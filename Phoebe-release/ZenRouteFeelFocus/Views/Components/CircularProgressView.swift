import SwiftUI

struct CircularProgressView: View {
    
    // MARK: - Properties
    
    let progress: Double
    let colorName: String
    let lineWidth: CGFloat
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    private var progressColor: Color {
        switch colorName {
        case "green":
            return themeManager.currentTheme.progressGreen
        case "yellow":
            return themeManager.currentTheme.progressYellow
        case "red":
            return themeManager.currentTheme.progressRed
        case "blue":
            return themeManager.currentTheme.blueButton
        default:
            return themeManager.currentTheme.progressGreen
        }
    }
    
    // MARK: - Initialization
    
    init(progress: Double, colorName: String, lineWidth: CGFloat = 20) {
        self.progress = progress
        self.colorName = colorName
        self.lineWidth = lineWidth
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    themeManager.currentTheme.secondaryText.opacity(0.2),
                    lineWidth: lineWidth
                )
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    progressColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
}

