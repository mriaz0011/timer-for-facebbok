import UIKit

struct SurfingViewControllerDependencies {
    let navigationController: UINavigationController
    let timerController: TimerController
    let webContentController: WebContentController
    let timerPickerController: TimerPickerController
    let analyticsModel: AnalyticsModel
    let buttonsController: ButtonsController
    
    static func createDefault() -> SurfingViewControllerDependencies {
        let timerModel = TimerModel()
        let timerView = TimerView()
        let webContentModel = WebContentModel()
        let analyticsModel = AnalyticsModel()
        let buttonsController = ButtonsController()
        let reportDataManager = ReportDataManager(persistenceManager: UserDefaults.standard, delegate: nil)
        
        return SurfingViewControllerDependencies(
            navigationController: UINavigationController(),
            timerController: TimerController(
                timerView: timerView, timerModel: timerModel,
                reportDataManager: reportDataManager
            ),
            webContentController: WebContentController(webContentModel: webContentModel),
            timerPickerController: TimerPickerController(timerModel: timerModel, delegate: nil),
            analyticsModel: analyticsModel,
            buttonsController: buttonsController
        )
    }
} 
