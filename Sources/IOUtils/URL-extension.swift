import Foundation

public extension URL {
    init?(withUnknownFormatOf filePath: String) {
        if filePath.hasPrefix("https://") || filePath.hasPrefix("http://") {
            return nil
        } else if filePath.hasPrefix("file://") {
            guard let tempURL = URL(string: filePath) else {
                return nil
            }
            self = tempURL
        } else if filePath.hasPrefix("/") {
            self = URL(fileURLWithPath: filePath)
        } else {
            self = URL(fileURLWithPath: FileManager().currentDirectoryPath).appendingPathComponent(filePath)
        }
    }

    var text: String? {
        get {
            do {
                return try String(contentsOf: self)
            } catch {
                return nil
            }
        }
    }
}
