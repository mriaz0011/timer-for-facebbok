//
//  TimerModel.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 02/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import Foundation

class TimerModel {
    // MARK: - Properties
    private(set) var isActive: Bool = false
    private(set) var isPaused: Bool = false
    var remainingTime: TimeInterval = 0
    private(set) var totalTimeSpent: TimeInterval = 0
    var startTime: Date?
    var duration: TimeInterval = 0
    var accumulatedTime: TimeInterval = 0
    
    var isExpired: Bool {
        let expired = isActive && !isPaused && remainingTime <= 0
        return expired
    }
    
    // MARK: - Timer Control
    func startTimer(duration: TimeInterval) {
        guard duration > 0, shouldResetTimer() else {
            return 
        }

        self.duration = duration
        self.isActive = true
        self.isPaused = false
        self.startTime = Date()
        self.accumulatedTime = 0
        self.remainingTime = duration
        saveTimerState()
    }
    
    func pauseTimer() {
        guard isActive else { return }

        isPaused = true
        // Simply save the current remaining time, no elapsed time calculation needed
        print("TimerModel - Timer paused with remaining time: \(remainingTime)")
        saveTimerState()
    }
    
    func resumeTimer() {
        guard isActive && remainingTime > 0 else { 
            print("TimerModel - resumeTimer: conditions not met")
            return 
        }

        isPaused = false
        startTime = Date()
        saveTimerState()
    }
    
    func stopTimer() {
        isActive = false
        isPaused = false
        if let lastActiveTime = startTime {
            totalTimeSpent += Date().timeIntervalSince(lastActiveTime) + accumulatedTime
        }
        startTime = nil
        saveTimerState()
    }
    
    func updateRemainingTime() -> (hours: Int, minutes: Int, seconds: Int) {
        updateTimer()
        
        let hours = Int(remainingTime) / 3600
        let minutes = Int(remainingTime) / 60 % 60
        let seconds = Int(remainingTime) % 60
        
        return (hours, minutes, seconds)
    }
    
    private func updateTimer() {
        guard isActive, !isPaused, let start = startTime else { 
            print("TimerModel - updateTimer: conditions not met")
            return 
        }

        let elapsed = Date().timeIntervalSince(start)
        remainingTime = max(0, remainingTime - elapsed)
        startTime = Date()
    }
    
    // MARK: - State Management
    private func saveTimerState() {
        let defaults = UserDefaults.standard
        defaults.set(isActive, forKey: "isTimerActive")
        defaults.set(isPaused, forKey: "isTimerPaused")
        defaults.set(remainingTime, forKey: "remainingTime")
        defaults.set(totalTimeSpent, forKey: "totalTimeSpent")
        defaults.set(duration, forKey: "duration")
        defaults.set(Date(), forKey: "lastActiveDate")
    }
    
    func loadTimerState() {
        let defaults = UserDefaults.standard
        isActive = defaults.bool(forKey: "isTimerActive")
        isPaused = defaults.bool(forKey: "isTimerPaused")
        remainingTime = defaults.double(forKey: "remainingTime")
        totalTimeSpent = defaults.double(forKey: "totalTimeSpent")
        accumulatedTime = defaults.double(forKey: "accumulatedTime")

        if let startTimeInterval = defaults.object(forKey: "startTime") as? Date {
            startTime = startTimeInterval
        }

        duration = defaults.double(forKey: "duration")
    }
    
    // MARK: - Timer Reset Logic
    func shouldResetTimer() -> Bool {
        guard let lastActiveDate = UserDefaults.standard.object(forKey: "lastActiveDate") as? Date else {
            return true
        }
        return !Calendar.current.isDate(lastActiveDate, inSameDayAs: Date())
    }
    
    var isTimerSetForToday: Bool {
        guard let lastActiveDate = UserDefaults.standard.object(forKey: "lastActiveDate") as? Date else {
            return false
        }
        return Calendar.current.isDate(lastActiveDate, inSameDayAs: Date())
    }
    
    func restoreState(remainingTime: TimeInterval, totalTimeSpent: TimeInterval) {
        self.remainingTime = remainingTime
        self.totalTimeSpent = totalTimeSpent
        self.isActive = remainingTime > 0
        self.isPaused = true  // Start paused
        self.startTime = nil  // Clear start time
        saveTimerState()
    }
}
