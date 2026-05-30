#!/bin/bash
# build-mutex.sh — serialize xcodebuild invocations from pre-push hooks.
#
# Why this exists
# ---------------
# The Overnight v2 run deadlocked the shared pre-push gate: every parallel
# agent's `ci-build-test.sh` used the SAME TMPDIR DerivedData path, so 7-8
# concurrent `xcodebuild` processes corrupted each other's module caches and
# OOM-killed the Late-2014 iMac's Swift compiler (see commit b7118dd /
# STOP_AND_ASK.md). The v3 launcher fixes the primary cause by giving each
# agent its own /tmp/dd-agent-<LETTER>-<PID> DerivedData path. This script is
# the SECOND-TIER guarantee: even with isolated DerivedData, two pre-push
# gates that fire at the same instant would still run two heavy xcodebuild
# jobs concurrently and can still starve 8 GB of RAM. The mutex ensures only
# ONE xcodebuild-bearing gate runs at a time across the whole machine.
#
# Design
# ------
# macOS does not ship GNU coreutils `flock`, so we implement a portable lock
# with the shell's noclobber (`set -C`) primitive: `set -C; echo $$ > LOCK`
# fails atomically if LOCK already exists. The held PID is written into the
# lockfile so a crashed holder can be detected (kill -0) and reclaimed, and a
# hard 30-minute ceiling steals the lock outright so a wedged build can never
# block the whole fleet forever.
#
# Usage
# -----
#   bash scripts/hooks/build-mutex.sh xcodebuild -scheme desktopAhaan ...
#   bash scripts/hooks/build-mutex.sh bash scripts/ci-build-test.sh
#
# Exit code is the wrapped command's exit code (so the gate still fails when
# the build fails). If no command is given, exits 2.
#
# BSD/Big Sur only: no GNU flock, no `date -d`, no `find -printf`. bash 3.2
# compatible.

set -u

LOCKFILE="${BUILD_MUTEX_LOCKFILE:-/tmp/desktopAhaan-build-mutex.lock}"
CEILING_SECS="${BUILD_MUTEX_CEILING_SECS:-1800}"   # 30 min
POLL_SECS="${BUILD_MUTEX_POLL_SECS:-5}"

if [ "$#" -eq 0 ]; then
    echo "build-mutex: no command given." >&2
    echo "Usage: build-mutex.sh <command> [args...]" >&2
    exit 2
fi

DEADLINE=$(( $(date +%s) + CEILING_SECS ))

# Spin-acquire the lock.
while true; do
    if ( set -C; echo "$$" > "$LOCKFILE" ) 2>/dev/null; then
        break   # acquired
    fi

    now=$(date +%s)
    if [ "$now" -ge "$DEADLINE" ]; then
        echo "build-mutex: timeout after ${CEILING_SECS}s waiting on $LOCKFILE — stealing." >&2
        rm -f "$LOCKFILE"
        continue
    fi

    HOLDER="$(cat "$LOCKFILE" 2>/dev/null || true)"
    if [ -z "$HOLDER" ]; then
        # Lockfile vanished or is mid-write between our test and read; retry fast.
        sleep 1
        continue
    fi
    # A non-numeric holder is corrupt — reclaim.
    case "$HOLDER" in
        ''|*[!0-9]*)
            echo "build-mutex: corrupt holder '$HOLDER' in $LOCKFILE — reclaiming." >&2
            rm -f "$LOCKFILE"
            continue
            ;;
    esac
    if ! kill -0 "$HOLDER" 2>/dev/null; then
        echo "build-mutex: stale holder PID $HOLDER (no live process) — reclaiming." >&2
        rm -f "$LOCKFILE"
        continue
    fi

    echo "build-mutex: lock held by PID $HOLDER; waiting ${POLL_SECS}s…" >&2
    sleep "$POLL_SECS"
done

# Release on any exit. We only remove the lock if WE still own it, so a steal
# by another waiter (after our 30-min ceiling) doesn't get clobbered.
release() {
    local owner
    owner="$(cat "$LOCKFILE" 2>/dev/null || true)"
    if [ "$owner" = "$$" ]; then
        rm -f "$LOCKFILE"
    fi
}
trap release EXIT INT TERM

# Run the wrapped command while holding the lock; propagate its exit code.
"$@"
rc=$?
exit "$rc"
