# V9 — Exam Simulation / Mock-Test mode — CHECKPOINT

**Status: complete (dev-Mac + static-lint verified; final Big-Sur confirmation = iMac rebuild).**

A timed, auto-graded **Mock Test** surface that turns the existing question
banks into realistic practice papers, grades them against a marking scheme, and
feeds the results into the systems already built (parent Report Card, Mastery
Map). Built read-only over the SRS for assembly + grading; the one deliberate
write (recording answered questions) goes through the sanctioned ephemeral-review
path.

## How to use it

- **Help → "Mock Test"** or **⌘⌥M** opens the window.
- **Setup:** choose a subject scope (Mixed — all subjects, or a single subject),
  a difficulty band (Foundation 1–2 / Balanced 1–5 / Challenge 3–5), and a length
  preset (**Quick** 15 Q / 20 min, **Standard** 30 Q / 45 min). Defaults: Mixed ·
  Balanced · Quick.
- **Runner:** countdown clock (turns red in the last minute), one question at a
  time, Prev/Next (⌥← / ⌥→), Mark-for-review, a tappable question grid, and
  Submit (confirms if questions are unanswered). The clock auto-submits at zero.
- **Report:** marks score (+4 / −1 default scheme), correct / wrong / skipped +
  time used, per-subject breakdown, the weakest topics to revisit, and a
  collapsible per-answer review. "New test" rebuilds; "Done" closes.

## Architecture

| Layer | File | Notes |
|-------|------|-------|
| Models | `Models/MockTest.swift` | config, preset, difficulty band, subject selection, marking scheme, `MockTestQuestion` (composite `packId::id` identity), `MockTestPaper` |
| Models | `Models/MockTestResult.swift` | Codable result + per-subject / per-topic / weak-area + outcomes |
| Engine (pure) | `Services/MockTestEngine.swift` | `topicBalancedOrder` (round-robin across a subject's topics, gap-front-loaded) + `grade` (marking scheme, breakdowns, timing). FS/DataStore/SRS-free |
| Live half | `Services/Persistence/DataStore+MockTest.swift` | `buildMockTest` gathers MCQs across all 4 banks (topic/boss/quick-check/deep-dive) filtered by band, then REUSES `MilestoneAssessmentPlanner.compose` for subject apportionment + weak-first interleave; capped persistence; `recordMockTestReviews` (ephemeral path) |
| Runner state | `Views/MockTest/MockTestRunState.swift` | `ObservableObject` clock/answers/marks state machine; testable `tick()`; PomodoroState-style `Timer` |
| UI | `Views/MockTest/MockTest{SetupView,RunnerView,ReportView,Window}.swift` | setup → runner → report coordinator + AppKit window presenter |

### Reuse, not reinvention
- Subject apportionment (D'Hondt by mastery gap) + weak-first interleave come
  straight from `MilestoneAssessmentPlanner.compose` / `JourneyPlanner`. The only
  NEW pure step is `MockTestEngine.topicBalancedOrder` (topic spread within a
  subject) — the milestone sampler doesn't balance across topics.
- MCQ rendering reuses the shared `MCQOptionRow`.
- Mastery weighting reuses `MasteryEngine.snapshot`.

### SRS stance
- **Build + grade are strictly READ-ONLY** over `questionReviews` (pinned by
  `MockTestBuildTests.testBuildIsReadOnlyOverSRS` + the engine's pure grading).
- **Recording is one deliberate step** at submit (`recordMockTestReviews`):
  each ANSWERED question → `recordEphemeralReview` (correct → `.good`, wrong →
  `.forgot`); unanswered are not recorded. Real topic ids resolve normally;
  boss/quick-check ids are already ephemeral; an unresolvable deep-dive bonus id
  is silently skipped by the existing resolver. **No new ephemeral prefix was
  needed** (no synthetic ids are minted). This is the SM-2-sanctioned write path,
  not a direct scheduler mutation — so a finished test reflects into the Mastery
  Map.

### Integration
- Results persist to `mock_test_results.json` (capped at 50, atomic writes).
- The parent **Report Card PDF** gained a compact "Latest mock test" section
  (`WeeklyReportPDFExporter.exportReportCard` `mockTest:` param; drawn only when a
  result exists, keeping the exporter at the 600-LOC ceiling).
- The **Mastery Map** updates automatically because recording writes real reviews.

## Tests (all green on the dev Mac)

- `MockTestEngineTests` (11) — topic-balanced ordering (round-robin, weakest-first,
  determinism, empty/single) + grading (+4/−1, gentle scheme, marks-fraction
  clamp, per-subject/per-topic breakdown, weak-area sort + threshold, timing).
- `MockTestModelTests` (8) — band admission/clamp, config clamps, presets,
  marking scheme, paper derived props + composite identity.
- `MockTestBuildTests` (9) — determinism, no-duplicates, read-only-over-SRS,
  single-subject scoping, band filtering, no-registry empty, persistence
  round-trip + cap, recording-writes-only-answered, mastery-map reflection.
- `MockTestRunStateTests` (13) — clock decrement/charge, auto-submit at zero,
  low-time, select/mark, navigation clamp, status, manual-submit idempotence +
  injected-clock grading, post-finish no-ops, format, leak-safety.
- `WeeklyReportPDFExporterTests` (+2) — report card with/without a mock-test result.
- `desktopAhaanUITests/MockTestRunnerUITests` — runner happy-path walk (⌘⌥M →
  Start → mark/grid → Submit → confirm → report). `--ui` opt-in (AX grant
  required); default ci-build-test compiles it but skips execution.

## Big-Sur compatibility

All v4/v8 static lints (viewbuilder limit incl. menus, mainactor-closure-refs,
macos12-apis, swift55-syntax, sf-symbols-compat, inline-modifier-math,
designtokens spacing/radius, a11y label/identifier) are GREEN. Specifics:
- No macOS 12+ APIs; `Timer.scheduledTimer` (not `Task.sleep`/`TimelineView`);
  AppKit monospaced clock font (SwiftUI `.monospacedDigit()` Font is 12+);
  `Picker(.segmented)`, `LazyVGrid`, `.alert(isPresented:)` are all macOS 11.
- Every `@MainActor` action passed to a `Button`/closure is wrapped.
- All transitions go through `withAnimationRespectingReduceMotion`.
- **HardwareTier:** the surface uses only STATIC bars/text (no particles, no
  per-frame animation), so it costs the legacy AMD R9 M290X nothing — no explicit
  `HardwareTier.isLegacy` gate is needed (same stance as the Milestone Checkpoint
  view).

⚠️ **Final Big-Sur confirmation requires an iMac rebuild** — this dev Mac cannot
compile the Big-Sur target; the static lints + dev-Mac `ci-build-test.sh` are the
safety net. The new UITest also needs the runner's Accessibility grant on the
iMac to execute (it's `--ui` opt-in).

## Edge / empty states

- **Not enough questions** for the chosen subject + band → a friendly "try
  Balanced / Mixed / shorter" state instead of an empty runner.
- **Time up** → auto-submit; the report flags "Time ran out — submitted
  automatically."
- **Submit with unanswered** → confirm alert ("Submit anyway").
