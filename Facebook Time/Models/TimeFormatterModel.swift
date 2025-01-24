import Foundation

class TimeFormatterModel {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    func formatCurrentTime() -> String {
        return dateFormatter.string(from: Date())
    }
    
    func formatTimeComponents(hours: Int, minutes: Int, seconds: Int) -> String {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
} 