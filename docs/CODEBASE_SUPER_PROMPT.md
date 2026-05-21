# desktopAhaan Codebase Super Prompt + Issues Audit (2026-05-21)

A paste-ready prompt for any Claude session touching this repo, **plus**
the current known-issues / gaps / problems list. Maintains Big Sur
backward compatibility as the highest-priority constraint. Update both
sections when state changes.

---

## PART 1 — THE SUPER PROMPT (paste verbatim at session start)

```
You are about to make changes to the desktopAhaan repo. Read every
rule below before touching any code. If a change can't satisfy ALL
of them, surface the conflict and ask the user first.

═══════════════════════════════════════════════════════════════════
PROJECT IN ONE PARAGRAPH
═══════════════════════════════════════════════════════════════════

Single-window macOS SwiftUI app for one 12-year-old (Ahaan):
Sanskrit translator + Class 7 NCERT Science tutor (19 chapters,
~190 concepts, ~830 questions, 21+ Discover scenes per chapter) +
OCR translator. Single user, offline-first, no accounts, no
telemetry. Only outbound network call is the optional
FreeOnlineTranslationProvider (user-toggleable).

═══════════════════════════════════════════════════════════════════
HARD PLATFORM CONSTRAINTS — DO NOT BREAK
═══════════════════════════════════════════════════════════════════

Deploy target: Late-2014 iMac running Big Sur 11.7.11, Xcode
13.2.1 (Swift 5.5), AMD R9 M290X 2 GB GPU. Dev Macs are modern
Apple Silicon. Ship is a universal binary (arm64 + x86_64).

1. NO macOS 12+ APIs anywhere. Pre-commit lint enforces. The
   complete banned list (truth source:
   scripts/check_macos12_apis.py):
     • .animation(_:value:)            • .scrollDismissesKeyboard
     • .foregroundStyle(…)             • .scrollContentBackground
     • .symbolEffect / .symbolRenderingMode
     • .scrollPosition / .formStyle / .dynamicTypeSize
     • .refreshable / .toolbarRole / .searchable / .tint
     • .task / .task(_:)               • @FocusState / .focused
     • @Observable / @Bindable         • NavigationStack /
       NavigationSplitView             • Font.monospaced()
     • AsyncImage                      • Chart { … } / import Charts
     • Color.brown / .mint / .cyan / .indigo / .teal
   Replacements documented inline in the lint script. Use
   .accentColor(…), .foregroundColor(…), Color.compatBrown /
   .compatIndigo, .onAppear { Task { … } } instead.

2. SF Symbols 2 only — modern symbol names render BLANK on
   Big Sur. Route every literal through SFSymbolCompat.name("…")
   in Extensions.swift. Pre-commit lint enforces (44 known names).

3. ViewBuilder ≤ 10 direct children per closure. Heuristic lint
   warns. Wrap with Group { … } when you hit the limit.

4. No `try!` / `as!` / `array[i]!` in runtime paths. Tests are
   exempt. FoundationTutor (the AI shim) is exempt per CLAUDE.md.
   Pre-commit lint hard-fails on the rest.

5. Particle counts honour HardwareTier.isLegacy — cap at 20 fps
   on legacy. The AMD R9 M290X 2 GB GPU is the real bottleneck.

6. ONLY_ACTIVE_ARCH = NO in Release config — both archs always.

7. No multiple .sheet(isPresented:) modifiers on the same view.
   SwiftUI on Big Sur drops every chain except the last. Use ONE
   .sheet(item:) with an Identifiable enum discriminator.

8. No tuple-keypath ForEach. `ForEach(arr, id: \.label)` over a
   `[(label: ...)]` tuple array compiles cleanly on Swift 5.5 but
   produces unstable view identity → "Entangling fence requested
   after pre-commit" → EXC_BAD_ACCESS. Use a named Identifiable
   struct.

9. No heavy SwiftUI transitions on Big Sur. .move(edge:) /
   .asymmetric force layout of outgoing + incoming subtrees
   simultaneously, causing ~1 s main-thread hangs at navigation
   time. Prefer .opacity or .identity (with Reduce Motion guard).

10. Inline-scene-in-dispatcher pattern. New Discover scenes live
    as `private struct` at the bottom of the chapter's
    DiscoverChapter<N>View.swift file. Avoids the pbxproj
    add-files ceremony AND the 210 s @ViewBuilder compile-time
    cliff (which the AnyView lookup-table dispatcher closes).

═══════════════════════════════════════════════════════════════════
NEVER DO
═══════════════════════════════════════════════════════════════════

• Edit project.pbxproj by hand. Articles/Chapter* is a PBXGroup
  of explicit file references — folder references are NOT used.
  New files on disk are invisible to the build until registered.
  Use the xcode-tools MCP `XcodeWrite` tool (it auto-adds to
  project), OR ask the user to drag-add via Xcode's "Add Files…"
  dialog.

• Claim "bug-free" / "no regressions" / "fixed" without LAUNCHING
  the app at least once. Tests passing ≠ runtime working. Lints
  don't catch SwiftUI render-loop bugs. Crashlog ≠ debugger pause.

• Commit changes the user didn't request. Bundle a refactor with
  a bug fix means the bug fix is now coupled to unrelated risk.

• Skip the pre-commit / pre-push hooks via --no-verify unless the
  user explicitly says so.

• Use Dictionary(uniqueKeysWithValues:) — it fatally crashes on
  duplicate keys. Use Dictionary(_:uniquingKeysWith:) and log to
  CrashReporter.logDataIssue instead.

• Mutate the @AppStorage scene-counts magic-number constants
  without updating the matching ratchet test pin
  (testTotalDiscoverScenesPinnedAt382) in the same commit. Else
  the kid hits the "all chapters complete" celebration early
  or never.

═══════════════════════════════════════════════════════════════════
ALWAYS DO
═══════════════════════════════════════════════════════════════════

Before any commit:
  1. python3 scripts/check_macos12_apis.py    → exit 0
  2. python3 scripts/check_sf_symbols_compat.py → exit 0
  3. python3 scripts/check_viewbuilder_limit.py → no critical
  4. BuildProject MCP tool                    → clean
  5. RunAllTests MCP tool                     → all green

Before declaring a UI change "fixed":
  6. Cold-launch the app in Xcode (Clean Build Folder ⌘⇧K,
     then ⌘B then ⌘R)
  7. Click through the affected surface end to end
  8. Open + dismiss + re-open every sheet/window introduced
  9. Read ~/Library/Containers/com.emoha.desktopAhaan/Data/
     Library/Application Support/desktopAhaan/crashlogs/
     crashlog-YYYY-MM-DD.txt → no new HANG / EXCEPTION /
     SIGNAL entries with a fresh timestamp

After every push:
 10. Confirm `git rev-parse HEAD` == `git rev-parse origin/main`
 11. Tell the user EXPLICITLY to Clean Build Folder + rebuild
     on the iMac. Stale binaries WILL keep showing the old bug.

═══════════════════════════════════════════════════════════════════
KEY ARCHITECTURE INVARIANTS — DO NOT CHANGE LIGHTLY
═══════════════════════════════════════════════════════════════════

• AnyView lookup-table dispatcher in every DiscoverChapter<N>View
  closes a 210 s → 5 s Debug compile cliff. Don't refactor back
  to a @ViewBuilder switch.

• DataStore.saveCoalesced(_:to:) uses a 250 ms debounce on hot
  mutators. Don't switch hot paths back to synchronous save().

• CrashReporter.install + startHangDetection early-return under
  XCTest by design. Don't "fix" this — they'd flood the crashlog
  with false-positive XCTWaiter hangs.

• @AppStorage keys all route through AppStorageKeys enum. A typo
  silently forks a fresh cursor.

• WKWebView in-page JS is disabled per-navigation in the article
  browser. Native evaluateJavaScript still works for Read Aloud.

• All file writes use options: .atomic.

• Inline-scene `@State` does NOT persist across view recreation
  by design — the inline structs are stateless demos. If a future
  scene needs persistent state, route through DataStore or
  @AppStorage.

═══════════════════════════════════════════════════════════════════
CONVENTIONS
═══════════════════════════════════════════════════════════════════

• Conventional commits: feat: / fix: / fix(content): / polish: /
  docs: / chore(scripts): / refactor:

• Every commit body ends with:
    Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

• PascalCase types, camelCase props/methods, 4-space indent.

• @State private var for SwiftUI state. let for constants.

• Add comments ONLY when WHY is non-obvious (constraint, invariant,
  bug history). Never narrate WHAT — well-named identifiers do that.

═══════════════════════════════════════════════════════════════════
WHEN IN DOUBT
═══════════════════════════════════════════════════════════════════

• Read CLAUDE.md (top of repo) — authoritative constraints.
• Read docs/ISSUES_AUDIT_2026-05-21.md — known-bug taxonomy.
• Read docs/CH1_BUG_FREE_SUPER_PROMPT.md — Ch.1 gotchas.
• Read THIS file (docs/CODEBASE_SUPER_PROMPT.md) — repo-wide.
• Read memory/ files — durable context from prior sessions.

If a rule above conflicts with a request, surface the conflict.
Don't silently take the easier path.
```

