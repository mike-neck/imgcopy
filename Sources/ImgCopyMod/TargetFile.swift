import Foundation

public struct TargetFile {
    let name: String
    let content: FileContent

    public init?(from arguments: [String]) {
        if arguments.count != 2 {
            return nil
        }
        self.name = arguments[1]
        let mayHandle = FileHandle(forReadingAtPath: name)
        guard let handle = mayHandle else {
            return nil
        }
        defer {
            handle.closeFile()
        }
        guard let fileContent = FileContent(by: {
            handle.readDataToEndOfFile()
        }) else {
            return nil
        }
        self.content = fileContent
    }

    static private let availableExtension: [String] = ["jpg", "gif", "png"]

    public var canRead: Bool {
        get {
            content.canRead
        }
    }

    public func copyContent(to consumer: DataConsumer) -> Error? {
        let err = content.copy(to: consumer)
        if err != nil {
            return CannotCopyError("\(String(describing: err))[file: \(name)]")
        }
        return nil
    }
}

public enum FileContent {
    case png(Data)
    case tiff(Data)
    case another
    case jpg
    case gif

    public var canRead: Bool {
        get {
            switch self {
            case .another: return false
            default: return true
            }
        }
    }
}

public extension FileContent {
    init?(by dataFactory: () throws -> Data?) {
        do {
            let mayData: Data? = try dataFactory()
            guard let data = mayData else {
                return nil
            }
            switch data[0] {
            case 0x89:
                self = .png(data)
            case 0xFF: // jpg
                self = .jpg
            case 0x47: // gif
                self = .gif
            case 0x49, 0x4D:
                self = .tiff(data)
            default:
                self = .another
            }
        } catch {
            return nil
        }
    }

    func copy(to consumer: DataConsumer) -> Error? {
        switch self {
        case .png(_), .tiff(_):
            return consumer.accept(self)
        case .jpg, .gif:
            return CannotCopyError("\(self) not supported")
        case .another: return CannotCopyError("this type not supported")
        }
    }
}

extension FileContent: CustomStringConvertible {
    public var description: String {
        switch self {
        case .png(_):
            return "png"
        case .tiff(_):
            return "tiff"
        case .another:
            return "this file type"
        case .jpg:
            return "jpg"
        case .gif:
            return "gif"
        }
    }
}

public protocol DataConsumer {
    func accept(_ content: FileContent) -> Error?
}

struct CannotCopyError: Error, CustomStringConvertible {
    let description: String

    init() {
        self.description = "no contents to be copied"
    }

    init(_ description: String) {
        self.description = description
    }
}
