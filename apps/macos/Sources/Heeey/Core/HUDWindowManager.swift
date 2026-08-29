import AppKit
import SwiftUI
import Combine

/// Manages the floating top-of-screen Dynamic Island / HUD window.
@MainActor
public final class HUDWindowManager: ObservableObject {
    public static let shared = HUDWindowManager()

    @Published public private(set) var currentMessage: TickerMessage?
    @Published public private(set) var isVisible: Bool = false

    private var panel: NSPanel?
    private var messageQueue: [TickerMessage] = []
    private var dismissWorkItem: DispatchWorkItem?

    private init() {
        setupPanel()
    }

    public func setupPanel() {
        guard panel == nil else { return }

        let hostingView = NSHostingView(rootView: TopTickerContainerView(manager: self))

        let initialRect = calculateWindowFrame()
        let newPanel = NSPanel(
            contentRect: initialRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        newPanel.level = .statusBar
        newPanel.isOpaque = false
        newPanel.backgroundColor = .clear
        newPanel.hasShadow = false
        newPanel.ignoresMouseEvents = true
        newPanel.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenAuxiliary]
        newPanel.contentView = hostingView
        newPanel.orderOut(nil)

        self.panel = newPanel
    }

    private func calculateWindowFrame() -> NSRect {
        guard let screen = NSScreen.main else {
            return NSRect(x: 100, y: 100, width: 620, height: 60)
        }

        let screenRect = screen.frame
        let windowWidth: CGFloat = 620
        let windowHeight: CGFloat = 64

        // Center horizontally, anchor to top of screen
        let xPos = screenRect.origin.x + (screenRect.width - windowWidth) / 2.0
        // Screen top coordinate (AppKit Y starts at bottom)
        let yPos = screenRect.origin.y + screenRect.height - windowHeight - 8.0

        return NSRect(x: xPos, y: yPos, width: windowWidth, height: windowHeight)
    }

    public func updatePosition() {
        guard let panel = panel else { return }
        let newFrame = calculateWindowFrame()
        panel.setFrame(newFrame, display: true)
    }

    /// Displays an incoming message in the HUD ticker.
    public func present(message: TickerMessage) {
        // Save to history always
        SettingsStore.shared.addMessageToHistory(message)

        // If Focus Mode is active, do not show HUD to prevent interruption/embarrassment
        if FocusManager.shared.isFocusActive {
            return
        }

        if isVisible {
            // Already displaying a message, queue this one
            messageQueue.append(message)
            return
        }

        displayMessage(message)
    }

    private func displayMessage(_ message: TickerMessage) {
        dismissWorkItem?.cancel()
        dismissWorkItem = nil

        self.currentMessage = message
        self.updatePosition()

        // Show panel
        panel?.orderFrontRegardless()

        withAnimation(.spring(response: 0.5, dampingFraction: 0.72)) {
            self.isVisible = true
        }

        // Play sound chime
        if message.soundEnabled {
            SoundManager.shared.playArrivalSound()
        }

        // Schedule auto-dismiss
        let duration = max(5.0, SettingsStore.shared.autoDismissSeconds)
        let workItem = DispatchWorkItem { [weak self] in
            Task { @MainActor [weak self] in
                self?.dismissCurrent()
            }
        }
        self.dismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
    }

    public func dismissCurrent() {
        dismissWorkItem?.cancel()
        dismissWorkItem = nil

        withAnimation(.easeOut(duration: 0.35)) {
            self.isVisible = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self = self else { return }
            if !self.isVisible {
                self.currentMessage = nil
                self.panel?.orderOut(nil)

                // If more messages are queued, display the next one
                if !self.messageQueue.isEmpty {
                    let next = self.messageQueue.removeFirst()
                    self.displayMessage(next)
                }
            }
        }
    }
}
