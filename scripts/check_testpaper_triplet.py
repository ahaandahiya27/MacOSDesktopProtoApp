#!/usr/bin/env python3
"""check_testpaper_triplet.py — locks test-paper triplet completeness.

Every test paper this app ships travels as a *triplet* of sibling files
sharing one stem. A half-shipped paper is a silent content bug: the kid
opens a question paper and the "Solutions" / "Solved Guide" link dead-ends,
or a SolvedGuide.html renders against a QuestionPaper.md that was renamed
out from under it.

Two streams, two triplet shapes:

  1. `TestPapers/` (repo root) — the Olympiad P3–P5 series. Each
     `<stem>_QuestionPaper.md` must have a non-empty `<stem>_Solutions.md`.
     (The rendered `<stem>.html` is a presentation artifact, not gated here.)

  2. `desktopAhaan/Resources/TestPapers/` — the bundled SolvedGuide stream
     plus the Advanced tier. Each `<stem>_QuestionPaper.md` must have BOTH a
     non-empty `<stem>_Solutions.md` AND a non-empty `<stem>_SolvedGuide.html`
     (the in-app rendered guide, produced by scripts/make_solved_guide.py).

     EXCEPTION — P3/P4/P5 practice variants: stems ending in `_P3`, `_P4`,
     or `_P5` are the QA-sweep ramp variants (a `qa:` commit lineage). They
     are bundled so the kid can take them as in-app quizzes via the
     `OlympiadPaperParser`, but they ship as a Question/Solutions PAIR — no
     SolvedGuide HTML. `make_solved_guide.py` is hand-tuned for the original
     Maths Ch15 / Science Ch13 anchors and isn't a generalised generator, so
     forcing a guide for 207 variants would require either a script rewrite
     or a stream of empty stubs (which the > 32-byte floor below already
     rejects anyway). The hub's "Solved Guide" CTA is gated on
     `solvedGuideHTML != nil`, so a variant card simply hides that affordance.

"Non-empty" means the file exists and has more than a trivial amount of
content (> 32 bytes) — a zero-byte or stub placeholder counts as missing,
because an empty Solutions.md passes a bare `os.path.exists` check while
still dead-ending the kid.

Usage:
    python3 scripts/check_testpaper_triplet.py             # audit the whole repo
    python3 scripts/check_testpaper_triplet.py FILE [...]  # audit only these files
    python3 scripts/check_testpaper_triplet.py --selftest  # fixture self-test

Exit 0 = clean, 1 = violation.

Wired into scripts/ci-build-test.sh (whole-repo scan — the push/CI gate) and the
pre-commit hook (scoped to the staged TestPapers files only). The scoped mode
matters under concurrent authoring: a pre-commit hook should validate the triplet
of what *this* commit touches, not fail because some unrelated paper is mid-flight
in the working tree (e.g. another author has just dropped a QuestionPaper.md and
hasn't written its Solutions.md yet). The full-tree scan in ci-build-test.sh still
catches any genuine orphan before it reaches origin. See ADVANCED_TIER_LEDGER.md
for the per-chapter coverage table this lint sources.
"""
from __future__ import annotations

import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# (relative-root, requires_solved_guide). Order is the report order.
STREAMS = [
    ("TestPapers", False),
    (os.path.join("desktopAhaan", "Resources", "TestPapers"), True),
]

# A file with fewer bytes than this is treated as missing — an empty or
# stub Solutions.md still dead-ends the reader. The smallest real solution
# set we ship is comfortably above this floor.
MIN_BYTES = 32

# P3/P4/P5 stem suffixes that exempt the bundled stream from the SolvedGuide
# requirement (see the docstring). The pair (QP.md + Solutions.md) is still
# enforced — only the SolvedGuide HTML is treated as not-required.
_VARIANT_STEM_SUFFIXES = ("_P3", "_P4", "_P5")


def _is_practice_variant(stem: str) -> bool:
    """True iff this stem belongs to the P3/P4/P5 QA-sweep ramp variants,
    which intentionally ship without a SolvedGuide.html."""
    return stem.endswith(_VARIANT_STEM_SUFFIXES)


def _nonempty(path: str) -> bool:
    """True iff path exists and carries more than a stub of content."""
    try:
        return os.path.getsize(path) > MIN_BYTES
    except OSError:
        return False


