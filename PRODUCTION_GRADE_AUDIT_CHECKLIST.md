# desktopAhaan — Production-Grade Audit Checklist

Generated: 2026-05-22 by Claude (Opus 4.7, 1M context).

## Reading guide

- Each leaf item is a binary check (✅ passes / ⚠️ partial / ❌ fails / ❓ not yet verified).
- "Confirm by" lines tell the auditor how to verify in 1–2 minutes (a grep, a build flag, a runtime check, or a manual test).
- "Failure mode" lines tell what bad looks like — so a half-broken implementation doesn't silently pass.
- Use this document as the agenda for Rohan-led grilling sessions, one macro-category at a time.
- Items are NOT pre-judged. The auditor walks them; this file is the catalogue.
- When a check refers to a specific file or symbol that already exists in this repo, the path is named so you don't have to hunt for it.
- The numbering is `<macro>.<subcat>.<item>` so any item can be referenced unambiguously.

## How to flip a row

Replace `[ ]` with one of:
- `[x]` for ✅ pass with the SHA where the proof landed.
- `[!]` for ⚠️ partial — note the gap in the same line.
- `[X]` for ❌ fail — link to the issue or commit that opened it.
- `[?]` for ❓ unverified — keep as a TODO with the owner.

---

## Category 1 — Crash classes — force-unwrap family

### 1.1 Optional unwrap (`!`) on reachable runtime paths

- [ ] 1.1.1 — Zero `!` force-unwraps in any file under `desktopAhaan/` except `FoundationTutor.swift` (documented AI-shim carve-out per `CLAUDE.md`).
      Confirm by: `grep -nE '[^!=<>][!](?!=)' --include='*.swift' desktopAhaan/ | grep -vE '(FoundationTutor|^Binary|//)'`
      Failure mode: SIGABRT on the iMac the first time the wrapped value is nil — single force-unwrap kills the morning's session.
- [ ] 1.1.2 — Every `Bundle.main.url(forResource:withExtension:)` and `Bundle.main.path(forResource:)` is matched by a `guard let` or `if let`, never `!`.
      Confirm by: `grep -nE 'Bundle\.main\.(url|path)' --include='*.swift' desktopAhaan/`
      Failure mode: A renamed/missing asset crashes the app at load instead of degrading gracefully.
- [ ] 1.1.3 — Every `URL(string:)` is treated as Optional. No `URL(string:"…")!`.
      Confirm by: `grep -nE 'URL\(string:.+\)!' --include='*.swift' desktopAhaan/`
      Failure mode: An invalid URL constant or a typo crashes the call site instead of returning nil.
- [ ] 1.1.4 — No `as!` (force cast) on reachable runtime paths. `as?` + guard everywhere.
      Confirm by: `grep -nE '\bas!\b' --include='*.swift' desktopAhaan/`
      Failure mode: A schema change that introduces a type mismatch crashes instead of being decoded as nil.
- [ ] 1.1.5 — No `try!` on reachable runtime paths. Use `try?` + nil-check or `do { } catch { CrashReporter.logDataIssue(…) }`.
      Confirm by: `grep -nE 'try!' --include='*.swift' desktopAhaan/`
      Failure mode: A transient disk error becomes a SIGABRT instead of a "couldn't save" banner.
- [ ] 1.1.6 — Implicit-unwrapped optionals (`Foo!` declaration syntax) are absent outside `@IBOutlet`-style late binding. None of those exist here, so the count should be zero.
      Confirm by: `grep -nE '^\s*(var|let)\s+\w+\s*:\s*\w+\!' --include='*.swift' desktopAhaan/`
      Failure mode: Reading before assignment crashes; the type system can't help.
- [ ] 1.1.7 — `unsafelyUnwrapped` is forbidden — has the same crash semantics as `!` and worse readability.
      Confirm by: `grep -n 'unsafelyUnwrapped' --include='*.swift' desktopAhaan/`
      Failure mode: Same as `!` but harder to spot in code review.

### 1.2 Array / Collection out-of-bounds

- [ ] 1.2.1 — Every `array[i]` access in a non-`indices` loop is guarded by `indices.contains(i)`, `if i < array.count`, or `array[safe: i]`.
      Confirm by: visually scan `grep -nE '\[(0-9|i|index|idx|cursor)\]' --include='*.swift' desktopAhaan/ | grep -v '//'`
      Failure mode: Trap `Fatal error: Index out of range` when content packs change shape.
- [ ] 1.2.2 — Every `ForEach(0..<n)` where `n` comes from a dynamic collection uses `ForEach(array, id: \.id)` instead, so resizing doesn't crash.
      Confirm by: `grep -nE 'ForEach\(0\s*\.\.<' --include='*.swift' desktopAhaan/`
      Failure mode: SwiftUI re-renders after the array shrinks and indexes past the new end.
- [ ] 1.2.3 — `String.Index` arithmetic uses `index(_:offsetBy:limitedBy:)`, never `index(_:offsetBy:)` + raw integer.
      Confirm by: `grep -nE '\.index\(.+,\s*offsetBy:\s*[^l]' --include='*.swift' desktopAhaan/`
      Failure mode: Trap when the offset runs past the end on a shorter-than-expected string.
- [ ] 1.2.4 — `Dictionary(uniqueKeysWithValues:)` is absent in runtime paths (use `Dictionary(_:uniquingKeysWith:)` per `CLAUDE.md`).
      Confirm by: `grep -nE 'Dictionary\(uniqueKeysWithValues' --include='*.swift' desktopAhaan/`
      Failure mode: Trap on duplicate key from a content-pack drift instead of a logged DATA entry.
- [ ] 1.2.5 — `removeFirst()` / `removeLast()` calls are preceded by a non-empty guard.
      Confirm by: `grep -nE '\.(removeFirst|removeLast)\(' --include='*.swift' desktopAhaan/`
      Failure mode: Trap on empty collection during teardown.
- [ ] 1.2.6 — `Range`/`ClosedRange` constructions with both bounds dynamic (e.g. `a...b`) guard `a <= b`.
      Confirm by: `grep -nE '\.\.\.\s*\w+' --include='*.swift' desktopAhaan/`
      Failure mode: Trap "Can't form Range with upperBound < lowerBound" when inputs invert.

### 1.3 IUO and bridging traps

- [ ] 1.3.1 — Every Obj-C bridging API that returns `T!` is treated as `T?` at the call site.
      Confirm by: `grep -nE '(NSWorkspace|NSApplication|NSWindow).+!\.' --include='*.swift' desktopAhaan/`
      Failure mode: A new SDK version returning nil where it didn't before crashes at deploy.
- [ ] 1.3.2 — `NSAttributedString(string:)` and `NSAttributedString(data:options:documentAttributes:)` are wrapped in `try?` with a fallback string.
      Confirm by: read `PlainTextArticleFallback.stripHTML(_:)` and any `NSAttributedString(data:` site.
      Failure mode: Malformed HTML crashes the article reader.

---

## Category 2 — Crash classes — programmer-assertion family

### 2.1 `fatalError` and `preconditionFailure`

- [ ] 2.1.1 — No `fatalError(...)` calls on reachable runtime paths in production code.
      Confirm by: `grep -nE 'fatalError\(' --include='*.swift' desktopAhaan/ | grep -v 'FoundationTutor'`
      Failure mode: SIGABRT when an "impossible" branch fires (which it eventually does).
- [ ] 2.1.2 — No `preconditionFailure(...)` on reachable runtime paths.
      Confirm by: `grep -nE 'preconditionFailure\(' --include='*.swift' desktopAhaan/`
      Failure mode: Same as fatalError, but with the false comfort of "won't fire in release."
- [ ] 2.1.3 — No `precondition(_:_:)` outside debug-gated code or unit tests.
      Confirm by: `grep -nE '\bprecondition\(' --include='*.swift' desktopAhaan/`
      Failure mode: A user input or content drift trips a precondition that should have been an `if`.
- [ ] 2.1.4 — No `assertionFailure(...)` left where a real error path is needed.
      Confirm by: `grep -nE 'assertionFailure\(' --include='*.swift' desktopAhaan/`
      Failure mode: Debug builds crash, release builds silently take the wrong path.
- [ ] 2.1.5 — `assert(_:_:)` calls are limited to invariant docs and never carry the only check.
      Confirm by: `grep -nE '\bassert\(' --include='*.swift' desktopAhaan/`
      Failure mode: Invariant fires in debug, no fallback in release.

### 2.2 Trap-equivalent SDK calls

- [ ] 2.2.1 — `NSDecimalNumber.notANumber` is not used as a sentinel that could be passed to math.
      Confirm by: `grep -n 'notANumber' --include='*.swift' desktopAhaan/`
      Failure mode: Arithmetic on NaN propagates and renders nonsense in UI.
- [ ] 2.2.2 — `Date.distantPast`/`distantFuture` used only as sentinels, never formatted directly for display.
      Confirm by: `grep -nE 'distant(Past|Future)' --include='*.swift' desktopAhaan/`
      Failure mode: User sees "Jan 1, 1 AD" in a header.
- [ ] 2.2.3 — `Int.max` / `Int.min` never used as default for index-typed values.
      Confirm by: `grep -nE 'Int\.(max|min)' --include='*.swift' desktopAhaan/`
      Failure mode: Off-by-one arithmetic against the sentinel crashes or misorders.

---

## Category 3 — Crash classes — Obj-C / AppKit exception family

### 3.1 NSException kinds

- [ ] 3.1.1 — No NSArray/NSDictionary bridging that can raise `NSRangeException` (use Swift collections instead).
      Confirm by: `grep -nE 'NS(Array|Dictionary)\(' --include='*.swift' desktopAhaan/`
      Failure mode: Out-of-range on a bridged NSArray bypasses Swift's Optional safety net.
- [ ] 3.1.2 — `NSInvalidArgumentException` paths (e.g. registering nil notifications) absent.
      Confirm by: search for `addObserver(_:selector:name:object:)` with nil name on Obj-C bridges.
      Failure mode: Uncaught NSException terminates the process before the Swift error path fires.
- [ ] 3.1.3 — `EXC_BAD_ACCESS` regression locks in place — `Crash_BeyondThenDiscover` + `Crash1_TryDiscoverMode_Ch1` in `desktopAhaanUITests/`.
      Confirm by: `ls desktopAhaanUITests/` and check both files present.
      Failure mode: A future dismantle-order regression isn't caught until a kid hits it on the iMac.
- [ ] 3.1.4 — `objc_release` over-release sites (the C1/C2 lineage) all closed per `CRASH_LEDGER.md` — verify recently re-read.
      Confirm by: read CRASH_LEDGER C1 and C2 row statuses (both should be ✅ live-repro fix shipped).
      Failure mode: A reopening regression silently reintroduces the dismantle race.

### 3.2 Uncaught exception hook

- [ ] 3.2.1 — `NSSetUncaughtExceptionHandler` is installed before any UI runs.
      Confirm by: `grep -nE 'NSSetUncaughtExceptionHandler' --include='*.swift' desktopAhaan/`
      Failure mode: Crashes that originate in Obj-C land aren't logged to the crashlog at all.
- [ ] 3.2.2 — POSIX signal handlers cover SIGABRT, SIGSEGV, SIGBUS, SIGILL, SIGFPE, SIGPIPE.
      Confirm by: read `App/CrashReporter.swift` for `signal(SIGABRT, …)` etc.
      Failure mode: A SIGBUS on the iMac during teardown leaves the user without a usable crashlog.
- [ ] 3.2.3 — `applicationWillTerminate` writes a clean-quit marker so a missing marker on next launch implies a crash.
      Confirm by: read `App/CrashReporter.swift` for the marker logic and `desktopAhaanApp.swift` for the call.
      Failure mode: Cannot disambiguate clean quit from crash on next launch.

---

## Category 4 — Crash classes — SwiftUI runtime

### 4.1 ForEach identity

- [ ] 4.1.1 — Every `ForEach` over a model collection uses an explicit `id:` keypath, not the default Identifiable-by-index.
      Confirm by: `grep -nE 'ForEach\(' --include='*.swift' desktopAhaan/`
      Failure mode: Identity churn on update produces ghost views or duplicated rows; over-release on the discarded identity.
- [ ] 4.1.2 — No `ForEach(\.enumerated())` or tuple keypaths like `\.element.id` (regression class fixed in commit `2760eb8`).
      Confirm by: `grep -nE 'ForEach\(.*enumerated|\\\.element\.' --include='*.swift' desktopAhaan/`
      Failure mode: Compile error on Big Sur's Swift 5.5 (this is a hard incompatibility, ratchet test required).
- [ ] 4.1.3 — `id:` keypath always resolves to a stable, content-derived value (not array index, not UUID re-rolled per render).
      Confirm by: walk Discover scenes' ForEach and verify identifiers are stable.
      Failure mode: Animations restart on every re-render; selection state resets unexpectedly.

### 4.2 Body-side hazards

- [ ] 4.2.1 — No multi-line `.animation(_:value:)` declarations (`f108a05` + `ed478dd` regression ratchet).
      Confirm by: `python3 scripts/check_viewbuilder_limit.py` and the existing ratchet greps.
      Failure mode: Big Sur AnyView dispatcher mis-bridges, EXC_BAD_ACCESS on Try Discover Mode.
- [ ] 4.2.2 — No `GeometryReader` directly inside `ScrollView` or `LazyVStack` that's unbounded (recursion fix `793c4ed`).
      Confirm by: `grep -nE 'GeometryReader' --include='*.swift' desktopAhaan/Subjects/Tutor/Discover/`
      Failure mode: Layout recursion → CPU spin → frame-skip → eventual crash.
- [ ] 4.2.3 — No `@State` written from inside a view's `body` (only inside actions or `.onAppear`).
      Confirm by: visually scan view bodies for `self.<state> = ...` patterns.
      Failure mode: SwiftUI runtime warning "Modifying state during view update" → undefined behaviour.
- [ ] 4.2.4 — `@StateObject` is constructed exactly once per view instance (no `StateObject(wrappedValue:)` re-init paths).
      Confirm by: `grep -nE 'StateObject\(wrappedValue' --include='*.swift' desktopAhaan/`
      Failure mode: The object resets every render, losing in-flight state.
- [ ] 4.2.5 — `@FocusState` not bound inside a `NavigationView` content that re-creates on navigation.
      Confirm by: `grep -nE '@FocusState' --include='*.swift' desktopAhaan/`
      Failure mode: Focus traps or focus losses when navigating between detail pages.
- [ ] 4.2.6 — `body` computed properties stay under 80 lines per view; longer bodies are decomposed.
      Confirm by: per-file LOC + visual scan; target list in `DEEP_SCAN_RESULTS.md`.
      Failure mode: Swift 5.5 type-checker timeout on Big Sur.

### 4.3 ViewBuilder arity

- [ ] 4.3.1 — Every `@ViewBuilder` closure has ≤ 10 direct children (Group-wrap when over).
      Confirm by: `python3 scripts/check_viewbuilder_limit.py`
      Failure mode: Swift 5.5 buildBlock arity ceiling — compile error on Big Sur.
- [ ] 4.3.2 — `.modifier()` chains stay under 10 deep on one expression.
      Confirm by: visual scan; deep chains are correlated with type-checker timeouts.
      Failure mode: Build hits 60s timeout in Swift 5.5 typecheck phase.

### 4.4 Sheet & alert collisions

- [ ] 4.4.1 — Every view has exactly one `.sheet(item:)` or `.sheet(isPresented:)`, not multiple racing modifiers (collapsed in `21f3d11` + `8198bd8`).
      Confirm by: `grep -cE '\.sheet\(' desktopAhaan/Subjects/Tutor/ChapterDetailView.swift desktopAhaan/ContentView.swift`
      Failure mode: Sheet flicker, dismiss collisions, EXC_BAD_ACCESS during transition.
- [ ] 4.4.2 — `.alert` does not coexist with `.sheet` on the same content view without explicit ordering.
      Confirm by: grep `\.alert\(` and cross-reference with `\.sheet\(` per file.
      Failure mode: Sheet eats alert tap, or alert eats sheet — user can't dismiss either.
- [ ] 4.4.3 — `.confirmationDialog` not nested inside a sheet.
      Confirm by: grep + visual audit.
      Failure mode: Confirmation dialog dismissal collides with sheet dismount.

### 4.5 NavigationView lifecycle

- [ ] 4.5.1 — `NavigationView` uses `.navigationViewStyle(DoubleColumnNavigationViewStyle())` on macOS to lock the layout (per `ContentView.swift:61`).
      Confirm by: read ContentView.
      Failure mode: Sidebar disappears on width change.
- [ ] 4.5.2 — Navigation depth from sidebar selection is reset when sidebar selection changes.
      Confirm by: switch sidebar to a different subject, observe.
      Failure mode: Detail page lingers from old subject.

### 4.6 EnvironmentValue traps

- [ ] 4.6.1 — Custom `EnvironmentValue` keys (if any) have default values that don't crash.
      Confirm by: search `EnvironmentKey` conformances.
      Failure mode: Missing inject crashes on first read.

---

## Category 5 — Crash classes — concurrency

### 5.1 Main-actor discipline

- [ ] 5.1.1 — Every `@Published` is mutated only from the main actor.
      Confirm by: `grep -nE '@Published' --include='*.swift' desktopAhaan/` then trace each writer.
      Failure mode: SwiftUI runtime warning "Publishing changes from background threads" → undefined behaviour, sometimes EXC_BAD_ACCESS.
- [ ] 5.1.2 — `objectWillChange.send()` always happens on the main actor or inside `DispatchQueue.main.async`.
      Confirm by: `grep -n 'objectWillChange.send' --include='*.swift' desktopAhaan/`
      Failure mode: Same as 5.1.1.
- [ ] 5.1.3 — Every `Task { @MainActor in ... }` inside a view body is at most one level deep and gated by a condition (not unconditional in body).
      Confirm by: `grep -nE 'Task\s*\{\s*@MainActor' --include='*.swift' desktopAhaan/`
      Failure mode: Re-render creates a new Task on every body invocation; runaway concurrency.

### 5.2 Off-main work

- [ ] 5.2.1 — JSON decoding > 10KB happens off the main actor (currently `SubjectRegistry` uses `Task.detached`).
      Confirm by: read `Subjects/Loader/SubjectRegistry.swift` for the detached load path.
      Failure mode: Cold launch beachballs while content packs decode.
- [ ] 5.2.2 — `Data(contentsOf:)` on the main actor is limited to bytes-sized reads (e.g. schema-version stamp).
      Confirm by: `grep -nE 'Data\(contentsOf:' --include='*.swift' desktopAhaan/`
      Failure mode: UI freeze when a content file grows.
- [ ] 5.2.3 — `FileManager.default.contentsOfDirectory(at:)` always wrapped in `Task.detached` for non-trivial paths.
      Confirm by: grep for `contentsOfDirectory(`.
      Failure mode: UI freeze on a slow disk or a synced ~/Documents tree.

### 5.3 Sendable + actor isolation

- [ ] 5.3.1 — `@unchecked Sendable` is absent (LH003 lint enforces).
      Confirm by: `python3 scripts/check_lifetime_hazards.py`
      Failure mode: Hidden data race that surfaces as nondeterministic crashes weeks later.
- [ ] 5.3.2 — Every `class` shared across actors is either an `actor` or `@MainActor`-isolated.
      Confirm by: `grep -nE '^(final )?class' --include='*.swift' desktopAhaan/ | head -50` and audit each.
      Failure mode: Concurrent access to mutable state under TSan.
- [ ] 5.3.3 — No `DispatchSemaphore.wait()` on the main thread.
      Confirm by: `grep -nE 'DispatchSemaphore' --include='*.swift' desktopAhaan/`
      Failure mode: Deadlock; spinning wheel; killed by macOS hang reporter.
- [ ] 5.3.4 — No `DispatchQueue.main.sync` called from the main thread.
      Confirm by: `grep -nE 'DispatchQueue\.main\.sync' --include='*.swift' desktopAhaan/`
      Failure mode: Instant deadlock.

### 5.4 NSLock and atomics

- [ ] 5.4.1 — Every `NSLock` use is balanced in a `defer { unlock() }` block.
      Confirm by: `grep -nE 'NSLock\(\)' --include='*.swift' desktopAhaan/`
      Failure mode: Reentrant lock leaves the lock held forever; later acquisition deadlocks.
- [ ] 5.4.2 — `pthread_mutex_t` and other C primitives are absent.
      Confirm by: `grep -nE 'pthread_' --include='*.swift' desktopAhaan/`
      Failure mode: Manual locking with no `defer` is almost certainly broken.

---

## Category 6 — Crash classes — system framework

### 6.1 WKWebView (now retired)

