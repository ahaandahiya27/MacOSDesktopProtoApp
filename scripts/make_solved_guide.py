#!/usr/bin/env python3
"""Generate a "<chapter>_SolvedGuide.html" from a paper's QuestionPaper.md
+ Solutions.md pair, matching the design system the user shipped for
Science Ch13.

Output: a single self-contained HTML doc with hero card, TOC,
topic-clustered Q cards (each with correct option highlighted +
worked solution prose), and a closing cheat-sheet section.

Usage:
    python3 scripts/make_solved_guide.py \
        --question-paper TestPapers/Maths_Ch15_FindingTheUnknown_QuestionPaper.md \
        --solutions      TestPapers/Maths_Ch15_FindingTheUnknown_Solutions.md \
        --out            desktopAhaan/Resources/TestPapers/Maths_Ch15_FindingTheUnknown_SolvedGuide.html \
        --paper          maths_ch15
"""
from __future__ import annotations

import argparse
import html as html_lib
import re
import sys
from dataclasses import dataclass
from pathlib import Path


@dataclass
class Question:
    number: int
    stem: str
    options: list[str]          # ["A text", "B text", "C text", "D text"]
    correct: str                # "A" / "B" / "C" / "D"
    explanation: str


# Cluster definitions per paper. Add new clusters here when authoring a
# new paper. Each entry is (cluster-title, key-takeaway-rule, [Q nums]).
CLUSTERS_BY_PAPER: dict[str, tuple[str, list[tuple[str, str, list[int]]]]] = {
    "maths_ch15": (
        "Finding the Unknown",
        [
            ("Word → Equation",
             "Pick a letter for the unknown, translate each phrase literally, then equate. The verb is your equals sign.",
             [1, 2, 6, 15, 18, 29, 32, 45, 50, 60]),
            ("Brackets",
             "Multiply through the bracket FIRST, then collect like terms. Distribute, simplify, isolate.",
             [7, 23, 37, 48, 56]),
            ("Fractions",
             "Multiply both sides by the LCM (or cross-multiply if the equation is one fraction = another). Clear the denominators before transposing.",
             [4, 8, 16, 22, 27, 34, 40, 53, 59]),
            ("Variables on Both Sides",
             "Move all x-terms to one side and all constants to the other in ONE pass. Subtract the smaller x-coefficient to keep x positive.",
             [5, 17, 26, 31, 41]),
            ("Checking by Substitution",
             "Plug the candidate back into the ORIGINAL equation. LHS = RHS confirms; anything else means the candidate is wrong.",
             [9, 21, 36, 47, 51]),
            ("Patterns → Equation",
             "Read the rule that turns the position number into the term. Then equate that rule to the target value and solve.",
             [14, 25, 38, 44]),
            ("Age &amp; Number Problems",
             "Let x = today's value. Future = x + years; past = x − years. Set up the relation from the verbal condition.",
             [3, 10, 11, 24, 33, 42, 46, 54, 55, 57]),
            ("Money &amp; Coins",
             "Total value = (count) × (denomination), summed across coin types. Write one equation per stated condition.",
             [12, 20, 35, 58]),
            ("Geometry &amp; Sharing",
             "For perimeter: 2(l + b) = P. For angles in a triangle: sum to 180°. For sharing: write each share as a multiple of one variable, then equate to the total.",
             [13, 19, 28, 30, 39, 43, 49, 52]),
        ],
    ),
    "science_ch13": (
        "Motion &amp; Time",
        [
            ("Types of Motion", "", [1, 20, 39, 45, 51]),
            ("Measuring Time &amp; Clocks", "", [10, 14, 19, 36, 46]),
            ("The Pendulum", "", [9, 13, 23, 26, 30, 43, 56]),
            ("Calculating Speed, Distance &amp; Time", "", [3, 11, 17, 18, 31, 32, 42, 53, 54]),
            ("Unit Conversion &amp; Comparing Speeds", "", [4, 5, 16, 27, 29, 49, 59]),
            ("Uniform vs Non-uniform Motion", "", [2, 24, 33, 47, 50]),
            ("Average Speed", "", [6, 12, 22, 28, 38, 44, 55]),
            ("Distance–Time Graphs", "", [8, 15, 21, 25, 34, 37, 40, 41, 52, 57]),
            ("Comparing Journeys", "", [7, 35, 48, 58, 60]),
        ],
    ),
}


