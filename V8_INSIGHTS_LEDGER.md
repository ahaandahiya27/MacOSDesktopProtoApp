# V8 — Longitudinal Insights & Dashboard Completion · LEDGER

Resumable progress ledger for the v8 autonomous run. Source of truth for "what's
done / what's next". Update + commit per milestone.

## Mission
Build the longitudinal layer: a read-only daily progress-history store derived
from the SRS (writes only `progress_history.json`), Big-Sur-safe trend charts
(pure `Path`/`Shape`, no `Charts`), week-over-week deltas, an Insights window,
per-subject Discover attribution, and the F.1 accessibility close-out.

## Hard invariants (never violate)
- Read-only over SRS; new surfaces write ONLY `progress_history.json` (+ a
  forward-compatible `discover.json` packId migration that adds attribution,
  never mutates reviews). Capstone test pins SRS byte-identical.
- Big Sur / Swift 5.5 rules (no macOS-12 APIs, no `Charts`, no `.foregroundStyle`,
  ViewBuilder ≤10, `if let x = x` long form, SFSymbolCompat, no force-unwrap,
  `.atomic` writes, ≤600 LOC/file, withAnimationRespectingReduceMotion, etc.)
- No hand-edit of pbxproj (use generate_compat_pbxproj.py), Package.swift,
  signing, deployment target, article renderer, SRS schema.
- No new packages/frameworks. Git: no --force/--no-verify/reset --hard.

## Baseline (Phase 0) — 2026-06-02
- `bash scripts/ci-build-test.sh` → **PASSED** (Release build + 810 XCTest + 66 swift-testing).
- `python3 scripts/test_lints.py` → **PASS**.
- Git HEAD at start: `97a4753` (Social Science readiness report).
- Foundation files read: MasteryEngine, DataStore+WeeklyActivity, DiscoverProgress,
  WeeklyReportPDFExporter, WeeklyProgressView, ShapeDiagramKit, LearningJourneyReadOnlyTests,
  AppStorageKeys, desktopAhaanApp Help-menu wiring, check_a11y_labels, POLISH_TODOS.

### Key facts gathered
- Persistence idiom: `var <store>: [...] = [:]` + `var didHydrate<X> = false` on
  DataStore; `hydrate<X>IfNeeded()` via `Self.readFile(T.self, from:"X.json", in: storeDir)`;
  writes via `saveCoalesced(Array(...), to:"X.json")` (atomic flush). storeDir is `let storeDir: URL`.
- Window idiom: `@MainActor final class <X>WindowPresenter: NSObject, NSWindowDelegate`
  singleton `.shared`, `present(dataStore:registry:)` makes an NSWindow w/ NSHostingController;
  `windowWillClose` nils the window. Wired in desktopAhaanApp.swift `CommandGroup(replacing:.help)`.
- **⌘⇧I is FREE** (taken: W,D,A,M,K,E,P,T,X,C,S,comma).
- AppStorageKeys at `Extensions/AppStorageKeys.swift` — `static let key = "key"`.
- ShapeDiagramKit at `Subjects/Tutor/Surfaces/ShapeDiagrams/ShapeDiagramKit.swift`:
  `SDFigure`, `SDLabel`, `SDChip`, `SDArrow`, `InsettableShape` structs. Axis pattern:
  `GeometryReader` + proportional origin + `Path{ move/addLine }.stroke(...)`.
- PDF exporter: `WeeklyReportPDFExporter.exportReportCard(activity:masteryRows:checkpoint:to:...)`;
  helpers `drawText(_:at:width:font:color:)`, `drawRow(label:detail:at:width:)`, `pct(_:)`,
  `drawPage(_:_:)`. Add page 3 via another `drawPage` call + a draw helper.
- check_a11y_labels.py COVERAGE_FLOOR = 90 (currently ~96%). Content-view suffixes
  Card/Cell/Row/Chip/Badge/Tile/Item/Entry/Banner/Pill/Tag/Block/Bubble credited.
- Capstone test `LearningJourneyReadOnlyTests`: `srsSignature(reviews)` hashes
  `totalReviews|lapses|bucket|ease|intervalDays|nextDueAt`; assert equal before/after.
