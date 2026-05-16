# Post-Merge Audit — desktopAhaan

Snapshot taken **after** the 12 Big Sur / 5K iMac commits merged to `main`
(`1302dbc`). Captured before iMac evaluation so you have a list of issues to
either watch for during testing, or to pick up next.

**Target machine**: iMac (Retina 5K, 27-inch, Late 2014) · macOS Big Sur 11.7.11 · AMD Radeon R9 M290X 2 GB · ~2560×1440 logical points @2x.

**Legend**
- 🔴 **HIGH** — Likely visible to the kid on first run, or compile/render bug. Fix before next ship.
- 🟡 **MED** — Visible but cosmetic; can wait for a polish pass.
- 🟢 **LOW** — Architectural / nice-to-have; doesn't block anything.

---

## A. SF Symbols residue (will render as missing glyph on Big Sur)

Two call sites were missed in the earlier sweep through `SFSymbolCompat.name(_:)`. `hand.tap` and `hand.tap.fill` were added in SF Symbols 3 (macOS 12) and are already mapped in `SFSymbolCompat`, but these two sites bypass the helper.

- 🔴 **`desktopAhaan/Subjects/Tutor/Discover/Scenes/Scene4_ColorTheChlorophyll.swift:122`** — `Label("Pick a colour from the spectrum above.", systemImage: "hand.tap.fill")` → wrap: `systemImage: SFSymbolCompat.name("hand.tap.fill")`.
- 🔴 **`desktopAhaan/Subjects/Tutor/Discover/Components/FlipCard.swift:69`** — `Label("Tap to flip", systemImage: "hand.tap")` → wrap: `systemImage: SFSymbolCompat.name("hand.tap")`.

## B. Dead / leftover files in repo

- 🟡 **`desktopAhaan/Subjects/Tutor/TutorNavigation 2.swift`** — Duplicate of `TutorNavigation.swift` (likely an Xcode "merge sibling" leftover). Verify the content is identical to the canonical file, then delete the `" 2"` version.
- 🟡 **`desktopAhaan.xcodeproj/project.pbxproj.backup_xcode26`** — Backup snapshot of the project file from the original backport. Safe to delete once you've verified the project still opens cleanly on the iMac.

## C. Layout & sizing on 5K canvas

What's already done: detail-view content panels capped at `DesignTokens.contentMaxWidth` (1100pt) and `contentMaxWidthWide` (1280pt); Discover bottom cards swept to `contentMaxWidth` across all 51 scene files; window min raised to 1280×800 with ideal 1500×950; AskFollowUpView sheet clamped 420–720 × 380–800.

What's still loose:

- 🟡 **`desktopAhaan/Subjects/Tutor/TopicDetailView.swift:10`** — `List { … }` has no `.frame(maxWidth:)` wrapper. On the 5K iMac a single concept row stretches the full ~2300pt with an icon on the left and nothing on the right. Wrap the List body in `.frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)`, or wrap the parent VStack in a centered `HStack { Spacer(); content.frame(maxWidth: …); Spacer() }`.
- 🟡 **`desktopAhaan/ContentView.swift:23-28`** — `NavigationView` + `DoubleColumnNavigationViewStyle()` doesn't pin a sidebar width. On the 5K canvas the sidebar can drift wide (~500pt+). Setting `.frame(minWidth: 220, idealWidth: 260, maxWidth: 320)` on the sidebar's root would lock it to a Finder-style proportion.
- 🟢 Discover-scene-specific medium widths (e.g. `frame(maxWidth: 500/560)` for ion animation areas, beaker rows, moon grids) — generally fine because they wrap visual elements that genuinely shouldn't sprawl. Spot-check on the iMac and flag the ones that look stranded.

## D. Dark mode still

Already swept: `Color.white` and `Color.white.opacity(0.5)` backgrounds in Ch.3 scenes. Remaining concerns:

