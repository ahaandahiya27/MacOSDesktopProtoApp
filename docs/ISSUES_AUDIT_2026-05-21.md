# Comprehensive Issues / Bugs / Lags / Crashes / Main-Thread Risks Audit

Generated **2026-05-21** after the multi-day expansion + perf sweep.
Cross-check this against the live behaviour on the iMac before
declaring anything closed.

---

## TL;DR

| Category | Count |
|---|---|
| Active crashes | **0** (sandbox crash fixed by ad-hoc signing) |
| Active HANG events under 2026-05-21 code | **1** (1305 ms — instrumented but root cause unknown) |
| Pre-commit lint violations | **0** |
| Tests passing | **239 / 239** |
| Build clean | **yes** (Big Sur target, 5-8s per build) |
| Banned API leaks | **0** |
| Working-tree dirty (excl. xcuserstate) | **clean** |

---

## A. CRASHES — currently observed: 0

### A1. Historical sandbox crash on launch (RESOLVED)

- **Symptom**: `EXC_BREAKPOINT (code=1, subcode=…) at __libsecinit_appsandbox.cold.6` immediately after launch.
- **Root cause**: Apple Developer cert for `ahaandahiya27@gmail.com` revoked 4× in keychain (`CSSMERR_TP_CERT_REVOKED`). macOS sandbox refused to initialize against the revoked-cert-signed binary.
- **Fix**: Project switched to `CODE_SIGN_IDENTITY = "-"` (Sign to Run Locally) for both `desktopAhaan` + `desktopAhaanTests` targets. Commit `22ba658`.
- **Status**: ✅ resolved. App launches cleanly under ad-hoc signing. Permanent setting in pbxproj.

### A2. dyld can't find `desktopAhaan.debug.dylib` (RESOLVED)

- **Symptom**: `(no such file)` for the Debug dylib at launch, post-build.
- **Root cause**: Stale codesign on the dylib — signed against the revoked authority.
- **Fix**: Combined fix from A1 + re-signing the .app bundle ad-hoc + DerivedData clean.
- **Status**: ✅ resolved.

### A3. Xcode debugger "Could not attach to pid" (RESOLVED)

- **Symptom**: `attach by pid 'XXXX' failed -- attach failed (Not allowed to attach to process)`.
- **Root cause**: My one-shot ad-hoc resign stripped the `com.apple.security.get-task-allow` entitlement.
- **Fix**: A1's permanent switch to "Sign to Run Locally" makes Xcode auto-inject `get-task-allow` for Debug ad-hoc builds.
- **Status**: ✅ resolved.

### A4. Test cert invalid (`CSSMERR_TP_CERT_REVOKED`) — RESOLVED

- **Symptom**: `xcodebuild test` failed with "Signing certificate is invalid…"
- **Fix**: Pass `CODE_SIGN_IDENTITY="-" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO` when running tests manually (the pre-push CI script `scripts/ci-build-test.sh` already does this).
- **Status**: ✅ workflow documented.

---

## B. MAIN-THREAD HANGS — actively monitored

### B1. New 1305 ms HANG on 2026-05-21 at 07:41:06 — **ROOT CAUSE UNKNOWN**

- **Crashlog**: `~/Library/Containers/com.emoha.desktopAhaan/Data/Library/Application Support/desktopAhaan/crashlogs/crashlog-2026-05-21.txt`
- **Hang detector captured a post-recovery main-thread stack** (the upgrade I shipped in commit `4b07c4e`), but the stack only shows generic AppKit `[NSApplication run]` → `CFRunLoop` → dispatch machinery. **No app-code frames visible** because the hang had already resolved by the time my `DispatchQueue.main.async` block ran.
- **What we know**: hang fired ~1 second after the post-launch RECOVERY marker, so it's somewhere in the launch-time view tree rendering or initial @Published cascade.
- **What we don't know**: which specific operation. Could be:
  - First-render of a 20-scene chapter dispatcher's `sceneTitles` array
  - SubjectRegistry pack decode finishing post-init (29ms per logs)
  - SwiftUI re-rendering the sidebar with new content
  - WKWebView article preload