def audit_stream(root_abs: str, root_label: str, requires_guide: bool) -> list[str]:
    """Return a list of human-readable violation strings for one stream."""
    errors: list[str] = []
    if not os.path.isdir(root_abs):
        # A missing stream dir is layout drift worth surfacing, not a
        # silent pass — but only the Resources stream is mandatory; the
        # repo-root Olympiad stream may legitimately be absent in a
        # trimmed checkout, so we only hard-fail on the bundled one.
        if requires_guide:
            return [f"{root_label}: stream directory is missing — layout drift"]
        return []

    qps = sorted(f for f in os.listdir(root_abs) if f.endswith("_QuestionPaper.md"))
    for qp in qps:
        stem = qp[: -len("_QuestionPaper.md")]
        sol = os.path.join(root_abs, f"{stem}_Solutions.md")
        if not _nonempty(sol):
            errors.append(
                f"{root_label}/{qp}: missing or empty {stem}_Solutions.md"
            )
        if requires_guide and not _is_practice_variant(stem):
            guide = os.path.join(root_abs, f"{stem}_SolvedGuide.html")
            if not _nonempty(guide):
                errors.append(
                    f"{root_label}/{qp}: missing or empty {stem}_SolvedGuide.html"
                )
    return errors


def _stream_for(path_abs: str) -> tuple[str, str, bool] | None:
    """Map an absolute file path to its (root_abs, root_label, requires_guide)
    stream, or None if it isn't under a known TestPapers stream."""
    norm = os.path.normpath(path_abs)
    for rel, requires_guide in STREAMS:
        root_abs = os.path.normpath(os.path.join(REPO, rel))
        if norm == root_abs or norm.startswith(root_abs + os.sep):
            return (root_abs, rel, requires_guide)
    return None


def audit_paths(paths: list[str]) -> list[str]:
    """Scoped audit: validate only the triplets implicated by `paths`.

    Each path is reduced to its triplet stem (stripping the _QuestionPaper.md /
    _Solutions.md / _SolvedGuide.html suffix), de-duplicated, and checked. Paths
    outside a TestPapers stream are ignored. Used by the pre-commit hook so a
    commit is judged on its own files, not on unrelated mid-flight papers.
    """
    suffixes = ("_QuestionPaper.md", "_Solutions.md", "_SolvedGuide.html")
    # stem-key -> (root_abs, root_label, requires_guide, stem)
    stems: dict[str, tuple[str, str, bool, str]] = {}
    for p in paths:
        p_abs = p if os.path.isabs(p) else os.path.join(REPO, p)
        stream = _stream_for(p_abs)
        if stream is None:
            continue
        root_abs, root_label, requires_guide = stream
        base = os.path.basename(p_abs)
        stem = base
        for suf in suffixes:
            if base.endswith(suf):
                stem = base[: -len(suf)]
                break
        else:
            continue  # not a triplet member (e.g. a .pdf or rendered .html)
        stems[os.path.join(root_label, stem)] = (root_abs, root_label, requires_guide, stem)

    errors: list[str] = []
    for root_abs, root_label, requires_guide, stem in stems.values():
        sol = os.path.join(root_abs, f"{stem}_Solutions.md")
        if not _nonempty(sol):
            errors.append(f"{root_label}/{stem}_QuestionPaper.md: missing or empty {stem}_Solutions.md")
        if requires_guide and not _is_practice_variant(stem):
            guide = os.path.join(root_abs, f"{stem}_SolvedGuide.html")
            if not _nonempty(guide):
                errors.append(f"{root_label}/{stem}_QuestionPaper.md: missing or empty {stem}_SolvedGuide.html")
    return errors


def audit(repo: str) -> tuple[list[str], int]:
    """Audit every stream. Returns (errors, total_question_papers_seen)."""
    errors: list[str] = []
    total = 0
    for rel, requires_guide in STREAMS:
        root_abs = os.path.join(repo, rel)
        if os.path.isdir(root_abs):
            total += sum(
                1 for f in os.listdir(root_abs) if f.endswith("_QuestionPaper.md")
            )
        errors.extend(audit_stream(root_abs, rel, requires_guide))
    return errors, total