def parse_question_paper(text: str) -> dict[int, dict]:
    """Return {q_number: {"stem": str, "options": [str, str, str, str]}}."""
    out: dict[int, dict] = {}
    lines = text.split("\n")
    qhead = re.compile(r"^(\d+)\.\s+(.*)$")
    ohead = re.compile(r"^\s*\(([A-D])\)\s+(.*)$")
    cur_num = None
    cur_stem: list[str] = []
    cur_opts: dict[str, str] = {}

    def flush():
        nonlocal cur_num, cur_stem, cur_opts
        if cur_num is not None and len(cur_opts) == 4:
            out[cur_num] = {
                "stem": " ".join(cur_stem).strip(),
                "options": [cur_opts["A"], cur_opts["B"], cur_opts["C"], cur_opts["D"]],
            }
        cur_num, cur_stem, cur_opts = None, [], {}

    for raw in lines:
        m = qhead.match(raw)
        if m:
            flush()
            cur_num = int(m.group(1))
            cur_stem = [m.group(2)]
            continue
        m = ohead.match(raw)
        if m and cur_num is not None:
            cur_opts[m.group(1)] = m.group(2).strip()
            continue
        if cur_num is not None and not cur_opts:
            t = raw.strip()
            if t and not t.startswith("---"):
                cur_stem.append(t)
    flush()
    return out


def parse_solutions(text: str) -> dict[int, tuple[str, str]]:
    """Return {q_number: (correct_letter, explanation)}."""
    out: dict[int, tuple[str, str]] = {}
    lines = text.split("\n")
    head = re.compile(r"^\*\*(\d+)\.\s+\(([A-D])\)\*\*\s*(.*)$")
    cur_num = None
    cur_letter = None
    cur_expl: list[str] = []

    def flush():
        nonlocal cur_num, cur_letter, cur_expl
        if cur_num is not None and cur_letter is not None:
            prose = " ".join(cur_expl).strip()
            out[cur_num] = (cur_letter, prose)
        cur_num, cur_letter, cur_expl = None, None, []

    for raw in lines:
        m = head.match(raw)
        if m:
            flush()
            cur_num = int(m.group(1))
            cur_letter = m.group(2)
            cur_expl = [m.group(3)]
            continue
        if cur_num is not None:
            t = raw.strip()
            if t and not t.startswith("#") and not t.startswith("<!--") and not t.startswith("-->"):
                cur_expl.append(t)
    flush()
    return out


def merge(qpaper: dict, sols: dict) -> dict[int, Question]:
    out: dict[int, Question] = {}
    for n, q in qpaper.items():
        if n in sols:
            letter, expl = sols[n]
            out[n] = Question(
                number=n,
                stem=q["stem"],
                options=q["options"],
                correct=letter,
                explanation=expl,
            )
    return out


def numeric_bin_clusters(title: str, total: int) -> tuple[str, list[tuple[str, str, list[int]]]]:
    """Bulk-generator fallback. Group questions into 6 sets of 10
    ("Set 1 · Q1–Q10", "Set 2 · Q11–Q20", …). The rule column is
    left empty so cards don't show a misleading per-set hint."""
    bins: list[tuple[str, str, list[int]]] = []
    set_no = 1
    for start in range(1, total + 1, 10):
        end = min(start + 9, total)
        nums = list(range(start, end + 1))
        bins.append((f"Set {set_no} · Q{start}–Q{end}", "", nums))
        set_no += 1
    return (title, bins)


