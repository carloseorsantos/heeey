import SwiftUI

/// Displays received message history in the Menu Bar.
public struct MessageHistoryView: View {
    @ObservedObject var settings = SettingsStore.shared

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label("Histórico de Mensagens", systemImage: "clock.arrow.circlepath")
                    .font(.headline)
                Spacer()
                if !settings.history.isEmpty {
                    Button("Limpar") {
                        settings.clearHistory()
                    }
                    .font(.caption)
                    .buttonStyle(.plain)
                    .foregroundColor(.secondary)
                }
            }

            if settings.history.isEmpty {
                Text("Nenhuma mensagem recebida ainda.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(settings.history.prefix(10)) { msg in
                            HStack(alignment: .top, spacing: 8) {
                                Text(msg.emoji ?? "💬")
                                    .font(.system(size: 16))

                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text(msg.sender ?? "Anônimo")
                                            .font(.caption)
                                            .bold()
                                        Spacer()
                                        Text(msg.timestamp, style: .time)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                    Text(msg.text)
                                        .font(.system(size: 12))
                                        .lineLimit(2)
                                }
                            }
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.primary.opacity(0.04))
                            )
                        }
                    }
                }
                .frame(maxHeight: 180)
            }
        }
        .padding(8)
    }
}
