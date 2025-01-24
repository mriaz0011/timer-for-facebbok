import UIKit

protocol WebContentControllerDelegate: AnyObject {
    func webContentControllerDidFinishLoading()
    func webContentControllerDidFailLoading(with error: Error)
}

class WebContentController: UIViewController {
    let webContentModel: WebContentModel
    let webContentView: WebContentView
    private var remainingTime: TimeInterval = 0
    private var totalTimeSpent: TimeInterval = 0
    
    weak var delegate: WebContentControllerDelegate?
    
    init(webContentModel: WebContentModel = WebContentModel()) {
        self.webContentModel = webContentModel
        self.webContentView = WebContentView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = webContentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webContentView.delegate = self
        
        // Load initial content immediately
        let content = webContentModel.getContent(for: .timerNotSet)
        webContentView.load(content)
    }
    
    func updateContent(timerActive: Bool, timerExpired: Bool) {
        let state: WebContentModel.ContentState
        
        if timerExpired {
            state = .timerExpired
        } else if !timerActive {
            state = .timerNotSet
        } else {
            state = .timerActive
        }
        
        let content = webContentModel.getContent(for: state)
        webContentView.load(content)
    }
    
    func reload() {
        webContentView.reload()
    }
    
    func goBack() {
        webContentView.goBack()
    }
    
    func loadHomePage() {
        let homeURL = webContentModel.getHomePageURL()
        let content = WebContent(type: .url, content: homeURL.absoluteString)
        webContentView.load(content)
    }
    
    func updateRemainingTime(_ time: TimeInterval, totalSpent: TimeInterval) {
        let wasInactive = remainingTime <= 0
        remainingTime = time
        totalTimeSpent = totalSpent
        
        // Update content when timer becomes active or expires
        if (wasInactive && remainingTime > 0) || (!wasInactive && remainingTime <= 0) {
            updateContentBasedOnTime()
        }
    }
    
    private func updateContentBasedOnTime() {
        let state: WebContentModel.ContentState
        
        if remainingTime <= 0 {
            state = .timerExpired  // Changed from .timerNotSet to .timerExpired
        } else if totalTimeSpent >= AppConfiguration.Timer.maxDailyTime {
            state = .timerExpired
        } else {
            state = .timerActive
        }
        
        let content = webContentModel.getContent(for: state)
        webContentView.load(content)
    }
    
    func updateContentBasedOnTimer(isActive: Bool, remainingTime: TimeInterval) {
        let state: WebContentModel.ContentState
        
        if !isActive {
            state = .timerNotSet
        } else if remainingTime <= 0 {
            state = .timerExpired  // Add handling for expired state
        } else {
            state = .timerActive
        }
        
        let content = webContentModel.getContent(for: state)
        webContentView.load(content)
    }
}

extension WebContentController: WebContentViewDelegate {
    func webContentViewDidStartLoading() {
        // Handle loading state if needed
    }
    
    func webContentViewDidFinishLoading() {
        delegate?.webContentControllerDidFinishLoading()
    }
    
    func webContentViewDidFailLoading(with error: Error) {
        delegate?.webContentControllerDidFailLoading(with: error)
    }
    
    func webContentViewCanGoBack() -> Bool {
        // If timer is expired or not set, don't allow back navigation
        if remainingTime <= 0 {
            return false
        }
        
        // Only allow back navigation when viewing web content (not HTML messages)
        switch webContentModel.getCurrentState() {
        case .timerActive:
            return webContentView.canGoBack
        case .timerExpired, .timerNotSet:
            return false
        }
    }
} 
