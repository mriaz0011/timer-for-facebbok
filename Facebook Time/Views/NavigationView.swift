import UIKit

protocol NavigationViewDelegate: AnyObject {
    func navigationViewDidTapBack()
    func navigationViewDidTapRefresh()
    func navigationViewDidTapShare()
    func navigationViewDidTapReport()
}

class NavigationView: ThemeableView {
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppConfiguration.UI.Colors.text
        label.font = UIFont.systemFont(ofSize: AppConfiguration.UI.defaultFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: NavigationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        applyTheme()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        applyTheme()
    }
    
    private func setupView() {
        backgroundColor = AppConfiguration.UI.Colors.navigationBar
        
        addSubview(timeLabel)
        addSubview(backButton)
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppConfiguration.UI.defaultPadding),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.alpha = hidden ? 0 : 1
            }
        } else {
            self.alpha = hidden ? 0 : 1
        }
    }
    
    func updateTime(_ timeString: String) {
        timeLabel.text = timeString
    }
    
    @objc private func backButtonTapped() {
        delegate?.navigationViewDidTapBack()
    }
}

extension NavigationView: Themeable {
    func applyTheme() {
        let theme = ThemeModel.shared.colors
        backgroundColor = theme.primary
        timeLabel.textColor = theme.text
        backButton.tintColor = theme.text
        
        // Update shadow and border colors if needed
        layer.shadowColor = theme.border.cgColor
        layer.borderColor = theme.border.cgColor
    }
} 
