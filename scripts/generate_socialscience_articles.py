#!/usr/bin/env python3
"""
generate_socialscience_articles.py — generate the bundled read-mode HTML
articles for Class 7 Social Science (`socialscience_class7`) AND emit the
matching Swift article index in one pass, so the D.8/D.9 article bijection
lints (`check_article_entry_bundled.py` / `check_orphan_html.py`) pass by
construction — every bundled HTML is registered and every registered entry
has a file, because both are produced from the same loop.

Eight chapter-level article types per chapter, each keyed off an enrichment
array already present in the pack JSON (so there is no placeholder content):

    _overview     chapter summary + topic/concept map (links to the rest)
    _glossary     glossary[]        (Vocabulary Deck)
    _ncert_qa     ncertQA[]         (model answers)
    _beyond       deepDive[]        (Beyond the Book — Olympiad tier)
    _whatif       whatIfs[]         (thought experiments)
    _mistakes     misconceptions[]  (Common Mistakes)
    _miniproject  miniProjects[]    (hands-on activity)
    _timeline     timelines[]       (timeline / map story)

Each chapter folder also gets a self-contained `ssch{NN}_style.css` (a copy
of the shared article stylesheet, re-themed with a 🌏 geography palette).

Outputs:
  desktopAhaan/Resources/Articles/SocialScienceChapter{N}/ssch{NN}_*.html + _style.css
  desktopAhaan/Subjects/Articles/ArticleIndex+SocialScienceEntries.swift

Run from the repo root:
    python3 scripts/generate_socialscience_articles.py            # dry-run summary
    python3 scripts/generate_socialscience_articles.py --write     # write all files

Idempotent. Atomic writes (tmp + rename, the POSIX form of `options: .atomic`).
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PACK_PATH = REPO_ROOT / "desktopAhaan" / "Subjects" / "Packs" / "socialscience_class7.json"
ARTICLES_ROOT = REPO_ROOT / "desktopAhaan" / "Resources" / "Articles"
INDEX_SWIFT = (REPO_ROOT / "desktopAhaan" / "Subjects" / "Articles"
               / "ArticleIndex+SocialScienceEntries.swift")
STYLE_SRC = (REPO_ROOT / "desktopAhaan" / "Resources" / "Articles"
             / "SanskritChapter1" / "sch01_style.css")

# id -> human strand label, for breadcrumbs (from the authoritative chapter map).
STRAND = {
    "ssch01": "Geography", "ssch02": "Geography", "ssch03": "Geography",
    "ssch04": "History", "ssch05": "History", "ssch06": "History",
    "ssch07": "History", "ssch08": "Culture & History", "ssch09": "Civics",
    "ssch10": "Civics", "ssch11": "Economics", "ssch12": "Economics",
    "ssch13": "Economics", "ssch14": "Geography", "ssch15": "History",
    "ssch16": "History", "ssch17": "Society & Culture", "ssch18": "Civics",
    "ssch19": "Economics", "ssch20": "Economics",
}


def esc(text) -> str:
    s = "" if text is None else str(text)
    return (s.replace("&", "&amp;").replace("<", "&lt;")
             .replace(">", "&gt;").replace('"', "&quot;"))


def grade_label(raw: str) -> str:
    if not raw:
        return ""
    return raw.replace("class_", "Class ").replace("_", " ")


# Populated in main(): concept id -> concept title, for resolving deepDive
# `prerequisite`/`nextStepHint` fields that hold a raw concept id rather
# than prose (so the reader sees a real concept name, never "ssch15_t04_c02").
CONCEPT_TITLES: dict = {}
CONCEPT_ID_RE = __import__("re").compile(r'^ssch\d+_t\d+_c\d+$')


def humanise_ref(value) -> str:
    """If `value` is a bare concept id, swap it for the concept's title;
    otherwise return it unchanged. Returns "" for empty input."""
    s = "" if value is None else str(value).strip()
    if not s:
        return ""
    if CONCEPT_ID_RE.match(s):
        return CONCEPT_TITLES.get(s, "")  # drop unresolved ids rather than show them
    return s


# --------------------------------------------------------------------------
# HTML shell
# --------------------------------------------------------------------------

def shell(nn: str, article_id: str, doc_title: str, breadcrumb: str,
          h1: str, subtitle: str, meta: str, lede: str, body_sections: str,
          show_back_to_overview: bool = True) -> str:
    back = ""
    if show_back_to_overview:
        back = (f'    <footer class="returns">\n'
                f'      <a class="pill" href="ssch{nn}_overview.html">&larr; Chapter overview</a>\n'
                f'    </footer>\n')
    return (
        f'<!DOCTYPE html>\n'
        f'<html lang="en" data-article-id="{esc(article_id)}">\n'
        f'<head>\n'
        f'  <meta charset="utf-8">\n'
        f'  <title>{esc(doc_title)}</title>\n'
        f'  <link rel="stylesheet" href="ssch{nn}_style.css">\n'
        f'</head>\n'
        f'<body>\n'
        f'  <article>\n'
        f'    <header class="hero">\n'
        f'      <p class="breadcrumb">{breadcrumb}</p>\n'
        f'      <h1>{esc(h1)}</h1>\n'
        f'      <p class="subtitle">{esc(subtitle)}</p>\n'
        f'      <p class="meta">{meta}</p>\n'
        f'    </header>\n'
        f'\n'
        f'    <section class="lede">\n'
        f'      <p>{lede}</p>\n'
        f'    </section>\n'
        f'\n'
        f'{body_sections}'
        f'\n'
        f'{back}'
        f'  </article>\n'
        f'</body>\n'
        f'</html>\n'
    )


# --------------------------------------------------------------------------
# Per-type body builders. Each returns (body_sections_html, title, minutes)
# or None when the source array is empty (the type is then skipped).
# --------------------------------------------------------------------------

def b_overview(chapter, nn, strand):
    title = f"Chapter Overview — {chapter['title']}"
    topics = chapter.get("topics") or []
    cards = []
    for t in topics:
        concepts = t.get("concepts") or []
        items = []
        for c in concepts:
            one = (c.get("explanations") or {}).get("oneLine") or ""
            items.append(f'        <li><strong>{esc(c.get("title",""))}</strong>'
                         f'<span class="teaser">{esc(one)}</span></li>\n')
        cards.append(
            f'    <section>\n'
            f'      <h2>{esc(t.get("title",""))}</h2>\n'
            f'      <p>{esc(t.get("summary",""))}</p>\n'
            f'      <ol class="concept-list">\n{"".join(items)}      </ol>\n'
            f'    </section>\n')
    nav = (
        f'    <nav class="see-also">\n'
        f'      <h3>Explore this chapter</h3>\n'
        f'      <a class="pill" href="ssch{nn}_glossary.html">Vocabulary Deck</a>\n'
        f'      <a class="pill" href="ssch{nn}_ncert_qa.html">NCERT Q&amp;A</a>\n'
        f'      <a class="pill" href="ssch{nn}_beyond.html">Beyond the Book</a>\n'
        f'      <a class="pill" href="ssch{nn}_whatif.html">What If?</a>\n'
        f'      <a class="pill" href="ssch{nn}_mistakes.html">Common Mistakes</a>\n'
        f'      <a class="pill" href="ssch{nn}_miniproject.html">Mini Project</a>\n'
        f'      <a class="pill" href="ssch{nn}_timeline.html">Timeline</a>\n'
        f'    </nav>\n')
    body = "".join(cards) + nav
    return body, title, max(5, len(topics) + 3)


def b_glossary(chapter, nn, strand):
    entries = chapter.get("glossary") or []
    if not entries:
        return None
    lis = []
    for e in entries:
        term = esc((e.get("term") or "").strip())
        hindi = esc((e.get("hindiTerm") or "").strip())
        definition = esc((e.get("definition") or "").strip())
        example = esc((e.get("example") or "").strip())
        hindi_b = f' &middot; <em>{hindi}</em>' if hindi else ""
        ex_b = (f'<br><span class="teaser"><strong>Example:</strong> {example}</span>'
                if example else "")
        lis.append(f'        <li><strong>{term}</strong>{hindi_b} &mdash; {definition}{ex_b}</li>\n')
    body = (
        f'    <section>\n'
        f'      <h2>The {len(entries)} terms to know</h2>\n'
        f'      <ul>\n{"".join(lis)}      </ul>\n'
        f'    </section>\n'
        f'    <aside class="fact-box">\n'
        f'      <h3>&#128172; How to use this deck</h3>\n'
        f'      <p>Cover the right side of each line. Read just the term. Say its meaning out loud. '
        f'Move on only when you can do that for every term &mdash; not before.</p>\n'
        f'    </aside>\n')
    title = f"Vocabulary Deck — {chapter['title']}"
    return body, title, max(3, len(entries) // 2)


def b_ncert_qa(chapter, nn, strand):
    entries = chapter.get("ncertQA") or []
    if not entries:
        return None
    blocks = []
    for i, e in enumerate(entries, 1):
        page = e.get("textbookPage")
        page_b = (f' <span class="teaser">(NCERT page {esc(page)})</span>' if page else "")
        blocks.append(
            f'    <section>\n'
            f'      <h3>Q{i}. {esc(e.get("question",""))}{page_b}</h3>\n'
            f'      <p>{esc(e.get("modelAnswer",""))}</p>\n'
            f'    </section>\n')
    body = "".join(blocks) + (
        f'    <aside class="kid-tip">\n'
        f'      <h3>&#128221; Revision tip</h3>\n'
        f'      <p>Read the question, hide the answer, and try to write three or four sentences of '
        f'your own. Then compare. The marks live in the reasons you give, not just the facts.</p>\n'
        f'    </aside>\n')
    title = f"NCERT Q&A — {chapter['title']}"
    return body, title, max(6, len(entries) * 2)


def b_beyond(chapter, nn, strand):
    entries = chapter.get("deepDive") or []
    if not entries:
        return None
    blocks = []
    for e in entries:
        grade = grade_label(e.get("gradeLevel", ""))
        grade_b = f' <span class="teaser">[{esc(grade)}]</span>' if grade else ""
        pre = humanise_ref(e.get("prerequisite"))
        nxt = humanise_ref(e.get("nextStepHint"))
        extra = ""
        if pre:
            extra += f'      <p><strong>You\'ll want to know first:</strong> {esc(pre)}</p>\n'
        if nxt:
            extra += (f'      <aside class="try-this">\n'
                      f'        <h3>&#128640; Go further</h3>\n'
                      f'        <p>{esc(nxt)}</p>\n'
                      f'      </aside>\n')
        blocks.append(
            f'    <section>\n'
            f'      <h2>{esc(e.get("title",""))}{grade_b}</h2>\n'
            f'      <p>{esc(e.get("body",""))}</p>\n'
            f'{extra}'
            f'    </section>\n')
    body = "".join(blocks)
    title = f"Beyond the Book — {chapter['title']}"
    return body, title, max(6, len(entries) * 3)


def b_whatif(chapter, nn, strand):
    entries = chapter.get("whatIfs") or []
    if not entries:
        return None
    blocks = []
    for e in entries:
        blocks.append(
            f'    <section>\n'
            f'      <h2>{esc(e.get("question",""))}</h2>\n'
            f'      <details class="check-understanding">\n'
            f'        <summary>Think first, then open to compare</summary>\n'
            f'        <p>{esc(e.get("answer",""))}</p>\n'
            f'      </details>\n'
            f'    </section>\n')
    body = "".join(blocks)
    title = f"What If? — {chapter['title']}"
    return body, title, max(6, len(entries) * 3)


def b_mistakes(chapter, nn, strand):
    entries = chapter.get("misconceptions") or []
    if not entries:
        return None
    blocks = []
    for e in entries:
        blocks.append(
            f'    <section>\n'
            f'      <aside class="warning-box">\n'
            f'        <h3>&#10060; Many kids think&hellip;</h3>\n'
            f'        <p>{esc(e.get("kidsThink",""))}</p>\n'
            f'      </aside>\n'
            f'      <aside class="kid-tip">\n'
            f'        <h3>&#9989; Actually&hellip;</h3>\n'
            f'        <p>{esc(e.get("actually",""))}</p>\n'
            f'      </aside>\n'
            f'    </section>\n')
    body = "".join(blocks)
    title = f"Common Mistakes — {chapter['title']}"
    return body, title, max(4, len(entries) * 2)


def b_miniproject(chapter, nn, strand):
    entries = chapter.get("miniProjects") or []
    if not entries:
        return None
    blocks = []
    for e in entries:
        emoji = e.get("emoji") or "🛠️"
        needs = "".join(f'        <li>{esc(x)}</li>\n' for x in (e.get("needs") or []))
        steps = "".join(f'        <li>{esc(x)}</li>\n' for x in (e.get("steps") or []))
        obs = e.get("expectedObservation")
        why = e.get("whyItWorks")
        mins = e.get("estimatedMinutes")
        mins_b = f' <span class="teaser">(about {esc(mins)} min)</span>' if mins else ""
        tail = ""
        if obs:
            tail += (f'      <aside class="real-world">\n'
                     f'        <h3>&#128064; What you should see</h3>\n'
                     f'        <p>{esc(obs)}</p>\n'
                     f'      </aside>\n')
        if why:
            tail += (f'      <aside class="fact-box">\n'
                     f'        <h3>&#129504; Why it works</h3>\n'
                     f'        <p>{esc(why)}</p>\n'
                     f'      </aside>\n')
        blocks.append(
            f'    <section>\n'
            f'      <h2>{esc(emoji)} {esc(e.get("title",""))}{mins_b}</h2>\n'
            f'      <h3>What you need</h3>\n'
            f'      <ul>\n{needs}      </ul>\n'
            f'      <h3>Steps</h3>\n'
            f'      <ol>\n{steps}      </ol>\n'
            f'{tail}'
            f'    </section>\n')
    body = "".join(blocks)
    title = f"Mini Project — {chapter['title']}"
    return body, title, 25


def b_timeline(chapter, nn, strand):
    entries = chapter.get("timelines") or []
    if not entries:
        return None
    blocks = []
    for tl in entries:
        steps = []
        for s in (tl.get("steps") or []):
            steps.append(
                f'        <li><span class="year">{esc(s.get("label",""))}</span><br>'
                f'{esc(s.get("body",""))}</li>\n')
        blocks.append(
            f'    <section>\n'
            f'      <h2>{esc(tl.get("title",""))}</h2>\n'
            f'      <p>{esc(tl.get("intro",""))}</p>\n'
            f'      <ul class="timeline">\n{"".join(steps)}      </ul>\n'
            f'    </section>\n')
    body = "".join(blocks)
    title = f"Timeline — {chapter['title']}"
    return body, title, max(5, len(entries) * 4)


# suffix -> (builder, default lede). Order matters for the index file layout.
TYPES = [
    ("_overview", b_overview,
     "This is your map of the whole chapter. Skim it first to see where you are going, "
     "then dive into any topic or open one of the read-mode articles linked at the bottom."),
    ("_glossary", b_glossary,
     "These are the chapter's key words, drawn from its own concept list. Knowing the words "
     "is what makes you confident in the questions and the exam."),
    ("_ncert_qa", b_ncert_qa,
     "Model answers to the chapter's textbook questions &mdash; the kind of full, reasoned "
     "answers that score well. Read them as worked examples, not as something to memorise."),
    ("_beyond", b_beyond,
     "Ready for more? These extensions take the chapter's ideas a few classes further &mdash; "
     "toward the depth a curious student or an Olympiad needs. Take them slowly."),
    ("_whatif", b_whatif,
     "History, geography and society are full of 'what if' turning points. Think about each "
     "question yourself first &mdash; then open the panel to compare your reasoning."),
    ("_mistakes", b_mistakes,
     "Every topic has traps that catch careful students. Here are the most common ones for this "
     "chapter, paired with what is actually true, so you can sidestep them."),
    ("_miniproject", b_miniproject,
     "Reading teaches; doing sticks. Try this hands-on activity at home &mdash; it turns the "
     "chapter's idea into something you can see, build, or trace for yourself."),
    ("_timeline", b_timeline,
     "Big changes make more sense as a sequence. Walk this timeline from start to finish to see "
     "how one step led to the next."),
]


def build_chapter(chapter):
    """Return list of (suffix, filename, html, title, minutes) for one chapter."""
    n = chapter["number"]
    nn = f"{n:02d}"
    cid = chapter["id"]
    strand = STRAND.get(cid, "Social Science")
    out = []
    for suffix, builder, lede in TYPES:
        article_id = f"{cid}{suffix}"
        result = builder(chapter, nn, strand)
        if result is None:
            continue
        body_sections, title, minutes = result
        doc_title = f"{title} · Class 7 Social Science"
        h1 = title.split(" — ")[0]
        breadcrumb = f"Chapter {n} &middot; {esc(strand)} &middot; {esc(h1)}"
        subtitle = chapter.get("summary", "")[:160]
        meta = f"&#8776; {minutes} min &middot; read-mode &middot; 🌏 Social Science"
        show_back = (suffix != "_overview")
        html = shell(nn, article_id, doc_title, breadcrumb, h1, subtitle, meta,
                     lede, body_sections, show_back_to_overview=show_back)
        out.append((suffix, f"{cid}{suffix}.html", html, title, minutes))
    return out


def emit_swift(all_entries) -> str:
    """all_entries: list of (article_id, filename, title, folder, minutes)."""
    lines = []
    lines.append("import Foundation\n")
    lines.append("")
    lines.append("// Social Science (NCERT Class 7, \"Exploring Society: India and Beyond\")")
    lines.append("// article registrations. Generated by")
    lines.append("// scripts/generate_socialscience_articles.py from")
    lines.append("// socialscience_class7.json — do not hand-edit; re-run the generator.")
    lines.append("// Keys carry the `ssch` prefix (ssch01..ssch20), distinct from Science's")
    lines.append("// `ch*`, Maths's `mch*` and Sanskrit's `sch*` namespaces. Merged into")
    lines.append("// ArticleIndex.entries in ArticleIndex.swift.")
    lines.append("extension ArticleIndex {")
    lines.append("    static let socialScienceEntries: [String: ArticleEntry] = [")
    for aid, filename, title, folder, minutes in all_entries:
        t = title.replace("\\", "\\\\").replace('"', '\\"')
        lines.append(
            f'        "{aid}": ArticleEntry(id: "{aid}", filename: "{filename}", '
            f'title: "{t}", chapterFolder: "{folder}", estimatedMinutes: {minutes}),')
    lines.append("    ]")
    lines.append("}")
    return "\n".join(lines) + "\n"


def atomic_write(path: Path, text: str):
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(text, encoding="utf-8")
    tmp.replace(path)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--write", action="store_true")
    args = ap.parse_args()

    pack = json.loads(PACK_PATH.read_text(encoding="utf-8"))
    style_css = STYLE_SRC.read_text(encoding="utf-8")

    # Build the concept id -> title map so deepDive prerequisite/nextStep
    # fields that hold a bare concept id render as a real concept name.
    for ch in pack["chapters"]:
        for t in ch.get("topics", []):
            for c in t.get("concepts", []):
                CONCEPT_TITLES[c["id"]] = c.get("title", "")

    all_entries = []  # (article_id, filename, title, folder, minutes)
    total_html = 0
    for chapter in pack["chapters"]:
        n = chapter["number"]
        nn = f"{n:02d}"
        folder_rel = f"Articles/SocialScienceChapter{n}"
        out_dir = ARTICLES_ROOT / f"SocialScienceChapter{n}"
        files = build_chapter(chapter)
        for suffix, filename, html, title, minutes in files:
            aid = f"{chapter['id']}{suffix}"
            all_entries.append((aid, filename, title, folder_rel, minutes))
            total_html += 1
            if args.write:
                atomic_write(out_dir / filename, html)
        if args.write:
            atomic_write(out_dir / f"ssch{nn}_style.css", style_css)

    swift = emit_swift(all_entries)
    if args.write:
        atomic_write(INDEX_SWIFT, swift)
        print(f"Wrote {total_html} HTML files across 20 chapters + 20 style.css files.")
        print(f"Wrote {INDEX_SWIFT.relative_to(REPO_ROOT)} with {len(all_entries)} entries.")
    else:
        print(f"[dry-run] would write {total_html} HTML + 20 css + index "
              f"({len(all_entries)} entries). Pass --write.")
        # show first chapter's overview as a sample
        sample = build_chapter(pack["chapters"][0])[0][2]
        print("\n----- sample (ssch01_overview.html, first 30 lines) -----")
        print("\n".join(sample.splitlines()[:30]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
