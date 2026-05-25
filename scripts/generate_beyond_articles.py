#!/usr/bin/env python3
"""
generate_beyond_articles.py — generate
`Resources/Articles/Chapter{N}/ch{NN}_beyond.html` for every
chapter EXCEPT Ch.1 and Ch.2 (which both have bespoke 5-section
and 10-section hand-authored anchor articles).

Consumes each chapter's `deepDive: [StretchTopic]` array (3 entries
per chapter; 51 total for Ch.3-19). Mirrors the four prior
generators in this 2026-05-26 series.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PACK_PATH = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs" / "science_class7.json"
ARTICLES_ROOT = REPO_ROOT / "desktopAhaan" / "Resources" / "Articles"

# Both Ch.1 and Ch.2 have bespoke beyond articles already shipped.
SKIP_CHAPTER_NUMBERS = {1, 2}


def html_escape(text: str) -> str:
    return (text.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace('"', "&quot;"))


def section_html(index: int, dd: dict) -> str:
    title = html_escape((dd.get("title") or "").strip())
    body = html_escape((dd.get("body") or "").strip())
    prereq = html_escape((dd.get("prerequisite") or "").strip())
    nxt = html_escape((dd.get("nextStepHint") or "").strip())

    prereq_block = (
        f"      <aside class=\"connect-box\" style=\"margin:10px 0;\">\n"
        f"        <h3>&#128205; Before you tackle this</h3>\n"
        f"        <p>{prereq}</p>\n"
        f"      </aside>\n"
        if prereq else ""
    )
    next_block = (
        f"      <p><strong>Next step:</strong> {nxt}</p>\n" if nxt else ""
    )
    return (
        f"\n    <section>\n"
        f"      <h2>{index}. {title}</h2>\n"
        f"      <p>{body}</p>\n"
        f"{prereq_block}"
        f"{next_block}"
        f"    </section>\n"
    )


def build_article_html(chapter: dict) -> str:
    n = chapter["number"]
    nn = f"{n:02d}"
    title_short = html_escape(chapter["title"])
    summary = html_escape((chapter.get("summary") or "").strip())
    # Take first sentence of summary for the lede.
    lede_sentence = summary.split(".")[0].strip() if summary else f"the topic of {title_short}"
    items = chapter.get("deepDive") or []
    count = len(items)
    if count == 0:
        return ""
    count_word = {1: "One", 2: "Two", 3: "Three", 4: "Four", 5: "Five"}.get(count, str(count))

    sections = "".join(section_html(i + 1, dd) for i, dd in enumerate(items))
    return (
        f"<!DOCTYPE html>\n"
        f"<html lang=\"en\" data-article-id=\"ch{nn}_beyond\">\n"
        f"<head>\n"
        f"  <meta charset=\"utf-8\">\n"
        f"  <title>Beyond the Book &mdash; Chapter {n} &middot; {title_short}</title>\n"
        f"  <link rel=\"stylesheet\" href=\"ch{nn}_style.css\">\n"
        f"</head>\n"
        f"<body>\n"
        f"  <article>\n"
        f"    <header class=\"hero\">\n"
        f"      <p class=\"breadcrumb\">Chapter {n} &middot; Beyond the Book</p>\n"
        f"      <h1>Beyond the Book &mdash; {count_word} Mind-Stretchers About {title_short}</h1>\n"
        f"      <p class=\"subtitle\">{count_word} ideas that don&#x27;t show up in the NCERT textbook but will change how you see this chapter.</p>\n"
        f"      <p class=\"meta\">&#8776; {max(8, count * 3)} min read &middot; curious-kid level</p>\n"
        f"    </header>\n"
        f"\n"
        f"    <section class=\"lede\">\n"
        f"      <p>The chapter teaches you {lede_sentence.lower() if lede_sentence else 'the basics'}. This article goes a step further &mdash; three stretch topics that lead naturally into Class 8 and beyond. Read one a day; don&#x27;t try to absorb them all at once.</p>\n"
        f"    </section>\n"
        f"{sections}\n"
        f"    <aside class=\"fact-box\">\n"
        f"      <h3>&#128221; How to use this</h3>\n"
        f"      <p>These ideas are <em>stretch</em>, not exam material. The goal is not to memorise; the goal is to wonder. Pick the one that sounds most interesting, read it twice, and try to explain it to someone older than you.</p>\n"
        f"    </aside>\n"
        f"\n"
        f"    <footer class=\"returns\">\n"
        f"      <a class=\"pill\" href=\"ch{nn}_overview.html\">&larr; Chapter overview</a>\n"
        f"    </footer>\n"
        f"\n"
        f"  </article>\n"
        f"</body>\n"
        f"</html>\n"
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    with PACK_PATH.open() as f:
        pack = json.load(f)
    if not args.write:
        for chapter in pack["chapters"]:
            if chapter["number"] == 3:
                print(build_article_html(chapter))
                break
        print("\n(dry-run; pass --write)\n", file=sys.stderr)
        return 0
    wrote = 0
    for chapter in pack["chapters"]:
        n = chapter["number"]
        if n in SKIP_CHAPTER_NUMBERS:
            print(f"  ch{n:02d}: skipping (bespoke anchor)")
            continue
        items = chapter.get("deepDive") or []
        if len(items) < 2:
            print(f"  ch{n:02d}: skipping — only {len(items)} deepDive entries.",
                  file=sys.stderr)
            continue
        out_dir = ARTICLES_ROOT / f"Chapter{n}"
        out_path = out_dir / f"ch{n:02d}_beyond.html"
        if out_path.exists() and not args.force:
            print(f"  ch{n:02d}: refusing to overwrite (pass --force).", file=sys.stderr)
            continue
        html = build_article_html(chapter)
        out_dir.mkdir(parents=True, exist_ok=True)
        tmp = out_path.with_suffix(".html.tmp")
        tmp.write_text(html, encoding="utf-8")
        tmp.replace(out_path)
        print(f"  ch{n:02d}: wrote {out_path.relative_to(REPO_ROOT)} ({len(html)} bytes, {len(items)} stretch topics)")
        wrote += 1
    print(f"\nWrote {wrote}.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
