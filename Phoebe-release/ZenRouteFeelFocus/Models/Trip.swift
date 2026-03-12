import Foundation

struct Trip: Identifiable, Codable {
    
    // MARK: - Properties
    
    let id: UUID
    let date: Date
    let drivingDuration: TimeInterval
    let breakCount: Int
    let averageBreakDuration: TimeInterval
    let intervalsCompleted: Int
    let followedBreaks: Bool
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        drivingDuration: TimeInterval,
        breakCount: Int,
        averageBreakDuration: TimeInterval,
        intervalsCompleted: Int,
        followedBreaks: Bool
    ) {
        self.id = id
        self.date = date
        self.drivingDuration = drivingDuration
        self.breakCount = breakCount
        self.averageBreakDuration = averageBreakDuration
        self.intervalsCompleted = intervalsCompleted
        self.followedBreaks = followedBreaks
    }
    
    // MARK: - Public Methods
    
    func formattedDuration() -> String {
        let hours = Int(drivingDuration) / 3600
        let minutes = Int(drivingDuration) % 3600 / 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

