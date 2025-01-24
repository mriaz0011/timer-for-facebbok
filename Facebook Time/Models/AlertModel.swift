import UIKit

// MARK: - Alert Configuration
struct AlertConfig {
    let title: String
    let message: String
    let actions: [AlertAction]
}

// MARK: - Alert Actions
enum AlertAction {
    case ok
    case cancel
    case custom(title: String, style: UIAlertAction.Style)
    
    var alertAction: UIAlertAction {
        switch self {
        case .ok:
            return UIAlertAction(title: "OK", style: .default)
        case .cancel:
            return UIAlertAction(title: "Cancel", style: .cancel)
        case .custom(let title, let style):
            return UIAlertAction(title: title, style: style)
        }
    }
}
