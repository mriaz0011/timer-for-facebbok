import UIKit

extension Date {
    func isNewDay(comparedTo date: Date) -> Bool {
        let calendar = Calendar.current
        return !calendar.isDate(self, inSameDayAs: date)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    static var today: Date {
        return Date().startOfDay
    }
    
    func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    var isToday: Bool {
        return isSameDay(as: Date())
    }
} 
