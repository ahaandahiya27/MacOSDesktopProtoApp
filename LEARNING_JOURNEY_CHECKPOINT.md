# LEARNING_JOURNEY_CHECKPOINT.md — v6 "The Learning Journey"

Final checkpoint for the v6 Learning Journey work: unifying the four subjects
(Science, Maths, Sanskrit, Social Science) into one guided beginner→expert
journey, raising every subject to a consistent bar, and adding the cross-subject
progress, planning, assessment, and challenge surfaces on top.

Status as of 2026-06-02: **Phases 1–6 complete; green on the Big-Sur deploy
target (Release build + full XCTest, 800 tests, 0 failures).**

All v6 surfaces are **READ-ONLY over the SRS** — they read the spaced-repetition
reviews (`DataStore.questionReviews`) and the immutable content packs, and never
mutate, schedule, or write the SRS. The one capstone guarantee is pinned by
`LearningJourneyReadOnlyTests`.

---

## Phase-by-phase

### Phase 1 — Parity audit + depth sweep ✅
Raised weak chapters to parity (deeper Discover scenes, gated bespoke
interactives, enrichment fill). Tracked in `JOURNEY_PARITY_MATRIX.md`.

### Phase 2 — Mastery Map ✅
- `Services/MasteryEngine.swift` — read-only aggregation of SRS + coverage into
  concept→subject→overall mastery. Pure `level(forFraction:)` + `overall(from:)`;
  `@MainActor snapshot(registry:dataStore:now:)`. Types: `OverallMasterySnapshot`,
  `SubjectMasterySnapshot` (coverage vs mastery as two distinct axes).
