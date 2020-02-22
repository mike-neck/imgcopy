import Cocoa
import ImgCopyMod

func printUsage() {
    print("imgcopy")
    print("    copies image file to clipboard.")
    print("")
    print("imgcopy <file>")
    print("")
}

let mayTargetFile = TargetFile(from: CommandLine.arguments)

guard let targetFile = mayTargetFile else {
    printUsage()
    exit(1)
}

let mayNotSupported = targetFile.descriptionIfNotSupported

if let desc: String = mayNotSupported {
    print(desc)
    exit(2)
}

if let err: Error = targetFile.copyContent(to: macOSClipboard) {
    print("error \(err)")
    exit(4)
}

exit(0)
