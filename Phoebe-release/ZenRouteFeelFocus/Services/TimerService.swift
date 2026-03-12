import Foundation
import Combine

final class TimerService: ObservableObject {
    
    // MARK: - Properties
    
    @Published var currentState: TimerState = .idle
    @Published var elapsedTime: TimeInterval = 0
    @Published var totalDrivingTime: TimeInterval = 0
    @Published var breakCount: Int = 0
    
    private var timer: Timer?
    private var targetInterval: TimeInterval = 0
    private var breakDuration: TimeInterval = 0
    private var startDate: Date?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Private Methods
    
    private func startInternalTimer() {
        stopInternalTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime += 1
            if self.currentState == .driving {
                self.totalDrivingTime += 1
            }
        }
    }
    
    private func stopInternalTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Public Methods
    
    func startDriving(interval: TimeInterval, breakDuration: TimeInterval) {
        stopInternalTimer()
        currentState = .driving
        targetInterval = interval
        self.breakDuration = breakDuration
        elapsedTime = 0
        startDate = Date()
        startInternalTimer()
    }
    
    func pause() {
        guard currentState == .driving || currentState == .onBreak else { return }
        currentState = .paused
        stopInternalTimer()
    }
    
    func resume() {
        guard currentState == .paused else { return }
        currentState = .driving
        startInternalTimer()
    }
    
    func startBreak() {
        stopInternalTimer()
        currentState = .onBreak
        breakCount += 1
        elapsedTime = 0
        startInternalTimer()
    }
    
    func completeBreak() {
        stopInternalTimer()
        currentState = .driving
        elapsedTime = 0
        startInternalTimer()
    }
    
    func reset() {
        stopInternalTimer()
        currentState = .idle
        elapsedTime = 0
        totalDrivingTime = 0
        breakCount = 0
        startDate = nil
    }
    
    func progress() -> Double {
        let interval = currentState == .onBreak ? breakDuration : targetInterval
        guard interval > 0 else { return 0 }
        return min(elapsedTime / interval, 1.0)
    }
    
    func progressColor() -> String {
        if currentState == .onBreak {
            return "blue"
        }
        
        let progressValue = progress()
        if progressValue < 0.7 {
            return "green"
        } else if progressValue < 0.9 {
            return "yellow"
        } else {
            return "red"
        }
    }
}

