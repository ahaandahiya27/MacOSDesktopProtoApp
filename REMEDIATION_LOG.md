# Remediation Log — desktopAhaan

## Session start: 2026-05-22 00:35 +05:30

## Audit reference: ISSUES_AUDIT.md @ 18cac57 (now superseded by 8cfb6e7)

## Iterations

[2026-05-22 00:35] iter 1 · chore · `.gitignore`/pbxproj · untrack `.DS_Store` + xcuserstate · `995de21` · pushed:y
[2026-05-22 00:40] iter 2 · refactor · `DiscoverChapter1View.swift` · 1498→116 split into sister `+InlineScenes.swift` (12 private structs lifted, two nested types re-privatised to match Kind/Bucket access level) · `ef1e867` · pushed:y (retry on streak-test flake)
[2026-05-22 01:08] iter 3 · refactor · `ContentView.swift` · 992→409 split into `Views/Practice/DailyPracticeViewSheet.swift` (473) + `Views/Components/AllChaptersCompleteOverlay.swift` (124) · `5457f2a` · pushed:y

## Lessons captured this run

- **XcodeWrite path quirk**: when the `filePath` is `desktopAhaan/<file>` (one level deep), the MCP creates only the `PBXFileReference` entry and the file lands at the *workspace root* (not inside the target's group), so it doesn't compile. Workaround: place new sister files in a SUBDIRECTORY (`desktopAhaan/Views/Foo/Bar.swift`, `desktopAhaan/Subjects/X/Y.swift`) — those get both `PBXFileReference` AND `PBXBuildFile` and compile cleanly. Iter 3 cost one full retry to discover this.
- **Pre-push hook test flake**: `testStreak_*` in `ChapterContentTests.swift` is Date-sensitive and occasionally fails under the CI script's process order. Always retry the push once before assuming a real failure. Catalogued in `CRASH_DEEP_RESEARCH.md` row 11D.

## Open items (deferred, with reason)

[2026-05-23] **QuestionDetailView.swift split** — Attempted and reverted. The 929 LOC main view was carved into `+Sections.swift` (Sections rendering, 187 LOC) and `+MatchPairs.swift` (Match-the-following subsystem, 222 LOC) with the same playbook the ChapterDetailView split (commit 8972dfe) used cleanly. The split compiled in principle but produced two breakages: (1) ~12 `private` @State / private-func references became cross-file accesses requiring blanket internal relaxation; the encapsulation hit was tolerable, but (2) Swift 5.5's type-checker timed out on the main `body` ("the compiler is unable to type-check this expression in reasonable time") because the helper methods living in sister-file extensions made compound-expression type-inference quadratic. Reverted to single-file form which type-checks cleanly. A future split would need to first flatten the body into named sub-view computed properties INSIDE the same file (so the type-checker only has to infer one short expression at a time), then lift the named sub-views to a sister file. Out of scope for this session — kept in the file-size allowlist with this reason.

[2026-05-22] **Article teardown 100× stress test** — Deferred as "retired by f4ec573" rather than written. The CRASH_LEDGER open item asks for a unit test that asserts `ArticleWindowManager.windows.count ≤ 8` across 100 create+tear-down cycles, but `ArticleWindowManager` no longer exists in the working tree — `f4ec573` replaced the NSWindow-managed article surface with a SwiftUI `.sheet(item:)` on `ArticleEntryButton`. Writing a substitute test that mounts ArticleBrowserView 100× via NSHostingView in a unit-test bundle was considered and rejected: SwiftUI's lifecycle is asynchronous and lazy, the runloop pumping needed for a meaningful teardown stress doesn't run reliably inside the test process, and the actual regression class (the dismantle-order race between `NativeArticleRepresentable` and SwiftUI's commit pump) is already locked at the UI level by `Crash_BeyondThenDiscover` walking the open→close→re-open path that triggered the original crash. CRASH_LEDGER updated to mark the open item retired.

## Stop-and-ask events

(none yet)

## Iterations 5-8 (top-10 audit items)

[2026-05-22 01:18] iter 5 · perf · `ArticleEntryButton.swift` · ArticleWindowManager.windows capped at 8 with FIFO eviction + os.Logger telemetry · `9fd1e53` · pushed:y (audit #5)
[2026-05-22 01:21] iter 6 · chore(lint) · `scripts/check_macos12_apis.py` · 9 more macOS 13+/14+ API patterns (.scrollTargetLayout, .contentTransition, ImageRenderer, two-arg .onChange, .fontWidth/Design) · `0f2eecd` · pushed:y (audit #2)
[2026-05-22 01:24] iter 7 · feat(crashreport) · `desktopAhaanApp.swift` · log flushSavesBeforeQuit timeout to crashlog with pending-write count · `47452c9` · pushed:y (audit #6)
[2026-05-22 01:26] iter 8 · a11y · `Extensions/View+RespectReduceMotion.swift` · `.respectReduceMotion(animation:)` + `withAnimationRespectingReduceMotion(_:body:)` helpers (migration of 120 sites is opportunistic) · `36ad98b` · pushed:y (audit #7)

## 2-hour checkpoint — 2026-05-22 01:30 +05:30

- Iterations completed: 8
- Commits pushed: 8 (995de21, ef1e867, 5457f2a, 11fd545, 9fd1e53, 0f2eecd, 47452c9, 36ad98b)
- Findings closed (Top-10 audit): #2, #5, #6, #7, #10
- Findings remaining (Top-10 audit): #1 partial (Ch1+ContentView splits done; ArticleIndex, DiscoverChapter2View, QuestionDetailView, ChapterDetailView, DataStore still pending), #3 (coverage matrix), #4 (snapshot tests), #8 (Color.compat migration), #9 (accessibilityHint sweep)
- Build state: clean (all 311 tests pass)

## 12h-spec iterations (parallel track)

[2026-05-22 01:40] iter 1 · docs · 5 log files + coverage scanner seeded · `1d43990` · pushed:y
[2026-05-22 01:45] iter 2-4 · fix(crash) · C1+C2+C3+C4 deep scan returned zero hits; lint extended with 3 forward-prevention rules (unowned, var delegate, @unchecked Sendable); DEEP_SCAN_RESULTS.md snapshot · `882dcf2` · pushed:y

## 12h-spec 2-hour checkpoint — 2026-05-22 01:50 +05:30

- Iterations completed: 4 (12h-spec) + 8 (audit Top-10 from earlier in session) = 12 total today
- Commits pushed: 10 since session start (995de21, ef1e867, 5457f2a, 11fd545, 9fd1e53, 0f2eecd, 47452c9, 36ad98b, a201939, 1d43990, 882dcf2)
- Crashes captured this checkpoint: 0 new (all 4 classes already had mitigations from earlier session work)
- C1/C2/C3/C4 status: 🟡 / 🟡 / ✅ / ✅ (C1+C2 awaiting locking XCUITest walker — out of scope for headless tool use)
- Walker pass rate: N/A (XCUITest walker not yet built; requires Xcode-scheme modifications)
- Sanitizer hits: N/A (ASan/TSan scheme variants not yet built)
- Scale plan progress: 0 / 10 steps (SCALE_PLAN.md drafted; refactor steps not yet executed)
- Ch.1 enrichment: ledger created (CH1_LEVEL_LOG.md); 8 open next-level items queued (CH1-L1..L8)
- Build: clean, 311 tests green
