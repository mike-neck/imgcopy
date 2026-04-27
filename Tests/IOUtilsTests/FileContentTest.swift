import Foundation
import IOUtils
import XCTest

class FileContentTest: XCTestCase {

    struct TestCase {
        var source: () throws -> Data?
        var expected: FileContent?
    }

    struct MockError: Error {
        let message: String
    }

    func testInit() {
        let tests: [TestCase] = [
            TestCase(source: { Data([0x89]) }, expected: .png(Data())),
            TestCase(source: { Data([0xFF]) }, expected: .jpg),
            TestCase(source: { Data([0x47]) }, expected: .gif),
            TestCase(source: { Data([0x49, 0x4d]) }, expected: .tiff(Data())),
            TestCase(source: { Data([0xCA, 0xFE, 0xBA, 0xBE]) }, expected: .another),
            TestCase(source: { throw MockError(message: "error") }, expected: .cannotOpen(MockError(message:"error"))),
        ]
        
        for test in tests {
            let fc = FileContent(by: test.source)
            guard let expected = test.expected else {
                XCTAssertNil(fc)
                continue
            }
            XCTAssertEqual(expected, fc, "expected \(expected) but got \(fc, default: "nil")")
        }
    }
}

extension FileContent: Equatable {
    public static func == (lhs: FileContent, rhs: FileContent) -> Bool {
        switch (lhs, rhs) {
        case (.png, .png):
            return true
        case (.jpg, .jpg):
            return true
        case (.gif, .gif):
            return true
        case (.tiff, .tiff):
            return true
        case (.another, .another):
            return true
        case (.cannotOpen, .cannotOpen):
            return true
        default:
            return false
        }
    }
}
