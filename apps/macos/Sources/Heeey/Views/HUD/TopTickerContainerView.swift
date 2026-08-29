import SwiftUI

/// Container view for the top-of-screen Dynamic Island marquee HUD.
public struct TopTickerContainerView: View {
    @ObservedObject var manager: HUDWindowManager
    @ObservedObject private var settings = SettingsStore.shared

    public init(manager: HUDWindowManager) {
        self.manager = manager
    }

    public var body: some View {
        ZStack {
            if let message = manager.currentMessage {
                contentForTheme(message: message)
                    .frame(width: 580, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(message.theme.backgroundColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(message.theme.borderColor, lineWidth: 1.5)
                    )
                    .shadow(color: message.theme.primaryColor.opacity(0.35), radius: 16, x: 0, y: 4)
                    .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
                    .offset(y: manager.isVisible ? 0 : -80)
                    .opacity(manager.isVisible ? 1.0 : 0.0)
                    .animation(.spring(response: 0.45, dampingFraction: 0.72), value: manager.isVisible)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    @ViewBuilder
    private func contentForTheme(message: TickerMessage) -> some View {
        switch message.theme {
        case .ledGreen, .ledAmber, .ledRGB:
            LEDMatrixThemeView(message: message, speed: settings.scrollSpeed)
        case .cyberpunkNeon:
            NeonThemeView(message: message, speed: settings.scrollSpeed)
        case .liquidGlass:
            LiquidGlassThemeView(message: message, speed: settings.scrollSpeed)
        case .pixel8Bit:
            PixelArtThemeView(message: message, speed: settings.scrollSpeed)
        }
    }
}
