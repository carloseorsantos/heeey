import SwiftUI

/// Renders the retro LED dot-matrix board effect.
public struct LEDMatrixThemeView: View {
    let message: TickerMessage
    let speed: Double

    public var body: some View {
        ZStack {
            // Background LED grid texture simulation
            LEDGridPattern()
                .opacity(0.12)

            HStack(spacing: 12) {
                // Live LED Status Indicator
                Circle()
                    .fill(message.theme.primaryColor)
                    .frame(width: 8, height: 8)
                    .shadow(color: message.theme.primaryColor, radius: 4)

                MarqueeScrollView(
                    text: message.formattedHeadline,
                    font: .system(size: 15, weight: .bold, design: .monospaced),
                    textColor: message.theme.primaryColor,
                    glowColor: message.theme.primaryColor,
                    speed: speed
                )
            }
            .padding(.horizontal, 16)
        }
    }
}

/// Draws a subtle grid of LED points
struct LEDGridPattern: View {
    var body: some View {
        Canvas { context, size in
            let dotSize: CGFloat = 2.0
            let spacing: CGFloat = 6.0
            let cols = Int(size.width / spacing)
            let rows = Int(size.height / spacing)

            for col in 0..<cols {
                for row in 0..<rows {
                    let rect = CGRect(
                        x: CGFloat(col) * spacing + 2,
                        y: CGFloat(row) * spacing + 2,
                        width: dotSize,
                        height: dotSize
                    )
                    context.fill(Path(ellipseIn: rect), with: .color(.white))
                }
            }
        }
    }
}
