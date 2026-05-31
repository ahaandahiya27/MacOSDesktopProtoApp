#!/usr/bin/env python3
"""ss_build_pack.py — assemble socialscience_class7.json from fragments.

The Social Science subject is authored chapter-by-chapter across many
resumable build cycles. To keep each cycle's diff small and to avoid
hand-editing a single huge JSON file, each chapter lives in its own
fragment under `scripts/content_drafts/socialscience/sschNN.json`, and the
pack header lives in `_meta.json`. This script stitches them into the
canonical pack the app loads.

Canonical dump shape (matches verify_pack_roundtrip.py):
    json.dumps(obj, ensure_ascii=False, indent=2) + "\n"

Usage:
    python3 scripts/ss_build_pack.py            # build + write the pack
    python3 scripts/ss_build_pack.py --check    # build in memory, diff only
"""
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FRAG_DIR = os.path.join(REPO, "scripts", "content_drafts", "socialscience")
OUT = os.path.join(REPO, "desktopAhaan", "Subjects", "Packs",
                   "socialscience_class7.json")


def load(name):
    with open(os.path.join(FRAG_DIR, name), encoding="utf-8") as fh:
        return json.load(fh)


def build():
    meta = load("_meta.json")
    chapters = []
    for fn in sorted(os.listdir(FRAG_DIR)):
        if fn.startswith("ssch") and fn.endswith(".json"):
            chapters.append(load(fn))
    chapters.sort(key=lambda c: c["number"])
    pack = dict(meta)
    pack["chapters"] = chapters
    return pack


def canonical(obj):
    return json.dumps(obj, ensure_ascii=False, indent=2) + "\n"


def main():
    pack = build()
    text = canonical(pack)
    if "--check" in sys.argv:
        if os.path.exists(OUT):
            cur = open(OUT, encoding="utf-8").read()
            print("up-to-date" if cur == text else "DIFFERS from on-disk pack")
            return 0 if cur == text else 1
        print("pack not yet written")
        return 1
    with open(OUT, "w", encoding="utf-8") as fh:
        fh.write(text)
    n_ch = len(pack["chapters"])
    n_c = sum(len(t["concepts"]) for ch in pack["chapters"] for t in ch["topics"])
    n_q = sum(len(t["questions"]) for ch in pack["chapters"] for t in ch["topics"])
    print(f"wrote {OUT}: {n_ch} chapter(s), {n_c} concepts, {n_q} topic-questions")
    return 0


if __name__ == "__main__":
    sys.exit(main())
