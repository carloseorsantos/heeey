import SwiftUI
import Combine

/// Manages persistent application settings and history.
@MainActor
public final class SettingsStore: ObservableObject {
    public static let shared = SettingsStore()

    @AppStorage("userHandle") public var userHandle: String = "carlos"
    @AppStorage("serverURL") public var serverURL: String = "wss://heeey.live/ws"
    @AppStorage("defaultThemeRaw") private var defaultThemeRaw: String = TickerTheme.ledGreen.rawValue
    @AppStorage("scrollSpeed") public var scrollSpeed: Double = 60.0 // Pixels per second
    @AppStorage("soundEnabled") public var soundEnabled: Bool = true
    @AppStorage("soundVolume") public var soundVolume: Double = 0.7
    @AppStorage("loopsPerMessage") public var loopsPerMessage: Int = 2
    @AppStorage("autoDismissSeconds") public var autoDismissSeconds: Double = 8.0

    @Published public var history: [TickerMessage] = []

    private let historyKey = "message_history_cache"

    public var defaultTheme: TickerTheme {
        get { TickerTheme(rawValue: defaultThemeRaw) ?? .ledGreen }
        set {
            defaultThemeRaw = newValue.rawValue
            objectWillChange.send()
        }
    }

    private init() {
        loadHistory()
    }

    public func addMessageToHistory(_ message: TickerMessage) {
        history.insert(message, at: 0)
        // Keep maximum 50 messages
        if history.count > 50 {
            history = Array(history.prefix(50))
        }
        saveHistory()
    }

    public func clearHistory() {
        history.removeAll()
        saveHistory()
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([TickerMessage].self, from: data) {
            self.history = decoded
        }
    }
}
