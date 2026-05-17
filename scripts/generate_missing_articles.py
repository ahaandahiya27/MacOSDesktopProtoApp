#!/usr/bin/env python3
"""One-shot generator: produce a baseline HTML article for every concept
in `science_class7.json` that doesn't already have a bundled .html file.

The template pulls from the concept's `kidFriendly` + `textbook` +
`expert` explanation depths, the `useCases` list, and the `beyondTheBook`
narrative — all of which the content pipeline guarantees are populated
(see F7/F8/F9 invariant tests).

Run once to fill the G6 article-HTML coverage gap. Future concept edits
that need an article can re-run this for just the missing ones — the
script skips concepts that already have an HTML file.

    python3 scripts/generate_missing_articles.py
"""

import json
import os
import re
import sys
import html
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PACK = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs" / "science_class7.json"
ARTICLES = REPO_ROOT / "desktopAhaan" / "Resources" / "Articles"


def htmlescape(s: str) -> str:
    """Minimal HTML escape that keeps already-encoded entities like &mdash;
    intact. The JSON content occasionally uses em-dashes; pass them through.
    """
    # Don't double-encode existing entities.
    s = s.replace("&", "&amp;")
    s = s.replace("&amp;mdash;", "&mdash;")
    s = s.replace("&amp;amp;", "&amp;")
    s = s.replace("<", "&lt;").replace(">", "&gt;")
    # Convert Unicode em-dashes to entity for consistency with hand-authored files.
    s = s.replace("—", "&mdash;")
    s = s.replace("–", "&ndash;")
    s = s.replace("…", "&hellip;")
    s = s.replace("“", "&ldquo;").replace("”", "&rdquo;")
    s = s.replace("‘", "&lsquo;").replace("’", "&rsquo;")
    return s


def parse_id(concept_id: str):
    """ch05_t02_c01 -> (5, 2, 1)"""
    m = re.match(r"ch(\d+)_t(\d+)_c(\d+)", concept_id)
    if not m:
        return None
    return int(m.group(1)), int(m.group(2)), int(m.group(3))


def render_article(concept: dict, topic_id: str, chapter_num: int,
                   title_index: dict) -> str:
    title = htmlescape(concept["title"])
    expl = concept.get("explanations", {})
    one_line = htmlescape(expl.get("oneLine", ""))
    kid = htmlescape(expl.get("kidFriendly", ""))
    book = htmlescape(expl.get("textbook", ""))
    expert = htmlescape(expl.get("expert", ""))
    reasoning = htmlescape(concept.get("reasoning", ""))
    beyond = htmlescape(concept.get("beyondTheBook", ""))
    use_cases = concept.get("useCases", [])
    related = concept.get("relatedConceptIds", [])

    chinfo = parse_id(concept["id"])
    if chinfo is None:
        topic_num = 1
        concept_num = 1
    else:
        _, topic_num, concept_num = chinfo

    use_case_rows = []
    for uc in use_cases:
        uc_title = htmlescape(uc.get("title", ""))
        uc_desc = htmlescape(uc.get("description", ""))
        uc_domain = htmlescape(uc.get("domain", "")).capitalize()
        use_case_rows.append(
            f'      <li><strong>{uc_title}</strong> &mdash; {uc_desc} '
            f'<span class="domain-tag">[{uc_domain}]</span></li>'
        )
    use_cases_block = "\n".join(use_case_rows)

    # Resolve each related concept id to its readable title so the pill
    # row reads like "Acids — The Sour Family" instead of "ch05_t01_c01".
    related_pills = "\n".join(
        f'      <a class="pill" href="{rid}.html">'
        f'{htmlescape(title_index.get(rid, rid))}</a>'
        for rid in related
    )

    # Reading time: rough word-per-minute estimate.
    word_count = sum(
        len(v.split())
        for v in [kid, book, expert, reasoning, beyond]
    )
    read_minutes = max(2, round(word_count / 160))

    return f"""<!DOCTYPE html>
<html lang="en" data-article-id="{concept['id']}">
<head>
  <meta charset="utf-8">
  <title>{title} &middot; Class 7 Science</title>
  <link rel="stylesheet" href="ch{chapter_num:02d}_style.css">
</head>
<body>
  <article>
    <header class="hero">
      <p class="breadcrumb">Chapter {chapter_num} &middot; Topic {topic_num}, Concept {concept_num}</p>
      <h1>{title}</h1>
      <p class="subtitle">{one_line}</p>
      <p class="meta">&asymp; {read_minutes} min read &middot; for curious 12-year-olds</p>
    </header>

    <section class="lede">
      <p>{kid}</p>
    </section>

    <section>
      <h2>The textbook version</h2>
      <p>{book}</p>
    </section>

    <section>
      <h2>Why does this happen?</h2>
      <p>{reasoning}</p>
    </section>

    <section>
      <h2>Where you see this in the real world</h2>
      <ul>
{use_cases_block}
      </ul>
    </section>

    <section>
      <h2>Going deeper</h2>
      <p>{expert}</p>
    </section>

    <aside class="beyond-the-book">
      <h3>Beyond the book</h3>
      <p>{beyond}</p>
    </aside>

    <nav class="see-also">
      <h3>Related reading</h3>
      <a class="pill" href="ch{chapter_num:02d}_t{topic_num:02d}_overview.html">Topic {topic_num} Overview</a>
{related_pills}
    </nav>
  </article>
</body>
</html>
"""


def main() -> int:
    with PACK.open() as f:
        pack = json.load(f)

    # Build {concept_id: title} once so related-pill rendering can
    # resolve hrefs to human titles.
    title_index: dict = {}
    for ch in pack["chapters"]:
        for t in ch["topics"]:
            for c in t.get("concepts", []):
                title_index[c["id"]] = c.get("title", c["id"])

    created = 0
    skipped = 0
    regenerated = 0
    for ch in pack["chapters"]:
        ch_num = ch["number"]
        ch_dir = ARTICLES / f"Chapter{ch_num}"
        if not ch_dir.exists():
            continue  # only fill in chapters that already have a folder + css
        for t in ch["topics"]:
            tid = t["id"]
            for concept in t.get("concepts", []):
                target = ch_dir / f"{concept['id']}.html"
                # Skip if the chapter dir lacks a style.css — those chapters
                # haven't been set up at all.
                css = ch_dir / f"ch{ch_num:02d}_style.css"
                if not css.exists():
                    print(f"  ! no css for chapter {ch_num}, skipping {concept['id']}",
                          file=sys.stderr)
                    continue

                # If a previously generated file exists, only regenerate when
                # it carries our auto-generated signature. Don't trample
                # hand-authored articles.
                regen_only = False
                if target.exists():
                    existing = target.read_text(encoding="utf-8")
                    # Heuristic: our generator always emits the
                    # `class="beyond-the-book"` aside. Hand-authored Ch1
                    # articles use `class="fact-box"` etc.
                    if 'class="beyond-the-book"' in existing:
                        regen_only = True
                    else:
                        skipped += 1
                        continue

                html_doc = render_article(concept, tid, ch_num, title_index)
                target.write_text(html_doc, encoding="utf-8")
                if regen_only:
                    regenerated += 1
                    print(f"  ~ regenerated {target.relative_to(REPO_ROOT)}")
                else:
                    created += 1
                    print(f"  + wrote {target.relative_to(REPO_ROOT)}")

    print(f"\nDone. Created {created} new article(s); "
          f"{regenerated} regenerated; {skipped} hand-authored skipped.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
