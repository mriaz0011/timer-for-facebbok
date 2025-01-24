import UIKit

enum AlertType {
    case timeUp
    case timeSet
    case error(Error)
    case timerError(TimerError)
    case webError(WebError)
    case custom(title: String, message: String)
    
    var title: String {
        switch self {
        case .timeUp:
            return "Time's Up!"
        case .timeSet:
            return "Timer Already Set"
        case .error:
            return "Error"
        case .timerError:
            return "Timer Error"
        case .webError:
            return "Web Error"
        case .custom(let title, _):
            return title
        }
    }
    
    var message: String {
        switch self {
        case .timeUp:
            return "Your surfing time is up for today!"
        case .timeSet:
            return "You have already set a timer for today."
        case .error(let error):
            return error.localizedDescription
        case .timerError(let error):
            switch error {
            case .invalidDuration:
                return "Please select a valid duration."
            case .alreadyRunning:
                return "Timer is already running."
            case .notRunning:
                return "No timer is currently running."
            }
        case .webError(let error):
            switch error {
            case .loadingFailed(let underlyingError):
                return "Failed to load web content: \(underlyingError.localizedDescription)"
            case .invalidURL:
                return "Invalid URL provided"
            case .contentNotAvailable:
                return "Content is not available"
            }
        case .custom(_, let message):
            return message
        }
    }
}

class AlertManager {
    static func showAlert(_ type: AlertType, on viewController: UIViewController) {
        let alert = UIAlertController(
            title: type.title,
            message: type.message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
    
    static func showTimeUpAlert(on viewController: UIViewController) {
        showAlert(.timeUp, on: viewController)
    }
    
    static func showTimeAlreadySetAlert(on viewController: UIViewController) {
        showAlert(.timeSet, on: viewController)
    }
    
    static func showTimeSetAlert(on viewController: UIViewController) {
        showAlert(.timeSet, on: viewController)
    }
    
    static func showError(_ error: Error, on viewController: UIViewController) {
        showAlert(.error(error), on: viewController)
    }
    
    static func showTimerError(_ error: TimerError, on viewController: UIViewController) {
        showAlert(.timerError(error), on: viewController)
    }
    
    static func showWebError(_ error: WebError, on viewController: UIViewController) {
        showAlert(.webError(error), on: viewController)
    }
    
    static func showCustomAlert(title: String, message: String, on viewController: UIViewController) {
        showAlert(.custom(title: title, message: message), on: viewController)
    }
} 
