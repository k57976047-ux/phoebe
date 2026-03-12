import Foundation
import Combine

final class HistoryViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var trips: [Trip] = []
    @Published var filteredTrips: [Trip] = []
    @Published var selectedTrip: Trip?
    
    private let storageService: StorageService
    
    // MARK: - Initialization
    
    init(storageService: StorageService = .shared) {
        self.storageService = storageService
        loadTrips()
    }
    
    // MARK: - Private Methods
    
    private func loadTrips() {
        trips = storageService.loadTrips()
        filteredTrips = trips
    }
    
    // MARK: - Public Methods
    
    func refreshTrips() {
        loadTrips()
    }
    
    func filterByDate(from startDate: Date, to endDate: Date) {
        filteredTrips = trips.filter { trip in
            trip.date >= startDate && trip.date <= endDate
        }
    }
    
    func clearFilter() {
        filteredTrips = trips
    }
    
    func selectTrip(_ trip: Trip) {
        selectedTrip = trip
    }
    
    func totalDrivingTime() -> TimeInterval {
        trips.reduce(0) { $0 + $1.drivingDuration }
    }
    
    func totalBreaks() -> Int {
        trips.reduce(0) { $0 + $1.breakCount }
    }
    
    func averageDrivingTime() -> TimeInterval {
        guard !trips.isEmpty else { return 0 }
        return totalDrivingTime() / TimeInterval(trips.count)
    }
}

