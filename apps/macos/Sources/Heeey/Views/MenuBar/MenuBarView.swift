import SwiftUI
import AppKit

/// Primary dropdown content shown when clicking the macOS menu bar icon.
public struct MenuBarView: View {
    @ObservedObject var focusManager = FocusManager.shared
    @ObservedObject var syncManager = SyncManager.shared
    @ObservedObject var settings = SettingsStore.shared

    @State private var showingSettingsWindow = false

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 8) {
                Text("💬")
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Heeey!")
                        .font(.headline)
                        .bold()
                    HStack(spacing: 4) {
                        Circle()
                            .fill(syncManager.isConnected ? Color.green : Color.orange)
                            .frame(width: 6, height: 6)
                        Text(focusManager.isFocusActive ? focusManager.statusDescription : (syncManager.isConnected ? "@\(settings.userHandle)" : "Desconectado"))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Button(action: {
                    openSettingsWindow()
                }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(12)
            .background(Color.primary.opacity(0.04))

            Divider()

            // Focus Mode Anti-Vergonha Section
            FocusModePickerView()

            Divider()

            // Test Letreiro Button
            VStack(alignment: .leading, spacing: 6) {
                Text("Ações Rápidas")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.top, 6)

                Button(action: {
                    triggerRandomTest()
                }) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Testar Letreiro na Tela")
                        Spacer()
                        Text("Simular")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                }
                .buttonStyle(.plain)
            }

            Divider()

            // Message History Section
            MessageHistoryView()

            Divider()

            // Footer
            HStack {
                Button("Preferências...") {
                    openSettingsWindow()
                }
                .font(.caption)
                .buttonStyle(.plain)

                Spacer()

                Button("Sair") {
                    NSApplication.shared.terminate(nil)
                }
                .font(.caption)
                .buttonStyle(.plain)
                .foregroundColor(.red)
            }
            .padding(10)
            .background(Color.primary.opacity(0.02))
        }
        .frame(width: 320)
    }

    private func triggerRandomTest() {
        let sampleMessages = [
            ("eae carlos bora tomar um café?", "Ana", "☕", TickerTheme.ledGreen),
            ("o deploy em produção passou liso! 🚀", "Dev Team", "🎉", TickerTheme.cyberpunkNeon),
            ("seu letreiro retrô ficou animal!", "Pedro", "👾", TickerTheme.pixel8Bit),
            ("reunião de sync cancelada hoje!", "Squad", "🥳", TickerTheme.ledAmber),
            ("olha esse efeito de vidro no Mac!", "Design", "✨", TickerTheme.liquidGlass)
        ]
        let item = sampleMessages.randomElement()!
        SyncManager.shared.triggerTestMessage(
            text: item.0,
            sender: item.1,
            emoji: item.2,
            theme: item.3
        )
    }

    private func openSettingsWindow() {
        let settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 440, height: 460),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        settingsWindow.title = "Preferências do Heeey!"
        settingsWindow.center()
        settingsWindow.contentView = NSHostingView(rootView: SettingsSheetView())
        settingsWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
