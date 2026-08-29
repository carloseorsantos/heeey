import SwiftUI
import AppKit

@main
struct HeeeyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var focusManager = FocusManager.shared

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
        } label: {
            Image(systemName: focusManager.isFocusActive ? "moon.fill" : "sparkles")
        }
        .menuBarExtraStyle(.window)
    }
}
