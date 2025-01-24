import UIKit

class GraphView: UIView {
    private var timeSpentData: [TimeInterval] = []
    
    func updateData(_ data: [TimeInterval]) {
        timeSpentData = data
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGraph()
    }
    
    private func drawGraph() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let maxValue = timeSpentData.max() ?? 1
        let width = bounds.width
        let height = bounds.height
        let barWidth = width / CGFloat(timeSpentData.count + 1)
        
        timeSpentData.enumerated().forEach { index, value in
            let barHeight = (CGFloat(value) / CGFloat(maxValue)) * height
            let x = CGFloat(index + 1) * barWidth
            let y = height - barHeight
            
            let barRect = CGRect(x: x, y: y, width: barWidth * 0.8, height: barHeight)
            context.setFillColor(UIColor.blue.cgColor)
            context.fill(barRect)
            
            // Add time label
            let timeString = formatTime(value)
            drawTimeLabel(timeString, at: CGPoint(x: x, y: height - 20))
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) % 3600 / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    private func drawTimeLabel(_ text: String, at point: CGPoint) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.black
        ]
        text.draw(at: point, withAttributes: attributes)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Redraw graph when view layout changes
        if let reportData = UserDefaults.standard.dictionary(forKey: AppConfiguration.UserDefaultsKeys.weekUsageReport) as? [String: Double] {
            drawGraph(reportData: reportData)
        }
    }
    
    // Setup the graph view and axis labels
    func setupGraphView(on view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            self.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // Setup the axis labels (1-12 hours and days of the week)
    func setupAxisLabels(on view: UIView) {
        let hours = Array(1...12)
        for i in hours {
            let label = UILabel()
            label.text = "\(i)h"
            label.font = .systemFont(ofSize: 12)
            label.textColor = .black
            label.textAlignment = .right
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            let yPosition = self.frame.height - (CGFloat(i) * (self.frame.height / 12.0))
            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: -5),
                label.centerYAnchor.constraint(equalTo: self.topAnchor, constant: yPosition),
                label.widthAnchor.constraint(equalToConstant: 25)
            ])
        }
        
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        for (index, day) in days.enumerated() {
            let label = UILabel()
            label.text = day
            label.font = .systemFont(ofSize: 10)
            label.textColor = .black
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
