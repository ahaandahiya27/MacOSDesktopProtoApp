# iMac handoff — 2026-06-13 session

This document is a paste-ready verification checklist for the deploy
iMac (Big Sur 11.7.11 / Xcode 13.2.1 / Swift 5.5 / AMD R9 M290X). It
captures every commit shipped in the 2026-06-11 → 2026-06-13 multi-day
session and maps each to **what to verify on the iMac** + **specific
risks** the dev-Mac toolchain cannot catch.

The session shipped **41 commits** to `origin/main`. All passed
pre-push xcodebuild + tests on the dev Mac (macOS 26.5 / newer Xcode).
That gate is necessary but **not sufficient** — Big-Sur-specific
failures (ViewBuilder >10, `@MainActor` method-by-reference, macOS 12+
APIs slipping past the lint, SF Symbols 3+ unrouted) compile fine on
the dev Mac.

---

## Quick start on the iMac

```bash
cd "/Users/ahaandahiya/Downloads/DesktopAhaan 4/desktopAhaan"
bash scripts/imac-pull.sh
# imac-pull quits Xcode, stashes any pbxproj auto-edits, wipes DerivedData,
# pulls the 41 new commits, and re-opens Xcode.
python3 scripts/test_lints.py        # 40 lint selftests
python3 scripts/generate_compat_pbxproj.py  # picks up the new test methods + any new .swift files
# Then in Xcode:
#   Product → Clean Build Folder (⇧⌘K)
#   Product → Build (⌘B)
#   Product → Test (⌘U)
bash scripts/ci-build-test.sh        # xcodebuild + full XCTest, end-to-end
```

If all of the above pass, the session's work is **authoritatively
verified** on Big Sur and you can close this doc.

---

## Session-wide invariants (already enforced; verify the lint reports)

| Invariant | How it's enforced |
|---|---|
| 40 lints clean | `scripts/check_*.py`, wired through `ci-build-test.sh` |
| 706/706 Buttons labeled (exact 100%) | `check_a11y_labels.py` floor=99, current=100% |
| ~3,490 padding/spacing/radius literals migrated to DesignTokens | `check_designtokens_spacing.py` + `check_designtokens_radius.py` |
| 270 stable `.accessibilityIdentifier` selectors, zero same-file collisions | `check_a11y_identifier_uniqueness.py` |
| `Color(red:green:blue:)` site count frozen at 85 | `check_color_rgb_centralized.py` |
| 19 `@MainActor` singletons covered by view-mainactor lint | `check_view_mainactor.py` |
| 3 deploy-target lints have embedded selftests | `check_macos12_apis`, `check_swift55_syntax`, `check_sf_symbols_compat` |
| DataStore writes use `.atomic` (Swift-side ratchet) | `testDataStoreEveryWriteUsesAtomicOption` |
| HardwareTier budgets sane (20-200 particles, 15-60 fps) | `testHardwareTierBudgetsAreReasonable` |
| SFSymbolCompat fallback table ≥40 rows | `testSFSymbolCompatTableMeetsCoverageFloor` |

---

## Session commits by surface (what to actually inspect on the iMac)

### J8 — DesignTokens migration (Waves 1–6) — **~3,490 literal substitutions**

Commits: `3700f6a` (Wave 1 Discover) → `317b5a8` (Wave 5 LazyVGrid) → `7355eff` (Wave 6 mop-up), plus the Articles browser commits in between.

**iMac risk:** Spacing/radius values are byte-equivalent (`DesignTokens.Spacing.sm` = `CGFloat = 8`) so the compiled binary is identical to the pre-migration version. Should be a no-op.

**Verify:** Visual smoke on 4–5 chapter Discover scenes + the Articles browser. Layout should look identical to the pre-2026-06-11 version. If any control looks off-position, a token mapping likely missed an inline arithmetic site.

### T3 — NavigationSmokeUITests (`9650c99`)

**⚠️ ACTION REQUIRED:** The `.swift` file lives at `desktopAhaanUITests/NavigationSmokeUITests.swift` but is **NOT in `project.pbxproj`**. The pbxproj does not use `PBXFileSystemSynchronizedRootGroup`; every existing UITest is wired explicitly.

**Fix:** In Xcode → File → Add Files to "desktopAhaan"… → select `NavigationSmokeUITests.swift` → uncheck the `desktopAhaan` app target, check ONLY `desktopAhaanUITests` → Add. Then commit the pbxproj diff.

**Or:** `python3 scripts/generate_compat_pbxproj.py` should pick it up automatically (the generator walks `desktopAhaanUITests/` and emits explicit PBXFileReference rows). Run it, build, commit the pbxproj.

