import Cocoa
import ImgCopyMod

func printUsage() {
    print("imgcopy")
    print("    copies image file to clipboard.")
    print("")
    print("imgcopy <file>")
    print("")
}


let targetFile = TargetFile(from: CommandLine.arguments)

if targetFile == nil {
    printUsage()
    exit(1)
}


