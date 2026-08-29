import SwiftUI

/// Renders the modern macOS Liquid Glass style.
public struct LiquidGlassThemeView: View {
    let message: TickerMessage
    let speed: Double

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .foregroundColor(.white.opacity(0.85))

            MarqueeScrollView(
                text: message.formattedHeadline,
                font: .system(size: 15, weight: .semibold, design: .default),
                textColor: .white,
                glowColor: .clear,
                speed: speed
            )
        }
        .padding(.horizontal, 20)
    }
}
