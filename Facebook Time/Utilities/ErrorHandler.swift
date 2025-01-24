import UIKit

class ErrorHandler {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func updateViewController(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func handle(_ error: AppError) {
        logError(error.localizedDescription)
        
        let alertType: AlertType = switch error {
        case .timerError(let error):
            .timerError(error)
        case .webError(let error):
            .webError(error)
        case .dataError(let error):
            .error(error)
        case .shareError(let error):
            .error(error)
        case .unknown(let error):
            .error(error)
        }
        
        guard let viewController = viewController else { return }
        AlertManager.showAlert(alertType, on: viewController)
    }
    
    func handle(_ error: Error) {
        logError(error.localizedDescription)
        guard let viewController = viewController else { return }
        AlertManager.showAlert(.error(error), on: viewController)
    }
    
    private func logError(_ message: String) {
        // Add logging implementation here
        print("Error: \(message)")
    }
} 