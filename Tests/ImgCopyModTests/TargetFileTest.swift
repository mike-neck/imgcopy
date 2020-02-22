import ImgCopyMod
import XCTest

class TargetFileTest: XCTestCase {

    func testTargetNameInitializer() {
        let mayBeNull = TargetFile(from: ["test"])
        XCTAssertNil(mayBeNull)
        let swiftImg = TargetFile(from: ["test", "test-data/swift.png"])
        XCTAssertNotNil(swiftImg)
    }

    func testCanRead() {
        let becomesFalse: (TargetFile) -> Void = {
            XCTAssertFalse($0.canRead)
        }
        let becomesTrue: (TargetFile) -> Void = {
            XCTAssertTrue($0.canRead)
        }
        runCanRead(withFileName: "test-data/text.txt", becomesFalse)
        runCanRead(withFileName: "test-data/test-pdf-from-w3-org.pdf", becomesFalse)
        runCanRead(withFileName: "test-data/swift.png", becomesTrue)
    }

    private func runCanRead(withFileName name: String, _ assertion: (TargetFile) -> Void) {
        let mayTargetFile = TargetFile(from: ["test", name])
        guard let targetFile = mayTargetFile else {
            XCTFail("expected \(name) not to be nil, but it is nil.")
            return
        }
        assertion(targetFile)
    }

    static var allTests = [
        ("testTargetNameInitialization", testTargetNameInitializer),
        ("testCanRead", testCanRead)
    ]
}
