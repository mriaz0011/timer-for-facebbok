import UIKit
import WebKit

class ViewFactory {
    static func createTimerView() -> TimerView {
        let timerView = TimerView()
        timerView.translatesAutoresizingMaskIntoConstraints = false
        return timerView
    }
    
    static func createWebContentView() -> WebContentView {
        let webContentView = WebContentView()
        webContentView.translatesAutoresizingMaskIntoConstraints = false
        return webContentView
    }
    
    static func createTimerPickerView() -> TimerPickerView {
        let pickerView = TimerPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.isHidden = true
        return pickerView
    }
    
    static func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    static func createButtonsView() -> ButtonsView {
        let buttonsView = ButtonsView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsView
    }
} 
