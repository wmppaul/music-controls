# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AppleMusicController is a macOS menu bar app that provides global keyboard shortcuts for controlling Apple Music playback. It's designed for musicians who practice along with music and need precise rewind/forward controls and A-B loop functionality.

## Build System

This project uses a **hybrid Xcode/Swift Package Manager** setup:

- `Package.swift` defines dependencies (KeyboardShortcuts package)
- **Building requires Xcode** - there is no `.xcodeproj` file in the repository
- DO NOT add `Package.swift` to Xcode target membership (it's for SPM only)

### Building in Xcode

1. Create new macOS App project in Xcode (save outside repo)
2. Delete default Swift files, drag in `Sources/` folder
3. Add KeyboardShortcuts package: `https://github.com/sindresorhus/KeyboardShortcuts`
4. **Critical**: Remove App Sandbox from Signing & Capabilities (global hotkeys require this)
5. Add Info.plist keys:
   - `Application is agent (UIElement)` = `YES` (hides from Dock)
   - `Privacy - AppleEvents Sending Usage Description` = descriptive text

See BUILD.md for detailed instructions.

### Creating Releases

Use the `release.sh` script after building in Xcode:

```bash
# 1. Build in Xcode: Product → Archive → Distribute App → Copy App → Save to Desktop
# 2. Run release script
./release.sh

# This creates Releases/AppleMusicController-vX.X.X.zip ready for distribution
```

Version number is controlled by `Sources/Version.swift`. See RELEASING.md for full release process.

## Architecture

### State Management Pattern

The app uses SwiftUI's `@Observable` macro (not `ObservableObject`) for state management:

- `HotkeyManager` - Main coordinator, uses `@Observable`
- `ABMarkerState` - A-B loop state, uses `@Observable`
- `WindowManager` - Settings window lifecycle, uses `@StateObject` (holds NSWindow reference)

### Three-Layer Architecture

```
┌─────────────────────────────────────────────┐
│  AppleMusicControllerApp (MenuBarExtra)     │
│  - Menu bar UI                               │
│  - App lifecycle                             │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│  HotkeyManager (@Observable)                │
│  - Coordinates hotkey actions                │
│  - Manages A-B loop timer (100ms interval)   │
│  - Owns ABMarkerState                        │
│  - Visual feedback (lastTriggeredHotkeyID)   │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│  MusicController (Singleton)                │
│  - AppleScript interface to Music.app        │
│  - Player position get/set                   │
│  - No state, pure service layer              │
└─────────────────────────────────────────────┘
```

### Key Design Decisions

**Global Hotkeys**: Uses KeyboardShortcuts package with custom key codes for comma/period:
```swift
extension KeyboardShortcuts.Key {
    static let comma = Self(rawValue: 43)
    static let period = Self(rawValue: 47)
}
```

**A-B Loop**: Timer-based monitoring (100ms) checks if playback passed marker B, then jumps to marker A:
```swift
// In HotkeyManager
loopTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { ... }
```

**Visual Feedback**: When hotkey pressed, `lastTriggeredHotkeyID` is set, causing table row to flash blue, then cleared after 0.5s.

**Settings Window Management**: `WindowManager` holds strong NSWindow reference to prevent window deallocation. Uses `window.level = .floating` to keep window on top.

**AppleScript Integration**: All Music.app control goes through `MusicController.shared`. Uses synchronous `NSAppleScript.executeAndReturnError()`.

## Data Models

### HotkeyAction
- **NOT Codable** (KeyboardShortcuts.Name isn't Codable)
- Has `value: Double` for configurable seek times
- `timeOffset` computed property returns positive/negative value based on action type

### ActionType
- Enum with associated behavior via `supportsValue` property
- Only `.rewind` and `.forward` support configurable values

### ABMarkerState
- Stores markers as `Double?` (seconds)
- `loopStart`/`loopEnd` computed properties provide validation
- `shouldLoopBack()` checks if current position exceeds marker B

## Common Tasks

### Adding New Hotkey Actions

1. Add case to `ActionType` enum in `Models/HotkeyAction.swift`
2. Add KeyboardShortcuts.Name extension in `Services/HotkeyManager.swift`
3. Add handling in `HotkeyManager.handleAction()`
4. Update default hotkeys in `setupDefaultHotkeys()` if desired

### Modifying AppleScript Commands

All AppleScript lives in `MusicController.swift`. Scripts are simple strings executed synchronously. Error handling returns `nil` on failure.

### Changing Settings UI

- `SettingsView.swift` - Main container (currently 600x650px)
- `HotkeyTableView.swift` - Three-column table with visual feedback
- `ABMarkerView.swift` - Time input controls with up/down buttons

The settings window is created dynamically by `WindowManager.openSettings()` and uses `NSHostingView` to wrap SwiftUI content.

## Critical Requirements

- **App Sandbox MUST be disabled** - Global hotkeys require accessibility features
- **Input Monitoring permission required** - Users must grant in System Settings
- **macOS 14+** - Uses MenuBarExtra API introduced in macOS 13, refined in 14
- **KeyboardShortcuts 2.0+** - Dependency version specified in Package.swift

## Testing Notes

- Test hotkeys with Settings window both open and closed (visual feedback only shows when open)
- Test A-B loop with markers close together (< 1 second) to verify timer responsiveness
- Test permission handling by removing Input Monitoring permission and re-granting
- Verify menu bar icon appears and menu items are responsive

## Troubleshooting Common Issues

**Hotkeys not working**: Check App Sandbox disabled, Input Monitoring granted, hotkeysEnabled = true

**Package.swift compile errors**: Ensure Package.swift is NOT in Xcode target membership (it's metadata only)

**Settings window not appearing**: WindowManager must be `@StateObject` to maintain window reference

**Codable errors on HotkeyAction**: HotkeyAction is intentionally NOT Codable (KeyboardShortcuts.Name limitation)

## File Organization

```
Sources/
├── AppleMusicControllerApp.swift    # Main entry point, MenuBarExtra
├── Version.swift                     # Single source of truth for version
├── Models/
│   ├── HotkeyAction.swift           # Action types, hotkey data
│   └── ABMarker.swift               # A-B loop state machine
├── Services/
│   ├── HotkeyManager.swift          # Coordinator, registers hotkeys, A-B timer
│   ├── MusicController.swift       # AppleScript singleton
│   └── WindowManager.swift         # Settings window lifecycle
└── Views/
    ├── SettingsView.swift           # Main settings container
    ├── HotkeyTableView.swift        # Hotkey configuration table
    └── ABMarkerView.swift           # Marker time inputs with steppers
```

## Version Management

- Version number: `Sources/Version.swift` (single source of truth)
- Changelog: `CHANGELOG.md` (Keep a Changelog format)
- Release process: `RELEASING.md` (step-by-step guide)
- Release script: `release.sh` (automated packaging)

When incrementing version:
1. Update `Version.swift` (both `current` and `build`)
2. Update `CHANGELOG.md` with changes
3. Build in Xcode (Archive → Distribute)
4. Run `./release.sh`
5. Commit, tag, push
6. Create GitHub Release with zip file
