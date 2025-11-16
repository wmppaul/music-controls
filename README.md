# Apple Music Controller

A macOS menu bar app that lets you control Apple Music playback with customizable global keyboard shortcuts. Perfect for musicians who practice along with music and need quick rewind/forward controls and A-B loop functionality.

![Menu Bar Icon](https://img.shields.io/badge/macOS-14%2B-blue) ![Swift](https://img.shields.io/badge/Swift-5.9-orange)

<img width="712" height="794" alt="image" src="https://github.com/user-attachments/assets/d668dcd0-ae3f-4264-a029-e3354e2a3076" />


## Features

- **Global Keyboard Shortcuts**: Control playback from any app
- **Customizable Hotkeys**: Configure your own shortcuts with custom time values
- **A-B Loop Markers**: Set two points in a song and loop between them automatically
- **Precise Time Control**: Edit marker positions down to centiseconds (1/100th second)
- **Menu Bar Integration**: Lives in your menu bar, stays out of your way
- **Enable/Disable Toggle**: Quickly turn hotkeys on/off without quitting

## Default Keyboard Shortcuts

All shortcuts use the **Option (⌥)** modifier to avoid conflicts with system shortcuts:

- `Option+,` - Rewind 2 seconds
- `Option+Shift+,` - Rewind 5 seconds
- `Option+.` - Forward 2 seconds
- `Option+Shift+.` - Forward 5 seconds
- `Option+A` - Set marker A at current position
- `Option+B` - Set marker B at current position
- `Option+L` - Toggle A-B loop on/off
- `Option+C` - Clear markers

**All shortcuts are customizable** in the Settings window, and you can adjust the rewind/forward time values!

## Requirements

- macOS 14 (Sonoma) or later
- Apple Music app
- Xcode 15+ (for building from source)

## Installation

### Option 1: Download Pre-built App (Recommended)

1. Go to the [Releases](../../releases) page
2. Download the latest `AppleMusicController.app.zip`
3. Unzip the file
4. **Move the app to your Applications folder** (optional but recommended)
5. **First launch**:
   - Right-click on the app → **Open** (don't double-click!)
   - macOS will show a security warning
   - Click **"Open"** to confirm
6. **Grant Input Monitoring permission**:
   - Go to **System Settings → Privacy & Security → Input Monitoring**
   - Enable the checkbox for **AppleMusicController**
   - Quit and restart the app

### Option 2: Build from Source

#### Using Xcode (Easiest)

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/AppleMusicController.git
   cd AppleMusicController
   ```

2. **Open in Xcode**:
   - Open Xcode
   - File → New → Project → macOS → App
   - Product Name: `AppleMusicController`
   - Save it in the parent directory of this repo

3. **Add source files**:
   - Delete the default Swift files Xcode created
   - Drag the `Sources` folder into your Xcode project

4. **Add KeyboardShortcuts package**:
   - File → Add Package Dependencies
   - Enter: `https://github.com/sindresorhus/KeyboardShortcuts`
   - Add to target

5. **Configure project settings**:
   - Select your project → Target → **Signing & Capabilities**
   - **Remove App Sandbox** (click the `-` button)
   - Go to **Info** tab
   - Add these keys:
     - `Application is agent (UIElement)` = `YES`
     - `Privacy - AppleEvents Sending Usage Description` = `This app needs to control Apple Music playback`

6. **Build and run**: Press `⌘R`

#### Using Swift Package Manager (Command Line)

```bash
git clone https://github.com/yourusername/AppleMusicController.git
cd AppleMusicController
swift build -c release
```

Note: This builds a command-line executable. For a proper .app bundle, use Xcode.

## Usage

### Getting Started

1. **Launch the app** - You'll see a music note (♪) icon in your menu bar
2. **Click the icon** to access:
   - **Enable Hotkeys** toggle - Turn shortcuts on/off
   - **Settings...** - Configure shortcuts and A-B markers
   - **Quit** - Close the app

3. **Grant Input Monitoring permission** (if you haven't already):
   - System Settings → Privacy & Security → Input Monitoring
   - Enable "AppleMusicController"
   - Restart the app

### Basic Playback Control

1. Start playing a song in Apple Music
2. Use your configured keyboard shortcuts to rewind/forward
3. Customize the time values in Settings → Value column

### A-B Loop for Practice

Perfect for practicing difficult sections of a song:

1. Play a song in Apple Music
2. When you reach the start of the section, press `Option+A`
3. When you reach the end of the section, press `Option+B`
4. Press `Option+L` to start looping
5. The playback will automatically jump back to marker A when it reaches marker B

### Fine-Tuning Markers

1. Open **Settings** (menu bar icon → Settings)
2. In the **A-B Loop Markers** section:
   - Use the ▲▼ buttons to adjust time values
   - Or type directly in the time fields (MM:SS.CS format)
   - Changes apply immediately

### Customizing Shortcuts

1. Open **Settings**
2. In the **Keyboard Shortcuts** table:
   - Click any shortcut field and press your desired key combination
   - Edit the **Value** column to change rewind/forward seconds
   - Use **+** to add new shortcuts
   - Use **-** to remove selected shortcuts

## Troubleshooting

### Shortcuts Not Working?

- ✅ Make sure Input Monitoring permission is granted
- ✅ Check that Apple Music is running
- ✅ Verify "Enable Hotkeys" is ON in the menu bar menu
- ✅ Make sure shortcuts aren't conflicting with other apps
- ✅ Try customizing the shortcuts if there are conflicts

### A-B Loop Not Working?

- ✅ Ensure both A and B markers are set
- ✅ Verify the loop toggle is enabled
- ✅ Check that Music is playing (not paused)
- ✅ Make sure marker A comes before marker B in time

### Settings Window Won't Open?

- Try quitting and restarting the app
- Check Console.app for error messages
- Rebuild the app from source

### Security Warnings on First Launch

If you downloaded the pre-built app:
1. Don't double-click to open - use **Right-click → Open**
2. If blocked: **System Settings → Privacy & Security**
3. Scroll down to find "AppleMusicController was blocked"
4. Click **"Open Anyway"**

## Known Conflicts

The default shortcuts use the **Option** modifier to minimize conflicts. However, be aware of:

- **Option+comma/period**: Normally produce special characters (`≤`/`≥`) - our shortcuts override this
- **App-specific shortcuts**: Some music apps may use these combinations
- **You can customize** any shortcut that conflicts!

## Development

### Project Structure

```
AppleMusicController/
├── Sources/
│   ├── AppleMusicControllerApp.swift  # Main app entry point
│   ├── Models/
│   │   ├── HotkeyAction.swift         # Hotkey data model
│   │   └── ABMarker.swift             # A-B marker state
│   ├── Services/
│   │   ├── MusicController.swift      # AppleScript interface
│   │   ├── HotkeyManager.swift        # Hotkey coordination
│   │   └── WindowManager.swift        # Window management
│   └── Views/
│       ├── SettingsView.swift         # Main settings window
│       ├── HotkeyTableView.swift      # Hotkey configuration table
│       └── ABMarkerView.swift         # A-B marker controls
├── Releases/                          # Local builds (not in git)
├── Package.swift                      # Swift Package Manager config
└── README.md
```

### Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **MenuBarExtra**: Native menu bar integration (macOS 13+)
- **KeyboardShortcuts**: Global hotkey management ([sindresorhus/KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts))
- **NSAppleScript**: Communicate with Apple Music
- **Timer**: Monitor playback position for A-B looping

### How It Works

**AppleScript Integration:**
```applescript
tell application "Music"
    set player position to player position - 5  # Rewind 5 seconds
end tell
```

**A-B Loop Monitoring:**
A timer checks playback position every 100ms. When looping is active and playback passes marker B, it automatically jumps back to marker A.

**Global Hotkeys:**
Using the KeyboardShortcuts package, the app registers system-wide keyboard listeners that work even when the app isn't focused.

**Visual Feedback:**
When a hotkey is pressed with the Settings window open, the corresponding row flashes blue for instant visual confirmation.

## Contributing

Issues and pull requests are welcome! Feel free to:
- Report bugs
- Suggest new features
- Improve documentation
- Submit code improvements

## License

MIT License - feel free to use and modify as you wish.

## Acknowledgments

- [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts) by Sindre Sorhus - Excellent Swift package for global hotkeys
- Apple Music AppleScript documentation
- All the musicians who practice their craft! 🎵

---

**Made with ♥ for musicians who want better playback control**
