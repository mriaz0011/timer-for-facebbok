import UIKit

class ViewLayoutManager {
    static func setupStackViewConstraints(_ stackView: UIStackView, in view: UIView) {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    static func setupTimerViewConstraints(_ timerView: TimerView) {
        NSLayoutConstraint.activate([
            timerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    static func setupBottomViewConstraints(_ bottomView: ButtonsView) {
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    static func setupTimerPickerViewConstraints(_ pickerView: UIView, in view: UIView) {
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
} 
