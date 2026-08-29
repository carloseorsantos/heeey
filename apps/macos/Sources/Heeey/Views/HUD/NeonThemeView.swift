import SwiftUI

/// Renders the Cyberpunk Neon theme with dual-glow colors.
public struct NeonThemeView: View {
    let message: TickerMessage
    let speed: Double

    public var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "bolt.fill")
                .foregroundColor(message.theme.secondaryColor)
                .shadow(color: message.theme.secondaryColor, radius: 8)

            MarqueeScrollView(
                text: message.formattedHeadline,
                font: .system(size: 15, weight: .heavy, design: .rounded),
                textColor: message.theme.primaryColor,
                glowColor: message.theme.secondaryColor,
                speed: speed
            )
        }
        .padding(.horizontal, 18)
    }
}
