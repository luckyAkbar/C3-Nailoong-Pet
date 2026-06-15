import Foundation
import RealityKit
import SwiftUI
import os
import Combine
import UIKit

enum AppCaptureState {
    case notStarted
    case capturing
    case reconstructing
    case completed
    case failed(Error)
}

@MainActor
final class LidarCaptureManager: ObservableObject {
    @Published var session: ObjectCaptureSession?
    @Published var state: AppCaptureState = .notStarted {
        didSet { stateID = UUID() }
    }
    @Published private(set) var stateID = UUID()
    @Published var reconstructionProgress: Float = 0.0

    @Published var isPaused: Bool = false
    @Published var numberOfShots: Int = 0
    @Published var latestThumbnail: UIImage? = nil

    private(set) var captureDir: URL
    private(set) var imagesDir: URL
    private(set) var snapshotsDir: URL
    private(set) var modelURL: URL

    private var photogrammetrySession: PhotogrammetrySession?
    private var sessionObservationTask: Task<Void, Never>?
    private let logger = Logger(subsystem: "com.NailongPet", category: "LidarCaptureManager")
    private var folderObserverTimer: Timer?

    private let supportedExtensions = ["heic", "heif", "jpg", "jpeg", "png"]

    init() {
        (captureDir, imagesDir, snapshotsDir, modelURL) = Self.makeScanURLs()
    }

    private static func makeScanURLs() -> (captureDir: URL, imagesDir: URL, snapshotsDir: URL, modelURL: URL) {
        let docDir = ScannedModelLibrary.documentsDirectory
        let uniqueID = UUID().uuidString
        let captureDir = docDir.appendingPathComponent("Scans-\(uniqueID)", isDirectory: true)
        return (
            captureDir,
            captureDir.appendingPathComponent("Images", isDirectory: true),
            captureDir.appendingPathComponent("Snapshots", isDirectory: true),
            docDir.appendingPathComponent("model-\(uniqueID).usdz")
        )
    }

    func startSession() {
        guard ObjectCaptureSession.isSupported else {
            state = .failed(Self.captureError("This device does not support Object Capture."))
            return
        }

        (captureDir, imagesDir, snapshotsDir, modelURL) = Self.makeScanURLs()

        do {
            try FileManager.default.createDirectory(at: imagesDir, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: snapshotsDir, withIntermediateDirectories: true)
            var configuration = ObjectCaptureSession.Configuration()
            configuration.checkpointDirectory = snapshotsDir

            let newSession = ObjectCaptureSession()
            session = newSession
            state = .capturing
            isPaused = false
            numberOfShots = 0
            latestThumbnail = nil
            reconstructionProgress = 0

            observeSessionStateUpdates(newSession)
            newSession.start(imagesDirectory: imagesDir, configuration: configuration)

            startObservingFolder()
        } catch {
            state = .failed(error)
        }
    }

    func pauseScanning() {
        guard let session else { return }
        session.pause()
        isPaused = true
        stopObservingFolder()
    }

    func resumeScanning() {
        guard let session else { return }
        session.resume()
        isPaused = false
        startObservingFolder()
    }

    func finishCaptureAndReconstruct() {
        stopObservingFolder()
        guard let session else { return }
        state = .reconstructing
        session.finish()
    }

    func reset() {
        stopObservingFolder()
        sessionObservationTask?.cancel()
        sessionObservationTask = nil
        session = nil
        photogrammetrySession = nil
        state = .notStarted
        isPaused = false
        numberOfShots = 0
        latestThumbnail = nil
        reconstructionProgress = 0
    }

    private func observeSessionStateUpdates(_ session: ObjectCaptureSession) {
        sessionObservationTask?.cancel()
        sessionObservationTask = Task { [weak self] in
            for await newState in session.stateUpdates {
                guard let self else { return }
                switch newState {
                case .completed:
                    self.session = nil
                    await self.reconstructModel()
                    return
                case .failed(let error):
                    self.logger.error("ObjectCaptureSession failed: \(error.localizedDescription)")
                    self.state = .failed(error)
                    self.session = nil
                    return
                default:
                    break
                }
            }
        }
    }

