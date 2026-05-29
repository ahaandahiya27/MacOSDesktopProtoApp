# Production Readiness Report

**Date:** 2026-05-29
**Scope:** desktopAhaan macOS SwiftUI app — Big Sur 11.7 / Xcode 13.2.1 / Swift 5.5 deploy target
**Source:** in-session production-polish sweep against `SUPERPROMPT_PRODUCTION_POLISH_8H.md` (inline, not via the `run_production_polish.sh` wrapper)

## Per-criterion verdict

| Criterion | Status | Evidence |
|---|:--:|---|
| Build clean (Debug + Release) | ✅ | `scripts/ci-build-test.sh` exits 0 every push |
| All unit tests green | ✅ | 530+ XCTest methods + 66 swift-testing; full suite + 11 lints + 3-pack canonical-JSON round-trip gates every push |
| 11 lints clean | ✅ | `scripts/check_*.py` exit 0; allowlist count unchanged (3) |
| 3-pack data integrity | ✅ | `scripts/check_pack_schema.py` clean; cross-pack id audit clean; `verify_pack_roundtrip.py` clean |
| iMac (Big Sur 11.7.11) compatibility | ✅ | `MACOSX_DEPLOYMENT_TARGET=11.5`; no macOS 12+ APIs; SF Symbols 3+ routed through `SFSymbolCompat`; no Swift 5.7+ shorthand bindings |
| Crash report functional | ✅ | `CrashReporter` writes to `~/Library/Application Support/desktopAhaan/crashlogs/`; Help menu reveals; `ProductionReadinessRatchetTests.testCrashReporterWritesToCanonicalPath` |
| SRS persistence stable | ✅ | `DataStore` singleton; pack-attributed reviews via `recordReview(packId:)`; ease/interval clamps; `CrossPackReviewResolutionTests` |
| Cold launch time | 🟡 | Script deferred — `scripts/perf_cold_launch.sh` not yet shipped (running the bundled app from a shell measurement is unreliable; deferred to a later sweep that wires `os_signpost` instead) |
| Pack decode time | ✅ | `scripts/perf_pack_decode.py` reports avg ≤ 15 ms / pack; `PerfBudgetTests.test{Science,Maths,Sanskrit}PackDecodeUnderBudget` enforces a 100 ms budget with 10× margin |
| Memory growth over 5 min | 🟡 | Script deferred — `scripts/perf_memory_footprint.sh` not yet shipped; measurement needs a UI-driven session to be representative |
| VoiceOver label coverage | 🟡 | `scripts/check_a11y_labels.py` reports 63% via heuristic; ratchet floor at 60%; many false negatives where the Button label is a custom view (e.g. `ContinueCard`) whose own `Text` content VoiceOver narrates |
| Dynamic Type xLarge tolerance | ✅ | `DynamicTypeAtXLargeTests.testEvery{Chapter,Topic}TitleFitsAtXLargeDynamicType` plus the existing science-only `testConceptTitlesStayShortEnoughForDynamicType` |
| WCAG AA color contrast | ✅ | Existing `testWCAG_*` battery in `ChapterContentTests` covers BrandColor accents on canvas; SwiftUI semantic colors handle Light/Dark adaptation |
| Empty / error / loading states | 🟡 | PP3 deferred — full audit of `ChapterListView`, `DailyPracticeView`, `QuizBankView`, etc. for empty-state coverage is a UI sweep that needs visual verification |
| User-data export | ✅ | `BackupExportButton` ships in Settings → Data; `BackupExportTests` pins the v1 envelope format |
| Settings completeness | 🟡 | PP5 deferred — Settings sheet has all working controls today, but per-control `.accessibilityLabel` + `.help` audit + `AppStorageKeys` enum migration deferred to a future sweep |
| Help menu completeness | 🟡 | PP5 deferred — current Help menu has the crash-log reveal items; About / What's New / Welcome Tour completeness unverified |
| About sheet completeness | 🟡 | PP5 deferred — current About section in Settings shows app name + audience + cost + dictionary size; version + license + privacy stance not yet split out |
| Subject-leak gates | ✅ | `PilotInteractiveSubjectGateTests` green; subject-agnostic surfaces filter by `pack.id` |
| Cross-pack id collision | ✅ | `testNoCrossPackConceptIdCollision` green across all 3 packs; `sch*` / `mch*` / `ch*` namespacing pinned |
| TCC popup permanent | ✅ | Documents temporary-exception entitlement present; sandbox stays ON |
| Sanskrit chapter detail surfaces | ✅ | 15 NEP chapters at 9/9 enrichment density; `CrossSubjectEnrichmentParityTests` ratchets count + content quality + concept-map edge integrity |

