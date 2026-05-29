#!/usr/bin/env python3
"""
Lint that pins the zero-`DispatchQueue.main.sync` posture across
the codebase. Closes Family A.7 of
`BUG_FREE_CERTIFICATION_REPORT.md` (the strict, lint-able part).

`DispatchQueue.main.sync` is the classic deadlock-on-itself pattern:
called from the main thread, the dispatch blocks waiting for the
main thread to run the block, which it can't because it's blocked.
The codebase has zero such calls today; this lint pins that.

Related categories that are NOT lint-able by static analysis and
are instead pinned by:
  - A.6 race conditions — `check_view_mainactor.py` covers
    View→DataStore sync access. The wider `Task.detached` /
    `DispatchQueue.global` surface was audited 2026-05-29
    (BUG_FREE_CERTIFICATION_REPORT.md A.6 row); every closure was
    confirmed to isolate writes via `await MainActor.run`,
    `@MainActor`-annotated callees, or value-type returns.
  - A.8 unhandled Swift exception — Swift's `throws` propagation
    is enforced by the type system; `CrashReporter` captures any
    that escape via NSSetUncaughtExceptionHandler.

Usage:
    python3 scripts/check_race_and_deadlock.py
"""
import glob
import os
import re
import sys

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE_GLOB = os.path.join(REPO_ROOT, "desktopAhaan", "**", "*.swift")

# `DispatchQueue.main.sync` — must be zero outside test code.
MAIN_SYNC_RE = re.compile(r"DispatchQueue\s*\.\s*main\s*\.\s*sync\b")


def main() -> int:
    offenders: list[str] = []
    for path in sorted(glob.glob(SOURCE_GLOB, recursive=True)):
        if "Tests" in os.path.basename(path):
            continue
        with open(path) as f:
            src = f.read()
        for m in MAIN_SYNC_RE.finditer(src):
            line_start = src.rfind("\n", 0, m.start()) + 1
            line_prefix = src[line_start: m.start()]
            # Skip comment lines (// or ///)
            if "//" in line_prefix:
                continue
            line_no = src[: m.start()].count("\n") + 1
            rel = os.path.relpath(path, REPO_ROOT)
            offenders.append(f"{rel}:{line_no}")

    if offenders:
        print("check_race_and_deadlock: FAILED — "
              "DispatchQueue.main.sync detected. This is the classic "
              "main-thread-deadlocks-itself pattern; calling it from "
              "the main thread blocks the dispatch on a thread that "
              "can't run the block. Found:")
        for o in offenders:
            print(f"  {o}")
        print()
        print("  Switch to `DispatchQueue.main.async` or, if the value "
              "is needed synchronously, restructure so the caller is "
              "already off-main.")
        return 1
    print("check_race_and_deadlock: clean — 0 DispatchQueue.main.sync "
          "call sites. A.6/A.7 broader posture documented in "
          "BUG_FREE_CERTIFICATION_REPORT.md (audit clean, no static "
          "lint feasible without false-positive noise).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
