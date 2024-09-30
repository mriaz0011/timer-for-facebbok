//
//  ReportViewController.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 04/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
    private let reportGraphView = ReportGraphView()
    private let reportModel = ReportModel() // Initialize the model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        
        reportGraphView.setupGraphView(on: view) // Setup graph view
        view.layoutIfNeeded() // Ensure layout is updated
        
        reportGraphView.setupAxisLabels(on: view) // Setup axis labels
        
        reportGraphView.drawGraph(reportData: reportModel.reportData) // Draw graph
    }
    
    // Setup the navigation bar
    private func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .orange
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.isTranslucent = false
        }

        self.title = "Week Report"
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
