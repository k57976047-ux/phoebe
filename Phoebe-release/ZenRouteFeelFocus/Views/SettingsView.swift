import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: SettingsViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Body
    
    var body: some View {
        List {
            Section("Audio") {
                Toggle(isOn: Binding(
                    get: { viewModel.settings.soundEffectsEnabled },
                    set: { _ in viewModel.toggleSoundEffects() }
                )) {
                    Label("Sound Effects", systemImage: "speaker.wave.2.fill")
                        .foregroundStyle(themeManager.currentTheme.text)
                }
            }
            
            Section("Data") {
                Button(role: .destructive, action: viewModel.requestClearHistory) {
                    Label("Clear History", systemImage: "trash.fill")
                }
            }
            
            Section {
                VStack(alignment: .center, spacing: 8) {
                    Text("ZenRoute: Feel Focus, Find Balance")
                        .font(.headline)
                        .foregroundStyle(themeManager.currentTheme.text)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Version 1.0.0")
                        .font(.caption)
                        .foregroundStyle(themeManager.currentTheme.secondaryText)
                }
                .frame(maxWidth: .infinity)
            }
            .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .background(themeManager.currentTheme.background)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Clear History", isPresented: $viewModel.showClearHistoryAlert) {
            Button("Cancel", role: .cancel, action: viewModel.cancelClearHistory)
            Button("Clear", role: .destructive, action: viewModel.confirmClearHistory)
        } message: {
            Text("Are you sure you want to clear all trip history? This action cannot be undone.")
        }
        .overlay {
            if viewModel.historyCleared {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(themeManager.currentTheme.greenButton)
                        Text("History cleared successfully")
                            .font(.subheadline)
                            .foregroundStyle(themeManager.currentTheme.text)
                    }
                    .padding()
                    .background(themeManager.currentTheme.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 4)
                    .padding(.bottom, 32)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}
