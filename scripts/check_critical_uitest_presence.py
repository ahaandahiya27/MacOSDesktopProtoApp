#!/usr/bin/env python3
"""check_critical_uitest_presence.py — locks Bug-Free-Cert category K.2.

K.2 ("UI test count per critical flow") was certified by counting methods
in the audit. Counting drifts: a refactor can delete or rename a crash-
regression test and the suite still goes green because the *other* UI tests
compile. The two crash locks in particular guard real shipped crashes
(`Crash1_TryDiscoverMode_Ch1` pins the 2026-05 NSHostingView teardown race;
`Crash_BeyondThenDiscover` pins the Beyond→Discover navigation crash). If
either silently disappears, the regression it guards is unprotected.

This lint pins, by name, that each critical UI flow still has its test
method physically present in the UI-test target. It does NOT run the tests
(they need an AX grant — they're `--ui` opt-in); it asserts the methods
exist so a deletion/rename is caught at commit + push time, no build needed.

The manifest below is the source of truth for "which UI flows are critical."
Adding a critical flow means adding its row here in the same commit.

Usage:
    python3 scripts/check_critical_uitest_presence.py
    python3 scripts/check_critical_uitest_presence.py --selftest

Exit 0 = clean, 1 = violation.
"""
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
UITESTS_DIR = os.path.join(REPO, "desktopAhaanUITests")

# flow label -> required test method name (must exist somewhere in the target)
REQUIRED = {
    "crash: Try Discover Mode Ch.1 (NSHostingView teardown race)":
        "testTryDiscoverModeFromCh1_doesNotCrash",
    "crash: Beyond-the-Book then Discover Mode":
        "testBeyondTheBookThenDiscoverMode",
    "golden path: Ch.1 chapter detail renders surfaces":
        "testCh1ChapterDetailRendersExpectedSurfaces",
    "golden path: Concept Map sheet open/dismiss":
        "testConceptMapSheet_OpenAndDismiss",
    "golden path: Glossary sheet open/dismiss":
        "testGlossarySheet_OpenAndDismiss",
    "SRS smoke: Daily Practice then Mastery":
        "test_sidebar_dailyPractice_thenMastery",
    "surface audit: walk all science chapters":
        "testWalkAllScienceChapters",
    "maths discover walk: Ch.10 (integer arithmetic family)":
        "testTryDiscoverModeFromMathsCh10_doesNotCrash",
}

FUNC_RE = re.compile(r'func\s+(test[A-Za-z0-9_]+)\s*\(')


def present_methods(uitests_dir):
    methods = set()
    if not os.path.isdir(uitests_dir):
        return methods
    for dirpath, _dirs, files in os.walk(uitests_dir):
        for f in files:
            if f.endswith(".swift"):
                with open(os.path.join(dirpath, f), encoding="utf-8") as fh:
                    methods.update(FUNC_RE.findall(fh.read()))
    return methods


def audit(uitests_dir, required=REQUIRED):
    methods = present_methods(uitests_dir)
    if not methods:
        return ["K.2: found zero UI test methods — UI-test target missing or moved"]
    errors = []
    for label, name in required.items():
        if name not in methods:
            errors.append(f"K.2: missing critical-flow UI test {name!r} ({label})")
    return errors


def selftest():
    import tempfile
    ok = True
    with tempfile.TemporaryDirectory() as d:
        with open(os.path.join(d, "UITests.swift"), "w", encoding="utf-8") as fh:
            fh.write("func testTryDiscoverModeFromCh1_doesNotCrash() {}\n")
        mini = {"crash ch1": "testTryDiscoverModeFromCh1_doesNotCrash"}
        if audit(d, mini):
            print("SELFTEST FAIL: present method flagged:", audit(d, mini)); ok = False
        mini2 = dict(mini, **{"missing flow": "testThatDoesNotExist"})
        if not any("testThatDoesNotExist" in e for e in audit(d, mini2)):
            print("SELFTEST FAIL: missing method not caught"); ok = False
    # empty dir
    with tempfile.TemporaryDirectory() as d2:
        if not audit(d2, {"x": "testX"}):
            print("SELFTEST FAIL: empty target not caught"); ok = False
    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        return selftest()
    errors = audit(UITESTS_DIR)
    if errors:
        print("check_critical_uitest_presence: FAIL")
        for e in errors[:50]:
            print("  " + e)
        return 1
    print(f"check_critical_uitest_presence: clean — all {len(REQUIRED)} "
          f"critical-flow UI tests present (K.2)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
