import AppKit
import SwiftUI

/// Manages the native macOS status bar item and popover dropdown.
@MainActor
public final class MenuBarManager: NSObject, ObservableObject {
    public static let shared = MenuBarManager()

    private var statusItem: NSStatusItem?
    private var popover: NSPopover?

    private override init() {
        super.init()
    }

    public func setup() {
        guard statusItem == nil else { return }

        // Create status bar item
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = item.button {
            button.image = NSImage(systemSymbolName: "sparkles", accessibilityDescription: "Heeey!")
            button.target = self
            button.action = #selector(statusBarButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        // Create popover hosting SwiftUI MenuBarView
        let pop = NSPopover()
        pop.contentSize = NSSize(width: 320, height: 460)
        pop.behavior = .transient
        pop.animates = true
        pop.contentViewController = NSHostingController(rootView: MenuBarView())

        self.statusItem = item
        self.popover = pop
    }

    @objc private func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        guard let popover = popover else { return }

        if popover.isShown {
            popover.performClose(sender)
        } else {
            // Refresh content view controller
            popover.contentViewController = NSHostingController(rootView: MenuBarView())
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }

    public func updateIcon(isFocusActive: Bool) {
        guard let button = statusItem?.button else { return }
        let iconName = isFocusActive ? "moon.fill" : "sparkles"
        button.image = NSImage(systemSymbolName: iconName, accessibilityDescription: "Heeey!")
    }

    public func closePopover() {
        popover?.performClose(nil)
    }
}
