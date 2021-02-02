//
//  RepeatMethods.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 06/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit

class RepeatMethods: NSObject {
    
    class func recordSpentTime(_ mEndTime: Date, mStartTime: Date) {
        
        let itemName: String = "Facebook"
        let itemImage: String = "Facebook-Icon.png"
        let itemLink: String = "facebook.com"
        let imageLocalStorage: String = "false"
        
        let date8Digit = Date().asStringDate()
        let dateLongString = Date().asLongString()
        let year4Digit = Date().asStringYear
        let weekNumber = Date().asStringWeek
        let monthFull = Date().asStringMonth
        let totalSpentTimeInSeconds = Int(mEndTime.timeIntervalSince(mStartTime))
        let startTimeFull = mStartTime.asStringTimeFull
        let endTimeFull = mEndTime.asStringTimeFull
        
        _ = AppSettings.shared.db.execute(sql: "INSERT INTO report_details (item_name, item_link, item_image, image_local_storage, date_8digit, date_string, year_4digit, week_no, month, start_time, end_time, total_time) VALUES ('\(itemName)', '\(itemLink)', '\(itemImage)', '\(imageLocalStorage)', '\(date8Digit)', '\(dateLongString)', '\(year4Digit)', '\(weekNumber)', '\(monthFull)', '\(startTimeFull)', '\(endTimeFull)', '\(totalSpentTimeInSeconds)')")
    }
}
