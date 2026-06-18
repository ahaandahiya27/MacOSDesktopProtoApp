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

### Science_Ch01_NutritionInPlants_P4 — FIXED
- **Inherited state:** the working tree had an **incomplete prior WIP** — the QuestionPaper had 42 of 60 questions rewritten (the P3-dedup work flagged in the P3 audit) but **Solutions.md, HTML and PDF were never updated**. The validator passed only because the stale key-letters were internally self-consistent; in reality 40+ worked solutions described the OLD questions and many key letters were wrong for the new stems. This sweep completed the work to a consistent, verified state rather than discarding the (required) dedup.
- **Blind re-solve:** independently solved all 60 without consulting the key. Corrected the answer key on the many desynchronised questions and **rewrote 42 worked solutions** to match the current questions. Final key (post-fixes), exactly one defensible correct option each: confirmed by re-solve.
- **Answer-key corrections (key letter changed from the stale committed value):** Q5 C→A, Q12 B→C, Q13 A→D, Q17 C→B, Q18 C→D, Q20 D→A, Q21 D→C, Q22 B→D, Q25 A→C, Q26 D→A, Q28 A→D, Q32 C→B, Q33 C→D, Q35 B→C, Q36 D→C, Q37 B→D, Q39 D→C, Q40 A→B, Q41 C→D, Q42 D→A, Q44 A→B, Q45 A→B, Q48 A→B, Q52 D→C, Q53 C→D, Q55 D→A, Q57 B→D, Q58 C→A, Q60 A→B. (Plus worked-solution prose rewritten for all 42 changed questions, including those whose letter happened to stay the same: Q11,16,23,24,27,29,34,38,43,46,47,49,50,51,56.) Final distribution A=15/B=15/C=15/D=15.
- **Uniqueness (§3.4) — 5 genuine duplicates fixed:** the prior WIP had left five P4 questions duplicating frozen/sibling papers. Rewrote each to a genuinely new, in-scope, P4-level question (and its solution):
  - Q34 — was verbatim stem + answer-pool of P3 Q25 ("four statements, one incorrect") → now a global atmospheric O₂/CO₂-balance synthesis question.
  - Q43 — was effectively identical to P3 Q31 (variegated-leaf isolates chlorophyll, same options/answer) → now stomata/guard-cell identification + role in gas exchange.
  - Q44 — was P1 Q54 (variegated-leaf iodine test) → now food-made-in-leaves transported via phloem to storage organs (carrot/potato/wheat).
  - Q48 — was verbatim stem of P3 Q39 ("modes of nutrition, one incorrect") → now bread-mould saprotroph external-digestion mechanism.
  - Q58 — was verbatim P3 Q60 ("summarise the chapter") + near-identical options → now the ecological role of saprotroph decomposers (returning nutrients to soil).
  - Post-fix cross-paper scan: **zero** P4↔P3 / P4↔P1 / P4↔P5 stem pairs at ratio ≥0.70; intra-P4 max <0.55. (The three P5 matches that existed via Q34/Q48/Q58 also cleared once those stems changed.)
- **Structure:** header states Paper 4, +4/−1/0, max 240, 90 min; 60 single-correct MCQs, exactly 4 options each; SOL has worked solution + key for all 60. ✔
- **Validator:** GREEN — 60 Qs, options A–D, 60-entry key, key matches worked solutions, no dup stems.
- **Difficulty:** P4 stays scenario/synthesis/trap-laden and above P3 (net-flux compensation, ringing, KOH controls, food-chain collapse ordering, nitrogen-fixing reasoning). The two recall-leaning rewrites (Q43 structure-ID, Q44 storage-transport) carry cross-concept distractors (veins/phloem, root hairs, xylem-makes-food) to hold them at rung level. Ramp OK.
- **Assets:** `.html` regenerated via `make_html.py`; `.pdf` regenerated (Chrome headless, 8 pp). Both current and in sync with the `.md` files.
- **FLAGGED for human:** none requiring judgment. Note for the P5 audit: P5 still shares stems with the original P3/P4 templates (it was not deduped here — out of scope for the P4 paper) and must be reconciled when P5 is audited.

