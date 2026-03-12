import SwiftUI

struct OnboardingView: View {
    
    // MARK: - Properties
    
    @Binding var isPresented: Bool
    @State private var currentPage: Int = 0
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let pages = [
        OnboardingPage(
            icon: "timer",
            title: "Start Timer",
            description: "Control your fatigue and stay safe on the road"
        ),
        OnboardingPage(
            icon: "bell.badge.fill",
            title: "Push Notifications",
            description: "Get timely reminders about breaks"
        ),
        OnboardingPage(
            icon: "chart.bar.fill",
            title: "Achievements",
            description: "Track your progress and stay motivated"
        )
    ]
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 24) {
                        Image(systemName: pages[index].icon)
                            .font(.system(size: 80))
                            .foregroundStyle(themeManager.currentTheme.blueButton)
                        
                        Text(pages[index].title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(themeManager.currentTheme.text)
                            .multilineTextAlignment(.center)
                        
                        Text(pages[index].description)
                            .font(.body)
                            .foregroundStyle(themeManager.currentTheme.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: skip) {
                    Text("Skip")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(themeManager.currentTheme.secondaryBackground)
                        .foregroundStyle(themeManager.currentTheme.text)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button(action: nextOrFinish) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(themeManager.currentTheme.blueButton)
                        .foregroundStyle(themeManager.currentTheme.text)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(themeManager.currentTheme.background)
    }
    
    // MARK: - Private Methods
    
    private func nextOrFinish() {
        if currentPage < pages.count - 1 {
            currentPage += 1
        } else {
            finish()
        }
    }
    
    private func skip() {
        finish()
    }
    
    private func finish() {
        StorageService.shared.setOnboardingCompleted(true)
        isPresented = false
    }
}

// MARK: - OnboardingPage

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

