import Foundation

struct UserSettings: DataStorable, Codable {
    static let storageKey = "user_settings"
    
    var theme: ThemeType
    var timerDuration: TimeInterval
    var notificationsEnabled: Bool
    
    enum CodingKeys: String, CodingKey {
        case theme
        case timerDuration
        case notificationsEnabled
    }
}

struct UsageStats: DataStorable {
    static let storageKey = "usage_stats"
    
    var dailyUsage: [Date: TimeInterval]
    var lastUsedDate: Date
    var totalUsageTime: TimeInterval
}

struct WebHistory: DataStorable {
    static let storageKey = "web_history"
    
    struct HistoryItem: Codable {
        let url: URL
        let timestamp: Date
        let timeSpent: TimeInterval
    }
    
    var items: [HistoryItem]
} 