#!/usr/bin/env python3
"""check_orphan_html.py — locks Bug-Free-Cert category D.9.

Every HTML file shipped under `desktopAhaan/Resources/Articles/**` must be
reachable through a registered `ArticleEntry`. A bundled-but-unregistered
HTML file is dead weight: it bloats the app, can never be opened, and
masks an authoring mistake (an article was written but its registration
was forgotten, so the kid never sees it).

This is the reverse direction of `check_article_entry_bundled.py` (D.8):
  D.8 — every entry points at a file that exists.
  D.9 — every file is pointed at by some entry.

Together they pin a bijection between registered entries and bundled HTML.
Until now D.9 was locked only by Swift tests in the XCTest target; this is
the deterministic pure-Python push-time mirror that needs no build.

Usage:
    python3 scripts/check_orphan_html.py
    python3 scripts/check_orphan_html.py --selftest

Exit 0 = clean, 1 = violation.
"""
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ART_DIR = os.path.join(REPO, "desktopAhaan", "Subjects", "Articles")
RES_DIR = os.path.join(REPO, "desktopAhaan", "Resources")
ARTICLES_ROOT = os.path.join(RES_DIR, "Articles")

# Reuse the battle-tested entry parser from the sibling D.8 lint so both
# lints agree byte-for-byte on what "a registered entry" means.
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check_article_entry_bundled import parse_entries  # noqa: E402


def bundled_html(articles_root):
    out = set()
    for dirpath, _dirs, files in os.walk(articles_root):
        for f in files:
            if f.endswith(".html"):
                out.add(os.path.normpath(os.path.join(dirpath, f)))
    return out


def referenced_html(art_dir, res_dir):
    out = set()
    for _eid, filename, folder in parse_entries(art_dir):
        if folder is not None:
            out.add(os.path.normpath(os.path.join(res_dir, folder, filename)))
    return out


def audit(art_dir, res_dir, articles_root):
    bundled = bundled_html(articles_root)
    referenced = referenced_html(art_dir, res_dir)
    if not bundled:
        return ["D.9: found zero bundled HTML files — layout drift"]
    orphans = sorted(bundled - referenced)
    return [f"D.9: orphan HTML never registered as an ArticleEntry: "
            f"{os.path.relpath(p, REPO)}" for p in orphans]


def selftest():
    import tempfile
    ok = True
    with tempfile.TemporaryDirectory() as d:
        art = os.path.join(d, "art")
        res = os.path.join(d, "res")
        aroot = os.path.join(res, "Articles", "Chapter1")
        os.makedirs(aroot)
        os.makedirs(art)
        with open(os.path.join(art, "Index.swift"), "w", encoding="utf-8") as fh:
            fh.write('''
            static let chapter1Folder = "Articles/Chapter1"
            "ch01": ArticleEntry(id: "ch01", filename: "registered.html",
              title: "ok", chapterFolder: chapter1Folder, estimatedMinutes: 6),
            ''')
        open(os.path.join(aroot, "registered.html"), "w").close()
        open(os.path.join(aroot, "orphan.html"), "w").close()
        errs = audit(art, res, os.path.join(res, "Articles"))
        if not any("orphan.html" in e for e in errs):
            print("SELFTEST FAIL: orphan not caught:", errs); ok = False
        if any("registered.html" in e for e in errs):
            print("SELFTEST FAIL: registered file wrongly flagged:", errs); ok = False
        os.remove(os.path.join(aroot, "orphan.html"))
        if audit(art, res, os.path.join(res, "Articles")):
            print("SELFTEST FAIL: clean state still flagged"); ok = False
    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        return selftest()
    errors = audit(ART_DIR, RES_DIR, ARTICLES_ROOT)
    if errors:
        print("check_orphan_html: FAIL")
        for e in errors[:50]:
            print("  " + e)
        if len(errors) > 50:
            print(f"  ... and {len(errors) - 50} more")
        return 1
    n = len(bundled_html(ARTICLES_ROOT))
    print(f"check_orphan_html: clean — all {n} bundled HTML files are "
          f"registered as ArticleEntry rows (D.9)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
