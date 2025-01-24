import UIKit

protocol Coordinator: AnyObject {
    func start()
    func showReport()
    func showTimerPicker()
    func showShareSheet(items: [Any])
    func showAlert(_ alert: AlertType)
} 