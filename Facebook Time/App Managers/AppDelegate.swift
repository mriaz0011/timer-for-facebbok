//
//  AppDelegate.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 02/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = SurfingViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if let surfingVC = window?.rootViewController as? SurfingViewController {
            surfingVC.saveTimerState()
            surfingVC.timerModel.logTimeSpent()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let surfingVC = window?.rootViewController as? SurfingViewController {
            surfingVC.resumeTimerState()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if let surfingVC = window?.rootViewController as? SurfingViewController {
            surfingVC.saveTimerState()
            surfingVC.timerModel.logTimeSpent()
        }
    }
}

