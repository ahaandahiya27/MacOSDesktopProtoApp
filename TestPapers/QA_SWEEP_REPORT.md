# Olympiad TestPapers QA Sweep — Report

Per-paper audit findings. Appended one section per paper.

### Science_Ch01_NutritionInPlants_P3 — CLEAN (with downstream-dup note)
- **Validator:** GREEN — 60 Qs, options A–D, 60-entry key, key matches worked solutions, no dup stems.
- **Blind re-solve:** independently solved all 60; my answers matched the key on **60/60**. No key or worked-solution errors found.
- **Structure:** header states Paper 3, +4/−1/0, max 240, 90 min. All 60 single-correct with exactly 4 options; SOL has worked solution + key for all 60. ✔
- **Uniqueness vs FROZEN upstream:** clean — max Jaccard vs P1 = 0.45, vs Advanced/P2 = 0.26 (both well below the 0.6 near-dup line). No edits to P3 needed.
- **Difficulty:** P3 questions are scenario/analysis MCQs (zero-crossing gas exchange, ringing experiment, KOH CO₂-removal control, variegated+foil double test) — clearly above P1 recall level. Ramp OK at this rung.
- **FLAGGED for the P4/P5 audits (cross-sibling near-duplication):** P3 shares **37 high-similarity stem pairs** with its downstream siblings — 34 with P4 (several at Jaccard 1.00: P3 Q25≈P4 Q34, Q27≈Q38, Q53≈Q52, Q60≈Q58) and 3 with P5 (Q39≈P5 Q41, Q56≈P5 Q48, Q60≈P5 Q55). P3 and P4 are effectively paraphrase-twins (≈60% shared framings). Because P3 is the lower, earlier-audited rung and is unique vs everything frozen, the dedup + difficulty-escalation obligation lands on **P4 and P5**: when those rungs are audited they must rewrite the overlapping questions to genuinely new, *harder* items (P4 > P3, P5 > P4). No P3 edit made (editing the clean lower rung would be the wrong target). This is a systemic ladder-generation pattern worth a human glance.
- **Assets:** `.html` + `.pdf` present and current (same Jun-8 timestamp as the `.md`); not stale. No regeneration needed.
