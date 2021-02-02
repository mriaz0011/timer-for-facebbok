//
//  Extension+ViewController.swift
//  Facebook Time
//
//  Created by infoappworld1 on 25/01/2021.
//  Copyright © 2021 APPWORLD. All rights reserved.
//

import UIKit

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        var pickerValues: Int = 0
        if component == 0 {
            pickerValues = DataModel.hoursPickerValues.count
            return pickerValues
        } else {
            pickerValues = DataModel.minutesPickerValues.count
            return pickerValues
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var attributedString: NSAttributedString!
        if component == 0 {
            attributedString = NSAttributedString(string: DataModel.hoursPickerValues[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            return attributedString
        } else {
            attributedString = NSAttributedString(string: DataModel.minutesPickerValues[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            return attributedString
        }
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            //For hour.
            let selectedHour = DataModel.hoursPickerValues[row]
            let hourInInt: Int = row
            _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='\(selectedHour)' WHERE key='setHours'")
            _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='\(hourInInt)' WHERE key='setHoursInt'")
            //For minutes.
            let setMinutesIntQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='setMinutesInt'")
            let setMinutesInt: Int = Int((setMinutesIntQuery[0]["value"] as! String))!
            //Calculation.
            let dailySocialTime:Int = ((hourInInt * 60) * 60) + (setMinutesInt * 60)
            _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='\(dailySocialTime)' WHERE key='dailySocialTime'")
            //Updating remaining time label if needed.
            UpdatingRemainingTimeLabel()
            /*remainingTimeInSeconds = dailySocialTime
             storageDefaults.setInteger(remainingTimeInSeconds, forKey: "remainingTimeInSeconds")
             //Assigning time to label.
             let remainingTimeString: String  = (CommonUtilities.secondsToHoursMinutesSeconds(remainingTimeInSeconds)) + "-"
             remainingTimeLabel.text = remainingTimeString */
            //print(dailySocialTime)
        } else {
            //For minutes
            let selectedMinutes = DataModel.minutesPickerValues[row]
            let minutesInInt: Int = row
            _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='\(selectedMinutes)' WHERE key='setMinutes'")
            _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='\(minutesInInt)' WHERE key='setMinutesInt'")
            //For hours.
            let setHourIntQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='setHoursInt'")
            let setHourInt: Int = Int((setHourIntQuery[0]["value"] as! String))!
            //Calculation.
            let dailySocialTime:Int = ((setHourInt * 60) * 60) + (minutesInInt * 60)
            _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='\(dailySocialTime)' WHERE key='dailySocialTime'")
            //Updating remaining time label if needed.
            UpdatingRemainingTimeLabel()
            /*remainingTimeInSeconds = dailySocialTime
             storageDefaults.setInteger(remainingTimeInSeconds, forKey: "remainingTimeInSeconds")
             //Assigning time to label.
             let remainingTimeString: String  = (CommonUtilities.secondsToHoursMinutesSeconds(remainingTimeInSeconds)) + "-"
             remainingTimeLabel.text = remainingTimeString*/
            //print(dailySocialTime)
        }
    }
    
    @IBAction func pickerViewDoneAction(_ sender: UIButton) {
        
        //For remaining time label in main screen top corner.
        let setTimerMessageQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='timerSettingMessageDisplay'")
        let setTimerMessageValue = setTimerMessageQuery[0]["value"] as! String
        
        if setTimerMessageValue == "false" {
            alertForSetSocialTime()
        }
        
        //Testing
        timerCheckToDisplayBrowser()
        
        pickerConainerView.isHidden = true
    }
}
