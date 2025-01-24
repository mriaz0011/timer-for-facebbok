import UIKit

enum AccessibilityIdentifier: String {
    case timerSetButton = "TimerSetButton"
    case timerLabel = "TimerLabel"
    case webView = "MainWebView"
    case backButton = "BackButton"
    case refreshButton = "RefreshButton"
    case shareButton = "ShareButton"
    case reportButton = "ReportButton"
}

enum AccessibilityLabel: String {
    case timerSetButton = "Set Timer"
    case timerLabel = "Remaining Time"
    case webView = "Facebook Content"
    case backButton = "Go Back"
    case refreshButton = "Refresh Page"
    case shareButton = "Share"
    case reportButton = "View Report"
}

class AccessibilityModel {
    static let shared = AccessibilityModel()
    
    func configure(_ view: UIView, withIdentifier identifier: AccessibilityIdentifier) {
        view.accessibilityIdentifier = identifier.rawValue
    }
    
    func configureForAccessibility(_ view: UIView, identifier: AccessibilityIdentifier, label: AccessibilityLabel) {
        view.isAccessibilityElement = true
        view.accessibilityIdentifier = identifier.rawValue
        view.accessibilityLabel = LocalizationModel.shared.localized(.init(rawValue: label.rawValue) ?? .timerSetButton)
    }
    
    func announceChange(_ message: String) {
        UIAccessibility.post(notification: .announcement, argument: message)
    }
} 