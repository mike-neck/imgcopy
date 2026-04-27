import ArgumentParser
import Foundation
import Cocoa
import ClipboardReaderMod
import IOUtils

@main
@available(macOS 13, *)
struct ImgView: ParsableCommand {

    @Option(help: "Specifies the mode to view the image, default: terminal. available values are 'window', 'terminal'.")
    var mode: ViewMode = .terminal

    @Argument(help: "Specifies the image path to view. If not specified, an image from clipboard will be shown.")
    var filePath: String?

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
        guard let dataSrc: DataSource = ImageSource(filePath) else {
            let source = switch filePath {
            case nil, "": "clipboard"
            default      : filePath
            }
            throw RuntimeError(description: "no image found at \(String(describing: source))")
        }
        let data = try tryCall(name: "load data") { try dataSrc.loadData() }
        let imageConsumer: ImageConsumer = mode
        try tryCall(name: "showing image") { try imageConsumer.show(image: data) }
    }
}

func tryCall<T>(name: String, _ operation: () throws -> T) throws -> T {
    do {
        return try operation()
    } catch {
        throw RuntimeError(description: "an error occured while performing \(name), error: \(error)")
    }
}

protocol DataSource {
    func loadData() throws -> Data
}

protocol ImageConsumer {
    func show(image data: Data) throws
}

@MainActor
enum ViewMode: String, EnumerableFlag, ExpressibleByArgument, @preconcurrency ImageConsumer {
    case terminal, window

    init(rawValue: String) throws {
        if rawValue == "window" {
            self = .window
        } else {
            self = .terminal
        }
    }

    @MainActor
    func show(image data: Data) throws {
        switch (self) {
        case .terminal:
            try showInTermial(data)
        case .window:
            try showInWindow(data)
        }
    }
}

@available(macOS 13, *)
extension ImgView {

    static var version: String {
        get {
            guard
                let text = String(bytes: PackageResources.version_txt, encoding: .utf8)
            else {
                return "unknown"
            }
            return text.replacingOccurrences(of: "\n", with: "")
        }
    }

}

public extension ImageSource {
    init?(_ source: String?) {
        #if DEBUG
            print("image source: source=\(String(describing: source))")
        #endif
        guard let path = source else {
            self = .clipboard
            return
        }
        if path == "" {
            self = .clipboard
        } else {
            guard let content = FileContent(of: path) else {
                return nil
            }
            self = .file(content: content)
        }
    }
}

public enum ImageSource: Equatable {
    case file(content: FileContent)
    case clipboard

}

extension FileContent: Equatable {
    static public func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.png(let leftData), .png(let rightData)):
            return leftData == rightData
        case (.tiff(let leftData), .tiff(let rightData)):
            return leftData == rightData
        case (.gif, .gif):
            return true
        case (.jpg, .jpg):
            return true
        case (.another, .another):
            return true
        case (.cannotOpen, .cannotOpen):
            return true
        default:
            return false
        }
    }
}

extension ImageSource: DataSource {
    func loadData() throws -> Data {
        switch self {
        case .file(let content):
            guard let data = try content.getData() else {
                throw RuntimeError(description: "failed to get data from image source")
            }
            return data
        case .clipboard:
            let clipboard = Clipboard.general
            guard let data = clipboard.data(forType: NSPasteboard.PasteboardType.png) else {
                throw RuntimeError(description: "failed to read a clipboard image as png")
            }
            return data
        }
    }
}
