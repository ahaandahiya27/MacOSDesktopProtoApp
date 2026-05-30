# DAILY_PLAN_BADGES_CHECKPOINT

Agent A · Overnight v2 · Daily Plan + Achievement/Badge system.
Sentinel on completion: `DAILY_PLAN_BADGES_COMPLETE_SENTINEL_v1`.

## Baseline (DA0) — 2026-05-30

- Base HEAD: `030489c`.
- Debug build: **BUILD SUCCEEDED** (derivedData `/tmp/dd-daily-plan`, `MACOSX_DEPLOYMENT_TARGET=11.5`).
- Hard lints: green. Only advisory `check_callout_reading_level.py`
  flags a pre-existing Scene8 string (forbidden file — not touched).
- Gate policy adopted: run every `scripts/check_*.py` EXCEPT
  `check_callout_reading_level.py` (advisory, matches `ci-build-test.sh`
  which never gates on it).

## Key integration facts discovered (read before editing)

- `DataStore` is `@MainActor`, `ObservableObject`. Persistence via
  `save(_:to:)` (cold/atomic) + `saveCoalesced(_:to:)` (250 ms debounce).
  Off-thread loader `loadAllOffThread` in `DataStore+Loading.swift`.
- Lazy-hydrate pattern for non-`@Published` maps:
  `conceptVisitHistory` + `hydrateConceptVisitsIfNeeded()` /
  `didHydrateConceptVisits`. **Achievement unlocks follow the same
  lazy-hydrate pattern** so cold launch pays nothing.
- Existing signals to observe / read for criteria:
  - SRS: `questionReviews: [String:QuestionReview]`, `dueQuestionIds(at:)`,
    `dueQuestionCount(at:)`. `MasteryLevel.from(review:)` buckets a review.
  - Streak: `UserDefaults` keys `AppStorageKeys.reviewStreakDays /
    reviewStreakLastDate / reviewStreakBest` (credited in `recordReview`).
  - Concepts visited: `conceptVisitHistory` (lazy). Understood:
    `understoodConceptIds` (`@Published`).
  - Discover: `discoverProgress: [DiscoverProgress]`, `discoverRowCount(for:)`,
    `Self.discoverSceneCounts` (per-chapter), `Self.totalDiscoverScenes`,
    `allDiscoverChaptersComplete`.
  - Articles: `readArticleIds: Set<String>` (`@Published`).
- `SubjectRegistry` (`@MainActor`) resolves question/chapter locations;
  `pack(withId:)`, `location(forQuestionId:preferredPackId:)`.
  `DiscoverMode.hostPackId == "science_class7"`.
- Windowed feature pattern (no ContentView/AppState edits available this
  run — domain-locked): `WeeklyProgressWindowPresenter` opens an
  `NSHostingController` window from the App command block. Daily Plan +
  Achievements reuse this exact pattern.
- pbxproj is **explicit** (no synchronized groups). New source files are
  registered by re-running `python3 scripts/generate_compat_pbxproj.py`
  (deterministic MD5-of-path UUIDs — safe to re-run after a rebase to
  reconcile against whatever files are on disk).
- Big Sur constraints enforced by lints: macOS 12+ APIs, Swift 5.5 syntax,
  SF Symbols via `SFSymbolCompat.name(_:)`, ViewBuilder ≤10 children,
  600-LOC ceiling, RM-gated animation via
  `withAnimationRespectingReduceMotion`, no raw `Color.indigo/...` (use
  `Color.compat*`), no `.foregroundColor(.yellow/...)` on Text (use
  `DesignTokens.BrandColor.*`).

## Touch-list deviations / decisions

- **Sidebar "🏆 Achievements" entry deferred**: the sidebar lives in
  `AppState`/`ContentView`, which are NOT in this agent's write-allowlist
  (domain-locked to Agents B/C territory). Achievements + Daily Plan are
  therefore reached via Help menu + keyboard shortcuts + their own
  windows (the shipped `WeeklyProgress` pattern). Logged to POLISH_TODOS.
- **⌘⇧D conflict**: existing "Show Discover Progress" used ⌘⇧D. The brief
  assigns ⌘⇧D to Daily Plan. Resolution recorded in DA5 below.

## Phase log

- **DA0** ✅ baseline gate green + checkpoint scaffold.
- **DA1** ✅ `Achievement.swift` — 24 badges across 5 families × 4 tiers,
  pure `AchievementCriterion`/`AchievementSnapshot`/`AchievementProgress`
  value types. `AchievementCatalogTests` (16) pin the exact 24-id set,
  per-family counts, every-tier coverage, threshold firing, progress hints,
  sound gating.