def render(paper_id: str, questions: dict[int, Question],
           bulk_title: str | None = None) -> str:
    if bulk_title is not None:
        title, clusters = numeric_bin_clusters(bulk_title, len(questions))
    elif paper_id in CLUSTERS_BY_PAPER:
        title, clusters = CLUSTERS_BY_PAPER[paper_id]
    else:
        raise SystemExit(f"unknown paper-id '{paper_id}'; add to CLUSTERS_BY_PAPER or use --bulk")

    def esc(s: str) -> str:
        return html_lib.escape(s, quote=False)

    # Hero stats. We don't have score data — show generic totals.
    correct_count = len(questions)
    pieces: list[str] = []
    pieces.append(STYLE_BLOCK_HEAD)
    pieces.append(f'<title>{esc(title)} — Complete Solved Guide (All 60)</title>')
    pieces.append(STYLE_BLOCK_BODY)
    pieces.append('<body><div class="wrap">')

    # Hero
    pieces.append(f"""  <header class="hero">
    <div class="eyebrow">Class 7 · Olympiad · All 60 Solved</div>
    <h1>{title}<br>All 60, fully solved</h1>
    <p>Every question worked out step by step. Correct answer is highlighted; the explanation walks the solve.</p>
    <div class="scoreband">
      <div class="pill"><b>60</b><span>Questions</span></div>
      <div class="pill"><b>240</b><span>Max marks (+4/−1/0)</span></div>
      <div class="pill"><b>90 min</b><span>Suggested time</span></div>
    </div>
  </header>""")

    # TOC
    pieces.append('  <nav class="toc"><h3>What\'s inside</h3><ol>')
    for ci, (cname, _rule, qs) in enumerate(clusters, start=1):
        pieces.append(f'    <li><a href="#cluster-{ci}">{cname} <span style="opacity:.6;font-size:.85em;">· {len(qs)} Q</span></a></li>')
    pieces.append('  </ol></nav>')

    # Clusters
    for ci, (cname, rule, qs) in enumerate(clusters, start=1):
        pieces.append(f'  <section class="cluster" id="cluster-{ci}">')
        pieces.append(f'    <div class="cluster-head"><div class="cluster-num">{ci}</div><h2>{cname}</h2></div>')
        if rule:
            pieces.append(f'    <div class="cluster-rule"><b>Key rule.</b> {esc(rule)}</div>')
        for n in qs:
            if n not in questions:
                continue
            q = questions[n]
            pieces.append('    <div class="q">')
            pieces.append('      <div class="qhead">')
            pieces.append(f'        <span class="qtag">Q{q.number}</span>')
            pieces.append('      </div>')
            pieces.append(f'      <p class="qtext">{esc(q.stem)}</p>')
            pieces.append('      <ul class="opts">')
            letters = ["A", "B", "C", "D"]
            for idx, opt in enumerate(q.options):
                letter = letters[idx]
                cls = " correct" if letter == q.correct else ""
                mark = '<span class="mk">✓</span>' if letter == q.correct else ""
                pieces.append(f'        <li class="{cls.strip()}"><span class="lab">{letter}</span><span>{esc(opt)}</span>{mark}</li>')
            pieces.append('      </ul>')
            pieces.append('      <div class="solve">')
            pieces.append('        <h4>Working</h4>')
            pieces.append(f'        <div class="step"><div class="n">✓</div><p>{esc(q.explanation)}</p></div>')
            pieces.append('      </div>')
            pieces.append('    </div>')
        pieces.append('  </section>')

    # Closing cheat sheet — only for hand-authored papers; bulk-mode
    # papers don't get a curated cheat-sheet because the per-paper rules
    # would have to be authored individually.
    if bulk_title is None:
        pieces.append("""  <aside class="cheat">
    <h2>Cheat-sheet</h2>
    <p class="sub">If you can do these five, you can do every question above.</p>
    <div class="rules">""")
        cheats = [
            ("Translate carefully.", "Let x = the unknown. The verb is your equals sign."),
            ("Clear denominators first.", "Multiply through by the LCM; THEN transpose."),
            ("Group all x on one side.", "Subtract the smaller coefficient; keep x positive."),
            ("Check by substitution.", "LHS must equal RHS after plugging x back."),
            ("Write one equation per condition.", "Two conditions → two equations (or one substituted into the other)."),
        ]
        for title2, body in cheats:
            pieces.append(f'      <div class="rule"><div class="star">★</div><div><b>{title2}</b><span>{esc(body)}</span></div></div>')
        pieces.append('    </div></aside>')

    pieces.append('  <div class="closer"><h2>You\'ve seen every one.</h2><p>Take the quiz again next week. Speed comes from confidence, and confidence comes from familiar moves.</p></div>')

    pieces.append('</div></body></html>')
    return "\n".join(pieces)


