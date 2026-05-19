#!/usr/bin/env python3
"""Pack health dashboard — one-command summary of every audit dimension.

Replaces the ad-hoc Python one-liners we kept writing during the
2026-05-19 content sweep. Single command emits the current state of:

  - per-chapter L1..L5 difficulty coverage
  - questions missing commonMistakes (per chapter + total)
  - questions with <2 variations
  - concepts missing each of the 4 ExplanationDepth depths
  - concepts with empty mnemonic / reasoning / beyondTheBook
  - orphan relatedConceptIds / relatedQuestionIds
  - MCQ data bugs (answer not in options)
  - per-chapter zero-missing badge for the commonMistakes ratchet

Sort order: pack-level summary first, then per-chapter details for
chapters that aren't already at zero-missing.

Exit code: always 0 — this is a REPORT tool, not a gate.
Pre-commit / pre-push gates are check_pack_schema.py and the existing
Python lints; this script is for human triage during content sweeps.

Usage:
    python3 scripts/audit_pack_health.py
    python3 scripts/audit_pack_health.py --pack desktopAhaan/Subjects/Packs/sanskrit_class7.json
    python3 scripts/audit_pack_health.py --json > /tmp/audit.json
"""
import argparse
import json
import sys
from collections import Counter
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_PACK = REPO_ROOT / "desktopAhaan/Subjects/Packs/science_class7.json"

LEVELS = [1, 2, 3, 4, 5]
DEPTHS = ["oneLine", "kidFriendly", "textbook", "expert"]


def build_report(pack: dict) -> dict:
    """Walk the pack and aggregate every audit dimension into one dict."""
    all_concept_ids = set()
    all_question_ids = set()
    for ch in pack.get("chapters", []):
        for t in ch.get("topics", []):
            for c in t.get("concepts", []):
                all_concept_ids.add(c.get("id", ""))
            for q in t.get("questions", []):
                all_question_ids.add(q.get("id", ""))

    chapters_out = []
    pack_totals = {
        "concepts": len(all_concept_ids),
        "questions": len(all_question_ids),
        "level_counts": Counter(),
        "missing_cm_total": 0,
        "missing_variations_lt2_total": 0,
        "missing_depths_total": 0,
        "missing_mnemonic_total": 0,
        "missing_reasoning_total": 0,
        "missing_btb_total": 0,
        "orphan_refs_total": 0,
        "mcq_data_bugs": 0,
    }

    for ch in pack.get("chapters", []):
        ch_data = {
            "number": ch.get("number"),
            "title": ch.get("title"),
            "concept_count": 0,
            "question_count": 0,
            "level_counts": Counter(),
            "missing_cm": [],
            "few_variations": [],
            "missing_depths": [],
            "missing_mnemonic": [],
            "missing_reasoning": [],
            "missing_btb": [],
            "orphan_refs": [],
            "mcq_data_bugs": [],
        }
        for t in ch.get("topics", []):
            for c in t.get("concepts", []):
                ch_data["concept_count"] += 1
                exp = c.get("explanations", {}) or {}
                for d in DEPTHS:
                    if not exp.get(d) or not exp[d].strip():
                        ch_data["missing_depths"].append(f"{c.get('id','?')}.{d}")
                if not c.get("mnemonic") or not c["mnemonic"].strip():
                    ch_data["missing_mnemonic"].append(c.get("id", "?"))
                if not c.get("reasoning") or not c["reasoning"].strip():
                    ch_data["missing_reasoning"].append(c.get("id", "?"))
                if not c.get("beyondTheBook") or not c["beyondTheBook"].strip():
                    ch_data["missing_btb"].append(c.get("id", "?"))
                for rid in c.get("relatedConceptIds", []) or []:
                    if rid not in all_concept_ids:
                        ch_data["orphan_refs"].append(f"{c.get('id','?')}→{rid}")
                for rid in c.get("relatedQuestionIds", []) or []:
                    if rid not in all_question_ids:
                        ch_data["orphan_refs"].append(f"{c.get('id','?')}→{rid}")
            for q in t.get("questions", []):
                ch_data["question_count"] += 1
                ch_data["level_counts"][q.get("difficulty", 0)] += 1
                if not q.get("commonMistakes"):
                    ch_data["missing_cm"].append(q.get("id", "?"))
                if len(q.get("variations", []) or []) < 2:
                    ch_data["few_variations"].append(q.get("id", "?"))
                if q.get("questionType") == "mcq":
                    opts = q.get("options") or []
                    if q.get("answer") and q["answer"] not in opts:
                        ch_data["mcq_data_bugs"].append(q.get("id", "?"))

        for L in LEVELS:
            pack_totals["level_counts"][L] += ch_data["level_counts"].get(L, 0)
        pack_totals["missing_cm_total"] += len(ch_data["missing_cm"])
        pack_totals["missing_variations_lt2_total"] += len(ch_data["few_variations"])
        pack_totals["missing_depths_total"] += len(ch_data["missing_depths"])
        pack_totals["missing_mnemonic_total"] += len(ch_data["missing_mnemonic"])
        pack_totals["missing_reasoning_total"] += len(ch_data["missing_reasoning"])
        pack_totals["missing_btb_total"] += len(ch_data["missing_btb"])
        pack_totals["orphan_refs_total"] += len(ch_data["orphan_refs"])
        pack_totals["mcq_data_bugs"] += len(ch_data["mcq_data_bugs"])

        chapters_out.append(ch_data)

    return {"chapters": chapters_out, "totals": pack_totals}


