import Foundation
import AppKit
import KeyboardShortcuts

@Observable
class HotkeyManager {
    var hotkeys: [HotkeyAction] = []
    let abMarkerState = ABMarkerState()
    var hotkeysEnabled: Bool = true {
        didSet {
            if hotkeysEnabled {
                registerAllHotkeys()
            } else {
                unregisterAllHotkeys()
            }
        }
    }
    var lastTriggeredHotkeyID: UUID?

    private var loopTimer: Timer?
    private var registeredShortcuts: Set<KeyboardShortcuts.Name> = []

    init() {
        setupDefaultHotkeys()
        registerAllHotkeys()
        setupABLoopMonitoring()
    }

    // MARK: - Setup

    private func setupDefaultHotkeys() {
        // Define default shortcuts (users can change these)
        hotkeys = [
            HotkeyAction(shortcutName: .rewind2, action: .rewind, value: 2.0),
            HotkeyAction(shortcutName: .rewind5, action: .rewind, value: 5.0),
            HotkeyAction(shortcutName: .forward2, action: .forward, value: 2.0),
            HotkeyAction(shortcutName: .forward5, action: .forward, value: 5.0),
            HotkeyAction(shortcutName: .setMarkerA, action: .setMarkerA),
            HotkeyAction(shortcutName: .setMarkerB, action: .setMarkerB),
            HotkeyAction(shortcutName: .toggleABLoop, action: .toggleABLoop),
            HotkeyAction(shortcutName: .clearMarkers, action: .clearMarkers),
        ]
    }

    // MARK: - Hotkey Registration

    func registerAllHotkeys() {
        // Unregister existing shortcuts
        registeredShortcuts.forEach { KeyboardShortcuts.disable($0) }
        registeredShortcuts.removeAll()

        // Register all hotkeys
        for hotkey in hotkeys {
            registerHotkey(hotkey)
        }
    }

    func unregisterAllHotkeys() {
        // Unregister all shortcuts
        registeredShortcuts.forEach { KeyboardShortcuts.disable($0) }
        registeredShortcuts.removeAll()
    }

    private func registerHotkey(_ hotkey: HotkeyAction) {
        KeyboardShortcuts.onKeyUp(for: hotkey.shortcutName) { [weak self] in
            guard let self = self else { return }

            // Trigger visual feedback
            self.lastTriggeredHotkeyID = hotkey.id

            // Clear after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.lastTriggeredHotkeyID == hotkey.id {
                    self.lastTriggeredHotkeyID = nil
                }
            }

            self.handleAction(hotkey)
        }
        registeredShortcuts.insert(hotkey.shortcutName)
    }

    func addHotkey(action: ActionType) {
        let newShortcut = KeyboardShortcuts.Name("action_\(UUID().uuidString)")
        let newHotkey = HotkeyAction(shortcutName: newShortcut, action: action)
        hotkeys.append(newHotkey)
        registerHotkey(newHotkey)
    }

    func removeHotkey(_ hotkey: HotkeyAction) {
        KeyboardShortcuts.disable(hotkey.shortcutName)
        registeredShortcuts.remove(hotkey.shortcutName)
        hotkeys.removeAll { $0.id == hotkey.id }
    }

    // MARK: - Action Handling

    private func handleAction(_ hotkey: HotkeyAction) {
        switch hotkey.action {
        case .rewind, .forward:
            _ = MusicController.shared.seek(bySeconds: hotkey.timeOffset)

        case .setMarkerA:
            if let position = MusicController.shared.getPlayerPosition() {
                abMarkerState.setMarkerA(position)
            }

        case .setMarkerB:
            if let position = MusicController.shared.getPlayerPosition() {
                abMarkerState.setMarkerB(position)
            }

        case .toggleABLoop:
            abMarkerState.toggleLoop()

        case .clearMarkers:
            abMarkerState.clearMarkers()
        }
    }

    // MARK: - A-B Loop Monitoring

    private func setupABLoopMonitoring() {
        // Check every 100ms if we need to loop back
        loopTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.checkABLoop()
        }
    }

    private func checkABLoop() {
        guard abMarkerState.isLooping,
              let currentPosition = MusicController.shared.getPlayerPosition(),
              let loopStart = abMarkerState.loopStart else {
            return
        }

        if abMarkerState.shouldLoopBack(currentPosition: currentPosition) {
            _ = MusicController.shared.setPlayerPosition(loopStart)
        }
    }
}

// MARK: - KeyboardShortcuts.Name Extensions

extension KeyboardShortcuts.Name {
    static let rewind2 = Self("rewind2", default: .init(.comma, modifiers: [.option]))
    static let rewind5 = Self("rewind5", default: .init(.comma, modifiers: [.option, .shift]))
    static let forward2 = Self("forward2", default: .init(.period, modifiers: [.option]))
    static let forward5 = Self("forward5", default: .init(.period, modifiers: [.option, .shift]))
    static let rewind10 = Self("rewind10")
    static let forward10 = Self("forward10")
    static let setMarkerA = Self("setMarkerA", default: .init(.a, modifiers: [.option]))
    static let setMarkerB = Self("setMarkerB", default: .init(.b, modifiers: [.option]))
    static let toggleABLoop = Self("toggleABLoop", default: .init(.l, modifiers: [.option]))
    static let clearMarkers = Self("clearMarkers", default: .init(.c, modifiers: [.option]))
}

// Helper for key codes
extension KeyboardShortcuts.Key {
    static let comma = Self(rawValue: 43)
    static let period = Self(rawValue: 47)
}
