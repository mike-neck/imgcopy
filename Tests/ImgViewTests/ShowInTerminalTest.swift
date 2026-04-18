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

private func readImage(fromFile file: String) -> Data? {
    guard let handle = FileHandle(forReadingAtPath: file) else {
        return nil
    }
    defer {
        handle.closeFile()
    }
    do {
        return try handle.readToEnd()
    } catch {
        return nil
    }
}

extension String {
    fileprivate func hash(by alrorithm: HashAlgorithm) -> String {
        return alrorithm.getHash(of: self) ?? ""
    }

    fileprivate var hexDump: String {
        self.utf8.reduce("") { (acc: String, byte: UInt8) -> String in
            acc + String(format: "%02x", byte)
        }
    }
}

enum HashAlgorithm: Sendable {
    case md5, sha1, sha256

    func digest(of data: Data) -> any Digest {
        switch self {
        case .md5: return Insecure.MD5.hash(data: data)
        case .sha1: return Insecure.SHA1.hash(data: data)
        case .sha256: return SHA256.hash(data: data)
        }
    }

    func getHash(of text: String) -> String? {
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        let digest = digest(of: data)
        return digest.description
    }
}
