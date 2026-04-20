//
//  File.swift
//  
//
//  Created by mike on 2024/03/02.
//

import Foundation
import Cocoa

public typealias ImgType = NSPasteboard.PasteboardType

public enum Clipboard {
    case general
}

public extension Clipboard {
    func data(forType type: ImgType) -> Data? {
        let clipboard = NSPasteboard.general
        return clipboard.data(forType: type)
    }
}