- **Recommended next step**: instrument with `os_signpost` markers at suspected boundaries (registry-ready, first-render of selected sidebar) and inspect via Instruments → Time Profiler when the hang next fires. Or capture a sample with `sample -mayDie -file` during a hang.
- **Status**: 🟡 instrumented, root cause unknown, 1 occurrence.

### B2. Historical HANG events (pre-fix code, prior to today) — RESOLVED via mitigations

- **Symptom**: 6 entries 1011-1552 ms across 2026-05-18 through 2026-05-20.
- **Mitigations shipped**:
  - `DataStore.loadAll()` moved off the main actor (commit `f6a0c90`)
  - `saveCoalesced()` debounces 5 high-frequency mutators (commits `51cee84`, `e6b74c8`)
  - `SubjectRegistry.location(forQuestionId:)` index replaces O(2200) per-render scan (commit `1f531ad`)
  - SearchView debounced at 200ms (pre-existing)
  - SanskritDictionary pre-warm bumped to `.userInitiated` (commit `a4e99ac`)
  - AnyView lookup-table dispatcher eliminated 210s Debug compile time (commit `7843d56`)
- **Status**: ✅ mitigations in place; one new hang fired today (B1 above) at ~similar duration.

### B3. Hang detector limitation — **architectural**

- **Issue**: My `DispatchQueue.main.async` post-recovery stack capture (commit `4b07c4e`) only shows the post-resolve stack, not the during-hang stack. As evidenced by today's hang showing only AppKit machinery.
- **Better approach** (not yet implemented): use Mach thread state APIs to capture the main thread's stack from the background hang-check queue while the main thread is still blocked. `thread_get_state(thread_main, ARM_THREAD_STATE64, ...)`. Complex but possible.
- **Status**: 🟡 known limitation, deferred. Alternative: sample via Instruments when a hang fires.

---

## C. KNOWN LATENT RISKS (no observed failure, but plausible)

### C1. Dynamic Type xLarge clipping — UNVERIFIED on new scenes

- **Issue**: 209 new inline scenes use `.font(.callout)` / `.title3` / `.system(size: ...)` without testing at Accessibility xLarge / xxLarge sizes. Some scenes have fixed-width frames (`Slider(value:).frame(maxWidth: 340)`) that could clip large text.
- **Impact**: cosmetic; clipping reduces legibility, doesn't crash.
- **Status**: 🟡 H4 row in `docs/ISSUE_CATEGORIES.md` — requires iMac visual verification.

### C2. iMac (Big Sur 11.7.11 / Xcode 13.2.1) verification gap

- **Issue**: None of today's 40+ commits has been run on the deploy iMac. Build only proven on dev Mac modern Xcode.
- **Mitigations**:
  - AnyView lookup-table refactor specifically addresses iMac compile-time risk
  - Pre-push CI builds with `MACOSX_DEPLOYMENT_TARGET=11.0`
  - All lints enforce SF Symbols 2, no macOS 12+ APIs, no Color.brown
- **Risk**: Big Sur SwiftUI is more conservative; some animations or layout quirks may surface only there.
- **Status**: 🟡 needs iMac pull + smoke test of 1 scene per chapter (~30 min of clicking).

### C3. Force-unwraps in tests (`Calendar.current.date(byAdding:...)!`)

- **Location**: `desktopAhaanTests/ChapterContentTests.swift` (multiple sites in streak tests).
- **Why allowed**: Tests are exempt from the `try!`/`as!` pre-commit lint. `Calendar.current.date(byAdding:)` returning nil for a valid `.day` component is impossible in practice.
- **Status**: ✅ intentional, lint-exempt.

### C4. Inline scene structs' `@State` doesn't survive view recreation

- **Issue**: All 209 new scenes are `private struct`s declared inside chapter dispatcher files. SwiftUI recreates these on chapter re-entry, so any `@State` (e.g., a slider value, a tap-revealed flag) resets each visit. By design — these are stateless demos, not stateful editors.
- **Risk**: low — if a future scene needs persistent state, it'd need a `@StateObject` or AppStorage. The pattern itself is fine.
- **Status**: ✅ by design.

### C5. `AnyView` type-erasure in dispatchers

