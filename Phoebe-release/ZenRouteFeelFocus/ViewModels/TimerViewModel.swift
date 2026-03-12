import Foundation
import Combine

final class TimerViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var currentState: TimerState = .idle
    @Published var elapsedTime: TimeInterval = 0
    @Published var totalDrivingTime: TimeInterval = 0
    @Published var progress: Double = 0
    @Published var progressColorName: String = "green"
    @Published var breakCount: Int = 0
    @Published var showBreakAlert: Bool = false
    
    private let timerService: TimerService
    private let storageService: StorageService
    private let notificationService: NotificationService
    private let soundService: SoundService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var settings: AppSettings
    private var startDate: Date?
    
    // MARK: - Initialization
    
    init(
        timerService: TimerService = TimerService(),
        storageService: StorageService = .shared,
        notificationService: NotificationService = .shared,
        soundService: SoundService = .shared
    ) {
        self.timerService = timerService
        self.storageService = storageService
        self.notificationService = notificationService
        self.soundService = soundService
        self.settings = storageService.loadSettings()
        
        setupBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        timerService.$currentState
            .assign(to: &$currentState)
        
        timerService.$elapsedTime
            .assign(to: &$elapsedTime)
        
        timerService.$totalDrivingTime
            .assign(to: &$totalDrivingTime)
        
        timerService.$breakCount
            .assign(to: &$breakCount)
        
        timerService.$elapsedTime
            .sink { [weak self] _ in
                self?.updateProgress()
                self?.checkBreakTime()
            }
            .store(in: &cancellables)
    }
    
    private func updateProgress() {
        progress = timerService.progress()
        progressColorName = timerService.progressColor()
    }
    
    private func checkBreakTime() {
        let targetInterval = TimeInterval(settings.drivingIntervalMinutes * 60)
        
        if currentState == .driving && elapsedTime >= targetInterval {
            soundService.playSound(.breakAlert, if: settings.soundEffectsEnabled)
            showBreakAlert = true
            timerService.pause()
        }
        
        if currentState == .onBreak && elapsedTime >= TimeInterval(settings.breakDurationMinutes * 60) {
            completeBreak()
        }
    }
    
    private func saveTrip() {
        guard totalDrivingTime > 0 else { return }
        
        let trip = Trip(
            date: startDate ?? Date(),
            drivingDuration: totalDrivingTime,
            breakCount: breakCount,
            averageBreakDuration: TimeInterval(settings.breakDurationMinutes * 60),
            intervalsCompleted: breakCount + 1,
            followedBreaks: breakCount > 0
        )
        
        var trips = storageService.loadTrips()
        trips.insert(trip, at: 0)
        storageService.saveTrips(trips)
    }
    
    // MARK: - Public Methods
    
    func startTimer() {
        soundService.playSound(.start, if: settings.soundEffectsEnabled)
        
        let interval = TimeInterval(settings.drivingIntervalMinutes * 60)
        let breakDuration = TimeInterval(settings.breakDurationMinutes * 60)
        
        startDate = Date()
        timerService.startDriving(interval: interval, breakDuration: breakDuration)
        
        if settings.soundEffectsEnabled {
            notificationService.scheduleBreakNotification(
                after: interval,
                soundEnabled: settings.soundEffectsEnabled
            )
        }
    }
    
    func pauseTimer() {
        soundService.playSound(.pause, if: settings.soundEffectsEnabled)
        
        timerService.pause()
        notificationService.cancelAllNotifications()
    }
    
    func resumeTimer() {
        soundService.playSound(.resume, if: settings.soundEffectsEnabled)
        
        timerService.resume()
        
        if settings.soundEffectsEnabled {
            let remainingTime = TimeInterval(settings.drivingIntervalMinutes * 60) - elapsedTime
            notificationService.scheduleBreakNotification(
                after: remainingTime,
                soundEnabled: settings.soundEffectsEnabled
            )
        }
    }
    
    func resetTimer() {
        soundService.playSound(.stop, if: settings.soundEffectsEnabled)
        
        saveTrip()
        timerService.reset()
        notificationService.cancelAllNotifications()
        showBreakAlert = false
        startDate = nil
    }
    
    func startBreak() {
        soundService.playSound(.breakStart, if: settings.soundEffectsEnabled)
        
        showBreakAlert = false
        timerService.startBreak()
        
        if settings.soundEffectsEnabled {
            notificationService.scheduleBreakOverNotification(
                after: TimeInterval(settings.breakDurationMinutes * 60),
                soundEnabled: settings.soundEffectsEnabled
            )
        }
    }
    
    func startBreakManually() {
        soundService.playSound(.breakStart, if: settings.soundEffectsEnabled)
        
        timerService.startBreak()
        
        if settings.soundEffectsEnabled {
            notificationService.scheduleBreakOverNotification(
                after: TimeInterval(settings.breakDurationMinutes * 60),
                soundEnabled: settings.soundEffectsEnabled
            )
        }
    }
    
    func completeBreak() {
        soundService.playSound(.breakComplete, if: settings.soundEffectsEnabled)
        
        timerService.completeBreak()
        notificationService.cancelAllNotifications()
        
        if settings.soundEffectsEnabled {
            let interval = TimeInterval(settings.drivingIntervalMinutes * 60)
            notificationService.scheduleBreakNotification(
                after: interval,
                soundEnabled: settings.soundEffectsEnabled
            )
        }
    }
    
    func formattedElapsedTime() -> String {
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) % 3600 / 60
        let seconds = Int(elapsedTime) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func formattedTotalTime() -> String {
        let hours = Int(totalDrivingTime) / 3600
        let minutes = Int(totalDrivingTime) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    func updateIntervalSettings(drivingInterval: Int, breakDuration: Int) {
        var updatedSettings = settings
        updatedSettings.drivingIntervalMinutes = drivingInterval
        updatedSettings.breakDurationMinutes = breakDuration
        settings = updatedSettings
        storageService.saveSettings(settings)
    }
}

