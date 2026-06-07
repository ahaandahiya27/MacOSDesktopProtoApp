#!/usr/bin/env python3
"""Inject `solvedGuideHTML: "<stem>_SolvedGuide.html"` into every
OlympiadPaper entry in the 4 OlympiadPaperRegistry+*.swift sister files.

Idempotent. Reads the `questionPaperHTML: "<stem>.html"` line of each
entry to derive the SolvedGuide filename, then verifies the file
actually exists in `desktopAhaan/Resources/TestPapers/` before
inserting the line. The closing `)` of the entry that previously ended
with `suggestedTimeMinutes: 90` becomes `suggestedTimeMinutes: 90,`
and the new `solvedGuideHTML: "..."` line is inserted before the `)`.

Entries that already have `solvedGuideHTML:` are left untouched.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PAPERS_DIR = ROOT / "desktopAhaan" / "Resources" / "TestPapers"

REGISTRY_FILES = [
    ROOT / "desktopAhaan" / "Subjects" / "OlympiadTests" / "OlympiadPaperRegistry+MathsPapers.swift",
    ROOT / "desktopAhaan" / "Subjects" / "OlympiadTests" / "OlympiadPaperRegistry+SciencePapers.swift",
    ROOT / "desktopAhaan" / "Subjects" / "OlympiadTests" / "OlympiadPaperRegistry+SanskritPapers.swift",
    ROOT / "desktopAhaan" / "Subjects" / "OlympiadTests" / "OlympiadPaperRegistry+SocialSciencePapers.swift",
]


# Match a complete OlympiadPaper(...) block. Greedy from the opening
# struct-call paren through the matching closing paren of the entry,
# which we recognize as a line that is exactly "        )" or "        ),".
ENTRY_RE = re.compile(
    r"(OlympiadPaper\(\n"                            # opening line
    r"(?:(?!OlympiadPaper\()[^\n]*\n)*?"             # body lines that don't start a new entry
    r"            suggestedTimeMinutes: \d+\n"       # last simple field
    r"        \)(?:,)?\n)",                          # closing paren (with optional comma)
    re.MULTILINE,
)

QP_HTML_RE = re.compile(r'questionPaperHTML: "([^"]+)\.html"')


def patch_file(path: Path) -> tuple[int, int]:
    """Returns (n_added, n_skipped_already_wired)."""
    text = path.read_text()
    added = 0
    already = 0

    def repl(m: re.Match) -> str:
        nonlocal added, already
        block = m.group(1)
        if "solvedGuideHTML:" in block:
            already += 1
            return block
        qm = QP_HTML_RE.search(block)
        if not qm:
            return block
        stem = qm.group(1)
        guide_name = f"{stem}_SolvedGuide.html"
        guide_path = PAPERS_DIR / guide_name
        if not guide_path.exists():
            print(f"  WARN: {guide_name} not on disk, skipping wire", file=sys.stderr)
            return block
        # Find the "suggestedTimeMinutes: NN" line and append a comma,
        # then insert the new line + closing paren.
        new_block = re.sub(
            r"(            suggestedTimeMinutes: \d+)\n        \)(,?)\n",
            lambda x: (
                x.group(1) + ",\n"
                + f'            solvedGuideHTML: "{guide_name}"\n'
                + "        )" + x.group(2) + "\n"
            ),
            block,
            count=1,
        )
        if new_block == block:
            print(f"  WARN: couldn't splice into entry for {stem}", file=sys.stderr)
            return block
        added += 1
        return new_block

    new_text = ENTRY_RE.sub(repl, text)
    if new_text != text:
        path.write_text(new_text)
    return added, already


def main() -> int:
    total_added = 0
    total_already = 0
    for f in REGISTRY_FILES:
        added, already = patch_file(f)
        print(f"{f.name}: +{added} wired, {already} already")
        total_added += added
        total_already += already
    print(f"\ntotal: +{total_added} wired, {total_already} already wired")
    return 0


if __name__ == "__main__":
    sys.exit(main())