# ---------------------------------------------------------------------------
# Self-test — builds a throwaway tree and asserts the lint flags exactly the
# orphans we plant and nothing else.
# ---------------------------------------------------------------------------
def selftest() -> int:
    import tempfile

    ok = True
    body = "x" * 200  # comfortably above MIN_BYTES

    def write(path: str, content: str = body) -> None:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(content)

    with tempfile.TemporaryDirectory() as d:
        # Stream 1 (repo-root, no guide required).
        s1 = os.path.join(d, "TestPapers")
        # A complete pair — should NOT flag.
        write(os.path.join(s1, "Maths_Ch01_X_P3_QuestionPaper.md"))
        write(os.path.join(s1, "Maths_Ch01_X_P3_Solutions.md"))
        # A QP with no Solutions — SHOULD flag once.
        write(os.path.join(s1, "Maths_Ch02_Y_P3_QuestionPaper.md"))
        # A QP whose Solutions is an empty stub — SHOULD flag once.
        write(os.path.join(s1, "Maths_Ch03_Z_P3_QuestionPaper.md"))
        write(os.path.join(s1, "Maths_Ch03_Z_P3_Solutions.md"), content="")

        # Stream 2 (Resources, guide required).
        s2 = os.path.join(d, "desktopAhaan", "Resources", "TestPapers")
        # A complete triplet — should NOT flag.
        write(os.path.join(s2, "Maths_Ch01_X_Advanced_QuestionPaper.md"))
        write(os.path.join(s2, "Maths_Ch01_X_Advanced_Solutions.md"))
        write(os.path.join(s2, "Maths_Ch01_X_Advanced_SolvedGuide.html"))
        # Has Solutions but no SolvedGuide — SHOULD flag once (guide).
        write(os.path.join(s2, "Maths_Ch02_Y_Advanced_QuestionPaper.md"))
        write(os.path.join(s2, "Maths_Ch02_Y_Advanced_Solutions.md"))

        # P3/P4/P5 practice variants in the bundled stream — SHOULD NOT flag
        # for missing SolvedGuide. They ship as a QP+Solutions pair only.
        write(os.path.join(s2, "Maths_Ch04_W_P3_QuestionPaper.md"))
        write(os.path.join(s2, "Maths_Ch04_W_P3_Solutions.md"))
        write(os.path.join(s2, "Maths_Ch04_W_P4_QuestionPaper.md"))
        write(os.path.join(s2, "Maths_Ch04_W_P4_Solutions.md"))
        write(os.path.join(s2, "Maths_Ch04_W_P5_QuestionPaper.md"))
        write(os.path.join(s2, "Maths_Ch04_W_P5_Solutions.md"))
        # A P3 variant with NO Solutions — SHOULD still flag (pair contract
        # holds for variants; only the SolvedGuide is exempt).
        write(os.path.join(s2, "Maths_Ch05_V_P3_QuestionPaper.md"))

        errors, total = audit(d)
        joined = "\n".join(errors)

        def expect(cond: bool, msg: str) -> None:
            nonlocal ok
            if not cond:
                print(f"SELFTEST FAIL: {msg}\n  errors were:\n   " + "\n   ".join(errors))
                ok = False

        expect(total == 9, f"expected to count 9 question papers, counted {total}")
        expect("Maths_Ch02_Y_P3_QuestionPaper.md" in joined,
               "missing-Solutions orphan not flagged (stream 1)")
        expect("Maths_Ch03_Z_P3_QuestionPaper.md" in joined,
               "empty-Solutions stub not flagged (stream 1)")
        expect("Maths_Ch02_Y_Advanced_QuestionPaper.md" in joined
               and "SolvedGuide" in joined,
               "missing-SolvedGuide orphan not flagged (stream 2)")
        expect("Maths_Ch01_X_P3" not in joined,
               "complete pair wrongly flagged (stream 1)")
        expect("Maths_Ch01_X_Advanced" not in joined,
               "complete triplet wrongly flagged (stream 2)")
        # Variant pair completeness — no flag because SolvedGuide isn't required.
        expect("Maths_Ch04_W_P3_QuestionPaper.md" not in joined,
               "complete P3 variant pair wrongly flagged (stream 2)")
        expect("Maths_Ch04_W_P4_QuestionPaper.md" not in joined,
               "complete P4 variant pair wrongly flagged (stream 2)")
        expect("Maths_Ch04_W_P5_QuestionPaper.md" not in joined,
               "complete P5 variant pair wrongly flagged (stream 2)")
        # Variant with no Solutions — SHOULD still flag (the pair contract
        # holds for variants too).
        expect("Maths_Ch05_V_P3_QuestionPaper.md" in joined
               and "Solutions" in joined,
               "missing-Solutions in P3 variant not flagged (stream 2)")
        # Exactly 4 violations expected: 2 from stream 1, 2 from stream 2.
        expect(len(errors) == 4, f"expected exactly 4 violations, got {len(errors)}: {errors}")

        # Now heal everything and assert a clean pass.
        write(os.path.join(s1, "Maths_Ch02_Y_P3_Solutions.md"))
        write(os.path.join(s1, "Maths_Ch03_Z_P3_Solutions.md"))
        write(os.path.join(s2, "Maths_Ch02_Y_Advanced_SolvedGuide.html"))
        write(os.path.join(s2, "Maths_Ch05_V_P3_Solutions.md"))
        healed, _ = audit(d)
        expect(not healed, f"healed tree still flagged: {healed}")

        # Missing mandatory Resources stream must hard-fail.
        with tempfile.TemporaryDirectory() as d2:
            errs2, _ = audit(d2)
            expect(any("Resources" in e for e in errs2),
                   "missing Resources stream not flagged")

        # Scoped mode: audit_paths uses the REAL repo streams (it resolves
        # against REPO), so exercise it against the live tree. A complete
        # triplet (the prototype) must pass; a fabricated incomplete stem
        # must fail — and crucially, an unrelated mid-flight orphan elsewhere
        # in the tree must NOT make a complete staged triplet fail.
        proto = os.path.join(
            REPO, "desktopAhaan", "Resources", "TestPapers",
            "Maths_Ch15_FindingTheUnknown_Advanced_QuestionPaper.md",
        )
        if os.path.exists(proto):
            expect(not audit_paths([proto]),
                   "scoped mode flagged the complete prototype triplet")
        ghost = os.path.join(
            REPO, "desktopAhaan", "Resources", "TestPapers",
            "ZZ_NoSuchChapter_Advanced_QuestionPaper.md",
        )
        expect(bool(audit_paths([ghost])),
               "scoped mode failed to flag a stem with no Solutions/Guide")
        expect(not audit_paths(["README.md", "scripts/foo.py"]),
               "scoped mode wrongly flagged non-TestPaper paths")

    print("SELFTEST PASS" if ok else "SELFTEST FAILED")
    return 0 if ok else 1


