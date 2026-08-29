import SwiftUI

/// Renders the 8-bit retro arcade pixel art theme.
public struct PixelArtThemeView: View {
    let message: TickerMessage
    let speed: Double

    public var body: some View {
        HStack(spacing: 12) {
            Text("👾")
                .font(.system(size: 18))

            MarqueeScrollView(
                text: message.formattedHeadline,
                font: .system(size: 15, weight: .bold, design: .monospaced),
                textColor: message.theme.primaryColor,
                glowColor: message.theme.secondaryColor,
                speed: speed
            )
        }
        .padding(.horizontal, 16)
    }
}
