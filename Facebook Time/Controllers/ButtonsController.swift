import UIKit
import WebKit

protocol ButtonsControllerDelegate: AnyObject {
    func buttonsControllerDidRequestBack()
    func buttonsControllerDidRequestHome()
    func buttonsControllerDidRequestRefresh()
    func buttonsControllerDidRequestShare()
    func buttonsControllerDidRequestReport()
    func buttonsControllerDidRequestTimerPicker()
}

protocol ButtonsViewDelegate: AnyObject {
    func buttonsViewDidRequestBack()
    func buttonsViewDidRequestHome()
    func buttonsViewDidRequestRefresh()
    func buttonsViewDidRequestShare()
    func buttonsViewDidRequestReport()
    func buttonsViewDidRequestTimerPicker()
}

class ButtonsController: UIViewController {
    let buttonsView: ButtonsView
    weak var delegate: ButtonsControllerDelegate?
    
    init() {
        self.buttonsView = ViewFactory.createButtonsView()
        super.init(nibName: nil, bundle: nil)
        self.buttonsView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = buttonsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ButtonsController: ButtonsViewDelegate {
    func buttonsViewDidRequestBack() {
        delegate?.buttonsControllerDidRequestBack()
    }
    
    func buttonsViewDidRequestHome() {
        delegate?.buttonsControllerDidRequestHome()
    }
    
    func buttonsViewDidRequestRefresh() {
        delegate?.buttonsControllerDidRequestRefresh()
    }
    
    func buttonsViewDidRequestShare() {
        delegate?.buttonsControllerDidRequestShare()
    }
    
    func buttonsViewDidRequestReport() {
        delegate?.buttonsControllerDidRequestReport()
    }
    
    func buttonsViewDidRequestTimerPicker() {
        delegate?.buttonsControllerDidRequestTimerPicker()
    }
}

extension ButtonsController {
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.buttonsView.alpha = hidden ? 0 : 1
            }
        } else {
            self.buttonsView.alpha = hidden ? 0 : 1
        }
    }
    
    func updateTime(_ timeString: String) {
        // Time is now handled by TimerView
    }
} 
