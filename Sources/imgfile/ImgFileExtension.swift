//
//  ImgFileCommand.swift
//  
//
//  Created by mike on 2024/03/02.
//

import Foundation
import Cocoa

@available(macOS 14, *)
extension ImgFile {

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

struct InvalidOptionsError: Error, CustomStringConvertible {
    var description: String
}

extension InvalidOptionsError {
    init(_ message: String) {
        self.description = message
    }
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
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
