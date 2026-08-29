import SwiftUI

/// Section in the MenuBar allowing the user to quickly pause the ticker for meetings.
public struct FocusModePickerView: View {
    @ObservedObject var focusManager = FocusManager.shared

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Modo Anti-Vergonha / Foco", systemImage: focusManager.isFocusActive ? "moon.fill" : "moon")
                    .font(.headline)
                Spacer()
                if focusManager.isFocusActive {
                    Text(focusManager.statusDescription)
                        .font(.caption)
                        .foregroundColor(.orange)
                        .bold()
                }
            }

            if focusManager.isFocusActive {
                Button(action: {
                    focusManager.stopFocus()
                }) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Reativar Letreiro Agora")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            } else {
                Text("Pausar exibição na tela durante reuniões:")
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: 6) {
                    ForEach([FocusDuration.fifteenMinutes, .thirtyMinutes, .oneHour, .indefinite]) { duration in
                        Button(action: {
                            focusManager.startFocus(duration: duration)
                        }) {
                            Text(duration.title)
                                .font(.system(size: 11, weight: .medium))
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
        .padding(8)
    }
}
