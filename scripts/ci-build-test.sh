#!/usr/bin/env bash
# ci-build-test.sh — one-stop build + test for CI or pre-push checks.
#
# Runs:
#   1. xcodebuild build   (Release config, fail on warnings via -Wall surfacing)
#   2. xcodebuild test    (all 275+ tests in the desktopAhaanTests target)
#
# Big Sur target verification: pins MACOSX_DEPLOYMENT_TARGET=11.0 so a
# stray macOS 12+ API leaks as a build error, not a runtime crash on the
# deploy iMac.
#
# Usage:
#   bash scripts/ci-build-test.sh           # default — unit + chrome, no UI tests
#   bash scripts/ci-build-test.sh --ui      # also runs GoldenPathUITests
#
# The `--ui` flag adds a third xcodebuild test invocation that runs
# `-only-testing:desktopAhaanUITests/GoldenPathUITests`. This is opt-in
# because XCUIAutomation needs an Accessibility grant under System
# Settings → Privacy & Security → Accessibility for the test runner
# (`desktopAhaanUITests-Runner.app`). Default off so dev Macs and CI
# runners that haven't granted AX still get a clean ci-build-test pass
# without the UI tests silently no-op'ing. The iMac's pre-push hook
# should use `--ui` since AX is granted there and the GoldenPathUITests
# cover the surfaces most likely to regress between sessions.
#
# Crash-regression UI tests (`Crash1_TryDiscoverMode_Ch1`,
# `Crash_BeyondThenDiscover`) intentionally remain skipped even under
# `--ui` because they only reproduce on the iMac's AMD R9 M290X / Big
# Sur combo — running them on a dev Mac just consumes wall-clock and
# produces no signal. Invoke them explicitly via the documented
# `-only-testing:desktopAhaanUITests/CrashN_*` recipe in their headers.
#
# Exit code is 0 only when build + unit tests + (optionally) UI tests
# all succeed. Hooked into the pre-push hook or GitHub Actions workflow
# as the gate.
#
# Critical: xcodebuild's exit code is UNRELIABLE.
#   - When the .xcodeproj doesn't exist, xcodebuild prints "error: ..."
#     and exits 0.
#   - When tests fail, xcodebuild prints "** TEST FAILED **" but can also
#     exit 0 depending on the failure mode (this masked commit 6cdf722
#     landing broken on 2026-05-19 — Phase 2 content commit decoded fine
#     in Python but failed Swift Decodable; tests failed; script said
#     PASSED because the script only checked exit code).
#
# This script therefore checks BOTH exit code AND output markers ("error:",
# "** BUILD FAILED **", "** TEST FAILED **", "Testing failed:"). Either
# signal ⇒ propagate failure. False positives are vanishingly rare (xcodebuild
# uses those markers only on real failure).

set -euo pipefail

# --- Flag parsing -----------------------------------------------------
# bash 3.2 compatible (default shell on Big Sur). Simple while-case
# parser; only `--ui` is supported today. Unknown flags fail loudly so
# typos don't silently degrade to default behaviour.
RUN_UI_TESTS=0
while [ $# -gt 0 ]; do
    case "$1" in
        --ui)
            RUN_UI_TESTS=1
            shift
            ;;
        --help|-h)
            sed -n '2,40p' "$0"
            exit 0
            ;;
        *)
            echo "ci-build-test: unknown flag '$1'." >&2
            echo "Usage: bash scripts/ci-build-test.sh [--ui]" >&2
            exit 2
            ;;
    esac
done
# ---------------------------------------------------------------------

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="$REPO_ROOT/desktopAhaan.xcodeproj"
SCHEME="desktopAhaan"
# DerivedData lives outside the repo root because some dev Macs keep the
# repo inside an iCloud / Files-app fileprovider tree (~/Documents/...),
# which intermittently re-attaches com.apple.FinderInfo to outputs and
# fails codesign with "resource fork, Finder information, or similar
# detritus not allowed" — and intermittently corrupts the SwiftDriver
# build.db with "disk I/O error". The iMac repo lives under ~/Downloads
# (no fileprovider) so this is harmless there; on a dev Mac with
# Documents-synced repos it's the only path that builds reliably.
#
# Override with CI_DERIVED_OVERRIDE=/path/to/dir if you want the old
# in-repo .ci-derived/ behavior (e.g. to inspect build logs after a run).
DERIVED="${CI_DERIVED_OVERRIDE:-${TMPDIR:-/tmp}/desktopAhaan-ci-derived}"
LOG_DIR="$(mktemp -d -t ci-build-test.XXXXXX)"
trap 'rm -rf "$LOG_DIR"' EXIT

cd "$REPO_ROOT"

# Disable code signing for verification builds. The signed-binary path
# is only needed for distribution; a dev machine without a valid signing
# identity should still pass the build+test gate.
SIGNING_FLAGS=(
    CODE_SIGN_IDENTITY=""
    CODE_SIGNING_REQUIRED=NO
    CODE_SIGNING_ALLOWED=NO
)

# Detect formatter once.
USE_XCPRETTY=0
if command -v xcpretty >/dev/null 2>&1; then
    USE_XCPRETTY=1
fi

