import Foundation

class ActivityTracker {
    private let analyticsModel: AnalyticsModel
    private var sessionStartTime: Date?
    private var isTracking: Bool = false
    
    init(analyticsModel: AnalyticsModel) {
        self.analyticsModel = analyticsModel
    }
    
    func startTracking() {
        guard !isTracking else { return }
        sessionStartTime = Date()
        isTracking = true
    }
    
    func stopTracking() {
        guard isTracking, let startTime = sessionStartTime else { return }
        let duration = Date().timeIntervalSince(startTime)
        analyticsModel.recordDailyUsage(duration: duration)
        isTracking = false
        sessionStartTime = nil
    }
    
    func pauseTracking() {
        guard isTracking, let startTime = sessionStartTime else { return }
        let duration = Date().timeIntervalSince(startTime)
        analyticsModel.recordDailyUsage(duration: duration)
        sessionStartTime = nil
    }
    
    func resumeTracking() {
        guard isTracking else { return }
        sessionStartTime = Date()
    }
} 