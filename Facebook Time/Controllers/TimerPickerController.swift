import UIKit

protocol TimerPickerControllerDelegate: AnyObject {
    func timerPickerDidSelect(duration: TimeInterval)
    func timerPickerDidCancel()
}

class TimerPickerController: UIViewController {
    private let timerModel: TimerModel
    weak var delegate: TimerPickerControllerDelegate?
    private let timerPickerView: TimerPickerView
    
    init(timerModel: TimerModel, delegate: TimerPickerControllerDelegate?) {
        self.timerModel = timerModel
        self.delegate = delegate
        self.timerPickerView = TimerPickerView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = timerPickerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerPickerView.delegate = self
    }
    
    func handleTimerButton() {
        timerModel.loadTimerState()
        
        if timerModel.isExpired {
            AlertManager.showTimeUpAlert(on: self)
            hideTimerPicker()
        } else if timerModel.isTimerSetForToday && !timerModel.shouldResetTimer() {
            AlertManager.showTimeSetAlert(on: self)
            hideTimerPicker()
        } else {
            showTimerPicker()
        }
    }
    
    func didSelectTime(hours: Int, minutes: Int) {
        let duration = TimeInterval(hours * 3600 + minutes * 60)
        if !timerModel.isTimerSetForToday || timerModel.shouldResetTimer() {
            delegate?.timerPickerDidSelect(duration: duration)
        } else {
            AlertManager.showTimeSetAlert(on: self)
            hideTimerPicker()
        }
    }
    
    func showTimerPicker() {
        view.isHidden = false
        timerPickerView.isHidden = false
    }
    
    func hideTimerPicker() {
        view.isHidden = true
        timerPickerView.isHidden = true
    }
    
    func updateUI(isEnabled: Bool) {
        timerPickerView.isUserInteractionEnabled = isEnabled
        timerPickerView.alpha = isEnabled ? 1.0 : 0.5
    }
}

// MARK: - TimerPickerViewDelegate
extension TimerPickerController: TimerPickerViewDelegate {
    func timerPickerViewDidSelectTime(hours: Int, minutes: Int) {
        didSelectTime(hours: hours, minutes: minutes)
        hideTimerPicker()
    }
    
    func timerPickerViewDidCancel() {
        hideTimerPicker()
        delegate?.timerPickerDidCancel()
    }
} 
