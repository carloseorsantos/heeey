import SwiftUI
import Combine

/// Handles Focus / "Anti-Vergonha" meeting mute mode.
@MainActor
public final class FocusManager: ObservableObject {
    public static let shared = FocusManager()

    @Published public private(set) var isFocusActive: Bool = false
    @Published public private(set) var activeDuration: FocusDuration? = nil
    @Published public private(set) var remainingSeconds: Int = 0

    private var timer: Timer?

    private init() {}

    public var statusDescription: String {
        guard isFocusActive else { return "Letreiro Ativo" }
        if activeDuration == .indefinite {
            return "Modo Foco Ativo (Pausado)"
        }
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "Modo Foco (%02d:%02d)", minutes, seconds)
    }

    public func startFocus(duration: FocusDuration) {
        stopFocus() // Reset previous timer if any

        self.isFocusActive = true
        self.activeDuration = duration

        if let interval = duration.timeInterval {
            self.remainingSeconds = Int(interval)
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                Task { @MainActor [weak self] in
                    guard let self = self else { return }
                    if self.remainingSeconds > 1 {
                        self.remainingSeconds -= 1
                    } else {
                        self.stopFocus()
                    }
                }
            }
        } else {
            // Indefinite
            self.remainingSeconds = 0
        }
    }

    public func stopFocus() {
        timer?.invalidate()
        timer = nil
        isFocusActive = false
        activeDuration = nil
        remainingSeconds = 0
    }

    public func toggleFocus() {
        if isFocusActive {
            stopFocus()
        } else {
            startFocus(duration: .thirtyMinutes)
        }
    }
}
