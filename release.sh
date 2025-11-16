#!/bin/bash

# Release build script for Apple Music Controller
# This script helps create a release build and package it

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🎵 Apple Music Controller Release Builder${NC}"
echo ""

# Get version from Version.swift
VERSION=$(grep 'static let current = ' Sources/Version.swift | cut -d'"' -f2)
echo -e "Current version: ${YELLOW}v${VERSION}${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo -e "${RED}Error: Must be run from project root directory${NC}"
    exit 1
fi

# Create Releases directory if it doesn't exist
mkdir -p Releases

# Find the built app (check Desktop first, then DerivedData)
APP_PATH=""

# Check Desktop first (where Archive exports to, including subfolders)
APP_PATH=$(find ~/Desktop -name "AppleMusicController.app" -type d 2>/dev/null | head -1)

# If not on Desktop, check DerivedData
if [ -z "$APP_PATH" ]; then
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "AppleMusicController.app" -type d 2>/dev/null | head -1)
fi

if [ -z "$APP_PATH" ]; then
    echo -e "${RED}Error: AppleMusicController.app not found!${NC}"
    echo ""
    echo "Please build the app in Xcode first:"
    echo "  1. Open your Xcode project"
    echo "  2. Select 'Any Mac' as destination"
    echo "  3. Product → Archive"
    echo "  4. Distribute App → Custom → Built Products"
    echo "  5. Save to Desktop, then run this script again"
    exit 1
fi

echo -e "Found app: ${GREEN}${APP_PATH}${NC}"
echo ""

# Copy to Releases folder
RELEASE_NAME="AppleMusicController-v${VERSION}.app"
RELEASE_PATH="Releases/${RELEASE_NAME}"

echo "Copying app to Releases folder..."
rm -rf "$RELEASE_PATH"
cp -R "$APP_PATH" "$RELEASE_PATH"

# Create zip file
ZIP_NAME="AppleMusicController-v${VERSION}.zip"
ZIP_PATH="Releases/${ZIP_NAME}"

echo "Creating zip file..."
cd Releases
rm -f "$ZIP_NAME"
zip -r "$ZIP_NAME" "${RELEASE_NAME}" -q
cd ..

# Get file sizes
APP_SIZE=$(du -sh "$RELEASE_PATH" | cut -f1)
ZIP_SIZE=$(du -sh "$ZIP_PATH" | cut -f1)

echo ""
echo -e "${GREEN}✅ Release created successfully!${NC}"
echo ""
echo "📦 Files created:"
echo "  - $RELEASE_PATH ($APP_SIZE)"
echo "  - $ZIP_PATH ($ZIP_SIZE)"
echo ""
echo "Next steps:"
echo "  1. Test the app: open '$RELEASE_PATH'"
echo "  2. Create a git tag: git tag v${VERSION}"
echo "  3. Push tag: git push origin v${VERSION}"
echo "  4. Create GitHub Release and upload: $ZIP_PATH"
echo ""
echo -e "${YELLOW}Remember to update CHANGELOG.md before releasing!${NC}"
