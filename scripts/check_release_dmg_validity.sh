#!/usr/bin/env bash
# check_release_dmg_validity.sh — post-build sanity for a release DMG.
#
# Run AFTER scripts/build_release_dmg.sh. Verifies that the freshly built
# DMG actually mounts, carries a correctly-signed .app, and ships the
# expected version + Big Sur minimum-OS metadata — so a broken or
# mis-versioned disk image never reaches the kid's parent.
#
# Checks (in order):
#   1. DMG file exists at dist/desktopAhaan-v<version>-<sha>.dmg
#      (auto-discovered if not passed; newest matching DMG wins).
#   2. hdiutil verify  → the image isn't corrupt.
#   3. Mount, locate the .app.
#   4. codesign --verify --deep --strict  → signature is intact.
#      (Ad-hoc signatures verify but aren't "accepted"; that's expected.)
#   5. spctl --assess --type install  → Gatekeeper acceptance. Ad-hoc /
#      unnotarized builds FAIL this; we LOG the result, never gate on it.
#   6. Info.plist CFBundleShortVersionString is non-empty.
#   7. Info.plist LSMinimumSystemVersion == 11.5 (the deploy floor).
#   8. Unmount (always, even on failure — trap).
#
# Output: a PASS / WARN / FAIL banner with per-check diagnostics.
#   PASS — every hard check passed (spctl may still be "rejected"; that's
#          a WARN-level note for ad-hoc builds, not a failure).
#   WARN — all hard checks passed but spctl rejected (expected for ad-hoc).
#   FAIL — a hard check failed (missing DMG, corrupt image, bad signature,
#          empty version, wrong min-OS).
#
# Big Sur compatibility: hdiutil / codesign / spctl / defaults /
# /usr/libexec/PlistBuddy are all present on macOS 11.5+.
#
# Usage:
#   bash scripts/check_release_dmg_validity.sh                 # auto-discover newest DMG
#   bash scripts/check_release_dmg_validity.sh dist/foo.dmg    # explicit DMG
#   bash scripts/check_release_dmg_validity.sh --help
#
# Exit code: 0 on PASS or WARN, 1 on FAIL. (WARN is non-fatal so a CI tag
# push isn't blocked merely because the build is ad-hoc-signed.)

set -uo pipefail

EXPECTED_MIN_OS="11.5"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
DIST_DIR="$REPO_ROOT/dist"

usage() {
    sed -n '2,40p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
}

# ── Result accumulation ──────────────────────────────────────────────────────
FAILED=0          # any hard check failed
WARNED=0          # a soft check (spctl) flagged
declare -a NOTES  # diagnostic lines

note()  { NOTES+=("    $1"); }
hard_fail() { echo "  ✗ $1"; FAILED=1; }
soft_warn() { echo "  ⚠ $1"; WARNED=1; }
pass_line() { echo "  ✓ $1"; }

MOUNT_POINT=""
cleanup() {
    if [ -n "$MOUNT_POINT" ] && [ -d "$MOUNT_POINT" ]; then
        hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null \
            || hdiutil detach "$MOUNT_POINT" -force -quiet 2>/dev/null || true
    fi
}
trap cleanup EXIT

# ── Arg parse ────────────────────────────────────────────────────────────────
DMG=""
case "${1:-}" in
    --help|-h) usage ;;
    "") : ;;            # auto-discover below
    *) DMG="$1" ;;
esac

echo "== check_release_dmg_validity =="

# ── 1. Locate the DMG ────────────────────────────────────────────────────────
if [ -z "$DMG" ]; then
    # Newest desktopAhaan-v*.dmg in dist/.
    if [ -d "$DIST_DIR" ]; then
        DMG="$(ls -t "$DIST_DIR"/desktopAhaan-v*.dmg 2>/dev/null | head -1 || true)"
    fi
fi

if [ -z "$DMG" ] || [ ! -f "$DMG" ]; then
    hard_fail "no DMG found (looked in $DIST_DIR for desktopAhaan-v*.dmg)"
    note "Run scripts/build_release_dmg.sh first, or pass an explicit path."
    echo
    echo "== RESULT: FAIL =="
    printf '%s\n' "${NOTES[@]}"
    exit 1
fi
pass_line "DMG: $DMG"

# ── 2. hdiutil verify ────────────────────────────────────────────────────────
if hdiutil verify "$DMG" >/dev/null 2>&1; then
    pass_line "hdiutil verify — image checksum OK"
else
    hard_fail "hdiutil verify failed — image is corrupt or unreadable"
fi

