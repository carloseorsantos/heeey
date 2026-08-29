import AppKit

/// Plays retro notification chimes and feedback sounds.
@MainActor
public final class SoundManager {
    public static let shared = SoundManager()

    private init() {}

    public enum SoundType: String, CaseIterable, Identifiable {
        case pop = "Pop"
        case ping = "Ping"
        case tink = "Tink"
        case hero = "Hero"
        case glass = "Glass"

        public var id: String { rawValue }
    }

    public func playArrivalSound(type: SoundType = .pop) {
        guard SettingsStore.shared.soundEnabled else { return }

        if let sound = NSSound(named: NSSound.Name(type.rawValue)) {
            sound.volume = Float(SettingsStore.shared.soundVolume)
            sound.play()
        } else {
            NSSound.beep()
        }
    }
}
