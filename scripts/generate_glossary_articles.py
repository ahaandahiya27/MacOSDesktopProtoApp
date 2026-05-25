#!/usr/bin/env python3
"""
generate_glossary_articles.py — generate
`Resources/Articles/Chapter{N}/ch{NN}_glossary.html` for every
science chapter EXCEPT Ch.1 (which has a bespoke 30-term hand-
authored anchor article).

Consumes each chapter's `glossary: [GlossaryTerm]` array from
`science_class7.json` (10 entries per chapter, 190 total across
19 chapters), and emits a uniformly-templated HTML article in
the same shape as `ch01_glossary.html`.

Run from the repo root:
    python3 scripts/generate_glossary_articles.py            # dry-run, prints Ch.2
    python3 scripts/generate_glossary_articles.py --write    # writes 18 files
    python3 scripts/generate_glossary_articles.py --write --force   # overwrite existing

Idempotent under re-run. File writes are atomic (tmp + rename,
POSIX-equivalent of `options: .atomic` per CLAUDE.md).

Mirrors `generate_mistakes_articles.py` (shipped 2026-05-26)
exactly. Ships as a HISTORICAL ARTEFACT; not re-run on schedule.
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
    "Reading the chapter once isn't enough. Knowing the <em>words</em> is "
    "what makes you confident. Glance through this deck every Sunday for "
    "four weeks and these terms will be yours."
)


def html_escape(text: str) -> str:
    return (text.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace('"', "&quot;"))


def term_html(entry: dict) -> str:
    """One <li> per glossary term — English term, Hindi (if present),
    one-line definition. Example sentence below if present."""
    term = html_escape((entry.get("term") or "").strip())
    hindi = html_escape((entry.get("hindiTerm") or "").strip())
    definition = html_escape((entry.get("definition") or "").strip())
    example = html_escape((entry.get("example") or "").strip())

    hindi_block = f" &middot; <em>{hindi}</em>" if hindi else ""
    example_block = (
        f"<br><span class=\"example\"><strong>Example:</strong> {example}</span>"
        if example else ""
    )
    return (
        f"      <li><strong>{term}</strong>{hindi_block} &mdash; "
        f"{definition}{example_block}</li>\n"
    )


def build_article_html(chapter: dict) -> str:
    n = chapter["number"]
    nn = f"{n:02d}"
    title_short = html_escape(chapter["title"])
    entries = chapter.get("glossary") or []
    count = len(entries)

    if count == 0:
        return ""

    subtitle = (
        f"The {count} must-know terms from Chapter {n} &mdash; in plain "
        f"English plus the Hindi name, with a one-line meaning a Class 7 "
        f"student can actually use."
    )

    items = "".join(term_html(e) for e in entries)

    return (
        f"<!DOCTYPE html>\n"
        f"<html lang=\"en\" data-article-id=\"ch{nn}_glossary\">\n"
        f"<head>\n"
        f"  <meta charset=\"utf-8\">\n"
        f"  <title>Class 7 Vocabulary Deck &mdash; Chapter {n} &middot; {title_short}</title>\n"
        f"  <link rel=\"stylesheet\" href=\"ch{nn}_style.css\">\n"
        f"</head>\n"
        f"<body>\n"
        f"  <article>\n"
        f"    <header class=\"hero\">\n"
        f"      <p class=\"breadcrumb\">Chapter {n} &middot; Way of Learning &middot; Vocabulary Deck</p>\n"
        f"      <h1>A Class 7 {title_short} Dictionary</h1>\n"
        f"      <p class=\"subtitle\">{subtitle}</p>\n"
        f"      <p class=\"meta\">&#8776; {max(3, count // 2)} min read &middot; revision-ready</p>\n"
        f"    </header>\n"
        f"\n"
        f"    <section class=\"lede\">\n"
        f"      <p>{LEDE}</p>\n"
        f"    </section>\n"
        f"\n"
        f"    <section>\n"
        f"      <h2>The {count} terms to know</h2>\n"
        f"      <ul class=\"vocab-deck\">\n"
        f"{items}"
        f"      </ul>\n"
        f"    </section>\n"
        f"\n"
        f"    <aside class=\"fact-box\">\n"
        f"      <h3>&#128172; How to use this</h3>\n"
        f"      <p>Cover the right side of each row. Read just the term. See if you can speak the meaning out loud in one sentence. Move on when you can do that for every term &mdash; not before.</p>\n"
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
        print(f"\n(dry-run; pass --write to generate all 18 files)\n", file=sys.stderr)
        return 0

    wrote = 0
    skipped_empty = 0
    skipped_existing = 0
    for chapter in pack["chapters"]:
        n = chapter["number"]
        if n in SKIP_CHAPTER_NUMBERS:
            print(f"  ch{n:02d}: skipping (bespoke anchor article)")
            continue
        entries = chapter.get("glossary") or []
        if len(entries) < 5:
            print(f"  ch{n:02d}: SKIPPING — only {len(entries)} glossary entries.",
                  file=sys.stderr)
            skipped_empty += 1
            continue
        out_dir = ARTICLES_ROOT / f"Chapter{n}"
        out_path = out_dir / f"ch{n:02d}_glossary.html"
        if out_path.exists() and not args.force:
            print(f"  ch{n:02d}: refusing to overwrite (pass --force).", file=sys.stderr)
            skipped_existing += 1
            continue
        html = build_article_html(chapter)
        out_dir.mkdir(parents=True, exist_ok=True)
        tmp = out_path.with_suffix(".html.tmp")
        tmp.write_text(html, encoding="utf-8")
        tmp.replace(out_path)
        print(f"  ch{n:02d}: wrote {out_path.relative_to(REPO_ROOT)} ({len(html)} bytes, {len(entries)} terms)")
        wrote += 1

    print(file=sys.stderr)
    print(f"Wrote {wrote} article(s).", file=sys.stderr)
    if skipped_existing:
        print(f"Skipped {skipped_existing} existing file(s).", file=sys.stderr)
    if skipped_empty:
        print(f"Skipped {skipped_empty} chapter(s) with insufficient glossary data.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
