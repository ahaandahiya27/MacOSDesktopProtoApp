#!/usr/bin/env python3
"""Combine `.sink { ... }` must use `[weak self]` for stored cancellables.

Why this matters. Every `Cancellable` stored in `cancellables: Set<AnyCancellable>`
is process-lifetime as long as `self` (an `@MainActor` class) lives. If
`.sink { ... }` captures `self` STRONGLY, the closure holds `self` and the
publisher upstream holds the closure — net effect is a retain cycle that
keeps the entire view-model alive even after every reference is dropped.

On a hot path (8 GB iMac, multi-hour session), even one leaked view-model
keeps every `@Published` array alive — eventually filling the working set.

The repo convention (`check_lifetime_hazards` LH004 already gates the
`.sink` / `.assign` / Timer / NotificationCenter cases) covers the common
patterns. This lint is the FINE-GRAINED sister: it catches `.sink { ... }`
calls where the closure body uses `self.` WITHOUT a `[weak self]` capture
list at the closure head — even if the outer expression is on a publisher
that isn't otherwise flagged.

The 2026-06-05 audit verified all 3 existing `.sink` chains (`AdaptiveDifficulty
Engine`, `AchievementEngine`, `TranslatorViewModel`) DO use `[weak self]`.
This lint pins the discipline.

Usage:
    python3 scripts/check_combine_sink_weakself.py [--quiet] [paths ...]
    python3 scripts/check_combine_sink_weakself.py --selftest
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

# Two forms:
#   .sink { ... }                       — trailing-closure (the `{` opens
#                                          immediately or after a `(...)` arg)
#   .sink(receiveValue: { ... })        — closure-as-inner-arg (the `{` opens
#                                          INSIDE the `(...)` arg list)
#   .sink(receiveCompletion: ..., receiveValue: { ... })  — same as above
# We match the `.sink` location, then look forward for the FIRST `{` that
# opens the closure body.
_SINK_OPEN = re.compile(r"\.sink\b")

_LINE_COMMENT = re.compile(r"//[^\n]*")


def scan_text(src: str) -> list[tuple[int, str]]:
    cleaned = _LINE_COMMENT.sub("", src)
    findings: list[tuple[int, str]] = []
    for m in _SINK_OPEN.finditer(cleaned):
        # Find the FIRST `{` after `.sink` (within the next ~200 chars to
        # avoid runaway across unrelated braces in a fall-through block).
        scan_window = cleaned[m.end() : m.end() + 200]
        brace_idx = scan_window.find("{")
        if brace_idx < 0:
            continue
        # Body starts right after that `{`.
        body_window = scan_window[brace_idx + 1 : brace_idx + 1 + 150]
        # If the closure body references `self.` or `self?.` (anything more
        # than a bare argument label), it needs `[weak self]` or `[unowned
        # self]`. `[unowned self]` is forbidden by check_lifetime_hazards
        # LH002, so the only safe form here is `[weak self]`.
        uses_self = bool(re.search(r"\bself[\.\?]", body_window))
        has_weak_self = bool(re.search(r"\[\s*weak\s+self", body_window))
        # `[unowned self]` would be caught by LH002 separately; we just
        # need to ensure if `self` is used, `[weak self]` precedes it.
        if uses_self and not has_weak_self:
            line_no = cleaned.count("\n", 0, m.start()) + 1
            # Show the .sink line snippet trimmed for readability.
            line_start = cleaned.rfind("\n", 0, m.start()) + 1
            line_end = cleaned.find("\n", m.end())
            if line_end < 0:
                line_end = len(cleaned)
            snippet = cleaned[line_start:line_end].strip()
            if len(snippet) > 100:
                snippet = snippet[:97] + "..."
            findings.append((line_no, snippet))
    return findings


def scan_file(path: Path) -> list[tuple[int, str]]:
    try:
        return scan_text(path.read_text(encoding="utf-8"))
    except (UnicodeDecodeError, OSError):
        return []


def run_selftest() -> int:
    danger = """
    cancellable = publisher.sink { value in
        self.handleValue(value)
    }
    other = publisher.sink(receiveValue: { value in
        self.process(value)
    })
    """
    safe = """
    cancellable = publisher.sink { [weak self] value in
        self?.handleValue(value)
    }
    other = publisher.sink(receiveValue: { [weak self] value in
        self?.process(value)
    })
    // self-less sink — no [weak self] needed
    pureSink = publisher.sink { value in
        print(value)
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
            for (line_no, snippet) in scan_file(swift):
                print(
                    f"{swift}:{line_no}  .sink {{ ... self ... }} without [weak self]"
                )
                print(f"    {snippet}")
                failed = True
    if failed:
        print()
        print("These Combine .sink call sites capture `self` strongly. If")
        print("the resulting Cancellable is stored on the same `self`, the")
        print("closure → self → cancellables → closure cycle keeps the")
        print("view-model alive forever.")
        print()
        print("Fix: add `[weak self]` to the closure capture list and")
        print("replace `self.foo` with `self?.foo`.")
        return 1
    if not args.quiet:
        print("all Combine .sink call sites use [weak self] where they touch self")
    return 0


if __name__ == "__main__":
    sys.exit(main())