- `Views/Progress/MasteryMapView.swift` + `MasteryMapWindow.swift` — pure-SwiftUI
  cross-subject map (per-subject Coverage/Mastery meters, overall ring, "focus
  next" nudge). Help → Mastery Map (⌘⇧M).

### Phase 3 — Adaptive cross-subject journey ✅
- `Services/JourneyPlanner.swift` — pure `subjectFocusOrder` (weakest-started
  first) + `roundRobinReviews` (weak-first cross-subject spread). `JourneyMode`
  (`today` | `wholeJourney`) persisted via `JourneyPlannerStorage`.
- `Services/Persistence/DataStore+JourneyPlan.swift` — `buildWholeJourneyPlan`
  extends the existing Daily Plan, sampling by mastery gaps; reuses the
  `AdaptiveDifficultyEngine` band-aware due ordering. Maths Discover deliberately
  excluded (bare `chNN` Discover-id collision).
- `Views/.../DailyPlanView` — a Today ↔ Whole Journey segmented picker.
- M3 decision: no extra `AdaptiveDifficultyEngine` surfacing — subject-level gap
  ordering and within-subject band ordering are kept as two orthogonal signals.

### Phase 4 — Milestone assessments + parent report card ✅
- `Models/MilestoneAssessment.swift` + `Services/MilestoneAssessmentPlanner.swift`
  + `Services/Persistence/DataStore+MilestoneAssessment.swift` — a mixed,
  cross-subject, **mastery-gap-weighted MCQ checkpoint**. D'Hondt slot
  apportionment by gap weight; weak-first interleave (reuses
  `JourneyPlanner.roundRobinReviews`); started subjects + gradable MCQs only
  (`isAssessableMCQ`); collision-safe `packId`-scoped resolution.
- `Views/Progress/MilestoneAssessmentView.swift` + `MilestoneAssessmentWindow.swift`
  — the Milestone Checkpoint (intro → one MCQ at a time → per-subject result).
  Local scoring; never writes the SRS. Help → Milestone Checkpoint (⌘⇧K).
- `Models/MilestoneCheckpointResult.swift` + `DataStore+MilestoneCheckpoint.swift`
  — durable, capped checkpoint history (`milestone_checkpoints.json`), held in
  memory (lazily hydrated) so the append-then-save never races the async write.
- `Services/WeeklyReportPDFExporter.swift` (extended) +
  `Models/ReportCardMasteryRow.swift` — a **two-page parent report card** (page 1
  = the weekly summary; page 2 = mastery-by-subject + the latest checkpoint),
  exported from `WeeklyProgressView`.

### Phase 5 — Olympiad / Expert challenge ladder ✅
- `Models/ExpertChallengeLadder.swift` + `Services/ExpertChallengePlanner.swift`
  + `Services/Persistence/DataStore+ExpertChallenge.swift` — a read-only,
  **mastery-gated** tiered ladder. `ExpertTier` stretch/challenge/olympiad,
  unlocking at 0.20 / 0.50 / 0.80 mastery (Familiar/Confident/Mastered). Questions
  are the hardest topic MCQs (`DifficultyBand` `.stretch` / `.challenge`) plus
  `deepDive.bonusQuestions` (→ Olympiad), classified + deduped + capped (25) per
  tier.
- `Views/Progress/MCQQuizComponents.swift` — shared `MCQOptionRow` /
  `MCQFeedbackBlock` (also adopted by the Milestone view; no duplication).
- `Views/Progress/ExpertChallengeLadderView.swift` + `ExpertChallengeLadderWindow.swift`
  — the Expert Challenges window (ladder → playable/locked tiers → MCQ challenge
  → result). Local scoring; never writes the SRS. Help → Expert Challenges (⌘⇧E).
- **Content note:** `deepDive.bonusQuestions` are not yet authored in any pack,
  so the **Olympiad tier is empty today** and the view hides empty tiers — the
  Stretch + Challenge tiers are richly populated from the existing difficulty-4/5
  questions. The ladder *mechanism* is complete and tested; the Olympiad tier
  lights up automatically once that beyond-grade content is authored (a content
  task, not a code one).

### Phase 6 — Integrate / test / doc ✅
- Help-menu wiring confirmed: Weekly Progress (⌘⇧W), Today's Plan (⌘⇧D),
  Achievements (⌘⇧A), Mastery Map (⌘⇧M), Milestone Checkpoint (⌘⇧K), Expert
  Challenges (⌘⇧E) — all shortcuts distinct.
- a11y: every new window has explicit button labels + combined card labels;
  meters/bars are accessibility-hidden with the owning card speaking the value.
  `check_a11y_labels` coverage ≥ ratchet floor.
- Reduce-motion / legacy-GPU: the new surfaces use static bars (no particles),
  and every transition routes through `withAnimationRespectingReduceMotion`.
- `LearningJourneyReadOnlyTests` — capstone test running all four read-only
  surfaces over the live registry and asserting the SRS is untouched.
- This document.

---

## Big-Sur invariants honoured throughout
Swift 5.5 / Big Sur 11.7.11 only — no macOS-12+ APIs; `if let x = x` form;
ViewBuilder ≤10 children (Group buckets); `@MainActor` methods wrapped in
closures where a `()->Void` is expected; SF Symbols via `SFSymbolCompat` (the new
views are SF-Symbol-free, using emoji/glyphs); no `try!`/`as!`/force-unwrap; no
raw `Color.mint/.indigo/.teal/.cyan/.brown` (DesignTokens only); `.atomic` writes;
≤600 LOC/file; cost gated on `HardwareTier.isLegacy`. The pbxproj is regenerated
via `scripts/generate_compat_pbxproj.py` (never hand-edited).

## How to verify
```
python3 scripts/generate_compat_pbxproj.py
bash scripts/ci-build-test.sh    # Release build + full XCTest
```
Expected: all Big-Sur static lints clean, `test_lints.py` PASS, **BUILD + 800
XCTest, 0 failures**.

## Follow-on content opportunity (not a code task)
Author `deepDive.bonusQuestions` (beyond-grade MCQs) across the packs to populate
the Expert Challenge **Olympiad** tier. The schema (`StretchTopic.bonusQuestions`)
and the whole ladder/UI already consume them; no code change is needed.
