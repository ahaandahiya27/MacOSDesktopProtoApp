# iMac handoff — 2026-06-14 (consolidated v8 + v9 + the Jun 11–13 sweep)

This document supersedes `IMAC_HANDOFF_2026-06-13.md`. It bundles every
unverified-on-Big-Sur item across three workstreams into ONE pass so a
single iMac verification confirms the whole stack:

1. **v8 longitudinal insights** (already in main since 2026-06-03, never
   fully iMac-verified)
2. **The 2026-06-11 → 2026-06-13 sweep** (J8 DesignTokens migration,
   H2 accessibility hints, T3 NavigationSmokeUITests, identifier sweep,
   audit fixes, 4 new lints, 3 new ratchet tests)
3. **v9 Exam Simulation / Mock Test mode** (shipped 2026-06-13 evening
   by the terminal session: MockTestEngine + setup + runner + report +
   persistence + SRS recording + Help → Mock Test / ⌘⌥M)

Total unverified backlog: **~46 commits** on `origin/main`. All passed
the dev-Mac `ci-build-test.sh` gate (xcodebuild + full XCTest). That
gate proves the code compiles on the newer Xcode but **does not**
prove Big-Sur 11.7.11 + Xcode 13.2.1 + Swift 5.5 compatibility.

---

## Quick start on the iMac

```bash
cd "/Users/ahaandahiya/Downloads/DesktopAhaan 4/desktopAhaan"
bash scripts/imac-pull.sh
# imac-pull quits Xcode, stashes pbxproj auto-edits, wipes DerivedData,
# pulls origin/main, reopens Xcode.

python3 scripts/test_lints.py        # 40 lint selftests
python3 scripts/generate_compat_pbxproj.py  # idempotent (v9 already in pbxproj)

# In Xcode:
#   ⇧⌘K  Clean Build Folder
#   ⌘B   Build
#   ⌘U   Test (full XCTest suite — should include the new MockTest* + ratchet tests)

bash scripts/ci-build-test.sh        # end-to-end gate: xcodebuild + full XCTest

# Optional (AX-grant required on the runner):
bash scripts/ci-build-test.sh --ui   # adds GoldenPathUITests + NavigationSmokeUITests + MockTestRunnerUITests
```

If everything is green, the entire v8 + sweep + v9 stack is
authoritatively verified.

---

## Session-wide invariants (verify the lint reports)

| Invariant | Verified by |
|---|---|
| **40 lints** clean | `scripts/check_*.py` |
| **717/717 Buttons labeled (100%)** | `check_a11y_labels.py`, floor=99 |
| **~3,490 padding/spacing/radius literals** → DesignTokens | `check_designtokens_spacing.py` + `check_designtokens_radius.py` |
| **217 `.accessibilityIdentifier`** literal sites, zero same-file collisions | `check_a11y_identifier_uniqueness.py` |
| **`Color(red:green:blue:)`** count frozen at 85 | `check_color_rgb_centralized.py` |
| **19 `@MainActor` singletons** covered by view-mainactor lint | `check_view_mainactor.py` |
| **3 deploy-target lints** have embedded selftests | `check_macos12_apis`, `check_swift55_syntax`, `check_sf_symbols_compat` |
| **Source-level ratchet tests** | HardwareTier / DataStore atomic / SFSymbolCompat floor |

---

## What's new since the 2026-06-13 handoff doc

### v9 Exam Simulation (5 commits, terminal-session 2026-06-13 evening)

Surface: **Help → Mock Test** or **⌘⌥M**. Setup picker (subject + difficulty + length preset) → timed runner with countdown clock → report card with score / breakdown / weak topics.

| Commit | What |
|---|---|
| `baa8ff3` | docs: Phase 0 — V9_EXAM_SIM_LEDGER + architecture baseline |
| `035c69a` | Phase 1 — `MockTestEngine` + models + grade core (pure, FS/SRS-free) |
| `e2ae548` | Phase 2 — Setup + timed runner + report UI + window presenter |
| `cadb610` | Phase 3 — persist results (cap=50, atomic) + record into SRS via ephemeral-review path + surface in Report Card PDF |
| `ffdcd3b` | Phases 4-5 — keyboard nav (⌥← / ⌥→ / ⌘↩ / ⌘. / ⌘M) + `MockTestRunStateTests` (13) + `MockTestRunnerUITests` + `V9_EXAM_SIM_CHECKPOINT.md` |

