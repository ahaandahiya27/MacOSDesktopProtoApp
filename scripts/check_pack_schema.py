#!/usr/bin/env python3
"""Comprehensive Swift-schema lint for science_class7.json + sanskrit_class7.json.

The 2026-05-19 bug class (commit 6cdf722) landed broken because:
  - inject_questions.py only validated NEW questions, not existing ones.
  - verify_pack_roundtrip.py validates JSON roundtrip but is field-agnostic.
  - Swift's Decodable is the actual contract, and no pre-commit/pre-push
    check enforced it against the WHOLE pack.

This script closes that gap. It walks every concept, topic, chapter,
question, variation, and match-pair in both packs and asserts every
field required by the Swift schema:

  SubjectPack    → id, title, language, grade, version, chapters
  Chapter        → id, number, title, summary, topics, pageRefs
  Topic          → id, title, summary, concepts, questions
  Concept        → id, title, explanations (4 depths), reasoning,
                   useCases, beyondTheBook, relatedConceptIds,
                   relatedQuestionIds, pageRefs, needsHumanReview
  Question       → id, prompt, questionType (1 of 7), answer,
                   solutionSteps, commonMistakes, variations,
                   difficulty (1-5), pageRefs, needsHumanReview,
                   options (if mcq), matchPairs (if matchTheFollowing)
  QuestionVariation → prompt, answer, solutionSteps
  MatchPair      → left, right
  ExplanationDepth → oneLine, kidFriendly, textbook, expert (all 4)

Also enforces semantic invariants:
  - MCQ answer must be one of the options
  - matchTheFollowing must have ≥2 matchPairs
  - relatedConceptIds + relatedQuestionIds must resolve in-pack
  - explanation strings must be non-empty
  - difficulty must be int in 1..5
  - questionType must be a known value

Exit 0 on clean, 1 on any violations. Suitable for pre-commit hook.

Usage:
    python3 scripts/check_pack_schema.py [pack1.json pack2.json ...]
"""
import json
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_PACKS = [
    REPO_ROOT / "desktopAhaan/Subjects/Packs/science_class7.json",
    REPO_ROOT / "desktopAhaan/Subjects/Packs/sanskrit_class7.json",
    REPO_ROOT / "desktopAhaan/Subjects/Packs/maths_class7.json",
    REPO_ROOT / "desktopAhaan/Subjects/Packs/socialscience_class7.json",
]

VALID_TYPES = {
    "mcq", "shortAnswer", "longAnswer", "numerical",
    "trueFalse", "matchTheFollowing", "fillInBlank",
}
# Mirrors Swift's QuestionSource enum raw values (QuestionSource.swift).
VALID_SOURCES = {"book_end", "boss_quiz", "scene_quick_check"}
DEPTHS = ["oneLine", "kidFriendly", "textbook", "expert"]


class Violations:
    """Accumulates schema violations across a pack so we can report them all."""

    def __init__(self):
        self.items: list[str] = []

    def add(self, where: str, msg: str):
        self.items.append(f"{where}: {msg}")

    def __bool__(self):
        return bool(self.items)


def require(d: dict, keys: list[str], where: str, v: Violations):
    """Assert a dict has every key. Each missing key is a separate violation."""
    for k in keys:
        if k not in d:
            v.add(where, f"missing field '{k}'")


def check_concept(c: dict, all_concept_ids: set[str], all_question_ids: set[str], v: Violations):
    where = f"concept {c.get('id','?')}"
    require(c, [
        "id", "title", "explanations", "reasoning", "useCases",
        "beyondTheBook", "relatedConceptIds", "relatedQuestionIds",
        "pageRefs", "needsHumanReview",
    ], where, v)

    exp = c.get("explanations")
    if not isinstance(exp, dict):
        v.add(where, "explanations must be a dict")
    else:
        for d in DEPTHS:
            if d not in exp:
                v.add(where, f"explanations missing depth '{d}'")
            elif not isinstance(exp[d], str):
                v.add(where, f"explanations.{d} must be a string")
            elif not exp[d].strip():
                v.add(where, f"explanations.{d} is empty")

    for rid in c.get("relatedConceptIds", []) or []:
        if rid not in all_concept_ids:
            v.add(where, f"relatedConceptId '{rid}' does not exist in pack")
    for rid in c.get("relatedQuestionIds", []) or []:
        if rid not in all_question_ids:
            v.add(where, f"relatedQuestionId '{rid}' does not exist in pack")


def check_variation(var: dict, q_id: str, idx: int, v: Violations):
    where = f"question {q_id}.variations[{idx}]"
    if not isinstance(var, dict):
        v.add(where, "must be a JSON object")
        return
    for field in ("prompt", "answer", "solutionSteps"):
        if field not in var:
            v.add(where, f"missing field '{field}' (Swift's QuestionVariation requires it)")
    if "solutionSteps" in var:
        if not isinstance(var["solutionSteps"], list):
            v.add(where, "solutionSteps must be a list of strings")
        else:
            for j, step in enumerate(var["solutionSteps"]):
                if not isinstance(step, str):
                    v.add(where, f"solutionSteps[{j}] must be a string")
    if not var.get("prompt", "").strip():
        v.add(where, "prompt must be non-empty")
    if not var.get("answer", "").strip():
        v.add(where, "answer must be non-empty")


