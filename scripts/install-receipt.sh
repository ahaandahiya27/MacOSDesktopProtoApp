#!/usr/bin/env bash
# install-receipt.sh — the canonical "what gets installed, and where" map.
#
# desktopAhaan is a sideloaded, single-user, offline-first macOS app. It has
# no installer package and no background agents — installing is "drag the
# .app to Applications." This script is the single source of truth for every
# path the app touches, so support / uninstall / backup never has to guess.
#
# Usage:
#   bash scripts/install-receipt.sh           # print the path map
#   bash scripts/install-receipt.sh --check    # also report which paths exist
#   bash scripts/install-receipt.sh --uninstall-hint
#                                              # print copy-paste removal commands
#
# Nothing here MUTATES anything — even --uninstall-hint only PRINTS the
# commands for the user to run deliberately.

set -euo pipefail

BUNDLE_ID="com.emoha.desktopAhaan"
APP_PATH="/Applications/desktopAhaan.app"
APP_SUPPORT="$HOME/Library/Application Support/desktopAhaan"
CRASHLOGS="$APP_SUPPORT/crashlogs"
PREFS="$HOME/Library/Preferences/${BUNDLE_ID}.plist"
CACHES="$HOME/Library/Caches/${BUNDLE_ID}"
# Sandboxed apps also get a container; this app uses the App Support path
# above for its JSON because the temporary-exception entitlement grants
# ~/Documents and App Support directly. The container is created by the
# sandbox regardless.
CONTAINER="$HOME/Library/Containers/${BUNDLE_ID}"

MODE="${1:-}"

print_row() {
    # $1 = label, $2 = path, $3 = note
    if [ "$MODE" = "--check" ]; then
        if [ -e "$2" ]; then STATUS="[present]"; else STATUS="[absent ]"; fi
        printf "  %s  %-46s %s\n" "$STATUS" "$2" "— $1"
    else
        printf "  %-46s — %s\n" "$2" "$1"
    fi
    if [ -n "${3:-}" ]; then
        printf "  %46s   %s\n" "" "$3"
    fi
}

echo "== desktopAhaan install receipt (bundle id: $BUNDLE_ID) =="
echo
echo "Application bundle:"
print_row "the app itself (drag here from the DMG)" "$APP_PATH"
echo
echo "User data (created on first run; survives reinstall):"
print_row "all progress, reviews, settings (JSON)" "$APP_SUPPORT"
print_row "daily crash logs (Help → Reveal Crash Logs)" "$CRASHLOGS"
print_row "@AppStorage / UserDefaults" "$PREFS"
echo
echo "Regenerable (safe to delete; rebuilt on next launch):"
print_row "Metal shader + misc caches" "$CACHES"
print_row "sandbox container" "$CONTAINER"

if [ "$MODE" = "--uninstall-hint" ]; then
    echo
    echo "To fully uninstall (run these yourself — this script will not):"
    echo "    rm -rf \"$APP_PATH\""
    echo "    rm -rf \"$APP_SUPPORT\""
    echo "    rm -f  \"$PREFS\""
    echo "    rm -rf \"$CACHES\""
    echo "    rm -rf \"$CONTAINER\""
    echo "    defaults delete $BUNDLE_ID 2>/dev/null || true"
    echo
    echo "Tip: back up \"$APP_SUPPORT\" first if you want to keep progress,"
    echo "or use the in-app Settings → Data → Export backup."
fi

echo
echo "Privacy: no telemetry, no accounts. The only outbound network call is"
echo "the optional online translator, which can be disabled in Settings."
