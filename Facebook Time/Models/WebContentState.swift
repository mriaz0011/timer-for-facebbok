import Foundation

enum WebContentState {
    case loading
    case loaded
    case error(Error)
    case timerNotSet
    case timerExpired
    
    var message: String {
        switch self {
        case .timerNotSet:
            return AppConfiguration.Web.setTimerMessage
        case .timerExpired:
            return AppConfiguration.Web.timeOverMessage
        default:
            return ""
        }
    }
}

protocol WebContentStateDelegate: AnyObject {
    func webContentStateDidChange(_ state: WebContentState)
} 