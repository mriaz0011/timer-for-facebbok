import UIKit

protocol TimerControllerDelegate: AnyObject {
    func timerDidStart()
    func timerDidPause()
    func timerDidResume()
    func timerDidStop()
    func timerDidEnd()
    func timerDidUpdate(remainingTime: TimeInterval, totalTimeSpent: TimeInterval)
}

class TimerController: UIViewController {
    // MARK: - Properties
    let timerView: TimerView
    let timerModel: TimerModel
    private let reportDataManager: ReportDataManager
    private var dispatchTimer: DispatchSourceTimer?
    weak var delegate: TimerControllerDelegate?
    
    // Add computed properties
    var isTimerActive: Bool {
        return timerModel.isActive
    }
    
    var remainingTime: TimeInterval {
        return timerModel.remainingTime
    }
    
    var totalTimeSpent: TimeInterval {
        return timerModel.getCurrentTimeSpent()
    }
    
    // MARK: - Initialization
    init(timerView: TimerView, timerModel: TimerModel, reportDataManager: ReportDataManager) {
        self.timerView = timerView
        self.timerModel = timerModel
        self.reportDataManager = reportDataManager
        super.init(nibName: nil, bundle: nil)
        setupNotifications()
        print("DEBUG - TimerController: Initialized")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = timerView
    }
    
    // MARK: - Timer Control Methods
    func startTimer(duration: TimeInterval) {
        print("DEBUG - TimerController: Starting timer with duration \(duration)")
        timerModel.startTimer(duration: duration)
        startDispatchTimer()  // This starts the periodic updates
        delegate?.timerDidStart()
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
            
            // Get current time components and remaining time separately
            let time = self.timerModel.updateRemainingTime()
            let remainingTime = self.timerModel.remainingTime
            let totalTimeSpent = self.totalTimeSpent
            
            self.delegate?.timerDidUpdate(remainingTime: remainingTime, totalTimeSpent: totalTimeSpent)
            self.timerView.updateRemainingTimeLabel(hours: time.hours, minutes: time.minutes, seconds: time.seconds)
        }
        
        dispatchTimer?.resume()
    }
    
    func pauseTimer() {
        print("DEBUG - TimerController: Pausing timer")
        timerModel.pauseTimer()
        dispatchTimer?.cancel()
        dispatchTimer = nil
        delegate?.timerDidPause()
    }
    
    func resumeTimer() {
        print("DEBUG - TimerController: Resuming timer")
        timerModel.resumeTimer()
        startDispatchTimer()  // Restart periodic updates
        delegate?.timerDidResume()
    }
    
    func stopTimer() {
        print("DEBUG - TimerController: Stopping timer")
        timerModel.stopTimer()
        dispatchTimer?.cancel()
        dispatchTimer = nil
        delegate?.timerDidStop()
    }
    
    // MARK: - App Lifecycle Notifications
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func appDidEnterBackground() {
        if timerModel.isActive {
            print("DEBUG - TimerController: Pausing timer in background")
            timerModel.pauseTimer() // Only pause, don't stop
            dispatchTimer?.cancel()  // Just cancel the UI updates
            dispatchTimer = nil
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
    
    func updateRemainingTime() -> (hours: Int, minutes: Int, seconds: Int) {
        if isTimerActive && !timerModel.isPaused {
            updateTimer()
        }
        
        let hours = Int(remainingTime) / 3600
        let minutes = Int(remainingTime) / 60 % 60
        let seconds = Int(remainingTime) % 60
        
        return (hours, minutes, seconds)
    }
    
    private func updateTimer() {
        guard timerModel.isActive else { 
            print("DEBUG - TimerController: Timer not active, skipping update")
            return 
        }
        
        // Update remaining time and get components
        let time = timerModel.updateRemainingTime()
        print("DEBUG - TimerController: Timer update - Remaining time: \(timerModel.remainingTime)")
        
        if timerModel.remainingTime > 0 {
            updateDisplay(hours: time.hours, minutes: time.minutes, seconds: time.seconds)
            
            // Get the current time spent and log it
            let timeSpent = timerModel.getCurrentTimeSpent()
            
            // Always log usage on each timer update
            reportDataManager.logUsage(
                totalDuration: timeSpent,
                remainingTime: timerModel.remainingTime
            )
            
            // Notify delegate of update
            delegate?.timerDidUpdate(remainingTime: timerModel.remainingTime, totalTimeSpent: timeSpent)
        } else {
            print("DEBUG - TimerController: Timer reached zero")
            stopTimer()
            delegate?.timerDidEnd()
            timerView.displayTimeUp()
        }
    }
    
    private func updateDisplay(hours: Int, minutes: Int, seconds: Int) {
        print("DEBUG - TimerController: Updating display - H:\(hours) M:\(minutes) S:\(seconds)")
        if hours == 0 && minutes == 0 && seconds == 0 {
            timerView.displayTimeUp()
        } else {
            timerView.updateRemainingTimeLabel(hours: hours, minutes: minutes, seconds: seconds)
        }
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
        dispatchTimer = DispatchSource.makeTimerSource(queue: .main)
        dispatchTimer?.schedule(deadline: .now(), repeating: .seconds(1))
        
        dispatchTimer?.setEventHandler { [weak self] in
            self?.updateTimer()
        }
        
        dispatchTimer?.resume()
    }
    
    private func getCurrentTimeComponents() -> (hours: Int, minutes: Int, seconds: Int) {
        let remainingTime = timerModel.remainingTime
        let hours = Int(remainingTime) / 3600
        let minutes = Int(remainingTime) / 60 % 60
        let seconds = Int(remainingTime) % 60
        return (hours: hours, minutes: minutes, seconds: seconds)
    }
    
    func isTimerSetForToday() -> Bool {
        return timerModel.isTimerSetForToday
    }
    
    func shouldResetTimer() -> Bool {
        return timerModel.shouldResetTimer()
    }
    
    // MARK: - State Restoration
    func restoreTimer(remainingTime: TimeInterval, totalTimeSpent: TimeInterval) {
        print("DEBUG - TimerController: Restoring timer with remaining time: \(remainingTime), isActive: \(timerModel.isActive)")
        
        if remainingTime > 0 {
            // First update the model
            timerModel.restoreTimer(remainingTime: remainingTime, totalTimeSpent: totalTimeSpent)
            
            // Update display with current remaining time
            let time = timerModel.updateRemainingTime()
            print("DEBUG - TimerController: Restored time components - H:\(time.hours) M:\(time.minutes) S:\(time.seconds)")
            updateDisplay(hours: time.hours, minutes: time.minutes, seconds: time.seconds)
            
            // Resume the timer
            if timerModel.isActive {
                print("DEBUG - TimerController: Starting dispatch timer after restore")
                startDispatchTimer()
            }
        } else {
            print("DEBUG - TimerController: No remaining time on restore")
            timerModel.stopTimer()
            timerView.displayTimeUp()
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
