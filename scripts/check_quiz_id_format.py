#!/usr/bin/env python3
"""check_quiz_id_format.py — locks Bug-Free-Cert category D.10.

Boss-quiz and scene-quick-check ids are globally resolved (they carry a
prefix that makes them collision-free across packs and lets
DataStore.ephemeralIdPrefixes / SubjectRegistry route a missed answer to
Daily Practice's Recently-Missed row). If an id drifts from the canonical
shape the review never resolves and the data goes orphan-but-silent.

Canonical format:
    bossquiz_<ns>NN_qII      e.g. bossquiz_ch01_q00
    scenecheck_<ns>NN_qII    e.g. scenecheck_ch15_q03
where <ns> is the pack namespace token (ch | mch | sch) and NN / II are
two-digit, zero-padded ordinals.

This walks every dict in every pack and validates any id beginning with a
known prefix, regardless of where it lives in the tree (chapter
bossQuestions, chapter quickCheckQuestions, etc.). Pure-JSON; no build.

Usage:
    python3 scripts/check_quiz_id_format.py
    python3 scripts/check_quiz_id_format.py --selftest

Exit 0 = clean, 1 = violation.
"""
import json
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PACK_DIR = os.path.join(REPO, "desktopAhaan", "Subjects", "Packs")
PACKS = ["science_class7", "maths_class7", "sanskrit_class7"]

PATTERNS = {
    "bossquiz_": re.compile(r"^bossquiz_(ch|mch|sch)\d{2}_q\d{2}$"),
    "scenecheck_": re.compile(r"^scenecheck_(ch|mch|sch)\d{2}_q\d{2}$"),
}


def walk_ids(obj):
    """Yield every string value stored under an 'id' key, anywhere."""
    if isinstance(obj, dict):
        v = obj.get("id")
        if isinstance(v, str):
            yield v
        for val in obj.values():
            yield from walk_ids(val)
    elif isinstance(obj, list):
        for item in obj:
            yield from walk_ids(item)


def audit(name, pack):
    errors = []
    for ident in walk_ids(pack):
        for prefix, pat in PATTERNS.items():
            if ident.startswith(prefix) and not pat.match(ident):
                errors.append(f"D.10 {name}: malformed id {ident!r} "
                              f"(expected {pat.pattern})")
    return errors


def load_real_packs():
    out = {}
    for name in PACKS:
        with open(os.path.join(PACK_DIR, f"{name}.json"), encoding="utf-8") as fh:
            out[name] = json.load(fh)
    return out


def selftest():
    ok = True
    good = {"chapters": [{"bossQuestions": [{"id": "bossquiz_ch01_q00"}],
                          "quickCheckQuestions": [{"id": "scenecheck_ch15_q03"}]}]}
    if audit("good", good):
        print("SELFTEST FAIL: good ids flagged:", audit("good", good)); ok = False
    bad = {"chapters": [{"bossQuestions": [{"id": "bossquiz_ch1_q0"}]}]}  # not zero-padded
    if not audit("bad", bad):
        print("SELFTEST FAIL: malformed boss id not caught"); ok = False
    bad2 = {"x": [{"id": "scenecheck_chapter01_q1"}]}
    if not audit("bad2", bad2):
        print("SELFTEST FAIL: malformed scenecheck id not caught"); ok = False
    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        return selftest()
    errors = []
    for name, pack in load_real_packs().items():
        errors += audit(name, pack)
    if errors:
        print("check_quiz_id_format: FAIL")
        for e in errors[:50]:
            print("  " + e)
        if len(errors) > 50:
            print(f"  ... and {len(errors) - 50} more")
        return 1
    print("check_quiz_id_format: clean — all bossquiz_/scenecheck_ ids canonical (D.10)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
