//
//  SHARPModelRunner_iOS.swift
//  SHARP Model Inference — iOS / SwiftUI
//
//  Drop this file into your Xcode iOS project.
//  Add your .mlpackage to the bundle (drag into Xcode, tick "Add to target").
//  Add to Info.plist:
//    NSCameraUsageDescription      → "Used for AR placement"
//    NSPhotoLibraryUsageDescription → "Select a photo to reconstruct in 3D"

import SwiftUI
import PhotosUI
import CoreML
import CoreImage
import UIKit          // ← replaces AppKit
//import RealityKit
import Combine

// MARK: - Gaussians3D

struct Gaussians3D {
    let meanVectors:    MLMultiArray   // (1, N, 3) positions
    let singularValues: MLMultiArray   // (1, N, 3) scales
    let quaternions:    MLMultiArray   // (1, N, 4) rotations
    let colors:         MLMultiArray   // (1, N, 3) linear RGB
    let opacities:      MLMultiArray   // (1, N)    opacity

    var count: Int { meanVectors.shape[1].intValue }

    func computeImportanceScores() -> [Float] {
        let n = count
        var scores = [Float](repeating: 0, count: n)
        let scalePtr   = singularValues.dataPointer.assumingMemoryBound(to: Float.self)
        let opacityPtr = opacities.dataPointer.assumingMemoryBound(to: Float.self)
        for i in 0..<n {
            let s0 = scalePtr[i * 3 + 0]
            let s1 = scalePtr[i * 3 + 1]
            let s2 = scalePtr[i * 3 + 2]
            scores[i] = s0 * s1 * s2 * opacityPtr[i]
        }
        return scores
    }

    func decimationIndices(keepRatio: Float) -> [Int] {
        let keepCount = max(1, Int(Float(count) * keepRatio))
        var indexedScores = computeImportanceScores().enumerated().map { ($0.offset, $0.element) }
        indexedScores.sort { $0.1 > $1.1 }
        var keep = indexedScores.prefix(keepCount).map { $0.0 }
        keep.sort()
        return keep
    }
}

// MARK: - Color Utilities

func linearRGBToSRGB(_ v: Float) -> Float {
    v <= 0.0031308 ? v * 12.92 : 1.055 * pow(v, 1.0 / 2.4) - 0.055
}

func rgbToSphericalHarmonics(_ rgb: Float) -> Float {
    (rgb - 0.5) / sqrt(1.0 / (4.0 * Float.pi))
}

func inverseSigmoid(_ x: Float) -> Float {
    let c = min(max(x, 1e-6), 1.0 - 1e-6)
    return log(c / (1.0 - c))
}

// MARK: - SHARP Model Runner

class SHARPModelRunner {
    private let model: MLModel
    private let inputHeight: Int
    private let inputWidth:  Int

    private init(model: MLModel, inputHeight: Int = 1536, inputWidth: Int = 1536) {
        self.model       = model
        self.inputHeight = inputHeight
        self.inputWidth  = inputWidth

        print("Inputs:  \(model.modelDescription.inputDescriptionsByName.keys.joined(separator: ", "))")
        print("Outputs: \(model.modelDescription.outputDescriptionsByName.keys.joined(separator: ", "))")
    }

    static func loadModel(modelPath: URL, inputHeight: Int = 1536, inputWidth: Int = 1536) async throws -> SHARPModelRunner {
        let config = MLModelConfiguration()
        config.computeUnits = .cpuOnly

        let compiled = try await compileIfNeeded(at: modelPath)
        let model = try await MLModel.load(contentsOf: compiled, configuration: config)
        return SHARPModelRunner(model: model, inputHeight: inputHeight, inputWidth: inputWidth)
    }

    // MARK: Compile

