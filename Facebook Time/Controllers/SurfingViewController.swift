//
//  SurfingViewController.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 02/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//


import UIKit
import WebKit

final class SurfingViewController: UIViewController {
    // MARK: - Properties
    private let containerView: SurfingContainerView
    private let buttonsController: ButtonsController
    var timerController: TimerController
    private let webContentController: WebContentController
    private let analyticsModel: AnalyticsModel
    private let activityTracker: ActivityTracker
    private let timerPickerController: TimerPickerController
    private let shareController: ShareController
    
    // MARK: - Public Properties
    var isTimerActive: Bool {
        return timerController.isTimerActive
    }
    
    var remainingTime: TimeInterval {
        return timerController.remainingTime
    }
    
    var totalTimeSpent: TimeInterval {
        return timerController.totalTimeSpent
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return nil
    }
    
    // MARK: - Initialization
    init(dependencies: SurfingViewControllerDependencies) {
        self.containerView = SurfingContainerView()
        self.buttonsController = dependencies.buttonsController
        self.timerController = dependencies.timerController
        self.webContentController = dependencies.webContentController
        self.analyticsModel = dependencies.analyticsModel
        self.timerPickerController = dependencies.timerPickerController
        self.activityTracker = ActivityTracker(analyticsModel: dependencies.analyticsModel)
        self.shareController = ShareController(webContentModel: webContentController.webContentModel, delegate: nil)
        
        super.init(nibName: nil, bundle: nil)
        
        shareController.delegate = self
        setupChildControllers()
        setupDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        applyTheme()
        setupInitialState()
    }
    
    // MARK: - Setup
    private func setupChildControllers() {
        addChild(timerController)
        addChild(webContentController)
        addChild(buttonsController)
        addChild(timerPickerController)
        
        containerView.addTimerView(timerController.timerView)
        containerView.addButtonsView(buttonsController.buttonsView)
        containerView.addWebContentView(webContentController.webContentView)
        containerView.addTimerPickerView(timerPickerController.view)
        
        timerController.didMove(toParent: self)
        webContentController.didMove(toParent: self)
        buttonsController.didMove(toParent: self)
        timerPickerController.didMove(toParent: self)
        
        timerPickerController.view.isHidden = true
    }
    
    private func setupDelegates() {
        buttonsController.delegate = self
        timerController.delegate = self
        webContentController.delegate = self
        timerPickerController.delegate = self
    }
    
    private func setupInitialState() {
        // Start with timer picker hidden
        containerView.showTimerPicker(false)
        timerPickerController.view.isHidden = true
        
        // Check timer state and update web content accordingly
        if timerController.shouldResetTimer() {
            // New day - show set timer message
            webContentController.updateContent(timerActive: false, timerExpired: false)
        } else if timerController.isTimerSetForToday() {
            if timerController.remainingTime > 0 {
                timerController.resumeTimer()
                webContentController.loadHomePage()
            } else {
                // Time's up for today
                webContentController.updateContent(timerActive: true, timerExpired: true)
            }
        }
    }
    
    // MARK: - Theme
    private func applyTheme() {
        let theme = ThemeManager.shared.currentTheme
        view.backgroundColor = theme.backgroundColor
        containerView.backgroundColor = theme.backgroundColor
    }
    
    // MARK: - UI State
    private func updateUIState(isTimerActive: Bool) {
        containerView.showTimerPicker(!isTimerActive)
        webContentController.updateContentBasedOnTimer(
            isActive: isTimerActive,
            remainingTime: timerController.remainingTime
        )
        
        if isTimerActive {
            analyticsModel.trackEvent(.timerSet(duration: timerController.remainingTime))
        }
    }
    
    // MARK: - State Restoration
    func restoreState(isTimerActive: Bool, remainingTime: TimeInterval, totalTimeSpent: TimeInterval) {
        if timerController.shouldResetTimer() {
            // New day - reset timer state but keep total time spent
            timerController.restoreTimer(remainingTime: 0, totalTimeSpent: totalTimeSpent)
            containerView.showTimerPicker(true)
            updateUIState(isTimerActive: false)
            webContentController.updateContent(timerActive: false, timerExpired: false)
        } else {
            // Same day - restore previous state
            timerController.restoreTimer(remainingTime: remainingTime, totalTimeSpent: totalTimeSpent)
            containerView.showTimerPicker(!isTimerActive)
            updateUIState(isTimerActive: isTimerActive)
            
            if remainingTime > 0 {
                webContentController.updateRemainingTime(remainingTime, totalSpent: totalTimeSpent)
                if isTimerActive {
                    timerController.resumeTimer()
                }
            } else {
                webContentController.updateContent(timerActive: true, timerExpired: true)
            }
        }
    }
    
    func showTimerPicker() {
        containerView.showTimerPicker(true)
    }
    
    func hideTimerPicker() {
        containerView.showTimerPicker(false)
    }
    
