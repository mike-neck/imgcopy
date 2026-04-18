import imgview
import XCTest

class ImageSourceTest: XCTestCase {

    struct TestInitTestCase {
        let source: String?
        let expected: ImageSource
        let msg: String
    }

    func testInit() {
        let tests: [TestInitTestCase] = [
            TestInitTestCase(
                    source: nil,
                    expected: .clipboard,
                    msg: "ImageSource with Nil source becomes .clipboard",
            ),
            TestInitTestCase(
                source: "",
                expected: .clipboard,
                msg: "ImageSource with EMPTY source becomes .clipboard",
            ),
            TestInitTestCase(
                source: "path.png",
                expected: .file(path: "path.png"),
                msg: "ImageSource with valid source becomes .file",
            ),
        ]
        for test in tests {
            let imageSource = ImageSource(test.source)
            XCTAssertEqual(imageSource, test.expected, test.msg)
        }
    }

    @MainActor
    static let allTests = [
        ("testInit", testInit)
    ]
}
