enum AppError: Error {
    case webError(WebError)
    case shareError(Error)
    case timerError(TimerError)
    case dataError(DataError)
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .webError(let error):
            return "Web Error: \(error.localizedDescription)"
        case .shareError(let error):
            return "Share Error: \(error.localizedDescription)"
        case .timerError(let error):
            return "Timer Error: \(error.localizedDescription)"
        case .dataError(let error):
            return "Data Error: \(error.localizedDescription)"
        case .unknown(let error):
            return "Unknown Error: \(error.localizedDescription)"
        }
    }
}

enum WebError: Error {
    case loadingFailed(Error)
    case invalidURL
    case contentNotAvailable
}

enum TimerError: Error {
    case invalidDuration
    case alreadyRunning
    case notRunning
}

enum DataError: Error {
    case saveFailed(Error?)
    case loadFailed(Error?)
    case invalidData
    case persistenceError(Error?)
    
    var localizedDescription: String {
        switch self {
        case .saveFailed(let error):
            return "Failed to save data: \(error?.localizedDescription ?? "Unknown error")"
        case .loadFailed(let error):
            return "Failed to load data: \(error?.localizedDescription ?? "Unknown error")"
        case .invalidData:
            return "The data is invalid or corrupted"
        case .persistenceError(let error):
            return "Failed to persist data: \(error?.localizedDescription ?? "Unknown error")"
        }
    }
} 