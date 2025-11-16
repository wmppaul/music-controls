import SwiftUI
import AppKit

@MainActor
class WindowManager: ObservableObject {
    private var settingsWindow: NSWindow?

    func openSettings(hotkeyManager: HotkeyManager) {
        print("WindowManager: openSettings called")

        NSApp.activate(ignoringOtherApps: true)

        // Check if window already exists
        if let existingWindow = settingsWindow, existingWindow.isVisible {
            print("Window exists and is visible, bringing to front")
            existingWindow.makeKeyAndOrderFront(nil)
            return
        }

        print("Creating new settings window...")
        // Create new window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 550),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )

        window.title = "Settings"
        window.contentView = NSHostingView(rootView: SettingsView(hotkeyManager: hotkeyManager))
        window.center()
        window.isReleasedWhenClosed = false
        window.level = .floating

        // Store the window
        settingsWindow = window

        print("Making window key and order front...")
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        print("Window should be visible now!")
    }
}
