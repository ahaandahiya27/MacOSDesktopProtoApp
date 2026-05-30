# ADAPTIVE_PRACTICE_CHECKPOINT — Overnight v3, Agent A

Sentinel: `ADAPTIVE_PRACTICE_COMPLETE_SENTINEL_v1`

Three kid-facing features + empty-state polish, shipped overnight while
Agents B (Cert) and C (Infra) work disjoint domains.

## Phase status

| Phase | Topic | Status |
|---|---|---|
| AP0 | Baseline gate + read docs + checkpoint scaffold | ✅ baseline Debug build green (exit 0) |
| AP1 | `AdaptiveDifficulty.swift` + `AdaptiveDifficultyEngine.swift` + persistence + tests | ⏳ |
| AP2 | Wire engine into Daily Plan SRS pull (read-only adapter) | ⏳ |
| AP3 | `WorksheetPrintRenderer` + `PrintableWorksheetView` + ⌘⇧P + tests | ⏳ |
| AP4 | `PomodoroState` + `StudyTimerView` + ⌘⇧T + persistence + tests | ⏳ |
| AP5 | `DailyPlanEmptyStateView` + `AchievementGalleryEmptyStateView` + tests | ⏳ |
| AP6 | Settings entries (timer sound, worksheet default, adaptive on/off) | ⏳ |
| AP7 | Final gate + readiness report | ⏳ |
| AP8 | Sentinel commit | ⏳ |

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