- [ ] 6.1.1 — No `import WebKit` in `desktopAhaan/Subjects/Articles/` (structurally retired in `f4ec573`).
      Confirm by: `grep -rn 'import WebKit\|WKWebView' desktopAhaan/Subjects/Articles/`
      Failure mode: Re-introducing WKWebView brings back the AMD R9 M290X Metal shader cache C4 lineage.
- [ ] 6.1.2 — No `#available(macOS 12, *)` branch that would picks WKWebView over `NativeArticleRepresentable`.
      Confirm by: `grep -nE '#available\(macOS 12.*WKWebView' --include='*.swift' desktopAhaan/`
      Failure mode: Same as 6.1.1.

### 6.2 AVAudioEngine + Speech.framework

- [ ] 6.2.1 — `AVAudioEngine.start()` is in a `do { try } catch { showTemporaryError }` block (never `try!`).
      Confirm by: read `Services/Speech/SpeechRecognitionManager.swift` and `TextToSpeechManager.swift`.
      Failure mode: Mic-busy or audio-busy throw becomes a crash instead of a banner.
- [ ] 6.2.2 — `SFSpeechRecognizer.requestAuthorization` only inside `requestPermissions()` and only after the XCTest guard.
      Confirm by: `grep -nE 'requestAuthorization' --include='*.swift' desktopAhaan/`
      Failure mode: Speech prompt pops at app launch or mid-test instead of on first user tap.
- [ ] 6.2.3 — `AVSpeechSynthesizer.delegate` is set to a strongly-owned helper, not `self`, to avoid retain-cycle / dealloc-callback.
      Confirm by: read `TextToSpeechManager.swift:11` and the `TTSDelegate` glue.
      Failure mode: Delegate callback into freed manager → EXC_BAD_ACCESS.
- [ ] 6.2.4 — Audio session is deactivated on stop (`deactivateAudioSession()` called).
      Confirm by: read `stopListening()` and `deinit` in `SpeechRecognitionManager`.
      Failure mode: TTS doesn't play because session is still in `.record` mode.

### 6.3 NotificationCenter

- [ ] 6.3.1 — Every raw `addObserver(_:selector:name:object:)` has a matched `removeObserver` (or, ideally, uses `.onReceive` in SwiftUI).
      Confirm by: `grep -nE 'addObserver\(_' --include='*.swift' desktopAhaan/`
      Failure mode: Notification fires into a freed observer → EXC_BAD_ACCESS.
- [ ] 6.3.2 — SwiftUI views consume notifications via `.onReceive(NotificationCenter.default.publisher(for:))`, not raw observers.
      Confirm by: `grep -nE '\.onReceive\(.*NotificationCenter' --include='*.swift' desktopAhaan/`
      Failure mode: Lifecycle mismatch between view and observer.

### 6.4 NSWindow / NSHostingView

- [ ] 6.4.1 — Every secondary `NSWindow` has its `delegate = nil` set in `windowWillClose`.
      Confirm by: `grep -nE 'windowWillClose' --include='*.swift' desktopAhaan/` (now mostly N/A since article is a SwiftUI sheet, but confirm).
      Failure mode: Delegate callback into a freed manager → EXC_BAD_ACCESS.
- [ ] 6.4.2 — `NSHostingView`'s root view does not hold `@StateObject` instances shared across teardown.
      Confirm by: visual scan of any explicit `NSHostingView(rootView:)` site.
      Failure mode: SwiftUI commit pump runs against a freed StateObject.

---

## Category 7 — Memory — retain cycles

### 7.1 Closure-captures-self

- [ ] 7.1.1 — Every escaping closure stored on a class captures `self` weakly.
      Confirm by: `grep -nE '\{\s*$' --include='*.swift' desktopAhaan/` then audit each closure context.
      Failure mode: Class keeps itself alive past its owner; downstream work continues against stale state.
- [ ] 7.1.2 — Every `Task { ... }` in a class instance method captures `[weak self]` or runs to immediate completion.
      Confirm by: `grep -nE 'Task\s*\{' --include='*.swift' desktopAhaan/`
      Failure mode: Long-running Task keeps the owning class alive after the view disappears.
- [ ] 7.1.3 — Every Combine `.sink` and `.assign(to:)` closure captures `self` weakly.
      Confirm by: `grep -nE '\.sink\(' --include='*.swift' desktopAhaan/`
      Failure mode: ObservableObject lives forever holding the Publisher chain.
- [ ] 7.1.4 — Every `Timer.scheduledTimer(withTimeInterval:repeats:block:)` block captures `[weak self]`.
      Confirm by: `grep -nE 'Timer\.scheduledTimer' --include='*.swift' desktopAhaan/`
      Failure mode: Timer fires forever against a freed owner; CPU spin in background.
- [ ] 7.1.5 — `NotificationCenter` observers stored as `AnyCancellable` (not raw block-tokens) so the Cancellable's deinit removes the observer.
      Confirm by: `grep -nE 'addObserver\(forName' --include='*.swift' desktopAhaan/`
      Failure mode: Block stays registered after view disappears; fires into a freed scope.

### 7.2 Delegate cycles

- [ ] 7.2.1 — Every `var delegate:` on an `NSObject` subclass is `weak var delegate:` (LH001 lint enforces).
      Confirm by: `python3 scripts/check_lifetime_hazards.py`
      Failure mode: Owner ↔ delegate cycle; neither dies.
- [ ] 7.2.2 — `unowned` is absent (LH002 lint enforces). When justified, allowlisted with a proof in `scripts/lifetime_hazards_allowlist.txt`.
      Confirm by: `python3 scripts/check_lifetime_hazards.py`
      Failure mode: `unowned` reference is touched after the target deallocates → EXC_BAD_ACCESS.

### 7.3 StateObject / EnvironmentObject

- [ ] 7.3.1 — `@StateObject` is owned by exactly one view; downstream views use `@ObservedObject` or `@EnvironmentObject`.
      Confirm by: visually audit each `@StateObject` site.
      Failure mode: Two views construct the same StateObject independently; one of them never dies.
- [ ] 7.3.2 — `@EnvironmentObject` injection always has a `.environmentObject(...)` ancestor; runtime crash if missing.
      Confirm by: launch every screen and verify no "No ObservableObject of type … found" crash.
      Failure mode: Hard crash on first render of a screen that's missing its environment.
