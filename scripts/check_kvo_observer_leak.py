#!/usr/bin/env python3
"""
Lint that catches KVO observer registrations without a paired
removal — and, today, asserts the KVO surface is empty.

Closes Family B.8 of BUG_FREE_CERTIFICATION_REPORT.md.

KVO (`addObserver:forKeyPath:options:context:` /
`observe(\\.path)`) requires explicit removal in `deinit` or
`willRelease`; SwiftUI does not manage this for you. The codebase
deliberately doesn't use KVO today — observation flows through
Combine (`@Published`), `@StateObject`, or NotificationCenter.
This lint pins that posture: a new KVO addObserver call without
a matching `removeObserver` / `invalidate()` fails CI.

Patterns flagged (in non-test code):
  - `\\.addObserver(_:forKeyPath:options:context:)`
  - `\\.observe(\\\\.<keypath>, options:...)` returning
    NSKeyValueObservation (must be retained and invalidated)
  - `NSKeyValueObservation` type references

Currently the codebase shows zero hits for any of the above —
this lint locks the empty state.

Usage:
    python3 scripts/check_kvo_observer_leak.py
"""
import glob
import os
import re
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE_GLOB = os.path.join(REPO_ROOT, "desktopAhaan", "**", "*.swift")

# Patterns that indicate KVO use.
KVO_PATTERNS = [
    (re.compile(r"\baddObserver\s*\(\s*[^,]+,\s*forKeyPath\s*:"),
     "addObserver(_:forKeyPath:options:context:)"),
    (re.compile(r"NSKeyValueObservation\b"),
     "NSKeyValueObservation type reference"),
    # Modern Swift KVO uses .observe(\.keyPath, options:); the keypath
    # syntax is distinctive enough to detect without false positives.
    (re.compile(r"\.observe\s*\(\s*\\\."),
     ".observe(\\.keyPath, options:) — KVO via Swift API"),
]


def main() -> int:
    offenders: list[str] = []
    for path in sorted(glob.glob(SOURCE_GLOB, recursive=True)):
        if "Tests" in os.path.basename(path):
            continue
        with open(path) as f:
            src = f.read()
        for pattern, label in KVO_PATTERNS:
            for m in pattern.finditer(src):
                line_start = src.rfind("\n", 0, m.start()) + 1
                line_prefix = src[line_start: m.start()]
                if "//" in line_prefix or "///" in line_prefix:
                    continue
                line_no = src[: m.start()].count("\n") + 1
                rel = os.path.relpath(path, REPO_ROOT)
                offenders.append(f"{rel}:{line_no} — {label}")

    if offenders:
        print("check_kvo_observer_leak: FAILED — KVO use detected in "
              "code that previously had none. KVO requires explicit "
              "removeObserver / invalidate() in deinit:")
        for o in offenders:
            print(f"  {o}")
        print()
        print("  If the KVO use is intentional and properly torn down,")
        print("  switch this lint to a paired-removal check instead of")
        print("  the empty-surface assertion.")
        return 1
    print("check_kvo_observer_leak: clean — no KVO observers in code; "
          "observation flows through Combine / @Published / "
          "NotificationCenter.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
