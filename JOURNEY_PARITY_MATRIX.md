# JOURNEY_PARITY_MATRIX.md — Phase 1 audit (v6 "The Learning Journey")

> **Purpose.** A data-backed, cross-subject parity audit of all four content
> packs and their Discover experiences, so the depth-sweep work (Phase 1) and
> the later journey phases (Mastery Map, Adaptive Journey, Milestone
> Assessments, Olympiad Ladder) target the genuinely weak surfaces instead of
> guessing. This is the single source of truth for "which subject is behind,
> on what dimension, and why it matters downstream."
>
> **How the numbers were produced.** Counts are computed directly from the four
> pack JSONs under `desktopAhaan/Subjects/Packs/` and the Discover dispatcher
> `desktopAhaan/Subjects/Tutor/Discover/DiscoverMode.swift`. Re-run the audit
> any time with `python3 scripts/coverage_matrix.py` (existing) plus the
> per-field tally embedded in this run's REMEDIATION_LOG entry.
>
> **Baseline.** Captured against `main` @ 959146b (2026-06-01), Phase 0 green:
> Release build + 700 XCTest cases pass, 0 fail, all 13 core lints clean.

## 1. Headline parity table

| Subject | Chapters | Topics | ncertQA | bossQuestions | deepDive | Discover coverage | Tier |
|---------|:--------:|:------:|:-------:|:-------------:|:--------:|-------------------|:----:|
| **Science** | 19 | 57 | 152 | **200** | **57** | 19/19 bespoke per-chapter views | 🥇 GOLD |
| **Social Science** | 20 | 96 | 87 | **260** | **120** | 20/20 (one data-driven 9-scene view) | 🥈 STRONG |
| **Maths** | 15 | 53 | 120 | **90** ✅ | **45** ✅ | 15/15 bespoke per-chapter views | 🥈 STRONG |
| **Sanskrit** | 16¹ | 43 | 75 | **90** ✅ | **45** ✅ | **15/15 ✅** (one data-driven 9-scene view + a gated शब्द–अर्थ word-match interactive/ch; legacy ch01 exempt) | 🥈 STRONG |

> **Phase-1 enrichment-parity sweep: COMPLETE (P1-A…P1-I).** All four subjects
> now sit at the 🥈 STRONG bar or above — every subject carries the full
> bar-setting enrichment surface set (`deepDive`, `bossQuestions`,
> `crossChapterRefs`, `examConnections` ≥3/ch, `whatIfs` ≥3/ch) plus Discover
> Mode. Maths and Sanskrit-NEP rose from 🟡 MEDIUM to 🥈 STRONG. Only the
> optional-polish backlog (§4) remains, and it blocks nothing downstream.

¹ Sanskrit `ch01` is the legacy vocabulary deck (a deliberate carve-out, exempt
from NEP cross-subject parity ratchets per CLAUDE.md). The 15 NEP chapters are
`sch01`–`sch15`. Sanskrit per-field counts below read "15/16" wherever the
legacy `ch01` lacks the NEP enrichment field — that is expected, not a gap.

## 2. Enrichment-field coverage (chapters with the field non-empty)

Legend: ✅ = every (non-carve-out) chapter has it · ⚠️ = partial · ❌ = absent entirely.

