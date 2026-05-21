# Crash Deep Research — desktopAhaan, Big Sur 11.7.11 target

A from-the-evidence forensic audit of every observed and plausible crash
source as of 2026-05-21. Companion to `CRASH_FIX_SUPER_PROMPT.md`
(which lists the canonical fix patterns); this doc records **what was
actually found** in the crash logs, what the audit turned up, and what
remains as a hypothesis vs. what shipped as a fix.

---

## 1. Crash logging is already in place

`CrashReporter.swift` writes append-only text files to:

```
~/Library/Containers/com.emoha.desktopAhaan/Data/Library/Application Support/desktopAhaan/crashlogs/
```

Format is human-readable. Four entry kinds:

| Kind        | What triggers it                                                  |
|-------------|-------------------------------------------------------------------|
| `EXCEPTION` | `NSSetUncaughtExceptionHandler` callback — Obj-C exception        |
| `SIGNAL`    | POSIX signal handler — SIGSEGV / SIGABRT / SIGBUS / SIGILL        |
| `DATA`      | `CrashReporter.logDataIssue(_:)` — soft data invariants, hangs    |
| `RECOVERY`  | Previous session ended without `applicationWillTerminate`         |

Help menu exposes "Reveal Crash Logs in Finder" and "Clear Crash Logs"
(see `desktopAhaanApp.swift` ~line 196). The hang detector runs DEBUG-only
at 250 ms tick interval; threshold was 1.0 → 1.5 → **2.0 s** (commit
`49a7790`) after Big Sur cold-launch WKWebView XPC init proved to take
~1.6–1.8 s legitimately.

## 2. What the logs actually say

Today's log (`crashlog-2026-05-21.txt`) has **39 entries** and **zero
EXCEPTION or SIGNAL entries**. Breakdown:

- ~6 × `DATA` HANG entries (1000 ms with old threshold; 1300–1717 ms range)
- ~8 × `RECOVERY` notes — "previous session ended without a clean quit"

Yesterday's log (`crashlog-2026-05-20.txt`) is the same shape.

**Critical inference**: the EXC_BAD_ACCESS in `objc_release` the user
sees in the Xcode debugger is **caught by LLDB before the OS hands a
signal to the process**. Production builds (Release config, no
debugger attached) may not actually terminate — the process either
limps along with a corrupted view tree, or LLDB-only safety guards
(like ASan-lite for ObjC ARC) fire only in DEBUG. This is consistent
with the absence of any `[SIGNAL] 2026-05-21` line.

Practical consequence: **we cannot diagnose from logs alone.** We have
to reason from the screenshot stack (objc_release) plus the symptoms
("Try at Home is breaking, Ch.1, regularly").

## 3. Bug classes confirmed FIXED on origin/main

| # | Class | Fix commit | Where |
|---|-------|------------|-------|
| 1 | Tuple-keypath `ForEach(Array(x.enumerated()), id: \\.offset)` | `818aff0` | 13 sites |
| 2 | macOS 12+ APIs `.animation(_:value:)` etc. | various | 14 `.animation` sites + 24 lint rules |
| 3 | Double `.sheet(isPresented:)` collision on ChapterDetailView | `21f3d11` | single `.sheet(item:)` enum |
| 4 | Three-way `.sheet(isPresented:)` collision on ContentView | `8198bd8` | single `.sheet(item:)` enum |
| 5 | Speech-permission re-prompt loop | `25f712b` / `a296077` | early-return + lazy first-tap |
| 6 | Eager `SFSpeechRecognizer.authorizationStatus()` cold-launch hang | `49a7790` | revert to `.notDetermined` default |
| 7 | Hang threshold tuned 1.0 → 2.0 s | `49a7790` | matches Big Sur WKWebView XPC init |
| 8 | `Dictionary(uniqueKeysWithValues:)` fatal on dup | `8198bd8` | two sites → `uniquingKeysWith:` |
| 9 | SF Symbols 3+ literals | various | 44-entry compat map |
| 10 | ViewBuilder ≤10 children | various | Group{} wrappers |
| 11 | Discover-scene `currentScene` out-of-range on launch | `f108a05` | `.onAppear { clamp }` |

## 4. New finding (HIGH) — WKWebView coordinator cleanup gap

`Subjects/Articles/ArticleBrowserView.swift`:

- `WebViewCoordinator` (line 199) owns a `WKWebView` and three KVO
  observations.
