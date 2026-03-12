import SwiftUI

struct LoaderView: View {
    
    // MARK: - Properties
    
    @State private var isAnimating: Bool = false
    @State private var showText: Bool = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .fill(themeManager.currentTheme.blueButton.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.6)
                    
                    Circle()
                        .fill(themeManager.currentTheme.blueButton)
                        .frame(width: 80, height: 80)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                        .opacity(isAnimating ? 0.7 : 1.0)
                    
                    Image(systemName: "car.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                        .scaleEffect(isAnimating ? 1.05 : 0.95)
                }
                .animation(
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                    value: isAnimating
                )
                
                VStack(spacing: 8) {
                    Text("ZenRoute")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(themeManager.currentTheme.text)
                        .opacity(showText ? 1 : 0)
                        .offset(y: showText ? 0 : 20)
                    
                    Text("Feel Focus, Find Balance")
                        .font(.subheadline)
                        .foregroundStyle(themeManager.currentTheme.secondaryText)
                        .opacity(showText ? 1 : 0)
                        .offset(y: showText ? 0 : 20)
                }
                .animation(.easeOut(duration: 0.8).delay(0.3), value: showText)
            }
        }
        .onAppear {
            isAnimating = true
            withAnimation {
                showText = true
            }
        }
    }
}