After the file is in the target, the test selectors I picked may need adjustment — they were patterned on `HomeExperimentsUITests.swift` + `GoldenPathUITests.swift` but never compile-checked. If selectors don't match the actual UI tree on Big Sur, fix in place.

### H2 — `.accessibilityHint(...)` sweep (`6a1386b`)

~169 hints added across ~89 files. Pure additive (no semantic changes). Lint passes 706/706.

**iMac risk:** None expected. VoiceOver hint announcement only matters when VoiceOver is on; visual surface is unchanged.

**Verify:** Optional — turn on VoiceOver (⌘F5), tab through any one detail view (e.g., Concept Detail), confirm hints announce. Skip if no VoiceOver user.

### Identifier sweep — `.accessibilityIdentifier(...)` (`1a26b0e` → `04ed86a`)

259 new identifiers across 82 files (total 270). Stable XCUITest selectors.

**iMac risk:** Pure additive — `.accessibilityIdentifier` is macOS 10.10+ and has no rendering effect.

**Verify:** No visual verification needed. After `NavigationSmokeUITests` is in the pbxproj, the XCUITest run will exercise the identifier-based selectors.

### Tooltip / menu help (`5f4046c`)

28 `.help(...)` tooltips on every menu command in `desktopAhaanApp.swift`.

**iMac risk:** None. `.help(_:)` is macOS 10.15+.

**Verify:** Hover over any menu item (e.g., Help → Insights) — a tooltip should appear after ~1s. If no tooltip, the modifier was likely dropped during a rebase.

### Big-Sur latent bug fix — QuestionDetailView `@MainActor`

`7628822` added `@MainActor` to `struct QuestionDetailView: View {}`. The view was calling `SettingsManager.shared.autoAdvanceOnCorrect` synchronously from a `@MainActor`-isolated singleton without the annotation — exactly the Swift 5.5 / Big Sur compile-failure class the `check_view_mainactor.py` lint catches.

**iMac risk:** If the fix is incomplete, Big Sur Xcode 13.2.1 build fails at QuestionDetailView. The expanded `check_view_mainactor.py` covers 19 singletons now (was 1); a future regression in any of them surfaces immediately.

**Verify:** `Product → Build (⌘B)` on the Big-Sur iMac. Should compile clean. If it errors on QuestionDetailView, the `@MainActor` annotation didn't propagate correctly — look for any extension of the view that needs explicit `@MainActor` too.

### Code quality — dead iOS code removal (`e715293`)

176 LOC of `#if os(iOS)` blocks deleted from `SpeechRecognitionManager.swift`. The remaining `deactivateAudioSession()` is an empty no-op stub kept to preserve the macOS call site.

**iMac risk:** Speech translator (Sanskrit voice playback) MUST still work. If the iMac speaks Sanskrit slokas via `SpeechReader`, the path goes through `TextToSpeechManager` (separate from `SpeechRecognitionManager` — the latter is the dictation input path). The deletion doesn't touch playback.

**Verify:** Open the Translator → input some Devanagari → tap "Speak Result". If audio plays, the path is intact.

### Code quality — Notification.Name consolidation (`dc28d4f` part 1)

11 `Notification.Name` decls moved from `desktopAhaanApp.swift` into `Extensions.swift`. Same names, same string values — purely a relocation.

**iMac risk:** None. All callers use unqualified `.openImageCommand` syntax which resolves via Swift's module-wide visibility.

**Verify:** Cmd-O (Open Image) opens the OCR panel; Cmd-T (Translate) submits; Cmd-K (Speak Result) speaks. If any keyboard shortcut fails, a name reference dropped.

### Lint additions (38 → 40)

- `check_designtokens_spacing.py` + `check_designtokens_radius.py` (2026-06-12, J8)
- `check_a11y_identifier_uniqueness.py` (2026-06-13)
- `check_color_rgb_centralized.py` (2026-06-13)
- `check_macos12_apis.py` / `check_swift55_syntax.py` / `check_sf_symbols_compat.py` got embedded `--selftest` (2026-06-13)

**iMac risk:** Lints are platform-independent Python scripts. Should pass identically on the iMac.

**Verify:** `python3 scripts/test_lints.py` ends with `test_lints: PASS`. Each `python3 scripts/check_*.py` exits 0. If any lint fails, it's a real violation that the dev-Mac scan missed.

### Test additions — 3 new ratchets in `ProductionReadinessRatchetTests.swift` (`d7dc8e8`)

`testHardwareTierBudgetsAreReasonable`, `testDataStoreEveryWriteUsesAtomicOption`, `testSFSymbolCompatTableMeetsCoverageFloor` — source-level ratchets using `#filePath` to find the project root.

**iMac risk:** Path resolution from `#filePath` should work identically; both Mac and iMac use the same repo layout (modulo the wrapper folder, which `#filePath` correctly resolves past).

