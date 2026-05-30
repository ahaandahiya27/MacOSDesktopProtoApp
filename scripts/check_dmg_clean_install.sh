#!/bin/bash
# check_dmg_clean_install.sh — simulate a fresh-user clean install of the DMG.
#
# Agent B's scripts/check_release_dmg_validity.sh validates the DMG IN PLACE
# (mounts, verifies signature/version on the app still inside the image). This
# script is complementary: it reproduces what actually happens on a new iMac —
# the user drags the .app OUT of the mounted image into /Applications, then
# launches it. We copy the app to a temp location, detach the image, and verify
# the COPY (so we catch resource-fork / xattr / signature breakage that only
# manifests after the app leaves the read-only DMG).
#
# Steps (each reported PASS / WARN / FAIL):
#   1. locate + attach the DMG (read-only, no browser popup)
#   2. copy desktopAhaan.app out to a temp dir (the "drag to /Applications" step)
#   3. detach the image
#   4. codesign --verify --deep --strict on the COPY
#   5. inspect com.apple.quarantine xattr (informational — set by the browser,
#      not by us; absence here is normal for a locally built DMG)
#   6. spctl --assess --type execute (ad-hoc signing WILL be rejected — WARN,
#      never FAIL, since the shipped build is ad-hoc by design)
#   7. read Contents/Info.plist (version + LSMinimumSystemVersion) — proxy for
#      "the app bundle is intact and launchable" without needing a GUI/AX grant
#   8. cleanup the temp copy
#
# Exit code: 0 if no FAIL step (PASS/WARN only); 1 if any FAIL; 2 on usage error.
# A missing DMG is a WARN (nothing to test — Agent B builds the DMG), exit 0.
#
# Big Sur native tools only: hdiutil, codesign, spctl, xattr, defaults, sips.
# set -u, NOT -e (we must run every step and aggregate the verdict).
#
# Usage:
#   bash scripts/check_dmg_clean_install.sh                 # newest dist/ DMG
#   bash scripts/check_dmg_clean_install.sh path/to.dmg     # explicit DMG

set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# Unique temp paths so concurrent runs (parallel agents) never collide.
MNT="/tmp/dmg-cleaninstall-mnt-$$"
APP_COPY="/tmp/desktopAhaan-cleaninstall-$$.app"

FAILS=0
WARNS=0
PASSES=0

pass() { echo "  [PASS] $*"; PASSES=$((PASSES + 1)); }
warn() { echo "  [WARN] $*"; WARNS=$((WARNS + 1)); }
fail() { echo "  [FAIL] $*"; FAILS=$((FAILS + 1)); }

