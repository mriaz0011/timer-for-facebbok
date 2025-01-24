import Foundation

class DataManager {
    private let dataStore: DataStoreModel
    private let cacheManager: CacheManager
    
    init(
        dataStore: DataStoreModel = DataStoreModel(),
        cacheManager: CacheManager = CacheManager()
    ) {
        self.dataStore = dataStore
        self.cacheManager = cacheManager
    }
    
    // Settings Management
    func saveSettings(_ settings: UserSettings) {
        try? dataStore.save(settings)
    }
    
    func loadSettings() -> UserSettings? {
        try? dataStore.load(UserSettings.self)
    }
    
    // Usage Stats Management
    func saveUsageStats(_ stats: UsageStats) {
        try? dataStore.save(stats)
    }
    
    func loadUsageStats() -> UsageStats? {
        try? dataStore.load(UsageStats.self)
    }
    
    // Web History Management
    func saveWebHistory(_ history: WebHistory) {
        try? dataStore.save(history)
    }
    
    func loadWebHistory() -> WebHistory? {
        try? dataStore.load(WebHistory.self)
    }
    
    // Cache Management
    func cacheWebContent(_ content: String, forURL url: URL) {
        cacheManager.cache(content as NSString, forKey: url.absoluteString)
    }
    
    func cachedWebContent(forURL url: URL) -> String? {
        cacheManager.object(forKey: url.absoluteString) as? String
    }
    
    func clearCache() {
        cacheManager.clearCache()
    }
} 