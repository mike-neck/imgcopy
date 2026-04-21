//
//  ImgFileCommand.swift
//  
//
//  Created by mike on 2024/03/02.
//

import Foundation
import Cocoa
import ClipboardReaderMod
import IOUtils

@available(macOS 13, *)
extension ImgFile {

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

    static func execute(with imgFile: ImgFile) throws {
        try execute(imgFile.filePath)
    }

    static func execute(_ filePath: String) throws {
        guard let fileURL = URL(withUnknownFormatOf: filePath) else {
            if filePath.hasPrefix("https://") || filePath.hasPrefix("http://") {
                throw InvalidOptionsError("http/https protocol not supported")
            }
            throw InvalidOptionsError("invalid file URL \(filePath)")
        }

        let extItems = filePath.split(separator: ".")
        let outputFormat = AvailableExtensions(withDefaults: extItems.last?.lowercased())

        let clipboard = Clipboard.general
        guard let imageData = clipboard.data(forType: NSPasteboard.PasteboardType.png) else {
            throw RuntimeError(description: "failed to read a clipboard image as png")
        }

        guard let outputData = outputFormat.convertFormat(imageData) else {
            throw RuntimeError(description: "failed to convert format of image to \(outputFormat)")
        }

        try outputData.write(to: fileURL, options: NSData.WritingOptions.atomic)
    }
}

public struct InvalidOptionsError: Error, CustomStringConvertible {
    public let description: String

    public init(_ message: String) {
        self.description = message
    }
}
