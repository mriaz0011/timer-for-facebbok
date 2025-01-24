import Foundation

class AnalyticsModel {
    private let userDefaults: UserDefaults
    private let calendar: Calendar
    
    init(userDefaults: UserDefaults = .standard, calendar: Calendar = .current) {
        self.userDefaults = userDefaults
        self.calendar = calendar
    }
    
    func trackEvent(_ event: AnalyticsEvent) {
        logInfo("Analytics event: \(event.name), parameters: \(event.parameters)")
        // Implementation for sending to analytics service
    }
    
    func recordDailyUsage(duration: TimeInterval) {
        let today = calendar.startOfDay(for: Date())
        var usageData = getDailyUsageData()
        usageData[today] = (usageData[today] ?? 0) + duration
        saveDailyUsageData(usageData)
    }
    
    private func getDailyUsageData() -> [Date: TimeInterval] {
        guard let data = userDefaults.dictionary(forKey: "daily_usage") as? [String: TimeInterval] else {
            return [:]
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return Dictionary(uniqueKeysWithValues: data.compactMap { key, value in
            guard let date = dateFormatter.date(from: key) else { return nil }
            return (date, value)
        })
    }
    
    private func saveDailyUsageData(_ data: [Date: TimeInterval]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let serializedData = Dictionary(uniqueKeysWithValues: data.map { date, duration in
            (dateFormatter.string(from: date), duration)
        })
        
        userDefaults.set(serializedData, forKey: "daily_usage")
    }
} 
