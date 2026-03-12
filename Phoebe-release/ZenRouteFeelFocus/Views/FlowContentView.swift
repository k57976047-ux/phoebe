import SwiftUI

struct W6C: View {
    
    let u4: URL?
    let useLightTheme: Bool
    
    @StateObject private var viewModel = FlowSurfaceViewModel()
    
    private var themeColor: Color {
        useLightTheme ? Color(red: 0.95, green: 0.95, blue: 0.95) : Color(red: 0.1, green: 0.1, blue: 0.1)
    }
    
    private var accentColor: Color {
        useLightTheme ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color(red: 0.9, green: 0.9, blue: 0.9)
    }
    
    private var colorScheme: ColorScheme {
        useLightTheme ? .light : .dark
    }
    
    var body: some View {
        ZStack {
            if let url = u4 {
                FlowSurfaceRepresentable(
                    viewModel: viewModel,
                    url: url,
                    useLightTheme: useLightTheme
                )
            .ignoresSafeArea(edges: [.horizontal, .bottom])
            } else {
                placeholderView
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle(tint: accentColor)
                    )
                    .scaleEffect(1.5)
            }
        }
        .background(themeColor)
        .preferredColorScheme(colorScheme)
    }
    
    private var placeholderView: some View {
        themeColor
            .ignoresSafeArea(edges: [.horizontal, .bottom])
    }
}

