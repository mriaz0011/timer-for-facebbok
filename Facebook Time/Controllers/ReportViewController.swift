//
//  ReportViewController.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 04/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    private let graphView = GraphView()
    private let reportController: ReportController
    
    init(reportController: ReportController = ReportController()) {
        self.reportController = reportController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        
        graphView.setupGraphView(on: view)
        view.layoutIfNeeded()
        graphView.setupAxisLabels(on: view)
        
        // Immediately load and display data
        reportController.delegate = self
        reportController.refresh()
        
        setupNotifications()
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTimeUpdate),
            name: .usageStatsDidUpdate,
            object: nil
        )
    }
    
    @objc private func handleTimeUpdate() {
        updateGraph()
    }
    
    private func updateGraph() {
       reportController.refresh()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func formatDataForGraph(_ dailyUsage: [Date: TimeInterval]) -> [String: Double] {
        print("ReportViewController - Formatting data: \(dailyUsage)")
        var formattedData: [String: Double] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Full day name
        
        for (date, duration) in dailyUsage {
            let dayName = dateFormatter.string(from: date)
            formattedData[dayName] = Double(duration)
            print("ReportViewController - Day: \(dayName), Duration: \(duration)")
        }
        return formattedData
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppConfiguration.UI.Colors.navigationBar
        appearance.titleTextAttributes = [.foregroundColor: AppConfiguration.UI.Colors.text]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = AppConfiguration.UI.Colors.text
        navigationItem.leftBarButtonItem = backButton
        
        title = "Usage Report"
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - ReportControllerDelegate
extension ReportViewController: ReportControllerDelegate {
    func reportDataDidUpdate(_ data: ReportData) {
        let formattedData = formatDataForGraph(data.dailyUsage)
        graphView.drawGraph(reportData: formattedData)
    }
}
