import AppKit
import SwiftUI

public final class AppDelegate: NSObject, NSApplicationDelegate {
    public func applicationDidFinishLaunching(_ notification: Notification) {
        // Run as background accessory without taking over the Dock
        NSApp.setActivationPolicy(.accessory)

        // Setup top HUD floating window
        Task { @MainActor in
            HUDWindowManager.shared.setupPanel()
            SyncManager.shared.connect()
        }
    }
}
