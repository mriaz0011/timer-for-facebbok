import UIKit

protocol ThemeManagerDelegate: AnyObject {
    func themeDidChange(_ theme: Theme)
}

class ThemeManager {
    // MARK: - Singleton
    static let shared = ThemeManager()
    
    // MARK: - Properties
    private(set) var currentTheme: Theme = .primary
    
    // MARK: - Initialization
    private init() {}
}

// MARK: - Theme
enum Theme {
    case primary
    
    // MARK: - Brand Colors
    static let primaryOrange = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1) // #FF9500
    static let pureWhite = UIColor.white
    static let pureBlack = UIColor.black
    
    // MARK: - UI Colors
    var backgroundColor: UIColor {
        return AppConfiguration.UI.Colors.background
    }
    
    var textColor: UIColor {
        return AppConfiguration.UI.Colors.text
    }
    
    var navigationBarColor: UIColor {
        return AppConfiguration.UI.Colors.navigationBar
    }
    
    var timerBackgroundColor: UIColor {
        return AppConfiguration.UI.Colors.timerBackground
    }
    
    var buttonBackgroundColor: UIColor {
        return AppConfiguration.UI.Colors.buttonBackground
    }
    
    var buttonTintColor: UIColor {
        return AppConfiguration.UI.Colors.buttonTint
    }
    
    var separatorColor: UIColor {
        return AppConfiguration.UI.Colors.separator
    }
    
    var clockTextColor: UIColor {
        return AppConfiguration.UI.Colors.clockText
    }
    
    var timerTextColor: UIColor {
        return AppConfiguration.UI.Colors.timerText
    }
    
    var pickerBackgroundColor: UIColor {
        return AppConfiguration.UI.Colors.pickerBackground
    }
    
    var pickerTextColor: UIColor {
        return AppConfiguration.UI.Colors.pickerText
    }
    
    var webViewBackgroundColor: UIColor {
        return AppConfiguration.UI.Colors.webViewBackground
    }
}
