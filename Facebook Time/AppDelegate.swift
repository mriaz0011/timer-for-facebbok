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
        // Override point for customization after application launch.
        
        //For google mobile ads
        // Use Firebase library to configure APIs
//        FIRApp.configure()
        //GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544~1458002511") //Test
//        GADMobileAds.configure(withApplicationID: "ca-app-pub-9005498559306659~2080713926")
        
        //Storage keys initialization.
        keysInitialization()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if AppSettings.shared.timer.isValid {
            AppSettings.shared.timer.invalidate()
        }
        
        AppSettings.shared.storageDefaults.set(AppSettings.shared.remainingTimeInSeconds, forKey: "remainingTimeInSeconds")
        
        //Saving record in database.
        if AppSettings.shared.saveRecord == true {
            RepeatMethods.recordSpentTime(Date(), mStartTime: AppSettings.shared.startTime)
            AppSettings.shared.saveRecord = false
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        AppSettings.shared.remainingTimeInSeconds = AppSettings.shared.storageDefaults.integer(forKey: "remainingTimeInSeconds")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshingView"), object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func keysInitialization() {
        
        //First time writing keys in defaults.
        if let keysInitializationCheck = AppSettings.shared.storageDefaults.string(forKey: "keysInitializationForVersion1Build1") { //Put new key
            print(keysInitializationCheck)
            AppSettings.shared.remainingTimeInSeconds = AppSettings.shared.storageDefaults.integer(forKey: "remainingTimeInSeconds")
            AppSettings.shared.currentURL = AppSettings.shared.storageDefaults.string(forKey: "currentURLKey")
        } else {
            AppSettings.shared.storageDefaults.setValue("Default keys initiated already.", forKey: "keysInitializationForVersion1Build1")
            AppSettings.shared.storageDefaults.set(0, forKey: "remainingTimeInSeconds")
            AppSettings.shared.storageDefaults.setValue("http://facebook.com", forKey: "currentURLKey")
            AppSettings.shared.remainingTimeInSeconds = AppSettings.shared.storageDefaults.integer(forKey: "remainingTimeInSeconds")
            AppSettings.shared.currentURL = AppSettings.shared.storageDefaults.string(forKey: "currentURLKey")
            
            print("Old keys doesn't exist. New keys initiated.")
            
            //** Copying Facebook-Icon.png into app directory. **
            let fileManager = FileManager.default
            let mainPath = Bundle.main.bundlePath
            //let mainDirectoryURL: NSURL = NSURL.fileURLWithPath(path)
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            
            var fileNames = ["Facebook-Icon.png", "style.css"]
            
            for indexA in 0 ..< fileNames.count  {
                let getImagePathForMainPath = mainPath.stringByAppendingPathComponent(fileNames[indexA])
                let setImagePathForDocumentPath = documentPath.stringByAppendingPathComponent(fileNames[indexA])
                
                //Copying image from main to app's document directory.
                if !(fileManager.fileExists(atPath: setImagePathForDocumentPath)) {
                    try! fileManager.copyItem(atPath: getImagePathForMainPath, toPath: setImagePathForDocumentPath)
                }
            }
        }
    }
}