- **DA2** ✅ `AchievementEngine.swift` (debounced observer of DataStore +
  registry, silent first-launch backfill, pure `newlyUnlocked` core) +
  `DataStore+Achievements.swift` (`achievements.json` round-trip via the
  shared coalesced-write plumbing + the snapshot builder + static metric
  helpers) + `AchievementToastView.swift` (top-right slide-in NSPanel,
  RM-gated, gold/platinum chime). `AchievementEngineTests` (12).
- **DA3** ✅ `AchievementGalleryView.swift` (4-col LazyVGrid by family,
  auto-hides not-yet-started badges, detail sheet) + `AchievementBadgeView`
  (locked grayscale + lock glyph + progress hint / unlocked colour + date)
  + `AchievementGalleryWindow.swift` presenter (⌘⇧A). Render-smoke tests in
  `AchievementGalleryViewTests` (empty/partial + badge/detail/toast states).
- **DA4** ✅ `DailyPlan.swift` (model, 3 AM plan-day boundary, completion
  semantics, `DailyPlanStorage` keys) + `DataStore+DailyPlan.swift`
  (rollup: ≤3 due reviews + 1 unmastered/unvisited concept + 1 open Discover
  chapter; reconcile auto-Done; streak credit; pure static helpers).
  `DailyPlanRollupTests` (11).
- **DA5** ✅ `DailyPlanView.swift` (header w/ streak + done count, 5-item
  list, tap-through routing via AppState `pendingRoute`, ✓/Skip controls,
  auto-Done on DataStore change) + `DailyPlanWindow.swift` presenter (⌘⇧D).
  Render-smoke in `DailyPlanViewTests`.
- **DA6** ✅ `DailyPlanNotifications.swift` — opt-in daily 5pm
  `UNUserNotificationCenter` reminder, permission requested on first Daily
  Plan open (graceful decline), toggle surfaced in the Daily Plan window
  (Settings screen is out-of-domain). No-ops under XCTest. No new
  entitlement (local notifications need none → locked set untouched).
- **DA7** ✅ 24-badge id ratchet lives in `AchievementCatalogTests`
  (`testAllBadgeIdsAreUniqueAndStable` pins the exact set; persistence
  contract). View render-smokes pin no-crash across unlock states.
- **DA8** ✅ checkpoint updated; sentinel printed.

## SHIPPED — pushed to origin/main

- Feature commit `de6ce38`, test-hardening commit `335b632` (precise
  UserDefaults restore). Pushed `528a513..335b632 main -> main` (carried
  Agent C's onboarding `211fce7`/`d04a1af`/`b7118dd` along, which had been
  deferred for the same parallel-gate reason).
- **Pre-push gate green: 628 tests, 0 failures** (Release build + all lints
  + full Debug suite), run uncontended (~26 min — the iCloud-synced
  source-scanning meta-tests dominate wall time).
- First push attempt was rejected by 7 `ChapterContentTests.testStreak_*`
  failures — proven to be **cross-process `UserDefaults.standard`
  contention** from a concurrent parallel-agent test host (Agent C hit the
  same wall, see `b7118dd`). The streak suite passes green in isolation
  immediately after this agent's tests; `335b632` additionally hardens this
  agent's own restore logic so it can never contribute residue.

## DA5 — ⌘⇧D resolution

Daily Plan takes **⌘⇧D** (per brief). "Show Discover Progress" moves to
**⌘⌃D** so both stay reachable from the keyboard. The sidebar badge string
for Discover (`SidebarTool.discover.keyboardShortcut` in `AppState`) still
reads "⌘⇧D" — `AppState` is out-of-domain this run, so updating that badge
to "⌘⌃D" is queued in POLISH_TODOS for the surface owner.

## Cross-agent note

Arrived to find Agent C's `feat(dist)` (first-launch onboarding + DMG +
docs) committed to `main` as `211fce7` mid-session, plus stale foreign WIP
in the main worktree. Reset my tree to C's committed baseline, regenerated
the pbxproj as the union of C's tracked files + my new files, and built my
Daily-Plan/Achievements work on top. Only my touch-list files + the shared
pbxproj + app.swift menu additions are staged in my commits.

## Integration / engine start

`AchievementEngine.shared.start(dataStore:registry:)` is invoked from a
`.onAppear` on the App's `ContentView` (the App command block is in my
allowlist), so the engine observes from launch and toasts fire during
normal use. Daily Plan + Achievements open in their own AppKit windows via
singleton presenters (same pattern as the shipped Weekly Progress window).
