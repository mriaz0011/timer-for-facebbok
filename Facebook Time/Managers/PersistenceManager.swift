import Foundation

protocol PersistenceManager {
    func save<T>(_ value: T, forKey key: String)
    func load<T>(_ type: T.Type, forKey key: String) -> T?
    func remove(forKey key: String)
}

extension UserDefaults: PersistenceManager {
    func save<T>(_ value: T, forKey key: String) {
        if let array = value as? [[String: Any]] {
            set(array, forKey: key)
        } else if let dict = value as? [String: Any] {
            set(dict, forKey: key)
        } else {
            set(value, forKey: key)
        }
        synchronize()
    }
    
    func load<T>(_ type: T.Type, forKey key: String) -> T? {
        let value = object(forKey: key)
        if T.self == [[String: Any]].self {
            return value as? T
        }
        return value as? T
    }
    
    func remove(forKey key: String) {
        removeObject(forKey: key)
        synchronize()
    }
}