- **Issue**: Each chapter dispatcher uses `[() -> AnyView]` lookup table (19 chapters × 20 entries = 380 AnyView wrappers). Tiny per-render overhead vs. typed views.
- **Why accepted**: AnyView only wraps the scene that's currently rendered (one per visible chapter). The savings from avoiding 21-case ViewBuilder type-checking are 30-100× bigger than the AnyView render cost.
- **Status**: ✅ deliberate tradeoff documented in commit `7843d56`.

### C6. WKWebView `prefers-color-scheme` — UNVERIFIED on Big Sur

- **Issue**: Dark-mode CSS shipped today (commit `54fd33f`) for all 19 chapter stylesheets. WKWebView is supposed to honour `prefers-color-scheme` natively on macOS 11+. Not yet verified on the iMac.
- **Status**: 🟡 logic is standard CSS — should work, but Big Sur WKWebView is older.

### C7. UserDefaults streak keys can drift if user travels timezones

- **Issue**: `creditReviewStreak` formats dates using `yyyy-MM-dd` in `en_US_POSIX` + `Calendar(identifier: .gregorian)`. If the user travels across the international date line, a "yesterday" could appear to be the same day or skip a day in local time.
- **Coverage**: Unit-test pinned in `testStreak_*` (4 tests). All use `Date(timeIntervalSince1970:)` + `Calendar.current.date(byAdding:.day,...)` which is timezone-sensitive.
- **Status**: 🟡 minor edge case; user is in India (fixed timezone) so unlikely to trip.

### C8. Scene-count drift if a chapter is added or chapters renumbered

- **Issue**: `DataStore.discoverSceneCounts` is now a static dictionary; ratchet tests pin the total at 380. If a future contributor adds Ch.20, they must update both the dict AND the test.
- **Mitigation**: ratchet test failure message explicitly tells dev to update both.
- **Status**: ✅ flagged in test message; documented in `docs/ISSUE_CATEGORIES.md`.

---

## D. KNOWN BUGS DEFERRED — too large for safe single-session fix

### D1. Boss Quiz 5→10 questions (B1 from pending list)

- **Why deferred**: 95 new MCQs across 19 chapters require focused content authoring with consistent quality + difficulty curve. A rushed sweep here would ship uneven content — the opposite of what was asked.
- **Surface area**: 19 Boss Quiz files in `desktopAhaan/Subjects/Tutor/Discover/Chapter*/Scenes/Scene9_BossQuiz_Ch*.swift` (+ one base file `desktopAhaan/Subjects/Tutor/Discover/Scenes/Scene9_BossQuiz.swift`). Hardcoded `count: 5`, `total: 5`, `max: 5` literals in 8 of the 19. Other 11 use `.count` properly.
- **Refactor needed first**: standardize on `quiz.count`/`questions.count` everywhere so bumping to 10 is just "add 5 items to the array."
- **Estimated effort**: ~2-3 hours of careful authoring with subject-matter familiarity.
- **Status**: ❌ deferred — needs dedicated session.

### D2. Pack JSON content for 209 new inline scenes (B6)

- **Why deferred**: Each new scene would need a matching `Concept` entry in `science_class7.json` plus 2-3 supporting questions to feed the SM-2 review queue. ~600+ new pack entries with proper IDs, related-concept links, difficulty grading.
- **What works without it**: All 380 scenes render correctly. SM-2 system works against existing 190 concepts / 732 questions. Daily Practice queue surfaces only the original content.
- **What's missing**: SM-2 can't surface review questions tied to the NEW pedagogical hooks (lichen partnerships, Venus flytrap reflex, etc.).
- **Status**: ❌ deferred — multi-day content authoring task.

### D3. Article HTML files for new scenes (B7)

- **Why deferred**: Each new scene could have a companion long-form HTML article in `Resources/Articles/Chapter*/`. ~209 new HTML files needed.
- **What works without it**: Scenes are self-contained; no "read more" link is offered to the kid.
- **Status**: ❌ deferred — substantial scope.

### D4. Snapshot/screenshot tests for 209 new scenes (E5)

