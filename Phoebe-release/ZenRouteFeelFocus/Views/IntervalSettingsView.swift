import SwiftUI

struct IntervalSettingsView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var selectedDrivingInterval: Int
    @State private var selectedBreakDuration: Int
    
    private let drivingIntervalOptions = [30, 60, 90, 120, 150, 180, 240]
    private let breakDurationOptions = [5, 10, 15, 20, 30]
    
    // MARK: - Initialization
    
    init(viewModel: TimerViewModel) {
        self.viewModel = viewModel
        _selectedDrivingInterval = State(initialValue: viewModel.settings.drivingIntervalMinutes)
        _selectedBreakDuration = State(initialValue: viewModel.settings.breakDurationMinutes)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "car.fill")
                                .foregroundStyle(themeManager.currentTheme.blueButton)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Driving Interval")
                                    .font(.headline)
                                    .foregroundStyle(themeManager.currentTheme.text)
                                
                                Text("How long you want to drive before taking a break")
                                    .font(.caption)
                                    .foregroundStyle(themeManager.currentTheme.secondaryText)
                            }
                        }
                        .padding(.bottom, 8)
                        
                        Text("\(selectedDrivingInterval) minutes")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(themeManager.currentTheme.blueButton)
                            .frame(maxWidth: .infinity)
                            .animation(.spring(response: 0.3), value: selectedDrivingInterval)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 12) {
                            ForEach(drivingIntervalOptions, id: \.self) { value in
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedDrivingInterval = value
                                    }
                                } label: {
                                    VStack(spacing: 4) {
                                        Text("\(value)")
                                            .font(.title3.bold())
                                        Text("min")
                                            .font(.caption2)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        selectedDrivingInterval == value
                                            ? themeManager.currentTheme.blueButton
                                            : themeManager.currentTheme.secondaryBackground
                                    )
                                    .foregroundStyle(
                                        selectedDrivingInterval == value
                                            ? Color.white
                                            : themeManager.currentTheme.text
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(
                                        color: selectedDrivingInterval == value
                                            ? themeManager.currentTheme.blueButton.opacity(0.3)
                                            : .clear,
                                        radius: 8,
                                        y: 4
                                    )
                                    .scaleEffect(selectedDrivingInterval == value ? 1.05 : 1.0)
                                    .animation(.spring(response: 0.3), value: selectedDrivingInterval)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.clear)
                
                Section {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "cup.and.saucer.fill")
                                .foregroundStyle(themeManager.currentTheme.yellowOrange)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Break Duration")
                                    .font(.headline)
                                    .foregroundStyle(themeManager.currentTheme.text)
                                
                                Text("How long your break should last")
                                    .font(.caption)
                                    .foregroundStyle(themeManager.currentTheme.secondaryText)
                            }
                        }
                        .padding(.bottom, 8)
                        
                        Text("\(selectedBreakDuration) minutes")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(themeManager.currentTheme.yellowOrange)
                            .frame(maxWidth: .infinity)
                            .animation(.spring(response: 0.3), value: selectedBreakDuration)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 12) {
                            ForEach(breakDurationOptions, id: \.self) { value in
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedBreakDuration = value
                                    }
                                } label: {
                                    VStack(spacing: 4) {
                                        Text("\(value)")
                                            .font(.title3.bold())
                                        Text("min")
                                            .font(.caption2)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        selectedBreakDuration == value
                                            ? themeManager.currentTheme.yellowOrange
                                            : themeManager.currentTheme.secondaryBackground
                                    )
                                    .foregroundStyle(
                                        selectedBreakDuration == value
                                            ? Color.white
                                            : themeManager.currentTheme.text
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(
                                        color: selectedBreakDuration == value
                                            ? themeManager.currentTheme.yellowOrange.opacity(0.3)
                                            : .clear,
                                        radius: 8,
                                        y: 4
                                    )
                                    .scaleEffect(selectedBreakDuration == value ? 1.05 : 1.0)
                                    .animation(.spring(response: 0.3), value: selectedBreakDuration)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.clear)
                
                Section {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(themeManager.currentTheme.secondaryText)
                            
                            Text("You will be notified when it's time for a break")
                                .font(.caption)
                                .foregroundStyle(themeManager.currentTheme.secondaryText)
                        }
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(themeManager.currentTheme.greenButton)
                            
                            Text("Settings apply to your next driving session")
                                .font(.caption)
                                .foregroundStyle(themeManager.currentTheme.secondaryText)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .background(themeManager.currentTheme.background)
            .navigationTitle("Interval Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(themeManager.currentTheme.text)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveSettings()
                    }
                    .foregroundStyle(themeManager.currentTheme.blueButton)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func saveSettings() {
        viewModel.updateIntervalSettings(
            drivingInterval: selectedDrivingInterval,
            breakDuration: selectedBreakDuration
        )
        dismiss()
    }
}