    private static func compileIfNeeded(at modelPath: URL) async throws -> URL {
        let fm  = FileManager.default
        let ext = modelPath.pathExtension.lowercased()

        if ext == "mlmodelc" { return modelPath }

        guard ext == "mlpackage" || ext == "mlmodel" else {
            throw NSError(domain: "SHARP", code: 10,
                          userInfo: [NSLocalizedDescriptionKey: "Unsupported format: \(ext)"])
        }

        let cacheDir = fm.temporaryDirectory.appendingPathComponent("SHARPModelCache")
        try? fm.createDirectory(at: cacheDir, withIntermediateDirectories: true)

        let modelName    = modelPath.deletingPathExtension().lastPathComponent
        let compiledPath = cacheDir.appendingPathComponent("\(modelName).mlmodelc")

        if fm.fileExists(atPath: compiledPath.path) {
            let srcDate    = (try? fm.attributesOfItem(atPath: modelPath.path))?[.modificationDate] as? Date
            let cachedDate = (try? fm.attributesOfItem(atPath: compiledPath.path))?[.modificationDate] as? Date
            if let s = srcDate, let c = cachedDate, c >= s {
                print("Using cached compiled model.")
                return compiledPath
            }
            try? fm.removeItem(at: compiledPath)
        }

        print("Compiling model…")
        let t   = CFAbsoluteTimeGetCurrent()
        let tmp = try await Task.detached(priority: .userInitiated) {
            try MLModel.compileModel(at: modelPath)
        }.value
        print("✓ Compiled in \(String(format: "%.1f", CFAbsoluteTimeGetCurrent() - t))s")

        try? fm.removeItem(at: compiledPath)
        try  fm.moveItem(at: tmp, to: compiledPath)
        return compiledPath
    }

    // MARK: Preprocess — UIImage instead of NSImage

