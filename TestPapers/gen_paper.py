#!/usr/bin/env python3
"""Generate a (QuestionPaper.md, Solutions.md) pair from an authored content JSON.

The author supplies, per question: a stem, the correct-answer TEXT, three
distractor TEXTS, and a worked-solution explanation that refutes the distractors
*by paraphrase* (never by option letter). This script assigns each question's
correct-answer LETTER from a balanced sequence (exactly 15 each of A/B/C/D, no
run longer than 3, seeded per-chapter so different chapters get different keys),
lays the options out in A–D order, and emits both files in the exact format that
validate_paper.py + make_html.py expect. Output is validator-green by construction.

Usage:
    python3 gen_paper.py <content.json> <OutputStem>
        e.g. python3 gen_paper.py /tmp/ssch06.json SocialScience_Ssch06_TheAgeOfReorganisation

content.json schema:
{
  "subject":      "Social Science (NCERT Class 7)",   # full label for header row
  "subjectLine":  "Social Science (Class 7)",          # short, for the H1/solutions title
  "chapterNum":   6,
  "chapterTitle": "The Age of Reorganisation",
  "chapterId":    "ssch06",                            # used as the RNG seed
  "trapsLine":    "the chapter's classic traps are ...",  # one sentence, appended to Instructions
  "coverage":     "multi-line coverage-matrix text (goes inside an HTML comment)",
  "questions": [
     {"stem": "...", "correct": "...", "distractors": ["...","...","..."], "sol": "..."},
     ... exactly 60 ...
  ]
}
"""
import json
import os
import random
import sys


def balanced_letters(seed_str):
    """60 letters, exactly 15 of each, no run longer than 3, deterministic per seed."""
    base = ["A"] * 15 + ["B"] * 15 + ["C"] * 15 + ["D"] * 15
    rng = random.Random("oly-key::" + seed_str)
    for _ in range(20000):
        seq = base[:]
        rng.shuffle(seq)
        ok = True
        run = 1
        for i in range(1, 60):
            if seq[i] == seq[i - 1]:
                run += 1
                if run > 3:
                    ok = False
                    break
            else:
                run = 1
        if ok:
            return seq
    raise RuntimeError("could not build a no-run>3 balanced sequence")


SLOTS = ("A", "B", "C", "D")


def build_qp(c, letters):
    L = []
    a = L.append
    a(f"# Olympiad Test Paper — {c['subjectLine']}")
    a(f"## Chapter {c['chapterNum']}: {c['chapterTitle']}")
    a("")
    a("| | |")
    a("|---|---|")
    a(f"| **Subject** | {c['subject']} |")
    a(f"| **Chapter** | {c['chapterNum']} — {c['chapterTitle']} |")
    a("| **Total Questions** | 60 (Multiple Choice, single correct) |")
    a("| **Maximum Marks** | 240 |")
    a("| **Suggested Time** | 90 minutes |")
    a("")
    a("**Marking scheme:** **+4** for each correct answer · **−1** for each wrong "
      "answer · **0** if unattempted.")
    a("")
    a("**Instructions:** Each question has four options (A), (B), (C), (D); exactly "
      "one is correct. " + c["trapsLine"] + " Do not write on this paper — mark "
      "answers on your answer sheet.")
    a("")
    a("---")
    a("")
    for i, q in enumerate(c["questions"]):
        n = i + 1
        correct_letter = letters[i]
        # lay out options: correct text at its assigned slot, distractors fill rest
        opts = {}
        opts[correct_letter] = q["correct"]
        rest = [s for s in SLOTS if s != correct_letter]
        for slot, dtext in zip(rest, q["distractors"]):
            opts[slot] = dtext
        a(f"{n}. {q['stem']}")
        for slot in SLOTS:
            a(f"   ({slot}) {opts[slot]}")
        a("")
    return "\n".join(L).rstrip() + "\n"


def build_solutions(c, letters):
    L = []
    a = L.append
    a(f"# Solutions — {c['subjectLine']}, Chapter {c['chapterNum']}: {c['chapterTitle']}")
    a("")
    a("Marking: **+4** correct, **−1** wrong, **0** unattempted. Maximum marks **240**.")
    a("")
    a("<!--")
    a(c["coverage"].rstrip())
    a("-->")
    a("")
    a("## Answer Key")
    a("")
    a("| Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans | Q | Ans |")
    a("|---|-----|---|-----|---|-----|---|-----|---|-----|---|-----|")
    # six columns: rows hold q, q+10, q+20, q+30, q+40, q+50
    for r in range(10):
        cells = []
        for col in range(6):
            qn = r + 1 + col * 10
            cells.append(f"{qn} | {letters[qn - 1]}")
        a("| " + " | ".join(cells) + " |")
    a("")
    counts = {s: letters.count(s) for s in SLOTS}
    a(f"Answer-key distribution: A = {counts['A']}, B = {counts['B']}, "
      f"C = {counts['C']}, D = {counts['D']}.")
    a("")
    a("---")
    a("")
    a("## Worked Solutions")
    a("")
    for i, q in enumerate(c["questions"]):
        n = i + 1
        a(f"**{n}. ({letters[i]})** {q['sol']}")
        a("")
    return "\n".join(L).rstrip() + "\n"


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        return 2
    content_path, stem = sys.argv[1], sys.argv[2]
    here = os.path.dirname(os.path.abspath(__file__))
    with open(content_path, encoding="utf-8") as f:
        c = json.load(f)
    qs = c["questions"]
    if len(qs) != 60:
        print(f"ERROR: expected 60 questions, got {len(qs)}")
        return 2
    for i, q in enumerate(qs):
        if len(q.get("distractors", [])) != 3:
            print(f"ERROR: Q{i+1} must have exactly 3 distractors")
            return 2
    letters = balanced_letters(c["chapterId"])
    qp = build_qp(c, letters)
    sol = build_solutions(c, letters)
    qp_path = os.path.join(here, stem + "_QuestionPaper.md")
    sol_path = os.path.join(here, stem + "_Solutions.md")
    with open(qp_path, "w", encoding="utf-8") as f:
        f.write(qp)
    with open(sol_path, "w", encoding="utf-8") as f:
        f.write(sol)
    print(f"wrote {qp_path}")
    print(f"wrote {sol_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
