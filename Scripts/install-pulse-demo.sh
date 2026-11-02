#!/bin/bash
# Build and install a side-by-side AirStats demo with isolated preferences.
set -euo pipefail

cd "$(dirname "$0")/.."
APP="$(Scripts/build.sh release | tail -n 1)"
DEST="$HOME/Applications/AirStats Pulse Demo.app"

mkdir -p "$HOME/Applications"
rm -rf "$DEST"
ditto "$APP" "$DEST"
/usr/libexec/PlistBuddy -c 'Set :CFBundleIdentifier com.nibaba999.AirStats.zhCN.PulseDemo' "$DEST/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :CFBundleDisplayName AirStats Pulse Demo' "$DEST/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :CFBundleName AirStats Pulse Demo' "$DEST/Contents/Info.plist"
xattr -cr "$DEST" 2>/dev/null || true
xattr -dr com.apple.FinderInfo "$DEST" 2>/dev/null || true
codesign --force --deep --sign - --timestamp=none "$DEST"
codesign --verify --deep --strict "$DEST"

echo "$DEST"
