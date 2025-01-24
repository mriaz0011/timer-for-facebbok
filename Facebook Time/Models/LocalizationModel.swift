import Foundation

enum LocalizationKey: String {
    // Timer
    case timerSetButton = "timer.set"
    case timerResetButton = "timer.reset"
    case timerExpired = "timer.expired"
    case timerHours = "timer.hours"
    case timerMinutes = "timer.minutes"
    
    // Navigation
    case backButton = "navigation.back"
    case refreshButton = "navigation.refresh"
    case shareButton = "navigation.share"
    case reportButton = "navigation.report"
    
    // Alerts
    case errorTitle = "alert.error.title"
    case okButton = "alert.button.ok"
    case cancelButton = "alert.button.cancel"
    
    // Report
    case reportTitle = "report.title"
    case reportDailyUsage = "report.daily_usage"
    case reportWeeklyUsage = "report.weekly_usage"
}

class LocalizationModel {
    static let shared = LocalizationModel()
    private var currentLanguage: String
    
    private init() {
        self.currentLanguage = Locale.current.languageCode ?? "en"
    }
    
    func localized(_ key: LocalizationKey) -> String {
        return NSLocalizedString(key.rawValue, comment: "")
    }
    
    func localizedFormat(_ key: LocalizationKey, _ arguments: CVarArg...) -> String {
        let format = localized(key)
        return String(format: format, arguments: arguments)
    }
} 