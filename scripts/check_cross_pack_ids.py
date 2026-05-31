#!/usr/bin/env python3
"""check_cross_pack_ids.py — locks Bug-Free-Cert categories D.2 + D.3.

D.2  No duplicate concept id WITHIN a single pack.
D.3  No concept id collides ACROSS packs (Science ch*, Maths mch*,
     Sanskrit sch*/sk_*). Concept ids must be globally unique because
     Bookmarks + DataStore.discoverProgress key on the bare id and the
     registry surfaces them flat (see CLAUDE.md "Cross-subject pack ID
     prefix"). Cross-pack *question*-id collisions are intentionally
     ALLOWED (nav routes + QuestionReview.packId disambiguate), so this
     lint only guards concept ids.

This duplicates ChapterContentTests.testNoCrossPackConceptIdCollision at
commit time so a stray pack edit can't land a collision before the Swift
test runs. Pure-JSON; no Xcode build needed.

Usage:
    python3 scripts/check_cross_pack_ids.py            # audit real packs
    python3 scripts/check_cross_pack_ids.py --selftest # built-in fixtures

Exit 0 = clean, 1 = violation.
"""
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PACK_DIR = os.path.join(REPO, "desktopAhaan", "Subjects", "Packs")
PACKS = ["science_class7", "maths_class7", "sanskrit_class7", "socialscience_class7"]


def concept_ids(pack):
    """Yield (concept_id) for every concept in a decoded pack dict."""
    for ch in pack.get("chapters", []):
        for t in ch.get("topics", []):
            for c in t.get("concepts", []):
                cid = c.get("id")
                if cid is not None:
                    yield cid


def audit(packs_by_name):
    """packs_by_name: {name: decoded_dict}. Returns list of error strings."""
    errors = []
    global_owner = {}  # concept_id -> pack_name that first claimed it
    for name, pack in packs_by_name.items():
        seen_in_pack = set()
        for cid in concept_ids(pack):
            # D.2 — within-pack duplicate
            if cid in seen_in_pack:
                errors.append(f"D.2 duplicate concept id within {name}: {cid}")
            seen_in_pack.add(cid)
        # D.3 — cross-pack collision (compare distinct ids per pack)
        for cid in seen_in_pack:
            if cid in global_owner:
                errors.append(
                    f"D.3 cross-pack concept id collision: {cid} "
                    f"in both {global_owner[cid]} and {name}"
                )
            else:
                global_owner[cid] = name
    return errors


def load_real_packs():
    out = {}
    for name in PACKS:
        path = os.path.join(PACK_DIR, f"{name}.json")
        with open(path, encoding="utf-8") as fh:
            out[name] = json.load(fh)
    return out


def selftest():
    ok = True
    # clean fixture
    clean = {
        "a": {"chapters": [{"topics": [{"concepts": [{"id": "ch01_t01_c01"}]}]}]},
        "b": {"chapters": [{"topics": [{"concepts": [{"id": "mch01_t01_c01"}]}]}]},
    }
    if audit(clean):
        print("SELFTEST FAIL: clean fixture flagged"); ok = False
    # dup within pack
    dup = {"a": {"chapters": [{"topics": [{"concepts": [
        {"id": "ch01_t01_c01"}, {"id": "ch01_t01_c01"}]}]}]}}
    if not any("D.2" in e for e in audit(dup)):
        print("SELFTEST FAIL: within-pack dup not caught"); ok = False
    # cross-pack collision
    coll = {
        "a": {"chapters": [{"topics": [{"concepts": [{"id": "ch01_t01_c01"}]}]}]},
        "b": {"chapters": [{"topics": [{"concepts": [{"id": "ch01_t01_c01"}]}]}]},
    }
    if not any("D.3" in e for e in audit(coll)):
        print("SELFTEST FAIL: cross-pack collision not caught"); ok = False
    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        return selftest()
    errors = audit(load_real_packs())
    if errors:
        print("check_cross_pack_ids: FAIL")
        for e in errors[:50]:
            print("  " + e)
        if len(errors) > 50:
            print(f"  ... and {len(errors) - 50} more")
        return 1
    print("check_cross_pack_ids: clean — concept ids unique within and across all packs (D.2, D.3)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
