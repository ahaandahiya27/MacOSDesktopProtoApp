#!/usr/bin/env python3
"""
namespace_maths_concept_ids.py — one-shot fix for the cross-pack concept-id
collision introduced when the Maths pack landed (2026-05-27, in parallel
with the Science quick-check work).

The architectural contract (documented in
ChapterContentTests.testNoCrossPackConceptIdCollision) is:

  * Concept IDs MUST be globally unique across all packs — Bookmarks and
    DataStore.discoverProgress key on the bare concept id and the registry
    surfaces them flat (e.g. CommandPalette deep-link).
  * Question IDs are ALLOWED to collide — every nav route + storage key
    carries packId explicitly, so question ids are pack-scoped in practice.

The Maths pack reused Science's `chNN_tNN_cNN` concept-id scheme, producing
73 maths↔science concept-id collisions (the guard test never loaded maths,
so it stayed green). This prefixes every Maths concept id with `m`
(`ch01_t01_c01` → `mch01_t01_c01`), matching the `mch…` article-key
convention the Maths session already adopted, and remaps every in-pack
reference (relatedConceptIds, conceptMap node ids of kind concept, and
conceptMap edge from/to endpoints that point at a concept node).

Question ids, topic ids, chapter ids, conceptMap pivot-node ids, and edge
ids are deliberately left untouched — only concept ids carry the global
uniqueness contract.

Run from the repo root:

    # Dry-run — prints a summary of what would change.
    python3 scripts/namespace_maths_concept_ids.py

    # Apply — rewrites maths_class7.json in place.
    python3 scripts/namespace_maths_concept_ids.py --write

Idempotent: a second run is a no-op (ids already starting with `mch` are
skipped). CI can assert this via `git diff --quiet` after a re-run.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PACK_PATH = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs" / "maths_class7.json"

PREFIX = "m"  # ch01_t01_c01 -> mch01_t01_c01


def collect_concept_ids(pack: dict) -> set[str]:
    ids: set[str] = set()
    for chapter in pack.get("chapters", []):
        for topic in chapter.get("topics", []):
            for concept in topic.get("concepts", []):
                ids.add(concept["id"])
    return ids


def remap_value(value: str, mapping: dict[str, str]) -> str:
    return mapping.get(value, value)


def remap_in_place(obj, mapping: dict[str, str]) -> int:
    """Recursively replace any string value that is exactly an old concept id.
    Returns the number of replacements made."""
    count = 0
    if isinstance(obj, dict):
        for k, v in obj.items():
            if isinstance(v, str):
                if v in mapping:
                    obj[k] = mapping[v]
                    count += 1
            else:
                count += remap_in_place(v, mapping)
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            if isinstance(v, str):
                if v in mapping:
                    obj[i] = mapping[v]
                    count += 1
            else:
                count += remap_in_place(v, mapping)
    return count


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true",
                        help="apply the re-key to maths_class7.json in place")
    args = parser.parse_args()

    with PACK_PATH.open("r", encoding="utf-8") as f:
        pack = json.load(f)

    concept_ids = collect_concept_ids(pack)
    # Only ids not already namespaced get a mapping (idempotency guard).
    mapping = {cid: PREFIX + cid for cid in concept_ids
               if not cid.startswith("mch")}

    print(f"Maths concept ids: {len(concept_ids)} "
          f"({len(mapping)} need namespacing, "
          f"{len(concept_ids) - len(mapping)} already prefixed)",
          file=sys.stderr)

    if not mapping:
        print("Nothing to do — all concept ids already namespaced.",
              file=sys.stderr)
        return 0

    replacements = remap_in_place(pack, mapping)
    print(f"Replaced {replacements} value-site(s) across the pack.",
          file=sys.stderr)

    if not args.write:
        sample = list(mapping.items())[:5]
        print("Dry-run. Sample mapping:", file=sys.stderr)
        for old, new in sample:
            print(f"  {old} -> {new}", file=sys.stderr)
        print("Re-run with --write to apply.", file=sys.stderr)
        return 0

    with PACK_PATH.open("w", encoding="utf-8") as f:
        json.dump(pack, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(f"Wrote {PACK_PATH.name}.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
