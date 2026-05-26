#!/usr/bin/env python3
"""
migrate_quick_checks_to_pack.py — one-shot migration of inline
scene quick-check MCQs from `DiscoverChapterNView.swift` dispatcher
files (and their `+InlineScenesB` sister files where present) into
`science_class7.json`'s `chapters[].quickCheckQuestions` arrays.

Background:
The 2026-05-25 Boss Quiz migration moved 19 chapter-completion MCQs
into `chapter.bossQuestions`. The same surfaces (DailyPractice
"Recently missed", MasteryDashboard, ChapterStuckHereStrip) want to
include the chapter's mid-scene quick-checks too — the MCQs inside
scenes like `CycloneSurvivalQuizScene` in Ch.8's dispatcher. Those
literals never reach the SRS scheduler today: the inline scene just
tracks local `picks` state and discards wrong answers on close.

This migration moves the content into the pack so each scene can
read from `chapter.quickCheckQuestionsList` and route answers
through `DataStore.shared.recordReview` with a stable id. After
migration, every miss surfaces in Daily Practice on next launch.

What we DO migrate:
  - `private struct Q { id, prompt, opts: [String], correct: Int }`
    style constructors with `Q(id: "qN", prompt: "...", opts: [...],
    correct: N)`. Field order may vary — we look up by name.

What we DO NOT migrate (heterogeneous shapes — not MCQs):
  - Sorting / classification tasks (e.g. `correctCotton: Bool`)
  - Emoji/name/detail match cards (e.g. Ch.1 SpecialPlants)
  - Anything without an `opts:` array of strings

The script SKIPS files that contain `Q(id: ...)` calls but no
`opts:` field — those are different surfaces and stay inline.

Run from the repo root:

    # Dry-run — prints the JSON patch to stdout.
    python3 scripts/migrate_quick_checks_to_pack.py

    # Apply — rewrites science_class7.json in place.
    python3 scripts/migrate_quick_checks_to_pack.py --write

    # Force-overwrite existing quickCheckQuestions arrays.
    python3 scripts/migrate_quick_checks_to_pack.py --write --force

Idempotency: a second `--write` run produces byte-identical output.

Historical artefact — this script is committed for the record but
not part of any maintenance cron.
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
                  correct_index: int) -> dict:
    """Build one migrated Question dict. Id format
    `scenecheck_chNN_qII` matches the prefix already whitelisted in
    `DataStore.ephemeralIdPrefixes`. solutionSteps is empty because
    the inline Q struct has no explanation field — the dispatcher
    scenes never showed one. Future authoring can fill it in JSON."""
    if not (0 <= correct_index < len(options)):
        raise ValueError(
            f"correct index {correct_index} out of range for "
            f"options of length {len(options)}: {options!r}"
        )
    return {
        "id": f"scenecheck_ch{chapter_number:02d}_q{item_index:02d}",
        "prompt": prompt,
        "questionType": "mcq",
        "options": options,
        "answer": options[correct_index],
        "solutionSteps": [],
        "commonMistakes": [],
        "variations": [],
        "difficulty": 1,
        "pageRefs": [],
        "needsHumanReview": False,
        "source": "scene_quick_check",
    }


# ─── Swift-source parser ───────────────────────────────────────────────────

# Parse a single Swift string literal — handles \" escapes.
def parse_swift_string(src: str, i: int) -> tuple[str, int]:
    assert src[i] == '"', f"parse_swift_string: expected '\"' at {i}, got {src[i]!r}"
    i += 1
    out: list[str] = []
    while i < len(src):
        ch = src[i]
        if ch == "\\":
            if i + 1 >= len(src):
                raise ValueError(f"unterminated escape at {i}")
            nxt = src[i + 1]
            out.append({"n": "\n", "t": "\t", '"': '"', "\\": "\\"}.get(nxt, nxt))
            i += 2
        elif ch == '"':
            return "".join(out), i + 1
        else:
            out.append(ch)
            i += 1
    raise ValueError(f"unterminated string literal starting at {i}")


def parse_swift_string_array(src: str, i: int) -> tuple[list[str], int]:
    assert src[i] == "[", f"parse_swift_string_array: expected '[' at {i}, got {src[i]!r}"
    i += 1
    items: list[str] = []
    while i < len(src):
        while i < len(src) and src[i] in " \t\n,":
            i += 1
        if i >= len(src):
            raise ValueError("unterminated array literal")
        if src[i] == "]":
            return items, i + 1
        if src[i] == '"':
            v, i = parse_swift_string(src, i)
            items.append(v)
            continue
        raise ValueError(f"unexpected char {src[i]!r} in array literal at {i}")
    raise ValueError("unterminated array literal")


# Skip past a Swift integer literal at position `i`. Returns
# (value, index_after).
def parse_swift_int(src: str, i: int) -> tuple[int, int]:
    j = i
    if j < len(src) and src[j] in "+-":
        j += 1
    while j < len(src) and src[j].isdigit():
        j += 1
    if j == i:
        raise ValueError(f"expected int at {i}, got {src[i]!r}")
    return int(src[i:j]), j


# Find every `Q(id:"...", prompt:"...", opts:[...], correct: N)`
# constructor in the file. Field order tolerant; require all of
# {prompt, opts, correct}. The `id:` argument inside the Swift Q is
# the ForEach Identifiable shim — we don't reuse it for the SM-2 id
# because it's only locally unique within the scene.
_CONSTRUCTOR_RE = re.compile(r"\bQ\s*\(")

_FIELD_RE = re.compile(
    r"\b(?P<field>id|prompt|opts|options|correct|symbol|emoji|name|detail)\s*:\s*"
)


def parse_q_items(src: str) -> list[dict]:
    """Walk the entire file source for `Q(...)` constructors that
    have a `prompt:` string and an `opts:` array (or `options:`).
    Skips any Q-shape that doesn't carry those two fields — they're
    sort/classify tasks, not MCQs.

    Returns items in file-order.
    """
    items: list[dict] = []
    i = 0
    while i < len(src):
        m = _CONSTRUCTOR_RE.search(src, i)
        if not m:
            break
        ctor_open = m.end() - 1
        # Skip over decls like `let qs: [Q] = [...]` or `Q.self` —
        # the next char after `Q(` is our anchor; ctor_open IS the
        # `(`. Step into the body.
        depth = 1
        scan = ctor_open + 1
        fields: dict[str, object] = {}
        while scan < len(src):
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
                _, scan = parse_swift_string(src, scan)
                continue
            if ch == "[":
                _, scan = parse_swift_string_array(src, scan)
                continue
            fm = _FIELD_RE.match(src, scan)
            if fm:
                name = fm.group("field")
                after = fm.end()
                while after < len(src) and src[after] in " \t\n":
                    after += 1
                if after >= len(src):
                    raise ValueError(f"unterminated field value at {scan}")
                ch2 = src[after]
                if ch2 == '"':
                    v, scan = parse_swift_string(src, after)
                    fields[name] = v
                elif ch2 == "[":
                    v, scan = parse_swift_string_array(src, after)
                    fields[name] = v
                elif ch2 in "0123456789+-":
                    v, scan = parse_swift_int(src, after)
                    fields[name] = v
                else:
                    # Unknown literal kind — advance past the colon and
                    # continue. Don't fail: other tolerated field shapes
                    # (Bool true/false, an enum) come up in non-MCQ Q
                    # constructors we DON'T want to migrate.
                    scan = after + 1
                continue
            scan += 1
        i = scan + 1

        # Decide whether this Q is an MCQ we want to migrate.
        prompt = fields.get("prompt")
        opts = fields.get("opts") if "opts" in fields else fields.get("options")
        correct = fields.get("correct")
        if not isinstance(prompt, str):
            continue
        if not isinstance(opts, list) or not all(isinstance(x, str) for x in opts):
            continue
        if not isinstance(correct, int):
            continue
        items.append({
            "prompt": prompt,
            "options": opts,
            "correct": correct,
        })
    return items


# ─── File discovery ────────────────────────────────────────────────────────

def chapter_number_from_path(path: Path) -> Optional[int]:
    """Recover chapter number from a dispatcher path.

    Layouts:
      - desktopAhaan/Subjects/Tutor/Discover/Chapter{N}/DiscoverChapter{N}View.swift
      - desktopAhaan/Subjects/Tutor/Discover/Chapter{N}/DiscoverChapter{N}View+InlineScenesB.swift
      - desktopAhaan/Subjects/Tutor/Discover/DiscoverChapter1View+InlineScenes.swift  (Ch.1 only)
      - desktopAhaan/Subjects/Tutor/Discover/DiscoverChapter1View.swift
    """
    parts = path.parts
    for p in parts:
        m = re.fullmatch(r"Chapter(\d+)", p)
        if m:
            return int(m.group(1))
    m = re.match(r"DiscoverChapter(\d+)View", path.name)
    if m:
        return int(m.group(1))
    return None


def discover_dispatcher_files() -> list[Path]:
    """Every file that might contain a dispatcher-inline Q literal:
    the 19 main DiscoverChapter{N}View.swift dispatchers (Ch.1
    lives at the Discover root, Ch.2..19 inside Chapter{N}/), plus
    any `+InlineScenesB` / `+InlineScenes` sister files. Scene*.swift
    files under Chapter{N}/Scenes/ are NOT dispatchers and don't
    carry MCQ Q literals — exclude them."""
    found: list[Path] = []
    for path in DISCOVER_ROOT.rglob("DiscoverChapter*.swift"):
        if not path.is_file():
            continue
        # Exclude any file inside a Scenes/ folder (defensive — none
        # match the glob today, but keep the script future-proof).
        if "Scenes" in path.parts:
            continue
        found.append(path)
    return sorted(found, key=lambda p: (chapter_number_from_path(p) or 999, p.name))


# ─── Driver ────────────────────────────────────────────────────────────────

def main() -> int:
    parser = argparse.ArgumentParser(
        description="Migrate dispatcher quick-check MCQs from Swift literals into the pack JSON."
    )
    parser.add_argument("--write", action="store_true",
                        help="Apply the patch to science_class7.json. Default is dry-run.")
    parser.add_argument("--force", action="store_true",
                        help="Overwrite existing quickCheckQuestions arrays.")
    args = parser.parse_args()

    files = discover_dispatcher_files()
    if not files:
        print("ERROR: found no dispatcher files under "
              f"{DISCOVER_ROOT}", file=sys.stderr)
        return 1

    # Group items by chapter, walking each file in declaration order.
    # Items inside Ch.13 (which has two MCQ scenes) come out in file
    # order, giving stable q00..q07 numbering.
    by_chapter: dict[int, list[dict]] = {}
    skipped: list[Path] = []
    for path in files:
        chapter = chapter_number_from_path(path)
        if chapter is None:
            print(f"SKIP: cannot derive chapter from path "
                  f"{path.relative_to(REPO_ROOT)}", file=sys.stderr)
            continue
        src = path.read_text(encoding="utf-8")
        items = parse_q_items(src)
        if not items:
            skipped.append(path)
            continue
        by_chapter.setdefault(chapter, []).extend(items)
        print(f"OK   ch{chapter:02d}: +{len(items)} items "
              f"({path.relative_to(REPO_ROOT)})", file=sys.stderr)

    for path in skipped:
        print(f"SKIP: no migratable MCQ Q in "
              f"{path.relative_to(REPO_ROOT)}", file=sys.stderr)

    # Build the per-chapter Question lists with stable ids.
    by_chapter_q: dict[int, list[dict]] = {}
    for chapter, items in sorted(by_chapter.items()):
        by_chapter_q[chapter] = [
            make_question(chapter, idx,
                          item["prompt"], item["options"], item["correct"])
            for idx, item in enumerate(items)
        ]

    if not args.write:
        json.dump(
            {f"ch{n:02d}": qs for n, qs in sorted(by_chapter_q.items())},
            sys.stdout, indent=2, ensure_ascii=False,
        )
        sys.stdout.write("\n")
        return 0

    with PACK_PATH.open("r", encoding="utf-8") as f:
        pack = json.load(f)

    written = 0
    skipped_existing = 0
    for chapter_obj in pack.get("chapters", []):
        n = chapter_obj.get("number")
        if n not in by_chapter_q:
            continue
        existing = chapter_obj.get("quickCheckQuestions")
        if existing:
            if not args.force:
                print(f"SKIP ch{n:02d}: quickCheckQuestions already "
                      f"present ({len(existing)} items). Use --force "
                      f"to overwrite.", file=sys.stderr)
                skipped_existing += 1
                continue
        chapter_obj["quickCheckQuestions"] = by_chapter_q[n]
        written += 1

    with PACK_PATH.open("w", encoding="utf-8") as f:
        json.dump(pack, f, indent=2, ensure_ascii=False)
        f.write("\n")

    print(f"\nWrote quickCheckQuestions for {written} chapter(s); "
          f"skipped {skipped_existing}.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
