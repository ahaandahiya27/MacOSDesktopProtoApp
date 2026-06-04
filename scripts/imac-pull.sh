#!/bin/bash
# =============================================================================
# imac-pull.sh — pull latest origin/main on the Big Sur iMac and clean-build.
#
# Works from any working directory. Handles the recurring iMac issues:
#   - Xcode auto-rewrites project.pbxproj on open, causing pull conflicts.
#   - Xcode keeps file handles open inside DerivedData even after quitting.
#   - Stale .dia diagnostic files surface as "Invalid diagnostics signature"
#     warnings until DerivedData is wiped.
#
# Usage on the iMac (from any folder):
#     bash "/Users/ahaandahiya/Downloads/DesktopAhaan 4/desktopAhaan/scripts/imac-pull.sh"
#
# Or once chmod +x'd (idempotently set below):
#     "/Users/ahaandahiya/Downloads/DesktopAhaan 4/desktopAhaan/scripts/imac-pull.sh"
#
# =============================================================================

set -u   # not -e — we INTENTIONALLY continue past benign errors like
         # "Directory not empty" so the build flow doesn't abort.

# Default to the iMac's known repo location; fall back to the script's
# own directory if that path doesn't exist (handles the case where the
# repo got relocated, or someone runs the script from a clone elsewhere
# without editing this constant). Bash 3.2 compatible: no readlink -f,
# no realpath, just two cd-and-pwd hops.
REPO_ROOT="/Users/ahaandahiya/Downloads/DesktopAhaan 4/desktopAhaan"
if [ ! -d "${REPO_ROOT}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    FALLBACK_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
    if [ -d "${FALLBACK_ROOT}/desktopAhaan.xcodeproj" ]; then
        echo "▶ iMac path not found — falling back to script-relative repo root:"
        echo "    ${FALLBACK_ROOT}"
        REPO_ROOT="${FALLBACK_ROOT}"
    fi
fi
XCODE_PROJECT="${REPO_ROOT}/desktopAhaan.xcodeproj"

echo "▶ 1. Quitting Xcode (graceful, then force if needed)…"
osascript -e 'tell application "Xcode" to quit' 2>/dev/null || true

# Wait up to 15 seconds for Xcode to actually exit. After that, force-kill.
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
    if ! pgrep -x Xcode >/dev/null; then
        break
    fi
    sleep 1
done
if pgrep -x Xcode >/dev/null; then
    echo "   …Xcode still alive after 15 s; force-killing."
    pkill -9 -x Xcode || true
    sleep 2
fi
# Also kill any leftover Xcode helper that holds DerivedData open.
pkill -9 -x "Xcode Helper" 2>/dev/null || true
pkill -9 -f "com.apple.dt.Xcode.IDEMetalContextProvider" 2>/dev/null || true
sleep 1
echo "   ✓ Xcode terminated."

echo "▶ 2. cd to repo root (absolute, works regardless of starting cwd)…"
if [ ! -d "${REPO_ROOT}" ]; then
    echo "   ✗ Repo root not found at: ${REPO_ROOT}"
    echo "   Open this script and edit REPO_ROOT to your actual path."
    exit 1
fi
cd "${REPO_ROOT}" || exit 1
echo "   ✓ now in $(pwd)"

echo "▶ 3. Parking ALL local changes (safety net before the hard sync)…"
# The iMac is a PURE CONSUMER of origin/main — it never authors commits that
# need preserving, and its only routine local edits are pbxproj auto-rewrites
# that Xcode regenerates anyway. A plain `git pull` (merge) used to leave the
# tree STALE whenever ANY tracked file besides pbxproj was dirty or local main
# had diverged: the merge wouldn't fast-forward, the old source stayed on disk,
# and Xcode rebuilt the pre-fix code → the same crash "again and again".
# We snapshot everything into a stash (recoverable if ever needed) and then
# force the working tree to EXACTLY match origin/main below.
git stash push -u -m "imac-pull: full local snapshot $(date +%F_%H%M%S)" 2>/dev/null || true
echo "   ✓ snapshot taken (nothing to stash is fine; recover via 'git stash list')."

echo "▶ 4. Force-syncing the working tree to origin/main (fetch + hard reset)…"
# fetch first so origin/main is current, then reset --hard so the tree matches
# it byte-for-byte regardless of local divergence, dirt, or a failed prior pull.
if ! git fetch origin; then
    echo "   ✗ fetch failed — check the network / GitHub auth, then re-run."
    exit 1
fi
if ! git reset --hard origin/main; then
    echo "   ✗ reset failed — run 'git status' and inspect."
    exit 1
fi
git clean -fd desktopAhaan.xcodeproj 2>/dev/null || true   # drop stray pbxproj turds
echo "   ✓ working tree now matches origin/main exactly."

echo "▶ 5. Verifying the sync actually took (guards against a silent stale tree)…"
LOCAL_SHA="$(git rev-parse HEAD)"
ORIGIN_SHA="$(git rev-parse origin/main)"
echo "   HEAD       = $(git rev-parse --short HEAD)"
echo "   origin/main= $(git rev-parse --short origin/main)"
git log -1 --oneline
if [ "${LOCAL_SHA}" != "${ORIGIN_SHA}" ]; then
    echo "   ✗ HEAD does not match origin/main after reset — STOP. Do not build a"
    echo "     stale tree. Run 'git status' / 'git remote -v' and re-run this script."
    exit 1
fi
echo "   ✓ HEAD matches origin/main — the build will compile the latest source."

echo "▶ 6. Wiping stale DerivedData (with retry — handles file-handle races)…"
DERIVED_GLOB="${HOME}/Library/Developer/Xcode/DerivedData/desktopAhaan-*"
# Two passes: first attempt may leave non-empty dirs if files are still open.
# Second pass after a short delay catches whatever was holding handles.
rm -rf ${DERIVED_GLOB} 2>/dev/null || true
sleep 1
rm -rf ${DERIVED_GLOB} 2>/dev/null || true
# Final check — list any remnant so the user can decide whether to ignore.
remnants=$(ls -d ${DERIVED_GLOB} 2>/dev/null || true)
if [ -n "${remnants}" ]; then
    echo "   ⚠ DerivedData partially removed; remnants:"
    echo "${remnants}"
    echo "   Inside Xcode, ⇧⌘K (Clean Build Folder) will overwrite anyway."
else
    echo "   ✓ DerivedData wiped."
fi

# Step 6.5 — Redirect interactive Xcode's DerivedData OFF the fileprovider
# tree. The iMac's "code 9: Killed" build failures correlate with memory
# pressure during large rebuilds when DerivedData lives under iCloud-
# tracked paths (extended attributes + sync churn). CI already redirects
# via CI_DERIVED_OVERRIDE / TMPDIR (commit 2831646 / 2026-05-22).
# This block does the same for the kid's interactive Xcode session — but
# ONLY if it isn't already configured to a custom location, so a
# deliberate manual setting is preserved.
#
# Idempotent: re-running this script after the redirect is in place is a
# no-op (the "Custom" branch short-circuits below). Big Sur 11.7 +
# Xcode 13.2.1 compatible — the `defaults` keys are unchanged since
# Xcode 11.
echo "▶ 6.5 Routing interactive Xcode DerivedData off the fileprovider tree…"
CURRENT_STYLE="$(defaults read com.apple.dt.Xcode IDEDerivedDataLocationStyle 2>/dev/null || echo 'Default')"
if [ "${CURRENT_STYLE}" = "Custom" ]; then
    CURRENT_LOC="$(defaults read com.apple.dt.Xcode IDECustomDerivedDataLocation 2>/dev/null || echo '(unset)')"
    echo "   ✓ already custom — leaving alone: ${CURRENT_LOC}"
else
    # /tmp is local-disk and not under FileProvider. A stable subdir
    # keeps the location predictable across reboots.
    XCODE_DD_TARGET="/tmp/desktopAhaan-imac-derived"
    mkdir -p "${XCODE_DD_TARGET}"
    defaults write com.apple.dt.Xcode IDEDerivedDataLocationStyle -string "Custom" 2>/dev/null || true
    defaults write com.apple.dt.Xcode IDECustomDerivedDataLocation -string "${XCODE_DD_TARGET}" 2>/dev/null || true
    echo "   ✓ routed to: ${XCODE_DD_TARGET}"
    echo "     (revert via: defaults write com.apple.dt.Xcode IDEDerivedDataLocationStyle Default)"
fi

echo "▶ 7. Verifying expected source files are present after pull…"
for must_exist in \
    "desktopAhaan/App/CrashReporter.swift" \
    "desktopAhaan/Subjects/Tutor/Discover/Components/DiscoveryWidget.swift" \
    "desktopAhaan/Subjects/Packs/science_class7.json"; do
    if [ ! -f "${must_exist}" ]; then
        echo "   ✗ MISSING: ${must_exist}"
    fi
done
echo "   ✓ verification complete."

echo "▶ 8. Re-opening the Xcode project…"
open "${XCODE_PROJECT}"
echo "   ✓ Xcode opening."

echo ""
echo "╭───────────────────────────────────────────────────────────────╮"
echo "│ Inside Xcode 13.2.1 now:                                      │"
echo "│   ⇧⌘K   Product → Clean Build Folder                          │"
echo "│   ⌘B    Product → Build                                        │"
echo "│                                                                │"
echo "│ Expected: zero 'Extra argument in call' errors, zero          │"
echo "│ 'Invalid diagnostics signature' warnings, zero SF Symbol      │"
echo "│ missing-glyph warnings.                                        │"
echo "╰───────────────────────────────────────────────────────────────╯"
