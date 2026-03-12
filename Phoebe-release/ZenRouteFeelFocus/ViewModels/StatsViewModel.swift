import Foundation
import Combine

final class StatsViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var achievements: [Achievement] = []
    @Published var totalTrips: Int = 0
    @Published var totalDrivingTime: TimeInterval = 0
    @Published var averageDrivingTime: TimeInterval = 0
    @Published var totalBreaks: Int = 0
    @Published var consistentTripsCount: Int = 0
    
    private let storageService: StorageService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(storageService: StorageService = .shared) {
        self.storageService = storageService
        calculateStats()
        generateAchievements()
    }
    
    // MARK: - Private Methods
    
    private func calculateStats() {
        let trips = storageService.loadTrips()
        totalTrips = trips.count
        totalDrivingTime = trips.reduce(0) { $0 + $1.drivingDuration }
        averageDrivingTime = trips.isEmpty ? 0 : totalDrivingTime / TimeInterval(trips.count)
        totalBreaks = trips.reduce(0) { $0 + $1.breakCount }
        
        var consecutive = 0
        for trip in trips {
            if trip.followedBreaks {
                consecutive += 1
            } else {
                break
            }
        }
        consistentTripsCount = consecutive
    }
    
    private func generateAchievements() {
        achievements = [
            Achievement(
                title: "First Timer Completed",
                description: "Complete your first trip",
                iconName: "flag.checkered",
                isUnlocked: totalTrips >= 1,
                progress: min(Double(totalTrips), 1.0)
            ),
            Achievement(
                title: "3 Consecutive Trips",
                description: "Complete 3 trips with proper breaks",
                iconName: "arrow.3.trianglepath",
                isUnlocked: consistentTripsCount >= 3,
                progress: min(Double(consistentTripsCount) / 3.0, 1.0)
            ),
            Achievement(
                title: "100 Hours on Road",
                description: "Drive safely for 100 hours total",
                iconName: "clock.badge.checkmark",
                isUnlocked: totalDrivingTime >= 360000,
                progress: min(totalDrivingTime / 360000, 1.0)
            ),
            Achievement(
                title: "Break Master",
                description: "Take 50 breaks",
                iconName: "cup.and.saucer.fill",
                isUnlocked: totalBreaks >= 50,
                progress: min(Double(totalBreaks) / 50.0, 1.0)
            ),
            Achievement(
                title: "Dedicated Driver",
                description: "Complete 10 trips",
                iconName: "car.fill",
                isUnlocked: totalTrips >= 10,
                progress: min(Double(totalTrips) / 10.0, 1.0)
            )
        ]
    }
    
    // MARK: - Public Methods
    
    func refresh() {
        calculateStats()
        generateAchievements()
    }
    
    func formattedTotalTime() -> String {
        let hours = Int(totalDrivingTime) / 3600
        let minutes = Int(totalDrivingTime) % 3600 / 60
        return "\(hours)h \(minutes)m"
    }
    
    func formattedAverageTime() -> String {
        let hours = Int(averageDrivingTime) / 3600
        let minutes = Int(averageDrivingTime) % 3600 / 60
        return "\(hours)h \(minutes)m"
    }
}

