#!/usr/bin/env python3
"""Generate docs/CHAPTER_MANIFEST.md — auto-computed coverage matrix.

Walks `desktopAhaan/Subjects/Packs/science_class7.json` and counts, for
every chapter:
  - number of topics
  - number of concepts (total + per topic)
  - number of questions (total + per topic, plus *_topup_*)
  - number of bundled HTML articles (concept + overview)
  - presence of style.css

The output table is what G13 in `docs/ISSUE_CATEGORIES.md` asks for —
the previous version was hand-maintained, this one is reproducible.

Run from the repo root:
    python3 scripts/generate_chapter_manifest.py
The file is rewritten in place; commit the diff alongside content
changes so the matrix stays honest.
"""

import json
import os
import sys
from pathlib import Path


def main() -> int:
    repo_root = Path(__file__).resolve().parent.parent
    pack_path = repo_root / "desktopAhaan" / "Subjects" / "Packs" / "science_class7.json"
    articles_root = repo_root / "desktopAhaan" / "Resources" / "Articles"
    out_path = repo_root / "docs" / "CHAPTER_MANIFEST.md"

    if not pack_path.exists():
        print(f"missing: {pack_path}", file=sys.stderr)
        return 1

    with pack_path.open() as f:
        pack = json.load(f)

    rows = []
    for chapter in pack.get("chapters", []):
        ch_num = chapter.get("number")
        ch_id = chapter.get("id", "")
        ch_title = chapter.get("title", "")
        topics = chapter.get("topics", [])

        concepts_total = sum(len(t.get("concepts", [])) for t in topics)
        questions_total = sum(len(t.get("questions", [])) for t in topics)
        topup_questions = sum(
            1
            for t in topics
            for q in t.get("questions", [])
            if "_topup_" in q.get("id", "")
        )

        article_dir = articles_root / f"Chapter{ch_num}"
        if article_dir.exists():
            html_files = list(article_dir.glob("*.html"))
            css_present = (article_dir / f"ch{ch_num:02d}_style.css").exists()
            html_count = len(html_files)
        else:
            html_count = 0
            css_present = False

        rows.append(
            {
                "ch": ch_num,
                "id": ch_id,
                "title": ch_title,
                "topics": len(topics),
                "concepts": concepts_total,
                "questions": questions_total,
                "topup": topup_questions,
                "html": html_count,
                "css": "✅" if css_present else "❌",
            }
        )

    rows.sort(key=lambda r: r["ch"] if r["ch"] is not None else 0)

    lines: list[str] = []
    lines.append("# desktopAhaan — Chapter Coverage Matrix")
    lines.append("")
    lines.append("**Auto-generated** by `scripts/generate_chapter_manifest.py`. ")
    lines.append("Do not edit by hand — re-run the script after content changes.")
    lines.append("")
    pack_version = pack.get("version", "?")
    pack_generated = pack.get("generatedAt", "?")
    lines.append(f"Source pack: `science_class7.json` v{pack_version} ({pack_generated})")
    lines.append("")
    lines.append("| Ch | Title | Topics | Concepts | Questions | (+topup) | HTML files | style.css |")
    lines.append("|---:|-------|-------:|---------:|----------:|---------:|-----------:|:---------:|")
    for r in rows:
        lines.append(
            f"| {r['ch']:>2} | {r['title']} | {r['topics']} | {r['concepts']} | "
            f"{r['questions']} | {r['topup']} | {r['html']} | {r['css']} |"
        )

    total_topics = sum(r["topics"] for r in rows)
    total_concepts = sum(r["concepts"] for r in rows)
    total_questions = sum(r["questions"] for r in rows)
    total_topup = sum(r["topup"] for r in rows)
    total_html = sum(r["html"] for r in rows)
    css_count = sum(1 for r in rows if r["css"] == "✅")

    lines.append(
        f"| | **Total** | **{total_topics}** | **{total_concepts}** | "
        f"**{total_questions}** | **{total_topup}** | **{total_html}** | "
        f"**{css_count}/{len(rows)}** |"
    )
    lines.append("")
    lines.append("## How to read this")
    lines.append("")
    lines.append("- **Topics / Concepts / Questions** come from the JSON pack.")
    lines.append("- **+topup** is the subset of questions whose id contains `_topup_`")
    lines.append("  — these were added in later bulk content passes; they're still")
    lines.append("  scoped to a topic but use a non-sequential id.")
    lines.append("- **HTML files** counts every `.html` in `Resources/Articles/Chapter<N>/`")
    lines.append("  including `_overview` files. A concept without an HTML file falls back")
    lines.append("  to a system text view; the test `testAllArticleHTMLFilesExistInBundle`")
    lines.append("  asserts ≥ 90% coverage.")
    lines.append("- **style.css** is the per-chapter article stylesheet — ✅ when present.")
    lines.append("")

    out_path.parent.mkdir(parents=True, exist_ok=True)
    with out_path.open("w") as f:
        f.write("\n".join(lines) + "\n")
    print(f"wrote {out_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
