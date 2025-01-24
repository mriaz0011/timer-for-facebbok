import Foundation

protocol ReportDataManagerDelegate: AnyObject {
    func reportDataDidUpdate(_ data: [DailyUsage])
}

class ReportDataManager {
    private(set) var weeklyUsage: [DailyUsage] = [] {
        didSet {
            delegate?.reportDataDidUpdate(weeklyUsage)
        }
    }
    
    private let persistenceManager: PersistenceManager
    private weak var delegate: ReportDataManagerDelegate?
    private let calendar = Calendar.current
    
    init(persistenceManager: PersistenceManager, delegate: ReportDataManagerDelegate?) {
        self.persistenceManager = persistenceManager
        self.delegate = delegate
        loadWeeklyData()
    }
    
    func logUsage(totalDuration: TimeInterval, remainingTime: TimeInterval) {
        let timeSpent = max(totalDuration - remainingTime, 0)
        let today = Date()
        
        // Check if we need to reset (new week started)
        if shouldResetWeeklyData(today) {
            weeklyUsage.removeAll()
        }
        
        let newUsage = DailyUsage(date: calendar.startOfDay(for: today), duration: timeSpent)
        
        if let index = weeklyUsage.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            weeklyUsage[index] = newUsage
        } else {
            weeklyUsage.append(newUsage)
        }
        
        saveWeeklyData()
        NotificationCenter.default.post(name: .usageStatsDidUpdate, object: nil)
    }
    
    private func shouldResetWeeklyData(_ today: Date) -> Bool {
        guard let oldestDate = weeklyUsage.map({ $0.date }).min() else {
            return false
        }
        
        // Get the start of the week for both dates
        let todayWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))
        let oldestWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: oldestDate))
        
        return todayWeekStart != oldestWeekStart
    }
    
    private func loadWeeklyData() {
        if let data = persistenceManager.load([[String: Any]].self, forKey: AppConfiguration.UserDefaultsKeys.weekUsageReport) {
            weeklyUsage = data.compactMap { dict in
                guard let timeInterval = dict["date"] as? TimeInterval,
                    let duration = dict["duration"] as? TimeInterval else {
                    return nil
                }
                let date = Date(timeIntervalSince1970: timeInterval)
                return DailyUsage(date: calendar.startOfDay(for: date), duration: duration)
            }
        }
    }
    
    private func saveWeeklyData() {
        let data = weeklyUsage.map { usage -> [String: Any] in
            return [
                "date": usage.date.timeIntervalSince1970,
                "duration": usage.duration
            ]
        }
        persistenceManager.save(data, forKey: AppConfiguration.UserDefaultsKeys.weekUsageReport)
    }
} 
