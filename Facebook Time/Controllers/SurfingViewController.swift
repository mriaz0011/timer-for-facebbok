//
//  SurfingViewController.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 02/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//


import UIKit
import WebKit

protocol BottomViewDelegate: AnyObject {
    func bottomView(_ bottomView: BottomView, didTapButtonWith tag: Int)
}

class SurfingViewController: UIViewController {

    let topView = TopView() // Custom top view with clock and timer
    private let webView = WKWebView() // Middle section for web content
    private let bottomView = BottomView() // Custom bottom view with buttons
    private let stackView = UIStackView() // StackView to arrange the views
    private var timerPickerView: TimerPickerView! // Timer Picker view

    // Timer model to handle business logic
    let timerModel = TimerModel()
    private var dispatchTimer: DispatchSourceTimer?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        setupStackView()
        setupTopView()
        setupWebView()
        setupBottomView()
        setupTimerPickerView()

        checkForNewDay()
        
        loadWebContent()

        NotificationCenter.default.addObserver(self, selector: #selector(onReportDataUpdated), name: NSNotification.Name("ReportDataUpdated"), object: nil)
    }

    // MARK: - Hide Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupTopView() {
        topView.delegate = self
        stackView.addArrangedSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupWebView() {
        webView.layer.borderColor = UIColor.lightGray.cgColor
        webView.layer.borderWidth = 1
        stackView.addArrangedSubview(webView)
    }

