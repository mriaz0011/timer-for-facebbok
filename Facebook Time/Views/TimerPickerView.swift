//
//  TimerPickerView.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 02/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit

protocol TimerPickerViewDelegate: AnyObject {
    func timerPickerView(_ pickerView: TimerPickerView, didSelectHour hour: Int, minute: Int)
}

class TimerPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var pickerView: UIPickerView!
    private var toolbar: UIToolbar!
    
    private let hours = Array(0...12) // Array of hours
    private let minutes = Array(0...59) // Array of minutes
    
    private var hoursHeading: UILabel!
    private var minutesHeading: UILabel!
    
    weak var delegate: TimerPickerViewDelegate?
    
    private var selectedHour: Int = 0
    private var selectedMinute: Int = 0
    
    private var hoursBackgroundView: UIView!
    private var minutesBackgroundView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackgroundViews() // First, set up the background views
        setupPickerView() // Then, set up the picker view on top of the background views
        setupToolbar()
        setupHeadings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBackgroundViews() // First, set up the background views
        setupPickerView() // Then, set up the picker view on top of the background views
        setupToolbar()
        setupHeadings()
    }
    
    // MARK: - Setup Picker and Toolbar
    
    private func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pickerView) // Add picker view on top of the background views
        
        // Constraints for the picker view
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupToolbar() {
        toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        // Done button on the toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        addSubview(toolbar)
        
        // Constraints for the toolbar
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: self.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: pickerView.topAnchor)
        ])
    }
    
    // MARK: - Setup Background Views for Hours and Minutes
    
    private func setupBackgroundViews() {
        hoursBackgroundView = UIView()
        minutesBackgroundView = UIView()
        
        // Set the background colors
        hoursBackgroundView.backgroundColor = .white
        minutesBackgroundView.backgroundColor = .lightGray
        
        hoursBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        minutesBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hoursBackgroundView)
        addSubview(minutesBackgroundView)
        
        // Proportional background views for hours and minutes
        NSLayoutConstraint.activate([
            hoursBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hoursBackgroundView.trailingAnchor.constraint(equalTo: self.centerXAnchor),
            hoursBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            hoursBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            minutesBackgroundView.leadingAnchor.constraint(equalTo: self.centerXAnchor),
            minutesBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            minutesBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            minutesBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - Setup Headings (Hours and Minutes)
    
    private func setupHeadings() {
        hoursHeading = UILabel()
        minutesHeading = UILabel()
        
        hoursHeading.text = "Hours"
        minutesHeading.text = "Minutes"
        
        hoursHeading.font = UIFont.boldSystemFont(ofSize: 16)
        minutesHeading.font = UIFont.boldSystemFont(ofSize: 16)
        
        hoursHeading.textAlignment = .left
        minutesHeading.textAlignment = .left
        
        hoursHeading.translatesAutoresizingMaskIntoConstraints = false
        minutesHeading.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hoursHeading)
        addSubview(minutesHeading)
        
        // Constraints for the headings
        NSLayoutConstraint.activate([
            // Hours Heading
            hoursHeading.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            hoursHeading.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 10),
            
            // Minutes Heading
            minutesHeading.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 10),
            minutesHeading.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 10)
        ])
    }
    
    @objc private func doneButtonTapped() {
        if selectedMinute > 0 || selectedHour > 0 {
            delegate?.timerPickerView(self, didSelectHour: selectedHour, minute: selectedMinute)
            self.isHidden = true // Hide after selection
        } else {
            self.isHidden = true // Hide after selection
        }
        
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // Hours and Minutes
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count // Hours
        } else {
            return minutes.count // Minutes
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    // Add labels with transparent background and text "Hour" or "Minute"
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.backgroundColor = .clear // Transparent background

        // Determine whether to use singular or plural based on the row value
        if component == 0 { // Hours
            label.text = row == 1 ? "\(hours[row]) Hour" : "\(hours[row]) Hours" // Singular for 1, plural for others
        } else { // Minutes
            label.text = row == 1 ? "\(minutes[row]) Minute" : "\(minutes[row]) Minutes" // Singular for 1, plural for others
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedHour = hours[row]
        } else {
            selectedMinute = minutes[row]
        }
    }
    
    // Method to show the picker view
    func showPicker() {
        self.isHidden = false
    }
}