- [ ] 7.3.3 — `@EnvironmentObject` does not capture environment in a long-lived closure (it's snapshotted at init).
      Confirm by: visual audit of any `let env = ...` of EnvObject.
      Failure mode: Stale env reference, especially after sheet dismounts.

### 7.4 Combine pipelines

- [ ] 7.4.1 — `Publisher.assign(to: &$x)` (modern keyPath form) preferred over `.assign(to: \.x, on: self)` since the latter is a strong-self capture.
      Confirm by: `grep -nE '\.assign\(to:' --include='*.swift' desktopAhaan/`
      Failure mode: Strong-self retain cycle.
- [ ] 7.4.2 — Long-running pipelines have `.share()` or `.multicast` only when justified (otherwise duplicated work).
      Confirm by: search for `share()`.
      Failure mode: Double-subscription duplicated work.

---

## Category 8 — Memory — leaks

### 8.1 Unbounded singletons

- [ ] 8.1.1 — `appState.recentItems` capped at a documented limit (≤ 50).
      Confirm by: read `AppState.swift` for the recent-items cap logic.
      Failure mode: Recents grow unboundedly across months; sidebar slows down.
- [ ] 8.1.2 — Any `static var cache: [Key: Value]` has a documented bound and eviction policy, or is an `NSCache` with `countLimit`.
      Confirm by: `grep -nE 'static var .*:\s*\[' --include='*.swift' desktopAhaan/`
      Failure mode: Caches grow forever; resident memory grows; eventual jetsam on Big Sur.
- [ ] 8.1.3 — `SubjectRegistry.packs` is not mutated after `loadAll()`; reloads replace, never append.
      Confirm by: read `SubjectRegistry.swift` for `packs.append` patterns.
      Failure mode: Duplicate-pack accumulation over reloads.

### 8.2 NSCache / NSImage

- [ ] 8.2.1 — Every `NSCache` instance sets `countLimit` and/or `totalCostLimit`.
      Confirm by: `grep -nE 'NSCache' --include='*.swift' desktopAhaan/`
      Failure mode: Cache never evicts; resident memory grows.
- [ ] 8.2.2 — `NSImage(named:)` results cached, never re-decoded in tight ForEach loops.
      Confirm by: visual scan of ForEach bodies for Image construction patterns.
      Failure mode: Re-decoding the same PNG every render frame.

### 8.3 AVPlayer / engine teardown

- [ ] 8.3.1 — Every `AVAudioEngine` instance is `.stop()`-ed before the holder deallocates.
      Confirm by: read `deinit` / `stopListening()` for every AVAudioEngine holder.
      Failure mode: Engine stays running, holding mic resource and CPU.
- [ ] 8.3.2 — Every `AVPlayer` instance is paused and its `player.replaceCurrentItem(with: nil)` called before holder deallocates.
      Confirm by: `grep -nE 'AVPlayer' --include='*.swift' desktopAhaan/`
      Failure mode: Background audio continues; player retains its item indefinitely.

### 8.4 Cancellables

- [ ] 8.4.1 — Every Combine pipeline result is stored in a `Set<AnyCancellable>` owned by the consuming class.
      Confirm by: `grep -nE 'AnyCancellable' --include='*.swift' desktopAhaan/`
      Failure mode: Pipeline runs forever after the consumer dies.
- [ ] 8.4.2 — `cancellables.removeAll()` is called in `deinit` for explicit cleanup (or the set is `var` and goes out of scope cleanly).
      Confirm by: visual audit.
      Failure mode: Same as 8.4.1.

### 8.5 Image caches

- [ ] 8.5.1 — Any `NSImage(named:)` cached via `NSImage.imageNamed(...)` system cache, not duplicated.
      Confirm by: `grep -nE 'NSImage\(named:' --include='*.swift' desktopAhaan/`
      Failure mode: Same image decoded twice.

### 8.6 Resource bundle holds

- [ ] 8.6.1 — `Bundle.main.url(forResource:withExtension:)` results are not retained longer than needed.
      Confirm by: visual audit.
      Failure mode: Bundle URL retains a CFURL that pins inode.

### 8.7 Document leaks

- [ ] 8.7.1 — N/A — no NSDocument architecture. Document.
      Confirm by: search NSDocument.
      Failure mode: Not applicable.

---

## Category 9 — Memory — excess allocation

### 9.1 Hot-path allocation

- [ ] 9.1.1 — `JSONDecoder()` is not constructed per-render; one per class or static.
      Confirm by: `grep -nE 'JSONDecoder\(\)' --include='*.swift' desktopAhaan/`
      Failure mode: GC churn; jank on scroll where decoding happens implicitly.
- [ ] 9.1.2 — `DateFormatter` / `NumberFormatter` is reused, not constructed per render (these are expensive).
      Confirm by: `grep -nE '(Date|Number)Formatter\(\)' --include='*.swift' desktopAhaan/`
      Failure mode: Per-row construction → CPU spike in long ForEach.
- [ ] 9.1.3 — `Color(red:green:blue:)` is constant-cached (e.g. as a `static let` in a tokens enum), not re-built per body.
      Confirm by: `grep -nE 'Color\(red:' --include='*.swift' desktopAhaan/`
      Failure mode: Re-allocates a CGColor per render; GC churn.
- [ ] 9.1.4 — Bundled assets > 1 MB are loaded off-main and cached.
      Confirm by: audit `Resources/Articles/` and `Bundle.main.url(forResource:)` sites.
      Failure mode: UI freeze on first navigation to a media-heavy chapter.

### 9.2 String / regex

- [ ] 9.2.1 — Regex literals (`/.../`) or `NSRegularExpression` instances are static, not per-call.
      Confirm by: `grep -nE 'NSRegularExpression' --include='*.swift' desktopAhaan/`
      Failure mode: Regex compilation per-call → tail-latency spikes.
- [ ] 9.2.2 — String concatenation in tight loops uses `appendInterpolation` or `joined`, not `+=` in a `for`.
      Confirm by: visual audit of any string-build site.
      Failure mode: O(N²) allocation pattern.

### 9.3 Body allocation

- [ ] 9.3.1 — `Image(systemName:)` in tight `ForEach` is wrapped in a custom view to amortize the Bundle lookup cost.
      Confirm by: visual audit.
      Failure mode: Subtle frame hitching in long lists.

---

## Category 10 — Memory — lifecycle hygiene

### 10.1 deinit safety

- [ ] 10.1.1 — Every `deinit` is non-throwing and does not call `@MainActor` methods without a `Task { @MainActor in ... }` hop.
      Confirm by: `grep -nE 'deinit' --include='*.swift' desktopAhaan/`
      Failure mode: Crash during deinit because we accessed main-actor state from a non-main deinit caller.
- [ ] 10.1.2 — `deinit` cancels any owned `Task` and removes any owned Combine `AnyCancellable`.
      Confirm by: visual audit per deinit.
      Failure mode: Task fires after deinit; sink fires after deinit.

### 10.2 .onDisappear

- [ ] 10.2.1 — Every view that owns a long-running resource (speech, file watcher, timer, animation) calls a `cleanup()` from `.onDisappear`.
      Confirm by: read each `ArticleBrowserView`, `TranslatorScreen`, `Discover*` for `.onDisappear` blocks.
      Failure mode: Audio continues after navigation away.
- [ ] 10.2.2 — `.onDisappear` does not assume `@State` is still mutable (SwiftUI may have already torn down).
      Confirm by: visual audit.
      Failure mode: Runtime warning, sometimes silent.

### 10.3 Scene-phase backgrounding

- [ ] 10.3.1 — `@Environment(\.scenePhase)` transitions to `.background` pause animations and TTS.
      Confirm by: `grep -nE 'scenePhase' --include='*.swift' desktopAhaan/`
      Failure mode: Hidden window keeps drawing at 60 fps and burns battery.
- [ ] 10.3.2 — Window-backgrounded state suspends timers and `Task.sleep` loops.
      Confirm by: visual audit.
      Failure mode: Same as 10.3.1.

---

## Category 11 — Main thread — I/O on main

### 11.1 File reads

- [ ] 11.1.1 — `Data(contentsOf:)` on the main actor is limited to bytes-sized files (e.g. `schema_version`) — see `DataStore.swift:283`.
      Confirm by: `grep -nE 'Data\(contentsOf:' --include='*.swift' desktopAhaan/`
      Failure mode: Beachball on cold launch.
- [ ] 11.1.2 — Article HTML reads occur on-demand inside the view's load helper, not eagerly at construction.
      Confirm by: read `ArticleCoordinator.load(fileURL:)` for the load path.
      Failure mode: All articles preloaded eagerly → giant RSS.
- [ ] 11.1.3 — `FileManager.default.contentsOfDirectory(at:)` for `~/Library/Application Support` enumeration is off-main when called at launch.
      Confirm by: grep + read each site.
      Failure mode: Slow cold launch if the directory has accumulated many crashlogs.

### 11.2 File writes

- [ ] 11.2.1 — Every persisted-state write uses `options: .atomic` (CLAUDE.md invariant).
      Confirm by: `grep -nE '\.write\(to:' --include='*.swift' desktopAhaan/`
      Failure mode: Partial-write corruption on power loss / OS crash.
- [ ] 11.2.2 — Writes large enough to feel are debounced/coalesced (see `DataStore`'s coalescing pattern).
      Confirm by: read `DataStore.swift` debounce logic.
      Failure mode: One save per keystroke → I/O storm.

### 11.3 Process / Pipe / Shell

- [ ] 11.3.1 — `Process()` is not used in production paths (no shelling out from the app).
      Confirm by: `grep -nE 'Process\(\)' --include='*.swift' desktopAhaan/`
      Failure mode: Sandbox violation; shell injection; UI freeze.

### 11.4 Plist reads

- [ ] 11.4.1 — Reading from Info.plist uses `Bundle.main.object(forInfoDictionaryKey:)`, not direct file I/O.
      Confirm by: `grep -nE 'object\(forInfoDictionaryKey' --include='*.swift' desktopAhaan/`
      Failure mode: Sandbox path race.

### 11.5 UserDefaults

- [ ] 11.5.1 — UserDefaults reads/writes only via `@AppStorage` or `UserDefaults.standard` on the main actor.
      Confirm by: `grep -nE 'UserDefaults' --include='*.swift' desktopAhaan/`
      Failure mode: Background-thread UserDefaults access races with main.

---

## Category 12 — Main thread — compute on main

### 12.1 Sort / filter in body

- [ ] 12.1.1 — `body` does not call `.sorted(by:)` or `.filter` on a non-trivial collection; pre-compute in the model.
      Confirm by: visual scan of view bodies.
      Failure mode: O(N log N) per render; jank on update.
- [ ] 12.1.2 — `.first(where:)` on large arrays in `body` is replaced by indexed lookup or a dictionary.
      Confirm by: `grep -nE '\.first\(where' --include='*.swift' desktopAhaan/`
      Failure mode: O(N) per row in a Wee ForEach → visible scroll judder.

### 12.2 Per-render regex / format

- [ ] 12.2.1 — Regex compilation does not happen inside `body`.
      Confirm by: grep for `NSRegularExpression` use inside SwiftUI files.
      Failure mode: 10+ ms per body invocation just to compile the regex.
- [ ] 12.2.2 — Date / number formatting cached or wrapped in `static let` formatters.
      Confirm by: visual audit.
      Failure mode: Per-row formatting at 16ms budget on Big Sur — judder.

### 12.3 Body chain depth

- [ ] 12.3.1 — No `body` has > 5 nested ViewBuilder containers without decomposition.
      Confirm by: visual audit (Big Sur Swift 5.5 type-checker risk).
      Failure mode: Type-checker timeout; build break.

---

## Category 13 — Main thread — sleep/wait

### 13.1 Direct blocking

- [ ] 13.1.1 — `Thread.sleep(forTimeInterval:)` is absent in app code.
      Confirm by: `grep -n 'Thread.sleep' --include='*.swift' desktopAhaan/`
      Failure mode: UI blocks; macOS kills the process for hang.
- [ ] 13.1.2 — `RunLoop.run(until:)` is absent.
      Confirm by: `grep -n 'RunLoop.run' --include='*.swift' desktopAhaan/`
      Failure mode: Reentrant runloop; obscure crashes.
- [ ] 13.1.3 — `DispatchSemaphore` is absent in main-thread contexts.
      Confirm by: `grep -n 'DispatchSemaphore' --include='*.swift' desktopAhaan/`
      Failure mode: Deadlock when the signal source needs the main thread.

### 13.2 Task.sleep usage

- [ ] 13.2.1 — `Task.sleep(nanoseconds:)` is only used inside `Task { ... }` blocks, never inline-awaited on `@MainActor`.
      Confirm by: `grep -nE 'Task\.sleep' --include='*.swift' desktopAhaan/`
      Failure mode: UI freeze if the sleep accidentally lands on the main actor.
- [ ] 13.2.2 — Task.sleep durations are explicit and documented when > 5 seconds.
      Confirm by: visual audit.
      Failure mode: Mystery 30s wait; user thinks the app is hung.

---

## Category 14 — Animation & frame-rate

### 14.1 SwiftUI animation correctness

- [ ] 14.1.1 — No multi-line `.animation(_:value:)` (Swift 5.5 / Big Sur incompatibility).
      Confirm by: ratchet lint — see also category 4.2.1.
      Failure mode: EXC_BAD_ACCESS on Try Discover Mode on Ch.1.
- [ ] 14.1.2 — `withAnimation(...) { ... }` does not encompass a large subtree (≤ 20 children).
      Confirm by: visual audit.
      Failure mode: Whole-subtree relayout per animation frame.
- [ ] 14.1.3 — `.transition` does not combine `.opacity` and `.scale` and `.move` simultaneously — collapsed to ≤ 2 in `8cfb6e7`.
      Confirm by: `grep -nE '\.combined\(with:' --include='*.swift' desktopAhaan/`
      Failure mode: Frame-skip; SIGSEGV on legacy GPU.

### 14.2 Frame budget

- [ ] 14.2.1 — Particle / Canvas emitters cap at 20 fps on `HardwareTier.isLegacy`.
      Confirm by: read `desktopAhaan/Subjects/Tutor/Discover/Components/HardwareTier.swift` and emitters.
      Failure mode: 60 fps animation on AMD R9 M290X → frame skips → thermal throttle.
- [ ] 14.2.2 — `Timer.scheduledTimer` driving SwiftUI state runs at ≤ 30 Hz unless explicitly gated by HardwareTier.
      Confirm by: `grep -nE 'Timer\.scheduledTimer' --include='*.swift' desktopAhaan/`
      Failure mode: Battery drain + thermal throttle on iMac.

### 14.3 Reduce-Motion

- [ ] 14.3.1 — Every `.animation` site routes through `respectReduceMotion(animation:)` from commit `36ad98b`.
      Confirm by: `grep -nE '\.animation\(' --include='*.swift' desktopAhaan/` and verify each goes through the helper.
      Failure mode: Animations still play with Reduce Motion ON → fails Accessibility audit.

---

## Category 15 — Cold launch

### 15.1 App.init heavy work

- [ ] 15.1.1 — `desktopAhaanApp.init()` does no I/O beyond `CrashReporter.shared.install()`.
      Confirm by: read `desktopAhaan/desktopAhaanApp.swift` top.
      Failure mode: Beachball before the welcome sheet renders.
- [ ] 15.1.2 — No `@StateObject` initializer enumerates the bundle or decodes packs synchronously.
      Confirm by: read each `@StateObject` init site.
      Failure mode: Welcome sheet appears late; window opens blank.

### 15.2 Permission prompts

- [ ] 15.2.1 — No permission prompt fires at launch — Speech is deferred to first dictation tap (per `a296077`).
      Confirm by: launch from a fresh state; observe no TCC dialog.
      Failure mode: Kid is greeted by a Speech permission dialog they don't understand.

### 15.3 Pre-warm / cache

- [ ] 15.3.1 — Metal cache directory is created before first GPU use (`ensureMetalCacheDirectory()` in AppDelegate).
      Confirm by: read `desktopAhaanApp.swift` AppDelegate's `applicationWillFinishLaunching`.
      Failure mode: First Canvas render takes 800ms to compile shaders.
- [ ] 15.3.2 — Asset catalog is the only image source for app-icon variants — no per-render Bundle lookups.
      Confirm by: `grep -nE 'NSImage\(named:' --include='*.swift' desktopAhaan/`
      Failure mode: Icon flicker at launch.

---

## Category 16 — Rendering performance

### 16.1 ScrollView nesting

- [ ] 16.1.1 — No `ScrollView` is nested inside another `ScrollView` (gesture conflict + perf).
      Confirm by: visual scan of Discover scenes.
      Failure mode: Inner scroll doesn't respond, or both scroll simultaneously.
- [ ] 16.1.2 — `LazyVStack` / `LazyVGrid` is the default for any > 30-item list (not `VStack`).
      Confirm by: visual audit.
      Failure mode: O(N) memory at first render; slow scroll.

### 16.2 Canvas overhead

- [ ] 16.2.1 — Every `Canvas` view sets `.drawingGroup()` when its child count > 100.
      Confirm by: `grep -nE 'Canvas\(' --include='*.swift' desktopAhaan/`
      Failure mode: 60 fps scroll drops to 20 fps on legacy GPU.

### 16.3 View-identity churn

- [ ] 16.3.1 — `ForEach` items have stable identities (covered in 4.1.1, 4.1.3).
      Confirm by: see 4.1.
      Failure mode: Animations restart on every parent re-render.

### 16.4 Scrolling 60/120 Hz

- [ ] 16.4.1 — Boss Quiz timer + Discover scene scroll at 60fps stable on Apple Silicon; ≥ 30fps on iMac.
      Confirm by: Instruments → Time Profiler under each surface.
      Failure mode: Visible judder; kid notices.
- [ ] 16.4.2 — `List` (not `LazyVStack inside ScrollView`) used for chapter/question lists, so AppKit can reuse rows.
      Confirm by: `grep -nE 'List\(|LazyVStack' --include='*.swift' desktopAhaan/`
      Failure mode: Memory grows linearly with scrolled-past rows.

### 16.5 Redraw thrash

- [ ] 16.5.1 — No view does work in `.onChange(of:)` that itself triggers a state update on the watched value (loop).
      Confirm by: `grep -nE '\.onChange\(of:' --include='*.swift' desktopAhaan/`
      Failure mode: Infinite re-render loop.
- [ ] 16.5.2 — `@AppStorage` writes outside user-initiated actions are minimized (each write triggers a redraw).
      Confirm by: visual audit.
      Failure mode: Subtle CPU spike during animation.

### 16.6 Offscreen rendering

- [ ] 16.6.1 — `.drawingGroup()` set on Canvas heavy scenes (offloads to Metal).
      Confirm by: `grep -nE '\.drawingGroup' --include='*.swift' desktopAhaan/`
      Failure mode: Software compositor slow path.

---

## Category 17 — Loaders & loading states

### 17.1 Tri-state UI

- [ ] 17.1.1 — Every async surface has explicit `.loading / .loaded / .empty / .error` branches in the view code.
      Confirm by: visual scan of any view that consumes async data.
      Failure mode: Spinner-forever or blank screen.
- [ ] 17.1.2 — Loading spinners default to text-explained (`"Loading subjects…"`), not just a circle.
      Confirm by: visual audit of all `ProgressView` sites.
      Failure mode: Kid stares at a spinner with no context.

### 17.2 Cancel & retry

- [ ] 17.2.1 — Any user-initiated async action has a "Cancel" affordance after 3 seconds.
      Confirm by: visual audit of dictation, OCR, translate.
      Failure mode: Stuck spinner with no escape.
- [ ] 17.2.2 — Error states offer a "Retry" or "Open in Safari" recovery.
      Confirm by: read `PlainTextArticleFallback` for the Safari recovery affordance.
      Failure mode: Dead-end error state; restart-app is the only fix.

### 17.3 Spinner-forever protection

- [ ] 17.3.1 — Every spinner has a watchdog timeout (e.g. 30s for Dictation auto-stop in `SpeechRecognitionManager`).
      Confirm by: read each long-running async helper.
      Failure mode: Mic stays on, battery drains, user has to force-quit.
- [ ] 17.3.2 — Network calls (FreeOnlineTranslationProvider) cap at a documented timeout (e.g. 15s).
      Confirm by: read `URLRequest.timeoutInterval` in the provider.
      Failure mode: User stares at a spinner on a captive-portal network.
- [ ] 17.3.3 — File reads in async paths cap via `Task.checkCancellation()` checkpoints.
      Confirm by: visual audit.
      Failure mode: No way to cancel a slow read.

### 17.4 Skeleton vs spinner

- [ ] 17.4.1 — Chapter list uses skeleton rows (greyed placeholders), not a single centered spinner.
      Confirm by: visual audit during first-launch.
      Failure mode: Layout shift when content appears.
- [ ] 17.4.2 — Article body shows "Loading…" inline at expected location, not a different container.
      Confirm by: read `ArticleCoordinator.nativeArticle` default text.
      Failure mode: Article area collapses then reopens.

### 17.5 Optimistic UI rollback

- [ ] 17.5.1 — Optimistic state updates (e.g. marking a question correct) roll back cleanly if the persist fails.
      Confirm by: walk through markCorrect flow + simulate write failure.
      Failure mode: UI shows correct, disk says wrong, kid loses progress.

---

## Category 18 — Empty & error states

### 18.1 Zero-item

- [ ] 18.1.1 — Empty sidebar after fresh install renders an "Add subjects" or "No subjects loaded" message, not a blank pane.
      Confirm by: read sidebar `if subjectRegistry.packs.isEmpty` branch in `ContentView.swift`.
      Failure mode: Blank pane confuses the user.
- [ ] 18.1.2 — Empty recents list shows "Recently opened items will appear here" instead of an empty section.
      Confirm by: read recents rendering in `ContentView.swift`.
      Failure mode: Visible-but-empty section feels broken.

### 18.2 Malformed data

- [ ] 18.2.1 — Any pack that fails `SubjectPack.validateRelatedRefs()` logs DATA entries to crashlog and skips the broken refs, doesn't crash.
      Confirm by: read `SubjectPack.swift`.
      Failure mode: Orphan reference traps the app instead of logging.
- [ ] 18.2.2 — Any pack with duplicate IDs logs DATA via `CrashReporter.logDataIssue`, doesn't trap.
      Confirm by: read pack-load path for duplicate detection.
      Failure mode: SIGABRT on duplicate-key dictionary construction.

### 18.3 Disk full / permission denied

- [ ] 18.3.1 — Atomic write failures surface a "Couldn't save your progress" banner that auto-dismisses.
      Confirm by: visual audit of `DataStore` writers.
      Failure mode: Silent data loss.
- [ ] 18.3.2 — `~/Library/Application Support/desktopAhaan/` creation failures show a clear error in the welcome flow.
      Confirm by: `grep -nE 'createDirectory' --include='*.swift' desktopAhaan/`
      Failure mode: App boots into a broken state with no explanation.

---

## Category 19 — Edge-case data sizes

### 19.1 Large persisted state

- [ ] 19.1.1 — A 10000-row `progress.json` loads in < 2 seconds at cold launch.
      Confirm by: write a fixture and time the launch.
      Failure mode: Beachball on launch; jetsam kill on iMac.
- [ ] 19.1.2 — Pack JSON > 1 MB decodes off the main actor (`Task.detached` route).
      Confirm by: read `SubjectRegistry.loadAll()`.
      Failure mode: UI freeze on first navigation.

### 19.2 Long-string inputs

- [ ] 19.2.1 — Translator input field caps at 10 000 characters with a soft warning at 9 000.
      Confirm by: read input view for `.frame` and length-check.
      Failure mode: Paste of a 1 MB string hangs the recognizer.

### 19.3 Deep navigation

- [ ] 19.3.1 — Chapter → topic → concept → variation navigation depth supported without back-stack truncation.
      Confirm by: manual walk.
      Failure mode: Back stack loses earlier levels.

### 19.4 Single-item collection

- [ ] 19.4.1 — A list with one item renders without "n/a" placeholder or "empty after the first" misrendering.
      Confirm by: create a test fixture with one chapter.
      Failure mode: Single-item list looks empty.

### 19.5 Zero-byte files

- [ ] 19.5.1 — Opening a 0-byte article HTML shows the "Article could not be rendered" message, not a blank pane.
      Confirm by: read `ArticleCoordinator.loadNativeArticle` error branch.
      Failure mode: Blank pane confuses kid.

### 19.6 Very long strings

- [ ] 19.6.1 — A 100K-character translation input doesn't freeze the dictation start.
      Confirm by: paste large text + dictate.
      Failure mode: UI freeze on dictation start.

---

## Category 20 — Navigation — sheets & modals

### 20.1 Single-sheet invariant

- [ ] 20.1.1 — `ChapterDetailView` has exactly one `.sheet(item: SheetKind)` (collapsed in `21f3d11`).
      Confirm by: `grep -nE '\.sheet\(' desktopAhaan/Subjects/Tutor/ChapterDetailView.swift | wc -l`
      Failure mode: Racing sheet modifiers cause C2 dismount + nav-push collision.
- [ ] 20.1.2 — `ContentView` has exactly one `.sheet(item:)` for top-level modal flow (collapsed in `8198bd8`).
      Confirm by: `grep -cE '\.sheet\(' desktopAhaan/ContentView.swift`
      Failure mode: Same as 20.1.1.

### 20.2 Dismiss affordance

- [ ] 20.2.1 — Every sheet has at least one of: a Close button, Esc key shortcut, or a tap-outside dismiss.
      Confirm by: manual walk of every sheet.
      Failure mode: Kid can't escape the sheet; force-quits.
- [ ] 20.2.2 — `⌘W` dismisses any open article sheet (matches `Crash_BeyondThenDiscover`'s `.command + w` repro).
      Confirm by: read `ArticleBrowserView` close button's `.keyboardShortcut`.
      Failure mode: Test repro can't drive ⌘W because the binding is missing.

### 20.3 Mid-transition safety

- [ ] 20.3.1 — Tapping a CTA while a sheet is dismissing does not crash (the C2 lineage); every CTA defers its mutation via `DispatchQueue.main.async`.
      Confirm by: read `ChapterDetailView` CTA handlers — they should all be in `DispatchQueue.main.async` blocks per `dfdbbb4`.
      Failure mode: Sheet-dismount commit collides with parent-render commit → EXC_BAD_ACCESS.

---

## Category 21 — Navigation — push/pop & back stack

### 21.1 NavigationLink

- [ ] 21.1.1 — `NavigationLink(isActive:)` race patterns are absent (zero matches in current code).
      Confirm by: `grep -nE 'NavigationLink\(isActive:' --include='*.swift' desktopAhaan/`
      Failure mode: State + binding fight; nav pops unexpectedly.
- [ ] 21.1.2 — Programmatic push uses a path/state-driven approach (see `nav.push(...)` patterns).
      Confirm by: read `Subjects/Tutor/` for the `nav.` namespace.
      Failure mode: Two simultaneous pushes collide.

### 21.2 Back navigation

- [ ] 21.2.1 — Every leaf detail page (Discover scene, article, question) has a working "back" affordance.
      Confirm by: manual walk to each leaf and press back.
      Failure mode: Back disabled; user trapped.

### 21.3 Deep link landing

- [ ] 21.3.1 — N/A for this app (no registered URL schemes). Document explicitly.
      Confirm by: `grep -nE 'CFBundleURLSchemes' desktopAhaan/Info.plist`
      Failure mode: Deep-link handler missing where one is needed.

---

## Category 22 — Navigation — sidebar / split view

### 22.1 Selection restoration

- [ ] 22.1.1 — Sidebar selection persists across launches via `@AppStorage(AppStorageKeys.sidebarSelection)` (or equivalent).
      Confirm by: read `ContentView.swift` for sidebar selection persistence.
      Failure mode: Kid lands on the wrong tab every morning.
- [ ] 22.1.2 — Default selection on first launch is deterministic (`.subject("sanskrit_class7")` per `ContentView.swift:229`).
      Confirm by: read `ContentView.swift:225-232`.
      Failure mode: Sidebar selects nothing on cold launch.

### 22.2 Narrow-window collapse

- [ ] 22.2.1 — Minimum window width keeps the sidebar visible at its declared `idealWidth = 260` (see `ContentView.swift:317`).
      Confirm by: resize the window to 800px and observe the sidebar.
      Failure mode: Sidebar disappears off-screen; user can't navigate.

### 22.3 Sidebar tap during loading

- [ ] 22.3.1 — Tapping a sidebar row while packs are loading shows "Loading subjects…" instead of crashing.
      Confirm by: read `if subjectRegistry.isLoading` branch in `ContentView.swift`.
      Failure mode: Tap fires into nil pack reference.

---

## Category 23 — Layout — constraints

### 23.1 Min-window edge cases

- [ ] 23.1.1 — At minimum window size (760×500 or similar), no view clips its primary CTA.
      Confirm by: manual resize.
      Failure mode: "Try Discover Mode" button cut off.

### 23.2 Dynamic Type

- [ ] 23.2.1 — `.font(.body)` and `.font(.headline)` are used (Dynamic Type aware), not `.font(.system(size:))` for body copy.
      Confirm by: `grep -nE '\.font\(\.system\(size:' --include='*.swift' desktopAhaan/`
      Failure mode: Body text doesn't scale with system size preference.

### 23.3 Frame chains

- [ ] 23.3.1 — `.frame(minWidth:idealWidth:maxWidth:)` chains do not have `min > ideal` or `ideal > max`.
      Confirm by: `grep -nE '\.frame\(min' --include='*.swift' desktopAhaan/`
      Failure mode: SwiftUI runtime warning; unpredictable layout.
- [ ] 23.3.2 — `.aspectRatio(contentMode:)` does not coexist with `.fixedSize()` on the same view.
      Confirm by: visual audit.
      Failure mode: Aspect-ratio breaks under fixed size.
- [ ] 23.3.3 — `.frame(maxWidth: .infinity)` is matched with a containing parent that bounds it.
      Confirm by: visual audit ScrollView contents.
      Failure mode: Infinite frame inside non-bounded parent → SwiftUI warning.

### 23.4 Negative spacing

- [ ] 23.4.1 — No `Spacer(minLength: -X)` patterns; negative spacing only via `.offset` with documented reason.
      Confirm by: `grep -nE 'Spacer\(minLength' --include='*.swift' desktopAhaan/`
      Failure mode: Layout fights.

### 23.5 Dynamic Type overflow

- [ ] 23.5.1 — Long-text views use `.lineLimit(nil)` + `.fixedSize(horizontal: false, vertical: true)` to expand vertically rather than truncate.
      Confirm by: `grep -nE 'lineLimit' --include='*.swift' desktopAhaan/`
      Failure mode: Text truncates at AX5; user can't read.

---

## Category 24 — Layout — multi-display & resolution

### 24.1 5K iMac

- [ ] 24.1.1 — App renders correctly at 5120×2880 native resolution on the deploy iMac.
      Confirm by: launch on the iMac and verify.
      Failure mode: Sub-pixel rounding; blurry text.

### 24.2 4K / 1440p

- [ ] 24.2.1 — Window opens at a sensible default that fits on 1440p screens (≤ 1280×800 default).
      Confirm by: read default window size in `desktopAhaanApp.swift` or `ContentView.swift`.
      Failure mode: Window opens larger than the screen.

### 24.3 Display reconfiguration

- [ ] 24.3.1 — Plugging/unplugging a second display mid-session doesn't crash or freeze.
      Confirm by: manual test.
      Failure mode: NSWindow can't relocate; black screen.

### 24.4 Retina vs non-retina

- [ ] 24.4.1 — Custom-rendered images render at the screen's `backingScaleFactor`.
      Confirm by: visual on retina vs non-retina display.
      Failure mode: Blurry images on non-retina.

### 24.5 Multi-display

- [ ] 24.5.1 — When the window is on a secondary display, sheets appear on the same display.
      Confirm by: move main window to second display, open Beyond sheet.
      Failure mode: Sheet appears on primary display.

### 24.6 Resolution change mid-session

- [ ] 24.6.1 — System resolution change while app is running doesn't break layout.
      Confirm by: manual test.
      Failure mode: Layout stuck at old size.

---

## Category 25 — UI/UX — interaction

### 25.1 Tap targets

- [ ] 25.1.1 — Every tappable surface has ≥ 44pt × 44pt hitbox (or its macOS-equivalent for mouse: ≥ 28pt).
      Confirm by: visual audit + manual scroll-pad selection.
      Failure mode: Kid mis-clicks on adjacent control.
- [ ] 25.1.2 — `.buttonStyle(...)` is set on every Button so disabled state is visually distinct.
      Confirm by: visual audit.
      Failure mode: Disabled buttons look enabled.

### 25.2 Hover & focus

- [ ] 25.2.1 — Every clickable surface has `.onHover` styling or relies on the system button style for hover affordance.
      Confirm by: visual audit.
      Failure mode: Hover does nothing — feels dead.
- [ ] 25.2.2 — Every focusable surface shows a focus ring under keyboard navigation.
      Confirm by: Tab through every view.
      Failure mode: Keyboard user can't see where focus is.

### 25.3 Destructive confirmation

- [ ] 25.3.1 — "Clear progress" / "Reset to defaults" surfaces require an explicit confirmation alert.
      Confirm by: search for `Reset` / `Clear` action handlers.
      Failure mode: One-click data loss.
- [ ] 25.3.2 — "Reset" buttons styled with `.destructive` role.
      Confirm by: visual audit.
      Failure mode: User taps "Reset" thinking it's safe.

### 25.4 Undo / redo

- [ ] 25.4.1 — Translator and notebook text fields support `⌘Z` for undo.
      Confirm by: keyboard test.
      Failure mode: Accidental delete with no recovery.

### 25.5 Loading-during-tap

- [ ] 25.5.1 — Buttons that trigger async work disable themselves until the work completes (no double-fire).
      Confirm by: rapid double-tap test on dictation/translate.
      Failure mode: Two simultaneous requests.

### 25.6 Touch feedback

- [ ] 25.6.1 — Pressed state visible on click (button highlight, scale, or animation).
      Confirm by: visual audit.
      Failure mode: Click feels dead.

---

## Category 26 — UI/UX — visual polish

### 26.1 Consistency

- [ ] 26.1.1 — Padding scale uses tokens (e.g. 4/8/12/16/24) rather than arbitrary values.
      Confirm by: `grep -nE '\.padding\(\d+(\.\d+)?\)' --include='*.swift' desktopAhaan/`
      Failure mode: Misaligned grids; unprofessional feel.
- [ ] 26.1.2 — Corner radii are consistent (typically 6/8/12); no rogue 5pt or 13pt.
      Confirm by: `grep -nE 'cornerRadius:' --include='*.swift' desktopAhaan/`
      Failure mode: Inconsistent surfaces.

### 26.2 Shadows

- [ ] 26.2.1 — Shadow `.shadow(color:radius:x:y:)` uses a consistent set of presets.
      Confirm by: `grep -nE '\.shadow\(' --include='*.swift' desktopAhaan/`
      Failure mode: Random shadows that don't compose visually.

### 26.3 Semantic colors

- [ ] 26.3.1 — All colors come from `Color.compat*` polyfills or `DesignTokens.BrandColor.*`, never raw hex.
      Confirm by: `python3 scripts/check_color_literals.py`
      Failure mode: Light/Dark transitions break; brand drift.

---

## Category 27 — Accessibility — labels & traits

### 27.1 Labels

- [ ] 27.1.1 — Every Button has a label inside or an `.accessibilityLabel(...)` modifier.
      Confirm by: visual audit; XCUITest queries can spot the misses.
      Failure mode: VoiceOver reads "Button".
- [ ] 27.1.2 — Every Image used as a control has `.accessibilityLabel`. Decorative images carry `.accessibilityHidden(true)`.
      Confirm by: `grep -nE 'Image\(systemName:|Image\(' --include='*.swift' desktopAhaan/`
      Failure mode: VoiceOver reads SF Symbol identifier or "Image".

### 27.2 Traits

- [ ] 27.2.1 — Non-button tappable surfaces use `.accessibilityAddTraits(.isButton)`.
      Confirm by: visual audit.
      Failure mode: VoiceOver doesn't announce as activatable.

### 27.3 Hints

- [ ] 27.3.1 — Novel widgets (Discover scene controls) have `.accessibilityHint(...)` explaining what they do.
      Confirm by: visual audit of Discover scenes.
      Failure mode: VoiceOver user doesn't know what the gesture does.
- [ ] 27.3.2 — Hints are sentence-cased, end in a period.
      Confirm by: visual audit of `.accessibilityHint("...")` strings.
      Failure mode: Inconsistent VoiceOver speech rhythm.

### 27.4 Values

- [ ] 27.4.1 — Stateful controls (toggle, slider) expose state via `.accessibilityValue(...)`.
      Confirm by: `grep -nE 'accessibilityValue' --include='*.swift' desktopAhaan/`
      Failure mode: VoiceOver doesn't announce slider position.

### 27.5 Grouping

- [ ] 27.5.1 — Card content (icon + title + caption) combined via `.accessibilityElement(children: .combine)` so VoiceOver reads as one phrase.
      Confirm by: `grep -nE 'accessibilityElement\(children: \.combine\)' --include='*.swift' desktopAhaan/`
      Failure mode: VoiceOver reads icon, title, caption separately.

---

## Category 28 — Accessibility — contrast & legibility

### 28.1 WCAG ratios

- [ ] 28.1.1 — `scripts/check_wcag_contrast.py` passes for every BrandColor pair (≥ 4.5:1 body, ≥ 3:1 large).
      Confirm by: `python3 scripts/check_wcag_contrast.py`
      Failure mode: Low-contrast text — fails AA.

### 28.2 Dynamic Type sizes

- [ ] 28.2.1 — At Dynamic Type "Larger" through "AX5", primary navigation and CTAs remain reachable without clipping.
      Confirm by: Settings → Display → Text Size, drag to maximum, walk app.
      Failure mode: Buttons disappear; text clips.

### 28.3 Increase Contrast

- [ ] 28.3.1 — With System Settings → Accessibility → Display → Increase Contrast ON, borders are visible on every card.
      Confirm by: toggle setting and walk app.
      Failure mode: Cards lose their boundaries; feels broken.

---

## Category 29 — Accessibility — motion & transparency

### 29.1 Reduce Motion

- [ ] 29.1.1 — `respectReduceMotion(animation:)` from `36ad98b` wraps every entrance/exit animation.
      Confirm by: grep `respectReduceMotion`.
      Failure mode: Big animations still play with Reduce Motion ON.

### 29.2 Reduce Transparency

- [ ] 29.2.1 — `.background(.ultraThinMaterial)` etc. honor Reduce Transparency.
      Confirm by: search for `material:` and `.ultraThinMaterial`.
      Failure mode: Translucent backgrounds remain when user requested opaque.

### 29.3 Auto-play media

- [ ] 29.3.1 — No video / audio auto-plays without explicit user action.
      Confirm by: `grep -nE 'AVPlayer|player.play\(\)' --include='*.swift' desktopAhaan/`
      Failure mode: Audio surprises a child in a quiet classroom.

---

## Category 30 — Accessibility — VoiceOver & focus

### 30.1 Reading order

- [ ] 30.1.1 — VoiceOver rotor lists every sidebar item, every CTA, every chapter row, in visual order.
      Confirm by: enable VoiceOver, navigate by rotor.
      Failure mode: Rotor lists items out of order; user gets lost.

### 30.2 Keyboard reachability

- [ ] 30.2.1 — Tab traversal reaches every interactive surface; no trap.
      Confirm by: Tab through each screen.
      Failure mode: Focus locked on one card; can't proceed.

### 30.3 Focus loss

- [ ] 30.3.1 — Closing a sheet returns focus to the originating control, not to nothing.
      Confirm by: ⌘W after Beyond-the-Book and observe focus.
      Failure mode: Focus disappears; next Tab starts from a random place.
- [ ] 30.3.2 — VoiceOver focus after sheet dismiss returns to the originating element (`UIAccessibility.post(notification:argument:)` macOS equivalent).
      Confirm by: VoiceOver + sheet dismiss.
      Failure mode: VoiceOver focus lost on every modal close.

### 30.4 Announcement of dynamic content

- [ ] 30.4.1 — Async updates (translation result appearing) post an accessibility announcement via `NSAccessibility.post(...)`.
      Confirm by: `grep -nE 'NSAccessibility' --include='*.swift' desktopAhaan/`
      Failure mode: VoiceOver user doesn't notice translated text arriving.

### 30.5 Rotor groups

- [ ] 30.5.1 — Long lists have logical heading rows (`.accessibilityHeading(.h2)` or similar) for rotor navigation.
      Confirm by: `grep -nE 'accessibilityHeading' --include='*.swift' desktopAhaan/`
      Failure mode: Rotor user scrolls through 200 items linearly.

---

## Category 31 — Accessibility — Voice Control / Switch Control / Pointer

### 31.1 Voice Control

- [ ] 31.1.1 — Every interactive control has a name that Voice Control's "Show Numbers" overlay can reach.
      Confirm by: enable Voice Control and say "Show numbers".
      Failure mode: Some controls have no number → can't be activated by voice.

### 31.2 Switch Control

- [ ] 31.2.1 — Scan groups are coherent — sidebar is one group, detail is one group, sheet is one group.
      Confirm by: enable Switch Control's auto-scanning.
      Failure mode: Auto-scan jumps wildly; switch user can't follow.

### 31.3 Pointer accessibility

- [ ] 31.3.1 — `.pointerStyle()` set where the system default isn't right (rare on macOS).
      Confirm by: visual audit.
      Failure mode: I-beam cursor over a button.

---

## Category 32 — Localization & input

### 32.1 Localizable.strings

- [ ] 32.1.1 — Every user-visible string flows through `NSLocalizedString` or SwiftUI's automatic localization.
      Confirm by: `grep -nE 'Text\("[^"]*[a-z]' --include='*.swift' desktopAhaan/ | head` — flag literal strings.
      Failure mode: App not localizable to Hindi/Tamil/etc.

### 32.2 Devanagari & complex scripts

- [ ] 32.2.1 — Sanskrit Devanagari renders with the system fallback (San Francisco → Devanagari Sangam MN) without missing glyphs.
      Confirm by: open the dictionary, look at Devanagari entries.
      Failure mode: Tofu boxes; missing glyphs.

### 32.3 IME composition

- [ ] 32.3.1 — The Translator input field handles IME composition without committing partial input on every keystroke.
      Confirm by: enable Devanagari IME and type.
      Failure mode: IME pre-edit committed prematurely.

### 32.4 Plural rules

- [ ] 32.4.1 — Sentences like "5 questions" use stringsdict for plural rules, not interpolation.
      Confirm by: search for `Localizable.stringsdict`.
      Failure mode: "1 questions" in localized builds.

### 32.5 Number formatting

- [ ] 32.5.1 — Numbers display via `.formatted(.number)` or NumberFormatter (locale-aware).
      Confirm by: `grep -nE 'String\(format:.*%d' --include='*.swift' desktopAhaan/`
      Failure mode: 1,234 vs 1.234 wrong for the user's locale.

### 32.6 Date formatting

- [ ] 32.6.1 — Dates use locale-aware formatters; no hard-coded "MM/dd/yyyy".
      Confirm by: see 75.3.1.
      Failure mode: Same.

### 32.7 RTL audit

- [ ] 32.7.1 — N/A — Sanskrit Devanagari is LTR; document the absence of Hebrew/Arabic localization.
      Confirm by: project design doc.
      Failure mode: Not applicable.

---

## Category 33 — macOS version compatibility

### 33.1 #available gates

- [ ] 33.1.1 — Every macOS 12+ API is behind `#available(macOS 12, *)` with a Big Sur fallback (lint enforces).
      Confirm by: `python3 scripts/check_macos12_apis.py`
      Failure mode: Build for Big Sur target compiles, runtime crashes when API isn't there.

### 33.2 Fallback paths

- [ ] 33.2.1 — Every `#available` block has a real `else` branch — not `return` or `fatalError`.
      Confirm by: `grep -nA 5 '#available' --include='*.swift' desktopAhaan/`
      Failure mode: Fallback is "crash if not 12+".

### 33.3 .task vs onAppear

- [ ] 33.3.1 — `.task` (macOS 12+) is wrapped in `if #available` or replaced with `.onAppear { Task { ... } }` on Big Sur.
      Confirm by: `grep -nE '\.task\s*\{' --include='*.swift' desktopAhaan/`
      Failure mode: Compile or runtime error on Big Sur.

---

## Category 34 — Big Sur-specific traps

### 34.1 Swift 5.5 type-checker

- [ ] 34.1.1 — No body expression exceeds ~30 ViewBuilder children without decomposition.
      Confirm by: ratchet test + visual audit.
      Failure mode: 60s typecheck timeout → build break.

### 34.2 ForEach tuple-keypath

- [ ] 34.2.1 — No `ForEach(array.enumerated()..., id: \.element.id)` (handled in commit `2760eb8`).
      Confirm by: ratchet greps.
      Failure mode: Compile break on Big Sur Swift 5.5.

### 34.3 AMD R9 M290X / Metal

- [ ] 34.3.1 — No GPU-heavy effects (large blurs, complex Canvas) outside `HardwareTier.isLegacy` gating.
      Confirm by: `grep -n 'HardwareTier' --include='*.swift' desktopAhaan/`
      Failure mode: Frame skips / shader-compile stalls on the deploy iMac.

### 34.4 IconRendering.framework

- [ ] 34.4.1 — `XPC_ERROR_CONNECTION_INVALID` console noise is acknowledged as Big Sur / AMD driver noise — not chased as an app bug (`STOP_AND_ASK.md` records this).
      Confirm by: read STOP_AND_ASK.
      Failure mode: Engineer spends a day on Big Sur driver noise that isn't ours.

### 34.5 Color.compat polyfills

- [ ] 34.5.1 — `Color.compatIndigo`, `Color.compatTeal`, etc. used everywhere `.indigo`/`.teal` (macOS 12+) would otherwise be needed.
      Confirm by: `grep -nE '\.indigo|\.teal' --include='*.swift' desktopAhaan/`
      Failure mode: Color renders gray on Big Sur.
- [ ] 34.5.2 — `Color.compatMint`, `Color.compatBrown`, `Color.compatCyan` likewise (every macOS 12+ named color).
      Confirm by: read `Extensions/Extensions.swift` for the full compat map.
      Failure mode: Gray fallback on Big Sur.

### 34.6 Speech first-touch stall

- [ ] 34.6.1 — First `SFSpeechRecognizer(locale:)` construction is documented as triggering ~500ms init on Big Sur; deferred to first tap.
      Confirm by: read `SpeechRecognitionManager.swift` comments.
      Failure mode: Cold-launch stall on iMac.

### 34.7 SF Symbols 2 compat

- [ ] 34.7.1 — Every `Image(systemName:)` literal that's not SF Symbols 2 routes through `SFSymbolCompat.name(_:)`.
      Confirm by: `python3 scripts/check_sf_symbols_compat.py`
      Failure mode: Blank icon on Big Sur.

---

## Category 35 — Hardware tier behavior

### 35.1 HardwareTier helpers

- [ ] 35.1.1 — `HardwareTier.duration(ideal:)` is used for every long-running animation (`b086732` lineage).
      Confirm by: `grep -n 'HardwareTier.duration' --include='*.swift' desktopAhaan/`
      Failure mode: Animation timing not tuned for legacy GPU.
- [ ] 35.1.2 — `HardwareTier.isLegacy` gates particle counts at ≤ 20fps (CLAUDE.md invariant).
      Confirm by: read `Subjects/Tutor/Discover/Components/HardwareTier.swift` and consumers.
      Failure mode: 60fps particles on AMD R9 → thermal throttle.

### 35.2 Apple Silicon vs Intel

- [ ] 35.2.1 — Release build is universal (`ONLY_ACTIVE_ARCH = NO`).
      Confirm by: `grep -n 'ONLY_ACTIVE_ARCH' desktopAhaan.xcodeproj/project.pbxproj`
      Failure mode: Apple Silicon build won't run on the Intel iMac.

### 35.3 Battery vs plugged

- [ ] 35.3.1 — Animation suspended when window is fully obscured / occluded (NSWindow occlusion state).
      Confirm by: minimize / cover the window and watch CPU.
      Failure mode: 100% CPU when window is hidden.

---

## Category 36 — Data & content schema

### 36.1 Pack invariants

- [ ] 36.1.1 — Every chapter ID is unique across `science_class7.json` and `sanskrit_class7.json`.
      Confirm by: `python3 scripts/check_pack_schema.py`
      Failure mode: Two chapters collapse into one in the sidebar.
- [ ] 36.1.2 — Every concept ID is unique within its chapter.
      Confirm by: `python3 scripts/check_pack_schema.py`
      Failure mode: Linking by ID picks the wrong concept.
- [ ] 36.1.3 — Every `relatedConceptIds` / `relatedQuestionIds` resolves to a real ID (`SubjectPack.validateRelatedRefs()`).
      Confirm by: run the validator at load and observe DATA-entry telemetry.
      Failure mode: Dead links from the "Related" panel.

### 36.2 Schema migration

- [ ] 36.2.1 — `schema_version` file on disk reflects `DataStore.currentSchemaVersion`.
      Confirm by: read `DataStore.diskSchemaVersion` + `writeDiskSchemaVersion`.
      Failure mode: Old user state isn't migrated.

### 36.3 Drift between Swift and JSON

- [ ] 36.3.1 — Every Decodable field on `Concept` / `Question` / `Variation` has either a default value or is Optional, so adding new fields to JSON doesn't break old binaries.
      Confirm by: read `Subjects/ContentSchema/`.
      Failure mode: Decode failure across versions.

---

## Category 37 — Persistence — durability

### 37.1 Atomic writes

- [ ] 37.1.1 — Every persisted state file (progress.json, settings.json, recents.json, ...) uses `options: .atomic`.
      Confirm by: `grep -nE '\.write\(to:' --include='*.swift' desktopAhaan/`
      Failure mode: Partial-write corruption on power loss.

### 37.2 Directory bootstrap

- [ ] 37.2.1 — `~/Library/Application Support/desktopAhaan/` is created with `createDirectory(at:withIntermediateDirectories:true)` before any write.
      Confirm by: read DataStore init.
      Failure mode: Write fails with "no such directory" on fresh install.

### 37.3 ⌘Q drain

- [ ] 37.3.1 — `applicationWillTerminate` flushes coalesced writes via `flushSavesBeforeQuit` and logs the timeout (commit `47452c9`).
      Confirm by: read `applicationWillTerminate` in `desktopAhaanApp.swift`.
      Failure mode: Pending writes dropped on quit.

### 37.4 Migration step gates

- [ ] 37.4.1 — `runSchemaMigrationsIfNeeded()` is idempotent — running it twice is safe.
      Confirm by: read `runSchemaMigrationsIfNeeded()` in DataStore.
      Failure mode: A retried migration corrupts state.
- [ ] 37.4.2 — Each `migrate_<n>_to_<n+1>()` step writes its result via `.atomic` and stamps the new version BEFORE returning.
      Confirm by: read each migration step.
      Failure mode: Power-loss between data write and version stamp leaves "migrated data, old stamp" state.
- [ ] 37.4.3 — Downgrade (`diskSchemaVersion > currentSchemaVersion`) is detected and surfaced as a banner — no destructive action.
      Confirm by: read the early-return branch.
      Failure mode: Downgrade silently destroys forward-compatible data.

### 37.5 Backup

- [ ] 37.5.1 — Settings file is rewritten only when content changes (no spurious mtime churn).
      Confirm by: read DataStore write methods for change-detection.
      Failure mode: File system snapshots bloat with identical re-writes.
- [ ] 37.5.2 — UserDefaults size stays under 4 MB (UserDefaults isn't designed for blobs).
      Confirm by: `defaults read com.emoha.desktopAhaan | wc -c`
      Failure mode: UserDefaults reads become slow.

---

## Category 38 — Persistence — concurrency

### 38.1 Single-writer

- [ ] 38.1.1 — Every persisted file has exactly one writer (DataStore methods are `@MainActor`).
      Confirm by: read `DataStore` class header.
      Failure mode: Two writers race and the slower one wins.

### 38.2 Coalescing

- [ ] 38.2.1 — `DataStore` debounces rapid mutations into one atomic write.
      Confirm by: read DataStore debounce logic.
      Failure mode: I/O storm under continuous typing.

### 38.3 lastSaveError banner

- [ ] 38.3.1 — Write errors set a `lastSaveError` published property surfaced as a banner.
      Confirm by: `grep -nE 'lastSaveError' --include='*.swift' desktopAhaan/`
      Failure mode: Silent data loss.
- [ ] 38.3.2 — `lastSaveError` auto-clears after the next successful write.
      Confirm by: read DataStore success path.
      Failure mode: Banner sticks forever after a transient error.
- [ ] 38.3.3 — Two-process safety: no second instance can corrupt one writer's atomic write (NSFileCoordinator if applicable, or single-instance app).
      Confirm by: search for `NSFileCoordinator`.
      Failure mode: Concurrent writes corrupt the file.

---

## Category 39 — System integration — Speech (TTS + STT)

### 39.1 Permission flow

- [ ] 39.1.1 — Speech permission requested on first dictation tap, not at launch.
      Confirm by: read `requestPermissions()` call sites.
      Failure mode: Prompt at launch confuses kid.
- [ ] 39.1.2 — XCTest guard skips the prompt (locked by `Speech_NoPromptUnderTest.swift`).
      Confirm by: run the test.
      Failure mode: Prompt pops mid-test, blocks CI.

### 39.2 Audio session

- [ ] 39.2.1 — `audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)` is the only category change during dictation.
      Confirm by: read `startListeningOniOS` / `startListeningOnMac`.
      Failure mode: Audio session bleeds across features.
- [ ] 39.2.2 — `deactivateAudioSession()` runs on stop.
      Confirm by: read `stopListening`.
      Failure mode: TTS doesn't play after dictation.

### 39.3 Voice fallback

- [ ] 39.3.1 — Sanskrit speech falls back to Hindi recognizer when Sanskrit isn't available.
      Confirm by: read `recognizerToUse` fallback chain.
      Failure mode: Voice input fails outright for the primary subject.

### 39.4 Auto-stop

- [ ] 39.4.1 — Dictation auto-stops after 30s (`Task.sleep(30_000_000_000)` in startListeningOniOS).
      Confirm by: read the auto-stop block.
      Failure mode: Mic stays on indefinitely.

### 39.5 TTS lifecycle

- [ ] 39.5.1 — `TextToSpeechManager.delegate` is owned by the manager and survives across calls.
      Confirm by: read `TextToSpeechManager.swift:11` and init.
      Failure mode: Delegate freed mid-utterance → over-release.
- [ ] 39.5.2 — Synthesizer is `final let`, constructed once per manager, never re-created during operation.
      Confirm by: read `TextToSpeechManager.swift:10`.
      Failure mode: Each call re-pays the AVSpeechSynthesizer init cost; voice cache thrashes.
- [ ] 39.5.3 — `speak(text:language:)` calls `stop()` first so a second tap doesn't queue two utterances.
      Confirm by: read `TextToSpeechManager.speak(...)`.
      Failure mode: Repeated taps stack utterances.
- [ ] 39.5.4 — TTS callback's `isSpeaking = false` is dispatched to MainActor via `Task { @MainActor }`.
      Confirm by: read `TTSDelegate` closure.
      Failure mode: Off-main publish — SwiftUI warning + EXC_BAD_ACCESS.

### 39.6 Recognizer fallback chain

- [ ] 39.6.1 — Locale string for Sanskrit is `hi-IN` (Hindi) as fallback (locales without Sanskrit support).
      Confirm by: read `SupportedLanguage.speechLocale`.
      Failure mode: Voice input returns "unsupported" with no fallback.
- [ ] 39.6.2 — Default-locale recognizer is tried before showing the "voice input unavailable" banner.
      Confirm by: read fallback ladder.
      Failure mode: Premature failure for English text inputs.
- [ ] 39.6.3 — Banner text explains the language change ("Using Hindi voice mode for Sanskrit").
      Confirm by: read `showTemporaryError` call sites.
      Failure mode: Silent language switch confuses the kid.

### 39.7 Recognition task lifecycle

- [ ] 39.7.1 — `recognitionTask?.cancel()` runs in `stopListening`.
      Confirm by: read `stopListening`.
      Failure mode: Task continues; partial-result callbacks fire into a stopped view.
- [ ] 39.7.2 — `recognitionRequest?.endAudio()` precedes `cancel()` so any in-flight audio is flushed.
      Confirm by: read `stopListening`.
      Failure mode: Last word lost.
- [ ] 39.7.3 — `audioEngine.inputNode.removeTap(onBus: 0)` runs only when `hasTapInstalled == true`.
      Confirm by: read `stopListening`.
      Failure mode: NSException from `removeTap` on a node without an installed tap.

---

## Category 40 — System integration — File picker / OCR / Image

### 40.1 NSOpenPanel

- [ ] 40.1.1 — `NSOpenPanel` invocations happen from a user-initiated action handler, not async code.
      Confirm by: `grep -nE 'NSOpenPanel' --include='*.swift' desktopAhaan/`
      Failure mode: Panel fails to show or shows behind the window.

### 40.2 OCR pipeline

- [ ] 40.2.1 — OCR runs via `Task.detached` and posts result back to MainActor.
      Confirm by: read `Services/OCR/`.
      Failure mode: UI freeze during OCR.

### 40.3 Image > display

- [ ] 40.3.1 — Large images are downsampled to display size before being passed to SwiftUI.
      Confirm by: read OCR image-import path.
      Failure mode: Loading a 30 MP image freezes UI for seconds.

### 40.4 Drag-drop UTIs

- [ ] 40.4.1 — Drag-drop targets declare exact `UTType.image` (or specific subtype) instead of `.data`.
      Confirm by: `grep -nE '\.onDrop\(' --include='*.swift' desktopAhaan/`
      Failure mode: Accepts arbitrary file types and tries to OCR them.

---

## Category 41 — System integration — NSWindow & NSHostingView

### 41.1 Window delegate

- [ ] 41.1.1 — Any secondary `NSWindow` sets `window.delegate = nil` before contentView teardown (`windowWillClose` pattern).
      Confirm by: search for `windowWillClose` (now mostly N/A since article is a sheet).
      Failure mode: Delegate callback into freed manager.

### 41.2 NSHostingView root

- [ ] 41.2.1 — Any `NSHostingView(rootView:)` does not bridge a `@StateObject` shared with another view tree.
      Confirm by: `grep -n 'NSHostingView' --include='*.swift' desktopAhaan/`
      Failure mode: Commit pump runs against torn-down state.

### 41.3 Min/max size

- [ ] 41.3.1 — Main window has `.frame(minWidth:minHeight:)` set so user can't drag below usable size.
      Confirm by: read `desktopAhaanApp.swift` `WindowGroup` body.
      Failure mode: Window collapses to 100px.

### 41.4 Restorable state

- [ ] 41.4.1 — `NSQuitAlwaysKeepsWindows` left at system default (true) so window frame restores (confirmed in AppDelegate comment).
      Confirm by: read AppDelegate.
      Failure mode: Window opens at default position every launch.

### 41.5 Tabbing

- [ ] 41.5.1 — `NSWindow.allowsAutomaticWindowTabbing = false` set in `applicationWillFinishLaunching`.
      Confirm by: read AppDelegate.
      Failure mode: Multiple article sheets fold into a single tabbed window (visually broken).

### 41.6 Title

- [ ] 41.6.1 — Main window title reflects the selected subject + chapter (e.g. "Science — Class 7 — Ch. 1").
      Confirm by: walk + observe title.
      Failure mode: Always says "desktopAhaan".

### 41.7 Restoration class

- [ ] 41.7.1 — App-defined restoration classes (if any) handle their own version drift.
      Confirm by: search for `NSWindowRestoration`.
      Failure mode: Stale restoration state crashes the new binary.

---

## Category 42 — System integration — Menu & commands

### 42.1 Shortcut coverage

- [ ] 42.1.1 — Every primary command has a `.keyboardShortcut`.
      Confirm by: `grep -nE '\.keyboardShortcut' --include='*.swift' desktopAhaan/`
      Failure mode: Power user can't do anything from the keyboard.

### 42.2 System-reserved conflicts

- [ ] 42.2.1 — No app-defined shortcut conflicts with `⌘Q`, `⌘W`, `⌘C`, `⌘V`, `⌘X`, `⌘Z`, `⌘⇧Z`, `⌘N`.
      Confirm by: visual audit + boot a fresh build and test each shortcut.
      Failure mode: Cut/paste broken in app.

### 42.3 Help menu

- [ ] 42.3.1 — Help menu contains "Keyboard Shortcuts" (the `KeyboardShortcutsSheet.swift`) and a link to `Reveal Crash Logs in Finder`.
      Confirm by: open Help menu in built app.
      Failure mode: Help menu empty.
- [ ] 42.3.2 — "Reveal Crash Logs" actually opens `~/Library/Application Support/desktopAhaan/crashlogs/` in Finder.
      Confirm by: trigger the menu action.
      Failure mode: Action no-ops.
- [ ] 42.3.3 — "Clear Crash Logs" prompts for confirmation, then removes only files matching `crashlog-*.txt`.
      Confirm by: trigger the action; verify other files untouched.
      Failure mode: Adjacent files deleted by accident.

### 42.4 Service menu

- [ ] 42.4.1 — App does not register services it doesn't implement.
      Confirm by: `grep -nE 'NSServices' desktopAhaan/Info.plist`
      Failure mode: Empty service crashes when used.

### 42.5 Command target chain when sheet up

- [ ] 42.5.1 — `⌘W` / `⌘Q` still work when a sheet is open.
      Confirm by: open Beyond sheet, ⌘W.
      Failure mode: Sheet swallows the shortcut.

---

## Category 43 — System integration — Input

### 43.1 Trackpad gestures

- [ ] 43.1.1 — Two-finger swipe on `NavigationView` does not pop unexpectedly.
      Confirm by: manual test.
      Failure mode: Accidental nav-pop.

### 43.2 Pasteboard sanity

- [ ] 43.2.1 — Pasteboard reads happen only from explicit user paste action.
      Confirm by: `grep -nE 'NSPasteboard\.general' --include='*.swift' desktopAhaan/`
      Failure mode: Privacy concern — surveillance.

### 43.3 Tab traversal

- [ ] 43.3.1 — Tab moves forward through controls, Shift-Tab moves back.
      Confirm by: manual test.
      Failure mode: Tab disabled; keyboard user stuck.

---

## Category 44 — Security & sandbox — entitlements

### 44.1 Entitlements audit

- [ ] 44.1.1 — Every entitlement in `desktopAhaan.entitlements` is actually used; no dead grants.
      Confirm by: read `desktopAhaan/desktopAhaan.entitlements`.
      Failure mode: Over-broad entitlements raise the attack surface.

### 44.2 Usage descriptions

- [ ] 44.2.1 — Every `NSXxxUsageDescription` key in Info.plist has a clear, kid-readable explanation.
      Confirm by: read Info.plist usage description strings.
      Failure mode: TCC dialog shows boilerplate that scares the user.

### 44.3 Minimal scope

- [ ] 44.3.1 — Microphone entitlement requested only at dictation start, not at launch.
      Confirm by: see 39.1.1.
      Failure mode: Permission requested too early.

---

## Category 45 — Security & sandbox — data at rest

### 45.1 AppSupport container

- [ ] 45.1.1 — All persisted data lives under `~/Library/Application Support/desktopAhaan/`.
      Confirm by: read DataStore's `storeDir` setup.
      Failure mode: Data scattered across the home directory.

### 45.2 Keychain

- [ ] 45.2.1 — Parent PIN (if any) is in Keychain, not UserDefaults.
      Confirm by: read `SettingsManagerTests.swift` Keychain comment.
      Failure mode: PIN stored as plaintext.

### 45.3 PII redaction

- [ ] 45.3.1 — Crash logs do not include user-typed translator input verbatim.
      Confirm by: read `CrashReporter.swift` redaction.
      Failure mode: Kid's notes leak into a shared log.

### 45.4 Screenshot redaction in support flow

- [ ] 45.4.1 — N/A — no support-flow screenshots; document the absence.
      Confirm by: search for screenshot capture API.
      Failure mode: Not applicable.

---

## Category 46 — Security — code signing & release

### 46.1 Hardened Runtime

- [ ] 46.1.1 — Hardened Runtime enabled in the Release config (not disabled by ad-hoc signing path).
      Confirm by: `grep -nE 'ENABLE_HARDENED_RUNTIME' desktopAhaan.xcodeproj/project.pbxproj`
      Failure mode: Notarization fails.

### 46.2 Notarization

- [ ] 46.2.1 — Distribution build is notarized and stapled.
      Confirm by: run `spctl --assess --verbose=4 desktopAhaan.app` on a distribution build.
      Failure mode: Gatekeeper warns user on first launch.

### 46.3 App Translocation

- [ ] 46.3.1 — App handles translocation (running from a quarantined location) without breaking content resolution.
      Confirm by: download a built .app from Safari and launch from ~/Downloads.
      Failure mode: Bundle resource URLs broken.

### 46.4 Notarization staple

- [ ] 46.4.1 — `xcrun stapler validate desktopAhaan.app` reports staple present.
      Confirm by: run the command on a distribution build.
      Failure mode: Gatekeeper online-check fails; first-launch delay.

### 46.5 Provisioning profile

- [ ] 46.5.1 — Release build does not embed a developer-team provisioning profile (or its bundle ID matches the production team).
      Confirm by: `security cms -D -i embedded.provisionprofile`
      Failure mode: Wrong team signs release.

### 46.6 Embedded frameworks signing

- [ ] 46.6.1 — Every `Contents/Frameworks/*` is signed with the same identity as the main binary.
      Confirm by: `codesign --display --verbose=4 desktopAhaan.app/Contents/Frameworks/*`
      Failure mode: Notarization rejects.

---

## Category 47 — Privacy

### 47.1 Telemetry

- [ ] 47.1.1 — Zero outbound network requests by default.
      Confirm by: launch under Little Snitch; observe.
      Failure mode: Surveillance.

### 47.2 Third-party SDKs

- [ ] 47.2.1 — Zero third-party Swift packages or Carthage / Cocoapods.
      Confirm by: `cat Package.swift 2>/dev/null; ls Cartfile* Podfile* 2>/dev/null`
      Failure mode: Hidden telemetry from a SDK.

### 47.3 Clipboard access

- [ ] 47.3.1 — Pasteboard reads logged in DEBUG to verify on-demand-only.
      Confirm by: see 43.2.1.
      Failure mode: Privacy leak.

---

## Category 48 — Networking

### 48.1 Outbound audit

- [ ] 48.1.1 — Default `FreeOnlineTranslationProvider` disabled by setting; explicit user opt-in.
      Confirm by: read Settings toggle for online translation.
      Failure mode: Offline-first promise broken.

### 48.2 URLSession lifecycle

- [ ] 48.2.1 — Any `URLSession` instance is cancelled on view disappear.
      Confirm by: `grep -nE 'URLSession' --include='*.swift' desktopAhaan/`
      Failure mode: Background fetch continues after navigation away.

### 48.3 TLS

- [ ] 48.3.1 — TLS 1.2+ enforced; no `NSAppTransportSecurity` plist overrides.
      Confirm by: read Info.plist.
      Failure mode: Downgrade attack possible.
- [ ] 48.3.2 — No `NSAllowsArbitraryLoads = true` in Info.plist.
      Confirm by: read Info.plist.
      Failure mode: Cleartext HTTP allowed.

### 48.4 Captive portal

- [ ] 48.4.1 — Online translate call fails gracefully on captive-portal (HTML response instead of expected JSON).
      Confirm by: read translate provider's response handling.
      Failure mode: Parse exception when captive portal returns HTML.

### 48.5 NWPathMonitor

- [ ] 48.5.1 — If used, `NWPathMonitor.cancel()` is called on view disappear.
      Confirm by: `grep -nE 'NWPathMonitor' --include='*.swift' desktopAhaan/`
      Failure mode: Monitor leaks; battery.

### 48.6 Timeouts

- [ ] 48.6.1 — Every URLRequest has a documented timeoutInterval (default 60s usually too long for kid-UX).
      Confirm by: search URLRequest constructions.
      Failure mode: 60s spinner before kid gives up.

---

## Category 49 — Audio & video

### 49.1 AVPlayer

- [ ] 49.1.1 — N/A or audited — no embedded video, document.
      Confirm by: search for AVPlayer usage.
      Failure mode: Not applicable.

### 49.2 Audio session

- [ ] 49.2.1 — Audio session set only for TTS/STT, never globally.
      Confirm by: see 39.2.1.
      Failure mode: Music apps duck whenever desktopAhaan runs.

---

## Category 50 — Notifications & badges

### 50.1 UNNotificationCenter

- [ ] 50.1.1 — Either N/A (no notifications) or every UN request is gated behind user permission and a settings toggle.
      Confirm by: `grep -nE 'UNNotificationCenter|UNUserNotification' --include='*.swift' desktopAhaan/`
      Failure mode: Spam to lock screen.

### 50.2 Dock badge

- [ ] 50.2.1 — Dock badge cleared on app focus.
      Confirm by: `grep -nE 'NSApp.dockTile|badgeLabel' --include='*.swift' desktopAhaan/`
      Failure mode: Stale "needs review" badge.

---

## Category 51 — State restoration

### 51.1 Window restoration

- [ ] 51.1.1 — `NSQuitAlwaysKeepsWindows` left at default (system handles frame restore).
      Confirm by: AppDelegate comment.
      Failure mode: Window opens at default position every time.

### 51.2 Sidebar selection

- [ ] 51.2.1 — Last-selected sidebar item restored at next launch.
      Confirm by: see 22.1.1.
      Failure mode: Lands on wrong page.

### 51.3 Recents persistence

- [ ] 51.3.1 — `appState.recentItems` round-trips across launches.
      Confirm by: read recents persistence in DataStore.
      Failure mode: Recents lost on every quit.

### 51.4 Last-chapter persistence

- [ ] 51.4.1 — Re-launching after navigating to Chapter X returns to Chapter X.
      Confirm by: walk, quit, relaunch.
      Failure mode: Always lands on welcome / Ch.1.

### 51.5 Settings persistence

- [ ] 51.5.1 — Settings toggles (preferOffline, speechRate, speechLanguage, autoAdvanceOnCorrect) round-trip across launches.
      Confirm by: `SettingsManagerTests.swift` should cover this.
      Failure mode: User has to re-set on every launch.

### 51.6 @SceneStorage

- [ ] 51.6.1 — Where used, `@SceneStorage` keys are kebab-case and stable across versions.
      Confirm by: `grep -nE '@SceneStorage' --include='*.swift' desktopAhaan/`
      Failure mode: A renamed key loses user state.

### 51.7 Per-chapter scratch

- [ ] 51.7.1 — Chapter notebook (`ChapterNotebookSheet`) auto-saves on Done, not on every keystroke (avoids I/O storm).
      Confirm by: read `ChapterNotebookSheet.swift`.
      Failure mode: I/O storm during typing.

---

## Category 52 — File handling

### 52.1 Drag-drop UTIs

- [ ] 52.1.1 — Only declared UTIs accepted (see 40.4.1).
      Confirm by: see 40.4.
      Failure mode: Random files dragged in crash the OCR pipeline.

### 52.2 Security-scoped URLs

- [ ] 52.2.1 — Any file URL obtained from NSOpenPanel uses `startAccessingSecurityScopedResource()` if needed.
      Confirm by: `grep -n 'startAccessingSecurity' --include='*.swift' desktopAhaan/`
      Failure mode: Sandbox blocks read after dialog dismiss.

### 52.3 Auto-save / revert

- [ ] 52.3.1 — N/A (no document-based architecture). Document.
      Confirm by: search for `NSDocument`.
      Failure mode: Not applicable.

---

## Category 53 — Print / Export / Share

### 53.1 PDF export

- [ ] 53.1.1 — Certificate export (Boss Quiz) produces a valid PDF.
      Confirm by: trigger export, open file.
      Failure mode: Empty / corrupt PDF.

### 53.2 NSSharingService

- [ ] 53.2.1 — Share menu populated if a share affordance exists; otherwise documented N/A.
      Confirm by: search for `NSSharingService`.
      Failure mode: Empty share sheet.

### 53.3 Print

- [ ] 53.3.1 — N/A or `NSPrintOperation` produces correct output if used.
      Confirm by: search for `NSPrintOperation`.
      Failure mode: Print prints blank.

---

## Category 54 — Logging & observability

### 54.1 Logger subsystems

- [ ] 54.1.1 — Every `Logger` uses subsystem `com.emoha.desktopAhaan` and a category per feature.
      Confirm by: `grep -nE 'Logger\(' --include='*.swift' desktopAhaan/`
      Failure mode: Logs lost in `Console.app` noise.

### 54.2 Privacy specifiers

- [ ] 54.2.1 — Every `\(... )` in a Logger call uses `, privacy: .public` only for safe identifiers (chapter IDs, version), `.private` for user-typed content.
      Confirm by: `grep -nE ', privacy:' --include='*.swift' desktopAhaan/`
      Failure mode: User notes leak into `log show`.

### 54.3 Signposts

- [ ] 54.3.1 — Signpost intervals exist at navigation boundaries (sidebar tap → page renders).
      Confirm by: search for `OSSignposter`.
      Failure mode: No way to measure tap-to-render latency in Instruments.

### 54.4 Release log volume

- [ ] 54.4.1 — Release build does not emit `.debug` logs (use `Logger.debug` not `Logger.info` for noisy traces).
      Confirm by: visual audit of high-volume call sites.
      Failure mode: Console floods.

---

## Category 55 — Crash reporting

### 55.1 In-app reporter

- [ ] 55.1.1 — `CrashReporter.shared.install()` runs in `applicationWillFinishLaunching` before any UI.
      Confirm by: read `AppDelegate`.
      Failure mode: Launch crash isn't captured.

### 55.2 Clean-quit marker

- [ ] 55.2.1 — Marker written in `applicationWillTerminate`; absence on next launch implies crash.
      Confirm by: read CrashReporter + AppDelegate.
      Failure mode: Cannot distinguish quit from crash.

### 55.3 Log rotation

- [ ] 55.3.1 — `crashlog-YYYY-MM-DD.txt` rotates per UTC day with a size cap.
      Confirm by: read `rotateIfNeeded` + `pruneOldLogs` in CrashReporter.
      Failure mode: Infinite log file.

### 55.4 PII redaction

- [ ] 55.4.1 — User-typed strings are redacted before being logged.
      Confirm by: visual audit of log call sites.
      Failure mode: PII in support logs.

### 55.5 Sanitizer integration

- [ ] 55.5.1 — `desktopAhaan.xcscheme` has NSZombieEnabled + ASan + MallocStackLogging + OBJC_DEBUG_MISSING_POOLS + CFZombieLevel.
      Confirm by: read scheme XML.
      Failure mode: Sanitizer scheme drifts.
- [ ] 55.5.2 — `desktopAhaan-ThreadSanitizer.xcscheme` enables TSan for concurrent-bug hunts.
      Confirm by: `ls desktopAhaan.xcodeproj/xcshareddata/xcschemes/`.
      Failure mode: TSan disabled means concurrent races invisible until production.
- [ ] 55.5.3 — Sanitizer scheme commits to scheme XML, not user-data (so the iMac inherits the env).
      Confirm by: confirm scheme files are in `xcshareddata`.
      Failure mode: Sanitizers disabled on the iMac silently.

### 55.6 Hang detection

- [ ] 55.6.1 — `CrashReporter.shared.startHangDetection()` runs in `applicationDidFinishLaunching` (DEBUG-only).
      Confirm by: read `desktopAhaanApp.swift` AppDelegate.
      Failure mode: Main-thread hangs go unnoticed.

### 55.7 Data-quality logging

- [ ] 55.7.1 — `CrashReporter.logDataIssue(...)` is the only path that surfaces DATA entries (no direct `print` for content drift).
      Confirm by: `grep -nE 'logDataIssue' --include='*.swift' desktopAhaan/`
      Failure mode: Data-drift incidents lost to stdout.
- [ ] 55.7.2 — DATA entries are throttled per key so a runaway loop doesn't fill the log.
      Confirm by: read `logDataIssue` for throttling.
      Failure mode: 50 MB log from one bad concept ID.

---

## Category 56 — Build & CI — compile

### 56.1 Zero-warning bar

- [ ] 56.1.1 — `xcodebuild build` exits clean with zero warnings on Debug + Release.
      Confirm by: `bash scripts/ci-build-test.sh`
      Failure mode: Warnings accumulate, real signals lost.

### 56.2 Type-checker timeouts

- [ ] 56.2.1 — No file builds in > 30s on Big Sur Xcode 13.2.1 (Swift 5.5).
      Confirm by: time `xcodebuild build` on the iMac.
      Failure mode: Bisection unrecoverable build break.

### 56.3 Scheme drift

- [ ] 56.3.1 — Shared scheme `desktopAhaan.xcscheme` matches what the dev Mac and the iMac use — no `xcuserdata` overrides leak into commits.
      Confirm by: `git status` should never show `xcuserdata/` (already in .gitignore).
      Failure mode: Different schemes on different machines.

### 56.4 Bridging cleanliness

- [ ] 56.4.1 — Mixed Swift/Obj-C bridging headers — only `desktopAhaan-Bridging-Header.h` if needed; otherwise none.
      Confirm by: `find desktopAhaan -name '*Bridging*'`
      Failure mode: Hidden Obj-C bridging that breaks under Swift updates.

### 56.5 Build settings parity

- [ ] 56.5.1 — Debug + Release configurations share `SWIFT_VERSION` and `MACOSX_DEPLOYMENT_TARGET`.
      Confirm by: `grep -nE 'SWIFT_VERSION|MACOSX_DEPLOYMENT_TARGET' desktopAhaan.xcodeproj/project.pbxproj`
      Failure mode: A modern API compiles in Debug but not Release (or vice versa).

### 56.6 Universal binary

- [ ] 56.6.1 — Release config: `ONLY_ACTIVE_ARCH = NO` so the binary is x86_64 + arm64.
      Confirm by: see 35.2.1.
      Failure mode: Apple Silicon build won't launch on Intel iMac.

### 56.7 Swift warnings as errors

- [ ] 56.7.1 — `SWIFT_TREAT_WARNINGS_AS_ERRORS = YES` is OFF (intentional — see ratchets for hard gates) but warning count is zero.
      Confirm by: read pbxproj.
      Failure mode: Warning accumulation.

---

## Category 57 — Build & CI — pipeline

### 57.1 Deploy-target enforcement

- [ ] 57.1.1 — CI uses `MACOSX_DEPLOYMENT_TARGET=11.0` so Big Sur incompatibilities surface as compile errors.
      Confirm by: read `scripts/ci-build-test.sh:115-123`.
      Failure mode: Modern API compiles in CI, fails on iMac.

### 57.2 Tests on every push

- [ ] 57.2.1 — Pre-push hook runs `scripts/ci-build-test.sh`.
      Confirm by: read `scripts/hooks/pre-push`.
      Failure mode: Broken state lands on origin.

### 57.3 Lint as part of pipeline

- [ ] 57.3.1 — `check_macos12_apis.py`, `check_lifetime_hazards.py`, `check_sf_symbols_compat.py`, `check_wcag_contrast.py`, `check_color_literals.py`, `check_pack_schema.py`, `check_viewbuilder_limit.py` all called from pre-commit and/or pre-push.
      Confirm by: read `scripts/hooks/pre-commit`.
      Failure mode: Lint additions don't run automatically.

### 57.4 No xcpretty error-hiding

- [ ] 57.4.1 — `ci-build-test.sh` checks BOTH exit code AND failure-marker strings (lines 72-104).
      Confirm by: read the script.
      Failure mode: TEST FAILED hidden by xcpretty.

---

## Category 58 — Source control hygiene

### 58.1 .gitignore

- [ ] 58.1.1 — `.gitignore` covers `.DS_Store`, `xcuserdata/`, `DerivedData/`, `.ci-derived/`, `*.xcuserstate`.
      Confirm by: read `.gitignore`.
      Failure mode: Per-user state leaks into commits.

### 58.2 Pre-push hook

- [ ] 58.2.1 — `bash scripts/install-git-hooks.sh` installs both pre-commit and pre-push hooks.
      Confirm by: run the script after fresh clone.
      Failure mode: New machine pushes broken state.

### 58.3 Fast-forward main

- [ ] 58.3.1 — `git push --force` to main is forbidden (hard rule in CLAUDE.md).
      Confirm by: documented in CLAUDE.md.
      Failure mode: History rewrite loses someone else's commit.

### 58.4 Large binaries

- [ ] 58.4.1 — No binary > 5 MB in repo history; assets > 5 MB live as bundled resources not in `git`.
      Confirm by: `git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize)' | sort -nr -k3 | head -10`
      Failure mode: Clone time grows; LFS becomes a regret.

---

## Category 59 — Testing — unit coverage

### 59.1 Decoders

- [ ] 59.1.1 — `ChapterContentTests.swift` covers `Concept`, `Question`, `Variation` round-trip decode.
      Confirm by: read the test file.
      Failure mode: Schema break ships.

### 59.2 Persistence round-trip

- [ ] 59.2.1 — `PersistenceTests.swift` covers `DataStore` save → load → expect-equal for each persisted type.
      Confirm by: read the test file.
      Failure mode: Persistence break ships.

### 59.3 ViewModels

- [ ] 59.3.1 — `ViewModelTests.swift` covers happy-path + error-path for the translator VM.
      Confirm by: read the test file.
      Failure mode: VM behavior regresses silently.

### 59.4 Content-pack integrity

- [ ] 59.4.1 — `SubjectRegistryTests.swift` asserts pack count and structural integrity.
      Confirm by: read the test file.
      Failure mode: A broken pack ships and tests still pass.

### 59.5 Answer validation

- [ ] 59.5.1 — `AnswerValidatorTests.swift` covers each `Variation` answer-format (MCQ, free text, match-pairs).
      Confirm by: read the file.
      Failure mode: New variation type lands with no test coverage.

### 59.6 Tutor navigation

- [ ] 59.6.1 — `TutorNavigationTests.swift` walks Sidebar → Subject → Chapter → Concept identity in tests.
      Confirm by: read the file.
      Failure mode: Navigation regression unlocked.

### 59.7 Settings round-trip

- [ ] 59.7.1 — `SettingsManagerTests.swift` covers @AppStorage round-trip for each key.
      Confirm by: read the file.
      Failure mode: Setting silently lost across launches.

### 59.8 Review flag

- [ ] 59.8.1 — `ReviewFlagTests.swift` covers the per-question review flag flow.
      Confirm by: read the file.
      Failure mode: Review-flag UX breaks silently.

### 59.9 Streak tests

- [ ] 59.9.1 — Streak tests cover (yesterday+today)→2, (today+tomorrow w/ TZ skip)→1, leap day.
      Confirm by: read streak test cases in `ChapterContentTests.swift`.
      Failure mode: Streak misfires across time-zone moves.

---

## Category 60 — Testing — ratchet lints

### 60.1 ForEach tuple-keypath ratchet

- [ ] 60.1.1 — Pre-commit grep refuses `ForEach(...enumerated()..., id: \.element.id)`.
      Confirm by: read pre-commit hook.
      Failure mode: The 2760eb8 regression class returns.

### 60.2 Layout-recursion ratchet

- [ ] 60.2.1 — Either a lint or a documented invariant refuses `GeometryReader` inside unbounded `LazyVStack` (per `793c4ed`).
      Confirm by: visual check.
      Failure mode: Layout recursion crash returns.

### 60.3 Big Sur API ratchet

- [ ] 60.3.1 — `scripts/check_macos12_apis.py` covers macOS 12+/13+/14+/15+ patterns.
      Confirm by: read the lint script.
      Failure mode: A modern API leaks to Big Sur target.

### 60.4 Lifetime ratchet

- [ ] 60.4.1 — `scripts/check_lifetime_hazards.py` covers LH001 (`var delegate:` w/o weak), LH002 (`unowned`), LH003 (`@unchecked Sendable`).
      Confirm by: read the lint.
      Failure mode: A retain cycle / over-release returns.

---

## Category 61 — Testing — snapshot

### 61.1 Chapter index snapshot

- [ ] 61.1.1 — A snapshot test of `ChapterListView` rendered at default Dynamic Type + Light mode exists.
      Confirm by: search for `snapshot` test files.
      Failure mode: Visual regressions ship.

### 61.2 Discover scene snapshot

- [ ] 61.2.1 — A snapshot of at least one Discover scene (Ch.1 Scene 1) at Reduce Motion ON + Dark mode exists.
      Confirm by: search snapshot tests.
      Failure mode: Visual regression in scenes ships.

### 61.3 Boss Quiz snapshot

- [ ] 61.3.1 — A snapshot of the Boss Quiz state at AX5 Dynamic Type exists.
      Confirm by: search.
      Failure mode: Text clips at large sizes; ships.

---

## Category 62 — Testing — stress & fuzz

### 62.1 Large-state cold launch

- [ ] 62.1.1 — `progress.json` with 10K rows: cold launch < 2s.
      Confirm by: write the fixture, time `applicationDidFinishLaunching`.
      Failure mode: Slow launch on heavy users.

### 62.2 Malformed JSON

- [ ] 62.2.1 — A corrupted pack JSON degrades gracefully (logs DATA, shows the other packs).
      Confirm by: drop in a malformed fixture.
      Failure mode: One bad pack kills the whole subject.

### 62.3 Disk-full

- [ ] 62.3.1 — Save under a full disk surfaces `lastSaveError` banner; app does not crash.
      Confirm by: mock the write to throw.
      Failure mode: Silent loss or crash.

### 62.4 Permission denied

- [ ] 62.4.1 — Saving when AppSupport is read-only triggers the same banner.
      Confirm by: `chmod -w` on a test dir.
      Failure mode: Same as 62.3.

### 62.5 0-byte file

- [ ] 62.5.1 — Loading an empty `progress.json` initializes empty state, doesn't crash.
      Confirm by: write empty file.
      Failure mode: Decode trap.

### 62.6 HTML abuse

- [ ] 62.6.1 — `PlainTextArticleFallback.stripHTML(_:)` handles `<script>`, malformed tags, unicode, very long single-line HTML.
      Confirm by: fuzz with a script.
      Failure mode: Parser hangs / crashes.

---

## Category 63 — Testing — UI / XCUITest

### 63.1 UI-test target wiring

- [ ] 63.1.1 — `desktopAhaanUITests` is a `com.apple.product-type.bundle.ui-testing` target referenced from the scheme TestAction.
      Confirm by: `xcodebuild -list` shows the target; `xcodebuild build-for-testing` produces `desktopAhaanUITests-Runner.app`.
      Failure mode: UI tests stay as compile-locked dead code.

### 63.2 AX grant story

- [ ] 63.2.1 — `scripts/ci-build-test.sh` passes `-skip-testing:desktopAhaanUITests`; explicit invocation documented in test file header.
      Confirm by: read the file header.
      Failure mode: Pre-push hook breaks on machines without AX.

### 63.3 Every CTA reachable

- [ ] 63.3.1 — Every CTA in the app has an `accessibilityIdentifier`.
      Confirm by: `grep -nE '\.accessibilityIdentifier' --include='*.swift' desktopAhaan/`
      Failure mode: UI test can't drive that surface.

### 63.4 Crash repros locked

- [ ] 63.4.1 — `Crash_BeyondThenDiscover` + `Crash1_TryDiscoverMode_Ch1` both compile and run from the explicit invocation.
      Confirm by: see each commit SHA.
      Failure mode: Regression lock claim is false.
- [ ] 63.4.2 — iMac documentation includes the one-time AX-grant procedure for `desktopAhaanUITests-Runner.app`.
      Confirm by: read test file header + STOP_AND_ASK.
      Failure mode: iMac runs return AX-deny silently.

### 63.5 Every chapter walked

- [ ] 63.5.1 — A meta-walker test iterates `subjectRegistry.packs.flatMap{ $0.chapters }` and asserts the chapter detail page renders for each.
      Confirm by: build the meta-walker test (deferred).
      Failure mode: One chapter regresses; only a kid catches it.

### 63.6 Sanitizer walker

- [ ] 63.6.1 — XCUITest scheme can be combined with NSZombieEnabled + ASan via env override at xcodebuild time.
      Confirm by: pass env in `xcodebuild test ENV_KEY=VAL`.
      Failure mode: Sanitizer walks not reproducible.

---

## Category 64 — Energy & thermal

### 64.1 CPU spikes

- [ ] 64.1.1 — Idle app at the welcome screen draws < 1% CPU.
      Confirm by: Activity Monitor with app idle.
      Failure mode: Animation loop never sleeps.

### 64.2 Idle wake-ups

- [ ] 64.2.1 — No `Timer` fires faster than 30Hz outside an active animation.
      Confirm by: `grep -nE 'withTimeInterval:\s*0\.0' --include='*.swift' desktopAhaan/`
      Failure mode: Battery drain.

### 64.3 Window-backgrounded

- [ ] 64.3.1 — Backgrounded window suspends Discover scene animations (`scenePhase` driven).
      Confirm by: minimize + Activity Monitor.
      Failure mode: 60fps under minimize.

---

## Category 65 — Power management

### 65.1 Sleep/wake

- [ ] 65.1.1 — App handles `NSWorkspaceDidWakeNotification` (e.g. resets dictation auto-stop).
      Confirm by: sleep the Mac, wake, observe.
      Failure mode: Stale audio session post-wake.

### 65.2 Low-power mode

- [ ] 65.2.1 — Honor `ProcessInfo.processInfo.isLowPowerModeEnabled` by downshifting animations.
      Confirm by: `grep -nE 'isLowPowerModeEnabled' --include='*.swift' desktopAhaan/`
      Failure mode: Battery drains faster than user expects.

---

## Category 66 — Window & multi-window

### 66.1 Min size

- [ ] 66.1.1 — Every window has a documented min size that fits the primary CTA.
      Confirm by: see 41.3.1.
      Failure mode: Window resized to unusable.

### 66.2 Fullscreen

- [ ] 66.2.1 — Toggling fullscreen does not crash or freeze the sidebar.
      Confirm by: ⌃⌘F.
      Failure mode: Sidebar repaints incorrectly.

### 66.3 Mission Control

- [ ] 66.3.1 — Mission Control thumbnail renders the current content, not a placeholder.
      Confirm by: F3 / four-finger swipe.
      Failure mode: Missing icon.

### 66.4 Secondary windows

- [ ] 66.4.1 — Each secondary window has a distinguishable title.
      Confirm by: open multiple article sheets (if applicable).
      Failure mode: Two windows titled the same; user can't tell apart.

---

## Category 67 — Display reconfiguration

### 67.1 Plug/unplug

- [ ] 67.1.1 — Hot-swap of an external display does not crash; window stays visible on the remaining display.
      Confirm by: plug/unplug a display.
      Failure mode: App hides on disconnected display.

### 67.2 Resolution change

- [ ] 67.2.1 — Changing system resolution mid-session re-flows the layout cleanly.
      Confirm by: System Preferences → Displays.
      Failure mode: Layout sticks at old size.

### 67.3 Sleep-wake

- [ ] 67.3.1 — Display sleep then wake does not corrupt the Metal cache or Canvas drawing.
      Confirm by: sleep, wake.
      Failure mode: Black scenes after wake.

### 67.4 ColorSync profile change

- [ ] 67.4.1 — Changing system color profile during runtime re-rendered surfaces look correct.
      Confirm by: change profile in System Preferences → Displays.
      Failure mode: Colors shift visibly.

### 67.5 Brightness/contrast

- [ ] 67.5.1 — App appearance unaffected by hardware brightness/contrast (no logical changes).
      Confirm by: vary brightness.
      Failure mode: App tries to compensate.

---

## Category 68 — Keyboard shortcut hygiene

### 68.1 No system conflicts

- [ ] 68.1.1 — See 42.2.1.
      Confirm by: see 42.2.
      Failure mode: Same.

### 68.2 Menu == in-window

- [ ] 68.2.1 — Every in-window keyboard shortcut also appears in the menu bar.
      Confirm by: visual audit menu vs. app.
      Failure mode: Power user can't discover the shortcut.

### 68.3 Command target chain

- [ ] 68.3.1 — When a sheet is open, `⌘Q` still quits the app (root command target chain intact).
      Confirm by: open sheet, ⌘Q.
      Failure mode: ⌘Q swallowed by sheet; user can't quit.

---

## Category 69 — Trackpad & pointer

### 69.1 Smooth scroll

- [ ] 69.1.1 — Two-finger scroll inertia feels native.
      Confirm by: manual.
      Failure mode: Janky scroll.

### 69.2 Hover

- [ ] 69.2.1 — Hover delay on tooltips is the system default (no custom timer).
      Confirm by: search for hover-related custom delays.
      Failure mode: Tooltips lag.

### 69.3 Right-click

- [ ] 69.3.1 — Right-click on items in lists shows a sensible context menu or nothing (not a broken empty menu).
      Confirm by: right-click on each list item.
      Failure mode: Empty context menu.

### 69.4 Force Click

- [ ] 69.4.1 — Force Click does not trigger unexpected behavior (text lookup is the system default).
      Confirm by: Force Click on text.
      Failure mode: Custom Force Click overrides confusing.

### 69.5 Drag initiation

- [ ] 69.5.1 — Drag-and-drop initiation threshold matches system default (≥ 5pt).
      Confirm by: search for `dragGesture` patterns.
      Failure mode: Accidental drag on tap.

### 69.6 Edge swipe

- [ ] 69.6.1 — Two-finger swipe from screen edge does not pop nav unexpectedly.
      Confirm by: manual.
      Failure mode: Lost current view.

---

## Category 70 — Pasteboard / Clipboard

### 70.1 Read

- [ ] 70.1.1 — See 43.2.1.
      Confirm by: see 43.2.
      Failure mode: Same.

### 70.2 Write

- [ ] 70.2.1 — Copy actions write only the relevant type (no whole NSAttributedString when plain text is asked).
      Confirm by: visual audit + paste into Plain Text TextEdit.
      Failure mode: Bloated clipboard contents.

---

## Category 71 — URL schemes & deep links

### 71.1 Registered schemes

- [ ] 71.1.1 — `CFBundleURLSchemes` empty (no deep-linking is intentional for this app); document.
      Confirm by: read Info.plist.
      Failure mode: Unhandled scheme drops user into a broken state.

---

## Category 72 — Spotlight indexing

### 72.1 CoreSpotlight

- [ ] 72.1.1 — N/A or audited.
      Confirm by: `grep -nE 'CoreSpotlight|CSSearchableItem' --include='*.swift' desktopAhaan/`
      Failure mode: Not applicable.

---

## Category 73 — Quick Look

### 73.1 Preview provider

- [ ] 73.1.1 — N/A or audited.
      Confirm by: `grep -nE 'QLPreviewProvider' --include='*.swift' desktopAhaan/`
      Failure mode: Not applicable.

---

## Category 74 — Continuity

### 74.1 Handoff / Universal Clipboard / Sidecar

- [ ] 74.1.1 — N/A for an offline single-user app — document the absence.
      Confirm by: see app design doc.
      Failure mode: Not applicable.

---

## Category 75 — Time, dates, scheduling

### 75.1 Time-zone shifts

- [ ] 75.1.1 — Streak rollover uses `Calendar.current` not UTC, so a TZ change at midnight doesn't reset progress.
      Confirm by: read streak-rollover code in `DataStore` / `ChapterContentTests`.
      Failure mode: Kid loses streak from a flight.

### 75.2 DST

- [ ] 75.2.1 — Streak calculation handles DST transitions (23-hour and 25-hour days).
      Confirm by: read streak test and walk DST dates.
      Failure mode: Off-by-one streak on DST date.

### 75.3 Locale formatting

- [ ] 75.3.1 — Dates displayed via `DateFormatter` or `.formatted(date:time:)` with locale-aware style.
      Confirm by: `grep -nE 'DateFormatter|\.formatted\(' --include='*.swift' desktopAhaan/`
      Failure mode: US-style dates in IN locale.

### 75.4 Leap year

- [ ] 75.4.1 — Date math uses `Calendar.date(byAdding:)`, not raw `Date(timeIntervalSince:86400)`.
      Confirm by: `grep -nE 'Date\(timeIntervalSince' --include='*.swift' desktopAhaan/`
      Failure mode: Feb 29 corrupts streak.

### 75.5 Midnight rollover

- [ ] 75.5.1 — Streak rollover only counts a new day when the local-time midnight has passed.
      Confirm by: read streak logic.
      Failure mode: Off-by-one across timezones.

### 75.6 Calendar.startOfDay

- [ ] 75.6.1 — Per-day grouping uses `Calendar.startOfDay(for:)`, not arithmetic truncation.
      Confirm by: `grep -nE 'startOfDay\(' --include='*.swift' desktopAhaan/`
      Failure mode: DST off-by-one.

### 75.7 Long-running timer

- [ ] 75.7.1 — Quiz timer uses `Date()` deltas, not Timer accumulation (which drifts).
      Confirm by: read BossQuiz timer code.
      Failure mode: Timer drift over a long quiz.

---

## Category 76 — Resource bundle

### 76.1 Asset catalog

- [ ] 76.1.1 — App icon variants 16/32/128/256/512 at @1× and @2× present.
      Confirm by: read `Assets.xcassets/AppIcon.appiconset/Contents.json`.
      Failure mode: Pixelated icon on some sizes.

### 76.2 Dark mode variants

- [ ] 76.2.1 — Color sets in asset catalog have explicit Dark variants for any non-system color.
      Confirm by: open AccentColor.colorset / any color set.
      Failure mode: Color unreadable in dark mode.

### 76.3 1024 marketing icon

- [ ] 76.3.1 — 1024×1024 marketing icon is present even if no App Store submission planned.
      Confirm by: AppIcon.appiconset listing.
      Failure mode: Future App Store submission blocked.

### 76.4 Localized resources

- [ ] 76.4.1 — Bundled `.lproj` directories match declared `CFBundleLocalizations`.
      Confirm by: `find desktopAhaan -name '*.lproj'`
      Failure mode: Stale .lproj confuses localized lookup.

### 76.5 Article HTML organization

- [ ] 76.5.1 — `Resources/Articles/Chapter<N>/` per chapter; no cross-chapter pollution.
      Confirm by: `ls desktopAhaan/Resources/Articles/`
      Failure mode: Lookups by chapterFolder fail.

### 76.6 Asset catalog hygiene

- [ ] 76.6.1 — No orphan color sets or image sets unused by any view.
      Confirm by: `find desktopAhaan/Assets.xcassets -name 'Contents.json'` + cross-check usage.
      Failure mode: Bundle bloat from dead assets.

---

## Category 77 — Image rendering

### 77.1 HDR / Display P3

- [ ] 77.1.1 — Color sets declared with Display P3 where deliberate; otherwise sRGB.
      Confirm by: color-set Contents.json gamut field.
      Failure mode: Color shifts on P3-capable displays.

### 77.2 Vector vs raster

- [ ] 77.2.1 — Icons that should scale are vector (PDF or SVG); raster reserved for photo content.
      Confirm by: list `Assets.xcassets/` for raster icons.
      Failure mode: Pixelated icon at scaled sizes.

---

## Category 78 — Color management

### 78.1 Semantic colors

- [ ] 78.1.1 — Body text uses `.primary`/`.secondary`/`.tertiary` semantic colors.
      Confirm by: `grep -nE '\.foregroundColor\(\.(white|black|gray)\)' --include='*.swift' desktopAhaan/`
      Failure mode: White text on white background in Light mode.

### 78.2 Accent color

- [ ] 78.2.1 — Accent color flows from `AccentColor.colorset`, not hard-coded.
      Confirm by: see 26.3.1.
      Failure mode: Inconsistent brand color.

### 78.3 Light/Dark transitions

- [ ] 78.3.1 — Toggling System Settings → Appearance → Dark mid-session transitions smoothly.
      Confirm by: toggle and observe.
      Failure mode: Some surfaces don't update.

---

## Category 79 — Font fallback

### 79.1 Devanagari

- [ ] 79.1.1 — Devanagari script falls back to "Devanagari Sangam MN" (Big Sur default).
      Confirm by: open dictionary, inspect a Sanskrit entry.
      Failure mode: Tofu.

### 79.2 System sizes

- [ ] 79.2.1 — Body text uses `.font(.body)` so Dynamic Type works (see 23.2.1).
      Confirm by: see 23.2.
      Failure mode: Same.

### 79.3 Monospace digits

- [ ] 79.3.1 — Counter UIs use `.font(.system(size:design: .monospaced))` or `.font(.body.monospacedDigit())` so digits don't shift width.
      Confirm by: `grep -nE 'monospacedDigit' --include='*.swift' desktopAhaan/`
      Failure mode: Score counter jitters as digits change width.

---

## Category 80 — Onboarding & FTUE

### 80.1 Welcome sheet

- [ ] 80.1.1 — WelcomeSheet is dismissible by `Esc` or `Let's go` button.
      Confirm by: read `WelcomeSheet` in `ContentView.swift`.
      Failure mode: Sheet traps user.

### 80.2 No permission at launch

- [ ] 80.2.1 — Permission prompts only fire on user action, not on welcome.
      Confirm by: launch fresh and observe.
      Failure mode: Speech permission at launch.

### 80.3 Restartable welcome

- [ ] 80.3.1 — Setting `hasSeenWelcome = false` from Settings shows the welcome flow again.
      Confirm by: read settings + AppStorage key.
      Failure mode: Onboarding unrepeatable.

---

## Category 81 — Help & documentation

### 81.1 In-app Help

- [ ] 81.1.1 — Help menu has at least: Keyboard Shortcuts, Reveal Crash Logs in Finder, Clear Crash Logs.
      Confirm by: open menu.
      Failure mode: Help menu empty.

### 81.2 Tooltips

- [ ] 81.2.1 — Novel controls (Discover scene widgets) have `.help("...")` tooltips.
      Confirm by: `grep -nE '\.help\(' --include='*.swift' desktopAhaan/`
      Failure mode: User can't discover what a widget does.

### 81.3 About box

- [ ] 81.3.1 — About box shows version + bundle ID + a one-line description.
      Confirm by: ⌘+About.
      Failure mode: About box missing or default.

---

## Category 82 — Settings / Preferences

### 82.1 Defaults sane

- [ ] 82.1.1 — Fresh install defaults: `preferOffline = false`, `speechRate = 0.9`, `speechLanguage = "en-IN"`.
      Confirm by: read `SettingsManagerTests.swift`.
      Failure mode: Defaults that don't match the user's market.

### 82.2 Migration on update

- [ ] 82.2.1 — Settings schema version is bumped only when fields are removed/renamed.
      Confirm by: see `currentSchemaVersion` in DataStore.
      Failure mode: User loses settings on update.

### 82.3 Reset to defaults

- [ ] 82.3.1 — Settings UI offers a "Reset to defaults" affordance.
      Confirm by: open Settings.
      Failure mode: No escape from a broken settings state.

### 82.4 Validation

- [ ] 82.4.1 — `speechRate` clamped to `[0.5, 1.5]` on write; out-of-range input silently clamped.
      Confirm by: read SettingsManager setter for speechRate.
      Failure mode: Speech rate of 0 freezes TTS.

### 82.5 Surfaced a11y toggles

- [ ] 82.5.1 — Settings surfaces a "Reduce motion in lessons" toggle if it adds value beyond the system one.
      Confirm by: read Settings UI.
      Failure mode: Kid can't disable animations from the app.
- [ ] 82.5.2 — Settings surfaces a sound-effects mute toggle.
      Confirm by: see 96.2.1.
      Failure mode: SFX in quiet classroom.

### 82.6 Per-subject vs global

- [ ] 82.6.1 — Toggles like "preferOffline" apply globally; per-subject ones (if any) are namespaced.
      Confirm by: read SettingsManager structure.
      Failure mode: A subject-specific setting bleeds across subjects.

---

## Category 83 — Content quality — factual

### 83.1 NCERT alignment

- [ ] 83.1.1 — Every Ch.1 concept matches the NCERT Class 7 Science textbook (Chapter 1 — Nutrition in Plants).
      Confirm by: compare side-by-side with the book.
      Failure mode: Kid learns wrong facts from the app.

### 83.2 Cross-chapter consistency

- [ ] 83.2.1 — Terms defined in one chapter are used consistently in others.
      Confirm by: glossary scan.
      Failure mode: Photosynthesis defined two different ways.

### 83.3 No contradictions

- [ ] 83.3.1 — No "Beyond the Book" callout contradicts an in-textbook fact.
      Confirm by: read every Beyond article.
      Failure mode: Subtle inconsistency.

### 83.4 Citations

- [ ] 83.4.1 — Where Beyond-the-Book makes a claim that goes outside the textbook, it cites a source.
      Confirm by: visual audit articles.
      Failure mode: Unsourced claim might be wrong.

### 83.5 Diagrams accurate

- [ ] 83.5.1 — Every diagram (e.g. photosynthesis equation) matches the canonical form in the textbook.
      Confirm by: side-by-side compare.
      Failure mode: Kid learns wrong equation.

### 83.6 Math notation

- [ ] 83.6.1 — Math symbols (×, ÷, π, √) display correctly across Light/Dark and Dynamic Type sizes.
      Confirm by: open a math-heavy article.
      Failure mode: Missing glyph.

---

## Category 84 — Content quality — pedagogy

### 84.1 Vocabulary level

- [ ] 84.1.1 — `scripts/check_callout_reading_level.py` keeps callouts at Class-7-appropriate reading level.
      Confirm by: run the script.
      Failure mode: Article unreadable.

### 84.2 Indian context

- [ ] 84.2.1 — Examples reference Indian flora/fauna/locations where natural (e.g. neem, mango, monsoon, deserts of Rajasthan).
      Confirm by: read chapter articles.
      Failure mode: Pure US-centric examples feel foreign.

### 84.3 Exam-relevance flagging

- [ ] 84.3.1 — Concepts that recur in NEET/JEE are flagged as "you'll see this again".
      Confirm by: see cross-chapter bridge callout feature.
      Failure mode: No bridge to higher classes.

---

## Category 85 — Content quality — visual

### 85.1 Diagram clarity

- [ ] 85.1.1 — Every SVG diagram in chapter articles has a title + description for VoiceOver.
      Confirm by: read SVG metadata.
      Failure mode: Diagrams meaningless to VoiceOver users.

### 85.2 Color-only signalling

- [ ] 85.2.1 — Critical information is never conveyed by color alone (also has shape, text, or icon).
      Confirm by: visual audit of any green/red signal.
      Failure mode: Colorblind kid can't read.
- [ ] 85.2.2 — Quiz correct/incorrect uses ✓ / ✗ icon in addition to green/red.
      Confirm by: walk a quiz question.
      Failure mode: Colorblind kid sees no clear signal.

### 85.3 Hotspot accuracy

- [ ] 85.3.1 — Every interactive hotspot on a Discover scene SVG has a tap target ≥ 44pt.
      Confirm by: visual audit Discover scenes.
      Failure mode: Hard to tap a hotspot.
- [ ] 85.3.2 — Hotspots have alt text describing what they reveal.
      Confirm by: VoiceOver walk.
      Failure mode: Hotspots invisible to VoiceOver.

### 85.4 Alt text on SVG

- [ ] 85.4.1 — Every bundled `.svg` has `<title>` and `<desc>` elements for screen readers.
      Confirm by: grep SVGs for `<title>`.
      Failure mode: VoiceOver says "Image" only.

---

## Category 86 — Theming & appearance

### 86.1 Dark/Light/Auto

- [ ] 86.1.1 — App respects System Settings → Appearance choice without restart.
      Confirm by: toggle setting mid-session.
      Failure mode: App locks to one mode.

### 86.2 Increase Contrast toggle

- [ ] 86.2.1 — See 28.3.1.
      Confirm by: see 28.3.
      Failure mode: Same.

### 86.3 Per-window appearance

- [ ] 86.3.1 — All windows share the same appearance; no rogue light window in dark mode.
      Confirm by: open every window in dark mode.
      Failure mode: Inconsistent appearance.

---

## Category 87 — Animation polish

### 87.1 Timing curves

- [ ] 87.1.1 — Consistent timing curves (e.g. `.easeInOut`) across analogous animations.
      Confirm by: `grep -nE '\.animation\(\.' --include='*.swift' desktopAhaan/`
      Failure mode: Janky-feeling motion.

### 87.2 Interruption handling

- [ ] 87.2.1 — Tapping during an animation cancels it and starts the new state cleanly.
      Confirm by: tap mid-animation.
      Failure mode: Animations overlap; janky.

### 87.3 Loop bounds

- [ ] 87.3.1 — Looping animations have explicit `.repeatCount` or are gated by HardwareTier.
      Confirm by: `grep -nE 'repeatForever' --include='*.swift' desktopAhaan/`
      Failure mode: Forever-loop burns battery.
- [ ] 87.3.2 — `repeatForever(autoreverses: true)` paired with `respectReduceMotion(animation:)`.
      Confirm by: visual audit of `.repeatForever` sites.
      Failure mode: Animation still runs with Reduce Motion ON.

### 87.4 Restart from background

- [ ] 87.4.1 — When the window returns from background, animations resume from their last frame, not restart.
      Confirm by: minimize during animation, restore.
      Failure mode: Visual glitch on return.

### 87.5 Reduce-Motion routing uniformity

- [ ] 87.5.1 — Every animation site uses the helper from `36ad98b`, no inline `Animation.easeInOut` constants.
      Confirm by: search inline animation literals.
      Failure mode: One animation slips the Reduce-Motion gate.

---

## Category 88 — Plugin / scale architecture

### 88.1 SubjectPlugin invariants

- [ ] 88.1.1 — Every concrete `SubjectPlugin` implementation conforms to the protocol completely (no missing required members).
      Confirm by: search for `SubjectPlugin` protocol + conformers.
      Failure mode: Compile-time missing implementations forced via fatalError.

### 88.2 ChapterManifest

- [ ] 88.2.1 — Manifest contains entries for every chapter present on disk; absence triggers `generate_chapter_manifest.py`.
      Confirm by: `python3 scripts/generate_chapter_manifest.py --check`
      Failure mode: A chapter exists but doesn't appear in the list.

### 88.3 Registry race

- [ ] 88.3.1 — `SubjectRegistry.loadAll()` is idempotent against concurrent calls.
      Confirm by: read the load method.
      Failure mode: Double-load duplicates packs.

### 88.4 Namespacing

- [ ] 88.4.1 — Persisted state keyed by `(subjectId, chapterId)` so two subjects can't collide on a key.
      Confirm by: read `AppStorageKeys` enum.
      Failure mode: Sanskrit progress overwrites Science progress.

---

## Category 89 — Release plumbing

### 89.1 Bundle ID

- [ ] 89.1.1 — Bundle ID `com.emoha.desktopAhaan` stable across configs.
      Confirm by: `grep -nE 'PRODUCT_BUNDLE_IDENTIFIER' desktopAhaan.xcodeproj/project.pbxproj`
      Failure mode: Bundle ID drift breaks UserDefaults migration.

### 89.2 Version discipline

- [ ] 89.2.1 — Marketing version and current project version bump together at each release; no PRs land with version-only changes.
      Confirm by: visual audit.
      Failure mode: Version 1.0 for a year; can't tell what's shipped.

### 89.3 Changelog

- [ ] 89.3.1 — `CHANGELOG.md` or release notes file maintained per minor version.
      Confirm by: `ls CHANGELOG*`
      Failure mode: User has no idea what changed.

### 89.4 Rollback story

- [ ] 89.4.1 — Documented rollback procedure (re-install previous .app, settings backward-compatible).
      Confirm by: read release docs.
      Failure mode: A bad release strands users.

### 89.5 Force-update prompts

- [ ] 89.5.1 — N/A — no force-update; document explicit decision.
      Confirm by: search for `forceUpdate`.
      Failure mode: Not applicable.

### 89.6 Build number monotone

- [ ] 89.6.1 — `CURRENT_PROJECT_VERSION` is monotonically increasing per release.
      Confirm by: read pbxproj.
      Failure mode: Update silently doesn't update.

---

## Category 90 — Update mechanism

### 90.1 Sparkle (if any)

- [ ] 90.1.1 — N/A — no auto-update mechanism documented.
      Confirm by: search for Sparkle / SUFeed.
      Failure mode: Not applicable.

### 90.2 Manual update

- [ ] 90.2.1 — Documented manual-update procedure (download new .app, drag to Applications).
      Confirm by: read README.
      Failure mode: Family doesn't know how to update.

---

## Category 91 — AppleScript / Automation

### 91.1 sdef

- [ ] 91.1.1 — N/A — no AppleScript scripting bridge.
      Confirm by: `find . -name '*.sdef'`
      Failure mode: Not applicable.

---

## Category 92 — Telemetry sanity

### 92.1 Outbound zero

- [ ] 92.1.1 — See 47.1.1.
      Confirm by: see 47.1.
      Failure mode: Same.

### 92.2 No analytics SDK

- [ ] 92.2.1 — Zero matches for `Firebase`, `Amplitude`, `Mixpanel`, `Segment`, `Sentry`, `Bugsnag` in Swift sources.
      Confirm by: `grep -rnE 'Firebase|Amplitude|Mixpanel|Segment|Sentry|Bugsnag' --include='*.swift' desktopAhaan/`
      Failure mode: Hidden tracker.

---

## Category 93 — Help recovery / safe mode

### 93.1 Post-crash launch

- [ ] 93.1.1 — After a recorded crash, next launch reads the absence of the clean-quit marker and surfaces a "Help → Reveal Crash Logs" affordance.
      Confirm by: read CrashReporter behavior + Help menu.
      Failure mode: Kid restarts and forgets the crash.

### 93.2 Factory reset

- [ ] 93.2.1 — Settings exposes a "Factory reset" that clears AppSupport + UserDefaults.
      Confirm by: search for `Factory` / reset action.
      Failure mode: A corrupted state has no recovery path.

---

## Category 94 — Edge inputs

### 94.1 Very long text

- [ ] 94.1.1 — Translator input field accepts up to 10K characters without freezing.
      Confirm by: paste long string.
      Failure mode: UI freeze.

### 94.2 Emoji clusters

- [ ] 94.2.1 — Emoji clusters render correctly in translator output.
      Confirm by: type 👨‍👩‍👧‍👦.
      Failure mode: Broken cluster display.

### 94.3 RTL / LTR mix

- [ ] 94.3.1 — RTL text inside an LTR Devanagari context displays correctly.
      Confirm by: paste Arabic into translator.
      Failure mode: Mirrored layout / garbled.

### 94.4 Control characters

- [ ] 94.4.1 — Tab, newline, NUL in user input doesn't break the parser.
      Confirm by: paste a NUL char.
      Failure mode: String truncation.

---

## Category 95 — Time-bounded UI

### 95.1 Boss Quiz timer

- [ ] 95.1.1 — Timer survives app backgrounding and resumes correctly.
      Confirm by: minimize during quiz.
      Failure mode: Timer cheating possible.

### 95.2 Daily practice cooldown

- [ ] 95.2.1 — Daily practice resets at midnight in local TZ.
      Confirm by: see 75.1.1.
      Failure mode: Cooldown wrong by hours.

### 95.3 Anti-cheese

- [ ] 95.3.1 — Closing and reopening Boss Quiz mid-attempt does not let the kid try again with full timer.
      Confirm by: close + reopen test.
      Failure mode: Cheating possible.

---

## Category 96 — Game-feel polish

### 96.1 Haptics

- [ ] 96.1.1 — macOS — N/A on most desktops; document.
      Confirm by: documented in design.
      Failure mode: Not applicable.

### 96.2 Sound effects

- [ ] 96.2.1 — Sound effects on correct/incorrect can be muted in Settings.
      Confirm by: read settings toggle.
      Failure mode: SFX in a quiet classroom.

### 96.3 Completion celebrations

- [ ] 96.3.1 — Chapter completion shows the certificate-export affordance.
      Confirm by: complete a chapter (or use the test pack).
      Failure mode: Completion has no celebration.
- [ ] 96.3.2 — `AllChaptersCompleteOverlay` shows once when the whole subject is done.
      Confirm by: read `Views/Components/AllChaptersCompleteOverlay.swift`.
      Failure mode: No celebration for the marathon.

### 96.4 Encouraging copy

- [ ] 96.4.1 — Incorrect-answer copy is gentle ("Try again", not "Wrong!").
      Confirm by: visual audit.
      Failure mode: Discouraging tone.

### 96.5 Certificate render

- [ ] 96.5.1 — Certificate PDF includes kid's name (from settings), date, chapter title.
      Confirm by: trigger export.
      Failure mode: Generic certificate; no personalization.

---

## Category 97 — Cross-chapter integrity

### 97.1 "You'll see this again" links

- [ ] 97.1.1 — Every cross-chapter callout resolves to a real chapter ID.
      Confirm by: `python3 scripts/check_pack_schema.py` (covers ref integrity).
      Failure mode: Dead link.

### 97.2 Dead-link flag

- [ ] 97.2.1 — `SubjectPack.validateRelatedRefs()` logs DATA entries for any orphan ref.
      Confirm by: see 18.2.1.
      Failure mode: Silent dead link.

---

## Category 98 — JSON pack pipeline

### 98.1 ContentPipeline scripts

- [ ] 98.1.1 — `scripts/generate_missing_articles.py`, `inject_questions.py`, `verify_pack_roundtrip.py` are idempotent.
      Confirm by: run twice; outputs identical.
      Failure mode: Non-determinism in content build.

### 98.2 Schema validation

- [ ] 98.2.1 — `scripts/check_pack_schema.py` is a pre-commit gate when pack JSON changes.
      Confirm by: read pre-commit hook.
      Failure mode: Bad pack lands.

### 98.3 Build-time bundle verification

- [ ] 98.3.1 — A build phase or test asserts every pack file is in the app bundle resources.
      Confirm by: read pbxproj Resources phase + bundle URL search.
      Failure mode: Pack ships but isn't bundled.

---

## Category 99 — Documentation hygiene

### 99.1 README accuracy

- [ ] 99.1.1 — README describes build/run/test procedures accurately.
      Confirm by: read README.md.
      Failure mode: Stale README; new contributor blocked.

### 99.2 docs/ folder

- [ ] 99.2.1 — `docs/ISSUE_CATEGORIES.md` taxonomy current — every row has up-to-date status.
      Confirm by: read it.
      Failure mode: Stale taxonomy misleads.

### 99.3 CRASH_LEDGER accuracy

- [ ] 99.3.1 — Every C-row entry's "fix" SHA is accurate.
      Confirm by: `git log <sha>` for each cited SHA.
      Failure mode: Misattribution misleads remediation.

### 99.4 REMEDIATION_LOG accuracy

- [ ] 99.4.1 — Every "deferred" item has a documented reason; iterations match git log.
      Confirm by: cross-check with `git log --oneline`.
      Failure mode: Drift between log and reality.

### 99.5 DEEP_SCAN_RESULTS

- [ ] 99.5.1 — Current snapshot reflects state at the top-of-main SHA.
      Confirm by: read DEEP_SCAN_RESULTS.md timestamp.
      Failure mode: Stale snapshot guides wrong fixes.

### 99.6 STOP_AND_ASK

- [ ] 99.6.1 — Each open question has an explicit owner.
      Confirm by: read STOP_AND_ASK.md.
      Failure mode: Question lingers forever.

### 99.7 docs/ISSUE_CATEGORIES.md

- [ ] 99.7.1 — Every category A–Y has a status row that matches reality.
      Confirm by: read the file and cross-check.
      Failure mode: Audit chases issues already closed.

---

## Category 100 — Developer ergonomics

### 100.1 Build time

- [ ] 100.1.1 — Cold build (clean DerivedData) on Apple Silicon Xcode 15+ completes in < 90s.
      Confirm by: time `xcodebuild build`.
      Failure mode: Slow iteration loop.

### 100.2 Incremental cost

- [ ] 100.2.1 — Single-file edit re-builds in < 15s incremental.
      Confirm by: edit + time.
      Failure mode: Slow inner loop.

### 100.3 Scheme variants

- [ ] 100.3.1 — `desktopAhaan` (default) + `desktopAhaan-ThreadSanitizer` + `desktopAhaanUITests` (added via target) all documented.
      Confirm by: `xcodebuild -list`.
      Failure mode: Devs use the wrong scheme.

### 100.4 Scripts discoverable

- [ ] 100.4.1 — `scripts/` folder has a README or per-script docstring.
      Confirm by: `ls scripts/`.
      Failure mode: New contributor doesn't know what each script does.

### 100.5 CONTRIBUTING / CLAUDE.md

- [ ] 100.5.1 — `CLAUDE.md` covers the working agreement for AI agents (deploy target, common gotchas, conventional commits).
      Confirm by: read `CLAUDE.md`.
      Failure mode: AI agent re-introduces a banned pattern.
- [ ] 100.5.2 — `memory/` directory carries durable context across sessions per `CLAUDE.md`.
      Confirm by: `ls memory/`.
      Failure mode: AI agent loses repo context.

### 100.6 iMac pull script

- [ ] 100.6.1 — `scripts/imac-pull.sh` is bulletproof (quits Xcode, stashes pbxproj edits, pulls, clears DerivedData, reopens).
      Confirm by: read the script.
      Failure mode: Pull on iMac corrupts pbxproj.

### 100.7 Local DerivedData hygiene

- [ ] 100.7.1 — DerivedData lives at `${TMPDIR}/desktopAhaan-ci-derived` to avoid the `~/Documents` fileprovider tree issue (per `2831646`).
      Confirm by: read `scripts/ci-build-test.sh`.
      Failure mode: Codesign fails with "resource fork" detritus.

---

## Category 101 — Pasteboard / Drag-Drop UTIs (extension of 52)

### 101.1 UTI registration

- [ ] 101.1.1 — `Info.plist`'s `CFBundleDocumentTypes` only lists UTIs the app actually handles.
      Confirm by: read Info.plist `CFBundleDocumentTypes`.
      Failure mode: Finder offers desktopAhaan as a default for files it can't open.

---

## Category 102 — NSResponder chain hygiene

### 102.1 First responder

- [ ] 102.1.1 — Translator input field becomes first responder on screen appearance.
      Confirm by: open translator, observe focus.
      Failure mode: Kid has to click before typing.

### 102.2 Responder cleanup

- [ ] 102.2.1 — Closing a sheet returns first responder to a sensible target in the parent view.
      Confirm by: ⌘W after Beyond, observe Tab destination.
      Failure mode: Tab goes to nothing.

---

## Category 103 — NSFormatter usage

### 103.1 Validation

- [ ] 103.1.1 — Any custom `Formatter` in the app validates input range (e.g. min/max) and shows a clear error.
      Confirm by: `grep -nE 'class.*: Formatter' --include='*.swift' desktopAhaan/`
      Failure mode: Bad input silently rejected.

---

## Category 104 — Sandbox profile compliance

### 104.1 No prohibited APIs

- [ ] 104.1.1 — App does not call `system()`, `popen()`, `NSTask`, `Process` (sandbox would block).
      Confirm by: `grep -nE 'system\(|popen\(|NSTask|Process\(' --include='*.swift' desktopAhaan/`
      Failure mode: Sandbox violation at runtime.

### 104.2 Microphone scope

- [ ] 104.2.1 — Microphone entitlement is the only privacy-sensitive grant.
      Confirm by: read entitlements file.
      Failure mode: Over-broad permissions.

---

## Category 105 — Build product validation

### 105.1 Bundle structure

- [ ] 105.1.1 — Built `.app` bundle contains `Contents/MacOS/desktopAhaan`, `Contents/Resources/{packs.json}`, `Contents/Info.plist`.
      Confirm by: `find /tmp/dd-desktopAhaan/Build/Products/Debug/desktopAhaan.app -maxdepth 3 -type f`
      Failure mode: Missing resource → runtime error.

### 105.2 Embedded frameworks

- [ ] 105.2.1 — `Contents/Frameworks/` contains only Swift stdlib + system Frameworks (no third-party).
      Confirm by: `ls /tmp/dd-desktopAhaan/Build/Products/Debug/desktopAhaan.app/Contents/Frameworks/`
      Failure mode: Hidden dependency.

### 105.3 Code-signature integrity

- [ ] 105.3.1 — `codesign --verify --deep --strict desktopAhaan.app` reports no errors.
      Confirm by: run the command.
      Failure mode: Gatekeeper blocks launch.

### 105.4 Pack JSON in bundle

- [ ] 105.4.1 — `sanskrit_class7.json` + `science_class7.json` present at `Contents/Resources/`.
      Confirm by: `ls desktopAhaan.app/Contents/Resources/*.json`
      Failure mode: App launches but no subjects load.

### 105.5 Info.plist sanity

- [ ] 105.5.1 — Built `Info.plist` has `CFBundleIdentifier == com.emoha.desktopAhaan`, `LSMinimumSystemVersion = 11.0`.
      Confirm by: `defaults read desktopAhaan.app/Contents/Info`
      Failure mode: Mismatched bundle ID breaks UserDefaults migration.

---

## Category 106 — Subject-pack JSON authoring

### 106.1 ID stability

- [ ] 106.1.1 — Chapter IDs (`ch01_*`, `ch07_*`) follow `ch<NN>_<topic>` convention without renames once shipped.
      Confirm by: read sample pack.
      Failure mode: Renamed ID loses per-chapter progress.
- [ ] 106.1.2 — Concept IDs are stable across content edits.
      Confirm by: diff packs across versions.
      Failure mode: Recents and related-links break.

### 106.2 Required fields

- [ ] 106.2.1 — Every `Question` has `id`, `prompt`, and at least one `variation`.
      Confirm by: `python3 scripts/check_pack_schema.py`
      Failure mode: Decode failure or empty quiz.
- [ ] 106.2.2 — Every `Variation` has `id`, `answer`, `solutionSteps`.
      Confirm by: same script.
      Failure mode: Variation without solution shows no explanation.

### 106.3 Cross-refs

- [ ] 106.3.1 — `relatedConceptIds` references the same pack's concepts (or explicitly other pack with `pack:<id>` prefix if supported).
      Confirm by: SubjectPack.validateRelatedRefs at load.
      Failure mode: Orphan ref.

### 106.4 Difficulty tagging

- [ ] 106.4.1 — Question difficulty is one of the documented enum values (no typos).
      Confirm by: check_pack_schema.py
      Failure mode: Decode fails on unknown enum.

---

## Category 107 — OS upgrade story

### 107.1 macOS 11 → 12 transition

- [ ] 107.1.1 — If the iMac is upgraded to macOS 12+, the existing build still runs unmodified (target stays at 11.0).
      Confirm by: deploy unchanged build to a macOS 12+ machine.
      Failure mode: App refuses to launch.

### 107.2 macOS 15+ runtime tests

- [ ] 107.2.1 — Build that targets 11.0 still runs cleanly on macOS 15 on Apple Silicon dev Mac.
      Confirm by: launch on dev Mac.
      Failure mode: Runtime warnings or symbol-missing on newer macOS.

### 107.3 Xcode version drift

- [ ] 107.3.1 — Project opens in both Xcode 13.2.1 (iMac) and the latest Xcode (dev Mac) without auto-edit prompts that change pbxproj.
      Confirm by: open in both, check `git status`.
      Failure mode: Open-in-Xcode causes spurious pbxproj edits.

---

## Category 108 — Sanitizer correctness

### 108.1 ASan clean

- [ ] 108.1.1 — Walking every CTA under ASan produces zero `heap-use-after-free`, `heap-buffer-overflow`, `stack-use-after-scope`.
      Confirm by: full CTA walker run under `desktopAhaan.xcscheme` (ASan enabled).
      Failure mode: A latent UAF lurks until production.
- [ ] 108.1.2 — Boss Quiz timer + Discover scene animations + article open/close: 3 minutes per surface under ASan with zero findings.
      Confirm by: stopwatch + walker.
      Failure mode: Long-running animation reveals UAF.

### 108.2 NSZombieEnabled clean

- [ ] 108.2.1 — Walking every CTA under NSZombieEnabled produces zero `*** -[<Class> <selector>]: message sent to deallocated instance` lines.
      Confirm by: scheme env set, walk.
      Failure mode: Over-release surfaces only on the iMac.
- [ ] 108.2.2 — Beyond → ⌘W → Try Discover walked 10× in a row produces zero zombie lines (this is the C2 lineage).
      Confirm by: scripted walk.
      Failure mode: Intermittent C2 returns.

### 108.3 TSan clean

- [ ] 108.3.1 — Walking every CTA under `desktopAhaan-ThreadSanitizer.xcscheme` produces zero data-race reports.
      Confirm by: scheme run, walk.
      Failure mode: Concurrent races silently corrupt state.
- [ ] 108.3.2 — Dictation + simultaneous TTS does not race (TSan clean).
      Confirm by: dictate while TTS running.
      Failure mode: Audio session race.

### 108.4 MissingPools telemetry

- [ ] 108.4.1 — `OBJC_DEBUG_MISSING_POOLS = YES` chatter limited to known SwiftUI internal threads.
      Confirm by: stderr from sanitizer-scheme launch.
      Failure mode: New "missing pool" in user code → memory leak.

### 108.5 MallocStackLogging interpretation

- [ ] 108.5.1 — `malloc_history` symbolicates app addresses (dSYM available).
      Confirm by: `malloc_history <pid> <address>`
      Failure mode: Crash backtraces unsymbolicated.

---

## Category 109 — Shared sheet kind enum

### 109.1 SheetKind enum

- [ ] 109.1.1 — `ChapterDetailView.SheetKind` enumerates every modal flow with one stable case per flow.
      Confirm by: read SheetKind definition.
      Failure mode: A new sheet added without case → not collapsable in the single .sheet(item:).

### 109.2 Identifiable conformance

- [ ] 109.2.1 — Every SheetKind case has a stable `id` (the case name or an associated stable string).
      Confirm by: read SheetKind's Identifiable conformance.
      Failure mode: Dismount + remount race.

### 109.3 Top-level sheets

- [ ] 109.3.1 — `ContentView` has a parallel `SheetKind` enum for top-level modal flow.
      Confirm by: read ContentView.
      Failure mode: Multiple top-level sheets race.

---

## Category 110 — Plugin / scale architecture (extension of 88)

### 110.1 Generic fallback

- [ ] 110.1.1 — A chapter with no specific Discover scene falls back to a generic chapter view.
      Confirm by: read ChapterPlugin / ChapterManifest.
      Failure mode: New chapter without scene crashes navigation.

### 110.2 Per-subject persistence namespace

- [ ] 110.2.1 — Persisted state keys include the subject ID prefix; cross-subject state isolation.
      Confirm by: read `AppStorageKeys` enum and DataStore keys.
      Failure mode: Sanskrit progress overwrites Science.

### 110.3 SubjectPlugin registration

- [ ] 110.3.1 — Adding a new subject is a single-file addition (Plugins/ + a JSON pack).
      Confirm by: read `Subjects/Plugins/` for registration pattern.
      Failure mode: Multi-file changes required → high-friction.

### 110.4 ChapterManifest correctness

- [ ] 110.4.1 — `scripts/generate_chapter_manifest.py` is idempotent + checked in CI.
      Confirm by: re-run script.
      Failure mode: Drift between manifest and content.

---

## Category 111 — Walkthrough audit

### 111.1 CTA walker

- [ ] 111.1.1 — A scriptable CTA walker visits Sidebar → every Subject → every Chapter → every Topic → every Concept → every Question.
      Confirm by: walker test exists.
      Failure mode: Manual coverage gaps.

### 111.2 Coverage matrix

- [ ] 111.2.1 — `scripts/coverage_matrix.py` produces a per-chapter coverage table that's checked in to docs.
      Confirm by: run + inspect.
      Failure mode: Coverage gaps invisible.

### 111.3 Audit pack health

- [ ] 111.3.1 — `scripts/audit_pack_health.py` reports orphan refs, duplicate IDs, missing solution steps.
      Confirm by: run.
      Failure mode: Bad pack ships.

---

## Category 112 — Crash-handler ergonomics

### 112.1 Crashlog readability

- [ ] 112.1.1 — Per-day crashlog includes timestamp, exception/signal, top frames, and recovery breadcrumb.
      Confirm by: read a sample crashlog.
      Failure mode: Crashlog opaque.

### 112.2 Symbol resolution offline

- [ ] 112.2.1 — `dwarfdump --uuid` of the built binary matches the dSYM, enabling offline symbolication.
      Confirm by: `dwarfdump --uuid desktopAhaan.app/Contents/MacOS/desktopAhaan`
      Failure mode: Crashlogs unreadable.

### 112.3 Recovery breadcrumbs

- [ ] 112.3.1 — Recovery breadcrumbs distinguish CRASH from normal QUIT events.
      Confirm by: read CrashReporter for RECOVERY entry kind.
      Failure mode: Can't tell crash from quit.

### 112.4 Crash backoff

- [ ] 112.4.1 — If the app crashes twice within 60s of launch, the third launch surfaces a "Safe mode" affordance.
      Confirm by: simulate.
      Failure mode: Crash loop spirals.

---

## Category 113 — Final acceptance gates

### 113.1 Pre-ship smoke

- [ ] 113.1.1 — Full app walk completes without warnings in Console.app filtered by `subsystem:com.emoha.desktopAhaan`.
      Confirm by: launch + walk under `log stream`.
      Failure mode: Hidden runtime warning.
- [ ] 113.1.2 — Final pre-push gate (`scripts/ci-build-test.sh`) green on the build that will ship.
      Confirm by: run the script.
      Failure mode: Ships broken state.
- [ ] 113.1.3 — Every lint script clean.
      Confirm by: run each `scripts/check_*.py`.
      Failure mode: Bypass to ship a lint failure.

### 113.2 iMac acceptance

- [ ] 113.2.1 — `scripts/imac-pull.sh` succeeds and the app launches without crash.
      Confirm by: run on iMac.
      Failure mode: iMac stranded behind.
- [ ] 113.2.2 — Beyond → ⌘W → Try Discover sequence runs clean 10× under the sanitizer scheme.
      Confirm by: manual.
      Failure mode: C2 returns silently.

### 113.3 Pack health

- [ ] 113.3.1 — `scripts/audit_pack_health.py` reports zero issues.
      Confirm by: run.
      Failure mode: Orphan ref in production.

### 113.4 Documentation freshness

- [ ] 113.4.1 — `CRASH_LEDGER.md` reflects current state.
      Confirm by: visual review.
      Failure mode: Misleading docs.
- [ ] 113.4.2 — `REMEDIATION_LOG.md` last-entry timestamp is within the same release.
      Confirm by: read top of file.
      Failure mode: Stale.

### 113.5 Source control

- [ ] 113.5.1 — `git status` clean.
      Confirm by: run.
      Failure mode: Uncommitted local changes ship.
- [ ] 113.5.2 — `git log origin/main..HEAD` is empty (everything pushed).
      Confirm by: run.
      Failure mode: Local-only commit gets lost on next pull.

### 113.6 Recovery readiness

- [ ] 113.6.1 — Documented procedure to restore from a corrupted persisted state (delete `~/Library/Application Support/desktopAhaan/`).
      Confirm by: read README / docs.
      Failure mode: Kid is stranded.

### 113.7 Sign-off

- [ ] 113.7.1 — Rohan has walked the full app on the iMac under the sanitizer scheme since the last code change.
      Confirm by: dated log entry.
      Failure mode: Untested state ships.

---

## Category 114 — Out-of-scope explicit declarations

### 114.1 Continuity / Handoff

- [ ] 114.1.1 — Not implemented; documented in README.
      Confirm by: search.
      Failure mode: Not applicable.

### 114.2 iCloud sync

- [ ] 114.2.1 — Not implemented; documented in README.
      Confirm by: search for `CKContainer`.
      Failure mode: Not applicable.

### 114.3 Multiuser / family sharing

- [ ] 114.3.1 — Single-user by design; not multi-account.
      Confirm by: design doc.
      Failure mode: Not applicable.

### 114.4 Network APIs beyond optional translator

- [ ] 114.4.1 — No analytics, no remote config, no push notifications.
      Confirm by: search.
      Failure mode: Not applicable.

### 114.5 In-app purchase

- [ ] 114.5.1 — Not implemented; explicitly documented.
      Confirm by: search StoreKit.
      Failure mode: Not applicable.

### 114.6 Multi-language UI

- [ ] 114.6.1 — Single-locale (en-IN) at v1; Hindi/regional UI strings planned for v2 but not in this audit.
      Confirm by: design doc.
      Failure mode: Not applicable for v1.

### 114.7 Background processing

- [ ] 114.7.1 — App does no background processing; closes cleanly when window closed via ⌘Q.
      Confirm by: read NSApplication.shared.terminate handling.
      Failure mode: Not applicable.

---

**Checklist generated.**
**Macro-categories:** 114
**Subcategories:** 451
**Total check-items:** 601
**File:** PRODUCTION_GRADE_AUDIT_CHECKLIST.md
**Next:** Rohan grilling sessions, one macro-category per session.

(See final summary at the bottom of this file after Category 114.)
