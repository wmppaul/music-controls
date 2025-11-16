import SwiftUI

@main
struct AppleMusicControllerApp: App {
    @State private var hotkeyManager = HotkeyManager()
    @StateObject private var windowManager = WindowManager()

    var body: some Scene {
        // Menu bar extra
        MenuBarExtra("Apple Music Controller", systemImage: "music.note") {
            Toggle("Enable Hotkeys", isOn: $hotkeyManager.hotkeysEnabled)

            Divider()

            Button("Settings...") {
                print("Settings button clicked!")
                windowManager.openSettings(hotkeyManager: hotkeyManager)
            }
            .keyboardShortcut(",", modifiers: .command)

            Divider()

            if hotkeyManager.abMarkerState.hasMarkers {
                Section("A-B Loop") {
                    Toggle("Loop Active", isOn: Binding(
                        get: { hotkeyManager.abMarkerState.isLooping },
                        set: { _ in hotkeyManager.abMarkerState.toggleLoop() }
                    ))

                    Button("Clear Markers") {
                        hotkeyManager.abMarkerState.clearMarkers()
                    }
                }

                Divider()
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        }
        .menuBarExtraStyle(.menu)
    }
}
