//
//  TopView.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 04/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//


import UIKit

protocol TimerViewDelegate: AnyObject {
    func updateClock()
    func timerDidEnd()
}

class TimerView: UIView {
    
    // MARK: - UI Components
    
    private(set) var clockLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppConfiguration.UI.Colors.text
        label.font = UIFont.systemFont(ofSize: AppConfiguration.UI.defaultFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppConfiguration.UI.Colors.text
        label.font = UIFont.systemFont(ofSize: AppConfiguration.UI.defaultFontSize)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: TimerViewDelegate?
    
    // MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup UI Elements
    
    private func setupView() {
        backgroundColor = AppConfiguration.UI.Colors.navigationBar
        
        addSubview(clockLabel)
        addSubview(remainingTimeLabel)
        
        // Set initial text values
        clockLabel.text = "00:00"  // Initial clock value
        remainingTimeLabel.text = "00:00:00"  // Initial timer value
        
        NSLayoutConstraint.activate([
            clockLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppConfiguration.UI.defaultPadding),
            clockLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            remainingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConfiguration.UI.defaultPadding),
            remainingTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func updateRemainingTimeLabel(hours: Int, minutes: Int, seconds: Int) {
        remainingTimeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func displayTimeUp() {
        remainingTimeLabel.text = "Time's Up!"
    }
}
