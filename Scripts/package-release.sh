#!/bin/bash
# Build the unsigned distribution packages used by the GitHub release workflow.
set -euo pipefail

cd "$(dirname "$0")/.."
VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' Resources/Info.plist)"
APP="${1:-$(Scripts/build.sh release | tail -n 1)}"
DIST="$PWD/dist"
STAGE="$(mktemp -d "${TMPDIR:-/tmp}/airstats-release.XXXXXX")"
trap 'rm -rf "$STAGE"' EXIT

test -d "$APP" || { echo "error: app bundle not found: $APP" >&2; exit 1; }
mkdir -p "$DIST"
ZIP="$DIST/AirStats-zh-CN-v${VERSION}-macOS-arm64.zip"
DMG="$DIST/AirStats-zh-CN-v${VERSION}-macOS-arm64.dmg"
rm -f "$ZIP" "$DMG"

ditto -c -k --keepParent "$APP" "$ZIP"
ditto "$APP" "$STAGE/AirStats.app"
ln -s /Applications "$STAGE/Applications"
hdiutil create -volname "AirStats $VERSION" -srcfolder "$STAGE" \
  -ov -format UDZO "$DMG" >/dev/null

(cd "$DIST" && shasum -a 256 "$(basename "$DMG")" "$(basename "$ZIP")" \
  > "SHA256SUMS-v${VERSION}.txt")
echo "$DMG"
echo "$ZIP"
