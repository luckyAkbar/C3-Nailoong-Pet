import Foundation

enum ScannedModelLibrary {

    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    static func modelURL(for fileName: String) -> URL {
        documentsDirectory.appendingPathComponent(fileName)
    }

    static func modelExists(_ fileName: String) -> Bool {
        FileManager.default.fileExists(atPath: modelURL(for: fileName).path)
    }

    static func delete(fileName: String) {
        let url = modelURL(for: fileName)
        try? FileManager.default.removeItem(at: url)

        guard fileName.hasPrefix("model-") else { return }
        let uuid = fileName
            .replacingOccurrences(of: "model-", with: "")
            .replacingOccurrences(of: ".usdz", with: "")
        let scanFolder = documentsDirectory.appendingPathComponent("Scans-\(uuid)", isDirectory: true)
        try? FileManager.default.removeItem(at: scanFolder)
    }
}
