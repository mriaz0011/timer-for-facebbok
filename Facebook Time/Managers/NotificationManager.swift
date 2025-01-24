import UIKit

protocol NotificationObserver: AnyObject {
    func handleNotification(_ notification: Notification)
}

extension NotificationObserver {
    func handleNotification(_ notification: Notification) {}
}

class NotificationManager {
    private weak var observer: NotificationObserver?
    private var observations: [NSObjectProtocol] = []
    
    init(observer: NotificationObserver) {
        self.observer = observer
    }
    
    func observe(_ name: Notification.Name, handler: @escaping (Notification) -> Void) {
        let observation = NotificationCenter.default.addObserver(
            forName: name,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            handler(notification)
            self?.observer?.handleNotification(notification)
        }
        
        observations.append(observation)
    }
    
    deinit {
        observations.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
} 