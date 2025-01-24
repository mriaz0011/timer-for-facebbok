//
//  TimerPickerView.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 02/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit

protocol TimerPickerViewDelegate: AnyObject {
    func timerPickerViewDidSelectTime(hours: Int, minutes: Int)
    func timerPickerViewDidCancel()
}

class TimerPickerView: UIView {
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppConfiguration.UI.Colors.background
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    weak var delegate: TimerPickerViewDelegate?
    private let model: TimerPickerModel
    
    init(model: TimerPickerModel = TimerPickerModel()) {
        self.model = model
        super.init(frame: .zero)
        setupView()
        setupPickerView()
        setupToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(pickerView)
        addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44),
            
            pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupToolbar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [cancelButton, flexSpace, doneButton]
    }
    
    @objc private func doneButtonTapped() {
        let hours = pickerView.selectedRow(inComponent: 0)
        let minutes = pickerView.selectedRow(inComponent: 1)
        
        if model.isValidSelection(hours: hours, minutes: minutes) {
            delegate?.timerPickerViewDidSelectTime(hours: hours, minutes: minutes)
        }
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.timerPickerViewDidCancel()
    }
}

extension TimerPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? model.getHoursArray().count : model.getMinutesArray().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row) \(row == 1 ? "hour" : "hours")"
        } else {
            return "\(row) \(row == 1 ? "minute" : "minutes")"
        }
    }
}
