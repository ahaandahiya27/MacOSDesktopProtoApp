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

REPO_ROOT="/Users/ahaandahiya/Downloads/DesktopAhaan 4/desktopAhaan"
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

echo "▶ 3. Stashing any local pbxproj auto-edits (non-destructive)…"
git stash push -m "imac-pull: local pbxproj before pull $(date +%F_%H%M%S)" \
    -- desktopAhaan.xcodeproj/project.pbxproj 2>/dev/null || true
echo "   ✓ stash attempted (nothing to stash is fine)."

echo "▶ 4. Pulling origin/main…"
if ! git pull origin main; then
    echo "   ✗ pull failed — likely a deeper conflict. Run 'git status' and"
    echo "     either commit, stash, or discard the conflicting files."
    exit 1
fi
echo "   ✓ pull complete."

echo "▶ 5. Latest commit on main:"
git log -1 --oneline

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
