import UIKit

protocol ShareControllerDelegate: AnyObject {
    func shareController(_ controller: ShareController, didShareContent content: Any)
    func shareController(_ controller: ShareController, didFailWithError error: Error)
}

class ShareController: NSObject {
    // MARK: - Properties
    private let webContentModel: WebContentModel
    private let appStoreURL = URL(string: "https://apps.apple.com/gb/app/timer-for-facebook/id1150466189")! // Replace with actual App Store URL
    weak var delegate: ShareControllerDelegate?
    
    // MARK: - Initialization
    init(webContentModel: WebContentModel, delegate: ShareControllerDelegate? = nil) {
        self.webContentModel = webContentModel
        self.delegate = delegate
        super.init()
    }
    
    // MARK: - Public Methods
    func presentShareSheet(on viewController: UIViewController) {
        let shareItems = getShareContent()
        
        let activityVC = UIActivityViewController(
            activityItems: shareItems,
            applicationActivities: nil
        )
        
        activityVC.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .openInIBooks,
            .saveToCameraRoll
        ]
        
        activityVC.completionWithItemsHandler = { [weak self] activityType, completed, items, error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.shareController(self, didFailWithError: ShareError.sharingFailed(error))
                return
            }
            
            if completed {
                self.delegate?.shareController(self, didShareContent: shareItems)
            }
        }
        
        // For iPad
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX,
                                                y: viewController.view.bounds.midY,
                                                width: 0,
                                                height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(activityVC, animated: true)
    }
    
    // MARK: - Private Methods
    private func getShareContent() -> [Any] {
        var shareItems: [Any] = []
        
        // Add app
        shareItems.append(appStoreURL)
        
        // Add app name and description
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Timer for Facebook"
        let appDescription = """
        Check out \(appName) - The best way to manage your Facebook surfing time!
        
        Set time limits and stay productive while using surfing Facebook on this app.
        """
        shareItems.append(appDescription)
        
        return shareItems
    }
}

// MARK: - Share Errors
enum ShareError: LocalizedError {
    case noContent
    case invalidURL
    case sharingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .noContent:
            return "No content available to share"
        case .invalidURL:
            return "Invalid URL for sharing"
        case .sharingFailed(let error):
            return "Sharing failed: \(error.localizedDescription)"
        }
    }
} 
