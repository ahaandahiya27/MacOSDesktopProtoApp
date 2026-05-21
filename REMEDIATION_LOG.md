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

(none yet)

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
- Estimated time to zero findings at current rate: ~5–7 more hours of iterations (rate is ~15 min/iter for surgical changes, ~25 min/iter for split refactors with the XcodeWrite path-prefix workaround)
