//
//  TimerModel.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 02/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import Foundation

class TimerModel {

    private let userDefaultsTimerKey = "TimerDuration"
    private let userDefaultsTotalDurationKey = "TotalDuration" // Key to save total duration
    private let userDefaultsLastActiveTimeKey = "LastActiveTime"
    private let userDefaultsDateKey = "TimerSetDate"
    private let reportDataKey = "WeekUsageReport"

    var remainingTime: TimeInterval = 0
    var totalDuration: TimeInterval = 0

    // Save the remaining time and total duration when the app goes to background
    func saveTimerState(remainingTime: TimeInterval) {
        let currentDate = Calendar.current.startOfDay(for: Date())
        UserDefaults.standard.set(remainingTime, forKey: userDefaultsTimerKey) // Save remaining time
        UserDefaults.standard.set(totalDuration, forKey: userDefaultsTotalDurationKey) // Save total duration
        UserDefaults.standard.set(currentDate, forKey: userDefaultsDateKey)
        UserDefaults.standard.set(Date(), forKey: userDefaultsLastActiveTimeKey)
    }

    // Load the remaining time and total duration saved in UserDefaults
    func loadTimerState() {
        remainingTime = UserDefaults.standard.double(forKey: userDefaultsTimerKey)
        totalDuration = UserDefaults.standard.double(forKey: userDefaultsTotalDurationKey)
    }

    // Check if the timer was set today
    func isTimerSetForToday() -> Bool {
        if let timerSetDate = UserDefaults.standard.object(forKey: userDefaultsDateKey) as? Date {
            let currentDate = Calendar.current.startOfDay(for: Date())
            return currentDate == timerSetDate
        }
        return false
    }

    // Log time spent and save it in the report
    func logTimeSpent() {
        if isTimerSetForToday() {
            let calendar = Calendar.current
            let currentDay = calendar.component(.weekday, from: Date())
            var usageData = UserDefaults.standard.dictionary(forKey: reportDataKey) as? [String: Double] ?? [:]
            let dayName = getDayName(for: currentDay)

            // Print the total duration and remaining time for debugging
            print("Total duration: \(totalDuration) seconds")
            print("Remaining time: \(remainingTime) seconds")

            // Calculate time spent in seconds
            let timeSpentInSeconds = max(totalDuration - remainingTime, 0)

            // Print out the calculated time spent for debugging
            print("Time spent today (\(dayName)): \(timeSpentInSeconds) seconds")

            if timeSpentInSeconds > 0 {
                // Ensure no negative time spent and store it in the report
                usageData[dayName] = max(timeSpentInSeconds, 0)

                // Save to UserDefaults
                UserDefaults.standard.set(usageData, forKey: reportDataKey)

                // Print out the updated usage data for debugging
                print("Updated usage data: \(usageData)")

                // Notify any listeners that the report data was updated
                NotificationCenter.default.post(name: NSNotification.Name("ReportDataUpdated"), object: nil)
            }
        }
    }

    private func getDayName(for weekday: Int) -> String {
        let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        return dayNames[weekday - 1]
    }

    // Reset timer data for a new day
    func resetForNewDay() {
        let currentDate = Calendar.current.startOfDay(for: Date())
        if let timerSetDate = UserDefaults.standard.object(forKey: userDefaultsDateKey) as? Date, timerSetDate != currentDate {
            UserDefaults.standard.removeObject(forKey: userDefaultsTimerKey)
            UserDefaults.standard.removeObject(forKey: userDefaultsTotalDurationKey) // Clear total duration
            UserDefaults.standard.removeObject(forKey: userDefaultsDateKey)
            UserDefaults.standard.removeObject(forKey: userDefaultsLastActiveTimeKey)
        }
    }
}
