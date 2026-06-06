#!/usr/bin/env python3
"""Structural validator for the Olympiad test papers.

Usage:
    python3 validate_paper.py <QuestionPaper.md> <Solutions.md>
    python3 validate_paper.py --all        # validate both papers in this folder

Checks, for a (QuestionPaper, Solutions) pair:
  * exactly 60 questions, numbered 1..60 contiguous (no gaps, no dupes);
  * every question presents options (A) (B) (C) (D);
  * the Solutions answer-key has exactly 60 entries; every answer in {A,B,C,D};
  * no duplicate question stems (whitespace-normalised).

Exit code 0 = all green; non-zero = at least one failure (message printed).
"""
import re
import sys
import os

OPT = ("A", "B", "C", "D")


def parse_questions(qp_text):
    """Return dict {qnum: {'stem': str, 'options': set()}} parsed from the paper."""
    lines = qp_text.splitlines()
    questions = {}
    cur = None
    # A question starts with "<n>." optionally indented. Options look like "(A) ...".
    qhead = re.compile(r"^\s*(\d{1,3})\.\s+(.*)$")
    opt = re.compile(r"^\s*\(([ABCD])\)\s+(.+)$")
    for ln in lines:
        m_opt = opt.match(ln)
        if m_opt and cur is not None:
            questions[cur]["options"].add(m_opt.group(1))
            continue
        m_q = qhead.match(ln)
        if m_q:
            # Avoid treating a line that is actually an option-less numeric note;
            # a real question head is followed (eventually) by options, which we
            # capture as we go. Accept it as a new question.
            n = int(m_q.group(1))
            cur = n
            questions[n] = {"stem": m_q.group(2).strip(), "options": set()}
    return questions


def parse_answer_key(sol_text):
    """Return dict {qnum: letter} parsed from the Solutions answer-key table
    and/or the bold per-question solution headers like '**12. (B)**'."""
    answers = {}
    # 1) Markdown table cells of the form "| 12 | B |". Rows pack several
    #    Q|Ans pairs sharing pipe separators, so use a lookahead for the
    #    trailing pipe instead of consuming it (otherwise alternate pairs are
    #    skipped).
    for m in re.finditer(r"\|\s*(\d{1,3})\s*\|\s*([ABCD])\s*(?=\|)", sol_text):
        answers[int(m.group(1))] = m.group(2)
    # 2) Cross-check with worked-solution headers "**12. (B)**"
    header_ans = {}
    for m in re.finditer(r"\*\*\s*(\d{1,3})\.\s*\(([ABCD])\)", sol_text):
        header_ans[int(m.group(1))] = m.group(2)
    return answers, header_ans


def norm(s):
    return re.sub(r"\s+", " ", s).strip().lower()


def validate(qp_path, sol_path):
    errors = []
    with open(qp_path, encoding="utf-8") as f:
        qp = f.read()
    with open(sol_path, encoding="utf-8") as f:
        sol = f.read()

    questions = parse_questions(qp)
    nums = sorted(questions)

    # exactly 60, contiguous 1..60
    if len(nums) != 60:
        errors.append(f"expected 60 questions, found {len(nums)}: {nums}")
    expected = list(range(1, 61))
    if nums != expected:
        missing = sorted(set(expected) - set(nums))
        extra = sorted(set(nums) - set(expected))
        if missing:
            errors.append(f"missing question numbers: {missing}")
        if extra:
            errors.append(f"unexpected question numbers: {extra}")

    # options A B C D for each question
    for n in nums:
        opts = questions[n]["options"]
        if opts != set(OPT):
            errors.append(f"Q{n}: options present = {sorted(opts)}, expected A,B,C,D")

    # duplicate stems
    seen = {}
    for n in nums:
        key = norm(questions[n]["stem"])
        if key in seen:
            errors.append(f"duplicate stem: Q{n} matches Q{seen[key]}")
        else:
            seen[key] = n

    # answer key
    answers, header_ans = parse_answer_key(sol)
    akeys = sorted(answers)
    if len(answers) != 60:
        errors.append(f"answer key has {len(answers)} entries, expected 60: {akeys}")
    if akeys and akeys != expected:
        miss = sorted(set(expected) - set(akeys))
        if miss:
            errors.append(f"answer key missing: {miss}")
    for n, a in answers.items():
        if a not in OPT:
            errors.append(f"answer for Q{n} is '{a}', not in A/B/C/D")

    # cross-check table vs worked-solution headers (catches key/solution drift)
    for n in sorted(set(answers) & set(header_ans)):
        if answers[n] != header_ans[n]:
            errors.append(
                f"Q{n}: answer-key table says {answers[n]} but worked solution "
                f"header says {header_ans[n]}"
            )
    # every question should also have a worked-solution header
    miss_sol = sorted(set(expected) - set(header_ans))
    if miss_sol:
        errors.append(f"missing worked-solution headers for: {miss_sol}")

    return errors


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    pairs = []
    if len(sys.argv) == 2 and sys.argv[1] == "--all":
        for base in sorted(os.listdir(here)):
            if base.endswith("_QuestionPaper.md"):
                sol = base.replace("_QuestionPaper.md", "_Solutions.md")
                pairs.append((os.path.join(here, base), os.path.join(here, sol)))
    elif len(sys.argv) == 3:
        pairs.append((sys.argv[1], sys.argv[2]))
    else:
        print(__doc__)
        return 2

    if not pairs:
        print("No (QuestionPaper, Solutions) pairs found.")
        return 2

    all_ok = True
    for qp, sol in pairs:
        name = os.path.basename(qp).replace("_QuestionPaper.md", "")
        if not os.path.exists(sol):
            print(f"[FAIL] {name}: solutions file not found: {sol}")
            all_ok = False
            continue
        errs = validate(qp, sol)
        if errs:
            all_ok = False
            print(f"[FAIL] {name}: {len(errs)} problem(s)")
            for e in errs:
                print(f"    - {e}")
        else:
            print(f"[ OK ] {name}: 60 questions, options A-D, 60-entry key, no dup stems, key matches solutions.")

    return 0 if all_ok else 1


if __name__ == "__main__":
    sys.exit(main())
