import UIKit

protocol Themeable: AnyObject {
    func applyTheme()
}

class ThemeableView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupThemeNotification()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupThemeNotification()
    }
    
    private func setupThemeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: .themeDidChange,
            object: nil
        )
    }
    
    @objc private func themeDidChange() {
        (self as? Themeable)?.applyTheme()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
} 