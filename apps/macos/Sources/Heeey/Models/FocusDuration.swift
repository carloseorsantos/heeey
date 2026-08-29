import Foundation

/// Represents the focus / meeting mute duration.
public enum FocusDuration: Int, CaseIterable, Identifiable, Codable, Sendable {
    case fifteenMinutes = 15
    case thirtyMinutes = 30
    case oneHour = 60
    case twoHours = 120
    case indefinite = -1

    public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .fifteenMinutes:
            return "15 minutos"
        case .thirtyMinutes:
            return "30 minutos"
        case .oneHour:
            return "1 hora"
        case .twoHours:
            return "2 horas"
        case .indefinite:
            return "Até desativar"
        }
    }

    public var timeInterval: TimeInterval? {
        if self == .indefinite {
            return nil
        }
        return TimeInterval(rawValue * 60)
    }
}
