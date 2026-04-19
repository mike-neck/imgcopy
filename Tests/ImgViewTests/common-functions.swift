import Foundation
import CryptoKit

func readImage(fromFile file: String) -> Data? {
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
    func hash(by alrorithm: HashAlgorithm) -> String {
        return alrorithm.getHash(of: self) ?? ""
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
