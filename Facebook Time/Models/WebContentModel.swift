import UIKit

protocol WebContentModelDelegate: AnyObject {
    var isTimerExpired: Bool { get }
    var isTimerActive: Bool { get }
}

class WebContentModel {
    private let baseURL = AppConfiguration.Web.facebookURL
    weak var delegate: WebContentModelDelegate?
    
    enum ContentState {
        case timerNotSet
        case timerActive
        case timerExpired
    }
    
    func getContent(for state: ContentState) -> WebContent {
        switch state {
        case .timerNotSet:
            return WebContent(
                type: .html,
                content: AppConfiguration.Web.setTimerMessage
            )
        case .timerActive:
            return WebContent(
                type: .url,
                content: baseURL
            )
        case .timerExpired:
            return WebContent(
                type: .html,
                content: AppConfiguration.Web.timeOverMessage
            )
        }
    }
    
    func getShareItems() -> [Any]? {
        let shareText = "Check out Timer for Facebook - Manage your Facebook browsing time!"
        let appStoreURL = "https://apps.apple.com/gb/app/timer-for-facebook/id1150466189" // Replace with actual App Store URL
        
        var items: [Any] = [shareText]
        
        if let url = URL(string: appStoreURL) {
            items.append(url)
        }
        
        // Get app icon from bundle
        if let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIconDict = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIconDict["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last,
           let icon = UIImage(named: lastIcon) {
            items.append(icon)
        }
        
        return items
    }
    
    func getCurrentState() -> ContentState {
        guard let delegate = delegate else { return .timerNotSet }
        
        if delegate.isTimerExpired  {
            return .timerExpired
        } else if delegate.isTimerActive {
            return .timerActive
        }
        return .timerNotSet
    }
    
    func getHomePageURL() -> URL {
        return URL(string: baseURL)!
    }

}

struct WebContent {
    enum ContentType {
        case url
        case html
    }
    
    let type: ContentType
    let content: String
} 
