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
    
    weak var delegate: BottomViewDelegate?
    
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
        self.backgroundColor = .orange
        
        // Buttons for refresh, home, back, share, timer, and report
        let refreshButton = createButton(withImage: UIImage(systemName: "arrow.clockwise"), tag: 1)
        let homeButton = createButton(withImage: UIImage(systemName: "house"), tag: 2)
        let backButton = createButton(withImage: UIImage(systemName: "chevron.backward"), tag: 3)
        let shareButton = createButton(withImage: UIImage(systemName: "square.and.arrow.up"), tag: 4)
        let timerButton = createButton(withImage: UIImage(systemName: "timer"), tag: 5)
        let reportButton = createButton(withImage: UIImage(systemName: "doc.text.magnifyingglass"), tag: 6)
        
        // Add the buttons to a horizontal stack view
        let buttonStackView = UIStackView(arrangedSubviews: [refreshButton, homeButton, backButton, shareButton, timerButton, reportButton])
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .equalSpacing
        buttonStackView.spacing = 20
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonStackView)
        
        // Constraints for the button stack view
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            buttonStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        ])
    }
    
    // Helper method to create a button with a given image and add action
    private func createButton(withImage image: UIImage?, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Add target to handle button tap
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Button Actions
    
    @objc private func buttonTapped(_ sender: UIButton) {
        // Notify the delegate about which button was tapped using its tag
        delegate?.bottomView(self, didTapButtonWith: sender.tag)
    }
}
