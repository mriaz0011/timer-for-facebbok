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
    private var coordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard let window = window else { return false }
        
        let dependencies = SurfingViewControllerDependencies.createDefault()
        let appStateModel = AppStateModel()
        
        coordinator = MainCoordinator(
            window: window,
            dependencies: dependencies,
            appStateModel: appStateModel
        )
        coordinator?.start()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        coordinator?.appWillTerminate()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        coordinator?.appDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        coordinator?.appWillEnterForeground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Create a temporary AppStateModel to check the saved state
        let appStateModel = AppStateModel()
        if let appState = appStateModel.loadAppState(),
           appState.isTimerActive && appState.remainingTime > 0 {
            coordinator?.appWillEnterForeground()
        }
    }
}

