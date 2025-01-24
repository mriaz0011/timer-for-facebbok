import Foundation

enum LogLevel: Int {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    
    var prefix: String {
        switch self {
        case .debug: return "🔍 DEBUG"
        case .info: return "ℹ️ INFO"
        case .warning: return "⚠️ WARNING"
        case .error: return "❌ ERROR"
        }
    }
}

class Logger {
    static let shared = Logger()
    private let dateFormatter: DateFormatter
    
    #if DEBUG
    private var minimumLogLevel: LogLevel = .debug
    #else
    private var minimumLogLevel: LogLevel = .info
    #endif
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    func log(_ message: String, level: LogLevel, file: String = #file, function: String = #function, line: Int = #line) {
        guard level.rawValue >= minimumLogLevel.rawValue else { return }
        
        let timestamp = dateFormatter.string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        
        let logMessage = "\(timestamp) \(level.prefix) [\(fileName):\(line)] \(function): \(message)"
        
        #if DEBUG
        print(logMessage)
        #endif
        
        // Save log to file or send to logging service
        saveLog(logMessage)
    }
    
    private func saveLog(_ message: String) {
        // Implementation for saving logs
    }
}

// Convenience functions
func logDebug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.log(message, level: .debug, file: file, function: function, line: line)
}

func logInfo(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.log(message, level: .info, file: file, function: function, line: line)
}

func logWarning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.log(message, level: .warning, file: file, function: function, line: line)
}

func logError(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.log(message, level: .error, file: file, function: function, line: line)
} 