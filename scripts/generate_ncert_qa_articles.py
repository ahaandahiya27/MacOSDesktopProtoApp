#!/usr/bin/env python3
"""
generate_ncert_qa_articles.py — generate
`Resources/Articles/Chapter{N}/ch{NN}_ncert_qa.html` for every
science chapter EXCEPT Ch.1 (which has a bespoke 8-Q article).

Consumes each chapter's `ncertQA: [NcertQAEntry]` array from
`science_class7.json`. Mirrors `generate_mistakes_articles.py`
and `generate_glossary_articles.py` in shape.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PACK_PATH = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs" / "science_class7.json"
ARTICLES_ROOT = REPO_ROOT / "desktopAhaan" / "Resources" / "Articles"

SKIP_CHAPTER_NUMBERS = {1}

LEDE = (
    "The questions below are the NCERT-style questions teachers usually "
    "ask from this chapter. Each one shows: <strong>(a)</strong> a model "
    "answer at the right length, and <strong>(b)</strong> what the examiner "
    "is checking. Use these as revision before a chapter test."
)


def html_escape(text: str) -> str:
    return (text.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace('"', "&quot;"))


def qa_html(index: int, q: dict) -> str:
    question = html_escape((q.get("question") or "").strip())
    answer = html_escape((q.get("modelAnswer") or "").strip())
    return (
        f"\n    <section>\n"
        f"      <h2>Q{index}. {question}</h2>\n"
        f"      <p><strong>Model answer:</strong> {answer}</p>\n"
        f"      <aside class=\"fact-box\">\n"
        f"        <h3>&#128221; Examiner is checking</h3>\n"
        f"        <p>The full reasoning (not just a fact), with a concrete example where the answer calls for one.</p>\n"
        f"      </aside>\n"
        f"    </section>\n"
    )


def build_article_html(chapter: dict) -> str:
    n = chapter["number"]
    nn = f"{n:02d}"
    title_short = html_escape(chapter["title"])
    items = chapter.get("ncertQA") or []
    count = len(items)
    if count == 0:
        return ""

    sections = "".join(qa_html(i + 1, q) for i, q in enumerate(items))
    return (
        f"<!DOCTYPE html>\n"
        f"<html lang=\"en\" data-article-id=\"ch{nn}_ncert_qa\">\n"
        f"<head>\n"
        f"  <meta charset=\"utf-8\">\n"
        f"  <title>NCERT Exercise Q&amp;A &mdash; Chapter {n} &middot; {title_short}</title>\n"
        f"  <link rel=\"stylesheet\" href=\"ch{nn}_style.css\">\n"
        f"</head>\n"
        f"<body>\n"
        f"  <article>\n"
        f"    <header class=\"hero\">\n"
        f"      <p class=\"breadcrumb\">Chapter {n} &middot; NCERT Exercise &middot; Worked Answers</p>\n"
        f"      <h1>NCERT Exercise Q&amp;A &mdash; Chapter {n}</h1>\n"
        f"      <p class=\"subtitle\">{count} NCERT-style questions with model answers and what the examiner is checking. Built for revision before a chapter test.</p>\n"
        f"      <p class=\"meta\">&#8776; {max(8, count + 4)} min read &middot; exam-prep</p>\n"
        f"    </header>\n"
        f"\n"
        f"    <section class=\"lede\">\n"
        f"      <p>{LEDE}</p>\n"
        f"    </section>\n"
        f"{sections}\n"
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
            if chapter["number"] == 2:
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
        items = chapter.get("ncertQA") or []
        if len(items) < 4:
            print(f"  ch{n:02d}: skipping — only {len(items)} Q&A entries.",
                  file=sys.stderr)
            continue
        out_dir = ARTICLES_ROOT / f"Chapter{n}"
        out_path = out_dir / f"ch{n:02d}_ncert_qa.html"
        if out_path.exists() and not args.force:
            print(f"  ch{n:02d}: refusing to overwrite (pass --force).",
                  file=sys.stderr)
            continue
        html = build_article_html(chapter)
        out_dir.mkdir(parents=True, exist_ok=True)
        tmp = out_path.with_suffix(".html.tmp")
        tmp.write_text(html, encoding="utf-8")
        tmp.replace(out_path)
        print(f"  ch{n:02d}: wrote {out_path.relative_to(REPO_ROOT)} ({len(html)} bytes, {len(items)} Q&As)")
        wrote += 1
    print(f"\nWrote {wrote}.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
