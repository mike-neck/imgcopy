//
// Created by mike on 2020/02/22.
//

import Foundation
import Cocoa

let clipboard: DataConsumer = ClipBoard()

class ClipBoard: DataConsumer {

    let destination: ObjectPersistence

    init() {
        self.destination = NSPasteboard.general
    }

    init(withMock destination: ObjectPersistence) {
        self.destination = destination
    }

    func accept(_ content: FileContent) -> Error? {
        let item: NSPasteboardItem = content.newPasteboardItem()
        let success = destination.persist(item)
        if !success {
            return CannotCopyError("\(content) not supported")
        }
        return nil
    }
}

extension FileContent {
    func newPasteboardItem() -> NSPasteboardItem {
        switch self {
        case .png(let data):
            let item = NSPasteboardItem()
            item.setData(data, forType: NSPasteboard.PasteboardType.png)
            return item
        case .tiff(let data):
            let item = NSPasteboardItem()
            item.setData(data, forType: NSPasteboard.PasteboardType.tiff)
            return item
        default:
            return NSPasteboardItem()
        }
    }
}

protocol ObjectPersistence {
    func persist(_ item: NSPasteboardItem) -> Bool
}

extension NSPasteboard: ObjectPersistence {
    func persist(_ item: NSPasteboardItem) -> Bool {
        self.writeObjects([item])
    }
}
