# Building AppleMusicController

## Quick Build Instructions

### For End Users (No Xcode Project File)

Since this repo doesn't include an `.xcodeproj` file, you'll need to create one:

#### Method 1: Create Xcode Project (Recommended)

1. **Open Xcode**
2. **File → New → Project**
3. Select **macOS → App**
4. Fill in:
   - Product Name: `AppleMusicController`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - **Uncheck** "Use Core Data"
   - **Uncheck** "Include Tests"
5. Save in a **different location** (not inside this repo folder)

6. **Add Source Files**:
   - Delete the default files Xcode created
   - Drag the `Sources` folder from this repo into Xcode

7. **Add Package Dependency**:
   - File → Add Package Dependencies
   - Paste: `https://github.com/sindresorhus/KeyboardShortcuts`
   - Click "Add Package"

8. **Configure Settings**:
   - Click project name (blue icon) → Target → **Signing & Capabilities**
   - Find **App Sandbox** → Click the **`-`** button to remove it
   - Go to **Info** tab → Add Custom Keys:
     - Right-click in the list → **Add Row**
     - Key: `Application is agent (UIElement)` → Type: Boolean → Value: `YES`
     - Add another row:
     - Key: `Privacy - AppleEvents Sending Usage Description` → Type: String → Value: `This app needs to control Apple Music playback`

9. **Build**: Press `⌘B`
10. **Run**: Press `⌘R`

#### Method 2: Archive for Distribution

After setting up the Xcode project above:

1. **Product → Archive**
2. Wait for archive to complete
3. In Organizer window: **Distribute App**
4. Choose **Copy App**
5. Select destination folder
6. You'll get `AppleMusicController.app` ready to share!

### For Developers (Swift Package Manager)

This builds a command-line executable (not a .app bundle):

```bash
swift build -c release
.build/release/AppleMusicController
```

**Note**: This won't create a proper macOS app bundle with menu bar icon. Use Xcode for that.

## Troubleshooting Build Issues

### "No such module 'KeyboardShortcuts'"
- Make sure you added the package dependency in Xcode
- Try: Product → Clean Build Folder (⌘⇧K), then rebuild

### Build fails with sandbox errors
- Ensure App Sandbox is **removed** from Signing & Capabilities

### "Missing Info.plist keys"
- Add the `LSUIElement` and `NSAppleEventsUsageDescription` keys in the Info tab

### Can't find Sources files
- Make sure you dragged the entire `Sources` folder into Xcode
- Check that files have the target checkbox enabled in File Inspector

## Creating a Release

1. **Archive** in Xcode (see above)
2. **Export** the .app file
3. **Zip it**:
   ```bash
   cd /path/to/exported/app
   zip -r AppleMusicController.app.zip AppleMusicController.app
   ```
4. **Upload to GitHub Releases**:
   - Go to repository → Releases → Create new release
   - Upload the .zip file
   - Add release notes

## Why No .xcodeproj in Repo?

Xcode project files are:
- Machine-specific (contain absolute paths)
- Generated differently on each machine
- Merge conflicts are common
- Not necessary when using Swift Package Manager

Instead, we provide clear instructions to create the project locally.
