import Foundation

protocol ReportDataManagerDelegate: AnyObject {
    func reportDataDidUpdate(_ data: [DailyUsage])
}

class ReportDataManager {
    private let persistenceManager: PersistenceManager
    private let calendar = Calendar.current
    private(set) var weeklyUsage: [DailyUsage] = []
    weak var delegate: ReportDataManagerDelegate?
    
    init(persistenceManager: PersistenceManager, delegate: ReportDataManagerDelegate?) {
        self.persistenceManager = persistenceManager
        self.delegate = delegate
        loadWeeklyData()
        print("DEBUG - Initial weeklyUsage after init: \(weeklyUsage)")
    }
    
    func logUsage(totalDuration: TimeInterval, remainingTime: TimeInterval) {
        print("DEBUG - ReportDataManager - logUsage START")
        print("DEBUG - Total duration received: \(totalDuration)")
        
        let today = Date()
        let todayStart = calendar.startOfDay(for: today)
        
        if let index = weeklyUsage.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            print("DEBUG - Found existing entry for today")
            print("DEBUG - Previous duration: \(weeklyUsage[index].duration)")
            weeklyUsage[index] = DailyUsage(date: todayStart, duration: totalDuration)
            print("DEBUG - Updated duration: \(totalDuration)")
        } else {
            print("DEBUG - Creating new entry for today")
            weeklyUsage.append(DailyUsage(date: todayStart, duration: totalDuration))
            print("DEBUG - New entry duration: \(totalDuration)")
        }
        
        print("DEBUG - About to save weeklyUsage: \(weeklyUsage)")
        saveWeeklyData()
        
        // Verify save
        loadWeeklyData()
        print("DEBUG - After save verification - weeklyUsage: \(weeklyUsage)")
        
        NotificationCenter.default.post(name: .usageStatsDidUpdate, object: nil)
    }
    
    private func loadWeeklyData() {
        print("DEBUG - loadWeeklyData START")
        if let data = persistenceManager.load([[String: Any]].self, forKey: AppConfiguration.UserDefaultsKeys.weekUsageReport) {
            print("DEBUG - Raw data loaded: \(data)")
            weeklyUsage = data.compactMap { dict in
                guard let timestamp = dict["date"] as? TimeInterval,
                      let duration = dict["duration"] as? TimeInterval else {
                    print("DEBUG - Failed to parse dict: \(dict)")
                    return nil
                }
                let date = Date(timeIntervalSince1970: timestamp)
                let usage = DailyUsage(date: calendar.startOfDay(for: date), duration: duration)
                print("DEBUG - Parsed usage: \(usage)")
                return usage
            }
            print("DEBUG - Final parsed weeklyUsage: \(weeklyUsage)")
        } else {
            print("DEBUG - No data found in UserDefaults")
            weeklyUsage = []
        }
    }
    
    public func saveWeeklyData() {
        print("DEBUG - saveWeeklyData START")
        let data = weeklyUsage.map { usage -> [String: Any] in
            let dict = [
                "date": usage.date.timeIntervalSince1970,
                "duration": usage.duration
            ]
            print("DEBUG - Converting usage to dict: \(dict)")
            return dict
        }
        print("DEBUG - Final data to save: \(data)")
        persistenceManager.save(data, forKey: AppConfiguration.UserDefaultsKeys.weekUsageReport)
    }
} 