    private func startObservingFolder() {
        folderObserverTimer?.invalidate()
        folderObserverTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.updateFolderContents()
            }
        }
        updateFolderContents()
    }

    private func stopObservingFolder() {
        folderObserverTimer?.invalidate()
        folderObserverTimer = nil
    }

    private func updateFolderContents() {
        do {
            let files = try FileManager.default.contentsOfDirectory(
                at: imagesDir,
                includingPropertiesForKeys: [.creationDateKey],
                options: .skipsHiddenFiles
            )
            let imageFiles = files.filter { supportedExtensions.contains($0.pathExtension.lowercased()) }
            numberOfShots = imageFiles.count

            if let latestFile = imageFiles.sorted(by: {
                let date1 = (try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? .distantPast
                let date2 = (try? $1.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? .distantPast
                return date1 > date2
            }).first {
                if let data = try? Data(contentsOf: latestFile), let image = UIImage(data: data) {
                    latestThumbnail = image
                }
            }
        } catch {
            logger.error("Failed to read scan directory: \(error.localizedDescription)")
        }
    }

    private func reconstructModel() async {
        guard PhotogrammetrySession.isSupported else {
            state = .failed(Self.captureError("This device does not support on-device photogrammetry."))
            return
        }

        let imageCount = (try? FileManager.default.contentsOfDirectory(at: imagesDir, includingPropertiesForKeys: nil))?
            .filter { supportedExtensions.contains($0.pathExtension.lowercased()) }
            .count ?? 0

        guard imageCount >= 5 else {
            state = .failed(Self.captureError(
                "Too few photos (\(imageCount)). Capture more shots while moving around your pet."
            ))
            return
        }

        do {
            var configuration = PhotogrammetrySession.Configuration()
            configuration.sampleOrdering = .unordered
            configuration.featureSensitivity = .high
            configuration.ignoreBoundingBox = true

            let session = try PhotogrammetrySession(input: imagesDir, configuration: configuration)
            photogrammetrySession = session

            let request = PhotogrammetrySession.Request.modelFile(url: modelURL, detail: .reduced)
            try session.process(requests: [request])

            var requestError: Error?

            for try await output in session.outputs {
                switch output {
                case .processingComplete:
                    if let requestError {
                        logger.error("Reconstruction failed: \(requestError.localizedDescription)")
                        state = .failed(Self.friendlyError(from: requestError))
                    } else if FileManager.default.fileExists(atPath: modelURL.path) {
                        logger.log("USDZ model saved at: \(self.modelURL.path)")
                        state = .completed
                    } else {
                        state = .failed(Self.captureError(
                            "Reconstruction finished but produced no model. The photos could not be assembled — rescan a still object with even lighting."
                        ))
                    }
                case .requestError(_, let error):
                    requestError = error
                case .requestProgress(_, let fractionComplete):
                    reconstructionProgress = Float(fractionComplete)
                case .invalidSample(let id, let reason):
                    logger.error("Invalid sample \(id): \(reason)")
                case .processingCancelled:
                    state = .failed(Self.captureError("Reconstruction was cancelled."))
                default:
                    break
                }
            }
        } catch {
            logger.error("Failed to start photogrammetry session: \(error.localizedDescription)")
            state = .failed(Self.friendlyError(from: error))
        }
    }

    private static func captureError(_ message: String) -> NSError {
        NSError(domain: "LidarCaptureError", code: 3, userInfo: [NSLocalizedDescriptionKey: message])
    }

    private static func friendlyError(from error: Error) -> NSError {
        let tips = "Tip: scan a still object, use bright even lighting, prefer textured surfaces "
            + "(avoid plain or shiny objects), and circle the object 360° with many overlapping photos."
        return captureError("The photos could not be assembled into a 3D model. \(tips)")
    }

    deinit {
        folderObserverTimer?.invalidate()
        sessionObservationTask?.cancel()
    }
}
