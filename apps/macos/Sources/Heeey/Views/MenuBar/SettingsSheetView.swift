import SwiftUI

/// Settings and preferences window for Heeey!
public struct SettingsSheetView: View {
    @ObservedObject var settings = SettingsStore.shared
    @ObservedObject var syncManager = SyncManager.shared

    public var body: some View {
        Form {
            Section(header: Text("Identificação & Conexão")) {
                TextField("Seu apelido / Handle:", text: $settings.userHandle)
                    .textFieldStyle(.roundedBorder)

                TextField("Servidor WebSocket / Realtime:", text: $settings.serverURL)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Circle()
                        .fill(syncManager.isConnected ? Color.green : Color.orange)
                        .frame(width: 8, height: 8)
                    Text(syncManager.isConnected ? "Conectado" : "Desconectado")
                        .font(.caption)
                    Spacer()
                    Button(syncManager.isConnected ? "Reconectar" : "Conectar") {
                        syncManager.connect()
                    }
                    .buttonStyle(.bordered)
                }
            }

            Section(header: Text("Aparência & Letreiro")) {
                Picker("Tema Padrão:", selection: $settings.defaultTheme) {
                    ForEach(TickerTheme.allCases) { theme in
                        Text(theme.displayName).tag(theme)
                    }
                }

                VStack(alignment: .leading) {
                    HStack {
                        Text("Velocidade do Letreiro:")
                        Spacer()
                        Text("\(Int(settings.scrollSpeed)) px/s")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $settings.scrollSpeed, in: 30...150, step: 5)
                }

                VStack(alignment: .leading) {
                    HStack {
                        Text("Duração na tela:")
                        Spacer()
                        Text("\(Int(settings.autoDismissSeconds))s")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $settings.autoDismissSeconds, in: 4...20, step: 1)
                }
            }

            Section(header: Text("Efeitos Sonoros")) {
                Toggle("Tocar som ao receber nova mensagem", isOn: $settings.soundEnabled)

                if settings.soundEnabled {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Volume:")
                            Spacer()
                            Text("\(Int(settings.soundVolume * 100))%")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $settings.soundVolume, in: 0.1...1.0, step: 0.1)
                    }

                    Button("Testar Som") {
                        SoundManager.shared.playArrivalSound()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding(20)
        .frame(width: 440, height: 460)
    }
}
