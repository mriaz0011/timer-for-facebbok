//
//  ReportModel.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 04/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import Foundation

class ReportModel {
    // MARK: - Properties
    private let dataManager: ReportDataManager
    private(set) var dailyUsage: [Date: TimeInterval] = [:]
    private(set) var totalTimeSpent: TimeInterval = 0
    weak var delegate: ReportDataDelegate?
    
    // MARK: - Initialization
    init(dataManager: ReportDataManager = ReportDataManager(
        persistenceManager: UserDefaultsManager(),
        delegate: nil
    )) {
        self.dataManager = dataManager
        setupNotifications()
    }
    
    // MARK: - Public Methods
    func refresh() {
        let weeklyData = dataManager.weeklyUsage
        print("ReportModel - refresh: weeklyData count = \(weeklyData.count)")
        
        // Create a dictionary with proper date keys
        let calendar = Calendar.current
        var usageDict: [Date: TimeInterval] = [:]
        
        // Fill in all days of the week with zero duration
        let today = Date()
        for dayOffset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let startOfDay = calendar.startOfDay(for: date)
                usageDict[startOfDay] = 0
            }
        }
        
        // Update with actual usage data
        for usage in weeklyData {
            let startOfDay = calendar.startOfDay(for: usage.date)
            print("ReportModel - Adding usage for \(startOfDay): \(usage.duration)")
            if let existingDuration = usageDict[startOfDay] {
                usageDict[startOfDay] = existingDuration + usage.duration
            } else {
                usageDict[startOfDay] = usage.duration
            }
        }
        
        self.dailyUsage = usageDict
        self.totalTimeSpent = weeklyData.map { $0.duration }.reduce(0, +)
        print("ReportModel - Total time spent: \(totalTimeSpent)")
        delegate?.reportDataDidUpdate()
    }
    
    func usageForCurrentWeek() -> [Date: TimeInterval] {
        return Dictionary(uniqueKeysWithValues: dataManager.weeklyUsage.map { 
            ($0.date, $0.duration) 
        })
    }
    
    // MARK: - Private Methods
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: .usageStatsDidUpdate,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refresh()
        }
    }
    
    @objc private func handleDataUpdate() {
        refresh()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func averageDailyUsage() -> TimeInterval {
        let weekUsage = usageForCurrentWeek()
        guard !weekUsage.isEmpty else { return 0 }
        let totalTime = weekUsage.values.reduce(0, +)
        return totalTime / TimeInterval(weekUsage.count)
    }
    
    func mostUsedDay() -> Date? {
        return dailyUsage.max(by: { $0.value < $1.value })?.key
    }
    
    func leastUsedDay() -> Date? {
        return dailyUsage.min(by: { $0.value < $1.value })?.key
    }
    
    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
