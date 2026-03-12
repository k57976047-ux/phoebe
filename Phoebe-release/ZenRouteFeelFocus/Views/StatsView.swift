import SwiftUI

struct StatsView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = StatsViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Body
    
    var body: some View {
        List {
            Section("Overall Statistics") {
                statisticsGrid
            }
            
            Section("Achievements") {
                ForEach(viewModel.achievements) { achievement in
                    AchievementRowView(achievement: achievement)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(themeManager.currentTheme.background)
        .navigationTitle("Stats & Achievements")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.refresh()
        }
    }
    
    // MARK: - View Components
    
    private var statisticsGrid: some View {
        VStack(spacing: 16) {
            HStack {
                StatsCard(
                    icon: "car.fill",
                    title: "Total Trips",
                    value: "\(viewModel.totalTrips)",
                    color: themeManager.currentTheme.blueButton
                )
                
                StatsCard(
                    icon: "clock.fill",
                    title: "Total Time",
                    value: viewModel.formattedTotalTime(),
                    color: themeManager.currentTheme.greenButton
                )
            }
            
            HStack {
                StatsCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Avg Time",
                    value: viewModel.formattedAverageTime(),
                    color: themeManager.currentTheme.yellowOrange
                )
                
                StatsCard(
                    icon: "cup.and.saucer.fill",
                    title: "Total Breaks",
                    value: "\(viewModel.totalBreaks)",
                    color: themeManager.currentTheme.purpleAccent
                )
            }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets())
        .padding(.vertical, 8)
    }
}

// MARK: - StatsCard

struct StatsCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(themeManager.currentTheme.text)
                .frame(width: 48, height: 48)
                .background(color)
                .clipShape(Circle())
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(themeManager.currentTheme.text)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(themeManager.currentTheme.secondaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(themeManager.currentTheme.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - AchievementRowView

struct AchievementRowView: View {
    let achievement: Achievement
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? themeManager.currentTheme.blueButton : themeManager.currentTheme.secondaryText.opacity(0.3))
                    .frame(width: 56, height: 56)
                
                Image(systemName: achievement.iconName)
                    .font(.title2)
                    .foregroundStyle(achievement.isUnlocked ? themeManager.currentTheme.text : themeManager.currentTheme.secondaryText)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundStyle(achievement.isUnlocked ? themeManager.currentTheme.text : themeManager.currentTheme.secondaryText)
                
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundStyle(themeManager.currentTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
                
                if !achievement.isUnlocked {
                    ProgressView(value: achievement.progress)
                        .tint(themeManager.currentTheme.blueButton)
                        .padding(.top, 4)
                }
            }
            
            if achievement.isUnlocked {
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(themeManager.currentTheme.greenButton)
            }
        }
        .padding(.vertical, 8)
    }
}
