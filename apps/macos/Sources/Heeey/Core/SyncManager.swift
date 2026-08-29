import Foundation
import Combine

/// Connects to the real-time server via WebSockets to receive messages.
@MainActor
public final class SyncManager: ObservableObject {
    public static let shared = SyncManager()

    @Published public private(set) var isConnected: Bool = false
    @Published public private(set) var lastError: String? = nil

    private var webSocketTask: URLSessionWebSocketTask?
    private var session: URLSession
    private var isIntentionalDisconnect: Bool = false
    private var retryCount = 0
    private var isReconnecting: Bool = false

    private init() {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = false
        config.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: config)
    }

    public func connect(resetRetry: Bool = true) {
        if resetRetry {
            retryCount = 0
        }
        disconnect()
        isIntentionalDisconnect = false
        isReconnecting = false

        let handle = SettingsStore.shared.userHandle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !handle.isEmpty else {
            lastError = "Handle não configurado"
            return
        }

        let urlString = SettingsStore.shared.serverURL.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !urlString.isEmpty, let url = URL(string: urlString) else {
            lastError = "URL de servidor inválida"
            return
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems = components?.queryItems ?? []
        if !queryItems.contains(where: { $0.name == "handle" }) {
            queryItems.append(URLQueryItem(name: "handle", value: handle))
        }
        components?.queryItems = queryItems

        guard let finalURL = components?.url else {
            lastError = "URL final inválida"
            return
        }

        let task = session.webSocketTask(with: finalURL)
        self.webSocketTask = task
        task.resume()

        listenForMessages()
    }

    public func disconnect() {
        isIntentionalDisconnect = true
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        isConnected = false
    }

    private func listenForMessages() {
        guard let task = webSocketTask else { return }

        task.receive { [weak self] result in
            Task { @MainActor [weak self] in
                guard let self = self else { return }

                switch result {
                case .success(let message):
                    self.isConnected = true
                    self.lastError = nil
                    self.retryCount = 0

                    switch message {
                    case .string(let text):
                        self.handleIncomingText(text)
                    case .data(let data):
                        if let text = String(data: data, encoding: .utf8) {
                            self.handleIncomingText(text)
                        }
                    @unknown default:
                        break
                    }
                    // Continue listening for next message
                    self.listenForMessages()

                case .failure(let error):
                    self.isConnected = false
                    self.lastError = error.localizedDescription
                    if !self.isIntentionalDisconnect {
                        self.scheduleReconnect()
                    }
                }
            }
        }
    }

    private func scheduleReconnect() {
        guard !isReconnecting else { return }
        isReconnecting = true

        retryCount += 1
        // Backoff: 5s, 10s, 20s, up to 60s
        let delay = min(60.0, max(5.0, pow(2.0, Double(min(retryCount, 6)))))

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            Task { @MainActor [weak self] in
                guard let self = self, !self.isIntentionalDisconnect, !self.isConnected else { return }
                self.isReconnecting = false
                self.connect(resetRetry: false)
            }
        }
    }

    private func handleIncomingText(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }

        // Struct to decode flexible incoming JSON payload
        struct IncomingPayload: Codable {
            let text: String
            let sender: String?
            let emoji: String?
            let theme: String?
            let sound: Bool?
        }

        if let payload = try? JSONDecoder().decode(IncomingPayload.self, from: data) {
            let selectedTheme = TickerTheme(rawValue: payload.theme ?? "") ?? SettingsStore.shared.defaultTheme
            let msg = TickerMessage(
                text: payload.text,
                sender: payload.sender,
                emoji: payload.emoji,
                theme: selectedTheme,
                soundEnabled: payload.sound ?? SettingsStore.shared.soundEnabled
            )
            HUDWindowManager.shared.present(message: msg)
        } else {
            // Fallback plain text string
            let msg = TickerMessage(
                text: text,
                sender: "Anônimo",
                emoji: "💬",
                theme: SettingsStore.shared.defaultTheme
            )
            HUDWindowManager.shared.present(message: msg)
        }
    }

    /// Triggers a simulated local test message for instant verification.
    public func triggerTestMessage(
        text: String = "heeey! Bora codar um projeto open source?",
        sender: String = "Amigo",
        emoji: String = "🚀",
        theme: TickerTheme? = nil
    ) {
        let msg = TickerMessage(
            text: text,
            sender: sender,
            emoji: emoji,
            theme: theme ?? SettingsStore.shared.defaultTheme,
            soundEnabled: SettingsStore.shared.soundEnabled
        )
        HUDWindowManager.shared.present(message: msg)
    }
}