def check_match_pair(pair: dict, q_id: str, idx: int, v: Violations):
    where = f"question {q_id}.matchPairs[{idx}]"
    if not isinstance(pair, dict):
        v.add(where, "must be a JSON object")
        return
    for field in ("left", "right"):
        if field not in pair:
            v.add(where, f"missing field '{field}'")
        elif not pair.get(field, "").strip():
            v.add(where, f"{field} must be non-empty")


def check_question(q: dict, v: Violations):
    where = f"question {q.get('id','?')}"
    require(q, [
        "id", "prompt", "questionType", "answer", "solutionSteps",
        "commonMistakes", "variations", "difficulty", "pageRefs",
        "needsHumanReview",
    ], where, v)

    qtype = q.get("questionType")
    if qtype and qtype not in VALID_TYPES:
        v.add(where, f"questionType '{qtype}' is not one of {sorted(VALID_TYPES)}")

    if qtype == "mcq":
        opts = q.get("options")
        if not opts:
            v.add(where, "mcq requires non-empty options")
        elif q.get("answer") and q["answer"] not in opts:
            v.add(where, f"mcq answer '{q['answer']}' is not in options {opts}")

    if qtype == "matchTheFollowing":
        pairs = q.get("matchPairs") or []
        if len(pairs) < 2:
            v.add(where, "matchTheFollowing requires ≥2 matchPairs")
        for i, pair in enumerate(pairs):
            check_match_pair(pair, q.get("id", "?"), i, v)

    diff = q.get("difficulty")
    if not isinstance(diff, int) or not (1 <= diff <= 5):
        v.add(where, f"difficulty must be int 1..5, got {diff!r}")
    elif diff >= 3 and not q.get("solutionSteps"):
        v.add(where, f"difficulty {diff} requires non-empty solutionSteps")

    for i, var in enumerate(q.get("variations") or []):
        check_variation(var, q.get("id", "?"), i, v)

    # Optional `source` must match Swift's QuestionSource enum
    # (QuestionSource.swift) — an invalid value is a hard decode failure.
    src = q.get("source")
    if src is not None and src not in VALID_SOURCES:
        v.add(where, f"source '{src}' is not one of {sorted(VALID_SOURCES)}")


def check_pack(pack_path: Path) -> int:
    """Lint one pack. Returns count of violations (0 on clean)."""
    try:
        pack = json.loads(pack_path.read_text())
    except Exception as e:
        print(f"{pack_path.name}: failed to load JSON — {e}", file=sys.stderr)
        return 1

    v = Violations()
    require(pack, ["id", "title", "language", "grade", "version", "chapters"],
            f"pack {pack_path.name}", v)

    all_concept_ids: set[str] = set()
    all_question_ids: set[str] = set()
    for ch in pack.get("chapters", []):
        for t in ch.get("topics", []):
            for c in t.get("concepts", []):
                if "id" in c:
                    all_concept_ids.add(c["id"])
            for q in t.get("questions", []):
                if "id" in q:
                    all_question_ids.add(q["id"])

    # Topic / chapter shape.
    for ch in pack.get("chapters", []):
        ch_where = f"chapter {ch.get('id','?')}"
        require(ch, ["id", "number", "title", "summary", "topics", "pageRefs"], ch_where, v)
        for t in ch.get("topics", []):
            t_where = f"topic {t.get('id','?')}"
            require(t, ["id", "title", "summary", "concepts", "questions"], t_where, v)
            for c in t.get("concepts", []):
                check_concept(c, all_concept_ids, all_question_ids, v)
            for q in t.get("questions", []):
                check_question(q, v)
        # Chapter-level question arrays (bossQuestions, quickCheckQuestions)
        # are decoded by the same Question initialiser as topic questions, so
        # validate them with the same checks — previously they were skipped,
        # letting invalid `source`/variation shapes reach the runtime decoder.
        for q in (ch.get("bossQuestions") or []):
            check_question(q, v)
        for q in (ch.get("quickCheckQuestions") or []):
            check_question(q, v)
        # conceptMap node "kind" must match Swift's NodeKind enum
        # (ConceptMap.swift) — an invalid value is a hard decode failure at
        # runtime, so catch it cheaply here instead of in the build.
        cm = ch.get("conceptMap")
        if isinstance(cm, dict):
            valid_kinds = {"concept", "crossChapter", "pivot"}
            for i, node in enumerate(cm.get("nodes", []) or []):
                k = node.get("kind") if isinstance(node, dict) else None
                if k is not None and k not in valid_kinds:
                    v.add(f"{ch_where}.conceptMap.nodes[{i}]",
                          f"invalid kind '{k}' (must be one of {sorted(valid_kinds)})")

    if not v:
        print(f"{pack_path.name}: clean ({len(all_concept_ids)} concepts, {len(all_question_ids)} questions)")
        return 0

    print(f"{pack_path.name}: {len(v.items)} violation(s):", file=sys.stderr)
    for item in v.items[:50]:
        print(f"  {item}", file=sys.stderr)
    if len(v.items) > 50:
        print(f"  ... +{len(v.items) - 50} more", file=sys.stderr)
    return len(v.items)


def main():
    paths = [Path(p) for p in sys.argv[1:]] if len(sys.argv) > 1 else DEFAULT_PACKS
    total = 0
    for p in paths:
        total += check_pack(p)
    return 0 if total == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
