//
//  ImgFileCommand.swift
//  
//
//  Created by mike on 2024/03/02.
//

import Foundation
import Cocoa

extension ImgFile {
    static func execute(_ filePath: String) throws {
        if filePath.hasPrefix("https://") || filePath.hasPrefix("http://") {
            throw InvalidOptionsError("http/https protocol not supported")
        }

        let fileURL: URL
        if filePath.hasPrefix("file://") {
            guard let tempURL = URL(string: filePath) else {
                throw InvalidOptionsError("invalid file URL \(filePath)")
            }
            fileURL = tempURL
        } else if filePath.hasPrefix("/") {
            fileURL = URL(fileURLWithPath: filePath)
        } else {
            fileURL = URL(fileURLWithPath: FileManager().currentDirectoryPath).appendingPathComponent(filePath)
        }

        let clipboard = Clipboard.general
        guard let imageData = clipboard.data(AvailableExtensions.png) else {
            throw RuntimeError(description: "failed to read a clipboard image as png")
        }

        try imageData.write(to: fileURL, options: NSData.WritingOptions.atomic)
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
