#!/usr/bin/env python3
"""check_test_target_compat.py — locks Bug-Free-Cert category C.10.

check_macos12_apis.py deliberately SKIPS desktopAhaanTests/ (its comment
says "tests don't ship to the iMac"). But this repo's iMac actually RUNS
the test suite (scripts/ci-build-test.sh runs `xcodebuild test` on
Xcode 13.2.1 / Big Sur). A macOS 12+ SwiftUI API in a *test* file compiles
fine on a dev Mac and then hard-fails to build on the iMac — a silent
test-target compatibility leak.

This lint reuses the exact scanning rules from check_macos12_apis.scan_file
but points them at the test target, so the same Big-Sur ban that protects
the shipped target also protects the test target.

Wired into pre-commit only when a test .swift file is staged (see the
pre-commit hook), so it never spuriously blocks unrelated commits.

Usage:
    python3 scripts/check_test_target_compat.py [file ...]
    python3 scripts/check_test_target_compat.py --selftest

Exit 0 = clean, 1 = banned API found in test code.
"""
import os
import pathlib
import sys

SCRIPTS = pathlib.Path(__file__).resolve().parent
REPO = SCRIPTS.parent
sys.path.insert(0, str(SCRIPTS))
import check_macos12_apis as base  # noqa: E402

TEST_DIRS = ["desktopAhaanTests", "desktopAhaanUITests"]


def test_sources(argv_files):
    if argv_files:
        return [pathlib.Path(f) for f in argv_files if f.endswith(".swift")]
    out = []
    for d in TEST_DIRS:
        root = REPO / d
        if root.exists():
            out += list(root.rglob("*.swift"))
    return out


def selftest():
    # Build a temp fixture with a banned API and confirm it trips.
    import tempfile
    ok = True
    with tempfile.TemporaryDirectory() as td:
        bad = pathlib.Path(td) / "BadTest.swift"
        bad.write_text("import SwiftUI\nlet x = Color.clear.foregroundStyle(.tint)\n")
        if not base.scan_file(bad):
            print("SELFTEST FAIL: banned API in fixture not caught"); ok = False
        good = pathlib.Path(td) / "GoodTest.swift"
        good.write_text("import XCTest\nfinal class T: XCTestCase { func test() {} }\n")
        if base.scan_file(good):
            print("SELFTEST FAIL: clean fixture flagged"); ok = False
    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


def main():
    argv = [a for a in sys.argv[1:] if not a.startswith("--")]
    if "--selftest" in sys.argv:
        return selftest()
    total = 0
    for path in sorted(test_sources(argv)):
        for lineno, name, why, line in base.scan_file(path):
            try:
                rel = path.relative_to(REPO)
            except ValueError:
                rel = path
            print(f"{rel}:{lineno}: {name} — {why}")
            print(f"    {line}")
            total += 1
    if total == 0:
        print("check_test_target_compat: clean — test target has no macOS 12+ APIs (C.10)")
        return 0
    print()
    print(f"check_test_target_compat: refusing — {total} macOS 12+ API usage(s) in test code.")
    print("The iMac (Xcode 13.2.1 / Big Sur) runs the test suite; these won't compile there.")
    return 1


if __name__ == "__main__":
    sys.exit(main())
