import ArgumentParser

@main
@available(macOS 13, *)
struct ImgFile: ParsableCommand {

    static var imgFile: String = "imgfile"

    static var configuration: CommandConfiguration {
        get {
            let version = ImgFile.version
            return CommandConfiguration(
                commandName: imgFile,
                abstract: "Saves an image from clipboard to a file in given path.",
                usage: "\(imgFile) <file-path>",
                version: version
            )
        }
    }

    @Argument(help: "Specifies the path of the file to be saved. The image format (PNG or JPEG) to be saved is determined based on the file extension provided here.")
    var filePath: String

    mutating func run() throws {
        do {
            try ImgFile.execute(with: self)
        } catch let err as InvalidOptionsError {
            throw ValidationError(err.description)
        }
    }
}
