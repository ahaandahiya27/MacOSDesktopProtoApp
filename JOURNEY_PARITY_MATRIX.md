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
| **Maths** | 15 | 53 | 120 | 0 | **45** ✅ | 15/15 bespoke per-chapter views | 🟡 MEDIUM |
| **Sanskrit** | 16¹ | 43 | 75 | 0 | **45** ✅ | **0/16 — no Discover Mode** | 🔴 WEAKEST |

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
| whatIfs           | ✅ 19/19 | ✅ 20/20 | ❌ 0    | ✅ 15/15 |
| **deepDive**      | ✅ 19/19 | ✅ 20/20 | ✅ **15/15** (P1-A) | ✅ **15/15** (P1-B) |
| **crossChapterRefs** | ✅ 19/19 | ✅ 20/20 | ❌ **0** | ❌ **0** |
| **bossQuestions** | ✅ 19/19 | ✅ 20/20 | ❌ **0** | ❌ **0** |
| **examConnections** | ✅ 19/19 | ✅ 20/20 | ❌ **0** | ❌ **0** |
| timelines         | ✅ 19/19 | ✅ 20/20 | ❌ 0    | ❌ 0 |
| quickCheckQuestions | ⚠️ 16/19 | ✅ 20/20 | ❌ 0  | ❌ 0 |
| scientists        | ✅ 19/19 | ❌ 0 (n/a²) | ⚠️ 3/15 | ✅ 15/15 |

² `scientists` is subject-inappropriate for Social Science (no "scientist"
notion); its absence there is correct, not a gap. Maths' 3/15 is borderline —
"mathematicians" entries (Aryabhata, Ramanujan, Brahmagupta) exist for 3
chapters only; a fill pass could add historical-mathematician context to the
remaining 12, but this is low priority versus the four bolded gaps.

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
  into. Maths/Sanskrit having **zero `bossQuestions`** means the adaptive
  difficulty ceiling for those subjects is just the `ncertQA` set — the journey
  can't ramp a strong student in Maths/Sanskrit the way it can in
  Science/Social Science.
- **`crossChapterRefs`** are what let the journey weave a subject into a
  connected arc rather than 15 isolated chapters. Absent in Maths/Sanskrit.

## 4. Prioritised depth-sweep backlog (drives subsequent Phase 1 cycles)

Ordered by leverage (downstream unblocking × number of students-affected
surfaces). Each item is a multi-cycle content milestone; every cycle stays
green here before commit, PDF-faithful and additive, articles regenerated with
`--write`.

| # | Milestone | Subject | Unblocks | Effort |
|---|-----------|---------|----------|--------|
| ~~**P1-A**~~ ✅ | ~~Add `deepDive` StretchTopics (≥3/ch, class_8–12 anchored)~~ **DONE** — 45 added (3/ch), all parent-anchored in-chapter, ≥120-word bodies, +6 ratchet tests; 706 XCTest green | **Maths** (15 ch) | Phase 5 ladder **now open for Maths** | High |
| ~~**P1-B**~~ ✅ | ~~Add `deepDive` StretchTopics (≥3/ch)~~ **DONE** — 45 added (3/ch), grammar/literature/culture forward-extensions, parent-anchored, ≥120-word bodies, +6 ratchet tests (ch01 legacy deck exempt); 712 XCTest green | **Sanskrit** (15 NEP ch) | Phase 5 ladder **now open for Sanskrit** | High |
| **P1-C** | Add `bossQuestions` (≥6/ch) | **Maths** | Phase 3 ceiling | High |
| **P1-D** | Add `bossQuestions` (≥6/ch) | **Sanskrit** | Phase 3 ceiling | High |
| **P1-E** | Build a real Sanskrit Discover experience (≥1 gated bespoke interactive/ch) | **Sanskrit** (0/16 today) | journey engagement parity | High |
| **P1-F** | Add `crossChapterRefs` (≥4/ch) | **Maths**, **Sanskrit** | Phase 3 weaving | Medium |
| **P1-G** | Add `examConnections` + `whatIfs` | **Maths** | enrichment parity | Medium |
| **P1-H** | Upgrade Social Science Discover from one generic view toward bespoke per-chapter interactives (parity with Science/Maths) | **Social Science** | engagement depth | Medium |
| **P1-I** | Backfill `quickCheckQuestions` for the 3 Science chapters missing them | **Science** | minor parity | Low |
| **P1-J** | Add historical-mathematician `scientists` entries for 12 Maths chapters | **Maths** | minor parity | Low |

**Sequencing note.** P1-A/B/C/D (the deepDive + bossQuestions fills for Maths
and Sanskrit) are prerequisites for Phases 3 and 5 and so come first. P1-E
(Sanskrit Discover) is the largest engagement gap and the most code-heavy; it
runs in parallel as its own track. The Social Science Discover upgrade (P1-H)
is genuine polish — the existing data-driven view already gives 20/20 coverage,
so it ranks below the absent-surface fills.

## 5. What is already at the high bar (no Phase 1 work needed)

- **Science** — gold standard on every dimension. 19/19 bespoke Discover, full
  enrichment, 200 boss Qs, 57 deepDive. Used as the reference for the bar.
- **Social Science** — full enrichment (260 boss Qs, 120 deepDive), 20/20
  Discover. Recently deepened (REMEDIATION_LOG cycles 81–99: second DEEPDIVE +
  GLOSSARY passes). Only the per-chapter-bespoke-Discover refinement (P1-H)
  remains, and that is polish, not a gap.

---

*Generated Phase 1 of the v6 Learning Journey. Update the headline table and
the backlog as depth-sweep milestones land. See `LEARNING_JOURNEY_LEDGER.md`
for run-by-run status.*
