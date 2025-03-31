import SwiftUI

// Extension for hex initialization
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

struct SplashScreenView: View {
    @State private var showSplash = true
    @State private var bgOpacity: Double = 1.0
    @State private var imageOpacity: Double = 1.0

    var body: some View {
        ZStack {
            ContentView()

            if showSplash {
                ZStack {
                    Color(hex: "#ed0f0c")
                        .ignoresSafeArea()
                        .opacity(bgOpacity)

                    Image("noomi_launch")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .opacity(imageOpacity)
                }
                .drawingGroup() // Helps if your image is complex
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Fade out the image first to account for lag
                withAnimation(.easeInOut(duration: 1.0)) {
                    imageOpacity = 0.0
                }
                // Then fade the background slightly after
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        bgOpacity = 0.0
                    }
                }
                // Remove from hierarchy
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    showSplash = false
                }
            }
        }
    }
}