# Failure-marker patterns xcodebuild prints on actual failure. Each is
# anchored to the start of a line to avoid matching mentions inside test
# output (e.g., a test that asserts on the string "error:").
FAIL_PATTERNS='^(error:|xcodebuild: error:|\*\* BUILD FAILED \*\*|\*\* TEST FAILED \*\*|Testing failed:)'

# Run xcodebuild and check BOTH exit code AND output markers. Any failure
# signal ⇒ propagate non-zero.
#   $1 = human label for error messages
#   rest = xcodebuild arguments
run_xcodebuild() {
    local label="$1"; shift
    local log="${LOG_DIR}/${label// /_}.log"
    local rc=0

    if [ "$USE_XCPRETTY" -eq 1 ]; then
        # Tee through xcpretty for live output; also persist raw log for marker scan.
        set +e
        xcodebuild "$@" 2>&1 | tee "$log" | xcpretty --color
        rc=${PIPESTATUS[0]}
        set -e
    else
        # No xcpretty — direct output, tee'd to log.
        set +e
        xcodebuild "$@" 2>&1 | tee "$log"
        rc=${PIPESTATUS[0]}
        set -e
    fi

    if [ "$rc" -ne 0 ]; then
        echo "" >&2
        echo "${label} FAILED (xcodebuild rc=${rc})" >&2
        exit "$rc"
    fi

    # xcodebuild exit code passed; now scan for the canonical failure markers
    # it sometimes prints while still exiting 0 (the bug class that masked
    # commit 6cdf722).
    if grep -E -q "$FAIL_PATTERNS" "$log"; then
        echo "" >&2
        echo "${label} FAILED (output contained failure marker, even though xcodebuild exit code was 0 — see log above)" >&2
        grep -E "$FAIL_PATTERNS" "$log" | head -5 >&2
        exit 1
    fi
}

echo "==> build (Release, MACOSX_DEPLOYMENT_TARGET=11.0)"
# Pre-build static lints. Cheap; surface failures before the slow
# xcodebuild step so the dev gets feedback fast.
if [ -f "scripts/check_lifetime_hazards.py" ]; then
    echo "==> lifetime-hazards lint"
    if ! python3 scripts/check_lifetime_hazards.py; then
        echo "ci-build-test: lifetime-hazards lint failed — see findings above." >&2
        exit 1
    fi
fi

if [ -f "scripts/check_file_size.py" ]; then
    echo "==> file-size lint"
    if ! python3 scripts/check_file_size.py; then
        echo "ci-build-test: file-size lint failed — see findings above." >&2
        exit 1
    fi
fi

if [ -f "scripts/check_view_mainactor.py" ]; then
    echo "==> view-mainactor lint (Big Sur Swift 5.5 isolation guard)"
    if ! python3 scripts/check_view_mainactor.py; then
        echo "ci-build-test: view-mainactor lint failed — see findings above." >&2
        exit 1
    fi
fi

if [ -f "scripts/test_lints.py" ]; then
    echo "==> lint self-test"
    if ! python3 scripts/test_lints.py; then
        echo "ci-build-test: lint self-test failed — a regex changed and a rule no longer catches its fixture violation. See output." >&2
        exit 1
    fi
fi

run_xcodebuild "BUILD" \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration Release \
    -derivedDataPath "$DERIVED" \
    -destination 'platform=macOS' \
    MACOSX_DEPLOYMENT_TARGET=11.0 \
    "${SIGNING_FLAGS[@]}" \
    build

echo "==> test (unit, skipping UI bundle)"
# Skip the UI-test bundle here unconditionally — even with `--ui` set,
# the UI tests run as a *separate* xcodebuild invocation below so a
# failure in either suite produces a focused error message rather than
# a mixed test output. The UI-test bundle's test runner needs an
# Accessibility grant in System Settings → Privacy & Security →
# Accessibility, which isn't present on dev Macs or CI runners.
run_xcodebuild "TESTS" \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration Debug \
    -derivedDataPath "$DERIVED" \
    -destination 'platform=macOS' \
    -skip-testing:desktopAhaanUITests \
    "${SIGNING_FLAGS[@]}" \
    test

if [ "$RUN_UI_TESTS" -eq 1 ]; then
    echo "==> ui-test (GoldenPathUITests only — Crash* tests are iMac-only)"
    # Crash-regression locks (Crash1_TryDiscoverMode_Ch1 /
    # Crash_BeyondThenDiscover) only reproduce on the iMac's AMD R9
    # M290X + Big Sur combo. Running them on a dev Mac eats wall-clock
    # without signal. Surface_AuditWalker is a one-off walker, not a
    # pass/fail gate. GoldenPathUITests covers the new chapter-detail
    # surfaces and SHOULD run anywhere AX is granted.
    run_xcodebuild "UI-TESTS" \
        -project "$PROJECT" \
        -scheme "$SCHEME" \
        -configuration Debug \
        -derivedDataPath "$DERIVED" \
        -destination 'platform=macOS' \
        -only-testing:desktopAhaanUITests/GoldenPathUITests \
        "${SIGNING_FLAGS[@]}" \
        test
fi

echo "==> ci-build-test PASSED"
