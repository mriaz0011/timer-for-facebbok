import Foundation

enum DataStoreError: Error {
    case saveError
    case loadError
    case deleteError
    case invalidData
}

protocol DataStorable: Codable {
    static var storageKey: String { get }
}

class DataStoreModel {
    private let fileManager: FileManager
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(
        fileManager: FileManager = .default,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.fileManager = fileManager
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func save<T: DataStorable>(_ item: T) throws {
        let data = try encoder.encode(item)
        let url = try fileURL(for: T.storageKey)
        try data.write(to: url)
    }
    
    func load<T: DataStorable>(_ type: T.Type) throws -> T {
        let url = try fileURL(for: T.storageKey)
        let data = try Data(contentsOf: url)
        return try decoder.decode(T.self, from: data)
    }
    
    func delete<T: DataStorable>(_ type: T.Type) throws {
        let url = try fileURL(for: T.storageKey)
        try fileManager.removeItem(at: url)
    }
    
    private func fileURL(for key: String) throws -> URL {
        try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("\(key).json")
    }
} 