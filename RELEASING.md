# Release Process

## Versioning System

We use **Semantic Versioning (SemVer)**: `MAJOR.MINOR.PATCH`

- **MAJOR** (1.x.x): Breaking changes, major redesigns
- **MINOR** (x.1.x): New features, additions (backward compatible)
- **PATCH** (x.x.1): Bug fixes, small improvements

## Creating a Release

### 1. Update Version Number

Edit `Sources/Version.swift`:

```swift
enum AppVersion {
    static let current = "1.1.0"  // <-- Update this
    static let build = "2"         // <-- Increment this
    // ...
}
```

### 2. Update CHANGELOG.md

Add your changes under a new version heading:

```markdown
## [1.1.0] - 2025-01-20

### Added
- New feature X
- New action type Y

### Fixed
- Bug with Z
```

### 3. Build in Xcode

**Option A: Quick Build (for testing)**
1. Clean: `⌘⇧K`
2. Build: `⌘B`
3. Run: `⌘R` (to verify it works)

**Option B: Archive (for distribution)**
1. Select **Any Mac** as destination
2. **Product → Archive**
3. In Organizer: **Distribute App**
4. Choose: **Copy App**
5. Save to any location (Desktop is fine)

### 4. Run Release Script

From the project root:

```bash
./release.sh
```

This will:
- Find the built .app
- Copy it to `Releases/AppleMusicController-vX.X.X.app`
- Create a zip: `Releases/AppleMusicController-vX.X.X.zip`
- Show file sizes and next steps

### 5. Test the Release

```bash
open Releases/AppleMusicController-v1.0.0.app
```

Verify:
- App launches correctly
- Menu bar icon appears
- Settings window opens
- Hotkeys work
- Version number is correct in Settings

### 6. Create Git Tag

```bash
git add .
git commit -m "Release v1.1.0"
git tag -a v1.1.0 -m "Version 1.1.0

- Added feature X
- Fixed bug Y"
git push origin main
git push origin v1.1.0
```

### 7. Create GitHub Release

1. Go to: https://github.com/wmppaul/music-controls/releases
2. Click **"Draft a new release"**
3. **Tag**: Select the tag you just created (v1.1.0)
4. **Title**: `v1.1.0 - Description of Release`
5. **Description**: Copy from CHANGELOG.md
6. **Attach binary**: Upload `Releases/AppleMusicController-v1.1.0.zip`
7. Click **"Publish release"**

## Version History Location

- **Source code versions**: Git tags (v1.0.0, v1.1.0, etc.)
- **Compiled releases**: GitHub Releases page
- **Local builds**: `Releases/` folder (not committed to git)
- **Changelog**: `CHANGELOG.md`
- **Current version**: `Sources/Version.swift`

## Quick Reference

### For Patch Release (Bug Fix)
```bash
# 1.0.0 → 1.0.1
# Update Version.swift: current = "1.0.1"
# Update CHANGELOG.md
git commit -m "Fix: bug description"
git tag v1.0.1
```

### For Minor Release (New Feature)
```bash
# 1.0.1 → 1.1.0
# Update Version.swift: current = "1.1.0"
# Update CHANGELOG.md
git commit -m "Add: feature description"
git tag v1.1.0
```

### For Major Release (Breaking Changes)
```bash
# 1.1.0 → 2.0.0
# Update Version.swift: current = "2.0.0"
# Update CHANGELOG.md
git commit -m "Breaking: major change description"
git tag v2.0.0
```

## Checklist Before Releasing

- [ ] Version number updated in `Version.swift`
- [ ] Build number incremented
- [ ] CHANGELOG.md updated with all changes
- [ ] All features tested
- [ ] No compiler warnings
- [ ] App Sandbox is disabled
- [ ] Info.plist keys are set correctly
- [ ] Built with Archive in Xcode
- [ ] Tested the .app from Releases folder
- [ ] Git commit created
- [ ] Git tag created and pushed
- [ ] GitHub Release created with .zip file

## Troubleshooting

### "App not found" when running release.sh
Build the app in Xcode first, or specify the path manually.

### Version shows wrong in app
Make sure you rebuilt after updating Version.swift.

### .zip file too large
Make sure you're building in Release mode (Archive), not Debug.

### GitHub release download issues
Ensure the .zip file is under 100MB. Consider using GitHub's large file storage if needed.