---

## PART 2 — KNOWN ISSUES, GAPS & PROBLEMS (2026-05-21 snapshot)

Severity scale: 🔴 user-visible crash/hang • 🟠 silent failure /
data risk • 🟡 cosmetic / latent only • 🟢 cleanup / debt.

### A. UI / SwiftUI

| ID | Sev | Issue | Why | Mitigation today |
|---|---|---|---|---|
| A1 | ✅ | Discover navigation transition was heavy (move-edge) → 1 s main-thread hangs | macOS 11 SwiftUI lays out outgoing + incoming subtrees together for move(edge:) | Replaced with .opacity in commit 3a2514b. Honours Reduce Motion. |
| A2 | ✅ | Stale `@AppStorage(discoverScene(N))` could index past array | Scene-count changes (20→21) leave old saved cursors briefly out of valid range | onAppear clamp now applied to all 19 chapter dispatchers (Ch.1–19). |
| A3 | ✅ | DiscoverEntryBanner hardcoded "9 interactive scenes" subtitle | Pre-dated the expansion. | Now reads `DataStore.discoverSceneCounts[chapter.number]` so it shows the live count per chapter. |
| A4 | 🟢 | `DiscoverChapter1View.swift` is 1498 LOC | All 21 inline scenes in one file. Compile-time and readability cost. | Inline pattern is deliberate (pbxproj-free + AnyView lookup). Accept the LOC. |
| A5 | 🟡 | Dynamic Type at xxxLarge not visually verified on any new inline scene | We never ran the app at AX5. Some Slider+Text rows may clip. | Defensive .minimumScaleFactor on tight labels would help. **Not done.** |

