import ArgumentParser
import Foundation

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

protocol ImgViewCommand {
    func exec() throws
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
