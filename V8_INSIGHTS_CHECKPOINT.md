# V8 — Longitudinal Insights & Dashboard Completion · CHECKPOINT

**Status: COMPLETE (2026-06-03).** Additive; zero regressions; zero STOP_AND_ASK.

## Why this run existed

The app was content- and surface-complete, but everything a parent saw was a
single-week snapshot — no *history*. POLISH_TODOS deferred three dashboard items
that all needed the same missing foundation (a persisted daily mastery series):
true week-over-week delta, a month/trend chart, and exact per-subject Discover
attribution. v8 built that longitudinal layer.

## What shipped

### The data foundation (Phase 1)
- `Models/ProgressSnapshot.swift` — one Codable row per calendar day
  (`SubjectProgressPoint` + overall fractions) plus the pure, `@MainActor`-free
  `enum ProgressHistory` analysis layer: `delta(from:to:)`, `series(_:forPackId:)`,
  `overallSeries(_:)`, `weekOverWeek(_:now:calendar:)`.
- `Services/Persistence/DataStore+ProgressHistory.swift` — lazy-hydrated store
  mirroring the `conceptVisits.json` idiom: **idempotent per-calendar-day capture**
  (re-capturing today overwrites that row), a **180-day rolling cap**, atomic
  coalesced writes to `progress_history.json`, and read accessors.
- Capture is cheap (one `MasteryEngine.snapshot` pass) and fires only off hot
  paths: app launch + when a dashboard/Insights surface opens. It **no-ops until
  the registry's packs load** (returns nil) so it never records an empty row.

### The trend chart (Phase 2)
- `Views/Progress/TrendChartView.swift` — a mastery-over-time line chart drawn
  **entirely with `Path`/`Shape`** (`TrendLineShape` + `TrendGridShape`). NO
  `Charts`, NO `Canvas`, NO `.foregroundStyle`, NO particles. Overall line + a
  per-subject segmented toggle, fixed 0–100% y-domain. The reveal is a single
  `.trim` gated by `withAnimationRespectingReduceMotion` (instant under Reduce
  Motion) — one stroked path, legacy-GPU safe. Empty state for <2 days.

### Week-over-week delta + PDF (Phase 3)
- `WeeklyProgressView` gained a "Compared with last week" card: signed overall
  `±N%` mastery + per-subject deltas, arrow/colour, first-week empty state.
- `WeeklyReportPDFExporter` gained **page 3 "Progress Trend"** — a Core-Graphics
  `NSBezierPath` sparkline of the overall series + signed week-over-week deltas
  (Big-Sur-safe; falls back to a note when <2 days).

### Per-subject Discover attribution (Phase 4)
- `DiscoverProgress` carries an optional `packId` (legacy `discover.json` rows
  decode as nil = forward-compatible) + pure `inferredPackId(fromChapterId:)` /
  `resolvedPackId`. The Weekly dashboard now splits Discover by owning subject —
  **Maths Discover lands under Maths, not Science.**
- **Maths caveat (documented):** the dashboard split is unambiguous because Maths
  Discover rows are already `mch`-prefixed. The cross-subject Whole-Journey *plan*
  still excludes Maths Discover, but for a *separate* reason — its slot lookup
  keys completions by the pack's bare `chNN` chapter id, which doesn't match the
  stored `mchNN` key; reconciling that through auto-Done is out of scope for this
  attribution pass. Exclusion comment in `DataStore+JourneyPlan.swift` updated.

### Insights window (Phase 5)
- `Views/Progress/InsightsView.swift` + `InsightsWindow.swift` tie the trend chart
  + week-over-week delta + per-subject standings together. **Help → Insights /
  ⌘⇧I** (verified free). Read-only over the SRS.

### Accessibility (Phase 6)
- a11y label coverage **96% → 100%** (floor 90). Labeled the Image-only refresh,
  the CommandPalette ×4 + QuestionDetailView ×4 keyboard-shortcut proxies (proxy
  containers `.accessibilityHidden`), the AchievementGallery badge button. New v8
  surfaces ship combined a11y labels. `check_a11y_labels.py` was made more
  accurate (skips `//`-comment matches; credits ternary-string labels) — floor
  untouched.

## The hard invariant, held

**Read-only over the SRS.** Every new surface derives from `MasteryEngine`/the
immutable packs and writes ONLY `progress_history.json` (plus the additive
`discover.json` `packId`, which adds attribution, never mutates a review). The
capstone `LearningJourneyReadOnlyTests.testEveryV8InsightsSurfaceIsReadOnlyOverSRS`
seeds reviews, captures three snapshots a week apart, exercises every series/delta
accessor, and asserts the SRS signature is byte-identical before/after.

## Test safety net

+25 XCTest methods this run → **835 XCTest + 66 swift-testing**. New/extended:
`ProgressHistoryTests` (idempotency, cap, persist/rehydrate, pure helpers, SRS
read-only), `TrendChartShapeTests` (pure path geometry), `DiscoverProgressAttributionTests`
(inference, legacy decode + recovery, round-trip), `WeeklyActivityRollupTests`
(per-subject split incl. Maths; legacy attribution), `WeeklyReportPDFExporterTests`
(trend page), and the v8 capstone.

## Honesty note (Big Sur)

Built on the dev Mac. Big-Sur compilation and AMD R9 M290X frame-rate are **not**
directly proven here — the proxy is: all Big-Sur static lints + dev-Mac
`ci-build-test.sh` green, and every new view reasoned against the Swift-5.5 rules
(no macOS-12 APIs, ViewBuilder ≤10, `if let x = x`, SFSymbolCompat, no
force-unwrap, atomic writes, ≤600 LOC/file, reduce-motion-gated animation).
**Final Big-Sur confirmation needs an iMac rebuild** (`scripts/imac-pull.sh`).

## Phase sentinels

```
V8_PHASE1_COMPLETE_SENTINEL_v1   progress-history store + pure helpers
V8_PHASE2_COMPLETE_SENTINEL_v1   TrendChartView (pure Path/Shape)
V8_PHASE3_COMPLETE_SENTINEL_v1   week-over-week delta + PDF trend page
V8_PHASE4_COMPLETE_SENTINEL_v1   per-subject Discover attribution
V8_PHASE5_COMPLETE_SENTINEL_v1   Insights window + ⌘⇧I + capstone
V8_PHASE6_COMPLETE_SENTINEL_v1   F.1 accessibility close-out
```
