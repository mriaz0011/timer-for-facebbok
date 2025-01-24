import UIKit

protocol ReportControllerDelegate: AnyObject {
    func reportDataDidUpdate(_ data: ReportData)
}

struct ReportData {
    let totalTimeSpent: TimeInterval
    let dailyUsage: [Date: TimeInterval]
    let averageDailyUsage: TimeInterval
    let mostUsedDay: Date?
    let leastUsedDay: Date?
}

class ReportController: NotificationObserver {
    // MARK: - Properties
    private let reportModel: ReportModel
    private lazy var notificationManager = NotificationManager(observer: self)
    weak var delegate: ReportControllerDelegate?
    
    // MARK: - Initialization
    init(reportModel: ReportModel = ReportModel()) {
        self.reportModel = reportModel
        setupNotifications()
    }
    
    // MARK: - Public Methods
    func refresh() {
        reportModel.refresh()
        notifyDataUpdate()
    }
    
    // MARK: - Private Methods
    private func setupNotifications() {
        notificationManager.observe(.usageStatsDidUpdate) { [weak self] _ in
            self?.refresh()
        }
    }
    
    private func notifyDataUpdate() {
        let reportData = ReportData(
            totalTimeSpent: reportModel.totalTimeSpent,
            dailyUsage: reportModel.dailyUsage,
            averageDailyUsage: reportModel.averageDailyUsage(),
            mostUsedDay: reportModel.mostUsedDay(),
            leastUsedDay: reportModel.leastUsedDay()
        )
        
        delegate?.reportDataDidUpdate(reportData)
    }
    
    // MARK: - NotificationObserver
    func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .usageStatsDidUpdate:
            refresh()
        default:
            break
        }
    }
}