- 🟡 **`desktopAhaan/Subjects/Tutor/Discover/Components/SoftShadowCard.swift:19`** — `.strokeBorder(Color.black.opacity(0.05), …)` on the card outline. In light mode this is a faint hairline; in dark mode 5 % black against the dark window background becomes invisible, so the card "floats" with no edge. Use an adaptive: `.strokeBorder(Color.primary.opacity(0.08))`.
- 🟡 **`desktopAhaan/Subjects/Tutor/ChapterDetailView.swift:81-82`** — Discover banner gradient uses hardcoded green→blue with `.foregroundColor(.white)` text on top (lines 64, 67). Readable in light Big Sur; verify on the iMac in dark mode that the gradient is still bright enough for white text to pass WCAG.
- 🟡 **`desktopAhaan/Subjects/Tutor/Discover/Chapter6/Scenes/Scene2_TearingVsBurningPaper.swift:102, 108`** — `.foregroundColor(.gray)` on the "Paper before burning / Paper after burning" subtitles. `.gray` is roughly mid-tone in both light and dark; the contrast is technically borderline. Swap to `.secondary` to inherit the system's adaptive label color.
- 🟢 **`desktopAhaan/Subjects/Tutor/Discover/DiscoverBackground.swift:28-36`** — Hardcoded pastel sky→grass gradient does not adapt to dark mode. Acceptable if Discover Mode is intentionally always-light (it reads like a children's book that way), but flag if you'd rather it dim on the iMac at night.

## E. Typography

- 🟡 **`desktopAhaan/Subjects/Tutor/ConceptDetailView.swift:301`** and **`TopicDetailView.swift:76`** — `.font(.caption2)` / `.caption2.bold()` on "Needs review" badges. 11 pt on a 27" screen at typical viewing distance is small for a warning. Consider `.caption` (12 pt).
- 🟡 **`desktopAhaan/Subjects/Articles/ArticleBrowserView.swift:75`** — `.lineLimit(1)` on `coordinator.pageTitle`. Web page titles regularly exceed 60 chars and will cut mid-word. Allow 2 lines or `.truncationMode(.middle)`.
- 🟡 **`desktopAhaan/Subjects/Tutor/SearchView.swift:116`** — `.lineLimit(1)` on `"Answer: \(q.answer)"` — long answers (e.g. multi-clause shortAnswer) truncate and lose information. Allow 2 lines.
- 🟢 **`desktopAhaan/Subjects/Articles/ArticleEntryButton.swift:64`** — `.lineLimit(1)` on topic title. Most topic titles are short; verify worst-case on the iMac before changing.
- 🟢 **`desktopAhaan/Subjects/Tutor/QuestionDetailView.swift:179`** — Question prompt uses `.font(.title3)` without `.lineSpacing`. Multi-line prompts are denser than the answer body below. Add `.lineSpacing(4)` for parity with the surrounding body text.

## F. Empty states & navigation

- 🟡 **`desktopAhaan/Subjects/Tutor/SearchView.swift:129-131`** — When a search query returns zero matches, the view shows only `Text("No matches.").foregroundColor(.secondary)` inside a List. A 12-year-old would benefit from a proper empty state with icon + "No results for '\(query)'" + a hint like "Try a single word, or check spelling." Mirror the empty-state pattern already used at lines 46–57 of the same file.
- 🟢 **`desktopAhaan/Subjects/Tutor/TopicDetailView.swift`** — When a topic has 0 concepts AND 0 questions, only the `ArticleEntryButton` is shown. Not broken, but a "No concepts or questions here yet — try the article above" hint would tighten the UX.
- 🟢 **`desktopAhaan/Subjects/Tutor/Discover/Chapter5/DiscoverChapter5View.swift`, `Chapter6`, `Chapter7`, `Chapter19`** — Verify on the iMac that arrow-key navigation works in chapters 5/6/7/19. Chapter 1–4 have `.onArrowKeys(...)` explicitly; the others were not confirmed during the audit grep. Two minutes of arrow-key testing per chapter on the iMac will resolve this.

## G. Accessibility

- 🟢 **`desktopAhaan/ContentView.swift:12`** — `Image(systemName: "exclamationmark.triangle.fill")` in the error banner has no `.accessibilityLabel` or `.accessibilityHidden(true)`. VoiceOver reads "warning triangle" twice if the adjacent text also mentions error. Add `.accessibilityHidden(true)` since the text says it.
- 🟢 **`desktopAhaan/ContentView.swift:111`** — `Image(systemName: "books.vertical")` in the no-selection empty state has no label. Add `.accessibilityLabel("No subject selected")` or hide it if the heading text already conveys this.
- 🟢 General: reduce-motion handling is consistent across Discover scenes (all query `@Environment(\.accessibilityReduceMotion)`). No regressions here.

## H. Content quality

- 🟢 **`desktopAhaan/Subjects/Packs/sanskrit_class7.json`** — Spot-checked 10 random MCQs; the auto-generated questions read cleanly and distractors are appropriately drawn from the same topic. No errors found. Devanagari script renders via the system SF Pro font — no explicit font tag is set, which is fine on Big Sur 11.7.11 (the system covers Devanagari).
- 🟢 **`desktopAhaan/Subjects/Packs/science_class7.json`** — Sampled questions are well-structured with `solutionSteps` and `commonMistakes`. No `needsHumanReview: true` flags in the spot-check; doing a full pack scan of that flag would be a 30-second job before shipping.
- 🟡 **`desktopAhaan/Resources/Articles/Chapter5/ch05_t02_overview.html:38, 46`** and **`Chapter6/ch06_t02_overview.html:25, 34`** — Chemistry equations use inline `style="text-align:center;font-size:1.1em;"`. Migrating these to a CSS class (`.equation { ... }` in the chapter stylesheet) keeps dark mode and font-size scaling consistent. Cosmetic.

## I. First-launch & settings

- 🟢 **`desktopAhaan/desktopAhaanApp.swift` + `App/AppState.swift`** — Fresh install drops the user on the Sanskrit translator with no onboarding. A 12-year-old with parent setup is fine; a child opening the app alone might not know to choose a subject from the sidebar. Optional addition: a one-time welcome overlay on first launch keyed by an `@AppStorage("hasSeenWelcome")` flag.
- 🟢 **`desktopAhaan/Views/Settings/SettingsScreen.swift`** — Settings are grouped well (Status, Parent Lock, Subject Packs, Read Aloud). The audit didn't finish scanning to the end of the file; before shipping verify any "Clear history" / "Reset app" button is behind a confirmation dialog.

## J. Performance on the 2014 GPU

What's already done: `ParticleEmitter` reduced from 80 particles @ 30 fps to 40 @ 20 fps on Big Sur via `HardwareTier`. All Discover Timer scenes routed through `HardwareTier.interval(ideal:)`. Every Timer-driven scene now pauses when the SwiftUI scene phase leaves `.active` via `pauseTimerWhenBackgrounded`.

What's still notable:

- 🟢 **`desktopAhaan/Subjects/Tutor/Discover/Components/SoftShadowCard.swift:21`** — `.shadow(color: .black.opacity(0.08), radius: 14, x: 0, y: 6)` is applied to every card. Shadows on a 2014 GPU are mildly expensive when many cards animate (e.g., the Boss Quiz answer reveal). Probably fine; flag only if you see frame drops on iMac.
- 🟢 No nested `GeometryReader` chains detected. No unbounded ForEach loops inside timers. No `.blur()` on animated views.

## K. Architecture / nice-to-haves

- 🟢 **Duplicate `startAnimation()` / `stopAnimation()` pattern** appears in ~11 Discover scenes verbatim. Candidate for a small `TimedScene` view modifier or protocol that owns the `tick: TimeInterval` and `animationTimer: Timer?` state. Worth doing if a 12th Timer scene gets added; not worth refactoring just to refactor.
- 🟢 **`desktopAhaan/Subjects/Tutor/QuestionDetailView.swift`** — 700+ lines. Splitting the MCQ button group, match-the-following section, and variations card into their own files would help future you when adding question types.
- 🟢 **`@AppStorage("discover_scene_chXX")` keys** are scattered across dispatcher files. A central enum with case-per-chapter would prevent silent progress loss from a typo. Low risk today (all keys are right), but useful before adding chapter 8+.

## L. Verified clean (no action needed)

- **macOS 12+ SwiftUI API leaks**: None remaining. All `Canvas` / `TimelineView` / modern modifier uses are either replaced or guarded.
- **macOS 12+ Foundation/Vision/Speech leaks**: None. `URLSession.data(for:)` is `@available`-guarded in `FreeOnlineTranslationProvider`. OCR's `automaticallyDetectsLanguage` uses KVC fallback. `ImageRenderer` is replaced by the `renderViewToImage` helper.
- **Timer leaks / concurrency**: Every `animationTimer` has matching `.invalidate()`. No force-unwraps in critical paths.
- **HTML article CSS**: All eight chapter stylesheets (Ch1, 2, 3, 4, 5, 6, 7, 19) include a `@media (prefers-color-scheme: dark)` block. No modern CSS features (`:has()`, `aspect-ratio`, container queries) used.
- **TutorNavigation push/pop/replaceTop mechanics**: Reviewed end-to-end; back button always shown when `canGoBack`. Arrow-key navigation wired in Ch1–4 (verify 5/6/7/19 visually).
- **`@AppStorage`, `DataStore`, `SettingsManager`**: Keychain access uses `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`. JSON decoding has error logging. No plaintext secrets.

---

## Recommended order if you resume after iMac testing

1. **Fix the 2 SF Symbol residue sites** (Section A) — 5-minute change, removes possible missing-glyph squares.
2. **Delete the 2 leftover repo files** (Section B) — 1-minute change, cleans up the working tree.
3. **Cap TopicDetailView List width** (Section C) — 1-line addition.
4. **SoftShadowCard adaptive border + Scene2_TearingVsBurningPaper gray→secondary** (Section D) — 3-line changes.
5. **SearchView empty results card** (Section F) — 10-line addition mirroring the existing empty state.
6. Then come back to the polish items based on what the iMac actually showed.
