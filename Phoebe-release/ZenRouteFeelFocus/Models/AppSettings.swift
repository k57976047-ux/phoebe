import Foundation

struct AppSettings: Codable {
    
    // MARK: - Properties
    
    static let defaultDrivingIntervalMinutes: Int = 120
    static let defaultBreakDurationMinutes: Int = 15
    
    var soundEffectsEnabled: Bool
    var drivingIntervalMinutes: Int
    var breakDurationMinutes: Int
    
    // MARK: - Initialization
    
    init(
        soundEffectsEnabled: Bool = true,
        drivingIntervalMinutes: Int = AppSettings.defaultDrivingIntervalMinutes,
        breakDurationMinutes: Int = AppSettings.defaultBreakDurationMinutes
    ) {
        self.soundEffectsEnabled = soundEffectsEnabled
        self.drivingIntervalMinutes = drivingIntervalMinutes
        self.breakDurationMinutes = breakDurationMinutes
    }
}

