import Foundation

struct Achievement: Identifiable {
    
    // MARK: - Properties
    
    let id: UUID
    let title: String
    let description: String
    let iconName: String
    let isUnlocked: Bool
    let progress: Double
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        iconName: String,
        isUnlocked: Bool,
        progress: Double
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.isUnlocked = isUnlocked
        self.progress = progress
    }
}

