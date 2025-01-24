import Foundation

protocol AppLifecycleDelegate: AnyObject {
    func appDidEnterBackground()
    func appWillEnterForeground()
    func appWillTerminate()
} 