# ---------------------------------------------------------------------------
# Style block — copied from the user-supplied Science HTML so the Maths
# guide reads as a sibling, not a knockoff.
# ---------------------------------------------------------------------------

STYLE_BLOCK_HEAD = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">"""

STYLE_BLOCK_BODY = """<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Lexend:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root{
    --cream:#fbf7ee;--paper:#fff;--ink:#23302f;--soft-ink:#55635f;
    --teal:#0f8a7e;--teal-deep:#0a5f57;--teal-wash:#e4f3f0;
    --coral:#e2603f;--coral-wash:#fceae3;--gold:#e0a528;--gold-wash:#fbf2d9;
    --green:#3a9d5d;--green-wash:#e6f4ea;--line:#e7e0d2;
    --shadow:0 14px 40px -18px rgba(15,90,82,.35);
  }
  *{box-sizing:border-box;}
  body{margin:0;background:radial-gradient(circle at 12% 4%,#fdf3e0 0,transparent 40%),radial-gradient(circle at 88% 2%,#e8f4f1 0,transparent 35%),var(--cream);color:var(--ink);font-family:'Lexend',sans-serif;line-height:1.65;-webkit-font-smoothing:antialiased;}
  .wrap{max-width:840px;margin:0 auto;padding:32px 20px 80px;}
  .hero{background:linear-gradient(135deg,var(--teal) 0%,var(--teal-deep) 100%);color:#fff;border-radius:26px;padding:38px 34px;position:relative;overflow:hidden;box-shadow:var(--shadow);}
  .hero::after{content:"";position:absolute;right:-40px;top:-40px;width:200px;height:200px;background:radial-gradient(circle,rgba(255,255,255,.16),transparent 70%);}
  .hero .eyebrow{font-size:.8rem;letter-spacing:.18em;text-transform:uppercase;opacity:.8;font-weight:600;}
  .hero h1{font-family:'Fraunces',serif;font-weight:600;font-size:2.3rem;line-height:1.1;margin:.35em 0 .2em;}
  .hero p{margin:.4em 0 0;font-weight:300;font-size:1.05rem;max-width:50ch;opacity:.95;}
  .scoreband{display:flex;gap:12px;margin-top:24px;flex-wrap:wrap;}
  .pill{background:rgba(255,255,255,.14);border:1px solid rgba(255,255,255,.25);border-radius:14px;padding:9px 15px;}
  .pill b{font-family:'Fraunces',serif;font-size:1.4rem;display:block;line-height:1;}
  .pill span{font-size:.74rem;opacity:.85;}
  .toc{background:var(--paper);border:1px solid var(--line);border-radius:18px;padding:22px 26px;margin:26px 0 8px;box-shadow:0 8px 26px -20px rgba(0,0,0,.4);}
  .toc h3{font-family:'Fraunces',serif;margin:0 0 10px;color:var(--teal-deep);font-size:1.2rem;}
  .toc ol{margin:0;padding-left:20px;columns:2;column-gap:30px;}
  .toc li{margin:5px 0;font-size:.95rem;}
  .toc a{color:var(--teal);text-decoration:none;font-weight:500;}
  .toc a:hover{text-decoration:underline;}
  .cluster{margin-top:46px;scroll-margin-top:16px;}
  .cluster-head{display:flex;align-items:center;gap:14px;margin-bottom:4px;}
  .cluster-num{font-family:'Fraunces',serif;font-size:2.4rem;font-weight:700;color:var(--teal);line-height:1;opacity:.35;}
  .cluster-head h2{font-family:'Fraunces',serif;font-size:1.55rem;margin:0;color:var(--teal-deep);}
  .cluster-rule{background:var(--teal-wash);border-left:5px solid var(--teal);border-radius:0 14px 14px 0;padding:14px 20px;margin:14px 0 26px;font-size:1rem;}
  .cluster-rule b{color:var(--teal-deep);}
  .q{background:var(--paper);border:1px solid var(--line);border-radius:20px;padding:24px 26px;margin-bottom:22px;box-shadow:0 8px 26px -20px rgba(0,0,0,.4);}
  .qhead{display:flex;gap:8px;align-items:center;flex-wrap:wrap;margin-bottom:12px;}
  .qtag{display:inline-block;background:var(--ink);color:#fff;font-size:.72rem;font-weight:600;letter-spacing:.05em;padding:4px 11px;border-radius:8px;}
  .qtext{font-size:1.05rem;font-weight:500;margin:0 0 14px;}
  .opts{list-style:none;padding:0;margin:0 0 16px;display:grid;gap:7px;}
  .opts li{padding:8px 13px;border-radius:11px;border:1.5px solid var(--line);font-size:.95rem;display:flex;align-items:center;gap:10px;}
  .opts li .lab{font-weight:700;width:1.4em;}
  .opts li.correct{background:var(--green-wash);border-color:#a9dab9;color:#1f6d3a;font-weight:600;}
  .opts li .mk{margin-left:auto;font-size:.78rem;font-weight:700;color:var(--green);}
  .solve{background:#f8faf9;border-radius:14px;padding:4px 18px 10px;margin-bottom:12px;}
  .solve h4{font-family:'Fraunces',serif;color:var(--teal-deep);font-size:1rem;margin:14px 0 6px;}
  .step{display:flex;gap:11px;align-items:flex-start;margin:8px 0;}
  .step .n{flex:0 0 24px;height:24px;background:var(--teal);color:#fff;border-radius:50%;display:grid;place-items:center;font-size:.78rem;font-weight:700;margin-top:1px;}
  .step p{margin:0;font-size:.95rem;}
  .cheat{background:var(--teal-deep);color:#fff;border-radius:24px;padding:32px;margin-top:50px;box-shadow:var(--shadow);}
  .cheat h2{font-family:'Fraunces',serif;font-size:1.6rem;margin:0 0 6px;}
  .cheat p.sub{opacity:.8;margin:0 0 20px;font-weight:300;}
  .rules{display:grid;gap:12px;}
  .rule{display:flex;gap:13px;align-items:flex-start;background:rgba(255,255,255,.08);border-radius:14px;padding:13px 17px;}
  .rule .star{flex:0 0 auto;font-size:1.05rem;}
  .rule b{font-family:'Fraunces',serif;}
  .rule span{display:block;opacity:.9;font-size:.9rem;font-weight:300;}
  .closer{text-align:center;margin-top:40px;padding:0 10px;}
  .closer h2{font-family:'Fraunces',serif;color:var(--teal-deep);font-size:1.4rem;margin-bottom:.3em;}
  .closer p{color:var(--soft-ink);max-width:54ch;margin:.5em auto;}
  @media (max-width:560px){.hero h1{font-size:1.8rem;}.wrap{padding:20px 14px 60px;}.q{padding:18px 16px;}.toc ol{columns:1;}}
</style>
</head>"""


