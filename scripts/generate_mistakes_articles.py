#!/usr/bin/env python3
"""
generate_mistakes_articles.py — generate
`Resources/Articles/Chapter{N}/ch{NN}_mistakes.html` for every
science chapter EXCEPT Ch.1 (which has a bespoke hand-authored
anchor article and stays untouched).

The generator consumes each chapter's `misconceptions: [Misconception]`
array from `science_class7.json` (5 entries per chapter, 95 total
across 19 chapters), and emits a uniformly-templated HTML article
matching `ch01_mistakes.html`'s structural shape:

    <header class="hero">     — breadcrumb + h1 + subtitle + meta
    <section class="lede">    — common opening prose
    <section>...</section>    — one per misconception (warning-box + fix)
    <aside class="fact-box">  — common stretch-your-thinking prompt
    <footer class="returns">  — back-link to chapter overview

Voice / framing: identical across all 18 generated chapters by design.
Per the SUPERPROMPT §1, uniformity IS the win — Ch.1's bespoke
anchor stays as the reference for hand-authored richness.

Run from the repo root:
    python3 scripts/generate_mistakes_articles.py            # dry-run, prints Ch.2 to stdout
    python3 scripts/generate_mistakes_articles.py --write    # writes all 18 files
    python3 scripts/generate_mistakes_articles.py --write --force   # overwrite existing

Idempotent under re-run: --write twice produces byte-identical output
when the input JSON is unchanged.

THIS IS A HISTORICAL ARTEFACT in the same shape as
`migrate_boss_quiz_to_pack.py`. It stays in the repo so a future
content audit can re-run + verify the generated articles still
match the JSON source.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PACK_PATH = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs" / "science_class7.json"
ARTICLES_ROOT = REPO_ROOT / "desktopAhaan" / "Resources" / "Articles"

# Ch.1 has a bespoke 10-entry hand-authored article. Leave it alone.
SKIP_CHAPTER_NUMBERS = {1}

LEDE = (
    "Examiners say the same wrong answers come back year after year. "
    "None of these mistakes are silly &mdash; they are <em>almost</em> right. "
    "That is exactly what makes them dangerous. Read each one, cover the "
    "answer, and try to spot what is off before peeking."
)

STRETCH = (
    "Pick any two of these and explain them to a younger sibling using a "
    "one-line analogy each. If you can compress a mistake into one sentence "
    "with one image, you have understood it."
)


# ──────────────────────────────────────────────────────────────────────────

def html_escape(text: str) -> str:
    """Light HTML-escape suitable for body text. Pack JSON already uses
    plain Unicode where useful (e.g. CO₂, →), so we only need to escape
    the four mandatory characters."""
    out = (text.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace('"', "&quot;"))
    return out


def section_html(index: int, miscon: dict) -> str:
    """One <section> per misconception. The h2 carries the
    `kidsThink` quote (what students wrongly believe). The
    warning-box header sits without repeating that quote — the
    `actually` content goes in the fix paragraph immediately
    below. Matches Ch.1's anchor article shape, where the
    warning-box <p> is a one-line FRAMING of why the mistake is
    common, not a restatement of the quoted belief.
    """
    kids_think = html_escape(miscon.get("kidsThink", "").strip())
    actually = html_escape(miscon.get("actually", "").strip())
    # Uniform framing line — Ch.1 anchor uses a per-section bespoke
    # framing; the generated articles use a single template line to
    # keep visual rhythm without paraphrasing the JSON. Acceptable
    # within the SUPERPROMPT's "uniformity is the win" rule.
    framing = "A common belief that's almost right &mdash; but misses the key detail."
    return (
        f"\n    <section>\n"
        f"      <h2>{index}. &ldquo;{kids_think}&rdquo;</h2>\n"
        f"      <aside class=\"warning-box\">\n"
        f"        <h3>&#128683; The mistake</h3>\n"
        f"        <p>{framing}</p>\n"
        f"      </aside>\n"
        f"      <p><strong>The fix:</strong> {actually}</p>\n"
        f"    </section>\n"
    )


def build_article_html(chapter: dict) -> str:
    """Render one chapter's mistakes article. Returns the full HTML
    string ready to write."""
    n = chapter["number"]
    nn = f"{n:02d}"
    title_short = html_escape(chapter["title"])
    miscons = chapter.get("misconceptions") or []
    count = len(miscons)
    word_for_count = {3: "Three", 4: "Four", 5: "Five", 6: "Six", 7: "Seven", 8: "Eight"}.get(count, str(count))

    # Subtitle: derive from first misconception's actually-fragment so the
    # subtitle teases the chapter content without inventing copy. Falls
    # back to a chapter-summary-derived sentence.
    if count > 0:
        first_actually = miscons[0].get("actually", "").strip()
        # Take the first sentence up to ~110 chars.
        first_sentence = first_actually.split(".")[0].strip()
        if len(first_sentence) > 110:
            first_sentence = first_sentence[:107].rstrip() + "..."
        subtitle = html_escape(first_sentence) + "."
    else:
        subtitle = "Common revisions worth one more look."
    subtitle = (
        f"The {word_for_count.lower()} places almost every Class 7 student trips up "
        f"on Chapter {n} &mdash; and the one-line fix for each."
    )

    sections = "".join(section_html(i + 1, m) for i, m in enumerate(miscons))

    return (
        f"<!DOCTYPE html>\n"
        f"<html lang=\"en\" data-article-id=\"ch{nn}_mistakes\">\n"
        f"<head>\n"
        f"  <meta charset=\"utf-8\">\n"
        f"  <title>{word_for_count} Wrong Answers &mdash; Chapter {n} &middot; {title_short}</title>\n"
        f"  <link rel=\"stylesheet\" href=\"ch{nn}_style.css\">\n"
        f"</head>\n"
        f"<body>\n"
        f"  <article>\n"
        f"    <header class=\"hero\">\n"
        f"      <p class=\"breadcrumb\">Chapter {n} &middot; Common Mistakes</p>\n"
        f"      <h1>{word_for_count} Wrong Answers Class 7 Students Give</h1>\n"
        f"      <p class=\"subtitle\">{subtitle}</p>\n"
        f"      <p class=\"meta\">&#8776; {max(3, count)} min read &middot; revision-tier</p>\n"
        f"    </header>\n"
        f"\n"
        f"    <section class=\"lede\">\n"
        f"      <p>{LEDE}</p>\n"
        f"    </section>\n"
        f"{sections}\n"
        f"    <aside class=\"fact-box\">\n"
        f"      <h3>&#128221; Stretch your thinking</h3>\n"
        f"      <p>{STRETCH}</p>\n"
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


# ──────────────────────────────────────────────────────────────────────────

def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--write", action="store_true",
                        help="Write the files. Default: dry-run, prints Ch.2's HTML to stdout.")
    parser.add_argument("--force", action="store_true",
                        help="Overwrite existing files. Default: refuse if file exists.")
    args = parser.parse_args()

    with PACK_PATH.open() as f:
        pack = json.load(f)

    if not args.write:
        # Dry-run: print Ch.2's full HTML so we can eyeball-verify the
        # template before committing to all 18 chapters.
        for chapter in pack["chapters"]:
            if chapter["number"] == 2:
                print(build_article_html(chapter))
                break
        print(f"\n(dry-run; pass --write to generate all 18 files)\n", file=sys.stderr)
        return 0

    wrote = 0
    skipped_existing = 0
    skipped_no_misconceptions = 0
    skipped_anchor = 0

    for chapter in pack["chapters"]:
        n = chapter["number"]
        if n in SKIP_CHAPTER_NUMBERS:
            print(f"  ch{n:02d}: skipping (bespoke anchor article — see SUPERPROMPT §1)")
            skipped_anchor += 1
            continue

        miscons = chapter.get("misconceptions") or []
        if len(miscons) < 3:
            # Stop-and-ask per SUPERPROMPT §10 — a 1-2 section article
            # reads broken. Skip rather than ship a stub.
            print(f"  ch{n:02d}: SKIPPING — only {len(miscons)} misconception(s) (need >= 3).",
                  file=sys.stderr)
            skipped_no_misconceptions += 1
            continue

        out_dir = ARTICLES_ROOT / f"Chapter{n}"
        out_path = out_dir / f"ch{n:02d}_mistakes.html"
        if out_path.exists() and not args.force:
            print(f"  ch{n:02d}: refusing to overwrite {out_path.relative_to(REPO_ROOT)} "
                  f"(pass --force to overwrite).", file=sys.stderr)
            skipped_existing += 1
            continue

        html = build_article_html(chapter)
        out_dir.mkdir(parents=True, exist_ok=True)
        # File writes use .atomic-equivalent — write to .tmp then rename.
        # Per CLAUDE.md: "All file writes use options: .atomic." Python's
        # closest equivalent is write-then-rename, atomic on POSIX.
        tmp = out_path.with_suffix(".html.tmp")
        tmp.write_text(html, encoding="utf-8")
        tmp.replace(out_path)
        print(f"  ch{n:02d}: wrote {out_path.relative_to(REPO_ROOT)} ({len(html)} bytes, {len(miscons)} sections)")
        wrote += 1

    print(file=sys.stderr)
    print(f"Wrote {wrote} article(s).", file=sys.stderr)
    if skipped_existing:
        print(f"Skipped {skipped_existing} existing file(s) (pass --force to overwrite).", file=sys.stderr)
    if skipped_no_misconceptions:
        print(f"Skipped {skipped_no_misconceptions} chapter(s) with insufficient misconceptions data.", file=sys.stderr)
    if skipped_anchor:
        print(f"Skipped {skipped_anchor} bespoke-anchor chapter(s) (Ch.1).", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
