import UIKit

protocol LifecycleManagerDelegate: AnyObject {
    func applicationWillEnterForeground()
    func applicationDidEnterBackground()
    func applicationWillTerminate()
}

class LifecycleManager {
    weak var delegate: LifecycleManagerDelegate?
    
    func handleForeground() {
        delegate?.applicationWillEnterForeground()
    }
    
    func handleBackground() {
        delegate?.applicationDidEnterBackground()
    }
    
    func handleTermination() {
        delegate?.applicationWillTerminate()
    }
} 