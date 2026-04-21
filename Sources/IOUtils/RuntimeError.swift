import Foundation

public struct RuntimeError: Error, CustomStringConvertible {
    public let description: String

    public init(description: String) {
        self.description = description
    }
}