    private func setupBottomView() {
        bottomView.delegate = self
        stackView.addArrangedSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func setupTimerPickerView() {
        timerPickerView = TimerPickerView()
        timerPickerView.translatesAutoresizingMaskIntoConstraints = false
        timerPickerView.delegate = self
        timerPickerView.isHidden = true
        view.addSubview(timerPickerView)
        NSLayoutConstraint.activate([
            timerPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timerPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timerPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Timer Logic

    func startTimer(duration: TimeInterval) {
        timerModel.totalDuration = duration
        timerModel.remainingTime = duration
        timerModel.saveTimerState(remainingTime: timerModel.remainingTime)
        startDispatchTimer()
    }

    private func startDispatchTimer() {
        dispatchTimer?.cancel() // Cancel previous timer if any
        dispatchTimer = DispatchSource.makeTimerSource()
        dispatchTimer?.schedule(deadline: .now(), repeating: 1.0)
        dispatchTimer?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.updateTimer()
            }
        }
        dispatchTimer?.resume()
    }

    private func updateTimer() {
        if timerModel.remainingTime > 0 {
            let hours = Int(timerModel.remainingTime) / 3600
            let minutes = (Int(timerModel.remainingTime) % 3600) / 60
            let seconds = Int(timerModel.remainingTime) % 60
            topView.updateRemainingTimeLabel(hours: hours, minutes: minutes, seconds: seconds)
            timerModel.remainingTime -= 1
        } else {
            dispatchTimer?.cancel()
            topView.displayTimeUp()
            timerModel.logTimeSpent()
            loadWebContent()
        }
    }

    // Save the current timer state before background or termination
    func saveTimerState() {
        if timerModel.isTimerSetForToday() {
            timerModel.saveTimerState(remainingTime: timerModel.remainingTime)
        }
    }

    // Resume the saved timer state
    func resumeTimerState() {
        if timerModel.isTimerSetForToday() {
            timerModel.loadTimerState()
            if timerModel.remainingTime > 0 {
                startDispatchTimer()
            } else {
                topView.displayTimeUp()
            }
        }
    }

    // Reset timer for a new day
    private func checkForNewDay() {
        timerModel.resetForNewDay()
        if timerModel.isTimerSetForToday() {
            resumeTimerState()
        }
    }

    // MARK: - Load Web Content

    private func loadWebContent() {
        if timerModel.isTimerSetForToday() {
            print(timerModel.remainingTime)
            if timerModel.remainingTime > 0 {
                if let url = URL(string: "https://www.facebook.com") {
                    webView.load(URLRequest(url: url))
                }
            } else {
                showTimeOverMessage()
            }
        } else {
            showSetTimerMessage()
        }
    }

    private func showTimeOverMessage() {
        let htmlMessage = """
            <html>
            <body style="font-family: Arial; text-align: center; padding: 50px;">
            <h1>Your today's set time is over.</h1>
            <h3>You can use Facebook again tomorrow.</h3>
            </body>
            </html>
            """
        webView.loadHTMLString(htmlMessage, baseURL: nil)
    }

    private func showSetTimerMessage() {
        let htmlMessage = """
            <html>
            <body style="font-family: Arial; text-align: center; padding: 50px;">
            <h1>Set today's time.</h1>
            <h3>You can use Facebook once you set today's timer.</h3>
            </body>
            </html>
            """
        webView.loadHTMLString(htmlMessage, baseURL: nil)
    }

    @objc private func onReportDataUpdated() {
        print("Report data has been updated")
    }
}

extension SurfingViewController: BottomViewDelegate {
    // MARK: - BottomView Delegate Methods

    func bottomView(_ bottomView: BottomView, didTapButtonWith tag: Int) {
        switch tag {
        case 1: // Refresh button tapped
            webView.reload()
        case 2: // Home button tapped
            loadWebContent()
        case 3: // Back button tapped
            handleBackButton()
        case 4: // Share button tapped
            shareCurrentApp()
            break
        case 5: // Timer button tapped
            handleTimerButton()
        case 6: // Report button tapped
            presentReportViewController()
        default:
            break
        }
    }
    
    private func handleBackButton() {
        // Check if the webView can go back in the browsing history
        if webView.canGoBack {
            webView.goBack() // Navigate to the previous page in the webView's history
        } else {
            // If there's no history to go back to, show an alert or take an alternative action
            AlertManager.showNoHistoryAlert(on: self) // This can be a custom alert method to notify the user
        }
    }
    
    // MARK: - Share Action
    
    private func shareCurrentApp() {
        let message = "Check out this amazing app! Timer for Facebook. Get it from the App Store using the link below:"
        
        // Include the App Store URL
        if let urlToShare = URL(string: "https://apps.apple.com/gb/app/timer-for-facebook/id1150466189") {
            let items: [Any] = [message, urlToShare] // Combine the message and the URL
            
            // Initialize the UIActivityViewController
            let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            
            // Exclude certain activity types (optional)
            activityViewController.excludedActivityTypes = [.print, .assignToContact, .saveToCameraRoll, .addToReadingList]
            
            // On iPad, set up the presentation as a popover to avoid crashes
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = self.view // Specify where the popover should appear
                popoverController.permittedArrowDirections = .any
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // Centered popover
            }
            
            // Present the activity view controller
            present(activityViewController, animated: true, completion: nil)
        } else {
            // If URL creation fails, show an alert
            AlertManager.shareErrorAlert(on: self)
        }
    }

    private func presentReportViewController() {
        let reportVC = ReportViewController()
        reportVC.modalPresentationStyle = .fullScreen
        let navController = UINavigationController(rootViewController: reportVC)
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Timer Picker Handling
    
    private func handleTimerButton() {
        if timerModel.isTimerSetForToday() {
            if timerModel.remainingTime > 0 {
                AlertManager.showTimeSetAlert(on: self)
            } else {
                AlertManager.showSetTimeTomorrowAlert(on: self)
            }
        } else {
            if timerModel.remainingTime > 0 {
                AlertManager.showTimeSetAlert(on: self)
            } else {
                timerPickerView.showPicker() // Show the timer picker when the timer button is tapped
            }
        }
    }
}

extension SurfingViewController: TimerPickerViewDelegate {
    func timerPickerView(_ pickerView: TimerPickerView, didSelectHour hour: Int, minute: Int) {
        let duration = TimeInterval(hour * 3600 + minute * 60)
        startTimer(duration: duration)
        loadWebContent()
    }
}

extension SurfingViewController: TopViewDelegate {
    // MARK: - TopViewDelegate Methods
    
    func timerDidEnd() {
        // Handle the timer ending event
        timerModel.logTimeSpent() // Log the time spent when the timer ends
        dispatchTimer?.cancel()
        timerModel.remainingTime = 0.0
        timerModel.resetForNewDay()
        topView.displayTimeUp()
        loadWebContent()
    }
}
