import Foundation

class UserDefaultsManager: PersistenceManager {
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func save<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    func load<T>(_ type: T.Type, forKey key: String) -> T? {
        return defaults.object(forKey: key) as? T
    }
    
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
} 
