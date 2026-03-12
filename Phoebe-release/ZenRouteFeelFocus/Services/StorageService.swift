import Foundation

final class StorageService {
    
    // MARK: - Properties
    
    static let shared = StorageService()
    
    private let tripsKey = "zen_route_trips"
    private let settingsKey = "zen_route_settings"
    private let hasCompletedOnboardingKey = "zen_route_has_completed_onboarding"
    
    private let userDefaults: UserDefaults
    
    // MARK: - Initialization
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Private Methods
    
    private func encode<T: Encodable>(_ value: T) -> Data? {
        try? JSONEncoder().encode(value)
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        try? JSONDecoder().decode(type, from: data)
    }
    
    // MARK: - Public Methods
    
    func saveTrips(_ trips: [Trip]) {
        guard let data = encode(trips) else { return }
        userDefaults.set(data, forKey: tripsKey)
    }
    
    func loadTrips() -> [Trip] {
        guard let data = userDefaults.data(forKey: tripsKey),
              let trips = decode([Trip].self, from: data) else {
            return []
        }
        return trips
    }
    
    func saveSettings(_ settings: AppSettings) {
        guard let data = encode(settings) else { return }
        userDefaults.set(data, forKey: settingsKey)
    }
    
    func loadSettings() -> AppSettings {
        guard let data = userDefaults.data(forKey: settingsKey),
              let settings = decode(AppSettings.self, from: data) else {
            return AppSettings()
        }
        return settings
    }
    
    func clearHistory() {
        userDefaults.removeObject(forKey: tripsKey)
    }
    
    func setOnboardingCompleted(_ completed: Bool) {
        userDefaults.set(completed, forKey: hasCompletedOnboardingKey)
    }
    
    func hasCompletedOnboarding() -> Bool {
        userDefaults.bool(forKey: hasCompletedOnboardingKey)
    }
}

