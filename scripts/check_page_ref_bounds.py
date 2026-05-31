#!/usr/bin/env python3
"""check_page_ref_bounds.py — locks Bug-Free-Cert category D.7.

`pageRefs` arrays scattered through the content packs tell the UI which
NCERT textbook page(s) a concept / question maps to. The source PDF is
*not* bundled, so an absolute upper-bound against the real page count is
impossible — but a malformed entry (a negative page, a zero, a non-integer,
or an absurd typo like 99999) is still a content bug that would surface a
nonsense "see page …" hint to the kid.

This lint pins, tree-wide across all three packs, that every element of
every `pageRefs` list is an integer in `[1, CEILING]`. Empty `pageRefs`
lists are allowed and common (they mean "no specific page ref"); only the
*present* elements are validated. CEILING is set well above the largest
real NCERT Class-7 textbook (science tops out at 241) so legitimate
content never trips it, while gross typos still do.

Until now D.7 was locked only by the boss-quiz Swift test
(`testEveryBossQuizHasPageRefs`), which covers presence on one surface.
This deterministic pure-JSON lint validates the *shape* of every pageRefs
in the tree at commit + push time, no build required.

Usage:
    python3 scripts/check_page_ref_bounds.py
    python3 scripts/check_page_ref_bounds.py --selftest

Exit 0 = clean, 1 = violation.
"""
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PACK_DIR = os.path.join(REPO, "desktopAhaan", "Subjects", "Packs")
PACKS = ["science_class7", "maths_class7", "sanskrit_class7", "socialscience_class7"]

CEILING = 1000  # generous: largest real page seen is 241


def walk(obj, path, errors):
    if isinstance(obj, dict):
        for k, v in obj.items():
            child = f"{path}.{k}"
            if k == "pageRefs":
                _validate(v, child, errors)
            walk(v, child, errors)
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            walk(v, f"{path}[{i}]", errors)


def _validate(v, path, errors):
    if not isinstance(v, list):
        errors.append(f"D.7 {path}: pageRefs must be a list, got {type(v).__name__}")
        return
    for i, el in enumerate(v):
        # bool is a subclass of int in Python — reject it explicitly.
        if isinstance(el, bool) or not isinstance(el, int):
            errors.append(f"D.7 {path}[{i}]: non-integer page ref {el!r}")
        elif el < 1 or el > CEILING:
            errors.append(f"D.7 {path}[{i}]: page ref {el} out of [1, {CEILING}]")


def audit(name, pack):
    errors = []
    walk(pack, name, errors)
    return errors


def load_real_packs():
    out = {}
    for name in PACKS:
        with open(os.path.join(PACK_DIR, f"{name}.json"), encoding="utf-8") as fh:
            out[name] = json.load(fh)
    return out


def selftest():
    ok = True
    good = {"chapters": [{"pageRefs": [1, 7, 241]}, {"pageRefs": []},
                         {"questions": [{"pageRefs": [12]}]}]}
    if audit("good", good):
        print("SELFTEST FAIL: good pageRefs flagged:", audit("good", good)); ok = False
    for label, bad in [
        ("negative", {"x": [{"pageRefs": [-1]}]}),
        ("zero", {"x": [{"pageRefs": [0]}]}),
        ("huge", {"x": [{"pageRefs": [99999]}]}),
        ("nonint", {"x": [{"pageRefs": ["7"]}]}),
        ("bool", {"x": [{"pageRefs": [True]}]}),
        ("notlist", {"x": [{"pageRefs": 7}]}),
    ]:
        if not audit(label, bad):
            print(f"SELFTEST FAIL: {label} not caught"); ok = False
    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        return selftest()
    errors = []
    for name, pack in load_real_packs().items():
        errors += audit(name, pack)
    if errors:
        print("check_page_ref_bounds: FAIL")
        for e in errors[:50]:
            print("  " + e)
        if len(errors) > 50:
            print(f"  ... and {len(errors) - 50} more")
        return 1
    print(f"check_page_ref_bounds: clean — all pageRefs are integers in "
          f"[1, {CEILING}] across {len(PACKS)} packs (D.7)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