### B. Crashes & main-thread hangs

| ID | Sev | Issue | Notes |
|---|---|---|---|
| B1 | 🟡 | Two 1000–1900 ms launch HANGs in today's crashlog | One at app boot, one ~35 s in (Try Discover Mode tap). The render-loop hang IS now lighter post-3a2514b but still threshold-edge on Big Sur. |
| B2 | 🟡 | No real EXCEPTION / SIGNAL entries — every "crash" today was a debugger-pause artifact at `_dyld_release` | Misread as crashes. The crashlog is the ground truth, not the Xcode debugger view. |
| B3 | ✅ | Hang threshold was 1000 ms — borderline noisy on Big Sur during navigation | Bumped to 1500 ms with a documented rationale. Trade-off: misses subtle layout stalls; accepts as the right cut for kid-facing signal. |

### C. Build / project / bundling

| ID | Sev | Issue | Why dangerous |
|---|---|---|---|
| C1 | 🟠 | Articles/Chapter* is a PBXGroup of explicit file references, not a folder reference | New HTML on disk doesn't ship in the bundle until manually registered. Twice today: ch01_beyond.html + ch02_beyond.html. |
| C2 | 🟡 | 6 phantom ArticleIndex entries existed for HTML files that were never authored (`ch05_t02_c03/c04/c05`, `ch06_t02_c03`, `ch07_t02_c04/c05`) | Removed in commit 251fba3. Restore as the files are written. |
| C3 | 🟡 | The 90% threshold lint that hid C1+C2 has been tightened to require 100% on core entries, with a `_beyond` enrichment carve-out | Done in commit 251fba3. |

### D. Content gaps (no code risk, but learning value left on the table)