    func pauseTimer() {
        if timerController.isTimerActive {
            timerController.pauseTimer()
        }
    }
    
    private func setupTimerController() {
        timerController.delegate = self
        print("DEBUG - SurfingViewController: Timer controller setup complete")
    }
}

// MARK: - ButtonsControllerDelegate
extension SurfingViewController: ButtonsControllerDelegate {
    func buttonsControllerDidRequestBack() {
        if timerController.isTimerActive && timerController.remainingTime > 0 {
            webContentController.goBack()
        }
    }
    
    func buttonsControllerDidRequestHome() {
        if timerController.isTimerActive && timerController.remainingTime > 0 {
            webContentController.loadHomePage()
        }
    }
    
    func buttonsControllerDidRequestRefresh() {
        if timerController.isTimerActive && timerController.remainingTime > 0 {
            webContentController.reload()
        }
    }
    
    func buttonsControllerDidRequestShare() {
        shareController.presentShareSheet(on: self)
    }
    
    func buttonsControllerDidRequestReport() {
        presentReportViewController()
    }
    
    func buttonsControllerDidRequestTimerPicker() {
        if timerController.isTimerActive {
            if timerController.remainingTime > 0 {
                AlertManager.showTimeSetAlert(on: self)
            } else {
                AlertManager.showTimeUpAlert(on: self)
            }            
            return
        }
        
        containerView.showTimerPicker(true)
        timerPickerController.showTimerPicker()
    }
}

// MARK: - TimerControllerDelegate
extension SurfingViewController: TimerControllerDelegate {
    func timerDidStart() {
        print("DEBUG - SurfingViewController: Timer started")
        updateUIState(isTimerActive: true)
        webContentController.updateContent(timerActive: true, timerExpired: false)
    }
    
    func timerDidPause() {
        print("DEBUG - SurfingViewController: Timer paused")
        updateUIState(isTimerActive: false)
    }
    
    func timerDidResume() {
        print("DEBUG - SurfingViewController: Timer resumed")
        updateUIState(isTimerActive: true)
    }
    
    func timerDidStop() {
        print("DEBUG - SurfingViewController: Timer stopped")
        updateUIState(isTimerActive: false)
        webContentController.updateContent(timerActive: false, timerExpired: true)
    }
    
    func timerDidEnd() {
        print("DEBUG - SurfingViewController: Timer ended")
        updateUIState(isTimerActive: false)
        webContentController.updateContent(timerActive: false, timerExpired: true)
    }
    
    func timerDidUpdate(remainingTime: TimeInterval, totalTimeSpent: TimeInterval) {
        print("DEBUG - SurfingViewController: Timer updated - Remaining: \(remainingTime), Total spent: \(totalTimeSpent)")
        webContentController.updateRemainingTime(remainingTime, totalSpent: totalTimeSpent)
    }
}

// MARK: - WebContentControllerDelegate
extension SurfingViewController: WebContentControllerDelegate {
    func webContentControllerDidFinishLoading() {
        analyticsModel.trackEvent(.webContentLoaded)
        updateUIState(isTimerActive: timerController.isTimerActive)
    }
    
    func webContentControllerDidFailLoading(with error: Error) {
        handleError(error)
        analyticsModel.trackEvent(.webContentLoadingFailed(error))
    }
}

// MARK: - TimerPickerControllerDelegate
extension SurfingViewController: TimerPickerControllerDelegate {
    func timerPickerDidSelect(duration: TimeInterval) {
        containerView.showTimerPicker(false)
        timerController.startTimer(duration: duration)
    }
    
    func timerPickerDidCancel() {
        containerView.showTimerPicker(false)
    }
}

// MARK: - ShareControllerDelegate
extension SurfingViewController: ShareControllerDelegate {
    func shareController(_ controller: ShareController, didShareContent content: Any) {
        analyticsModel.trackEvent(.shareAttempted)
    }
    
    func shareController(_ controller: ShareController, didFailWithError error: Error) {
        handleError(error)
        analyticsModel.trackEvent(.error(.shareError(error)))
    }
}

// MARK: - Private Methods
private extension SurfingViewController {
    private func presentReportViewController() {
        let reportController = ReportController()
        let reportVC = ReportViewController(reportController: reportController)
        let navigationController = UINavigationController(rootViewController: reportVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func handleError(_ error: Error) {
        switch error {
        case let dataError as DataError:
            AlertManager.showAlert(.error(dataError), on: self)
        case let timerError as TimerError:
            AlertManager.showAlert(.timerError(timerError), on: self)
        case let webError as WebError:
            AlertManager.showAlert(.webError(webError), on: self)
        case let appError as AppError:
            AlertManager.showAlert(.error(appError), on: self)
        default:
            let dataError = DataError.saveFailed(error)
            AlertManager.showAlert(.error(dataError), on: self)
        }
    }
}



