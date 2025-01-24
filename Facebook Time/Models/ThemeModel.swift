import UIKit

enum ThemeType: String, Codable {
    case light
    case dark
    case system
}

struct ThemeColors {
    let primary: UIColor
    let secondary: UIColor
    let background: UIColor
    let text: UIColor
    let accent: UIColor
    let border: UIColor
    let error: UIColor
}

class ThemeModel {
    static let shared = ThemeModel()
    
    private(set) var currentTheme: ThemeType = .system {
        didSet {
            updateTheme()
        }
    }
    
    var colors: ThemeColors {
        switch currentTheme {
        case .light:
            return lightThemeColors
        case .dark:
            return darkThemeColors
        case .system:
            return UITraitCollection.current.userInterfaceStyle == .dark ? darkThemeColors : lightThemeColors
        }
    }
    
    private let lightThemeColors = ThemeColors(
        primary: UIColor(named: "PrimaryLight") ?? .orange,
        secondary: UIColor(named: "SecondaryLight") ?? .blue,
        background: UIColor(named: "BackgroundLight") ?? .white,
        text: UIColor(named: "TextLight") ?? .black,
        accent: UIColor(named: "AccentLight") ?? .orange,
        border: UIColor(named: "BorderLight") ?? .lightGray,
        error: UIColor(named: "ErrorLight") ?? .red
    )
    
    private let darkThemeColors = ThemeColors(
        primary: UIColor(named: "PrimaryDark") ?? .orange,
        secondary: UIColor(named: "SecondaryDark") ?? .blue,
        background: UIColor(named: "BackgroundDark") ?? .black,
        text: UIColor(named: "TextDark") ?? .white,
        accent: UIColor(named: "AccentDark") ?? .orange,
        border: UIColor(named: "BorderDark") ?? .darkGray,
        error: UIColor(named: "ErrorDark") ?? .red
    )
    
    func setTheme(_ type: ThemeType) {
        currentTheme = type
    }
    
    private func updateTheme() {
        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }
}
