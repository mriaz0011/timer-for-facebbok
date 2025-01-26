import Foundation

struct AppState: Codable {
    let isTimerActive: Bool
    let remainingTime: TimeInterval
    let totalTimeSpent: TimeInterval
    let lastActiveDate: Date
}

class AppStateModel {
    private let persistenceManager: PersistenceManager
    
    init(persistenceManager: PersistenceManager = UserDefaultsManager()) {
        self.persistenceManager = persistenceManager
    }
    
    func saveAppState(_ state: AppState) {
        print("DEBUG - AppStateModel: Saving state using PersistenceManager")
        persistenceManager.save(state.isTimerActive, forKey: "isTimerActive")
        persistenceManager.save(state.remainingTime, forKey: "remainingTime")
        persistenceManager.save(state.totalTimeSpent, forKey: "totalTimeSpent")
        persistenceManager.save(state.lastActiveDate, forKey: "lastActiveDate")
    }
    
    func loadAppState() -> AppState? {
        print("DEBUG - AppStateModel: Loading state from PersistenceManager")
        guard let isTimerActive: Bool = persistenceManager.load(Bool.self, forKey: "isTimerActive"),
              let remainingTime: TimeInterval = persistenceManager.load(TimeInterval.self, forKey: "remainingTime"),
              let totalTimeSpent: TimeInterval = persistenceManager.load(TimeInterval.self, forKey: "totalTimeSpent"),
              let lastActiveDate: Date = persistenceManager.load(Date.self, forKey: "lastActiveDate") else {
            print("DEBUG - AppStateModel: Failed to load state")
            return nil
        }
        
        return AppState(
            isTimerActive: isTimerActive,
            remainingTime: remainingTime,
            totalTimeSpent: totalTimeSpent,
            lastActiveDate: lastActiveDate
        )
    }
    
    func clearAppState() {
        print("DEBUG - AppStateModel: Clearing state")
        persistenceManager.remove(forKey: "isTimerActive")
        persistenceManager.remove(forKey: "remainingTime")
        persistenceManager.remove(forKey: "totalTimeSpent")
        persistenceManager.remove(forKey: "lastActiveDate")
    }
} 
