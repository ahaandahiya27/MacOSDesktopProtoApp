#!/usr/bin/env python3
"""Rebalance the answer-key letter distribution of an Advanced MCQ triplet.

A few Advanced papers were authored with the correct option parked in the same
slot (e.g. 50/60 answers in position B) — a positional giveaway that violates
the authoring contract (≈15 each across A/B/C/D). This tool reorders the four
option lines of each question so the correct option lands on a balanced,
deterministic target letter, and rewrites the matching `**N. (X)**` heading in
the solutions file in lockstep. Worked prose references option *content*, never
letters, so reordering is content-preserving.

Usage:
  python3 scripts/rebalance_answer_key.py \
      --question-paper PATH_QuestionPaper.md \
      --solutions      PATH_Solutions.md

Idempotent in spirit: re-running reshuffles to the same target sequence, so the
distribution is stable at exactly 15/15/15/15 for a 60-question paper.
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

QHEAD = re.compile(r"^(\d+)\.\s+(.*)$")
OHEAD = re.compile(r"^(\s*)\(([A-D])\)\s+(.*)$")
SHEAD = re.compile(r"^\*\*(\d+)\.\s+\(([A-D])\)\*\*(.*)$")

# 15 fixed permutations of ABCD → each letter appears exactly once per cycle,
# so over 60 questions every letter is the correct slot exactly 15 times.
# Deterministic (no RNG) and visually scattered.
CYCLES = [
    "CADB", "BDAC", "ACDB", "DBCA", "CABD",
    "ADBC", "BCAD", "DACB", "CBDA", "ABDC",
    "DCAB", "BDCA", "ADCB", "CDBA", "BACD",
]
LETTERS = "ABCD"


def target_letters(n: int) -> list[str]:
    seq = "".join(CYCLES)
    if n > len(seq):
        raise SystemExit(f"only {len(seq)} target slots defined; paper has {n} questions")
    return list(seq[:n])


def parse_qp_options(text: str) -> dict[int, dict[str, str]]:
    """Return {qnum: {letter: option_text}} reading option lines only."""
    out: dict[int, dict[str, str]] = {}
    cur = None
    for raw in text.split("\n"):
        m = QHEAD.match(raw)
        if m:
            cur = int(m.group(1))
            out[cur] = {}
            continue
        m = OHEAD.match(raw)
        if m and cur is not None:
            out[cur][m.group(2)] = m.group(3)
    return out


def parse_sol_letters(text: str) -> dict[int, str]:
    out: dict[int, str] = {}
    for raw in text.split("\n"):
        m = SHEAD.match(raw)
        if m:
            out[int(m.group(1))] = m.group(2)
    return out


def reorder(opts: dict[str, str], correct: str, target: str) -> dict[str, str]:
    """Place `opts[correct]` at slot `target`; fill remaining slots with the
    other option texts in their original A→D order."""
    correct_text = opts[correct]
    rest = [opts[L] for L in LETTERS if L != correct]
    new: dict[str, str] = {}
    ri = 0
    for L in LETTERS:
        if L == target:
            new[L] = correct_text
        else:
            new[L] = rest[ri]
            ri += 1
    return new


def rewrite_qp(text: str, new_opts: dict[int, dict[str, str]]) -> str:
    lines = text.split("\n")
    out: list[str] = []
    cur = None
    for raw in lines:
        m = QHEAD.match(raw)
        if m:
            cur = int(m.group(1))
            out.append(raw)
            continue
        m = OHEAD.match(raw)
        if m and cur is not None and cur in new_opts:
            indent, letter = m.group(1), m.group(2)
            out.append(f"{indent}({letter}) {new_opts[cur][letter]}")
            continue
        out.append(raw)
    return "\n".join(out)


def rewrite_sol(text: str, new_letter: dict[int, str]) -> str:
    lines = text.split("\n")
    out: list[str] = []
    for raw in lines:
        m = SHEAD.match(raw)
        if m:
            n = int(m.group(1))
            if n in new_letter:
                out.append(f"**{n}. ({new_letter[n]})**{m.group(3)}")
                continue
        out.append(raw)
    return "\n".join(out)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--question-paper", required=True)
    ap.add_argument("--solutions", required=True)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    qp_path, sol_path = Path(args.question_paper), Path(args.solutions)
    qp_text, sol_text = qp_path.read_text(encoding="utf-8"), sol_path.read_text(encoding="utf-8")

    qp_opts = parse_qp_options(qp_text)
    sol_letters = parse_sol_letters(sol_text)

    nums = sorted(qp_opts)
    if nums != sorted(sol_letters):
        raise SystemExit(f"question-number mismatch: QP {nums} vs SOL {sorted(sol_letters)}")
    for n in nums:
        if len(qp_opts[n]) != 4:
            raise SystemExit(f"Q{n} does not have 4 options: {qp_opts[n]}")

    targets = target_letters(len(nums))
    new_opts: dict[int, dict[str, str]] = {}
    new_letter: dict[int, str] = {}
    for idx, n in enumerate(nums):
        tgt = targets[idx]
        new_opts[n] = reorder(qp_opts[n], sol_letters[n], tgt)
        new_letter[n] = tgt

    dist: dict[str, int] = {L: 0 for L in LETTERS}
    for n in nums:
        dist[new_letter[n]] += 1
    print(f"new distribution: {dist}")

    if args.dry_run:
        return 0

    qp_path.write_text(rewrite_qp(qp_text, new_opts), encoding="utf-8")
    sol_path.write_text(rewrite_sol(sol_text, new_letter), encoding="utf-8")
    print(f"rewrote {qp_path.name} + {sol_path.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
