# Changelog

All notable changes to Apple Music Controller will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Additional export formats for markers
- Keyboard shortcut presets
- Dark mode support

## [1.0.0] - 2025-01-16

### Added
- Initial release
- Global keyboard shortcuts with Option modifier
- Customizable rewind/forward actions with configurable time values
- A-B loop markers with automatic looping
- Precise time control with centisecond accuracy
- Menu bar integration
- Enable/disable hotkey toggle
- Visual feedback when hotkeys are triggered (settings window)
- Three-column hotkey table: Keystroke | Action | Value

### Features
- Default shortcuts:
  - Option+, : Rewind 2s
  - Option+Shift+, : Rewind 5s
  - Option+. : Forward 2s
  - Option+Shift+. : Forward 5s
  - Option+A : Set Marker A
  - Option+B : Set Marker B
  - Option+L : Toggle A-B Loop
  - Option+C : Clear Markers

### Technical
- Built with Swift 5.9 and SwiftUI
- Requires macOS 14 (Sonoma) or later
- Uses KeyboardShortcuts package for global hotkey support
- AppleScript integration for Music.app control

---

## Version Number Guidelines

- **MAJOR** (X.0.0): Incompatible API changes, major redesigns
- **MINOR** (1.X.0): New features in a backward compatible manner
- **PATCH** (1.0.X): Backward compatible bug fixes

## Release Types

- 🎉 **Added** - New features
- 🔄 **Changed** - Changes in existing functionality
- 🗑️ **Deprecated** - Soon-to-be removed features
- ❌ **Removed** - Removed features
- 🐛 **Fixed** - Bug fixes
- 🔒 **Security** - Vulnerability fixes