| Field | Science | Social Science | Maths | Sanskrit (NEP) |
|-------|:-------:|:--------------:|:-----:|:--------------:|
| realWorldExamples | ✅ 19/19 | ✅ 20/20 | ✅ 15/15 | ✅ 15/15 |
| misconceptions    | ✅ 19/19 | ✅ 20/20 | ✅ 15/15 | ✅ 15/15 |
| glossary          | ✅ 19/19 | ✅ 20/20 | ✅ 15/15 | ✅ 15/15 |
| mnemonics         | ✅ 19/19 | ✅ 20/20 | ✅ 15/15 | ✅ 15/15 |
| ncertQA           | ✅ 19/19 | ✅ 20/20 | ✅ 15/15 | ✅ 15/15 |
| miniProjects      | ✅ 19/19 | ✅ 20/20 | ✅ 15/15 | ✅ 15/15 |
| conceptMap        | ✅ 19/19 | ✅ 20/20 | ✅ 15/15 | ✅ 15/15 |
| **whatIfs**       | ✅ 19/19 | ✅ 20/20 (≥3/ch, P1-I) | ✅ **15/15** (P1-G) | ✅ 15/15 |
| **deepDive**      | ✅ 19/19 | ✅ 20/20 | ✅ **15/15** (P1-A) | ✅ **15/15** (P1-B) |
| **crossChapterRefs** | ✅ 19/19 | ✅ 20/20 | ✅ **15/15** (P1-F) | ✅ **15/15** (P1-F) |
| **bossQuestions** | ✅ 19/19 | ✅ 20/20 | ✅ **15/15** (P1-C) | ✅ **15/15** (P1-D) |
| **examConnections** | ✅ 19/19 | ✅ 20/20 (≥3/ch, P1-I) | ✅ **15/15** (P1-G) | ✅ **15/15** (P1-H) |
| timelines         | ✅ 19/19 | ✅ 20/20 | ⚠️ 0 (polish³) | ⚠️ 0 (polish³) |
| quickCheckQuestions | ⚠️ 16/19 | ✅ 20/20 | ⚠️ 0 (polish³) | ⚠️ 0 (polish³) |
| scientists        | ✅ 19/19 | ❌ 0 (n/a²) | ⚠️ 3/15 (polish³) | ✅ 15/15 |

² `scientists` is subject-inappropriate for Social Science (no "scientist"
notion); its absence there is correct, not a gap.

³ **Optional-polish backlog (not bar-setting).** After P1-A…P1-I, every subject
carries the full set of *bar-setting* enrichment surfaces (glossary, mnemonics,
misconceptions, realWorldExamples, ncertQA, miniProjects, conceptMap,
**deepDive, bossQuestions, crossChapterRefs, examConnections, whatIfs**) at the
3/ch (or 4/6-per-ch) parity bar, plus Discover Mode. The remaining ⚠️ cells are
genuine polish that does NOT leave any chapter-detail surface dark or block any
later phase: Maths/Sanskrit `timelines` are subject-marginal (math/grammar has
no natural chronology; the historical context already lives in `deepDive`);
`quickCheckQuestions` being empty in Maths/Sanskrit does not dark the Discover
quick-check scenes (those source live from concepts + `bossQuestions`); Maths
`scientists` 3/15 already covers the chapters with a famous mathematician
(Aryabhata, etc.) and forcing one onto every chapter would be artificial. These
are deferred below Phase 2 as low-value, optional, and are tracked in §4.

## 3. Downstream-dependency analysis (why the gaps matter)

The later journey phases are **not** independent of content depth. Two phases
have hard data dependencies on fields that Maths and Sanskrit are missing:

- **Phase 5 (Olympiad / Expert Challenge Ladder)** builds "tiered expert sets
  from `deepDive`." At baseline Maths and Sanskrit had **zero `deepDive` items**,
  so they could not participate at all. ✅ **RESOLVED** by P1-A (Maths, 45) and
  P1-B (Sanskrit, 45): all four subjects now carry `deepDive`, so Phase 5 is
  open across the board. This was the single highest-leverage gap.
- **Phase 3 (Adaptive Cross-Subject Journey)** mixes practice across subjects.
  `bossQuestions` are the high-difficulty pool the adaptive engine escalates
  into. ✅ **RESOLVED for all four subjects** — P1-C (Maths, 90) and P1-D
  (Sanskrit NEP, 90; legacy ch01 exempt) added the missing high-difficulty
  pools, both 6/ch at difficulty 3–5 with worked steps + a distractor-trap note
  + a re-drill variation each. The adaptive ceiling can now ramp a strong
  student in every subject, not just Science/Social Science.
