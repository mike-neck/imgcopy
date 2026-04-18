//
//  File.swift
//  imgcopy
//
//  Created by mike on 2026/03/31.
//

import Foundation

public func showInTermial(_ data: Data, _ out: (String) -> Void = { print($0) }) throws {
    let base64Contents = data.base64EncodedString()
    var sb = ""
    sb.append(ShowInTerminal.esc)
    sb.append(ShowInTerminal.code)
    sb.append(ShowInTerminal.separator)
    sb.append(ShowInTerminal.inline(display: true))
    sb.append(ShowInTerminal.separator)
    sb.append(sizeOf: base64Contents)
    sb.append(image: base64Contents)
    sb.append(ShowInTerminal.endOfCode)
    let output = sb
    out(output)
}

struct ShowInTerminal {
    static let separator = ";"
    static let esc: String = "\u{001B}]"
    static let code: String = "1337"
    static let protocolName = "File"
    static let endOfCode: String = "\u{7}"
    static func inline(display: Bool) -> String {
        if (display) {
            return "\(protocolName)=inline=1"
        } else {
            return "\(protocolName)=inline=0"
        }
    }
    static func size(of: String) -> String {
        return "size=\(of.count)"
    }
}

extension String {
    mutating func append(sizeOf image: String) {
        self.append("size=")
        self.append(String(image.utf8.count))
    }

    mutating func append(image: String) {
        self.append(":")
        self.append(image)
    }
}
