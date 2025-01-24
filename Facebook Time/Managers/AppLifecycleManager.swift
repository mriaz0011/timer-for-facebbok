import UIKit

class AppLifecycleManager {
    private let notificationCenter: NotificationCenter
    private weak var delegate: AppLifecycleManagerDelegate?
    
    init(delegate: AppLifecycleManagerDelegate? = nil, notificationCenter: NotificationCenter = .default) {
        self.delegate = delegate
        self.notificationCenter = notificationCenter
        setupNotifications()
    }
    
    func setDelegate(_ delegate: AppLifecycleManagerDelegate) {
        self.delegate = delegate
    }
    
    private func setupNotifications() {
        notificationCenter.addObserver(
            self,
            selector: #selector(handleBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(handleForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(handleTermination),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }
    
    @objc private func handleBackground() {
        delegate?.appDidEnterBackground()
    }
    
    @objc private func handleForeground() {
        delegate?.appWillEnterForeground()
    }
    
    @objc private func handleTermination() {
        delegate?.appWillTerminate()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
} 
