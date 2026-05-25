#!/usr/bin/env python3
"""
migrate_boss_quiz_to_pack.py — one-shot migration of hand-authored
Boss Quiz MCQs from 19 Scene9_BossQuiz*.swift files into
science_class7.json's `chapters[].bossQuestions` arrays.

Background:
The 2026-05-24 learning-loop session wired every Boss Quiz answer
into the SRS scheduler under ephemeral ids (`bossquiz_chNN_qII`).
The capture works, but `SubjectRegistry.location(forQuestionId:)`
returns nil for those ids because the questions don't exist in the
pack — so Daily Practice "Recently missed" and the chapter-detail
"Stuck here?" strip drop them silently. This migration moves the
content into the pack so every downstream surface picks it up.

Run from the repo root:

    # Dry-run — prints the JSON patch to stdout.
    python3 scripts/migrate_boss_quiz_to_pack.py

    # Apply — rewrites science_class7.json in place.
    python3 scripts/migrate_boss_quiz_to_pack.py --write

    # Force-overwrite existing bossQuestions arrays.
    python3 scripts/migrate_boss_quiz_to_pack.py --write --force

Idempotency: a second `--write` run against a freshly-migrated pack
produces byte-identical output. CI can assert this via
`git diff --quiet` after a re-run.

This script is a HISTORICAL ARTEFACT. After the migration commit
lands, it stays in the repo for the record but is never re-run on
a maintenance schedule.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Optional

REPO_ROOT = Path(__file__).resolve().parent.parent
DISCOVER_ROOT = REPO_ROOT / "desktopAhaan" / "Subjects" / "Tutor" / "Discover"
PACK_PATH = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs" / "science_class7.json"


# ─── Per-MCQ Question shape ────────────────────────────────────────────────

def make_question(chapter_number: int, item_index: int,
                  prompt: str, options: list[str],
                  answer: str, explanation: str) -> dict:
    """Build one migrated Question dict in the schema documented in
    the session brief (§4). Stable id format
    `bossquiz_chNN_qII` matches the SM-2 ephemeral ids the prior
    `recordEphemeralReview` call sites used."""
    return {
        "id": f"bossquiz_ch{chapter_number:02d}_q{item_index:02d}",
        "prompt": prompt,
        "questionType": "mcq",
        "options": options,
        "answer": answer,
        "solutionSteps": [explanation],
        "commonMistakes": [],
        "variations": [],
        "difficulty": 2,
        "pageRefs": [],
        "needsHumanReview": False,
        "source": "boss_quiz",
    }


# ─── Swift-source parser ───────────────────────────────────────────────────

# Filename → chapter number.
def chapter_number_from_path(path: Path) -> Optional[int]:
    name = path.name
    if name == "Scene9_BossQuiz.swift":
        return 1
    m = re.match(r"Scene9_BossQuiz_Ch(\d+)\.swift", name)
    if m:
        return int(m.group(1))
    return None


# Locate every Scene9 file under DISCOVER_ROOT.
def discover_scene9_files() -> list[Path]:
    found = []
    for path in DISCOVER_ROOT.rglob("Scene9_BossQuiz*.swift"):
        if path.is_file():
            found.append(path)
    return sorted(found)


# Parse a single Swift string literal — handles \" escapes.
# Starts at index `i` of `src` which MUST point at the opening quote.
# Returns (literal_value, index_after_closing_quote).
def parse_swift_string(src: str, i: int) -> tuple[str, int]:
    assert src[i] == '"', f"parse_swift_string: expected '\"' at {i}, got {src[i]!r}"
    i += 1  # skip opening quote
    out_chars: list[str] = []
    while i < len(src):
        ch = src[i]
        if ch == "\\":
            # Escape sequence: take the next char literally.
            if i + 1 >= len(src):
                raise ValueError(f"unterminated escape at {i}")
            nxt = src[i + 1]
            if nxt == "n":
                out_chars.append("\n")
            elif nxt == "t":
                out_chars.append("\t")
            elif nxt == '"':
                out_chars.append('"')
            elif nxt == "\\":
                out_chars.append("\\")
            else:
                # Pass through any other escape — we don't expect them
                # in authored MCQ text.
                out_chars.append(nxt)
            i += 2
        elif ch == '"':
            return "".join(out_chars), i + 1
        else:
            out_chars.append(ch)
            i += 1
    raise ValueError(f"unterminated string literal starting at {i}")


# Parse a Swift array literal of strings: `["a", "b", "c"]`.
# Starts at the opening `[`. Returns (list_of_strings, index_after_closing_]).
def parse_swift_string_array(src: str, i: int) -> tuple[list[str], int]:
    assert src[i] == "[", f"parse_swift_string_array: expected '[' at {i}, got {src[i]!r}"
    i += 1  # skip [
    items: list[str] = []
    while i < len(src):
        # Skip whitespace + commas.
        while i < len(src) and src[i] in " \t\n,":
            i += 1
        if i >= len(src):
            raise ValueError(f"unterminated array literal")
        if src[i] == "]":
            return items, i + 1
        if src[i] == '"':
            value, i = parse_swift_string(src, i)
            items.append(value)
            continue
        raise ValueError(f"unexpected char {src[i]!r} in array literal at {i}")
    raise ValueError("unterminated array literal")


# Find each MCQ item inside the array literal. The shapes we handle:
#   - Ch1QuizItem(prompt: "...", options: [...], answer: "...", explanation: "...")
#   - Q(prompt: "...", options: [...], answer: "...", explain: "...")
#   - QuizItem(prompt: ..., ...)
# Field order may vary; we look up fields by NAME, not by position.

# Pattern matches the opening of one constructor: e.g. `Ch1QuizItem(`,
# `Q(`, `QuizItem(`, with optional whitespace. The TYPE_NAME group
# captures the constructor name so we can validate it looks plausible.
_CONSTRUCTOR_RE = re.compile(
    r"\b(?P<TypeName>(?:Ch\d+)?(?:Quiz)?(?:Item|Q))\s*\("
)

_FIELD_RE = re.compile(r"\b(?P<field>prompt|options|answer|explanation|explain)\s*:\s*")


def parse_mcq_items(src: str, array_inner_start: int,
                    array_inner_end: int) -> list[dict]:
    """Walk the body of an MCQ array literal — between the opening
    `[` and matching `]` of the array — and pull out each constructor
    call's prompt / options / answer / explanation/explain.

    Returns a list of dicts: `{"prompt": str, "options": [str],
    "answer": str, "explanation": str}`.
    """
    items: list[dict] = []
    i = array_inner_start
    while i < array_inner_end:
        # Find the next constructor call.
        m = _CONSTRUCTOR_RE.search(src, i, array_inner_end)
        if not m:
            return items
        # Walk forward from the `(` after the constructor name,
        # tracking paren depth so we don't conflate a nested call's
        # closing paren with this constructor's.
        ctor_open = m.end() - 1  # position of `(`
        depth = 1
        scan = ctor_open + 1
        fields: dict[str, object] = {}
        while scan < array_inner_end:
            ch = src[scan]
            if ch == "(":
                depth += 1
                scan += 1
                continue
            if ch == ")":
                depth -= 1
                if depth == 0:
                    break
                scan += 1
                continue
            if ch == '"':
                # Skip past string literal — defensive against an
                # accidental field-name-shaped sequence inside a
                # value.
                _, scan = parse_swift_string(src, scan)
                continue
            if ch == "[":
                _, scan = parse_swift_string_array(src, scan)
                continue
            # Try matching a field assignment at this position.
            field_match = _FIELD_RE.match(src, scan)
            if field_match:
                name = field_match.group("field")
                after = field_match.end()
                # Skip whitespace after `:`.
                while after < array_inner_end and src[after] in " \t\n":
                    after += 1
                if after >= array_inner_end:
                    raise ValueError(f"unterminated field value at {scan}")
                if src[after] == '"':
                    value, scan = parse_swift_string(src, after)
                    fields[name] = value
                elif src[after] == "[":
                    value, scan = parse_swift_string_array(src, after)
                    fields[name] = value
                else:
                    # Not a string / array — skip this token. The
                    # constructor may have an int field we don't care
                    # about; tolerant default.
                    scan = after + 1
                continue
            scan += 1
        i = scan + 1

        # Normalise the explain → explanation alias.
        if "explanation" not in fields and "explain" in fields:
            fields["explanation"] = fields["explain"]

        # Validate the required fields are present.
        required = {"prompt", "options", "answer", "explanation"}
        missing = required - fields.keys()
        if missing:
            raise ValueError(
                f"item near offset {ctor_open}: missing fields {sorted(missing)}, "
                f"found {sorted(fields.keys())}"
            )
        items.append({
            "prompt": fields["prompt"],
            "options": fields["options"],
            "answer": fields["answer"],
            "explanation": fields["explanation"],
        })
    return items


# Find the MCQ array literal in a Scene9 file. Two shapes:
#   Shape 1 — stored property:   `let quiz: [Ch1QuizItem] = [ ... ]`
#   Shape 2 — computed property: `var quiz: [Ch3QuizItem] { [ ... ] }`
# Both end with us pointing one past an opening `[` whose matching
# `]` closes the MCQ array.

_ARRAY_DECL_LET_RE = re.compile(
    r"(?:(?:private|static|fileprivate|public|internal)\s+)*"
    r"let\s+\w+\s*:\s*\[\s*(?P<TypeName>(?:Ch\d+)?(?:Quiz)?(?:Item|Q))\s*\]\s*=\s*\["
)
_ARRAY_DECL_VAR_RE = re.compile(
    r"(?:(?:private|static|fileprivate|public|internal)\s+)*"
    r"var\s+\w+\s*:\s*\[\s*(?P<TypeName>(?:Ch\d+)?(?:Quiz)?(?:Item|Q))\s*\]\s*\{\s*\["
)


def find_mcq_array(src: str) -> Optional[tuple[int, int, str]]:
    """Find the boss-quiz MCQ array declaration. Returns
    (inner_start, inner_end, type_name) or None if not found."""
    match = _ARRAY_DECL_LET_RE.search(src) or _ARRAY_DECL_VAR_RE.search(src)
    if not match:
        return None
    array_inner_start = match.end() - 1 + 1  # one past the opening `[`
    # Walk forward to find the matching `]`, tracking nested brackets.
    depth = 1
    scan = array_inner_start
    while scan < len(src):
        ch = src[scan]
        if ch == "[":
            depth += 1
        elif ch == "]":
            depth -= 1
            if depth == 0:
                return (array_inner_start, scan, match.group("TypeName"))
        elif ch == '"':
            # Don't let a `[` inside a string fool the depth counter.
            _, scan = parse_swift_string(src, scan)
            continue
        scan += 1
    return None


def parse_scene9_file(path: Path) -> Optional[tuple[int, list[dict]]]:
    """Returns (chapter_number, [items]) for one Scene9 file.
    None if the file has no recognisable MCQ array (which means we
    need to stop-and-ask)."""
    chapter = chapter_number_from_path(path)
    if chapter is None:
        return None
    src = path.read_text(encoding="utf-8")
    located = find_mcq_array(src)
    if located is None:
        return None
    inner_start, inner_end, _ = located
    items = parse_mcq_items(src, inner_start, inner_end)
    return (chapter, items)


# ─── Driver ────────────────────────────────────────────────────────────────


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Migrate Boss Quiz MCQs from Swift literals into the pack JSON."
    )
    parser.add_argument("--write", action="store_true",
                        help="Apply the patch to science_class7.json. Default is dry-run.")
    parser.add_argument("--force", action="store_true",
                        help="Overwrite existing bossQuestions arrays.")
    args = parser.parse_args()

    scene9_files = discover_scene9_files()
    if len(scene9_files) != 19:
        print(f"WARN: found {len(scene9_files)} Scene9 files; expected 19.",
              file=sys.stderr)

    # Build per-chapter migrated content.
    by_chapter: dict[int, list[dict]] = {}
    for path in scene9_files:
        result = parse_scene9_file(path)
        if result is None:
            print(f"SKIP: could not parse {path.relative_to(REPO_ROOT)}",
                  file=sys.stderr)
            continue
        chapter, items = result
        questions = [
            make_question(chapter, idx,
                          item["prompt"], item["options"],
                          item["answer"], item["explanation"])
            for idx, item in enumerate(items)
        ]
        by_chapter[chapter] = questions
        print(f"OK   ch{chapter:02d}: {len(questions)} items "
              f"({path.relative_to(REPO_ROOT)})", file=sys.stderr)

    if not args.write:
        # Dry-run: pretty-print the patch to stdout.
        json.dump(
            {f"ch{n:02d}": qs for n, qs in sorted(by_chapter.items())},
            sys.stdout, indent=2, ensure_ascii=False,
        )
        sys.stdout.write("\n")
        return 0

    # --write: load pack, splice bossQuestions per chapter, save back.
    with PACK_PATH.open("r", encoding="utf-8") as f:
        pack = json.load(f)

    written = 0
    skipped = 0
    for chapter_obj in pack.get("chapters", []):
        n = chapter_obj.get("number")
        if n not in by_chapter:
            continue
        if "bossQuestions" in chapter_obj and chapter_obj["bossQuestions"]:
            if not args.force:
                print(f"SKIP ch{n:02d}: bossQuestions already present "
                      f"({len(chapter_obj['bossQuestions'])} items). "
                      f"Use --force to overwrite.",
                      file=sys.stderr)
                skipped += 1
                continue
        chapter_obj["bossQuestions"] = by_chapter[n]
        written += 1

    # Preserve trailing newline + 2-space indent matches the existing
    # human-edited style.
    with PACK_PATH.open("w", encoding="utf-8") as f:
        json.dump(pack, f, indent=2, ensure_ascii=False)
        f.write("\n")

    print(f"\nWrote bossQuestions for {written} chapter(s); "
          f"skipped {skipped}.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
