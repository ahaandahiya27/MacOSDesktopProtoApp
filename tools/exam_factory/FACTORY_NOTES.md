# Prompt — Class 7 Olympiad Paper Factory (random Science + Maths chapters)

You generate study-ready practice papers for a confident Class 7 student. Each paper
= **one question-paper PDF** + **one detailed solutions HTML**, in the SAME style and
quality as the existing files in `/Users/mac/Documents/Claude/Projects/hello/`:
`BOSS_PAPER_100_MCQ.pdf` and `BOSS_PAPER_100_Solutions.html` (built by
`gen_solutions_v2.py` — reuse its SVG diagram helpers + CSS as your template).
This is content-only work (no app code), so there is no Big-Sur/build risk.

## Parameters (defaults — change only if I tell you)
- Papers to make this run: **5** (then stop, unless told to continue).
- Chapters per paper: **3**, randomly chosen — at least **1 Science and 1 Maths** in each (mix the third either way).
- Questions per paper: **100**, all single-correct **MCQ**, mixed order.
- Level: **toughest-of-tough Olympiad** but strictly within **Class 7 scope**, in **simple language** (a bright child must understand the wording even if the thinking is hard). Test critical thinking, not recall.

## Chapter pool (Class 7)
Prefer the real chapter names the child studies — read them from the app packs if reachable:
`…/desktopAhaan/Subjects/Packs/science_class7.json` and `maths_class7.json` (use each file's `chapters[].title`). If not reachable, use the standard NCERT Class 7 lists:
- **Science:** Nutrition in Plants; Nutrition in Animals; Heat; Acids, Bases & Salts; Physical & Chemical Changes; Weather/Climate & Adaptations; Winds, Storms & Cyclones; Soil; Respiration in Organisms; Transportation in Animals & Plants; Reproduction in Plants; Motion & Time; Electric Current & its Effects; Light; Forests; Wastewater Story.
- **Maths:** Integers; Fractions & Decimals; Data Handling; Simple Equations; Lines & Angles; The Triangle & its Properties; Comparing Quantities; Rational Numbers; Perimeter & Area; Algebraic Expressions; Exponents & Powers; Symmetry; Arithmetic Expressions (order of operations).
Keep selections **varied across papers** (see manifest); don't reuse the same trio twice.

## Per-paper procedure
1. **Pick chapters** (random, per rules above). Log them.
2. **Author 100 MCQs**, MIXED so no two consecutive questions are from the same chapter, spread roughly evenly across the 3 chapters. Each question: a clear stem + four options (A–D), **exactly one correct**. Favour application, multi-step reasoning, "compare/which-is-true", traps with plausible distractors. Keep numbers and contexts Class-7-appropriate. (For Science avoid out-of-syllabus depth e.g. no Ohm's-law numericals, no enzyme biochemistry; for Maths keep within the chapter's tools.)
3. **Verify correctness BEFORE rendering:** re-compute every Maths item; re-check every Science fact; confirm each question has one and only one defensible correct option. Fix any ambiguity.
4. **Render two files** (reuse the toolkit):
   a. **Question-paper PDF** — questions + 4 choices only, NO answers. Header with the 3 chapter names + marking scheme (+4 / −1 / 0) + space note. (Use reportlab Platypus, A4, KeepTogether per question — same look as BOSS_PAPER_100_MCQ.pdf. Sanitize unicode: keep × ÷, replace −/→/— with safe chars.)
   b. **Solutions HTML** — for EVERY question: the question with the **correct option highlighted green**, a "Correct answer" bar, then an explanation box containing: **The idea** (concept from scratch), **Reasoning / step-by-step** working, a **diagram where it helps** (reuse the SVG helpers: series circuit, electromagnet, compass, fuse, cells, number line, distributive area model, neutralisation arrow, indicator colour table — and add new simple SVGs for other chapters as needed, pure inline SVG), **Why the other options miss** (address each distractor), and **a real-life use-case**. Same CSS/look as BOSS_PAPER_100_Solutions.html.
5. **Self-check the rendered files:** 100 questions, 4 options each, 100 answer bars, 100 "why-others" + 100 use-case boxes, no missing explanations, PDF page count sane. Fix and re-render if any count is off.

## Output layout
Save under `/Users/mac/Documents/Claude/Projects/hello/ExamPapers/`:
- `Paper_<NN>_<shortchapters>/QuestionPaper.pdf`
- `Paper_<NN>_<shortchapters>/Questions.md`
- `Paper_<NN>_<shortchapters>/Solutions.html`
Maintain `/Users/mac/Documents/Claude/Projects/hello/ExamPapers/PAPERS_MANIFEST.md`:
one row per paper — number, date, the 3 chapters, question split per chapter, and a ✓ once its self-check passed. Read it first each run to continue numbering and avoid repeating chapter trios.

## Quality bar / rules
- **Balance the answer key:** the correct option must be spread roughly evenly across A/B/C/D (~25% each), NOT clustered on B/C. Shuffle each question's options and keep the "why the other options miss" notes tied to each option's CONTENT so the letters stay correct after shuffling. (The `examfactory.py` engine does this automatically — reuse it.)
- Accuracy first: a wrong answer key or an ambiguous question is the worst failure — verify before shipping each paper.
- Simple wording, tough thinking. No content unsafe or inappropriate for a child.
- One correct option per question; distractors must be plausible but clearly wrong on reasoning.
- Keep each paper's 3 chapters genuinely mixed in order.
- Don't fabricate facts; stay within Class 7 syllabus.

## USE THE ENGINE (do not re-invent rendering)
Work inside `/Users/mac/Documents/Claude/Projects/hello/ExamPapers/`. A ready engine
`examfactory.py` already renders the question PDF + balanced solutions HTML + manifest.
Write one `make_paper_<NN>.py` that imports it and supplies content-keyed items:

```python
from examfactory import build_paper, C, steps, U   # + define small inline SVG diagrams as needed
labels={"X":"Chapter A","Y":"Chapter B","Z":"Maths Chapter"}
items=[
  # (chapter_key, stem, correct_text, main_html, [(distractor, why_wrong) x3])
  ("X","stem...","correct...", C("the idea...")+steps("...")+U("real-life..."),
     [("wrong1","why"),("wrong2","why"),("wrong3","why")]),
  # ... exactly 100 items, interleaved so no two consecutive share a chapter ...
]
build_paper("<NN>","Chapter A · Chapter B · Maths Chapter","ShortName_NoSpaces", labels, items)
```
`build_paper` AUTOMATICALLY balances the correct option to ~25% A/B/C/D and matches the
"why-wrong" notes to each option's content — so you only author content, never letters.
Run it with `python3 make_paper_<NN>.py`; it prints the answer spread and writes the files.
SELF-CHECK after running: 100 correct-highlights, 100 answer bars, 100 why-wrong + 100
use-case boxes (grep the Solutions.html). Fix and re-run if any count is off.

## LOOP BEHAVIOUR (when started by run_papers.sh)
Produce **exactly ONE new paper per invocation**, then stop — the launcher relaunches you
for the next. Read PAPERS_MANIFEST.md first to choose the next number and a chapter trio not
already used (once fresh chapters run out, REVISIT chapters but write entirely NEW questions;
never copy earlier questions). Always at least 1 Science + 1 Maths per paper.

Begin: read PAPERS_MANIFEST.md (create if absent), pick the next unused/varied trio, author one
full balanced paper via the engine, self-check it, confirm it logged, then stop.
