import SwiftUI

struct MainTimerView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = TimerViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showIntervalSettings = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                timerSection
                
                if viewModel.currentState == .idle {
                    intervalInfoCard
                }
                
                controlButtons
            }
            .padding()
        }
        .background(themeManager.currentTheme.background)
        .navigationTitle("Timer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showIntervalSettings = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundStyle(themeManager.currentTheme.text)
                }
                .disabled(viewModel.currentState != .idle)
            }
        }
        .sheet(isPresented: $showIntervalSettings) {
            IntervalSettingsView(viewModel: viewModel)
        }
        .alert("Time for a break!", isPresented: $viewModel.showBreakAlert) {
            Button("Start Break", action: viewModel.startBreak)
            Button("Continue Driving", role: .cancel, action: viewModel.resumeTimer)
        } message: {
            Text("You've been driving for a while. Take a short break to stay focused.")
        }
    }
    
    // MARK: - View Components
    
    private var timerSection: some View {
        VStack(spacing: 24) {
            ZStack {
                CircularProgressView(
                    progress: viewModel.progress,
                    colorName: viewModel.progressColorName,
                    lineWidth: 24
                )
                .frame(width: 280, height: 280)
                
                VStack(spacing: 8) {
                    Text(viewModel.formattedElapsedTime())
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(themeManager.currentTheme.text)
                    
                    Text(statusText)
                        .font(.title3)
                        .foregroundStyle(themeManager.currentTheme.secondaryText)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            if viewModel.currentState != .idle {
                VStack(spacing: 8) {
                    Label {
                        Text("Total Driving: \(viewModel.formattedTotalTime())")
                            .font(.headline)
                            .foregroundStyle(themeManager.currentTheme.text)
                    } icon: {
                        Image(systemName: "car.fill")
                            .foregroundStyle(themeManager.currentTheme.blueButton)
                    }
                    
                    Label {
                        Text("Breaks Taken: \(viewModel.breakCount)")
                            .font(.headline)
                            .foregroundStyle(themeManager.currentTheme.text)
                    } icon: {
                        Image(systemName: "cup.and.saucer.fill")
                            .foregroundStyle(themeManager.currentTheme.yellowOrange)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(themeManager.currentTheme.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private var controlButtons: some View {
        VStack(spacing: 16) {
            if viewModel.currentState == .idle {
                Button(action: viewModel.startTimer) {
                    Label("Start Timer", systemImage: "play.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(themeManager.currentTheme.greenButton)
                        .foregroundStyle(themeManager.currentTheme.text)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            } else if viewModel.currentState == .driving {
                HStack(spacing: 16) {
                    Button(action: viewModel.pauseTimer) {
                        Label("Pause", systemImage: "pause.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.currentTheme.yellowOrange)
                            .foregroundStyle(themeManager.currentTheme.text)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Button(action: viewModel.resetTimer) {
                        Label("Stop", systemImage: "stop.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.currentTheme.redWarning)
                            .foregroundStyle(themeManager.currentTheme.text)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            } else if viewModel.currentState == .paused {
                VStack(spacing: 16) {
                    Button(action: viewModel.startBreakManually) {
                        Label("Take a Break", systemImage: "cup.and.saucer.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.currentTheme.yellowOrange)
                            .foregroundStyle(themeManager.currentTheme.text)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    HStack(spacing: 16) {
                        Button(action: viewModel.resumeTimer) {
                            Label("Resume", systemImage: "play.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(themeManager.currentTheme.greenButton)
                                .foregroundStyle(themeManager.currentTheme.text)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Button(action: viewModel.resetTimer) {
                            Label("Stop", systemImage: "stop.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(themeManager.currentTheme.redWarning)
                                .foregroundStyle(themeManager.currentTheme.text)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            } else if viewModel.currentState == .onBreak {
                Button(action: viewModel.completeBreak) {
                    Label("End Break", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(themeManager.currentTheme.blueButton)
                        .foregroundStyle(themeManager.currentTheme.text)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    private var intervalInfoCard: some View {
        HStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "car.fill")
                        .foregroundStyle(themeManager.currentTheme.blueButton)
                        .font(.title3)
                    
                    Text("Drive")
                        .font(.subheadline)
                        .foregroundStyle(themeManager.currentTheme.secondaryText)
                    
                    Spacer()
                }
                
                Text("\(viewModel.settings.drivingIntervalMinutes) min")
                    .font(.title2.bold())
                    .foregroundStyle(themeManager.currentTheme.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(themeManager.currentTheme.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "cup.and.saucer.fill")
                        .foregroundStyle(themeManager.currentTheme.yellowOrange)
                        .font(.title3)
                    
                    Text("Break")
                        .font(.subheadline)
                        .foregroundStyle(themeManager.currentTheme.secondaryText)
                    
                    Spacer()
                }
                
                Text("\(viewModel.settings.breakDurationMinutes) min")
                    .font(.title2.bold())
                    .foregroundStyle(themeManager.currentTheme.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(themeManager.currentTheme.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var statusText: String {
        switch viewModel.currentState {
        case .idle:
            return "Ready to Drive"
        case .driving:
            return "Driving"
        case .onBreak:
            return "On Break"
        case .paused:
            return "Paused"
        }
    }
}

