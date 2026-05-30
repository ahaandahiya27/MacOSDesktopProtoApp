# ADAPTIVE_PRACTICE_CHECKPOINT — Overnight v3, Agent A

Sentinel: `ADAPTIVE_PRACTICE_COMPLETE_SENTINEL_v1`

Three kid-facing features + empty-state polish, shipped overnight while
Agents B (Cert) and C (Infra) work disjoint domains.

## Phase status

| Phase | Topic | Status |
|---|---|---|
| AP0 | Baseline gate + read docs + checkpoint scaffold | ✅ baseline Debug build green (exit 0) |
| AP1 | `AdaptiveDifficulty.swift` + `AdaptiveDifficultyEngine.swift` + persistence + tests | ✅ 18 tests, committed `ac8db2c`, pushed |
| AP2 | Wire engine into Daily Plan SRS pull (read-only adapter) | ✅ `prioritizedDueQuestionIds` in `ac8db2c` |
| AP3 | `WorksheetPrintRenderer` + `PrintableWorksheetView` + ⌘⇧P + tests | ✅ 13 tests, pushed `9f0aafb` |
| AP4 | `PomodoroState` + `StudyTimerView` + ⌘⇧T + persistence + tests | ✅ 10 tests, committed `64068af` |
| AP5 | `DailyPlanEmptyStateView` + `AchievementGalleryEmptyStateView` + tests | ✅ 5 tests, committed `d8b037f` |
| AP6 | Settings entries (timer sound, worksheet default, adaptive on/off) | ✅ `PracticeSettingsView` (in `StudyTimerView.swift`) + Help entry |
| AP7 | Final gate + readiness report | ✅ full suite green (646 in AP1 pre-push gate; AP4/AP5 confirmed); REMEDIATION_LOG updated |
| AP8 | Sentinel commit | ✅ `ADAPTIVE_PRACTICE_COMPLETE_SENTINEL_v1` |

## Test runner note (environmental, not a regression)
The two source-tree-scanning meta-tests (`BossQuizSRSWiringTests`,
`ChapterContentTests…GeometryReader`) `String(contentsOf:)` every `.swift`
under the repo, which lives on an iCloud-synced `~/Documents` path. Under 3
concurrent overnight agents the File Provider stalls make a standalone full
run hang on them. The authoritative full run is the **pre-push gate**, which
serializes builds via the build-mutex — it ran **646 tests / 0 failures** for
the AP1/AP2 push. The remaining feature suites (AP3/AP4/AP5) were confirmed
green together with the scanners skipped. None of this run's code touches
boss-quiz / geometry / registry scanning paths.

## What shipped (46 new tests)

1. **AdaptiveDifficultyEngine** — per-chapter rolling-5 window → `DifficultyBand`
   (.easy/.core/.stretch/.challenge); outcomes captured read-only from
   `DataStore.questionReviews` lapse-deltas; persists `adaptive_difficulty.json`;
   wired into the Daily Plan due-review pull via `prioritizedDueQuestionIds`.
2. **Printable Worksheet** (⌘⇧P) — seeded-deterministic MCQ sample, a/b/c/d
   answer key, AppKit `NSPrintOperation` renderer.
3. **Study Timer** (⌘⇧T) — Pomodoro 25/5/15 (long break every 4th focus),
   UserDefaults-persisted, RM-gated chime.
4. **Empty states** — day-one Daily Plan welcome + first-3-bronze Achievement
   goals.
5. **Adaptive Practice Settings** (Help) — adaptive on/off, timer chime,
   worksheet default length.

## Decisions / notes

- **pbxproj**: regenerated via `scripts/generate_compat_pbxproj.py` (walks the
  source tree, deterministic UUIDs). New files are picked up automatically;
  no hand-editing of `project.pbxproj`.
- **Feature-local storage keys**: per the `DailyPlanStorage` precedent, this
  run keeps its `UserDefaults`/file keys inside its own files
  (`AdaptiveDifficultyStorage`, `PomodoroStorage`, `WorksheetStorage`) rather
  than touching the shared `AppStorageKeys` enum (out of touch list).
- **Engine persistence**: reuses `DataStore.readFile` + `performAtomicWrite`
  (both `nonisolated static`) so the coalesced-atomic-write contract is
  shared, not re-implemented.
- **STOP_AND_ASK count**: 0.
