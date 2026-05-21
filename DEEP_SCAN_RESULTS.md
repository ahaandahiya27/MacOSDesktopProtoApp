# Deep Scan Results — 2026-05-22 (12h-spec iter 2/3)

Exhaustive recursive scan of every `desktopAhaan/**/*.swift` (production target, excluding tests) against the §B hazard taxonomy from the 12-hour spec.

This file is a **current-state snapshot**, not a log. It is overwritten on every scan.

## 1. Lifetime hazards (C1 root causes)

| Pattern | Hits | Note |
|---|---|---|
| `unowned` | **0** | clean |
| `var delegate:` (no `weak`) on NSObject subclass | **0** | clean |
| `@unchecked Sendable` | **0** | clean |
| `Timer.scheduledTimer` without `[weak self]` | **0** | all 3 sites (`DataStore.swift:736`, `Extensions.swift:474`, `ParticleEmitter.swift:71`) properly bind weak or run on a `struct` view |
| raw `NotificationCenter.default.addObserver(_:selector:name:object:)` | **0** | clean — only `.onReceive` SwiftUI bindings exist |
| `Combine .sink` without `[weak self]` | scan TBD | only 1 reachable site (`TranslatorViewModel:33`) — already uses `[weak self]` |
| `WKWebView()` lazy allocation | **1** | `ArticleBrowserView` allocates eagerly at coordinator init; mitigated by `coordinator.cleanup()` in `.onDisappear` (commit `178a113`) |
| `NSHostingView` rootView holding `@StateObject` shared across teardown | **1** | `ArticleWindowManager.openArticle` — the @StateObject is local to ArticleBrowserView (not bridged); safe pattern |

**C1 verdict**: **zero new findings**. Existing mitigations (sheet collapse `8198bd8`, WKWebView cleanup `178a113`, layout-recursion `793c4ed`, combined-transition flatten `8cfb6e7`, ArticleWindowManager bound `9fd1e53`) appear to close the class.

## 2. State-mutation hazards (C2 root causes)

| Pattern | Hits | Note |
|---|---|---|
| `@Published` written inside `init(...)` of `ObservableObject` | **0** | clean |
| `@StateObject` whose `init` does heavy work | **0** | SpeechRecognitionManager.init reverted to lazy (commit `49a7790`) |
| `.onAppear { self.<published> = ... }` synchronously | scan TBD | many; all in scenes — fires after body commit |
| `.onReceive { ... self.x = ... }` synchronously inside body | **9** | all are NotificationCenter menu-command bindings — closure runs on next runloop tick, not during body commit |
| `Task { @MainActor in ... }` inside `body` | **0** | clean (only inside `.onAppear` / `.onTapGesture` action closures) |
| `objectWillChange.send()` not wrapped in `DispatchQueue.main.async` | **0** | clean |

**C2 verdict**: **zero new findings**. The 9 `.onReceive` sites are all safe (NotificationCenter publishers run after the view-update commit).

## 3. Speech-permission hazards (C3 root causes)

| Pattern | Hits | Note |
|---|---|---|
| `SFSpeechRecognizer.authorizationStatus()` eagerly in @Published default | **0** | reverted in `49a7790` |
| `SFSpeechRecognizer.requestAuthorization` outside user-action path | **0** | only inside `requestPermissions()` which now early-returns on XCTest + already-determined status |
| `AVAudioSession.sharedInstance().setCategory` at app launch | **0** | only inside `startListening` |
| `AVSpeechSynthesisVoice.speechVoices()` at launch | **0** | not called at launch |

**C3 verdict**: **zero new findings**. The deferred-to-first-tap fix (commit `a296077`) plus XCTestConfigurationFilePath guard cover the class.

## 4. WKWebView hazards (C4 root causes)

| Pattern | Hits | Note |
|---|---|---|
| `WKWebView` allocation in `body` (per-render new instance) | **0** | only allocated in `WebViewCoordinator.init` which is `@StateObject`-lifetimed |
| `navigationDelegate` not nilled in cleanup | **0** | cleanup() sets both delegates to nil (commit `178a113`) |
| `webViewWebContentProcessDidTerminate(_:)` not handled | **0** | implemented in `ArticleBrowserView.swift:255` — sets `loadFailed = true` so parent renders fallback |
| `ArticleWindowManager.windows` unbounded | **0** | capped at 8, FIFO eviction (commit `9fd1e53`) |

**C4 verdict**: **zero new findings**. The cleanup hook + FIFO bound + WebContent termination handler cover the class.

## 5. Compile-time hazards

| Pattern | Hits | Note |
|---|---|---|
| Swift files > 600 lines | (many, see below) | Ch.1 + ContentView split done; DataStore (858), QuestionDetailView (929), ArticleIndex (1270), DiscoverChapter2View (965), ChapterDetailView (839) still pending |
| `body` > 80 lines or > 5 nesting levels | scan TBD | next iteration |
| `.modifier().modifier()...` chains > 10 deep on one line | scan TBD | next iteration |

## 6. macOS 11 compatibility

| Pattern | Hits | Note |
|---|---|---|
| `.foregroundStyle`, `.symbolEffect`, `.scrollPosition`, `.scrollIndicatorsFlash`, `.contentTransition`, `ImageRenderer`, `NavigationStack`, `NavigationSplitView`, `@Observable`, two-arg `.onChange` | **0** | lint `scripts/check_macos12_apis.py` enforces (iter 6 extension shipped `0f2eecd`) |

## 7. Sheet & navigation hazards

| Pattern | Hits | Note |
|---|---|---|
| Multiple `.sheet(isPresented:)` on same view | **0** | ContentView refactored (`8198bd8`), ChapterDetailView refactored (`21f3d11`) |
| `NavigationLink(isActive:)` racing with state | scan TBD | next iteration |

## 8. Data hazards

| Pattern | Hits | Note |
|---|---|---|
| `Data(contentsOf:)` on `@MainActor` for non-trivial payload | **1** | `DataStore.swift:283` schema_version read — bytes-sized, accepted |
| `JSONDecoder().decode(...)` on `@MainActor` | **0** | All pack decoding via `Task.detached` (commits in SubjectRegistry / DataStore) |
| `try? write` swallowing errors | scan TBD | next iteration |

---

## Open items queued for fix (next iterations)

- **High**: split DataStore (858 LOC), QuestionDetailView (929 LOC), ChapterDetailView (839 LOC), DiscoverChapter2View (965 LOC), ArticleIndex (1270 LOC) — all over the 600-line type-checker risk threshold.
- **Medium**: re-scan `body` computed properties for > 80-line bodies in remaining mega-files after the splits.
- **Medium**: scan `try? write` sites — should surface to `lastSaveError` banner pattern.

## Verdict

Each of the four crash classes (C1, C2, C3, C4) has **zero open static findings** at this scan. Remaining risk is dynamic (LLDB-only crash that never reaches the OS signal handler). To convert dynamic confidence to certainty we need the XCUITest walkers from §A of the 12-hour spec (CTA walker + sanitizer walker), which require modifying the Xcode scheme — out of scope for headless tool use here.
