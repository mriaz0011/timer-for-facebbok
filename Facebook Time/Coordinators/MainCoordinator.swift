import UIKit

class MainCoordinator: Coordinator {
    // MARK: - Properties
    private let window: UIWindow
    private let dependencies: SurfingViewControllerDependencies
    private let appStateModel: AppStateModel
    private var surfingViewController: SurfingViewController?
    
    // MARK: - Initialization
    init(window: UIWindow, 
         dependencies: SurfingViewControllerDependencies,
         appStateModel: AppStateModel) {
        self.window = window
        self.dependencies = dependencies
        self.appStateModel = appStateModel
    }
    
    // MARK: - Coordinator Methods
    func start() {
        let surfingVC = SurfingViewController(dependencies: dependencies)
        surfingViewController = surfingVC
        
        let navigationController = dependencies.navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([surfingVC], animated: false)
        
        window.rootViewController = navigationController
        
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
            window.windowLevel = .statusBar
        }
        
        window.makeKeyAndVisible()
    }
    
    func appDidEnterBackground() {
        guard let viewController = surfingViewController else { return }
        viewController.hideTimerPicker()
        
        let state = AppState(
            isTimerActive: viewController.isTimerActive,
            remainingTime: viewController.remainingTime,
            totalTimeSpent: viewController.totalTimeSpent,
            lastActiveDate: Date()
        )
        
        appStateModel.saveAppState(state)
    }
    
    func appWillEnterForeground() {
        guard let appState = appStateModel.loadAppState(),
              let viewController = surfingViewController else { return }
        
        viewController.restoreState(
            isTimerActive: appState.isTimerActive,
            remainingTime: appState.remainingTime,
            totalTimeSpent: appState.totalTimeSpent
        )
    }
    
    func appWillTerminate() {
        appDidEnterBackground()
    }
    
    // MARK: - Navigation Methods
    func showReport() {
        guard let viewController = surfingViewController else { return }
        let reportController = ReportController()
        let reportVC = ReportViewController(reportController: reportController)
        let navigationController = UINavigationController(rootViewController: reportVC)
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true)
    }
    
    func showTimerPicker() {
        surfingViewController?.showTimerPicker()
    }
    
    func hideTimerPicker() {
        surfingViewController?.hideTimerPicker()
    }
    
    func showShareSheet(items: [Any]) {
        guard let viewController = surfingViewController else { return }
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController.present(activityVC, animated: true)
    }
    
    func showAlert(_ alert: AlertType) {
        guard let viewController = surfingViewController else { return }
        AlertManager.showAlert(alert, on: viewController)
    }
} 
