//
//  ReportGraphView.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 04/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit

class ReportGraphView: UIView {
    
    // Setup the graph view and axis labels
    func setupGraphView(on view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .lightGray
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            self.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // Setup the axis labels (1-12 hours and days of the week)
    func setupAxisLabels(on view: UIView) {
        let hours = Array(1...12)
        for i in hours {
            let label = UILabel()
            label.text = "\(i)"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            let yPosition = self.frame.height - (CGFloat(i) * (self.frame.height / 12.0))
            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: -5),
                label.centerYAnchor.constraint(equalTo: self.topAnchor, constant: yPosition)
            ])
        }
        
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        for (index, day) in days.enumerated() {
            let label = UILabel()
            label.text = day
            label.font = UIFont.systemFont(ofSize: 10)
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            let xPosition = CGFloat(index) * (self.frame.width / CGFloat(days.count - 1))
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: xPosition),
                label.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 20),
                label.widthAnchor.constraint(lessThanOrEqualToConstant: 60)
            ])
        }
    }
    
    // Draw the graph based on the report data
    func drawGraph(reportData: [String: Double]) {
        print("Report Data: \(reportData)") // Add this line to check the data
        let graphLayer = CAShapeLayer()
        let graphPath = UIBezierPath()

        let graphWidth = self.frame.width
        let graphHeight = self.frame.height
        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        let maxHours: CGFloat = 12.0
        self.layoutIfNeeded()

        let daySpacing = graphWidth / CGFloat(days.count - 1)
        graphPath.move(to: CGPoint(x: 0, y: graphHeight))

        for (index, day) in days.enumerated() {
            let timeSpentInSeconds = reportData[day] ?? 0
            let timeSpentInHours = CGFloat(timeSpentInSeconds) / 3600.0
            let yPosition = graphHeight - (timeSpentInHours / maxHours * graphHeight)
            let xPosition = CGFloat(index) * daySpacing
            graphPath.addLine(to: CGPoint(x: xPosition, y: yPosition))
        }

        graphLayer.path = graphPath.cgPath
        graphLayer.strokeColor = UIColor.orange.cgColor
        graphLayer.lineWidth = 2
        graphLayer.fillColor = UIColor.clear.cgColor
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layer.addSublayer(graphLayer)
    }
}
