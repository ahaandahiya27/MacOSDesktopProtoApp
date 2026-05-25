#!/usr/bin/env python3
"""
generate_whatif_articles.py — generate
`Resources/Articles/Chapter{N}/ch{NN}_whatif.html` for every
science chapter EXCEPT Ch.1 (which has a bespoke 5-question
anchor article).

Consumes each chapter's `whatIfs: [WhatIfScenario]` array
(3 entries per chapter; 54 total for Ch.2-19). Mirrors the
mistakes / glossary / ncert_qa / scientists generators.
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
    "The textbook tells you <em>what is</em>. The best science teachers "
    "also ask <em>what if?</em> Pick any one of the questions below. "
    "Pause. Think for at least one minute before scrolling. Then read "
    "the discussion."
)


def html_escape(text: str) -> str:
    return (text.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace('"', "&quot;"))


def scenario_html(index: int, w: dict) -> str:
    question = html_escape((w.get("question") or "").strip())
    answer = html_escape((w.get("answer") or "").strip())
    return (
        f"\n    <section>\n"
        f"      <h2>What if {index} &mdash; {question}</h2>\n"
        f"      <aside class=\"connect-box\" style=\"margin:10px 0;\">\n"
        f"        <h3>&#129504; Think first</h3>\n"
        f"        <p>Pause. Write down your one-sentence guess before reading.</p>\n"
        f"      </aside>\n"
        f"      <p><strong>One discussion path:</strong> {answer}</p>\n"
        f"    </section>\n"
    )


def build_article_html(chapter: dict) -> str:
    n = chapter["number"]
    nn = f"{n:02d}"
    title_short = html_escape(chapter["title"])
    items = chapter.get("whatIfs") or []
    count = len(items)
    if count == 0:
        return ""

    count_word = {1: "One", 2: "Two", 3: "Three", 4: "Four", 5: "Five"}.get(count, str(count))
    sections = "".join(scenario_html(i + 1, w) for i, w in enumerate(items))
    return (
        f"<!DOCTYPE html>\n"
        f"<html lang=\"en\" data-article-id=\"ch{nn}_whatif\">\n"
        f"<head>\n"
        f"  <meta charset=\"utf-8\">\n"
        f"  <title>What If? &mdash; Chapter {n} &middot; {title_short}</title>\n"
        f"  <link rel=\"stylesheet\" href=\"ch{nn}_style.css\">\n"
        f"</head>\n"
        f"<body>\n"
        f"  <article>\n"
        f"    <header class=\"hero\">\n"
        f"      <p class=\"breadcrumb\">Chapter {n} &middot; Way of Learning &middot; Thought Experiments</p>\n"
        f"      <h1>{count_word} \"What Ifs?\" About {title_short}</h1>\n"
        f"      <p class=\"subtitle\">Hypothetical questions with no single right answer. Think hard before you read the discussion.</p>\n"
        f"      <p class=\"meta\">&#8776; {max(5, count * 2 + 1)} min read &middot; brain-stretcher level</p>\n"
        f"    </header>\n"
        f"\n"
        f"    <section class=\"lede\">\n"
        f"      <p>{LEDE}</p>\n"
        f"    </section>\n"
        f"{sections}\n"
        f"    <aside class=\"fact-box\">\n"
        f"      <h3>&#128172; How to use this</h3>\n"
        f"      <p>These are not exam questions. The answer marked &lsquo;one discussion path&rsquo; is one valid line of reasoning &mdash; your own may be different and still good. Practising this kind of thinking is how scientists become scientists.</p>\n"
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
        items = chapter.get("whatIfs") or []
        if len(items) < 2:
            print(f"  ch{n:02d}: skipping — only {len(items)} what-if entries.",
                  file=sys.stderr)
            continue
        out_dir = ARTICLES_ROOT / f"Chapter{n}"
        out_path = out_dir / f"ch{n:02d}_whatif.html"
        if out_path.exists() and not args.force:
            print(f"  ch{n:02d}: refusing to overwrite (pass --force).", file=sys.stderr)
            continue
        html = build_article_html(chapter)
        out_dir.mkdir(parents=True, exist_ok=True)
        tmp = out_path.with_suffix(".html.tmp")
        tmp.write_text(html, encoding="utf-8")
        tmp.replace(out_path)
        print(f"  ch{n:02d}: wrote {out_path.relative_to(REPO_ROOT)} ({len(html)} bytes, {len(items)} scenarios)")
        wrote += 1
    print(f"\nWrote {wrote}.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
