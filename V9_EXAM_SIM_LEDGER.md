# V9 — Exam Simulation / Mock-Test mode — LEDGER

Resumable build ledger for the **timed Mock Test** feature. One agent, no human
input. Resume from the lowest unchecked box.

## Goal

A timed, auto-graded "Mock Test" surface that turns the existing question banks
(`questions` + `bossQuestions` + `quickCheckQuestions` + `deepDive.bonusQuestions`
across all 4 packs) into realistic practice papers. Setup → timed runner →
graded report. Results persist, surface in the parent Report Card, and reflect
into the Mastery Map by recording answers through the existing ephemeral-review
path. Reuses the v6 mastery-gap sampler (`MilestoneAssessmentPlanner`,
`JourneyPlanner`) — extends, never duplicates.

## Architecture (decided)

- **Pure planner reuse:** subject allocation + weak-first interleave come from
  `MilestoneAssessmentPlanner.compose` / `JourneyPlanner.roundRobinReviews`. The
  ONE new pure step is `MockTestEngine.topicBalancedOrder` (round-robin across a
  subject's topics so a paper spreads across chapters, not one chapter).
- **Pure grading:** `MockTestEngine.grade` applies a marking scheme (+4/−1 MCQ
  default, configurable), and produces per-subject + per-topic breakdowns,
  weak areas, and timing. FS-free, DataStore-free, fully unit-testable.
- **Live half:** `DataStore+MockTest.swift` (`@MainActor`) gathers candidate
  MCQs across all 4 banks filtered by difficulty band, gap-orders + topic-buckets
  them, calls the engine, persists results (`mock_test_results.json`, capped),
  and records answered questions via `recordEphemeralReview` (sanctioned write
  path — NOT a direct scheduler mutation).
- **SRS:** build + grade are strictly READ-ONLY. Recording is a separate explicit
  submit-time step. Mock test reuses REAL question ids (topic) + already-ephemeral
  boss/quick-check ids, so NO new ephemeral prefix is required; bonus-question ids
  that don't resolve are silently skipped by the existing resolver.
- **UI:** own AppKit window via the presenter pattern (like Milestone Checkpoint /
  Mastery Map). Setup (preset + subject + difficulty) → timed runner (countdown,
  Prev/Next, mark-for-review, question grid, Submit) → score report.

## Phase checklist

- [x] **Phase 0** — sync origin, regen pbxproj, 40 lints + `test_lints.py` green,
  baseline `ci-build-test.sh` green. Ledger created.
- [x] **Phase 1** — `MockTestEngine` + models + `DataStore+MockTest` build half +
  thorough pure unit tests (27 new XCTest, all green). `V9_PHASE1_COMPLETE_v1`.
- [x] **Phase 2** — Mock Test setup + timed runner UI (own window) + full report
  view + coordinator + presenter + Help-menu entry (⌘⌥M). UI complete, in-memory.
  `V9_PHASE2_COMPLETE_v1`.
- [x] **Phase 3** — persistence + ephemeral-review recording wired into the
  coordinator's submit; latest mock test surfaced in the parent Report Card PDF;
  mastery-map reflection via recording. +3 tests. `V9_PHASE3_COMPLETE_v1`.
- [ ] **Phase 4** — Help-menu entry + keyboard shortcut + full a11y +
  reduce-motion + HardwareTier gating + empty/edge states. `V9_PHASE4_COMPLETE_v1`.
- [ ] **Phase 5** — full test surface + XCUITest happy path + checkpoint doc.
  `V9_EXAM_SIM_COMPLETE_v1`.

## Decisions / notes

- Presets: **Quick** (15 Q / 20 min), **Standard** (30 Q / 45 min). Default Quick.
- Difficulty bands: **Foundation** (difficulty 1–2), **Balanced** (1–5),
  **Challenge** (3–5). A thin band yields a shorter paper (no filler), like the
  milestone sampler.
- Subject selection: **single pack** or **Mixed** (all 4, gap-weighted).
- Paper-question identity uses a composite `packId::questionId` so a colliding
  bare id (science `ch01_*` vs Sanskrit legacy `ch01_*`) never aliases.
- Keyboard shortcut: **⌘⌥M** (Mock Test) — free (only ⌘⌥P used in that modifier set).
- Big-Sur final confirmation = iMac rebuild (dev Mac can't compile the target);
  the v4/v8 static lints are the safety net.

## Progress log

- 2026-06-13: Phase 0 — clean tree, origin up to date, pbxproj regen, 40 lints +
  test_lints green, baseline build/test running. Studied milestone/mastery/journey
  infra. Ledger written.
- 2026-06-13: Phase 1 — added `Models/MockTest.swift` (config/preset/band/
  selection/marking/MockTestQuestion/MockTestPaper), `Models/MockTestResult.swift`
  (result + per-subject/per-topic/weak-area + outcomes, Codable),
  `Services/MockTestEngine.swift` (pure `topicBalancedOrder` + `grade`),
  `Services/Persistence/DataStore+MockTest.swift` (live `buildMockTest` reusing
  `MilestoneAssessmentPlanner.compose`, capped persistence, ephemeral-path SRS
  recording). Added `mockTestResults` storage to DataStore. 3 test suites / 27
  tests, all green; 40 lints + full ci-build-test green. `V9_PHASE1_COMPLETE_v1`.
- 2026-06-13: Phase 2 — added `Views/MockTest/`: `MockTestRunState` (timer state
  machine, testable `tick()`), `MockTestSetupView` (subject + difficulty +
  preset), `MockTestRunnerView` (countdown header, MCQ card reusing
  `MCQOptionRow`, mark-for-review, tappable question grid, Prev/Next/Submit with
  unanswered-confirm alert), `MockTestReportView` (marks score + stats +
  per-subject + weak topics + collapsible per-answer review), `MockTestWindow`
  (coordinator + AppKit presenter). Wired Help → "Mock Test" / ⌘⌥M. All
  @MainActor action methods wrapped in closures (mainactor-closure lint). 40
  lints + full ci-build-test green. Persistence + SRS recording + report-card
  surfacing deferred to Phase 3. `V9_PHASE2_COMPLETE_v1`.
- 2026-06-13: Phase 3 — `MockTestView.handleFinish` now persists the result
  (`recordMockTestResult`) and records each answered question through the
  ephemeral path (`recordMockTestReviews`), so a finished test reflects into the
  Mastery Map. Added a compact "Latest mock test" section to the report-card PDF
  (`WeeklyReportPDFExporter.exportReportCard` gained a defaulted `mockTest:`
  param; `WeeklyProgressView` passes `latestMockTestResult()`); kept the exporter
  at the 600-LOC ceiling by drawing the section only when a result exists. +2
  PDF tests, +1 mastery-reflection integration test. 40 lints + ci-build-test
  green. `V9_PHASE3_COMPLETE_v1`.
