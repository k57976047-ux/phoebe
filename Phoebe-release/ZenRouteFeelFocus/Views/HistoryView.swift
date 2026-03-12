import SwiftUI

struct HistoryView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = HistoryViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if viewModel.filteredTrips.isEmpty {
                emptyStateView
            } else {
                tripsList
            }
        }
        .background(themeManager.currentTheme.background)
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.refreshTrips()
        }
    }
    
    // MARK: - View Components
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "tray.fill")
                .font(.system(size: 64))
                .foregroundStyle(themeManager.currentTheme.secondaryText)
            
            Text("No trips yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(themeManager.currentTheme.text)
            
            Text("Start your first trip!")
                .font(.body)
                .foregroundStyle(themeManager.currentTheme.secondaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(themeManager.currentTheme.background)
    }
    
    private var tripsList: some View {
        List {
            Section {
                summaryCard
            }
            
            Section("Trips") {
                ForEach(viewModel.filteredTrips) { trip in
                    NavigationLink(destination: TripDetailView(trip: trip)) {
                        TripRowView(trip: trip)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(themeManager.currentTheme.background)
    }
    
    private var summaryCard: some View {
        VStack(spacing: 16) {
            HStack {
                StatBox(
                    icon: "car.fill",
                    title: "Total Trips",
                    value: "\(viewModel.filteredTrips.count)"
                )
                
                StatBox(
                    icon: "clock.fill",
                    title: "Total Time",
                    value: formatTime(viewModel.totalDrivingTime())
                )
            }
            
            HStack {
                StatBox(
                    icon: "cup.and.saucer.fill",
                    title: "Total Breaks",
                    value: "\(viewModel.totalBreaks())"
                )
                
                StatBox(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Avg Time",
                    value: formatTime(viewModel.averageDrivingTime())
                )
            }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets())
    }
    
    // MARK: - Private Methods
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) % 3600 / 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
}

// MARK: - TripRowView

struct TripRowView: View {
    let trip: Trip
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: trip.followedBreaks ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(trip.followedBreaks ? themeManager.currentTheme.greenButton : themeManager.currentTheme.redWarning)
                
                Text(trip.formattedDate())
                    .font(.headline)
                    .foregroundStyle(themeManager.currentTheme.text)
            }
            
            HStack(spacing: 16) {
                Label(trip.formattedDuration(), systemImage: "clock")
                    .font(.subheadline)
                    .foregroundStyle(themeManager.currentTheme.secondaryText)
                
                Label("\(trip.breakCount)", systemImage: "cup.and.saucer")
                    .font(.subheadline)
                    .foregroundStyle(themeManager.currentTheme.secondaryText)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - StatBox

struct StatBox: View {
    let icon: String
    let title: String
    let value: String
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(themeManager.currentTheme.blueButton)
            
            Text(value)
                .font(.title3)
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

// MARK: - TripDetailView

struct TripDetailView: View {
    let trip: Trip
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        List {
            Section("Trip Information") {
                LabeledRow(label: "Date", value: trip.formattedDate())
                LabeledRow(label: "Duration", value: trip.formattedDuration())
                LabeledRow(label: "Breaks Taken", value: "\(trip.breakCount)")
                LabeledRow(label: "Intervals Completed", value: "\(trip.intervalsCompleted)")
                LabeledRow(
                    label: "Followed Breaks",
                    value: trip.followedBreaks ? "Yes" : "No",
                    valueColor: trip.followedBreaks ? themeManager.currentTheme.greenButton : themeManager.currentTheme.redWarning
                )
            }
        }
        .scrollContentBackground(.hidden)
        .background(themeManager.currentTheme.background)
        .navigationTitle("Trip Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - LabeledRow

struct LabeledRow: View {
    let label: String
    let value: String
    var valueColor: Color?
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(themeManager.currentTheme.text)
            Spacer()
            Text(value)
                .foregroundStyle(valueColor ?? themeManager.currentTheme.text)
                .fontWeight(.semibold)
        }
    }
}