**iMac risks specific to v9:**
- `MockTestRunState` uses a Timer with `[weak self]` (LH004b allowlist check this).
- The runner's countdown clock + auto-submit logic — verify it ticks correctly on Big Sur's older Combine implementation.
- `MockTest` window is a separate AppKit `NSWindow` via `MockTestWindowPresenter` (same pattern as `WeeklyProgressWindowPresenter` / `InsightsWindowPresenter` — multi-window scene APIs are macOS 13+, so stays AppKit).
- v9 added ~43 new XCTest methods across 5 files + 1 XCUITest file. All ALREADY in `project.pbxproj` (verified). Should compile + run on Big Sur with no extra wiring.

**Verify on iMac:**
1. `⌘B` — should compile clean.
2. `⌘U` — should run all v9 tests green: `MockTestEngineTests` (11), `MockTestModelTests` (8), `MockTestBuildTests` (9), `MockTestRunStateTests` (13), `WeeklyReportPDFExporterTests` (+2 new), and the existing suite.
3. **Smoke walk:** Help → Mock Test → Quick / Mixed / Balanced → Start → answer 2–3 questions → mark one for review → tap question grid → Submit (with unanswered remaining) → confirm → report renders with score + per-subject breakdown.
4. The report should show a "Latest mock test" section the next time you generate the Report Card PDF from Insights / Weekly.

### NavigationSmokeUITests pbxproj wired up

Previously the 2026-06-13 handoff flagged an ACTION REQUIRED — `NavigationSmokeUITests.swift` was on disk but not in `project.pbxproj`. The terminal session's `python3 scripts/generate_compat_pbxproj.py` run picked it up. **Status: ✅ wired in, 3 refs in pbxproj.**

**Verify:** `⌘U` should now run `test_homeToQuestionDetail_endToEnd` as part of the suite. If selectors don't match the real UI tree on Big Sur, fix in place.

---

## Recap: items from the 2026-06-13 handoff (still apply)

### J8 — DesignTokens migration (Waves 1–6) — ~3,490 literals migrated

Commits `3700f6a` → `7355eff`. Byte-equivalent (Spacing.sm = CGFloat(8)); compiled output identical to pre-migration. iMac risk: low — visual smoke on a few chapters.

### T3 — NavigationSmokeUITests (`9650c99` + pbxproj add)

