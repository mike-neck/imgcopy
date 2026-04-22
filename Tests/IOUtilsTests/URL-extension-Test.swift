import Foundation
import IOUtils
import XCTest

class URLExtensionTest: XCTestCase {
    
    struct Test {
        let url: String
        let valid: Bool
    }

    func testInit() {
        let tests: [Test] = [
            Test(url: "image.png", valid: true),
            Test(url: "image.jpg", valid: true),
            Test(url: "image.tiff", valid: true),
            Test(url: "relative/path/to/image.png", valid: true),
            Test(url: "/absolute/path/to/image.png", valid: true),
            Test(url: "file://absolute/path/to/image.png", valid: true),
            Test(url: "http://example.com/absolute/path/to/image.png", valid: false),
        ]
        for test in tests {
            let url = URL(withUnknownFormatOf: test.url)
            XCTAssertEqual(url != nil, test.valid, "expected \(test.url) to be \(test.valid ? "valid": "invalid") but \(test.valid ? "got invalid": "got valid")")
        }
    }
}