def main() -> int:
    if "--selftest" in sys.argv:
        return selftest()

    # Scoped mode: any non-flag args are treated as file paths to validate.
    file_args = [a for a in sys.argv[1:] if not a.startswith("-")]
    if file_args:
        errors = audit_paths(file_args)
        if errors:
            print("check_testpaper_triplet: FAIL (scoped to staged files)")
            for e in errors[:50]:
                print("  " + e)
            print(f"\n  {len(errors)} incomplete triplet(s) among the files checked.")
            print("  Fix: author the missing _Solutions.md / _SolvedGuide.html, or")
            print("  run scripts/make_solved_guide.py to (re)generate the guide.")
            return 1
        print(f"check_testpaper_triplet: clean — staged triplet(s) complete "
              f"({len(file_args)} path(s) checked).")
        return 0

    errors, total = audit(REPO)
    if errors:
        print("check_testpaper_triplet: FAIL")
        for e in errors[:50]:
            print("  " + e)
        if len(errors) > 50:
            print(f"  ... and {len(errors) - 50} more")
        print(f"\n  {len(errors)} incomplete triplet(s) across {total} question paper(s).")
        print("  Fix: author the missing _Solutions.md / _SolvedGuide.html, or")
        print("  run scripts/make_solved_guide.py to (re)generate the guide.")
        return 1

    print(
        f"check_testpaper_triplet: clean — all {total} question paper(s) across "
        f"{len(STREAMS)} stream(s) have complete triplets "
        f"(Solutions everywhere; SolvedGuide in the bundled Resources stream)."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
