//
//  AvailableExtensions.swift
//
//
//  Created by mike on 2024/03/02.
//

import Foundation
import Cocoa

enum AvailableExtensions {
    case png
//    jpg/gif is not supported
//    case jpg
//    case gif
}

typealias ImgType = NSPasteboard.PasteboardType

extension AvailableExtensions {
    static private var valueMap: [String: AvailableExtensions] = [
        "png": .png,
//        "jpeg": .jpg,
//        "jpg": .jpg,
//        "gif": .gif,
    ]
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
//            case .jpg: NSPasteboard.PasteboardType("jpeg");
//            case .gif: NSPasteboard.PasteboardType("gif");
            }
        }
    }
}
