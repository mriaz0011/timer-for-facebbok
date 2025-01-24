import Foundation

enum AnalyticsEvent {
    case timerSet(duration: TimeInterval)
    case timerExpired
    case timerDurationSelected(duration: TimeInterval)
    case webpageLoaded(url: URL)
    case webContentLoaded
    case webContentLoadingFailed(Error)
    case shareAttempted
    case reportViewed
    case error(AppError)
    
    var name: String {
        switch self {
        case .timerSet: return "timer_set"
        case .timerExpired: return "timer_expired"
        case .timerDurationSelected: return "timer_duration_selected"
        case .webpageLoaded: return "webpage_loaded"
        case .webContentLoaded: return "web_content_loaded"
        case .webContentLoadingFailed: return "web_content_loading_failed"
        case .shareAttempted: return "share_attempted"
        case .reportViewed: return "report_viewed"
        case .error: return "error_occurred"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .timerSet(let duration):
            return ["duration": duration]
        case .timerDurationSelected(let duration):
            return ["duration": duration]
        case .timerExpired:
            return [:]
        case .webpageLoaded(let url):
            return ["url": url.absoluteString]
        case .webContentLoaded:
            return [:]
        case .webContentLoadingFailed(let error):
            return ["error": String(describing: error)]
        case .shareAttempted:
            return [:]
        case .reportViewed:
            return [:]
        case .error(let error):
            return ["error_type": String(describing: error)]
        }
    }
}
