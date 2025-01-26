import UIKit

struct AppConfiguration {
    static let shared = AppConfiguration()
    
    // UserDefaults keys
    struct UserDefaultsKeys {
        static let timerDuration = "timerDuration"
        static let totalTimeSpent = "totalTimeSpent"
        static let timerSetDate = "timerSetDate"
        static let timerSetForToday = "timerSetForToday"
        static let weekUsageReport = "WeekUsageReport"
        static let lastPauseDate = "lastPauseDate"
        static let timerIsActive = "timerIsActive"
    }
    
    // UI Configuration
    struct UI {
        static let topViewHeight: CGFloat = 60
        static let bottomViewHeight: CGFloat = 70
        static let defaultFontSize: CGFloat = 14
        static let defaultPadding: CGFloat = 20
        static let NavigationHeight: CGFloat = 44
        static let TimerHeight: CGFloat = 50
        
        struct Colors {
            // Primary Colors
            static let primary = UIColor.orange
            
            // UI Elements
            static let navigationBar = primary
            static let background = UIColor.systemBackground
            static let text = UIColor.label
            static let border = UIColor.separator
            
            // Timer specific
            static let timerBackground = primary
            static let timerText = UIColor.white
            static let clockText = UIColor.white
            
            // Picker specific
            static let pickerBackground = UIColor.systemBackground
            static let pickerText = primary
            
            // Button specific
            static let buttonBackground = primary
            static let buttonTint = UIColor.white
            
            // Web specific
            static let webViewBackground = UIColor.systemBackground
            
            // Separator
            static let separator = UIColor.separator
        }
    }
    
    // Web Configuration
    struct Web {
        static let facebookURL = "https://www.facebook.com"
        static let timeOverMessage = """
                <html>
                <head>
                    <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
                    <style>
                        body {
                            font-family: -apple-system, system-ui;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            height: 100vh;
                            margin: 0;
                            background-color: white;
                            color: black;
                        }
                        h1 { font-size: 24px; }
                    </style>
                </head>
                <body>
                    <h1>Time's Up!</h1>
                </body>
                </html>
                """
        static let setTimerMessage = """
                <html>
                <head>
                    <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
                    <style>
                        body {
                            font-family: -apple-system, system-ui;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            height: 100vh;
                            margin: 0;
                            background-color: white;
                            color: black;
                        }
                        h1 { font-size: 24px; }
                    </style>
                </head>
                <body>
                    <h1>Set today's time.</h1>
                </body>
                </html>
                """
    }
    
    // Timer Configuration
    struct Timer {
        static let maxDailyTime: TimeInterval = 3600 * 3 // 2 hours
        static let defaultDuration: TimeInterval = 1800 // 30 minutes
    }
} 