- F.1: 24 unlabeled Image-only/keyboard-proxy buttons across CommandPalette,
  QuestionDetailView keyboard proxies, FlipCard/DiscoveryStepper.

## Phase status
- [x] Phase 0 — Baseline green + read files + ledger. **DONE**
- [x] Phase 1 — Progress-history store + pure helpers + tests. **DONE** (2026-06-02)
  - `Models/ProgressSnapshot.swift`: `SubjectProgressPoint`, `ProgressSnapshot` (Codable,
    one per start-of-day), `ProgressDelta`, `ProgressSeriesPoint`, and the pure
    `enum ProgressHistory { delta(from:to:), series(_:forPackId:), overallSeries(_:),
    weekOverWeek(_:now:calendar:) }`.
  - `Services/Persistence/DataStore+ProgressHistory.swift`: lazy hydrate, idempotent
    per-day `captureProgressSnapshot(registry:now:calendar:)` (overwrites today's row),
    rolling cap `maxProgressHistoryDays = 180`, atomic save via `saveCoalesced`, plus
    read accessors `progressHistorySorted/progressSeries/overallProgressSeries/progressWeekOverWeek`.
  - DataStore stored props `progressHistory: [Date:ProgressSnapshot]` + `didHydrateProgressHistory`.
  - Tests `desktopAhaanTests/ProgressHistoryTests.swift`: 6 pure + 4 capture (idempotent,
    cap, persist/rehydrate, SRS read-only). Build+test PASSED; all targeted lints clean.
  - Gotcha noted: tests must `flushSavesBeforeQuit()` (sync drain) not `flushPendingSave` (async).
- [x] Phase 2 — TrendChartView. **DONE** (2026-06-02)
  - `Views/Progress/TrendChartView.swift`: pure-SwiftUI line chart. `TrendLineShape`
    (normalized points → flipped rect) + `TrendGridShape` (gridlines + axes), both
    plain `Shape`s, no `Charts`/`Canvas`/`.foregroundStyle`. Self-contained: takes
    `[TrendSeries]` (overall + per-subject), owns a segmented toggle, plots mastery
    0–100% with a fixed y-domain. Reveal via `.trim` gated by
    `withAnimationRespectingReduceMotion` (instant under Reduce Motion); single
    stroked path → legacy-GPU safe. Endpoint dot, axis date labels, a11y description,
    "not enough history" empty state, and a `Preview_*` host.
  - Tests `desktopAhaanTests/TrendChartShapeTests.swift`: 5 pure path-geometry tests.
  - Gotcha: PreviewProvider types must be named `Preview_*` (or `_*`) or
    `check_dead_swift_types.py` flags them — the repo has no other PreviewProviders.
- [x] Phase 3 — Week-over-week delta + PDF page. **DONE** (2026-06-03)
  - `WeeklyProgressView`: `reload()` now captures today's snapshot (read-only) +
    computes `progressWeekOverWeek()`; new `weekOverWeekCard` shows signed overall
    `±N%` + per-subject deltas (≥0.5%), with arrow/colour and a first-week empty
    state. Export now passes `progressHistory` to the PDF.
  - `WeeklyReportPDFExporter`: new optional `progressHistory:` param → **page 3**
    "Progress Trend" = a CG `NSBezierPath` sparkline of the overall mastery series
    + signed week-over-week deltas (overall + per subject). Falls back to a note
    when <2 days. `shortLabel` gained `socialscience_class7 → "SocSci"`.
  - `desktopAhaanApp` launch onAppear captures a snapshot (no-ops until packs load).
  - `captureProgressSnapshot` now returns `ProgressSnapshot?` (nil = registry not
    loaded) so it's safe to fire at launch.
  - Tests: +2 PDF (trend page with/without history). Build+test PASSED.
  - Note: hit a transient stale-DerivedData "Framework … no Info.plist" failure;
    fixed by `rm -rf $TMPDIR/desktopAhaan-ci-derived` then re-running. Not a code issue.
- [ ] Phase 4 — Per-subject Discover attribution
- [ ] Phase 5 — InsightsView + InsightsWindow + ⌘⇧I + capstone test
- [ ] Phase 6 — F.1 a11y + new-surface a11y + ratchet
- [ ] Phase 7 — Integrate/test/doc + final sentinel

## STOP_AND_ASK count: 0