def print_human(pack_path: Path, report: dict):
    chapters = report["chapters"]
    tot = report["totals"]
    print(f"Pack: {pack_path.name}")
    print(f"      {tot['concepts']} concepts · {tot['questions']} questions")
    print()
    print("Pack-level totals:")
    print(f"  Level coverage:  L1={tot['level_counts'][1]:3d}  L2={tot['level_counts'][2]:3d}  "
          f"L3={tot['level_counts'][3]:3d}  L4={tot['level_counts'][4]:3d}  L5={tot['level_counts'][5]:3d}")
    print(f"  Questions missing commonMistakes:     {tot['missing_cm_total']:3d}")
    print(f"  Questions with <2 variations:         {tot['missing_variations_lt2_total']:3d}")
    print(f"  Concepts missing explanation depth:   {tot['missing_depths_total']:3d}")
    print(f"  Concepts missing mnemonic:            {tot['missing_mnemonic_total']:3d}")
    print(f"  Concepts missing reasoning:           {tot['missing_reasoning_total']:3d}")
    print(f"  Concepts missing beyondTheBook:       {tot['missing_btb_total']:3d}")
    print(f"  Orphan related-* references:          {tot['orphan_refs_total']:3d}")
    print(f"  MCQ data bugs (answer not in opts):   {tot['mcq_data_bugs']:3d}")
    print()

    print("Per-chapter snapshot:")
    print(f"  {'Ch':>3} {'L1':>3} {'L2':>3} {'L3':>3} {'L4':>3} {'L5':>3} {'noCM':>5} {'fewVar':>6} {'orph':>4}  Title")
    for ch in chapters:
        n = ch["number"]
        lc = ch["level_counts"]
        floor_ok = "✓" if lc.get(4, 0) >= 3 and lc.get(5, 0) >= 3 else "✗"
        cm_ok = "✓" if len(ch["missing_cm"]) == 0 else " "
        print(f"  {n:>3} {lc.get(1,0):>3} {lc.get(2,0):>3} {lc.get(3,0):>3} {lc.get(4,0):>3} {lc.get(5,0):>3} "
              f"{len(ch['missing_cm']):>5} {len(ch['few_variations']):>6} {len(ch['orphan_refs']):>4}  "
              f"{floor_ok}{cm_ok} {ch['title']}")
    print("                                              " +
          "3+3-floor: ✓ if L4≥3 and L5≥3 | cM: ✓ if zero questions missing commonMistakes")
    print()

    # Surface chapters with the most pressing gaps.
    by_cm = sorted(chapters, key=lambda c: -len(c["missing_cm"]))
    top_cm = [c for c in by_cm if len(c["missing_cm"]) > 0][:5]
    if top_cm:
        print("Top 5 chapters by commonMistakes gap:")
        for c in top_cm:
            print(f"  Ch.{c['number']:02d} {c['title']:42s} {len(c['missing_cm']):3d} missing")
        print()

    if tot["mcq_data_bugs"]:
        print("⚠ MCQ data bugs found — these will mis-grade in the app:")
        for ch in chapters:
            for qid in ch["mcq_data_bugs"]:
                print(f"  Ch.{ch['number']:02d} · {qid} (answer not in options)")
        print()


def print_json(pack_path: Path, report: dict):
    # Counter is not JSON-serialisable; convert.
    out_chapters = []
    for ch in report["chapters"]:
        out_chapters.append({**ch, "level_counts": dict(ch["level_counts"])})
    out = {
        "pack": pack_path.name,
        "chapters": out_chapters,
        "totals": {**report["totals"], "level_counts": dict(report["totals"]["level_counts"])},
    }
    print(json.dumps(out, indent=2))


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--pack", default=str(DEFAULT_PACK))
    ap.add_argument("--json", action="store_true", help="emit JSON instead of human-readable")
    args = ap.parse_args()

    pack_path = Path(args.pack)
    pack = json.loads(pack_path.read_text())
    report = build_report(pack)

    if args.json:
        print_json(pack_path, report)
    else:
        print_human(pack_path, report)
    return 0


if __name__ == "__main__":
    sys.exit(main())
