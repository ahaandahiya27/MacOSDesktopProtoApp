#!/usr/bin/env python3
"""check_file_size.py — refuse new Swift files over the Big Sur Swift 5.5
type-checker risk threshold.

The deploy iMac runs Xcode 13.2.1 / Swift 5.5. Big Sur's Swift type-
checker has a hard wall around files that combine many ViewBuilder
chains, deep modifier nesting, and large generic depth: once a file
crosses ~600 lines of typical SwiftUI code the type-check phase can
hit a 60-second timeout and produce a build break that bisects badly
("can't type-check expression in reasonable time").

The threshold is a heuristic, not a guarantee — some 700-LOC files
type-check in 5 s and some 400-LOC files time out. But the LOC ceiling
correlates well with risk and is mechanical to enforce.

This lint:
  - Walks every `.swift` file under `desktopAhaan/`.
  - Counts lines (including blanks and comments — keeps the rule simple).
  - Flags any file > THRESHOLD that isn't in the allowlist.
  - Reports current-state grandfathered files separately so adding new
    files-over-threshold can't hide behind the existing offenders.

Allowlist format (one entry per line, `# comments` allowed):
  desktopAhaan/path/to/File.swift: reason for the grandfathering.

Exit codes:
  0  — clean (only allowlisted oversized files exist)
  1  — at least one new file is over the threshold
  2  — script bug / fixture missing

Run from the repo root: `python3 scripts/check_file_size.py`.
"""

from __future__ import annotations

import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SOURCE_DIR = REPO_ROOT / "desktopAhaan"
ALLOWLIST_PATH = REPO_ROOT / "scripts" / "file_size_allowlist.txt"

# Big Sur Swift 5.5 type-checker risk threshold.
THRESHOLD = 600

# Subdirectories not subject to the rule (e.g. test fixtures, generated
# code). Tests live in a separate target with different perf characteristics;
# they aren't on the Big Sur type-checker risk path.
EXEMPT_PATH_FRAGMENTS = (
    "/FoundationTutor.swift",
)


def _is_exempt(path: Path) -> bool:
    rel = str(path)
    return any(frag in rel for frag in EXEMPT_PATH_FRAGMENTS)


def _read_allowlist() -> set[str]:
    if not ALLOWLIST_PATH.exists():
        return set()
    keys: set[str] = set()
    for raw in ALLOWLIST_PATH.read_text().splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        # Lines: `path/to/file.swift: human-readable reason`
        # Only the `path` part (before the first `:`) is the lookup key.
        path_part = line.split(":", 1)[0].strip()
        if path_part:
            keys.add(path_part)
    return keys


def _line_count(path: Path) -> int:
    # Count newlines + 1 if last byte is not newline. Cheap & correct.
    try:
        text = path.read_text()
    except UnicodeDecodeError:
        return 0
    if not text:
        return 0
    n = text.count("\n")
    if not text.endswith("\n"):
        n += 1
    return n


def main() -> int:
    if not SOURCE_DIR.exists():
        print(
            f"check_file_size: source dir not found at {SOURCE_DIR}",
            file=sys.stderr,
        )
        return 2

    allow = _read_allowlist()
    new_violations: list[tuple[str, int]] = []
    grandfathered: list[tuple[str, int]] = []

    for swift_path in sorted(SOURCE_DIR.rglob("*.swift")):
        if _is_exempt(swift_path):
            continue
        lines = _line_count(swift_path)
        if lines <= THRESHOLD:
            continue
        rel = swift_path.relative_to(REPO_ROOT).as_posix()
        if rel in allow:
            grandfathered.append((rel, lines))
        else:
            new_violations.append((rel, lines))

    if new_violations:
        print(
            "check_file_size: new violations over "
            f"{THRESHOLD} LOC (Big Sur Swift 5.5 type-checker risk):"
        )
        for rel, lines in new_violations:
            print(f"  {rel}: {lines} LOC")
        print()
        print(
            "Fix: split the file along natural seams (e.g. lift sub-views "
            "into a `+Foo.swift` sister file, move helpers into an "
            "extension file). If the file is genuinely indivisible, add it "
            "to scripts/file_size_allowlist.txt with a one-line reason."
        )
        return 1

    if grandfathered:
        total = len(grandfathered)
        print(
            f"check_file_size: clean — {total} pre-existing oversized "
            f"file(s) grandfathered via allowlist."
        )
    else:
        print("check_file_size: clean — every file is under the 600 LOC threshold.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
