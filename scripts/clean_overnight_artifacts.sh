#!/bin/bash
# clean_overnight_artifacts.sh — garbage-collect stale build artifacts left
# behind by parallel overnight runs.
#
# Two artifact classes accumulate across runs and silently fill the disk:
#   1. /tmp/dd-agent-<LETTER>-<PID>  — per-agent DerivedData paths created by
#      scripts/run_overnight_v3_3agents.sh (and ad-hoc per-commit gates). A
#      crashed agent or a kill -9 leaves these behind; each is hundreds of MB.
#   2. ~/Library/Developer/Xcode/DerivedData/desktopAhaan-*  — Xcode's own
#      managed DerivedData for interactive sessions. These rebuild on demand,
#      so old ones are safe to reclaim.
#
# Policy:
#   - /tmp/dd-agent-*           : remove if older than 24h (a live run's paths
#                                 are touched continuously while building, so
#                                 24h cleanly separates active from abandoned).
#   - Xcode DerivedData/desktopAhaan-* : remove if older than 7 days.
#
# Also clears the build mutex lockfile if its holder PID is dead (a crashed
# gate can leave /tmp/desktopAhaan-build-mutex.lock orphaned).
#
# Idempotent: running twice is a no-op after the first pass. Safe to run as a
# pre-flight step before launching a fresh overnight fleet.
#
# BSD/Big Sur only: `find -mtime` (no GNU -printf/-delete), bash 3.2.
#
# Usage:
#   bash scripts/clean_overnight_artifacts.sh          # clean
#   bash scripts/clean_overnight_artifacts.sh --dry-run # report only

set -u

DRY_RUN=0
if [ "${1:-}" = "--dry-run" ] || [ "${1:-}" = "-n" ]; then
    DRY_RUN=1
fi

TMP_DIR="${TMPDIR:-/tmp}"
# TMPDIR often has a trailing slash and a per-user path on macOS; the dd-agent
# paths the launcher creates live in /tmp explicitly, so scan both /tmp and
# $TMPDIR (deduped) to be safe.
SCAN_TMP_ROOTS="/tmp"
case "$TMP_DIR" in
    /tmp|/tmp/) ;;
    *) SCAN_TMP_ROOTS="/tmp ${TMP_DIR%/}" ;;
esac

XCODE_DD="$HOME/Library/Developer/Xcode/DerivedData"

removed=0
scanned=0

remove_path() {
    # $1 = path to remove
    scanned=$((scanned + 1))
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "  would remove: $1"
    else
        rm -rf "$1" && echo "  removed: $1"
        removed=$((removed + 1))
    fi
}

echo "==> clean_overnight_artifacts (dry-run=$DRY_RUN)"

# 1. Per-agent DerivedData in /tmp older than 24h.
# NOTE: /tmp is a symlink to /private/tmp on macOS, and `find` will not descend
# a symlinked start point without -L. Resolve each root to its physical path
# (pwd -P) so the scan actually sees the dd-agent-* dirs. Dedupe resolved roots.
echo "-- /tmp per-agent DerivedData (dd-agent-*, >24h)"
SEEN_ROOTS=""
for root in $SCAN_TMP_ROOTS; do
    [ -d "$root" ] || continue
    real="$(cd "$root" 2>/dev/null && pwd -P)" || continue
    [ -n "$real" ] || continue
    case " $SEEN_ROOTS " in *" $real "*) continue ;; esac
    SEEN_ROOTS="$SEEN_ROOTS $real"
    # -maxdepth 1 keeps us from descending into the (huge) build trees.
    while IFS= read -r p; do
        [ -n "$p" ] && remove_path "$p"
    done <<EOF
$(find "$real" -maxdepth 1 -type d -name 'dd-agent-*' -mtime +0 2>/dev/null)
EOF
done

# 2. Xcode-managed DerivedData for this project older than 7 days.
echo "-- Xcode DerivedData (desktopAhaan-*, >7d)"
if [ -d "$XCODE_DD" ]; then
    while IFS= read -r p; do
        [ -n "$p" ] && remove_path "$p"
    done <<EOF
$(find "$XCODE_DD" -maxdepth 1 -type d -name 'desktopAhaan-*' -mtime +7 2>/dev/null)
EOF
else
    echo "  (no Xcode DerivedData dir — nothing to do)"
fi

# 3. Orphaned build-mutex lockfile (dead holder PID).
LOCKFILE="${BUILD_MUTEX_LOCKFILE:-/tmp/desktopAhaan-build-mutex.lock}"
if [ -f "$LOCKFILE" ]; then
    holder="$(cat "$LOCKFILE" 2>/dev/null || true)"
    case "$holder" in
        ''|*[!0-9]*)
            echo "-- build-mutex lockfile holder '$holder' is non-numeric/empty — clearing"
            remove_path "$LOCKFILE"
            ;;
        *)
            if kill -0 "$holder" 2>/dev/null; then
                echo "-- build-mutex lockfile held by live PID $holder — leaving"
            else
                echo "-- build-mutex lockfile holder PID $holder is dead — clearing"
                remove_path "$LOCKFILE"
            fi
            ;;
    esac
fi

echo "==> done: scanned $scanned stale path(s), removed $removed"
exit 0
