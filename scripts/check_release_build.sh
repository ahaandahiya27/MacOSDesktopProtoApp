#!/usr/bin/env bash
# check_release_build.sh — pre-flight sanity before cutting a DMG.
#
# Validates everything that, if wrong, would ship a broken or unrunnable
# .app to the iMac:
#   1. App version  (CFBundleShortVersionString / MARKETING_VERSION) non-empty
#   2. Build number (CFBundleVersion / CURRENT_PROJECT_VERSION) non-empty
#   3. MACOSX_DEPLOYMENT_TARGET == 11.5   (Big Sur deploy floor)
#   4. Entitlements file present with the locked 5-key set
#   5. AppIcon set complete (all 10 sizes: 16/32/128/256/512 @1x+@2x + Contents.json)
#   6. Release config builds with ZERO warnings (unless --no-build)
#
# Usage:
#   bash scripts/check_release_build.sh            # full check incl. zero-warning build
#   bash scripts/check_release_build.sh --no-build # metadata + assets only (fast)
#
# Exit 0 only when every check passes. Designed to be called standalone OR
# as the first step of scripts/build_release_dmg.sh.
#
# Big Sur note: this runs on the dev Mac's newer Xcode but pins the deploy
# target so a stray macOS 12+ setting can't slip into a release. The actual
# macOS 12+ *API* ban is enforced separately by scripts/check_macos12_apis.py.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

SCHEME="desktopAhaan"
ENTITLEMENTS="desktopAhaan/desktopAhaan.entitlements"
APPICON_DIR="desktopAhaan/Assets.xcassets/AppIcon.appiconset"
EXPECTED_DEPLOYMENT_TARGET="11.5"

DO_BUILD=1
for arg in "$@"; do
    case "$arg" in
        --no-build) DO_BUILD=0 ;;
        *) echo "check_release_build: unknown arg '$arg'"; exit 2 ;;
    esac
done

FAILED=0
fail() { echo "  ✗ $1"; FAILED=1; }
pass() { echo "  ✓ $1"; }

echo "== check_release_build: pre-DMG sanity =="

# ── 1/2/3. Build settings: version, build number, deployment target ──────
echo "[1-3] Build settings (version / build number / deployment target)"
SETTINGS="$(xcodebuild -scheme "$SCHEME" -configuration Release -showBuildSettings 2>/dev/null || true)"

extract() { echo "$SETTINGS" | awk -F' = ' "/^[[:space:]]*$1 =/ {print \$2; exit}" | tr -d '[:space:]'; }

MARKETING_VERSION="$(extract MARKETING_VERSION)"
PROJECT_VERSION="$(extract CURRENT_PROJECT_VERSION)"
DEPLOYMENT_TARGET="$(extract MACOSX_DEPLOYMENT_TARGET)"

if [ -n "$MARKETING_VERSION" ]; then pass "CFBundleShortVersionString = $MARKETING_VERSION"
else fail "MARKETING_VERSION (CFBundleShortVersionString) is empty"; fi

if [ -n "$PROJECT_VERSION" ]; then pass "CFBundleVersion = $PROJECT_VERSION"
else fail "CURRENT_PROJECT_VERSION (CFBundleVersion) is empty"; fi

if [ "$DEPLOYMENT_TARGET" = "$EXPECTED_DEPLOYMENT_TARGET" ]; then
    pass "MACOSX_DEPLOYMENT_TARGET = $DEPLOYMENT_TARGET"
else
    fail "MACOSX_DEPLOYMENT_TARGET = '$DEPLOYMENT_TARGET' (expected $EXPECTED_DEPLOYMENT_TARGET)"
fi

# ── 4. Entitlements: locked 5-key set ────────────────────────────────────
echo "[4] Entitlements (locked 5-key set)"
REQUIRED_ENTITLEMENTS=(
    "com.apple.security.app-sandbox"
    "com.apple.security.network.client"
    "com.apple.security.files.user-selected.read-only"
    "com.apple.security.device.audio-input"
    "com.apple.security.temporary-exception.files.home-relative-path.read-write"
)
if [ ! -f "$ENTITLEMENTS" ]; then
    fail "entitlements file missing: $ENTITLEMENTS"
else
    for key in "${REQUIRED_ENTITLEMENTS[@]}"; do
        if grep -q "$key" "$ENTITLEMENTS"; then pass "entitlement: $key"
        else fail "entitlement MISSING: $key"; fi
    done
    # Guard the locked count: exactly 5 <key> entries.
    KEY_COUNT="$(grep -c "<key>" "$ENTITLEMENTS" || true)"
    if [ "$KEY_COUNT" = "5" ]; then pass "entitlement key count = 5 (locked)"
    else fail "entitlement key count = $KEY_COUNT (expected 5 — EntitlementsSnapshotTest pins this)"; fi
fi

# ── 5. AppIcon set complete ───────────────────────────────────────────────
echo "[5] AppIcon set (10 PNGs + Contents.json)"
EXPECTED_ICONS=(
    icon-16-1x.png icon-16-2x.png
    icon-32-1x.png icon-32-2x.png
    icon-128-1x.png icon-128-2x.png
    icon-256-1x.png icon-256-2x.png
    icon-512-1x.png icon-512-2x.png
)
if [ ! -d "$APPICON_DIR" ]; then
    fail "AppIcon set missing: $APPICON_DIR"
else
    [ -f "$APPICON_DIR/Contents.json" ] && pass "Contents.json present" || fail "Contents.json missing"
    MISSING_ICONS=0
    for icon in "${EXPECTED_ICONS[@]}"; do
        [ -f "$APPICON_DIR/$icon" ] || { fail "icon missing: $icon"; MISSING_ICONS=1; }
    done
    [ "$MISSING_ICONS" = "0" ] && pass "all 10 icon PNGs present"
fi

# ── 6. Zero-warning Release build ─────────────────────────────────────────
if [ "$DO_BUILD" = "1" ]; then
    echo "[6] Zero-warning Release build"
    BUILD_LOG="$(mktemp -t check_release_build)"
    DERIVED="/tmp/dd-check-release"
    rm -rf "$DERIVED"
    set +e
    xcodebuild \
        -scheme "$SCHEME" \
        -configuration Release \
        -derivedDataPath "$DERIVED" \
        -destination 'generic/platform=macOS' \
        build > "$BUILD_LOG" 2>&1
    BUILD_EXIT=$?
    set -e
    # xcodebuild's exit code is unreliable (see ci-build-test.sh) — grep the log.
    if grep -q "BUILD SUCCEEDED" "$BUILD_LOG"; then
        pass "Release build SUCCEEDED"
    else
        fail "Release build did NOT succeed (exit $BUILD_EXIT) — see $BUILD_LOG"
        grep -E "error:" "$BUILD_LOG" | head -20 || true
    fi
    WARN_COUNT="$(grep -c "warning:" "$BUILD_LOG" || true)"
    if [ "$WARN_COUNT" = "0" ]; then
        pass "zero compiler warnings"
        rm -f "$BUILD_LOG"
    else
        fail "$WARN_COUNT compiler warning(s) — release builds must be warning-free"
        grep -E "warning:" "$BUILD_LOG" | head -20 || true
        echo "  (full log: $BUILD_LOG)"
    fi
else
    echo "[6] Zero-warning Release build — SKIPPED (--no-build)"
fi

echo
if [ "$FAILED" = "0" ]; then
    echo "== check_release_build: ALL CHECKS PASSED =="
    exit 0
else
    echo "== check_release_build: FAILED — fix the ✗ items above before cutting a DMG =="
    exit 1
fi
