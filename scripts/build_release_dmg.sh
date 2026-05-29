#!/usr/bin/env bash
# build_release_dmg.sh — repeatable DMG packager for desktopAhaan.
#
# Produces:  dist/desktopAhaan-v<version>-<git-sha>.dmg
#
# Pipeline:
#   1. Pre-flight metadata/asset sanity (scripts/check_release_build.sh --no-build).
#   2. Release archive  (xcodebuild ... archive).
#         - Default: AD-HOC signing via desktopAhaan/Config/DevSigning.xcconfig
#           (works headless, no Developer ID / login keychain needed).
#         - If $DEVELOPMENT_TEAM is set: signs with that team and runs a real
#           `xcodebuild -exportArchive` with a generated ExportOptions.plist.
#   3. Stage the .app + an /Applications symlink + an install README.
#   4. hdiutil create ... -format UDZO  → compressed, read-only DMG.
#
# Usage:
#   bash scripts/build_release_dmg.sh                 # ad-hoc signed DMG
#   DEVELOPMENT_TEAM=TQM5Y6FG3Z \                     # Developer-ID export
#     CODE_SIGN_IDENTITY="Developer ID Application" \
#     EXPORT_METHOD=developer-id \
#     bash scripts/build_release_dmg.sh
#
# Big Sur compatibility: uses only macOS 11.5-era tooling (xcodebuild,
# hdiutil, ditto, /usr/libexec/PlistBuddy). hdiutil UDZO is supported on
# every macOS since 10.x.
#
# Note: this builds a fresh archive into /tmp/dd-release each run. The DMG is
# reproducible given the same commit + signing inputs (modulo the .app's
# internal timestamps).

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

SCHEME="desktopAhaan"
APP_NAME="desktopAhaan"
XCCONFIG="desktopAhaan/Config/DevSigning.xcconfig"
DERIVED="/tmp/dd-release"
ARCHIVE_PATH="$DERIVED/desktopAhaan.xcarchive"
EXPORT_DIR="$DERIVED/export"
DIST_DIR="$REPO_ROOT/dist"

echo "== build_release_dmg =="

# ── 0. Pre-flight ─────────────────────────────────────────────────────────
echo "[0/4] Pre-flight metadata + asset sanity"
bash scripts/check_release_build.sh --no-build

# ── Version + sha for the artifact name ───────────────────────────────────
SETTINGS="$(xcodebuild -scheme "$SCHEME" -configuration Release -showBuildSettings 2>/dev/null || true)"
VERSION="$(echo "$SETTINGS" | awk -F' = ' '/^[[:space:]]*MARKETING_VERSION =/ {print $2; exit}' | tr -d '[:space:]')"
VERSION="${VERSION:-0.0}"
GIT_SHA="$(git rev-parse --short HEAD)"
DMG_NAME="desktopAhaan-v${VERSION}-${GIT_SHA}.dmg"
VOL_NAME="desktopAhaan ${VERSION}"

echo "    version=$VERSION  sha=$GIT_SHA  →  dist/$DMG_NAME"

# ── 1. Archive ─────────────────────────────────────────────────────────────
echo "[1/4] Release archive → $ARCHIVE_PATH"
rm -rf "$DERIVED"
mkdir -p "$DERIVED"

ARCHIVE_LOG="$DERIVED/archive.log"
set +e
if [ -n "${DEVELOPMENT_TEAM:-}" ]; then
    echo "    signing with DEVELOPMENT_TEAM=$DEVELOPMENT_TEAM (Developer-ID path)"
    xcodebuild \
        -scheme "$SCHEME" \
        -configuration Release \
        -derivedDataPath "$DERIVED" \
        -destination 'generic/platform=macOS' \
        -archivePath "$ARCHIVE_PATH" \
        ONLY_ACTIVE_ARCH=NO \
        DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM" \
        CODE_SIGN_STYLE="${CODE_SIGN_STYLE:-Manual}" \
        CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY:-Developer ID Application}" \
        archive > "$ARCHIVE_LOG" 2>&1
else
    echo "    ad-hoc signing (base config: $XCCONFIG)"
    # The signing settings are also restated as command-line build settings
    # because target-level settings in the .pbxproj (CODE_SIGN_IDENTITY =
    # "Apple Development", CODE_SIGN_STYLE = Automatic, DEVELOPMENT_TEAM set)
    # OVERRIDE a -xcconfig base. Command-line settings are highest precedence,
    # so they're what actually forces the ad-hoc identity headlessly.
    xcodebuild \
        -scheme "$SCHEME" \
        -configuration Release \
        -derivedDataPath "$DERIVED" \
        -destination 'generic/platform=macOS' \
        -archivePath "$ARCHIVE_PATH" \
        -xcconfig "$XCCONFIG" \
        ONLY_ACTIVE_ARCH=NO \
        CODE_SIGN_STYLE=Manual \
        CODE_SIGN_IDENTITY=- \
        "CODE_SIGN_IDENTITY[sdk=macosx*]=-" \
        DEVELOPMENT_TEAM= \
        PROVISIONING_PROFILE_SPECIFIER= \
        archive > "$ARCHIVE_LOG" 2>&1
