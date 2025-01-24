import UIKit

class AlertFactory {
    static func createAlert(for type: AlertType) -> UIAlertController {
        let alert = UIAlertController(
            title: type.title,
            message: type.message,
            preferredStyle: .alert
        )
        
        // Add default OK action
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        return alert
    }
}
