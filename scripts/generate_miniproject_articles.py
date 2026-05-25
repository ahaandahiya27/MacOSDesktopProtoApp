#!/usr/bin/env python3
"""
generate_miniproject_articles.py — generate
`Resources/Articles/Chapter{N}/ch{NN}_miniproject.html` for every
chapter EXCEPT Ch.1 (which has a bespoke hand-authored anchor).

Consumes each chapter's `miniProjects: [MiniProject]` array (2
entries per chapter; 36 total for Ch.2-19). Each entry carries
emoji + title + needs[] + steps[] + expectedObservation +
whyItWorks + estimatedMinutes.
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


def html_escape(text: str) -> str:
    return (text.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace('"', "&quot;"))


def project_html(mp: dict) -> str:
    emoji = mp.get("emoji") or "🧪"
    title = html_escape((mp.get("title") or "").strip())
    needs = mp.get("needs") or []
    steps = mp.get("steps") or []
    expected = html_escape((mp.get("expectedObservation") or "").strip())
    why = html_escape((mp.get("whyItWorks") or "").strip())
    mins = mp.get("estimatedMinutes", "")

    needs_items = "".join(f"        <li>{html_escape(str(n))}</li>\n" for n in needs)
    steps_items = "".join(f"        <li>{html_escape(str(s))}</li>\n" for i, s in enumerate(steps))

    return (
        f"\n    <section>\n"
        f"      <h2>{emoji} {title}</h2>\n"
        f"      <p class=\"meta\">~{mins} min &middot; one-sitting project</p>\n"
        f"      <h3>What you&#x27;ll need</h3>\n"
        f"      <ul>\n"
        f"{needs_items}"
        f"      </ul>\n"
        f"      <h3>Steps</h3>\n"
        f"      <ol>\n"
        f"{steps_items}"
        f"      </ol>\n"
        f"      <aside class=\"fact-box\">\n"
        f"        <h3>&#128064; What you should see</h3>\n"
        f"        <p>{expected}</p>\n"
        f"      </aside>\n"
        f"      <p><strong>Why it works:</strong> {why}</p>\n"
        f"    </section>\n"
    )


def build_article_html(chapter: dict) -> str:
    n = chapter["number"]
    nn = f"{n:02d}"
    title_short = html_escape(chapter["title"])
    items = chapter.get("miniProjects") or []
    count = len(items)
    if count == 0:
        return ""

    sections = "".join(project_html(mp) for mp in items)
    count_word = {1: "One", 2: "Two", 3: "Three"}.get(count, str(count))

    return (
        f"<!DOCTYPE html>\n"
        f"<html lang=\"en\" data-article-id=\"ch{nn}_miniproject\">\n"
        f"<head>\n"
        f"  <meta charset=\"utf-8\">\n"
        f"  <title>Mini Projects &mdash; Chapter {n} &middot; {title_short}</title>\n"
        f"  <link rel=\"stylesheet\" href=\"ch{nn}_style.css\">\n"
        f"</head>\n"
        f"<body>\n"
        f"  <article>\n"
        f"    <header class=\"hero\">\n"
        f"      <p class=\"breadcrumb\">Chapter {n} &middot; Way of Learning &middot; Mini Projects</p>\n"
        f"      <h1>{count_word} Mini Project{'s' if count != 1 else ''} for Chapter {n}</h1>\n"
        f"      <p class=\"subtitle\">Hands-on activities you can do today &mdash; with materials from the kitchen, not the lab. Each project takes about an hour and turns chapter ideas into something you can see and touch.</p>\n"
        f"      <p class=\"meta\">&#8776; {max(20, count * 30)} min total &middot; hands-on</p>\n"
        f"    </header>\n"
        f"\n"
        f"    <section class=\"lede\">\n"
        f"      <p>Reading is not the same as doing. These mini projects ask you to use your hands &mdash; predict, observe, and write down what surprises you. Try at least one before the next chapter test.</p>\n"
        f"    </section>\n"
        f"{sections}\n"
        f"    <aside class=\"fact-box\">\n"
        f"      <h3>&#128221; How to use this</h3>\n"
        f"      <p>Before you start, predict what will happen. Write your prediction down. Then do the project. Compare. If your prediction was wrong, write down <em>why</em> &mdash; that&#x27;s where real learning happens.</p>\n"
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
        items = chapter.get("miniProjects") or []
        if len(items) < 1:
            print(f"  ch{n:02d}: skipping — no miniProjects.", file=sys.stderr)
            continue
        out_dir = ARTICLES_ROOT / f"Chapter{n}"
        out_path = out_dir / f"ch{n:02d}_miniproject.html"
        if out_path.exists() and not args.force:
            print(f"  ch{n:02d}: refusing to overwrite (pass --force).", file=sys.stderr)
            continue
        html = build_article_html(chapter)
        out_dir.mkdir(parents=True, exist_ok=True)
        tmp = out_path.with_suffix(".html.tmp")
        tmp.write_text(html, encoding="utf-8")
        tmp.replace(out_path)
        print(f"  ch{n:02d}: wrote {out_path.relative_to(REPO_ROOT)} ({len(html)} bytes, {len(items)} projects)")
        wrote += 1
    print(f"\nWrote {wrote}.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
