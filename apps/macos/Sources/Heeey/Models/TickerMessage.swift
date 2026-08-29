import Foundation

/// Represents a message received from a friend to be displayed in the marquee.
public struct TickerMessage: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let text: String
    public let sender: String?
    public let emoji: String?
    public let theme: TickerTheme
    public let timestamp: Date
    public let soundEnabled: Bool

    public init(
        id: UUID = UUID(),
        text: String,
        sender: String? = nil,
        emoji: String? = nil,
        theme: TickerTheme = .ledGreen,
        timestamp: Date = Date(),
        soundEnabled: Bool = true
    ) {
        self.id = id
        self.text = text
        self.sender = sender
        self.emoji = emoji
        self.theme = theme
        self.timestamp = timestamp
        self.soundEnabled = soundEnabled
    }

    /// Formatted representation for scrolling display.
    public var formattedHeadline: String {
        var parts: [String] = []
        if let emoji = emoji, !emoji.trimmingCharacters(in: .whitespaces).isEmpty {
            parts.append(emoji)
        }
        if let sender = sender, !sender.trimmingCharacters(in: .whitespaces).isEmpty {
            parts.append("[\(sender)]:")
        }
        parts.append(text)
        return parts.joined(separator: " ")
    }
}
