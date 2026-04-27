import Foundation

public enum FileContent: Sendable {
    case png(Data)
    case tiff(Data)
    case another
    case jpg
    case gif
    case cannotOpen(Error)
    
    public init?(of filepath: String) {
        self.init(by: { try openFileDataFactory(filepath) })
    }
    
    public init?(by dataFactory: () throws -> Data?) {
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
            self = .cannotOpen(error)
        }
    }

    public func getData() throws -> Data? {
        switch self {
        case .png(let data): return data
        case .tiff(let data): return data
        case .cannotOpen(let error): throw error
        default: return nil
        }
    }
}

fileprivate func openFileDataFactory(_ filepath: String) throws -> Data? {
    guard let handle = FileHandle(forReadingAtPath: filepath) else {
        throw RuntimeError(description: "failed to open file \(filepath)")
    }
    return handle.readDataToEndOfFile()
}
