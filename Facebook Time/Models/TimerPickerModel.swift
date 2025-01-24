import Foundation

class TimerPickerModel {
    private let maxHours = 11
    private let maxMinutes = 59
    
    func getHoursArray() -> [Int] {
        return Array(0...maxHours)
    }
    
    func getMinutesArray() -> [Int] {
        return Array(0...maxMinutes)
    }
    
    func calculateDuration(hours: Int, minutes: Int) -> TimeInterval {
        return TimeInterval(hours * 3600 + minutes * 60)
    }
    
    func isValidSelection(hours: Int, minutes: Int) -> Bool {
        return hours <= maxHours && minutes <= maxMinutes && (hours > 0 || minutes > 0)
    }
} 
