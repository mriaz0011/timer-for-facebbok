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
    
    init() {
        loadTimerState()  // Load state when initialized
    }
    
    var isExpired: Bool {
        return isActive && !isPaused && remainingTime <= 0
    }
    
    // MARK: - Timer Control
    func startTimer(duration: TimeInterval) {
        print("DEBUG - TimerModel: Starting timer with duration \(duration)")
        self.duration = duration
        self.remainingTime = duration
        self.isActive = true
        self.isPaused = false
        self.startTime = Date()
        self.accumulatedTime = 0
        saveTimerState()
    }
    
    func pauseTimer() {
        print("DEBUG - TimerModel: Pausing timer - Current remaining time: \(remainingTime)")
        if let start = startTime {
            accumulatedTime += Date().timeIntervalSince(start)
        }
        isPaused = true
        startTime = nil
        
        print("DEBUG - TimerModel: Timer paused - Remaining time: \(remainingTime)")
        saveTimerState()
    }
    
    func resumeTimer() {
        print("DEBUG - TimerModel: Resuming timer")
        isPaused = false
        startTime = Date()
        saveTimerState()
    }
    
    func stopTimer() {
        print("DEBUG - TimerModel: Stopping timer")
        isActive = false
        isPaused = true
        startTime = nil
        remainingTime = 0  // Only reset remaining time when actually stopping
        saveTimerState()
    }
    
    func restoreTimer(remainingTime: TimeInterval, totalTimeSpent: TimeInterval) {
        print("DEBUG - TimerModel: Restoring timer with remaining time: \(remainingTime)")
        if remainingTime > 0 {
            self.remainingTime = remainingTime
            self.totalTimeSpent = totalTimeSpent
            self.isActive = true
            self.isPaused = true  // Start paused when restored
            self.duration = remainingTime
            self.accumulatedTime = 0
            self.startTime = nil
            
            print("DEBUG - TimerModel: Timer restored with remaining time: \(remainingTime)")
        } else {
            stopTimer()
            print("DEBUG - TimerModel: Timer stopped due to no remaining time")
        }
    }
    
    func updateRemainingTime() -> (hours: Int, minutes: Int, seconds: Int) {
        updateTimer()
        
        let hours = Int(remainingTime) / 3600
        let minutes = Int(remainingTime) / 60 % 60
        let seconds = Int(remainingTime) % 60
        
        return (hours, minutes, seconds)
    }
    
    private func updateTimer() {
        guard isActive else { 
            print("TimerModel - updateTimer: Timer not active")
            return 
        }
        
        if isPaused {
            print("TimerModel - updateTimer: Timer is paused")
            return
        }
        
        guard let start = startTime else {
            print("TimerModel - updateTimer: No start time")
            return 
        }
        
        let elapsed = Date().timeIntervalSince(start)
        remainingTime = max(0, remainingTime - elapsed)
        print("TimerModel - Remaining time after update: \(remainingTime)")
        
        accumulatedTime += elapsed
        startTime = Date()  // Reset start time for next calculation
        
        saveTimerState()
    }
    
    // MARK: - State Management
    private func saveTimerState() {
        print("DEBUG - TimerModel: Saving state to UserDefaults")
        let defaults = UserDefaults.standard
        
        defaults.set(isActive, forKey: "isTimerActive")
        defaults.set(isPaused, forKey: "isTimerPaused")
        defaults.set(remainingTime, forKey: "remainingTime")
        defaults.set(totalTimeSpent, forKey: "totalTimeSpent")
        defaults.set(accumulatedTime, forKey: "accumulatedTime")
        defaults.set(duration, forKey: "duration")
        if let startTime = startTime {
            defaults.set(startTime, forKey: "startTime")
        }
        
        print("DEBUG - TimerModel: Saved state - isActive: \(isActive), isPaused: \(isPaused), remainingTime: \(remainingTime)")
    }
    
    func loadTimerState() {
        print("DEBUG - TimerModel: Loading state from UserDefaults")
        let defaults = UserDefaults.standard
        
        isActive = defaults.bool(forKey: "isTimerActive")
        isPaused = defaults.bool(forKey: "isTimerPaused")
        remainingTime = defaults.double(forKey: "remainingTime")
        totalTimeSpent = defaults.double(forKey: "totalTimeSpent")
        accumulatedTime = defaults.double(forKey: "accumulatedTime")
        duration = defaults.double(forKey: "duration")
        
        if let startTimeDate = defaults.object(forKey: "startTime") as? Date {
            startTime = startTimeDate
        }
        
        print("DEBUG - TimerModel: Loaded state - isActive: \(isActive), isPaused: \(isPaused), remainingTime: \(remainingTime)")
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
    
    func getCurrentTimeSpent() -> TimeInterval {
        let defaults = UserDefaults.standard
        let totalTimeSpent = defaults.double(forKey: "totalTimeSpent")
        print("DEBUG - TimerModel - UserDefaults totalTimeSpent: \(totalTimeSpent)")
        
        var currentSpent = accumulatedTime
        if let start = startTime, !isPaused {
            let currentTime = Date()
            let additional = currentTime.timeIntervalSince(start)
            currentSpent += additional
            print("DEBUG - TimerModel - Current session time: \(currentSpent)")
        }
        
        let finalTotal = totalTimeSpent + currentSpent
        print("DEBUG - TimerModel - Final total time: \(finalTotal)")
        return finalTotal
    }
}