- `cleanup()` was defined at line 316 but **never called** anywhere.
- `@StateObject` lifecycle releases the coordinator when the hosting
  `NSWindow` closes or the sheet dismisses. At that point, the WKWebView
  is mid-flight if the user closed before the page settled.
- On Big Sur, the AMD R9 M290X WebContent subprocess is unstable:
  Metal shader binary archive failures, sandbox lookups to
  `launchservicesd` returning error 159, IconRendering framework
  precondition fails. The crash log even shows these in the screenshot
  the user shared (WebContent[73882] sandbox warnings, the IconRendering
  metallib precondition).
- If a WebContent process callback queues onto main while the
  coordinator is mid-release, ARC re-runs `objc_release` on an
  already-zeroed object → EXC_BAD_ACCESS.

**Fix landed in this commit**: `.onDisappear` now calls
`coordinator.cleanup()`. The cleanup function was strengthened to:
1. Call `webView.stopLoading()` first (kills in-flight requests),
2. `invalidate()` every NSKeyValueObservation (synchronous unregister),
3. Clear `navigationDelegate` and `uiDelegate`.

This is the most plausible single cause of the reported "Try at Home"
crash IF the user had opened a "Beyond the Book" article window in the
same session (the BeyondTheBookCard sits in the same HStack as
TryAtHomeCard in `ChapterDetailView.swift:65-72`, so they often co-trigger).

## 5. Lower-priority findings (catalogued, not yet fixed)

| Severity | Location | Issue |
|----------|----------|-------|
| MEDIUM | `Subjects/Tutor/Discover/Chapter1/Scenes/Scene8_VenusFlytrapReflex` etc. | Tasks started in `startRound()` / `snap()` aren't cancelled on scene swap. If user navigates away mid-round, Task mutates `flyOnTrap` on a torn-down view. Mitigated in part by `[weak self]` patterns but worth a `@State private var task: Task<Void, Never>?` + `.onDisappear { task?.cancel() }` review. |
| MEDIUM | `Extensions/Extensions.swift:474` (`TimedSceneModifier`) | `Timer` closure mutates `@Binding tick` without weak capture. Rare race on view teardown. |
| LOW | Inner scene transitions using `.transition(.opacity.combined(with: .scale))` and `.move` and `.asymmetric` | DiscoverShell already lightened outer transition to plain `.opacity` (`3a2514b`). Same lightening recommended on inner Scenes if a Discover-scene crash surfaces. |
| LOW (cosmetic) | `ChapterDetailView.swift:351` | Hard-coded "5 experiments" string regardless of `HomeExperimentLibrary.experiments[chapter.id].count`. Content bug, not a crash. |

## 6. Bug classes audited and found CLEAN

- No remaining `try!` / `as!` / `[i]!` in runtime paths (excluding
  desktopAhaanTests and the documented FoundationTutor carve-out).
- No `NotificationCenter.default.addObserver` without a matching teardown.
- All `ObservableObject` classes (DataStore, SubjectRegistry,
  SpeechRecognitionManager, TextToSpeechManager, OCRService,
  SpeechReader, TutorNavigationState, AppState, TranslatorViewModel,
  PracticeViewModel, FoundationTutor, WebViewCoordinator) are
  `@MainActor` or publish only via `Task { @MainActor in ... }` /
  `DispatchQueue.main.async`.
- No state mutation directly in any `body` computed property.
- No `withAnimation` blocks mutate state that owns a
  `@StateObject`/sheet/NavigationLink identity.

## 7. What the user should see after this push

- Try-at-Home should stop crashing if (and only if) the crash class
  was the WebViewCoordinator pending-callback scenario.
- If it still crashes, the next step is to attach an LLDB exception
  breakpoint on `objc_release` and capture the full backtrace AT the
  crash, not the post-trap idle stack. That single screenshot will
  narrow the remaining hypothesis space dramatically.

## 8. Re-running this audit

Single pass:

```bash
python3 scripts/check_macos12_apis.py
python3 scripts/check_sf_symbols_compat.py
python3 scripts/check_viewbuilder_limit.py
xcodebuild -project desktopAhaan.xcodeproj -scheme desktopAhaan -configuration Debug test
```

All four should be clean (310/310 tests passing as of `8198bd8`).

## 9. When the user reports the next crash

The `docs/CRASH_FIX_SUPER_PROMPT.md` doc is paste-ready. Read the
screenshot stack, match to one of the 10 classes there, run the
detector, ship the fix.

---

Last updated: 2026-05-21 22:20 +05:30
Origin: `origin/main` at commit `8198bd8` (this commit will add the
WebView cleanup fix and bump the hash).
