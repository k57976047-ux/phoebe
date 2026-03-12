import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var settings: AppSettings
    @Published var showClearHistoryAlert: Bool = false
    @Published var historyCleared: Bool = false
    
    private let storageService: StorageService
    private let soundService: SoundService
    
    // MARK: - Initialization
    
    init(
        storageService: StorageService = .shared,
        soundService: SoundService = .shared
    ) {
        self.storageService = storageService
        self.soundService = soundService
        self.settings = storageService.loadSettings()
    }
    
    // MARK: - Private Methods
    
    private func saveSettings() {
        storageService.saveSettings(settings)
    }
    
    // MARK: - Public Methods
    
    func toggleSoundEffects() {
        settings.soundEffectsEnabled.toggle()
        saveSettings()
        
        if settings.soundEffectsEnabled {
            soundService.playSound(.resume)
        }
    }
    
    func requestClearHistory() {
        showClearHistoryAlert = true
    }
    
    func confirmClearHistory() {
        soundService.playSound(.stop, if: settings.soundEffectsEnabled)
        
        storageService.clearHistory()
        showClearHistoryAlert = false
        historyCleared = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.historyCleared = false
        }
    }
    
    func cancelClearHistory() {
        showClearHistoryAlert = false
    }
}

