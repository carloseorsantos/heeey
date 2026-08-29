import Foundation
import Combine

/// Connects to the real-time server (Native WebSocket or Supabase Realtime) to receive messages.
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
    private var heartbeatTimer: Timer?
    private var messageRef = 0
    private var currentTopic: String?

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

        let handle = SettingsStore.shared.userHandle.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !handle.isEmpty else {
            lastError = "Handle não configurado"
            return
        }

        let rawURL = SettingsStore.shared.serverURL.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !rawURL.isEmpty else {
            lastError = "URL de servidor vazia"
            return
        }

        // If the URL starts with http:// or https:// (e.g. https://heeey.click), resolve via /api/connect
        if rawURL.starts(with: "http://") || rawURL.starts(with: "https://") {
            resolveAndConnect(baseURL: rawURL, handle: handle)
            return
        }

        // Otherwise, connect directly via WebSocket URL
        connectDirectWebSocket(rawURL: rawURL, handle: handle)
    }

    private func resolveAndConnect(baseURL: String, handle: String) {
        guard var components = URLComponents(string: baseURL) else {
            lastError = "URL base inválida"
            return
        }

        components.path = "/api/connect"
        components.queryItems = [URLQueryItem(name: "handle", value: handle)]

        guard let connectEndpoint = components.url else {
            lastError = "Endpoint de conexão inválido"
            return
        }

        struct ConnectResponse: Codable {
            let success: Bool?
            let mode: String?
            let wsUrl: String
            let topic: String?
        }

        Task {
            do {
                let (data, response) = try await session.data(from: connectEndpoint)
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }

                let decoded = try JSONDecoder().decode(ConnectResponse.self, from: data)
                self.currentTopic = decoded.topic
                self.connectDirectWebSocket(rawURL: decoded.wsUrl, handle: handle, customTopic: decoded.topic)
            } catch {
                self.isConnected = false
                self.lastError = "Não foi possível conectar a \(baseURL): \(error.localizedDescription)"
                self.scheduleReconnect()
            }
        }
    }

    private func connectDirectWebSocket(rawURL: String, handle: String, customTopic: String? = nil) {
        guard var components = URLComponents(string: rawURL) else {
            lastError = "URL de servidor inválida"
            return
        }

        let isSupabase = rawURL.contains("supabase.co")

        if isSupabase {
            if components.path.isEmpty || components.path == "/" {
                components.path = "/realtime/v1/websocket"
            }
            var queryItems = components.queryItems ?? []
            if !queryItems.contains(where: { $0.name == "vsn" }) {
                queryItems.append(URLQueryItem(name: "vsn", value: "1.0.0"))
            }
            components.queryItems = queryItems
        } else {
            var queryItems = components.queryItems ?? []
            if !queryItems.contains(where: { $0.name == "handle" }) {
                queryItems.append(URLQueryItem(name: "handle", value: handle))
            }
            components.queryItems = queryItems
        }

        guard let finalURL = components.url else {
            lastError = "URL final inválida"
            return
        }

        let task = session.webSocketTask(with: finalURL)
        self.webSocketTask = task
        task.resume()

        listenForMessages()

        if isSupabase {
            let topicToJoin = customTopic ?? "realtime:heeey:\(handle)"
            joinSupabaseChannel(topic: topicToJoin)
            startHeartbeat()
        }
    }

    private func joinSupabaseChannel(topic: String) {
        messageRef += 1
        let joinMessage: [String: Any] = [
            "topic": topic,
            "event": "phx_join",
            "payload": [
                "config": [
                    "broadcast": ["self": false]
                ]
            ],
            "ref": "\(messageRef)"
        ]

        if let data = try? JSONSerialization.data(withJSONObject: joinMessage),
           let jsonString = String(data: data, encoding: .utf8) {
            webSocketTask?.send(.string(jsonString)) { _ in }
        }
    }

    private func startHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: 25.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self, self.isConnected else { return }
                self.messageRef += 1
                let heartbeat: [String: Any] = [
                    "topic": "phoenix",
                    "event": "heartbeat",
                    "payload": [:],
                    "ref": "\(self.messageRef)"
                ]
                if let data = try? JSONSerialization.data(withJSONObject: heartbeat),
                   let str = String(data: data, encoding: .utf8) {
                    self.webSocketTask?.send(.string(str)) { _ in }
                }
            }
        }
    }

    public func disconnect() {
        isIntentionalDisconnect = true
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
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
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil

        retryCount += 1
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

        // Struct to decode Supabase / Phoenix Realtime envelope
        struct PhoenixEnvelope: Codable {
            let topic: String?
            let event: String?
            let payload: MessagePayloadWrapper?
        }

        struct MessagePayloadWrapper: Codable {
            let text: String?
            let sender: String?
            let emoji: String?
            let theme: String?
            let sound: Bool?
            let payload: NestedPayload?
        }

        struct NestedPayload: Codable {
            let text: String?
            let sender: String?
            let emoji: String?
            let theme: String?
            let sound: Bool?
        }

        // Standard direct payload
        struct DirectPayload: Codable {
            let text: String
            let sender: String?
            let emoji: String?
            let theme: String?
            let sound: Bool?
        }

        // 1. Try Supabase Phoenix Envelope
        if let envelope = try? JSONDecoder().decode(PhoenixEnvelope.self, from: data) {
            if envelope.event == "phx_reply" || envelope.event == "phx_close" {
                return
            }

            if let p = envelope.payload {
                let msgText = p.payload?.text ?? p.text
                if let msgText = msgText, !msgText.isEmpty {
                    let rawTheme = p.payload?.theme ?? p.theme
                    let sender = p.payload?.sender ?? p.sender
                    let emoji = p.payload?.emoji ?? p.emoji
                    let sound = p.payload?.sound ?? p.sound ?? SettingsStore.shared.soundEnabled

                    let theme = TickerTheme(rawValue: rawTheme ?? "") ?? SettingsStore.shared.defaultTheme
                    let msg = TickerMessage(
                        text: msgText,
                        sender: sender,
                        emoji: emoji,
                        theme: theme,
                        soundEnabled: sound
                    )
                    HUDWindowManager.shared.present(message: msg)
                    return
                }
            }
        }

        // 2. Try Direct JSON Payload
        if let payload = try? JSONDecoder().decode(DirectPayload.self, from: data) {
            let theme = TickerTheme(rawValue: payload.theme ?? "") ?? SettingsStore.shared.defaultTheme
            let msg = TickerMessage(
                text: payload.text,
                sender: payload.sender,
                emoji: payload.emoji,
                theme: theme,
                soundEnabled: payload.sound ?? SettingsStore.shared.soundEnabled
            )
            HUDWindowManager.shared.present(message: msg)
            return
        }

        // 3. Fallback plain text string
        if !text.starts(with: "{") {
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