- **`crossChapterRefs`** are what let the journey weave a subject into a
  connected arc rather than 15 isolated chapters. ✅ **RESOLVED** by P1-F:
  4 outbound, in-pack, hand-authored references per chapter for Maths (60) and
  Sanskrit NEP (60) — 120 total — each anchored to a real source concept. The
  legacy Sanskrit `ch01` deck is exempt. Phase-3 cross-subject weaving can now
  follow real curricular threads in every subject.

## 4. Prioritised depth-sweep backlog (drives subsequent Phase 1 cycles)

Ordered by leverage (downstream unblocking × number of students-affected
surfaces). Each item is a multi-cycle content milestone; every cycle stays
green here before commit, PDF-faithful and additive, articles regenerated with
`--write`.

| # | Milestone | Subject | Unblocks | Effort |
|---|-----------|---------|----------|--------|
| ~~**P1-A**~~ ✅ | ~~Add `deepDive` StretchTopics (≥3/ch, class_8–12 anchored)~~ **DONE** — 45 added (3/ch), all parent-anchored in-chapter, ≥120-word bodies, +6 ratchet tests; 706 XCTest green | **Maths** (15 ch) | Phase 5 ladder **now open for Maths** | High |
| ~~**P1-B**~~ ✅ | ~~Add `deepDive` StretchTopics (≥3/ch)~~ **DONE** — 45 added (3/ch), grammar/literature/culture forward-extensions, parent-anchored, ≥120-word bodies, +6 ratchet tests (ch01 legacy deck exempt); 712 XCTest green | **Sanskrit** (15 NEP ch) | Phase 5 ladder **now open for Sanskrit** | High |
| ~~**P1-C**~~ ✅ | ~~Add `bossQuestions` (≥6/ch)~~ **DONE** — 90 added (6/ch), all `bossquiz_mchNN_qII`, difficulty 3–5, worked steps + common-mistake note + variation each, +7 ratchet tests; 719 XCTest green | **Maths** | Phase 3 ceiling **raised for Maths** | High |
| ~~**P1-D**~~ ✅ | ~~Add `bossQuestions` (≥6/ch)~~ **DONE** — 90 added (6/ch on the 15 NEP chapters, legacy ch01 exempt), all `bossquiz_schNN_qII`, difficulty 3–5, textbook-faithful (grounded in each concept's `explanations`), worked steps + distractor-trap note + variation each, +8 ratchet tests; 727 XCTest green | **Sanskrit** | Phase 3 ceiling **raised for Sanskrit** | High |
| ~~**P1-E**~~ ✅ | ~~Build a real Sanskrit Discover experience (≥1 gated bespoke interactive/ch)~~ **DONE** — `DiscoverChapterSanskritView` (data-driven 9-scene view) now serves all 15 NEP chapters (`sch01`–`sch15`); each carries a bespoke **gated** शब्द–अर्थ word-match interactive built from the chapter glossary (completes only when every pair is matched), plus 3 concept scenes, 3 SRS quick-checks, and the boss quiz. +4 ratchet tests; 731 XCTest green. Legacy ch01 deck deliberately excluded. | **Sanskrit** (was 0/16) | journey engagement parity **achieved** | High |
| ~~**P1-F**~~ ✅ | ~~Add `crossChapterRefs` (≥4/ch)~~ **DONE** — 120 added (4/ch × 30 chapters), all in-pack targets, hand-authored curricular pointers, real source-concept anchors, via re-runnable `scripts/inject_cross_chapter_refs.py`; +2 ratchet tests; 733 XCTest green. Legacy Sanskrit ch01 exempt. | **Maths**, **Sanskrit** | Phase 3 weaving **enabled** | Medium |
| ~~**P1-G**~~ ✅ | ~~Add `examConnections` + `whatIfs`~~ **DONE** — 45 each (3/ch), `mchNN_xcII`/`mchNN_wiII`, in-pack anchors, NEP-faithful forward pointers + misconception-targeting counterfactuals, +3 ratchet tests; whatIfs floor ratcheted 0→3 | **Maths** | enrichment parity **reached** | Medium |
| ~~**P1-H**~~ ✅ | ~~Add `examConnections` (last dark surface for Sanskrit NEP)~~ **DONE** — 45 (3/ch on the 15 NEP chapters, legacy ch01 exempt), `schNN_xcII`, grammar/literature/culture forward pointers, in-pack anchors, +1 ratchet test | **Sanskrit** | enrichment parity **reached** | Medium |
| ~~**P1-I**~~ ✅ | ~~Top up `examConnections` + `whatIfs` 2→3/ch~~ **DONE** — +40 items (`sschNN_xc03`/`wi03`), idempotent injector, 20 `_whatif` articles regenerated (3 scenarios), +3 ratchet tests | **Social Science** | clears the shared 3/ch bar | Medium |
| ~~**P1-J**~~ ✅ | ~~Refresh this matrix to mark the enrichment-parity sweep complete~~ **DONE** (this revision) | — | closes Phase 1 core | Low |

**Sequencing note.** P1-A/B/C/D (the deepDive + bossQuestions fills for Maths
and Sanskrit) were prerequisites for Phases 3 and 5 and came first. P1-E
(Sanskrit Discover) was the largest engagement gap and the most code-heavy.
P1-F…P1-I closed the remaining enrichment-surface gaps (`crossChapterRefs`,
`examConnections`, `whatIfs`) across all subjects. **The Phase-1 core is now
complete.**

### Deferred optional-polish backlog (post-Phase-2, blocks nothing)

These were re-triaged as low-value polish (see footnote ³). They leave no
chapter-detail surface dark and gate no later phase, so the journey advances to
Phase 2 (Mastery Map) ahead of them:

| Milestone | Subject | Note |
|-----------|---------|------|
| Bespoke per-chapter Discover interactives | Social Science | The data-driven 9-scene view already gives 20/20 coverage; bespoke views are refinement, not a gap. |
| Backfill `quickCheckQuestions` | Science (3 ch), Maths, Sanskrit | Discover quick-check scenes already source live from concepts + `bossQuestions`; the empty field darks nothing. |
| Historical-mathematician `scientists` | Maths (12 ch) | The 3 chapters with a famous mathematician are covered; forcing one onto every chapter would be artificial. |
| `timelines` | Maths, Sanskrit | Subject-marginal; historical context already lives in `deepDive`. |

## 5. What is at the high bar (Phase-1 core complete)

After P1-A…P1-I, **all four subjects sit at or above the 🥈 STRONG bar** on
every bar-setting enrichment surface:

- **Science** — gold standard on every dimension. 19/19 bespoke Discover, full
  enrichment, 200 boss Qs, 57 deepDive. The reference for the bar.
- **Social Science** — full enrichment (260 boss Qs, 120 deepDive), 20/20
  Discover, now ≥3/ch examConnections + whatIfs (P1-I). Deepened across
  REMEDIATION_LOG cycles 81–99 (second DEEPDIVE + GLOSSARY passes).
- **Maths** — rose from 🟡 MEDIUM to 🥈 STRONG. 15/15 bespoke Discover; full
  enrichment incl. deepDive (45, P1-A), bossQuestions (90, P1-C),
  crossChapterRefs (60, P1-F), examConnections + whatIfs (45 each, P1-G).
- **Sanskrit (NEP)** — rose from 🟡 MEDIUM to 🥈 STRONG. 15/15 data-driven
  Discover with a gated शब्द–अर्थ word-match per chapter (P1-E); full enrichment
  incl. deepDive (45, P1-B), bossQuestions (90, P1-D), crossChapterRefs (60,
  P1-F), examConnections (45, P1-H). Legacy `ch01` vocab deck is the documented
  carve-out throughout.

Only the deferred optional-polish backlog (§4) remains, and it blocks nothing
downstream. **Phase 1 advances to Phase 2 (Mastery Map).**

---

*Generated Phase 1 of the v6 Learning Journey. Update the headline table and
the backlog as depth-sweep milestones land. See `LEARNING_JOURNEY_LEDGER.md`
for run-by-run status.*
