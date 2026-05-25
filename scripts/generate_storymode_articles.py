#!/usr/bin/env python3
"""
generate_storymode_articles.py — generate `ch{NN}_storymode.html`
for every chapter EXCEPT Ch.1 (bespoke first-person leaf narrative).

Each generated story is a sequence of real-world examples woven
into a narrative-format article. Consumes `chapter.realWorldExamples`
(5 entries per chapter; 90 total).
"""

from __future__ import annotations

import argparse, json, sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PACK_PATH = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs" / "science_class7.json"
ARTICLES_ROOT = REPO_ROOT / "desktopAhaan" / "Resources" / "Articles"

SKIP_CHAPTER_NUMBERS = {1}


def html_escape(text: str) -> str:
    return (text.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace('"', "&quot;"))


def vignette_html(index: int, ex: dict) -> str:
    title = html_escape((ex.get("title") or "").strip())
    body = html_escape((ex.get("body") or "").strip())
    return (
        f"\n    <section>\n"
        f"      <h2>Scene {index} &mdash; {title}</h2>\n"
        f"      <p>{body}</p>\n"
        f"    </section>\n"
    )


def build_article_html(chapter: dict) -> str:
    n = chapter["number"]
    nn = f"{n:02d}"
    title_short = html_escape(chapter["title"])
    examples = chapter.get("realWorldExamples") or []
    count = len(examples)
    if count < 3:
        return ""
    sections = "".join(vignette_html(i + 1, ex) for i, ex in enumerate(examples))

    return (
        f"<!DOCTYPE html>\n"
        f"<html lang=\"en\" data-article-id=\"ch{nn}_storymode\">\n"
        f"<head>\n"
        f"  <meta charset=\"utf-8\">\n"
        f"  <title>Story Mode &mdash; Chapter {n} &middot; {title_short}</title>\n"
        f"  <link rel=\"stylesheet\" href=\"ch{nn}_style.css\">\n"
        f"</head>\n"
        f"<body>\n"
        f"  <article>\n"
        f"    <header class=\"hero\">\n"
        f"      <p class=\"breadcrumb\">Chapter {n} &middot; Way of Learning &middot; Story Mode</p>\n"
        f"      <h1>Story Mode &mdash; {title_short} in Five Scenes</h1>\n"
        f"      <p class=\"subtitle\">{count} short scenes from real life that bring this chapter to a kitchen table, a garden, a classroom &mdash; somewhere you can picture.</p>\n"
        f"      <p class=\"meta\">&#8776; {max(6, count * 2)} min read &middot; narrative-tier</p>\n"
        f"    </header>\n"
        f"\n"
        f"    <section class=\"lede\">\n"
        f"      <p>Textbook examples can feel abstract. These five scenes don&#x27;t happen in a textbook &mdash; they happen in places you go. Read them in order; each scene tightens the chapter&#x27;s big idea by another notch.</p>\n"
        f"    </section>\n"
        f"{sections}\n"
        f"    <aside class=\"fact-box\">\n"
        f"      <h3>&#128172; What this is for</h3>\n"
        f"      <p>Concrete examples are how your brain anchors abstract ideas. Pick the scene you remember best after reading. The next time you see it in real life, you&#x27;ll remember the chapter.</p>\n"
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
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    with PACK_PATH.open() as f:
        pack = json.load(f)
    if not args.write:
        for chapter in pack["chapters"]:
            if chapter["number"] == 2:
                print(build_article_html(chapter)); break
        return 0
    wrote = 0
    for chapter in pack["chapters"]:
        n = chapter["number"]
        if n in SKIP_CHAPTER_NUMBERS:
            print(f"  ch{n:02d}: skipping (bespoke anchor)"); continue
        html = build_article_html(chapter)
        if not html:
            print(f"  ch{n:02d}: skipping — too few realWorldExamples.", file=sys.stderr)
            continue
        out_dir = ARTICLES_ROOT / f"Chapter{n}"
        out_path = out_dir / f"ch{n:02d}_storymode.html"
        if out_path.exists() and not args.force:
            print(f"  ch{n:02d}: refusing to overwrite.", file=sys.stderr); continue
        out_dir.mkdir(parents=True, exist_ok=True)
        tmp = out_path.with_suffix(".html.tmp")
        tmp.write_text(html, encoding="utf-8"); tmp.replace(out_path)
        print(f"  ch{n:02d}: wrote {out_path.relative_to(REPO_ROOT)} ({len(html)} bytes)")
        wrote += 1
    print(f"\nWrote {wrote}.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
