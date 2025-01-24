import UIKit

protocol LifecycleControllerDelegate: AnyObject {
    func applicationWillEnterForeground()
    func applicationDidEnterBackground()
    func applicationWillTerminate()
}

class LifecycleController {
    private weak var delegate: LifecycleControllerDelegate?
    
    init(delegate: LifecycleControllerDelegate?) {
        self.delegate = delegate
        setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTermination),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }
    
    @objc private func handleForeground() {
        delegate?.applicationWillEnterForeground()
    }
    
    @objc private func handleBackground() {
        delegate?.applicationDidEnterBackground()
    }
    
    @objc private func handleTermination() {
        delegate?.applicationWillTerminate()
    }
    
    func updateDelegate(_ delegate: LifecycleControllerDelegate) {
        self.delegate = delegate
    }
} 