fi
ARCHIVE_EXIT=$?
set -e

# xcodebuild exit code is unreliable — verify the archive actually exists.
if [ ! -d "$ARCHIVE_PATH" ] || ! grep -q "ARCHIVE SUCCEEDED" "$ARCHIVE_LOG"; then
    echo "  ✗ archive failed (exit $ARCHIVE_EXIT). Last errors:"
    grep -E "error:" "$ARCHIVE_LOG" | head -20 || true
    echo "  Full log: $ARCHIVE_LOG"
    exit 1
fi
echo "  ✓ ARCHIVE SUCCEEDED"

# ── 2. Obtain the .app ──────────────────────────────────────────────────────
# Developer-ID path: real exportArchive (re-signs + strips for distribution).
# Ad-hoc path: copy straight out of the archive (exportArchive's macOS methods
# all require a Developer ID identity, which the ad-hoc build doesn't have).
APP_PATH=""
if [ -n "${DEVELOPMENT_TEAM:-}" ]; then
    echo "[2/4] exportArchive (method=${EXPORT_METHOD:-developer-id})"
    EXPORT_PLIST="$DERIVED/ExportOptions.plist"
    cat > "$EXPORT_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>${EXPORT_METHOD:-developer-id}</string>
    <key>teamID</key>
    <string>${DEVELOPMENT_TEAM}</string>
    <key>signingStyle</key>
    <string>manual</string>
</dict>
</plist>
PLIST
    rm -rf "$EXPORT_DIR"
    set +e
    xcodebuild -exportArchive \
        -archivePath "$ARCHIVE_PATH" \
        -exportPath "$EXPORT_DIR" \
        -exportOptionsPlist "$EXPORT_PLIST" > "$DERIVED/export.log" 2>&1
    set -e
    APP_PATH="$(/usr/bin/find "$EXPORT_DIR" -maxdepth 1 -name '*.app' -print -quit)"
    if [ -z "$APP_PATH" ]; then
        echo "  ✗ exportArchive produced no .app — see $DERIVED/export.log"
        grep -E "error:" "$DERIVED/export.log" | head -20 || true
        exit 1
    fi
else
    echo "[2/4] Extracting .app from archive (ad-hoc)"
    APP_PATH="$(/usr/bin/find "$ARCHIVE_PATH/Products/Applications" -maxdepth 1 -name '*.app' -print -quit)"
    if [ -z "$APP_PATH" ]; then
        echo "  ✗ no .app inside $ARCHIVE_PATH/Products/Applications"
        exit 1
    fi
fi
echo "  ✓ app: $APP_PATH"

# Verify the signature so a broken sign doesn't ship silently.
if codesign --verify --deep --strict "$APP_PATH" 2>/dev/null; then
    echo "  ✓ codesign --verify passed"
else
    echo "  ⚠ codesign --verify reported issues (ad-hoc signatures are expected to be unsealed)"
fi

# ── 3. Stage DMG contents ───────────────────────────────────────────────────
echo "[3/4] Staging DMG contents"
STAGING="$DERIVED/dmg-staging"
rm -rf "$STAGING"
mkdir -p "$STAGING"
# ditto preserves the bundle's symlinks + resource forks (cp -R can mangle).
ditto "$APP_PATH" "$STAGING/$(basename "$APP_PATH")"
ln -s /Applications "$STAGING/Applications"
cat > "$STAGING/README.txt" <<TXT
desktopAhaan ${VERSION}  (build ${GIT_SHA})

To install:
  1. Drag "desktopAhaan" onto the "Applications" folder in this window.
  2. Open your Applications folder and double-click desktopAhaan.
  3. First time only: macOS may say it "cannot be opened because Apple
     cannot check it for malware." Right-click the app → Open → Open Anyway.
  4. A short welcome tour appears the first time you open it.

This app is offline-first, single-user, and stores nothing off your Mac.
Full instructions: see INSTALL.md in the project repository.
TXT
echo "  ✓ staged app + Applications symlink + README.txt"

# ── 4. Build the DMG ─────────────────────────────────────────────────────────
echo "[4/4] hdiutil create (UDZO compressed)"
mkdir -p "$DIST_DIR"
DMG_OUT="$DIST_DIR/$DMG_NAME"
rm -f "$DMG_OUT"
hdiutil create \
    -srcfolder "$STAGING" \
    -volname "$VOL_NAME" \
    -fs HFS+ \
    -format UDZO \
    -ov \
    "$DMG_OUT" >/dev/null

if [ -f "$DMG_OUT" ]; then
    SIZE="$(du -h "$DMG_OUT" | cut -f1 | tr -d '[:space:]')"
    echo
    echo "== DMG ready: $DMG_OUT ($SIZE) =="
    echo "   Verify:  hdiutil verify \"$DMG_OUT\""
    exit 0
else
    echo "  ✗ hdiutil did not produce $DMG_OUT"
    exit 1
fi