    /// Accepts a UIImage picked from PhotosPicker or the camera roll.
    func preprocessImage(from uiImage: UIImage) throws -> MLMultiArray {
        guard let cgImage = uiImage.cgImage else {
            throw NSError(domain: "SHARP", code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to get CGImage from UIImage"])
        }

        // Resize via CIImage (same pipeline as the original script)
        let ciImage  = CIImage(cgImage: cgImage)
        let context  = CIContext()
        let scaleX   = CGFloat(inputWidth)  / ciImage.extent.width
        let scaleY   = CGFloat(inputHeight) / ciImage.extent.height
        let scaled   = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        guard let resized = context.createCGImage(scaled,
                                                   from: CGRect(x: 0, y: 0,
                                                                width: inputWidth,
                                                                height: inputHeight)) else {
            throw NSError(domain: "SHARP", code: 3,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to resize image"])
        }

        // (1, 3, H, W) float32 array
        let imageArray = try MLMultiArray(
            shape: [1, 3,
                    NSNumber(value: inputHeight),
                    NSNumber(value: inputWidth)],
            dataType: .float32)

        let bytesPerPixel = 4
        let bytesPerRow   = bytesPerPixel * inputWidth
        var pixelData     = [UInt8](repeating: 0, count: inputHeight * bytesPerRow)

        let cs = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(data:             &pixelData,
                                  width:            inputWidth,
                                  height:           inputHeight,
                                  bitsPerComponent: 8,
                                  bytesPerRow:      bytesPerRow,
                                  space:            cs,
                                  bitmapInfo:       CGImageAlphaInfo.premultipliedLast.rawValue) else {
            throw NSError(domain: "SHARP", code: 4,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to create bitmap context"])
        }
        ctx.draw(resized, in: CGRect(x: 0, y: 0, width: inputWidth, height: inputHeight))

        let ptr           = imageArray.dataPointer.assumingMemoryBound(to: Float.self)
        let channelStride = inputHeight * inputWidth

        for y in 0..<inputHeight {
            for x in 0..<inputWidth {
                let pi = y * bytesPerRow + x * bytesPerPixel
                let si = y * inputWidth  + x
                ptr[0 * channelStride + si] = Float(pixelData[pi])     / 255.0
                ptr[1 * channelStride + si] = Float(pixelData[pi + 1]) / 255.0
                ptr[2 * channelStride + si] = Float(pixelData[pi + 2]) / 255.0
            }
        }

        return imageArray
    }

    // MARK: Predict

    func predict(image: MLMultiArray, focalLengthPx: Float) throws -> Gaussians3D {
        let disparityFactor  = focalLengthPx / Float(inputWidth)
        let disparityArray   = try MLMultiArray(shape: [1], dataType: .float32)
        disparityArray[0]    = NSNumber(value: disparityFactor)

        let inputFeatures = try MLDictionaryFeatureProvider(dictionary: [
            "image":            MLFeatureValue(multiArray: image),
            "disparity_factor": MLFeatureValue(multiArray: disparityArray)
        ])

        let output      = try model.prediction(from: inputFeatures)
        let outputNames = Array(model.modelDescription.outputDescriptionsByName.keys)

        func find(_ keywords: [String]) -> MLMultiArray? {
            for name in outputNames {
                let lower = name.lowercased()
                if keywords.contains(where: { lower.contains($0.lowercased()) }) {
                    return output.featureValue(for: name)?.multiArrayValue
                }
            }
            return nil
        }

        let meanVectors    = output.featureValue(for: "mean_vectors_3d_positions")?.multiArrayValue    ?? find(["mean",     "position", "xyz"])
        let singularValues = output.featureValue(for: "singular_values_scales")?.multiArrayValue      ?? find(["singular", "scale"])
        let quaternions    = output.featureValue(for: "quaternions_rotations")?.multiArrayValue       ?? find(["quaternion","rotation", "rot"])
        let colors         = output.featureValue(for: "colors_rgb_linear")?.multiArrayValue           ?? find(["color",    "rgb"])
        let opacities      = output.featureValue(for: "opacities_alpha_channel")?.multiArrayValue     ?? find(["opacity",  "alpha"])

        // Fallback: use sorted output order if name matching fails
        if meanVectors == nil || singularValues == nil || quaternions == nil || colors == nil || opacities == nil {
            let sorted = outputNames.sorted()
            guard sorted.count >= 5,
                  let mv = output.featureValue(for: sorted[0])?.multiArrayValue,
                  let sv = output.featureValue(for: sorted[1])?.multiArrayValue,
                  let q  = output.featureValue(for: sorted[2])?.multiArrayValue,
                  let c  = output.featureValue(for: sorted[3])?.multiArrayValue,
                  let o  = output.featureValue(for: sorted[4])?.multiArrayValue else {
                throw NSError(domain: "SHARP", code: 5,
                               userInfo: [NSLocalizedDescriptionKey: "Cannot extract outputs. Available: \(outputNames)"])
            }
            print("Using outputs by sorted order: \(sorted)")
            return Gaussians3D(meanVectors: mv, singularValues: sv, quaternions: q, colors: c, opacities: o)
        }

        return Gaussians3D(meanVectors: meanVectors!,
                           singularValues: singularValues!,
                           quaternions: quaternions!,
                           colors: colors!,
                           opacities: opacities!)
    }
}

// MARK: - Save as USDZ (iOS-compatible, no export() needed)

func saveUSDZ(gaussians: Gaussians3D,
              to outputPath: URL,
              decimation: Float = 1.0) throws {

    let keepIndices = decimation < 1.0
        ? gaussians.decimationIndices(keepRatio: decimation)
        : Array(0..<gaussians.count)

    let n = keepIndices.count

    // Metal limits texture width to 32768. Use a ~square layout so texWidth stays well within limits.
    let texWidth  = min(max(1, Int(ceil(sqrt(Double(n))))), 8192)
    let texHeight = n == 0 ? 1 : (n + texWidth - 1) / texWidth

    let meanPtr     = gaussians.meanVectors.dataPointer.assumingMemoryBound(to: Float.self)
    let colorPtr    = gaussians.colors.dataPointer.assumingMemoryBound(to: Float.self)

    let s: Float    = 0.003
    var points:      [String] = []
    var faceIndices: [String] = []
    var uvCoords:    [String] = []
    var texPixels:   [UInt8]  = []

    for (splatIdx, i) in keepIndices.enumerated() {
        let x = meanPtr[i * 3 + 0]
        let y = -meanPtr[i * 3 + 1] * 0.5
        let z = -meanPtr[i * 3 + 2] * 2.0

        let r = linearRGBToSRGB(colorPtr[i * 3 + 0])
        let g = linearRGBToSRGB(colorPtr[i * 3 + 1])
        let b = linearRGBToSRGB(colorPtr[i * 3 + 2])
        texPixels += [
            UInt8(max(0, min(255, r * 255))),
            UInt8(max(0, min(255, g * 255))),
            UInt8(max(0, min(255, b * 255))),
            255
        ]

        let texX = splatIdx % texWidth
        let texY = splatIdx / texWidth
        let u    = (Float(texX) + 0.5) / Float(texWidth)
        let v    = (Float(texY) + 0.5) / Float(texHeight)
        let uv   = "(\(u), \(v))"

        let base = splatIdx * 4
        points += [
            "(\(x-s), \(y+s), \(z))",
            "(\(x+s), \(y+s), \(z))",
            "(\(x+s), \(y-s), \(z))",
            "(\(x-s), \(y-s), \(z))",
        ]
        uvCoords    += [uv, uv, uv, uv]
        faceIndices += [
            "\(base)", "\(base+1)", "\(base+2)",
            "\(base)", "\(base+2)", "\(base+3)"
        ]
    }

    let totalTexPixels = texWidth * texHeight
    if totalTexPixels > n {
        texPixels += [UInt8](repeating: 0, count: (totalTexPixels - n) * 4)
    }
    let texturePNG = try makePNG(rgbaPixels: texPixels, width: texWidth, height: texHeight)

    let usda = """
    #usda 1.0
    (
        defaultPrim = "Root"
        upAxis = "Y"
    )

    def Xform "Root"
    {
        def Mesh "Gaussians"
        {
            bool doubleSided = true
            point3f[] points = [\(points.joined(separator: ", "))]
            int[] faceVertexCounts = [\(Array(repeating: "3", count: n * 2).joined(separator: ", "))]
            int[] faceVertexIndices = [\(faceIndices.joined(separator: ", "))]
            float2[] primvars:st = [\(uvCoords.joined(separator: ", "))] (
                interpolation = "vertex"
            )
            rel material:binding = </Root/Mat>
        }

        def Material "Mat"
        {
            token outputs:surface.connect = </Root/Mat/Shader.outputs:surface>

            def Shader "Shader"
            {
                uniform token info:id = "UsdPreviewSurface"
                color3f inputs:diffuseColor.connect = </Root/Mat/Tex.outputs:rgb>
                token outputs:surface
            }

            def Shader "Tex"
            {
                uniform token info:id = "UsdUVTexture"
                asset inputs:file = @texture.png@
                float2 inputs:st.connect = </Root/Mat/TexReader.outputs:result>
                token outputs:rgb
            }

            def Shader "TexReader"
            {
                uniform token info:id = "UsdPrimvarReader_float2"
                token inputs:varname = "st"
                float2 outputs:result
            }
        }
    }
    """

    let usdaData = usda.data(using: .utf8)!
    let usdz     = makeZip(files: [("scene.usda", usdaData), ("texture.png", texturePNG)])
    try usdz.write(to: outputPath)
    print("✓ Saved USDZ (\(n) splats, RealityKit-compatible)")
}

private func makePNG(rgbaPixels: [UInt8], width: Int, height: Int) throws -> Data {
    var pixels = rgbaPixels
    return try pixels.withUnsafeMutableBytes { rawBuffer in
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: rawBuffer.baseAddress,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ), let cgImage = context.makeImage() else {
            throw NSError(domain: "SHARP", code: 20,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to create texture image"])
        }
        guard let pngData = UIImage(cgImage: cgImage).pngData() else {
            throw NSError(domain: "SHARP", code: 21,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to encode texture PNG"])
        }
        return pngData
    }
}

// USDZ-compliant ZIP: each file's content must start at a 64-byte aligned offset
private func makeZip(files: [(name: String, data: Data)]) -> Data {
    var zip = Data()
    struct Entry { let localOffset: UInt32; let name: Data; let size: UInt32; let crc: UInt32 }
    var entries: [Entry] = []

    func u16(_ v: UInt16) -> Data { withUnsafeBytes(of: v.littleEndian) { Data($0) } }
    func u32(_ v: UInt32) -> Data { withUnsafeBytes(of: v.littleEndian) { Data($0) } }

    for (name, fileData) in files {
        let nameData  = name.data(using: .utf8)!
        let fileCRC   = crc32(fileData)
        let fileSize  = UInt32(fileData.count)
        let nameLen   = Int(nameData.count)

        // Pad extra field so content starts at a multiple of 64 bytes
        let fixedLen  = 30 + nameLen
        let pos       = zip.count + fixedLen
        let remainder = pos % 64
        let extraLen  = remainder == 0 ? 0 : 64 - remainder

        entries.append(Entry(localOffset: UInt32(zip.count), name: nameData,
                             size: fileSize, crc: fileCRC))

        var header = Data()
        header += u32(0x04034b50)
        header += u16(20)
        header += u16(0)
        header += u16(0)
        header += u16(0)
        header += u16(0)
        header += u32(fileCRC)
        header += u32(fileSize)
        header += u32(fileSize)
        header += u16(UInt16(nameLen))
        header += u16(UInt16(extraLen))
        header += nameData
        header += Data(repeating: 0, count: extraLen)

        zip += header
        zip += fileData
    }

    let centralStart = UInt32(zip.count)
    var centralSize  = 0
    for e in entries {
        var rec = Data()
        rec += u32(0x02014b50)
        rec += u16(20)
        rec += u16(20)
        rec += u16(0)
        rec += u16(0)
        rec += u16(0)
        rec += u16(0)
        rec += u32(e.crc)
        rec += u32(e.size)
        rec += u32(e.size)
        rec += u16(UInt16(e.name.count))
        rec += u16(0)
        rec += u16(0)
        rec += u16(0)
        rec += u16(0)
        rec += u32(0)
        rec += u32(e.localOffset)
        rec += e.name
        zip += rec
        centralSize += rec.count
    }

    var eocd = Data()
    eocd += u32(0x06054b50)
    eocd += u16(0)
    eocd += u16(0)
    eocd += u16(UInt16(files.count))
    eocd += u16(UInt16(files.count))
    eocd += u32(UInt32(centralSize))
    eocd += u32(centralStart)
    eocd += u16(0)
    zip += eocd

    return zip
}

// CRC-32 for ZIP
private func crc32(_ data: Data) -> UInt32 {
    var table = [UInt32](repeating: 0, count: 256)
    for i in 0..<256 {
        var c = UInt32(i)
        for _ in 0..<8 { c = (c & 1) != 0 ? 0xEDB88320 ^ (c >> 1) : c >> 1 }
        table[i] = c
    }
    var crc: UInt32 = 0xFFFFFFFF
    for byte in data { crc = table[Int((crc ^ UInt32(byte)) & 0xFF)] ^ (crc >> 8) }
    return crc ^ 0xFFFFFFFF
}

// MARK: - ViewModel

enum SHARPState: Equatable {
    case notStarted
    case processing(progress: Float, phase: String)
    case completed(usdzURL: URL)
    case failed(String)
}

@MainActor
class SHARPViewModel: ObservableObject {
    @Published var state: SHARPState = .notStarted
    @Published var selectedImage: UIImage? = nil
    @Published var errorMessage: String? = nil

    private var runner: SHARPModelRunner?
    private var progressTimer: Task<Void, Never>?

    init() {
        if let url = Bundle.main.url(forResource: "sharp", withExtension: "mlmodelc") {
            print("✅ Found model at: \(url.path)")
        } else {
            print("❌ sharp.mlpackage NOT found in bundle")
            // Also print everything in the bundle to help diagnose
            if let resourcePath = Bundle.main.resourcePath {
                let files = (try? FileManager.default.contentsOfDirectory(atPath: resourcePath)) ?? []
                print("Bundle contents:")
                files.forEach { print("  - \($0)") }
            }
        }

        // Load the model once at startup so the first inference is fast
        Task {
            do {
                guard let modelURL = Bundle.main.url(forResource: "sharp",
                                                      withExtension: "mlmodelc") else {
                    self.errorMessage = "sharp.mlpackage not found in bundle."
                    return
                }
                let r = try await SHARPModelRunner.loadModel(modelPath: modelURL)
                self.runner = r
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func reset() {
        progressTimer?.cancel()
        progressTimer = nil
        state = .notStarted
        selectedImage = nil
        errorMessage = nil
    }

    private func startSmoothProgress(from start: Float, to end: Float, duration: Double) {
        progressTimer?.cancel()
        progressTimer = Task {
            let steps = 20
            let stepDuration = duration / Double(steps)
            let stepAmount = (end - start) / Float(steps)
            var currentProgress = start
            for _ in 0..<steps {
                if Task.isCancelled { break }
                try? await Task.sleep(nanoseconds: UInt64(stepDuration * 1_000_000_000))
                currentProgress += stepAmount
                if case .processing(_, let phase) = self.state {
                    self.state = .processing(progress: currentProgress, phase: phase)
                }
            }
        }
    }

    func process(uiImage: UIImage) async {
        state = .processing(progress: 0.0, phase: "Preparing image...")
        errorMessage = nil

        do {
            guard let r = runner else {
                throw NSError(domain: "SHARP", code: 98,
                              userInfo: [NSLocalizedDescriptionKey: "Model not ready yet — try again"])
            }

            // Step 1: Preprocessing
            state = .processing(progress: 0.0, phase: "Preprocessing image...")
            startSmoothProgress(from: 0.0, to: 0.2, duration: 0.5)
            let imageArray = try r.preprocessImage(from: uiImage)
            progressTimer?.cancel()

            // Step 2: CoreML Prediction
            state = .processing(progress: 0.2, phase: "Running 3D model reconstruction...")
            startSmoothProgress(from: 0.2, to: 0.7, duration: 3.0)
            let gaussians = try await Task.detached(priority: .userInitiated) {
                try r.predict(image: imageArray, focalLengthPx: 1536)
            }.value
            progressTimer?.cancel()

            // Step 3: Generating USDZ
            state = .processing(progress: 0.7, phase: "Generating 3D model (USDZ)...")
            startSmoothProgress(from: 0.7, to: 0.95, duration: 2.0)
            
            let uniqueID = UUID().uuidString
            let fileName = "model-\(uniqueID).usdz"
            let outURL = ScannedModelLibrary.modelURL(for: fileName)
            
            try await Task.detached(priority: .userInitiated) {
                try saveUSDZ(gaussians: gaussians, to: outURL, decimation: 0.01)
            }.value
            progressTimer?.cancel()

            state = .completed(usdzURL: outURL)
        } catch {
            errorMessage = error.localizedDescription
            state = .failed(error.localizedDescription)
        }
    }
}

// MARK: - AR View (UIViewRepresentable)



// MARK: - Content View


// MARK: - AR Scene (full-screen)



// MARK: - App Entry Point
//
//@main
//struct SHARPApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
