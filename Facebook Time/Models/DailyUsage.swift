import Foundation

struct DailyUsage {
    let date: Date
    let duration: TimeInterval
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
} 