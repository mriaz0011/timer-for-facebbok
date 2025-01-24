import Foundation

enum TimerState {
    case notSet
    case active(remainingTime: TimeInterval)
    case expired
    
    var isActive: Bool {
        switch self {
        case .active: return true
        default: return false
        }
    }
    
    var remainingTime: TimeInterval {
        switch self {
        case .active(let time): return time
        default: return 0
        }
    }
}

protocol TimerStateDelegate: AnyObject {
    func timerStateDidChange(_ state: TimerState)
} 