import SwiftUI

/// High-performance marquee scroll view utilizing TimelineView for fluid 60/120fps motion.
public struct MarqueeScrollView: View {
    let text: String
    let font: Font
    let textColor: Color
    let glowColor: Color
    let speed: Double // pixels per second

    @State private var textWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var startTime: Date = Date()

    public init(
        text: String,
        font: Font = .system(size: 16, weight: .bold, design: .monospaced),
        textColor: Color = .green,
        glowColor: Color = .green,
        speed: Double = 60.0
    ) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.glowColor = glowColor
        self.speed = speed
    }

    public var body: some View {
        GeometryReader { geometry in
            let cWidth = geometry.size.width

            TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
                let elapsed = timeline.date.timeIntervalSince(startTime)
                let totalDistance = (textWidth > 0 ? textWidth : 300) + cWidth
                let progress = CGFloat(fmod(elapsed * speed, Double(totalDistance)))
                let currentX = cWidth - progress

                HStack(spacing: 0) {
                    Text(text)
                        .font(font)
                        .foregroundColor(textColor)
                        .shadow(color: glowColor.opacity(0.8), radius: 6, x: 0, y: 0)
                        .shadow(color: glowColor.opacity(0.4), radius: 12, x: 0, y: 0)
                        .fixedSize()
                        .background(
                            GeometryReader { textGeo in
                                Color.clear
                                    .preference(key: TextWidthPreferenceKey.self, value: textGeo.size.width)
                            }
                        )
                }
                .offset(x: currentX, y: 0)
            }
            .onPreferenceChange(TextWidthPreferenceKey.self) { newWidth in
                self.textWidth = newWidth
            }
            .onAppear {
                self.containerWidth = cWidth
                self.startTime = Date()
            }
        }
        .clipped()
    }
}

private struct TextWidthPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
