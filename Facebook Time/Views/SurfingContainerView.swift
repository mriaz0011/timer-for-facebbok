import UIKit

class SurfingContainerView: UIView {
    // MARK: - Properties
    private var timerView: TimerView!
    private var webContentView: WebContentView!
    private var buttonsView: ButtonsView!
    private var timerPickerView: UIView!
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    // MARK: - View Management
    func addTimerView(_ view: TimerView) {
        timerView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.heightAnchor.constraint(equalToConstant: AppConfiguration.UI.topViewHeight)
        ])
    }
    
    func addButtonsView(_ view: ButtonsView) {
        buttonsView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.heightAnchor.constraint(equalToConstant: AppConfiguration.UI.bottomViewHeight)
        ])
    }
    
    func addWebContentView(_ view: WebContentView) {
        webContentView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        guard let topView = timerView, let bottomView = buttonsView else {
            fatalError("Timer view and buttons view must be added before web content view")
        }
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }
    
    func addTimerPickerView(_ view: UIView) {
        timerPickerView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: timerView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: buttonsView.topAnchor)
        ])
        
        view.isHidden = true
    }
    
    private func addSubviewWithConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Theme Support
    func applyTheme() {
        backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
    }
    
    func showTimerPicker(_ show: Bool) {
        timerPickerView.isHidden = !show
        if show {
            bringSubviewToFront(timerPickerView)
        }
    }
} 
