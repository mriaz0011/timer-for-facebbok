//
//  TopView.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 04/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//


import UIKit

protocol TopViewDelegate: AnyObject {
    func timerDidEnd()
}

class TopView: UIView {
    
    // MARK: - Properties
    
    private let clockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: TopViewDelegate?
    private var clockTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        startClock()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        startClock()
    }
    
    // MARK: - Setup UI Elements
    
    private func setupView() {
        self.backgroundColor = .orange
        
        self.addSubview(clockLabel)
        self.addSubview(remainingTimeLabel)
        
        NSLayoutConstraint.activate([
            clockLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            clockLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            remainingTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            remainingTimeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // MARK: - Clock Management
    
    private func startClock() {
        updateClock() // Initial clock update
        clockTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            self.updateClock()
        }
    }
    
    private func updateClock() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // Time format like 03:54 PM
        let currentTime = dateFormatter.string(from: Date())
        
        clockLabel.text = currentTime // Update the clock label

        // Check if it's exactly 12:00 AM (Midnight)
        if currentTime == "12:00 AM" {
            print("It's midnight, resetting timer for a new day.")
            delegate?.timerDidEnd() // Notify the controller about midnight to reset the timer.
        }
    }
    
    // MARK: - Update Remaining Time UI
    
    func updateRemainingTimeLabel(hours: Int, minutes: Int, seconds: Int) {
        remainingTimeLabel.text = String(format: "- %02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func displayTimeUp() {
        remainingTimeLabel.text = "Time's up!" // Update the label to show that the timer is up
    }
}
