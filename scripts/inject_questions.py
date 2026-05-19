#!/usr/bin/env python3
"""Safely inject new questions into science_class7.json.

Reads a deltas dict {chapter_number: {topic_id: [question, ...]}} and:
  1. Validates every new question id is unique within the pack.
  2. Validates each question has the required schema fields.
  3. Appends the new questions to their matching topic (order preserved).
  4. Writes the pack back atomically with ensure_ascii=False, indent=2 to
     match the pack's existing JSON style (verify_pack_roundtrip.py is the
     authority on style; it must report `ok` after this script runs).

Usage:
    python3 scripts/inject_questions.py /path/to/deltas.json [--dry-run]
"""
import argparse
import json
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
PACK = REPO / "desktopAhaan/Subjects/Packs/science_class7.json"

REQUIRED = {
    "id", "prompt", "questionType", "answer", "solutionSteps",
    "commonMistakes", "variations", "difficulty", "pageRefs",
    "needsHumanReview",
}
VALID_TYPES = {
    "mcq", "shortAnswer", "longAnswer", "numerical",
    "trueFalse", "matchTheFollowing", "fillInBlank",
}


def validate(q, existing_ids):
    missing = REQUIRED - set(q.keys())
    if missing:
        return f"missing fields: {sorted(missing)}"
    if q["id"] in existing_ids:
        return f"duplicate id: {q['id']}"
    if q["questionType"] not in VALID_TYPES:
        return f"invalid questionType: {q['questionType']}"
    if q["questionType"] == "mcq":
        if not q.get("options"):
            return "mcq requires options"
        if q["answer"] not in q["options"]:
            return f"mcq answer '{q['answer']}' not in options"
    if not isinstance(q["difficulty"], int) or not (1 <= q["difficulty"] <= 5):
        return f"difficulty must be int 1..5, got {q['difficulty']}"
    if q["difficulty"] >= 3 and not q.get("solutionSteps"):
        return "difficulty>=3 requires non-empty solutionSteps"
    if not q.get("variations") or len(q["variations"]) < 2:
        return "every authored question must ship >=2 variations"
    if not q.get("commonMistakes"):
        return "every authored question must ship >=1 commonMistake"
    return None


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("deltas_file", help="JSON file with the new-question deltas")
    ap.add_argument("--dry-run", action="store_true",
                    help="validate only; don't write the pack")
    args = ap.parse_args()

    deltas = json.loads(Path(args.deltas_file).read_text())
    pack = json.loads(PACK.read_text())

    existing_ids = set()
    topic_map = {}
    for ch in pack["chapters"]:
        for t in ch["topics"]:
            topic_map[t["id"]] = t
            for q in t.get("questions", []):
                existing_ids.add(q["id"])

    new_count = 0
    for ch_key, topics in deltas.items():
        for topic_id, qs in topics.items():
            if topic_id not in topic_map:
                print(f"ERROR: unknown topic_id '{topic_id}'", file=sys.stderr)
                return 2
            for q in qs:
                err = validate(q, existing_ids)
                if err:
                    print(f"ERROR: {topic_id} · {q.get('id','?')}: {err}", file=sys.stderr)
                    return 2
                existing_ids.add(q["id"])
                topic_map[topic_id].setdefault("questions", []).append(q)
                new_count += 1

    if args.dry_run:
        print(f"dry-run ok — {new_count} new question(s) would be injected.")
        return 0

    PACK.write_text(json.dumps(pack, ensure_ascii=False, indent=2) + "\n")
    print(f"injected {new_count} new question(s) into {PACK}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
