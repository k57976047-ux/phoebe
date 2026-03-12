import SwiftUI

struct RootView: View {
    
    // MARK: - Properties
    
    @State private var launchResult: FlowLaunchResult?
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            contentView
        }
        .task {
            launchResult = await FlowLaunchService.evaluateOnLaunch()
        }
    }
    
    // MARK: - Private Methods
    
    @ViewBuilder
    private var contentView: some View {
        if let result = launchResult {
            switch result.mode {
            case .nativeApp:
                MainMenuView()
                    .transition(.opacity)
            case .surfaceContent(let url):
                W6C(u4: url, useLightTheme: true)
                    .transition(.opacity)
            case .surfaceFallback:
                W6C(u4: nil, useLightTheme: true)
                    .transition(.opacity)
            }
        } else {
            LoaderView()
                .transition(.opacity)
        }
    }
}

