//
//  AlertManager.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 03/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit

class AlertManager {
    
    // MARK: - Timer Set Alert
    static func showTimerSetAlert(on viewController: UIViewController, hours: Int, minutes: Int) {
        let message = "Timer has been set for \(hours) hour(s) and \(minutes) minute(s)."
        let alert = createAlert(title: "Timer Set", message: message)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Time Over Alert
    static func showTimeOverAlert(on viewController: UIViewController) {
        let alert = createAlert(title: "Time Over", message: "Your time is up!")
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Time Set Alert
    static func showTimeSetAlert(on viewController: UIViewController) {
        let alert = createAlert(title: "Time Set", message: "Your already set the time!")
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Time Not Set Alert
    static func timeNotSetAlert(on viewController: UIViewController) {
        let alert = createAlert(title: "Time Not Set", message: "You didn't set the time!")
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Set Time Tomorrow Alert
    static func showSetTimeTomorrowAlert(on viewController: UIViewController) {
        let alert = createAlert(title: "Today's Time Over", message: "You can use facebook tomorrow!")
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Show No History Alert
    static func showNoHistoryAlert(on viewController: UIViewController) {
        let alert = createAlert(title: "No Previous Page", message: "There is no previous page to navigate back to.")
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Share Error Alert
    static func shareErrorAlert(on viewController: UIViewController) {
        let alert = createAlert(title: "Error", message: "Failed to create the App Store URL.")
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Add More Alerts Here
    
    // MARK: - Private Helper: Create Alert
    private static func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}
