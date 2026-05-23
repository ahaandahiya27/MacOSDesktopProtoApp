#!/usr/bin/env python3
"""merge-content-draft.py — apply an augmentation JSON to science_class7.json.

Given a draft like `scripts/content_drafts/chNN_augment.json`, this
script:
  1. Loads the pack at desktopAhaan/Subjects/Packs/science_class7.json.
  2. Locates the chapter by `_meta.chapter_id`.
  3. Adds each top-level array / object key from the draft onto that
     chapter dict. Existing arrays MERGE by id (additive, never
     destructive); new keys are inserted whole.
  4. Re-encodes the pack with sorted keys = False and indent = 2 to
     preserve the existing on-disk format.

Idempotent: re-running with the same draft produces the same pack.
Items keyed by `id` already in the pack are skipped (so a re-run
doesn't duplicate them).

Usage:
    python3 scripts/merge-content-draft.py scripts/content_drafts/ch01_augment.json
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PACK_PATH = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs" / "science_class7.json"

# Top-level keys on a chapter dict that the merger knows about. Anything
# else in the draft is added verbatim (so future schema additions don't
# need a code change).
LIST_KEYS = {
    "realWorldExamples", "examConnections", "mnemonics", "misconceptions",
    "ncertQA", "glossary", "miniProjects", "scientists", "whatIfs",
    "crossChapterRefs", "gallery", "timelines",
}
SINGLE_KEYS = {"curriculumBridge"}


def _merge_list_by_id(existing: list, new_items: list, key: str) -> tuple[list, int]:
    """Return (merged_list, items_added). Items in `new_items` whose
    `id` already appears in `existing` are skipped (idempotent)."""
    existing_ids = {item.get("id") for item in existing if isinstance(item, dict)}
    added = 0
    merged = list(existing)
    for item in new_items:
        if not isinstance(item, dict):
            print(f"  warning: skipping non-dict item under '{key}': {item!r}",
                  file=sys.stderr)
            continue
        if item.get("id") in existing_ids:
            continue
        merged.append(item)
        added += 1
    return merged, added


def main(draft_path: str) -> int:
    draft_file = Path(draft_path)
    if not draft_file.is_absolute():
        draft_file = REPO_ROOT / draft_file
    if not draft_file.exists():
        print(f"merge-content-draft: draft not found at {draft_file}",
              file=sys.stderr)
        return 2

    with draft_file.open() as f:
        draft = json.load(f)
    meta = draft.get("_meta", {})
    chapter_id = meta.get("chapter_id")
    if not chapter_id:
        print("merge-content-draft: draft missing _meta.chapter_id",
              file=sys.stderr)
        return 2

    with PACK_PATH.open() as f:
        pack = json.load(f)

    chapter = None
    for c in pack.get("chapters", []):
        if c.get("id") == chapter_id:
            chapter = c
            break
    if chapter is None:
        print(f"merge-content-draft: chapter {chapter_id} not found in pack",
              file=sys.stderr)
        return 2

    print(f"merging draft for {chapter_id} ({chapter.get('title', '?')}):")
    total_added = 0
    for key, value in draft.items():
        if key.startswith("_"):
            continue
        if key in LIST_KEYS:
            existing = chapter.get(key, []) or []
            merged, added = _merge_list_by_id(existing, value or [], key)
            chapter[key] = merged
            print(f"  {key}: {len(existing)} → {len(merged)} (+{added})")
            total_added += added
        elif key in SINGLE_KEYS:
            if key in chapter:
                print(f"  {key}: already present; leaving existing value")
            else:
                chapter[key] = value
                print(f"  {key}: added")
                total_added += 1
        else:
            # Future-proofing: unknown key, add verbatim.
            if key not in chapter:
                chapter[key] = value
                print(f"  {key}: added (unknown key — added verbatim)")
                total_added += 1
            else:
                print(f"  {key}: already present (skipped)")

    PACK_PATH.write_text(json.dumps(pack, indent=2, ensure_ascii=False) + "\n")
    print(f"merged {total_added} new item(s) into {chapter_id}.")
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 scripts/merge-content-draft.py <draft.json>",
              file=sys.stderr)
        sys.exit(2)
    sys.exit(main(sys.argv[1]))
