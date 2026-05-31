#!/usr/bin/env python3
"""check_orphan_refs.py — locks Bug-Free-Cert categories D.4 + D.5 + D.6.

D.4  Every concept.relatedConceptIds entry resolves to a concept id that
     exists in the SAME pack.
D.5  Every concept.relatedQuestionIds entry resolves to a question id that
     exists in the SAME pack.
D.6  Every conceptMap edge `from`/`to` resolves to a node id declared in
     the SAME chapter's conceptMap.nodes. (Node ids are NOT required to be
     concept ids — Maths conceptMaps legitimately carry synthetic "pivot"
     nodes like `ch01_pivot_placevalue`, so the safe invariant is internal
     edge<->node consistency, not node<->concept resolution.)

Orphan refs otherwise only surface at runtime as CrashReporter DATA
entries via SubjectPack.validateRelatedRefs(). This lint catches them at
commit time. Pure-JSON; no Xcode build needed.

Usage:
    python3 scripts/check_orphan_refs.py
    python3 scripts/check_orphan_refs.py --selftest

Exit 0 = clean, 1 = violation.
"""
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PACK_DIR = os.path.join(REPO, "desktopAhaan", "Subjects", "Packs")
PACKS = ["science_class7", "maths_class7", "sanskrit_class7", "socialscience_class7"]


def audit_pack(name, pack):
    errors = []
    concept_ids = set()
    question_ids = set()
    for ch in pack.get("chapters", []):
        for t in ch.get("topics", []):
            for c in t.get("concepts", []):
                if c.get("id") is not None:
                    concept_ids.add(c["id"])
            for q in t.get("questions", []):
                if q.get("id") is not None:
                    question_ids.add(q["id"])

    for ch in pack.get("chapters", []):
        for t in ch.get("topics", []):
            for c in t.get("concepts", []):
                cid = c.get("id", "<no-id>")
                for ref in c.get("relatedConceptIds", []) or []:
                    if ref not in concept_ids:
                        errors.append(
                            f"D.4 {name}: concept {cid} relatedConceptIds -> orphan {ref}")
                for ref in c.get("relatedQuestionIds", []) or []:
                    if ref not in question_ids:
                        errors.append(
                            f"D.5 {name}: concept {cid} relatedQuestionIds -> orphan {ref}")
        # D.6 conceptMap edge integrity (per chapter)
        cm = ch.get("conceptMap")
        if isinstance(cm, dict):
            node_ids = {n.get("id") for n in cm.get("nodes", []) if isinstance(n, dict)}
            for e in cm.get("edges", []) or []:
                if not isinstance(e, dict):
                    continue
                for end in ("from", "to"):
                    v = e.get(end)
                    if v is not None and v not in node_ids:
                        errors.append(
                            f"D.6 {name} ch={ch.get('id')}: conceptMap edge "
                            f"{e.get('id', '?')} {end}={v} not in nodes")
    return errors


def load_real_packs():
    out = {}
    for name in PACKS:
        with open(os.path.join(PACK_DIR, f"{name}.json"), encoding="utf-8") as fh:
            out[name] = json.load(fh)
    return out


def selftest():
    ok = True
    clean = {"chapters": [{
        "id": "ch01",
        "topics": [{"concepts": [
            {"id": "c1", "relatedConceptIds": ["c2"], "relatedQuestionIds": ["q1"]},
            {"id": "c2"}],
            "questions": [{"id": "q1"}]}],
        "conceptMap": {"nodes": [{"id": "n1"}, {"id": "n2"}],
                       "edges": [{"id": "e1", "from": "n1", "to": "n2"}]},
    }]}
    if audit_pack("clean", clean):
        print("SELFTEST FAIL: clean flagged:", audit_pack("clean", clean)); ok = False

    orphan_concept = {"chapters": [{"id": "ch01", "topics": [
        {"concepts": [{"id": "c1", "relatedConceptIds": ["MISSING"]}], "questions": []}]}]}
    if not any("D.4" in e for e in audit_pack("x", orphan_concept)):
        print("SELFTEST FAIL: orphan relatedConceptId not caught"); ok = False

    orphan_q = {"chapters": [{"id": "ch01", "topics": [
        {"concepts": [{"id": "c1", "relatedQuestionIds": ["MISSING"]}], "questions": []}]}]}
    if not any("D.5" in e for e in audit_pack("x", orphan_q)):
        print("SELFTEST FAIL: orphan relatedQuestionId not caught"); ok = False

    bad_edge = {"chapters": [{"id": "ch01", "topics": [],
        "conceptMap": {"nodes": [{"id": "n1"}],
                       "edges": [{"id": "e1", "from": "n1", "to": "GHOST"}]}}]}
    if not any("D.6" in e for e in audit_pack("x", bad_edge)):
        print("SELFTEST FAIL: dangling conceptMap edge not caught"); ok = False

    # pivot-node tolerance: synthetic node id that is not a concept id must NOT flag
    pivot = {"chapters": [{"id": "ch01", "topics": [],
        "conceptMap": {"nodes": [{"id": "mch01_t01_c01"}, {"id": "ch01_pivot_x"}],
                       "edges": [{"id": "e1", "from": "ch01_pivot_x", "to": "mch01_t01_c01"}]}}]}
    if audit_pack("x", pivot):
        print("SELFTEST FAIL: pivot-node edge wrongly flagged"); ok = False

    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        return selftest()
    errors = []
    for name, pack in load_real_packs().items():
        errors += audit_pack(name, pack)
    if errors:
        print("check_orphan_refs: FAIL")
        for e in errors[:50]:
            print("  " + e)
        if len(errors) > 50:
            print(f"  ... and {len(errors) - 50} more")
        return 1
    print("check_orphan_refs: clean — relatedConceptIds/relatedQuestionIds resolve; "
          "conceptMap edges resolve to nodes (D.4, D.5, D.6)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