cleanup() {
    # Detach if still mounted; remove the copy. Best-effort, quiet.
    if [ -d "$MNT" ]; then
        hdiutil detach "$MNT" -quiet 2>/dev/null || hdiutil detach "$MNT" -force -quiet 2>/dev/null || true
        rmdir "$MNT" 2>/dev/null || true
    fi
    rm -rf "$APP_COPY" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

# ── Locate DMG ───────────────────────────────────────────────────────────────
DMG="${1:-}"
if [ -z "$DMG" ]; then
    DMG="$(ls -t dist/desktopAhaan-v*.dmg 2>/dev/null | head -1 || true)"
fi

echo "==> check_dmg_clean_install"
if [ -z "$DMG" ] || [ ! -f "$DMG" ]; then
    warn "no DMG found (looked for dist/desktopAhaan-v*.dmg). Build one with scripts/build_release_dmg.sh first."
    echo "==> verdict: WARN (nothing to test) — $PASSES pass / $WARNS warn / $FAILS fail"
    exit 0
fi
echo "    DMG: $DMG"

# ── Step 1: attach ───────────────────────────────────────────────────────────
mkdir -p "$MNT"
if hdiutil attach "$DMG" -mountpoint "$MNT" -nobrowse -readonly -quiet 2>/dev/null; then
    pass "attached read-only at $MNT"
else
    fail "hdiutil attach failed — DMG is unreadable/corrupt."
    echo "==> verdict: FAIL — $PASSES pass / $WARNS warn / $FAILS fail"
    exit 1
fi

# ── Step 2: copy the .app out (the "drag to /Applications" step) ─────────────
SRC_APP="$(ls -d "$MNT"/*.app 2>/dev/null | head -1 || true)"
if [ -z "$SRC_APP" ] || [ ! -d "$SRC_APP" ]; then
    fail "no .app bundle inside the DMG."
else
    if cp -R "$SRC_APP" "$APP_COPY" 2>/dev/null; then
        pass "copied $(basename "$SRC_APP") out to a clean location"
    else
        fail "cp -R of the app bundle out of the DMG failed."
    fi
fi

# ── Step 3: detach ───────────────────────────────────────────────────────────
if hdiutil detach "$MNT" -quiet 2>/dev/null; then
    pass "detached image"
    rmdir "$MNT" 2>/dev/null || true
else
    warn "hdiutil detach reported an error (will force-detach at cleanup)."
fi

# Remaining steps only make sense if we have a copy.
if [ -d "$APP_COPY" ]; then
    # ── Step 4: codesign on the COPY ────────────────────────────────────────
    if codesign --verify --deep --strict --verbose=2 "$APP_COPY" 2>/dev/null; then
        pass "codesign --verify --deep --strict OK on the extracted copy"
    else
        fail "codesign verification failed on the extracted copy (signature broke after leaving the DMG)."
    fi

    # ── Step 5: quarantine xattr (informational) ────────────────────────────
    if xattr -l "$APP_COPY" 2>/dev/null | grep -q "com.apple.quarantine"; then
        warn "com.apple.quarantine present on the copy (unusual for a local build; Gatekeeper will prompt)."
    else
        pass "no com.apple.quarantine on the local copy (expected; the browser sets it on download)."
    fi

    # ── Step 6: Gatekeeper assessment (ad-hoc → reject is expected) ──────────
    SPCTL_OUT="$(spctl --assess --type execute --verbose=4 "$APP_COPY" 2>&1 || true)"
    if echo "$SPCTL_OUT" | grep -qi "accepted"; then
        pass "spctl accepted (Developer-ID signed / notarized)."
    else
        warn "spctl rejected — expected for an ad-hoc-signed build. Users open via right-click → Open. Detail: $(echo "$SPCTL_OUT" | tr '\n' ' ' | sed 's/  */ /g')"
    fi

    # ── Step 7: Info.plist readable (intact, launchable bundle) ─────────────
    PLIST="$APP_COPY/Contents/Info.plist"
    VER="$(defaults read "$PLIST" CFBundleShortVersionString 2>/dev/null || true)"
    MINOS="$(defaults read "$PLIST" LSMinimumSystemVersion 2>/dev/null || true)"
    if [ -n "$VER" ]; then
        pass "Info.plist readable — CFBundleShortVersionString=$VER"
    else
        fail "Info.plist unreadable or missing CFBundleShortVersionString — bundle is damaged."
    fi
    if [ -n "$MINOS" ]; then
        case "$MINOS" in
            11.*) pass "LSMinimumSystemVersion=$MINOS (Big Sur target)";;
            *)    warn "LSMinimumSystemVersion=$MINOS (expected 11.x for the Late-2014 iMac).";;
        esac
    else
        warn "LSMinimumSystemVersion not set in Info.plist."
    fi

    # ── Step 8: cleanup happens in the EXIT trap ────────────────────────────
fi

# ── Verdict ──────────────────────────────────────────────────────────────────
echo ""
echo "==> verdict: $PASSES pass / $WARNS warn / $FAILS fail"
if [ "$FAILS" -gt 0 ]; then
    echo "    RESULT: FAIL"
    exit 1
elif [ "$WARNS" -gt 0 ]; then
    echo "    RESULT: PASS (with warnings)"
    exit 0
else
    echo "    RESULT: PASS"
    exit 0
fi
