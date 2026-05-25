#!/usr/bin/env python3
"""
generate_scientists_articles.py — generate
`Resources/Articles/Chapter{N}/ch{NN}_scientists.html` for every
science chapter EXCEPT Ch.1 (which has a bespoke 5-scientist
anchor article with an SVG timeline).

Consumes each chapter's `scientists: [ScientistProfile]` array
(1 entry per chapter in the current pack). Mirrors the
mistakes / glossary / ncert_qa generators in shape.
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
    "Every chapter has a person behind it &mdash; someone who first asked "
    "the right question, ran the right experiment, or wrote down the "
    "answer. This is a one-page portrait of the scientist most tied to "
    "this chapter's content."
)


def html_escape(text: str) -> str:
    return (text.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace('"', "&quot;"))


def profile_html(sci: dict) -> str:
    name = html_escape((sci.get("name") or "").strip())
    lifespan = html_escape((sci.get("lifespan") or "").strip())
    nationality = html_escape((sci.get("nationality") or "").strip())
    one_liner = html_escape((sci.get("oneLineLegacy") or "").strip())
    narrative = html_escape((sci.get("narrative") or "").strip())

    meta_parts = []
    if lifespan: meta_parts.append(lifespan)
    if nationality: meta_parts.append(nationality)
    meta_line = " &middot; ".join(meta_parts)

    return (
        f"\n    <section>\n"
        f"      <h2>{name}</h2>\n"
        f"      <p class=\"meta\">{meta_line}</p>\n"
        f"      <aside class=\"fact-box\">\n"
        f"        <h3>&#127911; In one line</h3>\n"
        f"        <p>{one_liner}</p>\n"
        f"      </aside>\n"
        f"      <p>{narrative}</p>\n"
        f"    </section>\n"
    )


def build_article_html(chapter: dict) -> str:
    n = chapter["number"]
    nn = f"{n:02d}"
    title_short = html_escape(chapter["title"])
    scientists = chapter.get("scientists") or []
    if not scientists:
        return ""

    sections = "".join(profile_html(s) for s in scientists)
    count = len(scientists)
    intro_count_word = {1: "One", 2: "Two", 3: "Three", 4: "Four", 5: "Five"}.get(count, str(count))

    return (
        f"<!DOCTYPE html>\n"
        f"<html lang=\"en\" data-article-id=\"ch{nn}_scientists\">\n"
        f"<head>\n"
        f"  <meta charset=\"utf-8\">\n"
        f"  <title>Scientist Spotlight &mdash; Chapter {n} &middot; {title_short}</title>\n"
        f"  <link rel=\"stylesheet\" href=\"ch{nn}_style.css\">\n"
        f"</head>\n"
        f"<body>\n"
        f"  <article>\n"
        f"    <header class=\"hero\">\n"
        f"      <p class=\"breadcrumb\">Chapter {n} &middot; Way of Learning &middot; Scientist Spotlight</p>\n"
        f"      <h1>{intro_count_word} Curious Person Behind Chapter {n}</h1>\n"
        f"      <p class=\"subtitle\">The scientist most tied to {title_short.lower()} &mdash; their question, their experiment, and what changed because of them.</p>\n"
        f"      <p class=\"meta\">&#8776; {max(4, count * 4)} min read &middot; biography</p>\n"
        f"    </header>\n"
        f"\n"
        f"    <section class=\"lede\">\n"
        f"      <p>{LEDE}</p>\n"
        f"    </section>\n"
        f"{sections}\n"
        f"    <aside class=\"fact-box\">\n"
        f"      <h3>&#128172; Why this matters</h3>\n"
        f"      <p>Knowing the human behind a discovery makes it easier to remember the discovery itself. Try to summarise this scientist's contribution in one sentence, in your own words.</p>\n"
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
        scis = chapter.get("scientists") or []
        if len(scis) < 1:
            print(f"  ch{n:02d}: skipping — no scientist entry.", file=sys.stderr)
            continue
        out_dir = ARTICLES_ROOT / f"Chapter{n}"
        out_path = out_dir / f"ch{n:02d}_scientists.html"
        if out_path.exists() and not args.force:
            print(f"  ch{n:02d}: refusing to overwrite (pass --force).", file=sys.stderr)
            continue
        html = build_article_html(chapter)
        out_dir.mkdir(parents=True, exist_ok=True)
        tmp = out_path.with_suffix(".html.tmp")
        tmp.write_text(html, encoding="utf-8")
        tmp.replace(out_path)
        print(f"  ch{n:02d}: wrote {out_path.relative_to(REPO_ROOT)} ({len(html)} bytes, {len(scis)} scientist(s))")
        wrote += 1
    print(f"\nWrote {wrote}.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
