import CommonCrypto
import CryptoKit
import Foundation
import XCTest
import imgview

class ShowInTerminalTest: XCTestCase {
    
    struct TestCallTest {
        let filename: String
        let hashes: [HashAlgorithm: String]
    }
    
    func testCall() throws {
        let tests: [TestCallTest] = [
            TestCallTest(
                filename: "test-data/swift.png",
                hashes: [
                    .md5: "MD5 digest: 8633dee7365a5d7fa709da83660e3c98",
                    .sha1: "SHA1 digest: 616f3e675644371de258a94ebd37dbcd0c045299",
                    .sha256: "SHA256 digest: 27633a80413c35a616d67c5dc695f17347a6e8f7aa368c20a01e964265c3a8c1",
                ])
        ]
        for test in tests {
            guard let data = readImage(fromFile: test.filename) else {
                XCTFail("failed to read image file \(test.filename)")
                continue
            }
            for (algorithm, expected) in test.hashes {
                do {
                    try showInTermial(data) {
                        XCTAssertEqual($0.hash(by: algorithm), expected, "base64 value expected to be the same")
                    }
                } catch {
                    XCTFail("failed to show in terminal: \(error)")
                }
            }
        }
    }
}
