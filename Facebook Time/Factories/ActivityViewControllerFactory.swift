import UIKit

class ActivityViewControllerFactory {
    static func create(with items: [Any], from viewController: UIViewController) -> UIActivityViewController {
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        activityVC.excludedActivityTypes = [
            .print,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList
        ]
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(
                x: viewController.view.bounds.midX,
                y: viewController.view.bounds.midY,
                width: 0,
                height: 0
            )
        }
        
        return activityVC
    }
} 