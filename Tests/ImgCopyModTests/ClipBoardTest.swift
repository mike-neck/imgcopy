//
// Created by mike on 2020/02/22.
//

import Foundation
@testable import ImgCopyMod
import XCTest
import Cocoa

class ClipBoardTest: XCTestCase {

    static var allTests = [
        ("testAccept_AlwaysFalse", testAccept_AlwaysFalse),
        ("testAccept_AlwaysTrue", testAccept_AlwaysTrue),
        ("testAccept_PngDataSuccess", testAccept_PngDataSuccess),
        ("testAccept_PngDataFailure", testAccept_PngDataFailure),
    ]

    func testAccept_AlwaysFalse() {
        let clipBoard = ClipBoard(withMock: MockPersistence.alwaysFalse)

        let result: Error? = clipBoard.accept(FileContent.jpg)

        XCTAssertNotNil(result)
    }

    func testAccept_AlwaysTrue() {
        let clipBoard = ClipBoard(withMock: MockPersistence.alwaysTrue)

        let result: Error? = clipBoard.accept(FileContent.jpg)

        XCTAssertNil(result)
    }

    func testAccept_PngDataSuccess() {
        let data = Data(repeating: 0x89, count: 100)
        let clipBoard = ClipBoard(withMock: MockPersistence(withAssertingPasteItem: {
            let mayActual = $0.data(forType: NSPasteboard.PasteboardType.png)
            guard let actual = mayActual else {
                XCTFail("data not found")
                return
            }
            for index in 0..<data.count {
                XCTAssertEqual(data[index], actual[index])
            }
        }, withReturnValue: true))

        let result: Error? = clipBoard.accept(FileContent.png(data))

        XCTAssertNil(result)
    }

    func testAccept_PngDataFailure() {
        let data = Data(repeating: 0x89, count: 100)
        let clipBoard = ClipBoard(withMock: MockPersistence(withAssertingPasteItem: {
            let mayActual = $0.data(forType: NSPasteboard.PasteboardType.png)
            guard let actual = mayActual else {
                XCTFail("data not found")
                return
            }
            for index in 0..<data.count {
                XCTAssertEqual(data[index], actual[index])
            }
        }, withReturnValue: false))

        let result: Error? = clipBoard.accept(FileContent.png(data))

        XCTAssertNotNil(result)
    }
}

enum MockPersistence: ObjectPersistence {
    case alwaysFalse
    case alwaysTrue
    case assertingItem((NSPasteboardItem) -> Void, Bool)

    func persist(_ item: NSPasteboardItem) -> Bool {
        switch self {
        case .alwaysFalse:
            return false
        case .alwaysTrue:
            return true
        case .assertingItem(let assertion, let result):
            assertion(item)
            return result
        }
    }
}

extension MockPersistence {
    init(withAssertingPasteItem assertion: @escaping (NSPasteboardItem) -> Void, withReturnValue result: Bool) {
        self = .assertingItem(assertion, result)
    }
}
