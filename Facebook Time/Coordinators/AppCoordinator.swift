import UIKit

class AppCoordinator {
    private let window: UIWindow
    private let appStateModel: AppStateModel
    private let lifecycleManager: AppLifecycleManager
    private var surfingViewController: SurfingViewController?
    
    init(window: UIWindow) {
        self.window = window
        self.appStateModel = AppStateModel()
        self.lifecycleManager = AppLifecycleManager(delegate: nil as AppLifecycleManagerDelegate?)
        self.lifecycleManager.setDelegate(self)
    }
    
    func start() {
        let dependencies = SurfingViewControllerDependencies.createDefault()
        let viewController = SurfingViewController(dependencies: dependencies)
        surfingViewController = viewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        restoreAppStateIfNeeded()
    }
    
    private func restoreAppStateIfNeeded() {
        if let state = appStateModel.loadAppState() {
            surfingViewController?.restoreState(
                isTimerActive: state.isTimerActive,
                remainingTime: state.remainingTime,
                totalTimeSpent: state.totalTimeSpent
            )
        }
    }
}

extension AppCoordinator: AppLifecycleManagerDelegate {
    
    func appDidEnterBackground() {
        guard let viewController = surfingViewController else { return }
        viewController.pauseTimer()
        
        let state = AppState(
            isTimerActive: viewController.isTimerActive,
            remainingTime: viewController.remainingTime,
            totalTimeSpent: viewController.totalTimeSpent,
            lastActiveDate: Date()
        )
        
        appStateModel.saveAppState(state)
        print("App state after saving it= \(state)")
    }
    
    func appWillEnterForeground() {
        guard let appState = appStateModel.loadAppState(),
            let viewController = surfingViewController else { 
            print("AppCoordinator - No saved state or view controller")
            return 
        }
        
        viewController.restoreState(
            isTimerActive: appState.isTimerActive,
            remainingTime: appState.remainingTime,
            totalTimeSpent: appState.totalTimeSpent
        )
    }
    
    func appWillTerminate() {
        guard let viewController = surfingViewController else { return }
        viewController.pauseTimer()
        
        let state = AppState(
            isTimerActive: viewController.isTimerActive,
            remainingTime: viewController.remainingTime,
            totalTimeSpent: viewController.totalTimeSpent,
            lastActiveDate: Date()
        )
        
        appStateModel.saveAppState(state)
    }
}
