import UIKit

protocol TimerControllerDelegate: AnyObject {
    func timerDidUpdate(hours: Int, minutes: Int, seconds: Int)
    func timerDidEnd()
    func timerDidStart(duration: TimeInterval)
}

class TimerController: UIViewController {
    // MARK: - Properties
    private let timerModel: TimerModel
    private var dispatchTimer: DispatchSourceTimer?
    let timerView: TimerView
    weak var delegate: TimerControllerDelegate?
    
    // ReportDataManager
    private let reportDataManager: ReportDataManager

    var isActive: Bool {
        return timerModel.isActive
    }
    
    var remainingTime: TimeInterval {
        return timerModel.remainingTime
    }
    
    var totalTimeSpent: TimeInterval {
        return timerModel.totalTimeSpent
    }
    
    // MARK: - Initialization
    init(timerModel: TimerModel, 
         timerView: TimerView,
         reportDataManager: ReportDataManager = ReportDataManager(persistenceManager: UserDefaults.standard, delegate: nil)) {
        self.timerModel = timerModel
        self.timerView = timerView
        self.reportDataManager = reportDataManager
        super.init(nibName: nil, bundle: nil)
        setupNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = timerView
    }
    
    // MARK: - Timer Control Methods
    func startTimer(duration: TimeInterval) {
        timerModel.startTimer(duration: duration)
        setupDispatchTimer()
        delegate?.timerDidStart(duration: duration)
    }
    
    private func setupDispatchTimer() {
        dispatchTimer?.cancel()
        dispatchTimer = DispatchSource.makeTimerSource(queue: .main)
        dispatchTimer?.schedule(deadline: .now(), repeating: .seconds(1))
        
        dispatchTimer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            if self.timerModel.isExpired {
                self.stopTimer()
                self.delegate?.timerDidEnd()
                self.timerView.displayTimeUp()
                return
            }
            
            let time = self.timerModel.updateRemainingTime()
            self.delegate?.timerDidUpdate(hours: time.hours, minutes: time.minutes, seconds: time.seconds)
            self.timerView.updateRemainingTimeLabel(hours: time.hours, minutes: time.minutes, seconds: time.seconds)
        }
        
        dispatchTimer?.resume()
    }
    
    private func stopTimer() {
        dispatchTimer?.cancel()
        dispatchTimer = nil
    }
    
    // MARK: - App Lifecycle Notifications
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func appDidEnterBackground() {
        if timerModel.isActive {
            stopTimer() // Stop the dispatch timer only
            timerModel.pauseTimer() // This will save the current remaining time
        }
    }

    @objc private func appWillEnterForeground() {
        if timerModel.isActive {
            setupDispatchTimer() // Restart the UI updates
            timerModel.resumeTimer()
        } else {
            print("TimerController - Timer is not active")
        }
    }
    
    deinit {
        dispatchTimer?.cancel()
        NotificationCenter.default.removeObserver(self)
    }
    
    func pauseTimer() {
        dispatchTimer?.cancel()
        dispatchTimer = nil
        timerModel.pauseTimer()
    }
    
    func resumeTimer() {
        if timerModel.remainingTime > 0 {
            timerModel.resumeTimer()
            setupDispatchTimer()  // Changed from startDispatchTimer to setupDispatchTimer
        }
    }
    
    func updateRemainingTime() -> (hours: Int, minutes: Int, seconds: Int) {
        if isActive && !timerModel.isPaused {
            updateTimer()
        }
        
        let hours = Int(remainingTime) / 3600
        let minutes = Int(remainingTime) / 60 % 60
        let seconds = Int(remainingTime) % 60
        
        return (hours, minutes, seconds)
    }
    
    private func updateTimer() {
        guard timerModel.isActive, let start = timerModel.startTime else { return }
        
        let elapsed = Date().timeIntervalSince(start) + timerModel.accumulatedTime
        timerModel.remainingTime = max(0, timerModel.duration - elapsed)
        
        if timerModel.remainingTime <= 0 {
            // Log usage before stopping timer
            reportDataManager.logUsage(
                totalDuration: timerModel.duration,
                remainingTime: timerModel.remainingTime
            )
            stopTimer()
        }
    }
    
    private func updateDisplay(hours: Int, minutes: Int, seconds: Int) {
        timerView.updateRemainingTimeLabel(hours: hours, minutes: minutes, seconds: seconds)
    }
    
    // MARK: - Display Methods
    func updateDisplay() {
        let components = getCurrentTimeComponents()
        timerView.updateRemainingTimeLabel(
            hours: components.hours,
            minutes: components.minutes,
            seconds: components.seconds
        )
    }
    
    // MARK: - Private Methods
    private func startDispatchTimer() {
        dispatchTimer?.cancel()
        
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        timer.setEventHandler { [weak self] in
            self?.updateTimer()
        }
        timer.resume()
        
        dispatchTimer = timer
    }
    
    func getCurrentTimeComponents() -> (hours: Int, minutes: Int, seconds: Int) {
        let remaining = timerModel.remainingTime
        let hours = Int(remaining) / 3600
        let minutes = Int(remaining) / 60 % 60
        let seconds = Int(remaining) % 60
        return (hours, minutes, seconds)
    }
    
    func isTimerSetForToday() -> Bool {
        return timerModel.isTimerSetForToday
    }
    
    func shouldResetTimer() -> Bool {
        return timerModel.shouldResetTimer()
    }
    
    // MARK: - State Restoration
    func restoreTimer(remainingTime: TimeInterval, totalTimeSpent: TimeInterval) {
        timerModel.restoreState(remainingTime: remainingTime, totalTimeSpent: totalTimeSpent)
        
        // Don't start the timer automatically
        if timerModel.isActive {
            print("TimerController - Timer restored but not started yet")
        }
    }
    
    func resetTimer() {
        timerModel.stopTimer()
        dispatchTimer?.cancel()
        dispatchTimer = nil
        updateDisplay(with: (hours: 0, minutes: 0, seconds: 0))
    }
    
    private func updateDisplay(with components: (hours: Int, minutes: Int, seconds: Int)) {
        timerView.updateRemainingTimeLabel(
            hours: components.hours,
            minutes: components.minutes,
            seconds: components.seconds
        )
    }
}
