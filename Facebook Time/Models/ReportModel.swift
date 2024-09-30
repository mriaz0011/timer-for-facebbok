//
//  ReportModel.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 04/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import Foundation

class ReportModel {
    // Holds the usage data for each day (in seconds)
    private(set) var reportData: [String: Double] = [:]
    
    init() {
        loadReportData()
    }
    
    // Loads the report data from UserDefaults or initializes it
    func loadReportData() {
        reportData = UserDefaults.standard.dictionary(forKey: "WeekUsageReport") as? [String: Double] ?? [
            "Monday": 0,
            "Tuesday": 0,
            "Wednesday": 0,
            "Thursday": 0,
            "Friday": 0,
            "Saturday": 0,
            "Sunday": 0
        ]
        
        resetReportDataIfNeeded() // Check if data needs to be reset (every Monday)
        print("Loaded report data: \(reportData)")
    }
    
    // Resets the report data if today is Monday
    private func resetReportDataIfNeeded() {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentWeekday = calendar.component(.weekday, from: currentDate)
        
        // If today is Monday, reset the data
        if currentWeekday == 2 {
            reportData = [
                "Monday": 0,
                "Tuesday": 0,
                "Wednesday": 0,
                "Thursday": 0,
                "Friday": 0,
                "Saturday": 0,
                "Sunday": 0
            ]
            UserDefaults.standard.set(reportData, forKey: "WeekUsageReport")
        }
    }
    
    // Access the data for a particular day
    func getTimeSpent(for day: String) -> Double {
        return reportData[day] ?? 0
    }
}