Now wired. Walks home → chapter → topic → concept → question end-to-end. Big-Sur risk: selectors were never compile-checked on this dev Mac (the file wasn't in the build until terminal Claude wired it). If `⌘U` errors on selector mismatches, fix in place.

### H2 — `.accessibilityHint(...)` sweep (`6a1386b`)

~169 hints added across ~89 files. iMac risk: none — `.accessibilityHint(_:)` is macOS 10.15+ and additive.

### Identifier sweep — `.accessibilityIdentifier(...)` (`1a26b0e` → `04ed86a`)

259 new identifiers across 82 files (total 270, post-v9: 217 literal sites). iMac risk: none — additive, macOS 10.10+.

### Menu tooltip pass (`5f4046c`)

28 `.help(...)` on every menu command in `desktopAhaanApp.swift`. iMac risk: none.

### Big-Sur latent bug fix — `QuestionDetailView @MainActor` (`7628822`)

`@MainActor` added to the struct because it calls `SettingsManager.shared.autoAdvanceOnCorrect` synchronously. **The expanded `check_view_mainactor.py` (19 singletons, was 1) caught this**.

**iMac risk:** if Big-Sur build fails at QuestionDetailView with "actor isolation" errors, the fix didn't propagate to an extension. Look for any `extension QuestionDetailView` in the same file that also needs explicit `@MainActor`.

### Code quality — dead iOS shim delete (`e715293`)

176 LOC of `#if os(iOS)` blocks deleted from `SpeechRecognitionManager.swift`. The remaining `deactivateAudioSession()` is an empty no-op stub.

**Verify:** Sanskrit voice playback (translate → "Speak Result") should still work — that's `TextToSpeechManager`, a separate file from `SpeechRecognitionManager`.

### Code quality — Notification.Name consolidation (`dc28d4f`)

11 `Notification.Name` decls moved from `desktopAhaanApp.swift` into `Extensions.swift`. Pure relocation.

**Verify:** ⌘O (Open Image), ⌘T (Translate), ⌘K (Speak Result) all work via menu commands.

### Big-Sur compile failure caught + fixed — `fileprivate` regression (`fbc38f5` → `dcc9d76`)

`fbc38f5` did a bulk `fileprivate` → `private` sweep based on an audit that mis-classified 9 sites as "single-file usage." `dcc9d76` restored `fileprivate` on those 9 sites (BossQuiz ×6 + ParticleEmitter + SubjectPack + Scene1_IceToWaterToSteam). **The dev-Mac pre-push xcodebuild caught the breakage** (rc=65 BUILD FAILED) before it could ship — the gate worked.

**Memory entry saved:** `feedback_private_vs_fileprivate_sibling_access.md` — grep `<TypeName>.<MemberName>` cross-references in the same file BEFORE swapping `fileprivate` → `private`.

### Lint additions (36 → 40)

- `check_designtokens_spacing.py` + `check_designtokens_radius.py` (2026-06-12, J8)
- `check_a11y_identifier_uniqueness.py` (2026-06-13)
- `check_color_rgb_centralized.py` (2026-06-13)
- `check_macos12_apis.py` / `check_swift55_syntax.py` / `check_sf_symbols_compat.py` got embedded `--selftest` (2026-06-13)

### Test additions — 3 source-level ratchets (`d7dc8e8`)

`testHardwareTierBudgetsAreReasonable`, `testDataStoreEveryWriteUsesAtomicOption`, `testSFSymbolCompatTableMeetsCoverageFloor` — added inside `ProductionReadinessRatchetTests.swift`. Use `#filePath` for path resolution.

### v8 longitudinal insights (NOT verified on iMac yet)

Pre-dates this session — shipped 2026-06-03 but `V8_INSIGHTS_CHECKPOINT.md` notes the Big-Sur compilation / frame-rate is "verified only by static lints + dev-Mac ci-build-test.sh; final confirmation needs an iMac rebuild." That confirmation is part of THIS pass.

**Surfaces to spot-check on the iMac:**
- Help → **Insights** (⌘⇧I) — `TrendChartView` is pure Path/Shape (no Charts framework). Verify the line/bar renders without flicker.
- Weekly Progress (⌘⇧W) — week-over-week ±N% delta card.
- The PDF export from Weekly should have 3 pages now (Trend page added in v8).

---

## What the iMac should still flag (worth watching for)

1. **`ViewBuilder` >10 children** — already lint-checked but Swift 5.5's error is cryptic ("Extra argument in call"). Hits often in `var body`.
2. **`@MainActor` method-by-reference** — `check_mainactor_closure_refs.py` covers; if it slipped, the message is "Converting non-sendable function value...".
3. **macOS 12+ API leak** — `check_macos12_apis.py` covers 44 rules with selftest. If new code introduced a previously-unseen API, it'd surface as "is only available in macOS 12.0 or newer".
4. **Line-number drift in allowlists** — `dc28d4f` bumped `Extensions.swift:484 → :498` for the Timer/LH004b allowlist. If Big-Sur build flags Extensions.swift at a DIFFERENT line for the same rule, bump again in same commit.

---

## If the iMac build fails

1. `bash scripts/imac-pull.sh` — wipes DerivedData first.
2. `python3 scripts/generate_compat_pbxproj.py` — picks up any newly-added files.
3. `python3 scripts/test_lints.py` — every selftest should PASS.
4. Each `python3 scripts/check_*.py` — should all exit 0.
5. Open Xcode → ⌘B. Read the FIRST error in the navigator.
6. If error is in QuestionDetailView → see "Big-Sur latent bug fix" above.
7. If error is in a Discover scene around `Task.sleep(nanoseconds: DiscoverTiming.settleDelayNs)` → check `DiscoverMode.swift` for the `enum DiscoverTiming` declaration.
8. If error is in a MockTest file → check that `MilestoneAssessmentPlanner.compose` and `MasteryEngine.snapshot` are still accessible (v9 reuses them).
9. If genuinely stuck, paste the FIRST error message + 5 surrounding lines into a fresh iMac Claude Code session.

---

## Hard "don't touch" list (CLAUDE.md invariants)

- `MACOSX_DEPLOYMENT_TARGET = 11.5` (pbxproj). Do NOT lower to 11.0.
- `Package.swift` — none expected.
- Signing — stays ad-hoc (`CODE_SIGN_IDENTITY = -`).
- Article renderer — `NativeArticleRepresentable.swift`, `ArticleStructuredRenderer.swift` are LOCKED.
- SRS schema — `QuestionReview`, `SM2Scheduler` are LOCKED. (v9's `recordMockTestReviews` uses the SANCTIONED `recordEphemeralReview` path, not direct scheduler mutation.)
- Files ≤600 LOC except the 2 grandfathered (`QuestionDetailView`, `DataStore`).

---

## Final state once the iMac is green

Update `CLAUDE.md`'s "Current status" date line to the verification date and commit-and-push the one-line bump as the close-out. Mark the relevant 🟡 rows in `docs/ISSUE_CATEGORIES.md` if visual verification surfaces any new issues.

The full session ledger from `baa8ff3` back through `3700f6a` is on origin — `git log --oneline 3700f6a^..HEAD` enumerates all ~46 commits.
