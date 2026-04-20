//
//  AvailableExtensions.swift
//
//
//  Created by mike on 2024/03/02.
//

import Foundation
import ClipboardReaderMod
import Cocoa
import ImageIO
import UniformTypeIdentifiers

enum AvailableExtensions {
    case png
//    jpg/gif is not supported
    case jpg
//    case gif
}

@available(macOS 13, *)
extension AvailableExtensions {
    static private let valueMap: [String: AvailableExtensions] = [
        "png": .png,
        "jpeg": .jpg,
        "jpg": .jpg,
//        "gif": .gif,
    ]
    init(withDefaults string: String?) {
        guard let ext = string else {
            self = .png
            return
        }
        for (name, value) in AvailableExtensions.valueMap {
            if name.caseInsensitiveCompare(ext) == .orderedSame {
                self = value
                return
            }
        }
        self = .png
    }

    init?(from string: String) {
        for (name, value) in AvailableExtensions.valueMap {
            if name.caseInsensitiveCompare(string) == .orderedSame {
                self = value
                return
            }
        }
        return nil
    }

    var imgType: ImgType {
        get {
            return switch self {
            case .png: NSPasteboard.PasteboardType.png;
            case .jpg: NSPasteboard.PasteboardType("jpeg");
//            case .gif: NSPasteboard.PasteboardType("gif");
            }
        }
    }

    func convertFormat(_ data: Data) -> Data? {
        if self == .png {
            return data
        }
        guard
            let cgDataProvider = CGDataProvider(data: data as CFData),
            let cgImage = CGImage(
                    pngDataProviderSource: cgDataProvider,
                    decode: nil,
                    shouldInterpolate: false,
                    intent: .defaultIntent
            ),
            let cfMutableData = CFDataCreateMutable(kCFAllocatorDefault, 0),
            let cgImageDestination = CGImageDestinationCreateWithData(
                    cfMutableData,
                    UTType.jpeg.identifier as CFString,
                    1,
                    nil
            )
        else {
          return nil
        }
        CGImageDestinationAddImage(
                cgImageDestination,
                cgImage,
                [
                        kCGImageDestinationLossyCompressionQuality: 1.0 as CGFloat
                ] as CFDictionary
        )
        guard CGImageDestinationFinalize(cgImageDestination) else {
            return nil
        }
        return cfMutableData as Data
    }
}
