import ArgumentParser

@main
struct ImgFile: ParsableCommand {

    @Argument(help: "The file path")
    var filePath: String

    mutating func run() throws {
        do {
            try ImgFile.execute(with: self)
        } catch let err as InvalidOptionsError {
            throw ValidationError(err.description)
        }
    }
}