def derive_title_from_filename(stem: str) -> str:
    """Turn 'Science_Ch01_NutritionInPlants' into 'Nutrition in Plants'.
    Splits on _, drops the subject + chapter prefix, then inserts a
    space before each interior capital letter. Used by --bulk."""
    # Strip "_QuestionPaper" suffix if present (callers may pass either
    # the bare stem or the QuestionPaper-suffixed version).
    if stem.endswith("_QuestionPaper"):
        stem = stem[: -len("_QuestionPaper")]
    parts = stem.split("_")
    if len(parts) < 3:
        return stem
    # parts: [subject, "ChNN" or "SchNN", camelTitle, …]
    camel = "_".join(parts[2:])
    out = []
    for i, ch in enumerate(camel):
        if i > 0 and ch.isupper() and camel[i - 1].islower():
            out.append(" ")
        out.append(ch)
    return "".join(out)


def run_bulk(papers_dir: Path) -> int:
    """For every `*_QuestionPaper.md` in papers_dir, emit
    `<stem>_SolvedGuide.html` if it doesn't already exist."""
    qps = sorted(papers_dir.glob("*_QuestionPaper.md"))
    written = 0
    skipped_existing = 0
    skipped_no_sols = 0
    for qp in qps:
        stem = qp.name[: -len("_QuestionPaper.md")]
        sols_path = papers_dir / f"{stem}_Solutions.md"
        out_path = papers_dir / f"{stem}_SolvedGuide.html"
        if out_path.exists():
            skipped_existing += 1
            continue
        if not sols_path.exists():
            skipped_no_sols += 1
            print(f"  skip {stem}: no Solutions.md", file=sys.stderr)
            continue
        qpaper = parse_question_paper(qp.read_text(encoding="utf-8"))
        sols = parse_solutions(sols_path.read_text(encoding="utf-8"))
        questions = merge(qpaper, sols)
        if len(questions) < 50:
            print(f"  skip {stem}: only {len(questions)} merged questions", file=sys.stderr)
            continue
        title = derive_title_from_filename(stem)
        html_out = render(paper_id="<bulk>", questions=questions, bulk_title=title)
        out_path.write_text(html_out, encoding="utf-8")
        written += 1
        print(f"  ✔ {out_path.name} ({len(html_out)//1024} KB, {len(questions)} Q)")
    print(f"\nbulk done: wrote {written}, kept {skipped_existing} existing, "
          f"skipped {skipped_no_sols} without Solutions.md")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--bulk", help="generate guides for EVERY paper in this dir "
                                   "(skips ones that already have a SolvedGuide.html)")
    ap.add_argument("--question-paper")
    ap.add_argument("--solutions")
    ap.add_argument("--out")
    ap.add_argument("--paper", choices=list(CLUSTERS_BY_PAPER.keys()))
    args = ap.parse_args()

    if args.bulk:
        return run_bulk(Path(args.bulk))

    if not (args.question_paper and args.solutions and args.out and args.paper):
        ap.error("either --bulk DIR or all of --question-paper/--solutions/--out/--paper required")

    qpaper_text = Path(args.question_paper).read_text(encoding="utf-8")
    sols_text = Path(args.solutions).read_text(encoding="utf-8")
    qpaper = parse_question_paper(qpaper_text)
    sols = parse_solutions(sols_text)
    questions = merge(qpaper, sols)

    print(f"parsed {len(questions)} questions (expected 60)")
    if len(questions) != 60:
        print("WARN: expected 60 questions", file=sys.stderr)

    html_out = render(args.paper, questions)
    Path(args.out).write_text(html_out, encoding="utf-8")
    print(f"wrote {args.out} ({len(html_out)} bytes)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
