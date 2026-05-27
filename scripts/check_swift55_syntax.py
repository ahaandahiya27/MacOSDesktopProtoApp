#!/usr/bin/env python3
"""Big Sur Swift 5.5 syntax lint.

Deploy target is Xcode 13.2.1 / Swift 5.5 on Big Sur 11.7.11 (CLAUDE.md).
Newer Swift versions added pleasant shorthands and idioms that compile
clean on a dev Mac (Swift 5.7+) but hard-fail on the iMac with errors
like "Variable binding in a condition requires an initializer".

Each recurrence costs an iMac compile cycle (5–15 min) + a fix-and-push
cycle. This lint catches the patterns at commit time so they never
reach origin.

Hard gate: any match in non-comment, non-string Swift code is a refusal.

Bypass: `git commit --no-verify` if a genuinely-guarded `#if swift(>=5.7)`
block needs to land.

Current rules:

  - SS001 — `if let foo {`            shorthand binding (Swift 5.7+).
  - SS002 — `guard let foo else {`    shorthand binding (Swift 5.7+).
  - SS003 — `while let foo {`         shorthand binding (Swift 5.7+).

The compat rewrite is mechanical: `if let foo {` → `if let foo = foo {`.
"""
from __future__ import annotations
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# Each rule: (id, regex, what-it-catches, compat-rewrite-hint).
# Regex matches shorthand binding: the binder appears WITHOUT `= rhs`
# before the next `{`, `,`, or `else`. Captures cases like:
#   if let foo {
#   if let foo, let bar = baz {
#   guard let foo else { return }
#   while let foo {
RULES = [
    (
        "SS001",
        re.compile(r"\bif\s+let\s+(\w+)\s*(?=[,{])"),
        "Swift 5.7 shorthand `if let X` — Swift 5.5 needs `if let X = X`",
        "if let foo  →  if let foo = foo",
    ),
    (
        "SS002",
        re.compile(r"\bguard\s+let\s+(\w+)\s*(?=else\b|,)"),
        "Swift 5.7 shorthand `guard let X` — Swift 5.5 needs `guard let X = X`",
        "guard let foo else  →  guard let foo = foo else",
    ),
    (
        "SS003",
        re.compile(r"\bwhile\s+let\s+(\w+)\s*(?=[{,])"),
        "Swift 5.7 shorthand `while let X` — Swift 5.5 needs `while let X = X`",
        "while let foo  →  while let foo = foo",
    ),
]

# Strip // line comments AND /* … */ block comments AND "..." / """…""" strings
# so the binder regex doesn't false-positive inside doc text.
LINE_COMMENT = re.compile(r"//[^\n]*")
BLOCK_COMMENT = re.compile(r"/\*.*?\*/", re.DOTALL)
TRIPLE_STRING = re.compile(r'""".*?"""', re.DOTALL)
SINGLE_STRING = re.compile(r'"(?:\\.|[^"\\])*"')


def scrub(src: str) -> str:
    src = BLOCK_COMMENT.sub("", src)
    src = TRIPLE_STRING.sub('""', src)
    src = SINGLE_STRING.sub('""', src)
    src = LINE_COMMENT.sub("", src)
    return src


def scan_file(path: Path) -> list[tuple[str, int, str, str, str]]:
    text = path.read_text(encoding="utf-8", errors="replace")
    scrubbed = scrub(text)
    raw_lines = text.splitlines()
    scrubbed_lines = scrubbed.splitlines()
    hits: list[tuple[str, int, str, str, str]] = []
    for rule_id, rx, what, hint in RULES:
        for i, line in enumerate(scrubbed_lines):
            if rx.search(line):
                # Surface the ORIGINAL line text (with comments etc.) so the
                # dev sees what they actually wrote.
                original = raw_lines[i] if i < len(raw_lines) else line
                hits.append((rule_id, i + 1, original.rstrip(), what, hint))
    return hits


def main() -> int:
    swift_files = list((REPO_ROOT / "desktopAhaan").rglob("*.swift"))
    swift_files += list((REPO_ROOT / "desktopAhaanTests").rglob("*.swift"))
    swift_files += list((REPO_ROOT / "desktopAhaanUITests").rglob("*.swift"))
    swift_files = [p for p in swift_files if p.is_file()]

    all_hits: list[tuple[Path, str, int, str, str, str]] = []
    for f in swift_files:
        for rule_id, lineno, src, what, hint in scan_file(f):
            all_hits.append((f, rule_id, lineno, src, what, hint))

    if not all_hits:
        print(
            f"check_swift55_syntax: clean — scanned {len(swift_files)} files for "
            "Swift 5.7+ binder shorthand."
        )
        return 0

    print(
        f"check_swift55_syntax: {len(all_hits)} violation(s) "
        f"across {len(swift_files)} Swift file(s):"
    )
    print()
    for path, rule_id, lineno, src, what, hint in all_hits:
        rel = path.relative_to(REPO_ROOT)
        print(f"  {rel}:{lineno}  [{rule_id}]  {what}")
        print(f"    {src.strip()}")
        print(f"    fix:  {hint}")
        print()
    print(
        "These patterns compile clean on the dev Mac (Swift 5.7+) but fail on the"
    )
    print('iMac (Swift 5.5) with "Variable binding in a condition requires an')
    print("initializer\". Expand each binder before committing.")
    return 1


if __name__ == "__main__":
    sys.exit(main())
