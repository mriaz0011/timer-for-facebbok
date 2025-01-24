import Foundation

struct AppState: Codable {
    let isTimerActive: Bool
    let remainingTime: TimeInterval
    let totalTimeSpent: TimeInterval
    let lastActiveDate: Date
}

extension AppState: DataStorable {
    static var storageKey: String { return "app_state" }
}

class AppStateModel {
    private let dataStore: DataStoreModel
    
    init(dataStore: DataStoreModel = DataStoreModel()) {
        self.dataStore = dataStore
    }
    
    func saveAppState(_ state: AppState) {
        try? dataStore.save(state)
    }
    
    func loadAppState() -> AppState? {
        try? dataStore.load(AppState.self)
    }
    
    func clearAppState() {
        try? dataStore.delete(AppState.self)
    }
} 