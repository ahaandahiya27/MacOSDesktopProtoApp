# Olympiad Test Papers

Two printable, Olympiad-level test papers for a Class 7 student, authored to be
harder than a school unit test while staying strictly inside each chapter's
NCERT Class-7 concept scope (deeper, not off-syllabus).

| Paper | Subject | Chapter | Questions | Files |
|-------|---------|---------|-----------|-------|
| A | Science (Class 7) | 13 — Motion and Time | 60 MCQ | `Science_Ch13_MotionAndTime_*` |
| B | Maths (Class 7) | 15 — Finding the Unknown | 60 MCQ | `Maths_Ch15_FindingTheUnknown_*` |

Each paper ships as four files:
- `*_QuestionPaper.md` — the exam (60 numbered MCQs, options A–D, **no answers**).
- `*_Solutions.md` — answer-key table + a full step-by-step worked solution for every question, plus an auditable coverage matrix (HTML comment at the top).
- `*.html` — one self-contained, print-ready file: question paper, a page break, then the solutions.
- `*.pdf` — the same, generated from the HTML.

## Marking scheme (both papers)

- **+4** for each correct answer
- **−1** for each wrong answer
- **0** if unattempted
- **Maximum marks: 240** · **Suggested time: 90 minutes**

Each question has exactly four options (A) (B) (C) (D) with exactly one correct.
Math is written in plain-text / Unicode (e.g. `x²`, `½`, `≤`, `×`, `÷`, `→`) — no
LaTeX — so the papers render identically everywhere.

## Validate

The structural validator checks: exactly 60 contiguously-numbered questions, each
with options A–D; a 60-entry answer key with every answer in {A,B,C,D}; no
duplicate question stems; and that the answer-key table agrees with the
worked-solution headers.

```sh
cd TestPapers
python3 validate_paper.py --all
# or one pair:
python3 validate_paper.py Science_Ch13_MotionAndTime_QuestionPaper.md Science_Ch13_MotionAndTime_Solutions.md
```

## Re-generate the HTML

```sh
cd TestPapers
python3 make_html.py --all
```

## Print to PDF

The `.pdf` files are already generated. To re-make them, use whichever is
available (the `.html` is the canonical render source; the `.md` is the
canonical content source):

```sh
# Option 1 — headless Chrome / Brave / Edge (used to build the committed PDFs):
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="Science_Ch13_MotionAndTime.pdf" \
  "file://$PWD/Science_Ch13_MotionAndTime.html"

# Option 2 — pandoc or wkhtmltopdf, if installed:
pandoc Science_Ch13_MotionAndTime.html -o Science_Ch13_MotionAndTime.pdf
wkhtmltopdf Science_Ch13_MotionAndTime.html Science_Ch13_MotionAndTime.pdf
```

**Browser fallback (no tools needed):** open the `.html` file in any browser →
⌘P (Print) → "Save as PDF" → choose A4. The print CSS sizes it for A4 with the
marking header in a box and a page break before the solutions.
