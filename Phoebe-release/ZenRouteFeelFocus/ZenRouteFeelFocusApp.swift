import SwiftUI
import UIKit

@main
struct ZenRouteFeelFocusApp: App {
    
    @StateObject private var themeManager = ThemeManager.shared
    
    init() {
        configureNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(themeManager)
                .preferredColorScheme(.dark)
        }
    }
    
    // MARK: - Private Methods

    private func configureNavigationBarAppearance() {
        UINavigationBar.appearance().tintColor = .white
        UIBarButtonItem.appearance().tintColor = .white
    }
}
