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
