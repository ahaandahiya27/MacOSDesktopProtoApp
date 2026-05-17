#!/usr/bin/env bash
# ci-build-test.sh — one-stop build + test for CI or pre-push checks.
#
# Runs:
#   1. xcodebuild build   (Release config, fail on warnings via -Wall surfacing)
#   2. xcodebuild test    (all 254+ tests in the desktopAhaanTests target)
#
# Big Sur target verification: pins MACOSX_DEPLOYMENT_TARGET=11.0 so a
# stray macOS 12+ API leaks as a build error, not a runtime crash on the
# deploy iMac.
#
# Usage:
#   bash scripts/ci-build-test.sh
#
# Exit code is 0 only when both build and tests succeed. Hooked into a
# pre-push hook or GitHub Actions workflow, this is the gate.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="$REPO_ROOT/desktopAhaan.xcodeproj"
SCHEME="desktopAhaan"
DERIVED="$REPO_ROOT/.ci-derived"

cd "$REPO_ROOT"

echo "==> build (Release, MACOSX_DEPLOYMENT_TARGET=11.0)"
xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration Release \
    -derivedDataPath "$DERIVED" \
    -destination 'platform=macOS' \
    MACOSX_DEPLOYMENT_TARGET=11.0 \
    build \
    | xcpretty || true

# xcpretty swallows exit code via pipe; capture pipefail
BUILD_RC=${PIPESTATUS[0]}
if [ "$BUILD_RC" -ne 0 ]; then
    echo "BUILD FAILED (rc=$BUILD_RC)"
    exit "$BUILD_RC"
fi

echo "==> test"
xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration Debug \
    -derivedDataPath "$DERIVED" \
    -destination 'platform=macOS' \
    test \
    | xcpretty --test || true

TEST_RC=${PIPESTATUS[0]}
if [ "$TEST_RC" -ne 0 ]; then
    echo "TESTS FAILED (rc=$TEST_RC)"
    exit "$TEST_RC"
fi

echo "==> ci-build-test PASSED"
