import UIKit

class ViewControllerFactory {
    static func createSurfingViewController() -> SurfingViewController {
        let dependencies = SurfingViewControllerDependencies.createDefault()
        return SurfingViewController(dependencies: dependencies)
    }
} 