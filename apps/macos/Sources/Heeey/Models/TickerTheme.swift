import SwiftUI

/// Defines the visual styling for the marquee ticker.
public enum TickerTheme: String, CaseIterable, Identifiable, Codable, Sendable {
    case ledGreen = "led_green"
    case ledAmber = "led_amber"
    case ledRGB = "led_rgb"
    case cyberpunkNeon = "cyberpunk_neon"
    case liquidGlass = "liquid_glass"
    case pixel8Bit = "pixel_8bit"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .ledGreen:
            return "LED Matrix Verde"
        case .ledAmber:
            return "LED Matrix Âmbar"
        case .ledRGB:
            return "LED Matrix RGB"
        case .cyberpunkNeon:
            return "Cyberpunk Neon"
        case .liquidGlass:
            return "Liquid Glass"
        case .pixel8Bit:
            return "Pixel Art 8-Bit"
        }
    }

    public var primaryColor: Color {
        switch self {
        case .ledGreen:
            return Color(red: 0.15, green: 1.0, blue: 0.35)
        case .ledAmber:
            return Color(red: 1.0, green: 0.72, blue: 0.1)
        case .ledRGB:
            return Color(red: 0.2, green: 0.85, blue: 1.0)
        case .cyberpunkNeon:
            return Color(red: 1.0, green: 0.1, blue: 0.7)
        case .liquidGlass:
            return Color.white
        case .pixel8Bit:
            return Color(red: 1.0, green: 0.9, blue: 0.2)
        }
    }

    public var secondaryColor: Color {
        switch self {
        case .ledGreen:
            return Color(red: 0.05, green: 0.4, blue: 0.1)
        case .ledAmber:
            return Color(red: 0.5, green: 0.25, blue: 0.0)
        case .ledRGB:
            return Color(red: 1.0, green: 0.2, blue: 0.6)
        case .cyberpunkNeon:
            return Color(red: 0.0, green: 0.95, blue: 0.95)
        case .liquidGlass:
            return Color(white: 0.8)
        case .pixel8Bit:
            return Color(red: 0.3, green: 0.7, blue: 1.0)
        }
    }

    public var backgroundColor: Color {
        switch self {
        case .ledGreen, .ledAmber, .ledRGB:
            return Color(red: 0.05, green: 0.06, blue: 0.07).opacity(0.95)
        case .cyberpunkNeon:
            return Color(red: 0.07, green: 0.02, blue: 0.12).opacity(0.95)
        case .liquidGlass:
            return Color.black.opacity(0.4)
        case .pixel8Bit:
            return Color(red: 0.08, green: 0.05, blue: 0.15).opacity(0.96)
        }
    }

    public var borderColor: Color {
        switch self {
        case .ledGreen:
            return Color(red: 0.15, green: 0.8, blue: 0.3).opacity(0.5)
        case .ledAmber:
            return Color(red: 0.9, green: 0.6, blue: 0.1).opacity(0.5)
        case .ledRGB:
            return Color(red: 0.3, green: 0.7, blue: 1.0).opacity(0.6)
        case .cyberpunkNeon:
            return Color(red: 1.0, green: 0.1, blue: 0.7).opacity(0.7)
        case .liquidGlass:
            return Color.white.opacity(0.25)
        case .pixel8Bit:
            return Color(red: 1.0, green: 0.9, blue: 0.2).opacity(0.7)
        }
    }
}