**Verify:** `⌘U` (Test). All 3 new tests should pass. If any fail on the iMac but passed on dev Mac, the cause is most likely path-resolution edge case → check the test's `repoRootURL` helper.

### Doc refreshes

`8cea107` (J8 ledger + ISSUE_CATEGORIES flips), `3c7db60` (PRODUCTION_READINESS refresh), `6ef7c04` (CLAUDE.md status header), `d100e6a` (post-audit corrections), `4a853ed` (lint comment update).

**iMac risk:** None — pure markdown.

**Verify:** Skip. Read at leisure.

---

## What the iMac should still flag (worth watching for)

1. **`ViewBuilder` >10 children** — already lint-checked but Swift 5.5's error message is cryptic ("Extra argument in call"). If Build (⌘B) errors with that, look for a `var body` that grew during the session.
2. **`@MainActor` method-by-reference** — `check_mainactor_closure_refs.py` covers this, but if it slipped, the error message is "Converting non-sendable function value to '@Sendable () -> Void' may introduce data races".
3. **macOS 12+ API leak** — `check_macos12_apis.py` is comprehensive now (with selftest covering 44 rules). But a new rule may be needed if Big-Sur surfaces a previously-unseen API in `'is only available in macOS 12.0 or newer'`.
4. **The 41 commits include `dc28d4f` which has an LH004b allowlist line-number bump** for Extensions.swift:498. If the Big-Sur build flags Extensions.swift:N for a Timer.scheduledTimer issue with N ≠ 498, the lint allowlist needs the new line number.

---

## If the iMac build fails

Walk these in order:

1. `bash scripts/imac-pull.sh` — wipes DerivedData first. Often a stale `.dia` file fixes itself.
2. `python3 scripts/generate_compat_pbxproj.py` — picks up any new files (e.g., the still-pending `NavigationSmokeUITests.swift` add).
3. `python3 scripts/test_lints.py` — every selftest should PASS. If any FAIL, the lint logic itself is broken (rare).
4. Each `python3 scripts/check_*.py` (no flags) — should all exit 0. If one flags a real violation, fix the violation, don't allowlist.
5. Open Xcode → Product → Build (⌘B). Read the FIRST error in the navigator — the cascade often points to one root cause.
6. If error is in QuestionDetailView, see "Big-Sur latent bug fix" above.
7. If error is in a Discover scene around `Task.sleep(nanoseconds: DiscoverTiming.settleDelayNs)`, the F1 commit's helper might not have landed cleanly — check `DiscoverMode.swift` for the `enum DiscoverTiming` declaration.

If genuinely stuck, paste the error into a fresh Claude Code session on the iMac. The 41 commits' diffs + this doc give enough context to debug.

---

## Hard "don't touch" list (CLAUDE.md invariants)

- `MACOSX_DEPLOYMENT_TARGET = 11.5` (pbxproj). Do NOT lower to 11.0 even though `ci-build-test.sh` pins 11.0 for the gate run.
- `Package.swift` — none expected; if Xcode auto-creates one, delete.
- Signing — stays ad-hoc (`CODE_SIGN_IDENTITY = -`). Don't propose Apple Developer team.
- Article renderer — `NativeArticleRepresentable.swift` and `ArticleStructuredRenderer.swift` are LOCKED. If a fix proposes touching them, STOP and ask.
- SRS schema — `QuestionReview`, `SM2Scheduler` are LOCKED.
- Files ≤600 LOC except the 2 grandfathered (`QuestionDetailView`, `DataStore`).

---

## Session ledger reference

For each commit's full message + diff: `git log --oneline 3700f6a^..HEAD`. There are 41 of them. Highlights by SHA — the ones most likely to need iMac eyes:

| SHA (prefix) | Summary | iMac eyes? |
|---|---|---|
| `9650c99` | NavigationSmokeUITests source written | ⚠️ pbxproj add required |
| `7628822` | QuestionDetailView `@MainActor` + 3 deploy-target lint selftests + view_mainactor expanded | ✅ verify build |
| `e715293` | SpeechRecognitionManager iOS shim delete (-176 LOC) | ✅ verify speech still works |
| `dc28d4f` | Notification.Name consolidation + lifetime_hazards allowlist line bump | ✅ verify keyboard shortcuts |
| `d7dc8e8` | 3 new source-level ratchet tests | ✅ verify tests pass |
| Everything else | Either pure-additive a11y, J8 token substitutions, doc updates, or `fileprivate→private` style | Visual smoke at most |

---

When everything above is green on the iMac, the session is **authoritatively done**. Update `CLAUDE.md`'s "Current status" date line to today's date once verified, and commit-and-push that one-line bump as the close-out.
