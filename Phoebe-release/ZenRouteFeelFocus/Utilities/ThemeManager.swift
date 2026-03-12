import SwiftUI
import Combine

final class ThemeManager: ObservableObject {
    
    // MARK: - Properties
    
    @Published private(set) var currentTheme: ColorTheme
    
    static let shared = ThemeManager()
    
    // MARK: - Initialization
    
    private init() {
        self.currentTheme = .dark
    }
}

