#!/usr/bin/env python3
"""Flag `.foregroundColor(.yellow|.orange|.teal)` applied to a Text() view.

Background — `desktopAhaan/Extensions/Extensions.swift` defines deepened
BrandColor accents (gold, burnt-orange, deep teal) that hit WCAG 2.1 AA
on the Discover canvas. But hundreds of direct call-sites still use
`.foregroundColor(.yellow)` / `.orange` / `.teal` — system primaries
that fail AA (1.5-2:1 contrast) when applied to text.

For icons (`Image(systemName:)`, `Image("...")`, decorative shapes)
the system primaries are usually fine — WCAG only requires 3:1 for
icons that convey information, and most of ours are decorative.
So this lint is intentionally narrow: it flags ONLY foregroundColor
calls whose nearest preceding sibling within the same chain is a
`Text(...)` literal.

Heuristic: walk each Swift file line-by-line. When we see a
`.foregroundColor(.<primary>)` line where <primary> is in the offender
list, scan backwards ≤6 lines (typical chain length) for a line that
contains `Text(`. If found, that's a hit. If not, assume icon and skip.

False positives are possible (a `Text(` on line N can apply to a
`.foregroundColor(.yellow)` 12 lines later via long chain). False
negatives too (a Text built from a function call). Heuristic, not
proof. The audit catches the bulk; the WCAG ratchet tests catch the
remainder.

Exit 1 if any offender remains. Used as a pre-commit gate when scene
or chrome files are staged.
"""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
OFFENDER_COLORS = {"yellow", "orange", "teal"}
LOOKBACK = 6
COLOR_PATTERN = re.compile(r"\.foregroundColor\(\.(yellow|orange|teal)\)")
TEXT_PATTERN = re.compile(r"\bText\s*\(")


def scan_file(path: Path) -> list[tuple[int, str, str]]:
    """Returns [(line_no, color, line_content)] hits."""
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except (FileNotFoundError, UnicodeDecodeError):
        return []
    hits: list[tuple[int, str, str]] = []
    for i, line in enumerate(lines):
        m = COLOR_PATTERN.search(line)
        if not m:
            continue
        color = m.group(1)
        # Look back up to LOOKBACK lines for a Text(...) anchor.
        start = max(0, i - LOOKBACK)
        window = "\n".join(lines[start:i])
        if TEXT_PATTERN.search(window):
            hits.append((i + 1, color, line.rstrip()))
    return hits


def _files_to_check(argv: list[str]) -> list[Path]:
    """If args given, treat as paths. Else, all tracked Swift files in
    desktopAhaan/.
    """
    if argv:
        return [Path(p) for p in argv if p.endswith(".swift")]
    try:
        out = subprocess.check_output(
            ["git", "ls-files", "desktopAhaan/**/*.swift"],
            cwd=REPO, text=True
        )
    except subprocess.CalledProcessError:
        return []
    return [REPO / p for p in out.splitlines() if p.endswith(".swift")]


def main(argv: list[str]) -> int:
    files = _files_to_check(argv)
    total_hits = 0
    flagged_files: list[str] = []
    for f in files:
        hits = scan_file(f)
        if not hits:
            continue
        rel = f.relative_to(REPO) if f.is_absolute() else f
        flagged_files.append(str(rel))
        for line_no, color, content in hits:
            print(f"{rel}:{line_no}: .foregroundColor(.{color}) on Text — use BrandColor.* deep hue instead")
            print(f"    {content.strip()}")
            total_hits += 1
    if total_hits == 0:
        print("check_color_literals: clean — no Text widgets use system-primary fg colours")
        return 0
    print()
    print(f"FAILED: {total_hits} Text widget(s) across {len(flagged_files)} file(s) " +
          "use a system-primary foreground colour that fails WCAG AA on the canvas.")
    print("Fix: replace .foregroundColor(.yellow|.orange|.teal) with the deepened")
    print("       DesignTokens.BrandColor.* equivalent (mnemonic/tryAtHome/relatedConcepts/etc.)")
    print("       OR add a tighter Image(...).accessibilityHidden(true) chain so this lint sees it as an icon.")
    return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
