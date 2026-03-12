import SwiftUI

struct MainMenuView: View {
    
    // MARK: - Properties
    
    @StateObject private var settingsViewModel = SettingsViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "car.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(themeManager.currentTheme.blueButton)
                    .padding(.bottom, 16)
                
                Text("ZenRoute")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(themeManager.currentTheme.text)
                
                Text("Feel Focus, Find Balance")
                    .font(.title3)
                    .foregroundStyle(themeManager.currentTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                VStack(spacing: 16) {
                    NavigationLink(destination: MainTimerView()) {
                        MenuButton(
                            icon: "timer",
                            title: "Start Timer",
                            color: themeManager.currentTheme.greenButton
                        )
                    }
                    
                    NavigationLink(destination: HistoryView()) {
                        MenuButton(
                            icon: "clock.arrow.circlepath",
                            title: "History",
                            color: themeManager.currentTheme.blueButton
                        )
                    }
                    
                    NavigationLink(destination: StatsView()) {
                        MenuButton(
                            icon: "chart.bar.fill",
                            title: "Achievements & Stats",
                            color: themeManager.currentTheme.purpleAccent
                        )
                    }
                    
                    NavigationLink(destination: SettingsView(viewModel: settingsViewModel)) {
                        MenuButton(
                            icon: "gearshape.fill",
                            title: "Settings",
                            color: themeManager.currentTheme.yellowOrange
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .padding()
            .background(themeManager.currentTheme.background)
        }
    }
}

// MARK: - MenuButton

struct MenuButton: View {
    let icon: String
    let title: String
    let color: Color
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(themeManager.currentTheme.text)
                .frame(width: 48, height: 48)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(title)
                .font(.headline)
                .foregroundStyle(themeManager.currentTheme.text)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundStyle(themeManager.currentTheme.secondaryText)
        }
        .padding()
        .background(themeManager.currentTheme.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