# ── 3. Mount ─────────────────────────────────────────────────────────────────
# -nobrowse keeps it out of Finder; -mountrandom avoids name collisions.
ATTACH_OUT="$(hdiutil attach "$DMG" -nobrowse -readonly -mountrandom /tmp 2>/dev/null || true)"
MOUNT_POINT="$(echo "$ATTACH_OUT" | awk -F'\t' '/\/tmp\// {print $NF; exit}' | sed 's/[[:space:]]*$//')"
if [ -z "$MOUNT_POINT" ] || [ ! -d "$MOUNT_POINT" ]; then
    hard_fail "could not mount the DMG"
    echo
    echo "== RESULT: FAIL =="
    printf '%s\n' "${NOTES[@]}"
    exit 1
fi
pass_line "mounted at $MOUNT_POINT"

# ── 4. Find the .app ─────────────────────────────────────────────────────────
APP="$(/usr/bin/find "$MOUNT_POINT" -maxdepth 1 -name '*.app' -print -quit 2>/dev/null)"
if [ -z "$APP" ] || [ ! -d "$APP" ]; then
    hard_fail "no .app inside the DMG"
    echo
    echo "== RESULT: FAIL =="
    printf '%s\n' "${NOTES[@]}"
    exit 1
fi
pass_line "app: $(basename "$APP")"

# ── 5. codesign ──────────────────────────────────────────────────────────────
if codesign --verify --deep --strict "$APP" 2>/dev/null; then
    pass_line "codesign --verify --deep --strict — signature intact"
else
    # An ad-hoc signature still "verifies" structurally; a hard failure here
    # means the bundle's seal is actually broken (tampered / truncated).
    CS_OUT="$(codesign --verify --deep --strict "$APP" 2>&1 || true)"
    hard_fail "codesign --verify failed — signature is broken"
    note "codesign: $CS_OUT"
fi

# Report the signing identity for the log (informational).
CS_IDENTITY="$(codesign -dvv "$APP" 2>&1 | awk -F'=' '/^Authority/ {print $2; exit}' || true)"
if [ -z "$CS_IDENTITY" ]; then
    note "signing identity: ad-hoc (no Authority — expected for headless builds)"
else
    note "signing identity: $CS_IDENTITY"
fi

# ── 6. spctl (soft — log only) ───────────────────────────────────────────────
if spctl --assess --type install "$APP" >/dev/null 2>&1; then
    pass_line "spctl --assess --type install — Gatekeeper would ACCEPT"
else
    SPCTL_OUT="$(spctl --assess --type install "$APP" 2>&1 || true)"
    soft_warn "spctl --assess rejected (expected for ad-hoc / unnotarized builds)"
    note "spctl: $SPCTL_OUT"
fi

# ── 7. Version ───────────────────────────────────────────────────────────────
PLIST="$APP/Contents/Info.plist"
SHORT_VERSION="$(defaults read "$PLIST" CFBundleShortVersionString 2>/dev/null || true)"
if [ -n "$SHORT_VERSION" ]; then
    pass_line "CFBundleShortVersionString = $SHORT_VERSION"
else
    hard_fail "CFBundleShortVersionString is empty or unreadable"
fi

# ── 8. Minimum OS ────────────────────────────────────────────────────────────
MIN_OS="$(defaults read "$PLIST" LSMinimumSystemVersion 2>/dev/null || true)"
if [ "$MIN_OS" = "$EXPECTED_MIN_OS" ]; then
    pass_line "LSMinimumSystemVersion = $MIN_OS (matches Big Sur floor)"
else
    hard_fail "LSMinimumSystemVersion = '${MIN_OS:-<empty>}' — expected $EXPECTED_MIN_OS"
    note "A wrong floor lets the app launch on, or be blocked from, the deploy iMac."
fi

# cleanup() detaches via the EXIT trap.

# ── Verdict ──────────────────────────────────────────────────────────────────
echo
if [ "$FAILED" -ne 0 ]; then
    echo "== RESULT: FAIL =="
    [ "${#NOTES[@]}" -gt 0 ] && printf '%s\n' "${NOTES[@]}"
    exit 1
elif [ "$WARNED" -ne 0 ]; then
    echo "== RESULT: WARN (hard checks passed; see notes) =="
    [ "${#NOTES[@]}" -gt 0 ] && printf '%s\n' "${NOTES[@]}"
    exit 0
else
    echo "== RESULT: PASS =="
    [ "${#NOTES[@]}" -gt 0 ] && printf '%s\n' "${NOTES[@]}"
    exit 0
fi
