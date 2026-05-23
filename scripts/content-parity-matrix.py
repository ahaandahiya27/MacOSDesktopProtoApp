#!/usr/bin/env python3
"""content-parity-matrix.py — current per-chapter content counts vs floors.

Reads desktopAhaan/Subjects/Packs/science_class7.json and emits
CONTENT_PARITY_MATRIX.md at the repo root. Rows = chapters 1..19,
columns = the 16 content types from the parity spec.

Each cell shows: `<current>/<floor> <icon>` where the icon is:
  ✅ = at or above floor
  ⚠️ = within 50 % of floor
  ❌ = below 50 % or zero

Run from the repo root:
    python3 scripts/content-parity-matrix.py
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PACK_PATH = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs" / "science_class7.json"
OUTPUT_PATH = REPO_ROOT / "CONTENT_PARITY_MATRIX.md"
ARTICLE_DIR = REPO_ROOT / "desktopAhaan" / "Resources" / "Articles"

# (key in chapter dict, short column header, floor, optional ?)
# A column with `applies = False` for some chapters is shown as `n/a`.
COLUMN_SPECS: list[tuple[str, str, int]] = [
    # (json-key, header, floor)
    ("__concepts_total", "Conc", 8),
    ("__questions_total", "Qs", 22),
    ("realWorldExamples", "RWEx", 5),
    ("examConnections", "Exam", 3),
    ("mnemonics", "Mnem", 3),
    ("misconceptions", "Misc", 5),
    ("ncertQA", "NCERT", 8),
    ("glossary", "Gloss", 10),
    ("miniProjects", "Proj", 2),
    ("scientists", "Sci", 1),
    ("whatIfs", "WhatIf", 3),
    ("crossChapterRefs", "Cross", 2),
    ("__curriculum_bridge", "Bridge", 1),
    ("gallery", "Gal", 6),
    ("timelines", "TL", 1),
    ("__article_words", "Art", 600),
    # Deep Dive + Visual Media columns added 2026-05-23.
    # DeepDive floor = ≥3 stretch topics per chapter. Visual floor
    # rolls up the achievable media types (M2 ≥4 shape diagrams, M3
    # ≥3 scene refs, M5 ≥3 narration flags) into one ✅/❌; M1
    # (bundled PNG/PDF) and M4 (bundled video) are deferred with
    # FACT_CHECK_TODOS entries since fresh-asset creation is outside
    # this session's scope.
    ("__deep_dive_count", "Deep", 3),
    ("__visual_media_rollup", "Vis", 10),
]


def _count_for(chapter: dict, key: str) -> int:
    if key == "__concepts_total":
        return sum(len(t.get("concepts", [])) for t in chapter.get("topics", []))
    if key == "__questions_total":
        return sum(len(t.get("questions", [])) for t in chapter.get("topics", []))
    if key == "__curriculum_bridge":
        return 1 if chapter.get("curriculumBridge") else 0
    if key == "__article_words":
        # Sum word counts across all article files for this chapter.
        return _article_words(chapter.get("id", ""))
    if key == "__deep_dive_count":
        items = chapter.get("deepDive", []) or []
        return len(items)
    if key == "__visual_media_rollup":
        # Sum of M2 (shapeDiagram) + M3 (animatedSceneRef) + M5
        # (narratedWalkthrough) counts. Floor is 4 + 3 + 3 = 10 so a
        # chapter that meets all three sub-floors gets ✅.
        media = chapter.get("mediaAssets", []) or []
        m2 = sum(1 for a in media if a.get("kind") == "shapeDiagram")
        m3 = sum(1 for a in media if a.get("kind") == "animatedSceneRef")
        m5 = sum(1 for a in media if a.get("kind") == "narratedWalkthrough")
        return m2 + m3 + m5
    value = chapter.get(key, [])
    if value is None:
        return 0
    if isinstance(value, list):
        return len(value)
    if isinstance(value, dict):
        return 1
    return 0


def _article_words(chapter_id: str) -> int:
    """Sum word counts across all .html / .md article files for this
    chapter. Chapter folder naming convention: `Chapter{NN}` where NN
    is zero-padded from the chapter number."""
    if not chapter_id.startswith("ch") or len(chapter_id) < 4:
        return 0
    try:
        n = int(chapter_id[2:])
    except ValueError:
        return 0
    # Folder naming is inconsistent: Ch.1-9 are "Chapter1".."Chapter9"
    # (no zero-pad), Ch.10-19 are "Chapter10".."Chapter19". Try both.
    folder = ARTICLE_DIR / f"Chapter{n:02d}"
    if not folder.exists():
        folder = ARTICLE_DIR / f"Chapter{n}"
    total = 0
    if not folder.exists():
        return 0
    for ext in ("*.html", "*.md"):
        for f in folder.glob(ext):
            try:
                text = f.read_text(encoding="utf-8")
            except (OSError, UnicodeDecodeError):
                continue
            # Crude HTML strip: just remove tag-like segments before
            # counting. Good enough for a parity gauge.
            stripped = []
            in_tag = False
            for ch in text:
                if ch == "<":
                    in_tag = True
                elif ch == ">":
                    in_tag = False
                elif not in_tag:
                    stripped.append(ch)
            words = "".join(stripped).split()
            total += len(words)
    return total


def _icon(current: int, floor: int) -> str:
    if current >= floor:
        return "✅"
    if current >= floor * 0.5:
        return "⚠️"
    return "❌"


def _row(chapter: dict) -> tuple[str, list[str], int, int]:
    """Returns (chapter-id, formatted cells, ok_count, todo_count)."""
    cells = []
    ok = 0
    todo = 0
    for key, _hdr, floor in COLUMN_SPECS:
        c = _count_for(chapter, key)
        icon = _icon(c, floor)
        if icon == "✅":
            ok += 1
        else:
            todo += 1
        cells.append(f"{c}/{floor} {icon}")
    return chapter.get("id", "?"), cells, ok, todo


def main() -> int:
    if not PACK_PATH.exists():
        print(f"content-parity-matrix: pack not found at {PACK_PATH}", file=sys.stderr)
        return 2
    with PACK_PATH.open() as f:
        pack = json.load(f)
    chapters = pack.get("chapters", [])
    if not chapters:
        print("content-parity-matrix: zero chapters in pack", file=sys.stderr)
        return 2

    # Build the table.
    lines: list[str] = []
    lines.append("# Content parity matrix — Science Class 7\n")
    lines.append(
        "Auto-generated by `scripts/content-parity-matrix.py`. Re-run after every "
        "chapter authoring iteration. Rows = the 19 chapters; columns = the 16 "
        "content types from the per-chapter content floor. Each cell shows "
        "`<current>/<floor> <icon>` where:\n\n"
        "- ✅ at or above floor\n"
        "- ⚠️ within 50 % of floor\n"
        "- ❌ below 50 % or zero\n"
    )
    lines.append(
        "Floors are defined in the content-expansion session prompt. The lint "
        "scripts (`check_macos12_apis.py`, `check_lifetime_hazards.py`, "
        "`check_file_size.py`) gate code quality; this matrix gates content "
        "quality. New chapter authoring lifts cells from ❌ → ⚠️ → ✅.\n"
    )

    header = "| Ch | " + " | ".join(h for _, h, _ in COLUMN_SPECS) + " | ✅ |"
    sep = "|----|" + "|".join(["----"] * len(COLUMN_SPECS)) + "|----|"
    lines.append(header)
    lines.append(sep)

    totals_ok = 0
    totals_cells = 0
    for chapter in chapters:
        cid, cells, ok, _todo = _row(chapter)
        lines.append(f"| {cid} | " + " | ".join(cells) + f" | {ok}/{len(cells)} |")
        totals_ok += ok
        totals_cells += len(cells)

    lines.append("")
    lines.append(f"**Roll-up:** {totals_ok} of {totals_cells} cells at ✅ "
                 f"({100*totals_ok//totals_cells if totals_cells else 0} %).\n")

    OUTPUT_PATH.write_text("\n".join(lines))
    # Also print the table to stdout so the runner sees current state.
    for line in lines:
        print(line)
    return 0


if __name__ == "__main__":
    sys.exit(main())