### Science_Ch01_NutritionInPlants_P5 — FIXED
- **Validator:** GREEN — 60 Qs, options A–D, 60-entry key, key matches worked solutions, no dup stems.
- **Blind re-solve:** independently solved all 60 without consulting the key; my answers matched the committed key on **60/60**. No key or worked-solution errors found on the original questions — every item had exactly one defensible correct option.
- **Structure:** header states Paper 5, +4/−1/0, max 240, 90 min; 60 single-correct MCQs with exactly 4 options each; SOL has worked solution + key for all 60. ✔
- **Uniqueness (§3.4) — 8 P3-overlap questions rewritten.** As flagged in the P3 audit (and noted again in the P4 audit), P5 was a paraphrase-sibling of P3 on many stems. A token-Jaccard scan (stem text, stop-words stripped) found P5 clean vs P1, vs Advanced/P2, and — after the P4 fix — vs P4, but heavily overlapping P3. Eight questions were genuine duplicates or scenario-twins of P3 and were rewritten to **new, in-scope, P5-level** items; each kept its original answer LETTER so the A=15/B=15/C=15/D=15 distribution is unchanged:
  - Q32 (D) — was the sealed candle-jar-in-dark scenario (≈P3 Q38 / P5 Q59) → now a three-plant double-raw-material control (CO₂-free vs dry-soil), testing that BOTH carbon dioxide and water are required.
  - Q34 (B) — was the 48 h-dark destarching disc (≈P3 Q47) → now the purpose of the warm-water dip AFTER the alcohol boil (softening the brittle, decolourised leaf for iodine).
  - Q39 (B) — was the iodine-on-four-foods test (≈P3 Q29; also P4 Q41) → now the site-of-photosynthesis question (green cactus stem vs buried potato stem vs root; leaves are the main but not only site).
  - Q41 (D) — was "four nutrition-mode sentences, one false" (verbatim ≈P3 Q39) → now a "what if all green plants vanished" producer/oxygen-renewal synthesis.
  - Q43 (B) — was the sealed-box net-gas question (≈P3 Q57; also P4 Q51) → now a raw-material-vs-product classification of CO₂/O₂/water/glucose (glucose = food made and kept).
  - Q47 (C) — was the pondweed lamp-distance O₂-fall (≈P3 Q45; concept also in P5 Q31/Q33/Q59) → now the role of the leaf's vein network (xylem up to cells, phloem food away).
  - Q48 (B) — was "which observation disproves the autotroph claim" (verbatim ≈P3 Q56; also P4 Q20) → now the fertiliser-is-not-food / minerals-vs-food misconception.
  - Q55 (D) — was "summarise the chapter" (Jaccard 1.00 vs P3 Q60) → now the two-way plant↔animal dependence (food + oxygen out, carbon dioxide in).
  - Each rewrite was re-blind-solved (single defensible answer at the stated letter) and re-scanned. Post-fix cross-paper scan: **zero** P5 pairs ≥0.45 vs P1/P2/P4; vs P3 only two residual 0.50 pairs remain — Q35~P3 Q25 (shared "four claims, one correct/incorrect" FORMAT but different topic: starch test vs photosynthesis, different options/answer) and Q20~P3 Q11 (shared "four sealed jars" scenario template but different organisms, a harder *count* question vs P3's *identify*, different answer). Both are below the 0.6 near-dup line and are genuinely distinct questions, so kept. Intra-P5 max similarity after the rewrites: <0.45 (no internal duplication).
- **Difficulty:** P5 stays the hardest rung — net-flux/compensation-point numerics (Q1–Q2), backward atom-tracing (Q5, Q56), multi-factor controls, food-chain collapse ordering, nitrogen-fixing reasoning, and the new double-raw-material control (Q32) and producer-collapse synthesis (Q41). The rewrites preserve or raise rung level (none is a recall one-liner). Ramp P5 > P4 holds.
- **FLAGGED for human:** none requiring judgment. (The two residual 0.50 P3 pairs above are format/scenario echoes only, deliberately kept; noted here for transparency.)
- **Assets:** `.html` regenerated via `make_html.py` (88 KB, new content verified present, old stems absent); `.pdf` regenerated via Chrome headless (8 pp, 313 KB). Both current and in sync with the `.md` files.