- **Why deferred**: Would require setting up XCUIAutomation, baseline images, and a per-scene navigation script. No snapshot test infrastructure exists today.
- **What we have instead**: Build clean + lints + ratchet tests + manual code review.
- **Status**: ❌ deferred — infrastructure setup.

### D5. Direct-literal icon `.foregroundColor` sweep (E2)

- **Issue**: ~180 sites still use `.foregroundColor(.yellow|.orange|.teal)` on `Image(systemName:)` icons (not text). WCAG-allowed at 3:1 for icons; the lint specifically permits icon contexts.
- **Status**: ❌ deferred — cosmetic only.

---

## E. CODE-QUALITY ITEMS (not bugs)

### E1. File size: `DiscoverChapter1View.swift` at 1294 LOC

- Largest dispatcher (since it carried the pilot expansion). Manageable, but at the upper end of pleasant grep-ability.
- Status: ✅ acceptable.

### E2. Two `.monospaced()` slips during expansion — already caught + fixed

- Build caught both (Ch.5 + Ch.14). Each fixed in same commit via `.system(size:weight:design:)`. No regression remained.
- Status: ✅ closed.

### E3. `Color.brown` slip during Ch.1 expansion — already caught + fixed

- Routed via `Color.compatBrown`. All 6 uses corrected pre-merge.
- Status: ✅ closed.

### E4. `@AppStorage` keys all go through `AppStorageKeys` enum

- Verified: 0 stray `@AppStorage("…")` literal-key uses outside the registry.
- Status: ✅ clean.

### E5. Pre-push CI gate is the source of truth

- `scripts/ci-build-test.sh` runs Debug build + test suite + lints on every push. All 40+ today's pushes cleared the gate. The ViewBuilder lint "flagged something" warning is a deliberate non-blocking heuristic (the actual build is the canonical check).
- Status: ✅ working as intended.

---

## F. WHAT YOU SHOULD CHECK ON THE iMac

1. **Pull and rebuild**:
   ```
   cd /Users/ahaandahiya/Downloads/DesktopAhaan\ 4/desktopAhaan
   ./scripts/imac-pull.sh
   ```
2. **Launch in Xcode 13.2.1, ⌘R**. Should be clean now (no sandbox crash).
3. **Open Discover for any chapter** — verify the chapter card now reads "20 interactive scenes" (was "9").
4. **Scrub through 2-3 new scenes per chapter** — animations should work, no layout collapse, no blank SF Symbols.
5. **Open Daily Practice** — flag 1-2 questions tough, see if the queue + streak chip + new "Streak History" card all appear.
6. **Hit a Boss Quiz** — should still work at 5 questions (we didn't change it).
7. **Open an article in WKWebView, toggle System → Dark Mode** — body should now reflow dark colours (B8 fix).
8. **Press ⌘1/⌘2/⌘3/⌘4 in a review session** — quality buttons should fire.
9. **Press S in a review session** — skip the card.
10. **Test ⌘Q** — clean exit (the new flushSavesBeforeQuit drains any pending coalesced writes within 1s).

If any of those misbehave, copy the line from `~/Library/Containers/com.emoha.desktopAhaan/Data/Library/Application Support/desktopAhaan/crashlogs/crashlog-YYYY-MM-DD.txt` and send it.

---

## G. RAW NUMBERS

- **Files**: 132 Swift files in `desktopAhaan/`
- **Discover scenes**: 380 across 19 chapters (was 171)
- **Tests**: 239 (was 236 at audit start, +3 new ratchets shipped today)
- **Build time**: 5-8s per Debug build (was 210s for Ch.2 pre-AnyView refactor)
- **Today's commits**: 40+ on `origin/main`, every one cleared pre-push CI
- **Active crashes**: 0
- **Active HANGs**: 1 occurrence today, root cause unidentified

---

## H. NEXT-SESSION RECOMMENDED ORDER

1. **iMac smoke test (F above)** — 30 min, validates everything.
2. **B1: Boss Quiz 5→10** — focused content session, ~2-3 hours.
3. **B6: Pack JSON content alignment** — multi-day; biggest leverage for SM-2.
4. **B7: Article HTML for new scenes** — bulk content task.
5. **B3 hang root-cause hunt** — if a new hang fires with the current instrumentation, sample via Instruments.
