#!/usr/bin/env python3
"""check_article_entry_bundled.py — locks Bug-Free-Cert category D.8.

Every `ArticleEntry` registered in `desktopAhaan/Subjects/Articles/
ArticleIndex+*.swift` must point at an HTML file that actually ships in
the bundle under `desktopAhaan/Resources/<chapterFolder>/<filename>`. If
an entry references a file that isn't there, `ArticleBrowserView` opens
to a blank/empty article at runtime on the iMac with no compile-time
warning — a silent content hole.

Until now D.8 was locked only by the Swift test `testArticleFilenames-
MatchEntryIds`, which runs in the XCTest target. This is a deterministic
pure-Python mirror that runs at commit + push time, before the suite,
and needs no build.

How entries are parsed:
  ArticleEntry(id: "ch01", filename: "ch01_overview.html",
               title: "...", chapterFolder: chapter1Folder | "Articles/X",
               estimatedMinutes: 6)
`chapterFolder` is either a string literal or a `static let …Folder`
constant declared in the same directory; both are resolved here.

Usage:
    python3 scripts/check_article_entry_bundled.py
    python3 scripts/check_article_entry_bundled.py --selftest

Exit 0 = clean, 1 = violation.
"""
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ART_DIR = os.path.join(REPO, "desktopAhaan", "Subjects", "Articles")
RES_DIR = os.path.join(REPO, "desktopAhaan", "Resources")

# title: is a Swift string literal that may itself contain commas/escapes;
# match it non-greedily and key off the distinctive following arg names.
ENTRY_RE = re.compile(
    r'ArticleEntry\(\s*id:\s*"([^"]+)"\s*,'
    r'\s*filename:\s*"([^"]+)"\s*,'
    r'\s*title:\s*"(?:[^"\\]|\\.)*"\s*,'
    r'\s*chapterFolder:\s*([^,]+?)\s*,'
    r'\s*estimatedMinutes:',
    re.DOTALL,
)
FOLDER_CONST_RE = re.compile(r'static let (\w+Folder)\s*=\s*"([^"]+)"')


def folder_constants(art_dir):
    const = {}
    for fn in os.listdir(art_dir):
        if fn.endswith(".swift"):
            with open(os.path.join(art_dir, fn), encoding="utf-8") as fh:
                for m in FOLDER_CONST_RE.finditer(fh.read()):
                    const[m.group(1)] = m.group(2)
    return const


def parse_entries(art_dir):
    """Return list of (entry_id, filename, resolved_folder | None)."""
    const = folder_constants(art_dir)
    entries = []
    for fn in sorted(os.listdir(art_dir)):
        if not fn.endswith(".swift"):
            continue
        with open(os.path.join(art_dir, fn), encoding="utf-8") as fh:
            text = fh.read()
        for m in ENTRY_RE.finditer(text):
            eid, filename, folder_tok = m.group(1), m.group(2), m.group(3).strip()
            if folder_tok.startswith('"') and folder_tok.endswith('"'):
                folder = folder_tok[1:-1]
            else:
                folder = const.get(folder_tok)  # None if unresolved
            entries.append((eid, filename, folder))
    return entries


def audit(art_dir, res_dir):
    errors = []
    entries = parse_entries(art_dir)
    if not entries:
        errors.append("D.8: parsed zero ArticleEntry rows — parser or layout drift")
        return errors
    for eid, filename, folder in entries:
        if folder is None:
            errors.append(f"D.8: entry {eid!r} has an unresolved chapterFolder constant")
            continue
        path = os.path.join(res_dir, folder, filename)
        if not os.path.isfile(path):
            errors.append(f"D.8: entry {eid!r} -> missing bundled HTML {folder}/{filename}")
    return errors


def selftest():
    import tempfile
    ok = True
    with tempfile.TemporaryDirectory() as d:
        art = os.path.join(d, "art")
        res = os.path.join(d, "res")
        os.makedirs(os.path.join(res, "Articles", "Chapter1"))
        os.makedirs(art)
        with open(os.path.join(art, "Index.swift"), "w", encoding="utf-8") as fh:
            fh.write('''
            static let chapter1Folder = "Articles/Chapter1"
            static let entries = [
              "ch01": ArticleEntry(id: "ch01", filename: "ok.html",
                title: "Has, a comma \\"and quote\\"", chapterFolder: chapter1Folder,
                estimatedMinutes: 6),
              "ch02": ArticleEntry(id: "ch02", filename: "lit.html",
                title: "Lit folder", chapterFolder: "Articles/Chapter1",
                estimatedMinutes: 6),
            ]
            ''')
        # only ok.html exists; lit.html missing
        open(os.path.join(res, "Articles", "Chapter1", "ok.html"), "w").close()
        errs = audit(art, res)
        if not any("lit.html" in e for e in errs):
            print("SELFTEST FAIL: missing bundled HTML not caught:", errs); ok = False
        if any("ok.html" in e for e in errs):
            print("SELFTEST FAIL: present HTML wrongly flagged:", errs); ok = False
        # now add lit.html -> clean
        open(os.path.join(res, "Articles", "Chapter1", "lit.html"), "w").close()
        if audit(art, res):
            print("SELFTEST FAIL: clean state still flagged:", audit(art, res)); ok = False
    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        return selftest()
    errors = audit(ART_DIR, RES_DIR)
    if errors:
        print("check_article_entry_bundled: FAIL")
        for e in errors[:50]:
            print("  " + e)
        if len(errors) > 50:
            print(f"  ... and {len(errors) - 50} more")
        return 1
    n = len(parse_entries(ART_DIR))
    print(f"check_article_entry_bundled: clean — all {n} ArticleEntry rows "
          f"resolve to bundled HTML (D.8)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
