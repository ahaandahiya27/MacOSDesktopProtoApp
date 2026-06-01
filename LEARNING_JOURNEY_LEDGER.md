# LEARNING_JOURNEY_LEDGER.md — v6 "The Learning Journey"

> **Read this first every run.** It is the resumable status of the v6 mission:
> unify the four subjects (Science, Maths, Sanskrit, Social Science) into one
> guided beginner→expert journey and raise every subject to a consistent high
> bar. Update it (committed) at the end of each green milestone.

## Mission phases

0. **COMPILE-FIRST baseline** — prove the tree builds green before any change.
1. **PARITY AUDIT + DEPTH SWEEP** — `JOURNEY_PARITY_MATRIX.md`; raise weak
   chapters (deeper Discover, ≥1 gated bespoke interactive, fill enrichment).
2. **MASTERY MAP** — read-only `Services/MasteryEngine.swift` aggregating
   SRS + coverage concept→subject→overall; a Mastery Map window (pure SwiftUI).
3. **ADAPTIVE CROSS-SUBJECT JOURNEY** — `JourneyPlanner` extends Daily Plan +
   `AdaptiveDifficultyEngine`; a "Whole Journey" mode.
4. **MILESTONE ASSESSMENTS + PARENT REPORT CARD** — mixed quizzes sampled by
   mastery gaps; extend the Weekly-Progress PDF export to a report card.
5. **OLYMPIAD / EXPERT CHALLENGE LADDER** — tiered expert sets from `deepDive`,
   unlocked by mastery.
6. **INTEGRATE / TEST / DOC** — Help-menu wiring, a11y/WCAG/reduce-motion/
   legacy-GPU, full tests, `LEARNING_JOURNEY_CHECKPOINT.md`.

## Status

| Phase | State | Notes |
|-------|-------|-------|
| 0 | ✅ DONE | Baseline green: Release build + 700 XCTest pass, 0 fail; 13 core lints clean. |
| 1 | 🟡 IN PROGRESS | Audit landed. **P1-A DONE** (Maths `deepDive`: 45 StretchTopics, 3/ch, +6 tests, 706 XCTest green). Backlog P1-B…P1-J pending. |
| 2 | ⬜ NOT STARTED | Note: `MasteryDashboard` + `DataStore+Mastery` + `MasteryLevel` already exist (per-chapter, single-subject). MasteryEngine must aggregate **cross-subject** concept→subject→overall on top of these. |
| 3 | ⬜ NOT STARTED | `AdaptiveDifficultyEngine` already exists — extend, don't replace. |
| 4 | ⬜ NOT STARTED | `WeeklyReportPDFExporter` already exists — extend to a report card. |
| 5 | ⬜ NOT STARTED | Maths **unblocked** (P1-A added 45 `deepDive`). Still blocked for Sanskrit until P1-B. |
| 6 | ⬜ NOT STARTED | Final integration + checkpoint doc. |

## Environment note (important for whoever resumes)

The v6 prompt assumes execution **on the deploy iMac** (Xcode 13.2.1 / Swift
5.5 / Big Sur 11.7.11), where builds are authoritative. The cycles to date were
run on the **dev MacBook Pro (Xcode 26.5)**. Mitigation: the build pins
`MACOSX_DEPLOYMENT_TARGET=11.0` (so the compiler's availability checking still
rejects macOS-12+ APIs), and the static Big-Sur lints
(`check_macos12_apis.py`, `check_swift55_syntax.py`,
`check_sf_symbols_compat.py`, `check_color_literals.py`,
`check_view_mainactor.py`, `check_mainactor_closure_refs.py`,
`check_viewbuilder_limit.py`) are the authoritative Big-Sur guardrails and run
on every cycle. A final authoritative `--ui` build on the iMac is still
required before declaring the mission complete (Phase 6).

## Run log

### Cycle 1 (2026-06-01) — Phase 0 baseline + Phase 1 audit
- Confirmed Phase 0 green (Release build + 700 XCTest pass, 0 fail; 13 core
  lints clean; pbxproj already in sync).
- Created `JOURNEY_PARITY_MATRIX.md`: data-backed cross-subject audit. Key
  findings — **Sanskrit has 0/16 Discover coverage**; **Maths and Sanskrit have
  zero `deepDive`, `bossQuestions`, `crossChapterRefs`, `examConnections`**
  (which blocks Phase 5 and caps Phase 3 difficulty for those subjects).
  Science = gold standard; Social Science = strong.
- Defined the prioritised depth-sweep backlog (P1-A…P1-J).
- Created this ledger; gitignored the v6 launcher runtime artifacts.
- **NEXT:** begin P1-A (Maths `deepDive` fill) — highest leverage, unblocks
  Phase 5. PDF-faithful, additive, articles regenerated with `--write`, green
  here before commit.

### Cycle 2 (2026-06-01) — Phase 1 · P1-A complete (Maths `deepDive`)
- Added **45 `deepDive` StretchTopics** to the Maths pack (3 per chapter ×15),
  via the new re-runnable `scripts/inject_maths_deepdive.py`. Each is anchored
  by `parentConceptId` to a REAL concept in its own chapter, tagged
  class_8…class_11 (a genuine forward extension of the NEP Grade-7 idea — e.g.
  ch01 → standard form / significant figures / orders-of-magnitude; ch15 →
  transposition / simultaneous equations / quadratics), with a prerequisite and
  next-step hint and a ≥120-word body (Science floor is 100).
- Renders natively through the existing `DeepDiveSection` →
  `DeepDiveDetailSheet` in `ChapterDetailView` (no HTML article needed; the
  "regenerate articles" step is a Social-Science-only surface).
- Added `desktopAhaanTests/MathsDeepDiveTests.swift` (6 ratchet tests:
  ≥3/ch floor, total ≥45, parent-anchored in-chapter, globally-unique ids,
  ≥120-word bodies, prerequisite+nextStep present), mirroring the Science
  deep-dive contract.
- Green here: all content lints + `test_lints.py` pass; pbxproj regenerated
  (new test file wired); `ci-build-test.sh` → **BUILD + 706 XCTest, 0 failures**
  (was 700). roundtrip + `check_pack_schema` clean on all four packs.
- **Phase 5 (Olympiad ladder) is now open for Maths.** Additive only; zero
  regressions; zero STOP_AND_ASK.
- **NEXT:** P1-B — Sanskrit `deepDive` fill (15 NEP chapters `sch01`–`sch15`,
  ≥3/ch), the last subject blocking Phase 5. Same contract: in-chapter parent
  anchor, forward-grade extension faithful to the NEP Sanskrit text, ≥120-word
  bodies, mirror test, green before commit.
