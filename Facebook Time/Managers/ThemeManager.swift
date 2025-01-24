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
        return .white
    }
    
    var textColor: UIColor {
        return .black
    }
    
    var navigationBarColor: UIColor {
        return Theme.primaryOrange
    }
    
    var timerBackgroundColor: UIColor {
        return Theme.primaryOrange
    }
    
    var buttonBackgroundColor: UIColor {
        return Theme.primaryOrange
    }
    
    var buttonTintColor: UIColor {
        return .white
    }
    
    var separatorColor: UIColor {
        return UIColor(white: 0.9, alpha: 1.0)
    }
    
    var clockTextColor: UIColor {
        return .white
    }
    
    var timerTextColor: UIColor {
        return .white
    }
    
    var pickerBackgroundColor: UIColor {
        return .white
    }
    
    var pickerTextColor: UIColor {
        return Theme.primaryOrange
    }
    
    var webViewBackgroundColor: UIColor {
        return .white
    }
}
