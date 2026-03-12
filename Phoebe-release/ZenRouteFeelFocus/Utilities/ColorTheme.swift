import SwiftUI

struct ColorTheme {
    
    // MARK: - Properties
    
    let background: Color
    let secondaryBackground: Color
    let text: Color
    let secondaryText: Color
    let greenButton: Color
    let blueButton: Color
    let purpleAccent: Color
    let redWarning: Color
    let yellowOrange: Color
    let progressGreen: Color
    let progressYellow: Color
    let progressRed: Color
    
    // MARK: - Themes
    
    static let light = ColorTheme(
        background: Color(hex: "4B5563"),
        secondaryBackground: Color(hex: "9CA3AF"),
        text: Color(hex: "FFFFFF"),
        secondaryText: Color(hex: "E5E7EB"),
        greenButton: Color(hex: "10B981"),
        blueButton: Color(hex: "3B82F6"),
        purpleAccent: Color(hex: "A78BFA"),
        redWarning: Color(hex: "EF4444"),
        yellowOrange: Color(hex: "F59E0B"),
        progressGreen: Color(hex: "10B981"),
        progressYellow: Color(hex: "F59E0B"),
        progressRed: Color(hex: "EF4444")
    )
    
    static let dark = ColorTheme(
        background: Color(hex: "111827"),
        secondaryBackground: Color(hex: "1E293B"),
        text: Color(hex: "FFFFFF"),
        secondaryText: Color(hex: "E5E7EB"),
        greenButton: Color(hex: "10B981"),
        blueButton: Color(hex: "3B82F6"),
        purpleAccent: Color(hex: "A78BFA"),
        redWarning: Color(hex: "EF4444"),
        yellowOrange: Color(hex: "F59E0B"),
        progressGreen: Color(hex: "10B981"),
        progressYellow: Color(hex: "F59E0B"),
        progressRed: Color(hex: "EF4444")
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

