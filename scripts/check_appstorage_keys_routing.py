#!/usr/bin/env python3
"""@AppStorage keys must route through `AppStorageKeys` enum.

Why this matters. The deploy iMac is a single-user offline app where the
kid's progress lives entirely in `UserDefaults` via `@AppStorage`. A
typo in a key string silently forks a FRESH cursor on next launch —
streak counters reset, "what's new" badges reappear, last-read chapter
forgets. The corruption is invisible at compile time and only surfaces
as silent regressions weeks later.

The repo convention (CLAUDE.md → "Key invariants") routes every key
through the `AppStorageKeys` enum in `desktopAhaan/Extensions/AppStorageKeys.swift`:

    @AppStorage(AppStorageKeys.deepDiveDisclosureExpanded) private var x = false

NOT:

    @AppStorage("deepDive.disclosureExpanded") private var x = false   ← typo-able

This lint blocks the unsafe form. Hard gate at pre-commit.

The 2026-06-04 audit caught one regression — `DeepDiveSection.swift`
had a raw `@AppStorage("deepDive.disclosureExpanded")` literal that
slipped through the convention. Fixed in the same commit that
introduces this lint.

Usage:
    python3 scripts/check_appstorage_keys_routing.py [--quiet] [paths ...]
    python3 scripts/check_appstorage_keys_routing.py --selftest
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

# `@AppStorage("...")` with a string literal as the first arg — the unsafe
# form. The safe form passes an `AppStorageKeys.<name>` identifier or a call
# like `AppStorageKeys.discoverScene(_:)`.
_UNSAFE_APPSTORAGE = re.compile(r'@AppStorage\(\s*"[^"]+"\s*[,)]')

# Strip `// ...` line comments so a comment-quoted example doesn't false-fire.
_LINE_COMMENT = re.compile(r"//[^\n]*")


def scan_text(src: str) -> list[tuple[int, str]]:
    cleaned = _LINE_COMMENT.sub("", src)
    findings: list[tuple[int, str]] = []
    for m in _UNSAFE_APPSTORAGE.finditer(cleaned):
        line_no = cleaned.count("\n", 0, m.start()) + 1
        findings.append((line_no, m.group(0)))
    return findings


def scan_file(path: Path) -> list[tuple[int, str]]:
    try:
        return scan_text(path.read_text(encoding="utf-8"))
    except (UnicodeDecodeError, OSError):
        return []


def run_selftest() -> int:
    danger = """
    struct V: View {
      @AppStorage("hasSeenWelcome") var seen: Bool = false
      @AppStorage("deepDive.expanded") var expanded: Bool = false
    }
    """
    safe = """
    struct V: View {
      @AppStorage(AppStorageKeys.hasSeenWelcome) var seen: Bool = false
      @AppStorage(AppStorageKeys.deepDiveDisclosureExpanded) var expanded: Bool = false
      @AppStorage(AppStorageKeys.discoverScene(1)) var cursor: Int = 0
      // Example comment: @AppStorage("ignored.in.comment") should be ignored
    }
    """
    ok = True
    d = scan_text(danger)
    if len(d) != 2:
        print(f"SELFTEST FAIL: danger fixture flagged {len(d)} sites, expected 2")
        for v in d:
            print("  ", v)
        ok = False
    s = scan_text(safe)
    if len(s) != 0:
        print(f"SELFTEST FAIL: safe fixture flagged {len(s)} sites, expected 0")
        for v in s:
            print("  ", v)
        ok = False
    print("selftest passed" if ok else "selftest FAILED")
    return 0 if ok else 1


def main() -> int:
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    ap.add_argument(
        "paths",
        nargs="*",
        default=["desktopAhaan"],
        help="roots to scan (default: desktopAhaan)",
    )
    ap.add_argument("--quiet", action="store_true")
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()

    if args.selftest:
        return run_selftest()

    failed = False
    for top in args.paths:
        root = Path(top)
        if not root.exists():
            continue
        if root.is_file():
            files = [root] if root.suffix == ".swift" else []
        else:
            files = sorted(root.rglob("*.swift"))
        for swift in files:
            if "Tests" in swift.name:
                continue
            for (line_no, match_text) in scan_file(swift):
                print(
                    f"{swift}:{line_no}  {match_text} — raw string literal, "
                    f"route through AppStorageKeys"
                )
                failed = True
    if failed:
        print()
        print("These @AppStorage call sites use a raw string literal. A typo")
        print("silently forks a fresh cursor on next launch — streak resets,")
        print("badges reappear, last-read chapter forgets.")
        print()
        print("Fix: add a `static let` to `desktopAhaan/Extensions/AppStorageKeys.swift`")
        print("and reference it: @AppStorage(AppStorageKeys.yourKey)")
        return 1
    if not args.quiet:
        print("all @AppStorage call sites route through AppStorageKeys")
    return 0


if __name__ == "__main__":
    sys.exit(main())
