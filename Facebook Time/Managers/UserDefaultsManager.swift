import Foundation

class UserDefaultsManager: PersistenceManager {
    
    private let defaults = UserDefaults.standard
    
    func save<T>(_ value: T, forKey key: String) {
        print("DEBUG - Attempting to save for key: \(key)")
        print("DEBUG - Value type: \(type(of: value))")
        print("DEBUG - Raw value: \(value)")
        
        if let array = value as? [[String: Any]] {
            // Convert to proper format for UserDefaults
            let properArray = array.map { dict -> [String: Any] in
                var mutableDict = dict
                // Ensure all values are UserDefaults-compatible
                for (key, value) in dict {
                    if let date = value as? Date {
                        mutableDict[key] = date.timeIntervalSince1970
                    }
                }
                return mutableDict
            }
            defaults.set(properArray, forKey: key)
            print("DEBUG - Saved array: \(properArray)")
        } else {
            defaults.set(value, forKey: key)
        }
        
        defaults.synchronize()
        
        // Verify the save
        if let savedValue = defaults.array(forKey: key) {
            print("DEBUG - Verification - Value was saved: \(savedValue)")
        } else {
            print("DEBUG - Verification - Failed to save value!")
        }
    }
    
    func load<T>(_ type: T.Type, forKey key: String) -> T? {
        print("DEBUG - Loading for key: \(key)")
        if T.self == [[String: Any]].self {
            let array = defaults.array(forKey: key) as? [[String: Any]]
            print("DEBUG - Loaded array: \(String(describing: array))")
            return array as? T
        }
        let value = defaults.object(forKey: key)
        print("DEBUG - Loaded value: \(String(describing: value))")
        return value as? T
    }
    
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
} 
