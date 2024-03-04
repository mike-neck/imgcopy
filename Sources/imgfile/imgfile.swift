import ArgumentParser

@main
struct ImgFile: ParsableCommand {

    static let binaryName: String = "imgwrite";

    @Argument(help: "The file path")
    var filePath: String

    mutating func run() throws {
        do {
            try ImgFile.execute(filePath)
        } catch let err as InvalidOptionsError {
            throw ValidationError(err.description)
        }
    }
}
