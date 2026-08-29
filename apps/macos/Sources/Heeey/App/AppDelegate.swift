import AppKit
import SwiftUI
import Combine

public final class AppDelegate: NSObject, NSApplicationDelegate {
    private var cancellables = Set<AnyCancellable>()

    public func applicationDidFinishLaunching(_ notification: Notification) {
        // Run as background accessory without taking over the Dock
        NSApp.setActivationPolicy(.accessory)

        // Setup native Menu Bar item & popover
        MenuBarManager.shared.setup()

        // Setup top HUD floating window
        HUDWindowManager.shared.setupPanel()

        // Connect real-time sync
        SyncManager.shared.connect()

        // Observe focus state changes to update menu bar icon
        FocusManager.shared.$isFocusActive
            .receive(on: DispatchQueue.main)
            .sink { isActive in
                MenuBarManager.shared.updateIcon(isFocusActive: isActive)
            }
            .store(in: &cancellables)
    }

    public func applicationWillTerminate(_ notification: Notification) {
        SyncManager.shared.disconnect()
    }
}
