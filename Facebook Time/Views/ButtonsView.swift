//
//  BottomView.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 02/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit

class ButtonsView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ButtonsViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = AppConfiguration.UI.Colors.navigationBar
        
        let backButton = createButton(withImage: UIImage(systemName: "chevron.backward"), action: #selector(backButtonTapped))
        let homeButton = createButton(withImage: UIImage(systemName: "house"), action: #selector(homeButtonTapped))
        let refreshButton = createButton(withImage: UIImage(systemName: "arrow.clockwise"), action: #selector(refreshButtonTapped))
        let shareButton = createButton(withImage: UIImage(systemName: "square.and.arrow.up"), action: #selector(shareButtonTapped))
        let reportButton = createButton(withImage: UIImage(systemName: "exclamationmark.triangle"), action: #selector(reportButtonTapped))
        let timerPickerButton = createButton(withImage: UIImage(systemName: "timer"), action: #selector(timerPickerButtonTapped))
        
        let stackView = UIStackView(arrangedSubviews: [backButton, homeButton, refreshButton, timerPickerButton, shareButton, reportButton])
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func createButton(withImage image: UIImage?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = AppConfiguration.UI.Colors.text
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc private func backButtonTapped() {
        delegate?.buttonsViewDidRequestBack()
    }
    
    @objc private func homeButtonTapped() {
        delegate?.buttonsViewDidRequestHome()
    }
    
    @objc private func refreshButtonTapped() {
        delegate?.buttonsViewDidRequestRefresh()
    }
    
    @objc private func shareButtonTapped() {
        delegate?.buttonsViewDidRequestShare()
    }
    
    @objc private func reportButtonTapped() {
        delegate?.buttonsViewDidRequestReport()
    }
    
    @objc private func timerPickerButtonTapped() {
        print("ButtonsView: Timer picker button tapped")
        delegate?.buttonsViewDidRequestTimerPicker()
    }
}
