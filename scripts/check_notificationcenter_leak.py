#!/usr/bin/env python3
"""
Lint that catches imperative NotificationCenter observers without
a paired removal — and, today, asserts that the imperative-observer
surface is empty.

Closes Family B.7 of BUG_FREE_CERTIFICATION_REPORT.md.

The codebase observes notifications exclusively via the SwiftUI
publisher pattern, which auto-removes its subscription when the
view is torn down:

    .onReceive(NotificationCenter.default.publisher(for: .name)) { _ in
        ...
    }

The imperative `addObserver(_:selector:name:object:)` and
`addObserver(forName:object:queue:using:)` calls would require an
explicit `removeObserver` in `deinit`. Without it, the observed
object outlives the observer's intended lifetime — a slow,
silent leak. This lint pins the empty surface so a future commit
that adds an imperative observer triggers a review.

Allowed (whitelisted):
  - `NotificationCenter.default.publisher(for:)` — the SwiftUI path.
  - `.post(name:object:userInfo:)` — posting is not observing.

Flagged:
  - `addObserver(_:selector:name:object:)` (old-style ObjC)
  - `addObserver(forName:object:queue:using:)` (block-based)

Usage:
    python3 scripts/check_notificationcenter_leak.py
"""
import glob
import os
import re
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE_GLOB = os.path.join(REPO_ROOT, "desktopAhaan", "**", "*.swift")

PATTERNS = [
    (re.compile(r"\baddObserver\s*\(\s*[^,]+,\s*selector\s*:"),
     "addObserver(_:selector:name:object:)"),
    (re.compile(r"\baddObserver\s*\(\s*forName\s*:"),
     "addObserver(forName:object:queue:using:)"),
]


def main() -> int:
    offenders: list[str] = []
    for path in sorted(glob.glob(SOURCE_GLOB, recursive=True)):
        if "Tests" in os.path.basename(path):
            continue
        with open(path) as f:
            src = f.read()
        for pattern, label in PATTERNS:
            for m in pattern.finditer(src):
                line_start = src.rfind("\n", 0, m.start()) + 1
                line_prefix = src[line_start: m.start()]
                if "//" in line_prefix or "///" in line_prefix:
                    continue
                line_no = src[: m.start()].count("\n") + 1
                rel = os.path.relpath(path, REPO_ROOT)
                offenders.append(f"{rel}:{line_no} — {label}")

    if offenders:
        print("check_notificationcenter_leak: FAILED — imperative "
              "NotificationCenter observer detected. The codebase "
              "observes via the SwiftUI `.onReceive(publisher)` "
              "pattern, which auto-cleans up. Found:")
        for o in offenders:
            print(f"  {o}")
        print()
        print("  Either switch to .onReceive(NotificationCenter.default")
        print("  .publisher(for: .name)) inside a View, or pair every")
        print("  addObserver with a removeObserver in deinit and switch")
        print("  this lint to a paired-removal check.")
        return 1
    print("check_notificationcenter_leak: clean — all NotificationCenter "
          "observers flow through SwiftUI .onReceive(publisher); no "
          "imperative addObserver call sites.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
