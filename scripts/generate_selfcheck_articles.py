#!/usr/bin/env python3
"""
generate_selfcheck_articles.py — generate `ch{NN}_selfcheck.html`
for every chapter EXCEPT Ch.1 (bespoke anchor). Samples 5
representative questions from `chapter.topics[].questions` and
formats them as a self-quiz with answer-first-then-reveal flow.
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


def sample_questions(chapter: dict, count: int = 5) -> list:
    """Pick up to `count` questions spread across the chapter's
    topics. Prefer shortAnswer / mcq for clean rendering; skip
    matchTheFollowing (the article format doesn't render pairs
    well as text)."""
    all_qs = []
    for topic in chapter.get("topics", []):
        for q in topic.get("questions", []):
            if q.get("questionType") in ("matchTheFollowing",):
                continue
            all_qs.append(q)
    if not all_qs:
        return []
    # Pick evenly across the list (first, ~1/4, ~1/2, ~3/4, last).
    n = len(all_qs)
    if n <= count:
        return all_qs
    indices = [int(i * (n - 1) / (count - 1)) for i in range(count)]
    return [all_qs[i] for i in indices]


def question_html(index: int, q: dict, chapter_number: int) -> str:
    prompt = html_escape((q.get("prompt") or "").strip())
    answer = html_escape((q.get("answer") or "").strip())
    steps = q.get("solutionSteps") or []
    follow_up = ""
    if steps:
        # Use the first solution step as the explanation tail.
        first_step = html_escape(str(steps[0]).strip())
        follow_up = f"      <p><strong>Why:</strong> {first_step}</p>\n"
    return (
        f"\n    <section>\n"
        f"      <h2>Question {index} &mdash; from Chapter {chapter_number}</h2>\n"
        f"      <p>{prompt}</p>\n"
        f"      <aside class=\"connect-box\" style=\"margin:10px 0;\">\n"
        f"        <h3>&#129504; Answer in your head first</h3>\n"
        f"        <p>Don&#x27;t peek. Speak the answer out loud, then check.</p>\n"
        f"      </aside>\n"
        f"      <p><strong>Answer:</strong> {answer}</p>\n"
        f"{follow_up}"
        f"    </section>\n"
    )


def build_article_html(chapter: dict) -> str:
    n = chapter["number"]
    nn = f"{n:02d}"
    title_short = html_escape(chapter["title"])
    qs = sample_questions(chapter, 5)
    count = len(qs)
    if count < 3:
        return ""
    sections = "".join(question_html(i + 1, q, n) for i, q in enumerate(qs))

    return (
        f"<!DOCTYPE html>\n"
        f"<html lang=\"en\" data-article-id=\"ch{nn}_selfcheck\">\n"
        f"<head>\n"
        f"  <meta charset=\"utf-8\">\n"
        f"  <title>Self-Check &mdash; Chapter {n} &middot; {title_short}</title>\n"
        f"  <link rel=\"stylesheet\" href=\"ch{nn}_style.css\">\n"
        f"</head>\n"
        f"<body>\n"
        f"  <article>\n"
        f"    <header class=\"hero\">\n"
        f"      <p class=\"breadcrumb\">Chapter {n} &middot; Way of Learning &middot; Self-Check</p>\n"
        f"      <h1>Self-Check &mdash; Are You Ready for the Boss Quiz?</h1>\n"
        f"      <p class=\"subtitle\">{count} quick questions. Answer in your head before scrolling. No score saved &mdash; this is just for you.</p>\n"
        f"      <p class=\"meta\">&#8776; {count + 2} min &middot; honest-with-yourself level</p>\n"
        f"    </header>\n"
        f"\n"
        f"    <section class=\"lede\">\n"
        f"      <p>Take this self-check before opening the Boss Quiz on the chapter card. If you can answer all {count} confidently &mdash; without peeking at the answers &mdash; you&#x27;re ready.</p>\n"
        f"    </section>\n"
        f"{sections}\n"
        f"    <aside class=\"fact-box\">\n"
        f"      <h3>&#128221; How to use this</h3>\n"
        f"      <p>Cover the answer with your palm or scroll slowly. Speak the answer aloud. Hearing your own answer is twice as memorable as silently thinking it.</p>\n"
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
            print(f"  ch{n:02d}: skipping — too few sampleable questions.", file=sys.stderr)
            continue
        out_dir = ARTICLES_ROOT / f"Chapter{n}"
        out_path = out_dir / f"ch{n:02d}_selfcheck.html"
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