| ID | Sev | Issue | Effort |
|---|---|---|---|
| D1 | 🟢 | Pack JSON for the 209 new Discover scenes never authored | ~600 entries (concepts + questions + relations). Multi-day content work. |
| D2 | 🟢 | Companion HTML articles for the new Discover scenes | ~209 files. Multi-day. |
| D3 | 🟢 | Chapter 2 enrichment shipped (Boss Quiz +5, Beyond-the-Book, Try-at-Home, Discover scene 20, cross-chapter pointers) but Ch.3–19 not replicated | Pattern proven on Ch.1 and Ch.2 (commits 594e781, d65a5e1). Repeat for 17 more chapters. |
| D4 | 🟢 | Boss Quiz Ch.1 is on the OLD pattern (hardcoded 15s everywhere) — Ch.8–18 use modern `qs.count`-driven pattern | Would be cleaner to refactor Ch.1, 2, 3, 4, 5, 6, 7, 19 to modern pattern. Risky without UI testing. |

### E. Test coverage gaps

| ID | Sev | Issue | What test would catch it |
|---|---|---|---|
| E1 | ✅ | `testAllArticleHTMLFilesExistInBundle` carve-out for `_beyond` entries meant they could silently break | New `testBeyondTheBookArticlesAreAllBundled` requires 100% of `_beyond` entries to resolve in Bundle.main. |
| E2 | 🟡 | No XCUIAutomation snapshot tests on Discover scenes | A scene that builds but renders blank passes today. |
| E3 | 🟡 | No UI test exercises the new enrichment sheets (Try at Home, Notebook) | Would have caught the double-sheet bug. |
| E4 | 🟢 | iMac (Big Sur 11.7.11 / Xcode 13.2.1) verification gap | None of today's 50+ commits has been run on the deploy iMac. Mitigations exist (lints, pre-push CI with deployment-target 11.0, AnyView dispatcher) but the real test is the actual run. |

### F. Architecture / code quality

| ID | Sev | Issue | Notes |
|---|---|---|---|
| F1 | 🟢 | `ChapterDetailView.swift` is 830 LOC because Notebook + Home Experiments are inlined to avoid pbxproj | Acceptable trade-off given the pbxproj friction. |
| F2 | 🟢 | `ArticleIndex.swift` is 1190 LOC of static dictionary literals | Could be moved to a JSON file. Not done — fast to read for the kid app. |
| F3 | 🟢 | DiscoverChapter2View.swift is 955 LOC; only Ch.1 (1498) is bigger | Same inline-scene pattern. Acceptable. |
| F4 | 🟢 | DataStore.swift is 858 LOC, growing | Could split into PersistenceCoordinator + ReviewScheduler + StreakCalculator. Not done. |

### G. iMac-side gotchas (operational)

| ID | Sev | Issue | Recipe |
|---|---|---|---|
| G1 | 🟠 | Stale Xcode DerivedData masks ALL fixes | Always Clean Build Folder (⌘⇧K), then ⌘B, then ⌘R. The "kindly fix this crash" report often turns out to be the previous binary still running. |
| G2 | 🟡 | iMac pbxproj re-stamping on pull | scripts/imac-pull.sh quits Xcode, stashes pbxproj auto-edits, pulls, wipes DerivedData, re-opens. Use that recipe. |
| G3 | 🟡 | Ad-hoc signing (CODE_SIGN_IDENTITY = "-") | Don't propose Apple Developer / Team workflows — Apple Dev certs are revoked. |

### H. Recent fixes that closed real bugs (for context, not pending)

- `f108a05` Van Helmont scene .animation(_:value:) + tuple-keypath ForEach
- `0305629` 14 latent .animation(_:value:) calls across Ch.8/9/10/11/12/14/17 + lint
- `21f3d11` Double `.sheet(isPresented:)` → single `.sheet(item:)` in ChapterDetailView
- `69fa396` ch01/02_beyond.html added to Xcode project via XcodeWrite MCP
- `251fba3` Defensive Bundle.main probe + removed 6 phantom ArticleIndex entries
- `310713f` CrashReporter early-returns under XCTest (kills false-positive HANG noise)
- `3a2514b` Discover transition lightened + currentScene clamp

---

## How to maintain this document

When a new bug class lands or a constraint changes:

1. **Bump the date** in the H1 line.
2. **Add a row** to the relevant table with severity and mitigation.
3. **Add a banned API** to the lint AND to the SUPER PROMPT block.
4. **Add a recovery commit** to the "Recent fixes" list.

The aim is that a new Claude session pasting the SUPER PROMPT block
inherits every lesson learned to date, **without** the user having to
re-explain.
