//
//  AppDelegate.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 02/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?
    private let reportDataManager = ReportDataManager(
        persistenceManager: UserDefaultsManager(),
        delegate: nil
    )
    
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
        coordinator?.appDidEnterBackground()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        coordinator?.appDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        coordinator?.appWillEnterForeground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let appStateModel = AppStateModel()
        if let appState = appStateModel.loadAppState(),
           appState.isTimerActive && appState.remainingTime > 0 {
            coordinator?.appWillEnterForeground()
        }
    }
}

