import Foundation

protocol AppLifecycleManagerDelegate: AnyObject {
    func appDidEnterBackground()
    func appWillEnterForeground()
    func appWillTerminate()
} 