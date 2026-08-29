import SwiftUI
import AppKit

@main
struct HeeeyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var focusManager = FocusManager.shared
    @StateObject private var syncManager = SyncManager.shared

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: focusManager.isFocusActive ? "moon.fill" : "sparkles")
                if focusManager.isFocusActive {
                    Text("Pausa")
                        .font(.caption2)
                }
            }
        }
        .menuBarExtraStyle(.window)
    }
}
