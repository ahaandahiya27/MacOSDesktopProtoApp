# Crash Ledger — desktopAhaan

Per the 12-hour spec, every crash captured during this session lands here with: signal, top frame, repro path, root cause, fix commit, locking test.

## Four crash classes under hunt

### C1 — `EXC_BAD_ACCESS (code=1)` in `libobjc.A.dylib`objc_release`

**Signal**: read at `0x187b00120`, `ldr x17, [x2, #0x20]`.
**Last seen**: Xcode debugger paused on Try Discover Mode (Ch.1), 2026-05-21 (screenshot pasted by user). Caught by LLDB; no SIGNAL entry in `crashlog-2026-05-21.txt`.
**Suspected sites (per spec)**: NSHostingView teardown, WKWebView coordinator, NSWindow delegate, NSTimer target, AVSpeechSynthesizer delegate, Combine sink without `[weak self]`, `var delegate: T` that should be `weak var`, `@unchecked Sendable` classes.
**Mitigations already shipped**:
- `21f3d11` single `.sheet(item:)` in ChapterDetailView
- `8198bd8` single `.sheet(item:)` in ContentView (3-way collision)
- `178a113` WKWebView coordinator cleanup on disappear
- `793c4ed` Scene1_PlantKitchen layout-recursion fix (unbounded GeometryReader inside ScrollView/LazyVStack)
- `18cac57` Scene1_FluffToFibre same class
- `8cfb6e7` 12 combined-transition sites lightened
- `2760eb8` tuple-keypath `\.element.id` → `.indices` (CommandPalette, Scene1_FastOrSlow)
**Status**: 🟡 likely-fixed for the Ch.1 path; no fresh repro since 793c4ed. Awaiting locking XCUITest.

### C2 — SwiftUI "Ignoring request to entangle context after pre-commit"

**Signal**: `Entangling fence requested after pre-commit` / `Reporter disconnected` in console; no signal hand-off to OS so nothing reaches the in-app CrashReporter.
**Suspected sites (per spec)**: `.onAppear { state.x = ... }` on a `@Published`, `init { ... }` mutating `@Published`, `.onReceive { @StateObject.x = ... }` synchronously, `Task { @MainActor in ... }` inside `body`.
**Mitigations already shipped**:
- `49a7790` `SpeechRecognitionManager.authorizationStatus` reverted to `.notDetermined` default — was firing Speech.framework at every @StateObject construction.
- `f108a05` Van Helmont scene multi-line `.animation(_:value:)` removed; `ed478dd` extended lint catches multi-line variants
- 7 `.repeatForever` animations now honour `HardwareTier.duration(ideal:)`
**Status**: 🟡 lint catches all known forms; deep scan TBD for `.onAppear { x = ... }` and `Task { @MainActor in ... } inside body`.

### C3 — Speech-permission dialog re-prompts at cold start / test runs

**Signal**: SF Speech permission dialog appears at app launch or during XCTest, blocking the test.
**Suspected sites (per spec)**: `TranslatorViewModel.init`, `SpeechRecognitionManager.init`, `DictationButton.onAppear`, any other entry point not gated by `XCTestConfigurationFilePath`.
**Mitigations already shipped**:
- `25f712b` `SpeechRecognitionManager.requestPermissions()` early-returns when status is already determined.
- `a296077` `TranslatorViewModel.init` no longer calls `requestPermissions`; `DictationButton.toggle()` defers to first-tap; `XCTestConfigurationFilePath` guards `requestPermissions`.
- `49a7790` no eager `SFSpeechRecognizer.authorizationStatus()` in @Published default.
**Status**: ✅ believed fixed; awaiting locking unit test (Phase 2 of spec).

### C4 — WKWebView WebContent process termination during article open

**Signal**: `WebContent[NNN] CRASHSTRING: XPC_ERROR_CONNECTION_INVALID`, `Reporter disconnected`, over-release of coordinator on `dismantleNSView`.
**Suspected sites (per spec)**: `ArticleBrowserView` coordinator lifecycle, `ArticleWindowManager.windows` unbounded array, WKWebView created on `body` (per-render new instance).
**Mitigations already shipped**:
- `178a113` `ArticleBrowserView.onDisappear → coordinator.cleanup()`; cleanup() now stops loading, invalidates each NSKeyValueObservation, clears navigation/UI delegates.
- `9fd1e53` `ArticleWindowManager.windows` capped at 8 with FIFO eviction + os.Logger telemetry.
**Status**: ✅ believed fixed; awaiting 100-iteration tear-down test.

---

## Open work to lock the four fixes

- [ ] XCUITest `desktopAhaanTests/CrashRepros/Crash1_TryDiscoverMode_Ch1.swift` — walks Sidebar → Science → Ch.1 → Try Discover Mode and asserts a known element renders.
- [ ] Unit test that asserts `requestPermissions()` early-returns under `XCTestConfigurationFilePath`.
- [ ] Unit test that creates+tears-down `ArticleBrowserView` 100 times and asserts `ArticleWindowManager.windows.count` ≤ 8 throughout.
- [ ] Lint addition: refuse `var delegate:` in any class that inherits from `NSObject` (must be `weak var`).
- [ ] Lint addition: refuse `unowned` anywhere outside `@MainActor`-isolated init (use `weak`).
- [ ] Lint addition: refuse `@unchecked Sendable` in new code.