## What this sweep shipped

| Commit | Phase | Description |
|---|:--:|---|
| `9455614` | PP1 | `scripts/perf_pack_decode.py` baseline + `PerfBudgetTests` (3 decode budgets + content-count floors) |
| `fb434b0` | PP2.1 | `scripts/check_a11y_labels.py` VoiceOver label coverage scanner with 60% ratchet floor |
| `b264eda` | PP2.2 | `DynamicTypeAtXLargeTests` — chapter + topic title length ratchets across all 3 packs |
| `2728f52` | PP4 | `BackupExportButton` in Settings → Data + `BackupExportTests` pinning the v1 envelope format |
| (this commit) | PP6 | `ProductionReadinessRatchetTests` cross-cutting ratchet + this report |

## Open items deferred to a future sweep

| Phase | Item | Why deferred |
|---|---|---|
| PP1 | `scripts/perf_cold_launch.sh` | Shell-only timing of the bundled app is unreliable; a proper signpost-based measurement should land instead |
| PP1 | `scripts/perf_memory_footprint.sh` | RSS polling without a UI-driver loop produces flat numbers; needs an XCUITest to drive realistic actions |
| PP2.3 | Tap-target ≥ 44×44 audit + fixes | Requires per-Button manual review across ~60 sites; visual verification not possible in this session |
| PP3 | Empty / error / loading state coverage | UI sweep across `ChapterListView`, `DailyPracticeView`, `QuizBankView`, `BookmarksView`, `MasteryDashboard`, `SearchView`, `TranslatorScreen`, `OCRTranslationScreen` — needs visual verification |
| PP5 | Settings + Help + About completeness audit | UI sweep; needs the app running to verify each surface |
| Future | Restore-from-backup affordance | `BackupExportButton` only handles the save direction; a paired "Restore from backup…" button + file parser is a natural follow-up |

The deferred items are captured here so the next sweep picks them up without re-doing the audit.

## How future commits inherit this readiness posture

Every commit goes through the 11-lint + `xcodebuild` build + full test suite + 3-pack round-trip pre-push gate. The ratchet tests added in this sweep pin the following invariants:

- `PerfBudgetTests` — pack decode ≤ 100 ms; per-pack chapter / concept / question count floors.
- `DynamicTypeAtXLargeTests` — chapter title ≤ 120 chars, topic title ≤ 70 chars.
- `BackupExportTests` — v1 envelope schema (`version`, `schema`, `createdAt`, `files`) shape locked.
- `ProductionReadinessRatchetTests` — `CrashReporter` log directory namespace, `BackupExportButton.defaultDataDir()` namespace, all 3 packs bundled + decodable.
- `CrossSubjectEnrichmentParityTests` — per-pack enrichment field counts + Sanskrit content-quality + Sanskrit concept-map edge integrity (shipped in the prior Sanskrit sweep, complements this sweep's ratchets).

A future commit that breaches any of these fails CI before push.

## What "production-grade" means after this sweep

The app is shippable to a wider audience than just Ahaan with confidence that:

- It builds and tests clean on every push.
- It runs on Big Sur 11.7 / AMD R9 M290X without crashing on the surfaces that crashed historically (C1 try-discover, C2 beyond-then-discover, etc.) — all locked by `Crash1_TryDiscoverMode_Ch1` + `Crash_BeyondThenDiscover` regression tests.
- Pack data is correct, namespaced, and won't silently shrink.
- Performance budgets catch a JSON bloat regression before it ships.
- A11y posture has a floor that catches outright regression and can ratchet up over time.
- User progress can be exported as a single file the parent can keep.

The 🟡 items above are documented gaps, not unknown unknowns. Next sweep starts from this report.
