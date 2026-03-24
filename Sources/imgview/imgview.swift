import ArgumentParser
import Foundation
import Cocoa

@main
@available(macOS 13, *)
struct ImgView: ParsableCommand {

    @Option(help: "Specifies the mode to view the image, default: terminal. available values are 'window', 'terminal'.")
    var mode: ViewMode = .terminal

    @Argument(help: "Specifies the image path to view. If not specified, an image from clipboard will be shown.")
    var filePath: String

    static var configuration: CommandConfiguration {
        get {
            let version = ImgView.version
            let commandName = "imgview"

            return CommandConfiguration(
                commandName: commandName,
                abstract: "Preview an image from filepath or clipboard.",
                usage: "\(commandName) [option] [<file-path>]",
                version: version
            )
        }
    }

    mutating func run() throws {

    }
}

protocol DataSource {
    func loadData() throws -> Data
}

protocol ImageConsumer {
    func show(image data: Data) throws
}

enum ViewMode: String, EnumerableFlag, ExpressibleByArgument {
    case terminal, window

    init(rawValue: String) throws {
        if rawValue == "window" {
            self = .window
        } else {
            self = .terminal
        }
    }
}

@available(macOS 13, *)
extension ImgView {

    static var version: String {
        get {
            guard
                let versionTextURL = Bundle.module.url(forResource: "version", withExtension: "txt"),
                let text = versionTextURL.text
            else {
                return "unknown"
            }
            return text.replacingOccurrences(of: "\n", with: "")
        }
    }

}

extension URL {
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

enum ImageSource {
    case file(path: String)
    case clipboard

}

typealias ImgType = NSPasteboard.PasteboardType

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
}

extension ImageSource: DataSource {
    func loadData() throws -> Data {
        switch self {
        case .file(let path):
            let imgFile = ImageFile(from: path)
            return try imgFile.loadData()
        case .clipboard:
            let clipboard = Clipboard.general
            guard let data = clipboard.data(forType: NSPasteboard.PasteboardType.png) else {
                throw RuntimeError(description: "failed to read a clipboard image as png")
            }
            return data
        }
    }
}

enum Clipboard {
    case general
}

extension Clipboard {
    func data(forType type: ImgType) -> Data? {
        let clipboard = NSPasteboard.general
        return clipboard.data(forType: type)
    }
}

struct ImageFile {
    let filepath: String

    init(from filepath: String) {
        self.filepath = filepath
    }

    func loadData() throws -> Data {
        guard let handle = FileHandle(forReadingAtPath: filepath) else {
            throw RuntimeError(description: "failed to read file \(filepath)")
        }
        defer {
            handle.closeFile()
        }
        let data = handle.readDataToEndOfFile()
        switch data[0] {
        case 0x89:
            return data
        case 0xFF: // jpg
            throw RuntimeError(description: "unsupported data type(jpeg)")
        case 0x47: // gif
            throw RuntimeError(description: "unsupported data type(gif)")
        case 0x49, 0x4D:
            return data
        default:
            throw RuntimeError(description: "unknow data type")
        }
    }
}
