# Chapter 1 Bug-Free Super Prompt (paste verbatim)

Paste the block below at the **start** of any new Claude session that
will touch Chapter 1 of the science pack. It forces the rules I keep
forgetting and the verification steps I keep skipping. The aim is to
make Ahaan's iMac experience crash-free, regression-free, and Big-Sur–
safe end to end.

> Last updated 2026-05-21 after a three-hour debugging cycle that
> repeatedly reintroduced `.animation(_:value:)` and stacked
> `.sheet(isPresented:)` modifiers — both crashed Ch.1.

---

## THE PROMPT

```
You are about to make changes to Chapter 1 of the desktopAhaan
science pack. Before touching any code, internalise these rules.
If a change can't satisfy ALL of them, stop and ask me first.

═══════════════════════════════════════════════════════════════
HARD CONSTRAINTS — non-negotiable
═══════════════════════════════════════════════════════════════

1. DEPLOY TARGET IS BIG SUR 11.7.11 / Xcode 13.2.1 / Swift 5.5
   on a Late-2014 iMac with an AMD R9 M290X 2 GB GPU.
   Everything ships there. Anything macOS 12+ is forbidden
   even if it compiles cleanly on a newer dev Mac.

2. BANNED SwiftUI APIs (run `python3 scripts/check_macos12_apis.py`
   after every change — it must exit 0):
     • .animation(_:value:)      → use .animation(_:) only
     • .foregroundStyle(…)       → use .foregroundColor(…)
     • .symbolEffect(…)          → remove
     • .symbolRenderingMode(…)   → remove
     • .scrollPosition(…)        → use ScrollViewReader
     • .scrollDismissesKeyboard  → remove
     • .scrollContentBackground  → remove
     • .formStyle(…)             → don't use
     • .dynamicTypeSize(…)       → don't use
     • .refreshable(…)           → don't use
     • .toolbarRole(…)           → don't use
     • .searchable(…)            → build a manual search bar
     • .tint(…)                  → use .accentColor(…)
     • .task / .task(_:)         → use .onAppear { Task { … } }
     • @FocusState / .focused()  → don't use
     • @Observable / @Bindable   → use ObservableObject + @Published
     • NavigationStack /
       NavigationSplitView       → use NavigationView
     • Font.monospaced()         → .system(size:weight:design:
                                     .monospaced)
     • AsyncImage                → NSImage + URLSession
     • Color.brown               → Color.compatBrown
     • Color.mint/cyan/indigo/
       teal                      → Color.compatIndigo / a custom
                                     Color(red:green:blue:)
     • Chart { … } / import Charts → draw with Path

3. NO MULTIPLE `.sheet(isPresented:)` ON THE SAME VIEW.
   SwiftUI on Big Sur silently drops every chain except the
   last, then crashes the render loop. Use ONE
   `.sheet(item:)` with an Identifiable enum discriminator.

4. NO TUPLE-KEYPATH IN `ForEach`.
   `ForEach(arr, id: \.label)` over a `[(label: ...)]` is
   compile-clean on Swift 5.5 but produces an unstable view
   identity → "Entangling fence requested after pre-commit"
   warnings → EXC_BAD_ACCESS in objc_release. Use a named
   `Identifiable` struct.

5. NO `try!` / `as!` / `array[i]!` IN RUNTIME PATHS.
   Tests are exempt. The pre-commit hook will block.

6. SF SYMBOLS 2 ONLY.
   Route any modern symbol name through
   `SFSymbolCompat.name("...")`. The pre-commit hook will block.

7. VIEWBUILDER ≤ 10 DIRECT CHILDREN per closure. Wrap with
   `Group { ... }` when you hit the limit. Heuristic lint runs
   pre-commit.

8. UNIVERSAL BINARY — release config keeps
   ONLY_ACTIVE_ARCH = NO so it ships arm64 + x86_64.

9. NEVER EDIT project.pbxproj BY HAND.
   If you create a new file under desktopAhaan/Resources/...
   it MUST be registered to the build target. Use the
   xcode-tools MCP `XcodeWrite` tool (which auto-adds), OR
   ask me to drag-add via Xcode's "Add Files…" dialog.
   Articles/Chapter* is a PBXGroup with individually-listed
   file references — folder references are NOT used, so new
   files on disk alone are invisible to the build.

10. NEVER claim "bug-free" or "no regressions" without
    actually LAUNCHING the app at least once. Tests passing
    ≠ runtime working. The lints don't catch SwiftUI render-
    loop bugs.

═══════════════════════════════════════════════════════════════
REQUIRED VERIFICATION STEPS (in order, every time)
═══════════════════════════════════════════════════════════════

Before every commit:
  1. python3 scripts/check_macos12_apis.py       → exit 0
  2. python3 scripts/check_sf_symbols_compat.py  → exit 0
  3. python3 scripts/check_viewbuilder_limit.py  → exit 0
  4. BuildProject MCP tool                       → build clean
  5. RunAllTests MCP tool                        → 307+ pass

Before declaring a UI change "fixed":
  6. Cold-launch the app in Xcode (⌘B then ⌘R)
  7. Click through the affected surface end to end
  8. If a sheet, present + dismiss + present again
  9. Read ~/Library/Containers/com.emoha.desktopAhaan/Data/
     Library/Application Support/desktopAhaan/crashlogs/
     crashlog-YYYY-MM-DD.txt → no new EXC / SIGNAL / HANG
     entries since the build started

After every push:
 10. Confirm `git rev-parse HEAD` == `git rev-parse origin/main`
 11. Tell the user EXPLICITLY to ⌘B (clean build) and ⌘R on
     the iMac — stale binaries WILL keep crashing.

═══════════════════════════════════════════════════════════════
CHAPTER 1 — SPECIFIC SURFACES TO PROTECT
═══════════════════════════════════════════════════════════════

A. ChapterDetailView for ch01 has THREE enrichment cards:
   • Beyond the Book (gated by Bundle.main URL probe)
   • Try at Home  (gated by HomeExperimentLibrary.experiments[id])
   • My Notebook  (always shown)

   Sheet presentation MUST be a single .sheet(item: $presentedSheet)
   with an `enum SheetKind: String, Identifiable { … }`.

B. Discover Mode for ch01 has 21 scenes (Scene1 … Scene9_BossQuiz).
   Scene 20 = Van Helmont's Willow (inline private struct).
   Scene 21 = Boss Quiz with 15 hand-authored MCQs.
   The dispatcher uses an AnyView lookup table to keep build
   time at ~5-8 s instead of the 210 s a 21-case @ViewBuilder
   switch would produce.

C. Boss Quiz Ch.1 (Scene9_BossQuiz.swift) is the OLD pattern —
   uses Ch1QuizItem, hard-coded `count: 15` / `total: 15` /
   `< 14` / `score / 15`. If you bump the quiz length again,
   change ALL of those literals together.

D. ArticleIndex.entries["ch01_beyond"] points to
   Resources/Articles/Chapter1/ch01_beyond.html. The HTML file
   MUST be in the Xcode project's PBXResourcesBuildPhase.
   ChapterDetailView.beyondTheBookEntry probes Bundle.main and
   hides the card if not bundled — so a half-finished addition
   degrades gracefully instead of dead-clicking.

E. HomeExperimentLibrary.experiments["ch01"] holds 5 cards.
   Each is a struct with emoji/title/needs/steps/whyItWorks/
   estimatedMinutes. No tuple types, no force-unwraps.

F. ChapterNotebookSheet writes to DataStore.chapterNotes[…]
   on every TextEditor keystroke, through setChapterNote()
   which is 250 ms-debounced via saveCoalesced. Persists to
   notes.json in Application Support.

═══════════════════════════════════════════════════════════════
DON'T CHANGE
═══════════════════════════════════════════════════════════════

- The inline-in-dispatcher scene pattern (works around the
  pbxproj add-files ceremony AND the 210 s compile-time cliff).
- The AnyView lookup-table dispatcher
  (commit 7843d56 explains why).
- The hard-coded "21 scenes" / "382 total" test pins. If you
  change scene counts, change the pins TOGETHER in the same
  commit so CI fails before the kid sees a wrong celebration.
- CrashReporter.install / startHangDetection: they early-return
  under XCTest by design — don't "fix" this.

═══════════════════════════════════════════════════════════════
WHEN IN DOUBT
═══════════════════════════════════════════════════════════════

Read CLAUDE.md (top of repo) — it has the authoritative list
of constraints. Read docs/ISSUES_AUDIT_2026-05-21.md for the
known-bug taxonomy. Read this file for the Ch.1-specific
gotchas.

If any rule above conflicts with a request, surface the conflict
and ask. Don't silently take the easier path.
```

---

## How to use this prompt

1. **At the start of a session**, paste the block above into the
   chat (or attach this file). Claude will reference it.
2. **When a bug is reported** in Ch.1, the prompt forces the same
   verification cadence that should have caught it the first time.
3. **When updating this prompt itself**, bump the date in the
   "Last updated" line and add a new bullet to the rule that the
   regression violated. The doc grows with the project.

## What this prompt would have prevented today (2026-05-21)

| Regression | Rule it now violates |
|---|---|
| `.animation(.easeOut(0.2), value: years)` in Van Helmont | §2 (banned API list) |
| 14 latent `.animation(_:value:)` calls in Ch.8/9/10/11/12/14/17 + OCR + SoftShadowCard | §2 + required lint step 1 |
| Two `.sheet(isPresented:)` modifiers on ChapterDetailView | §3 (single-sheet rule) |
| `ForEach(options, id: \.label)` over a tuple array | §4 (no tuple-keypath) |
| ch01_beyond.html on disk but not in PBXResourcesBuildPhase | §9 (pbxproj awareness) |
| Claiming "bug-free" without launching the app | §10 + required verification step 6 |
