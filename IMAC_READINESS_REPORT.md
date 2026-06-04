# iMac Readiness Report — 2026-06-04 (full re-audit)

Target hardware: **Late-2014 iMac · macOS Big Sur 11.7.11 · Xcode 13.2.1 ·
Swift 5.5 · AMD Radeon R9 M290X 2 GB.**

This is a fresh, whole-codebase Big-Sur / Xcode-13.2.1 compatibility re-audit run
on the dev Mac (Xcode 26.5 / Swift 6 / SDK 26) covering everything since the last
report: **v6 Learning Journey, the UI-test sweep, v7 Discover Depth, v8
Longitudinal Insights, and the 534-MCQ Olympiad content run.**

## TL;DR
The codebase is **compatible with the iMac build to the fullest extent the dev
Mac can statically verify.** No sweeping fix was needed; nothing is statically
broken. The only true remaining confirmation is an actual iMac build (see §6).

## 1. Build-config markers (all correct for Xcode 13.2.1)
- `objectVersion = 55` in `project.pbxproj` — Xcode 13.2.1 opens it (≥70 would be too new). `scripts/generate_compat_pbxproj.py` is idempotent here (no diff).
- `MACOSX_DEPLOYMENT_TARGET = 11.5` (unchanged), `SWIFT_VERSION = 5.0` (Swift-5 language mode, what Xcode 13.2.1 uses).

## 2. Static compat lints — all clean
`check_macos12_apis`, `check_swift55_syntax`, `check_viewbuilder_limit`,
`check_mainactor_closure_refs`, `check_sf_symbols_compat`, `check_color_literals`,
`check_view_mainactor`, `check_file_size`, `check_lifetime_hazards`,
`check_test_target_compat` — **10/10 clean.**

## 3. Availability is comprehensively enforced (not just by lints)
`ci-build-test.sh` compiles the whole app at **deployment target 11.5**, so the
compiler itself rejects any *unguarded* macOS-12+ API (proven: a probe call to
`.foregroundStyle` errors "only available in macOS 14.0 or newer"). The build is
green → **no unguarded post-11.5 API calls exist anywhere in the app.** The few
genuine macOS-12 uses are correctly wrapped in `if #available(macOS 12, *)` with
Big-Sur fallbacks (`Extensions.swift`, `FreeOnlineTranslationProvider.swift`).
(The 1-parameter `onChange(of:perform:)` shows "deprecated in macOS 14" warnings
on the new SDK — that is the Big-Sur-correct form, not a problem.)

## 4. Deep sweeps beyond the lints
- **Post-Big-Sur SwiftUI/Foundation APIs** (whole tree): no `.task`, `Canvas`,
  `TimelineView`, `.regularMaterial`, `.tint(`, `.badge(`, SwiftUI `AttributedString`,
  `.formatted(`/`Date.now`, `Grid`/`GridRow`/`Gauge`, `NavigationStack`,
  `LabeledContent`, `ShareLink`, `ContentUnavailableView`, `presentationDetents`,
  `.scrollDisabled`, `@Observable`, `.searchable`/`.refreshable`/`.confirmationDialog`,
  `.symbolEffect`, `AsyncImage`, view-level `.bold()`, `.overlay(alignment:)`. All
  `NSAttributedString` uses are ancient AppKit (the article renderer deliberately
  avoids SwiftUI `AttributedString`).
- **Swift 5.6+/5.7+/5.9 syntax** that Xcode 13.2.1 (Swift 5.5) would reject: no
  `any` existential keyword, no `if`/`switch` expressions, no `#Preview` macro, no
  `consuming`/`borrowing`/`consume`, no primary-associated-types, no regex literals,
  no `some` in parameter position. **Clean.**

### False alarm resolved: `Font.monospacedDigit()`
~130 sites use `.font(.X.monospacedDigit())`. A code comment claimed this is
"macOS 12+". **It is not** — a compiler probe (`swiftc -typecheck -target
arm64-apple-macos11.5`) typechecks it cleanly, i.e. it is `@available(macOS 11)`.
These sites are Big-Sur-safe and were **correctly left untouched**. The misleading
comment in `Extensions.swift` was corrected so a future pass doesn't needlessly
migrate them.

## 5. The one residual risk the dev Mac CANNOT verify
The dev Mac builds against **SDK 26** with deployment target 11.5. It cannot
detect a symbol that exists in SDK 26 (annotated `@available(macOS 11)`) but was
**absent from the older SDK** shipped with Xcode 13.2.1 — nor compiler-version
quirks unique to Swift 5.5. These are rare and the curated lints cover the known
classes, but **only an actual iMac build is authoritative.**

## 6. How to confirm on the iMac (authoritative)
```
cd "/Users/ahaandahiya/Downloads/DesktopAhaan 4/desktopAhaan"
bash scripts/imac-pull.sh          # quits Xcode, stashes pbxproj, pulls, wipes DerivedData, reopens
# then in Xcode: Clean Build Folder (⇧⌘K) + Build, or:
bash scripts/ci-build-test.sh
# optional, with AX granted to the test runner:
CI_BUILD_TEST_FLAGS=--ui bash scripts/ci-build-test.sh
```
If anything is red, paste the compile/crash output back — it can be root-caused
and fixed within minutes (most likely an SDK-symbol gap per §5). If it builds
clean, the entire v6→Olympiad stack is confirmed authoritative-green on Big Sur.

## 7. Runtime crash / hang / main-thread / jank verification (every historical class)
Mined every prior iMac failure from `CRASH_LEDGER.md`, `ZOMBIE_LOG_FINDINGS.md`,
`docs/CRASH_DEEP_RESEARCH.md`, and the issue taxonomy, then verified each class's
guard is green AND not reintroduced by v6/UI-sweep/v7/v8/Olympiad:

| # | Historical failure (where it bit the iMac) | Guard | Current status |
|---|---|---|---|
| C1 | **Layout-recursion crash** — unbounded `GeometryReader` in a `ScrollView`/`LazyVStack` (AMD driver) | scene template + `Crash1_TryDiscoverMode_Ch1` | ✅ every new v7/v8 `GeometryReader` is frame-bounded (`.frame(height:…)`); manually verified sandboxes/tours/TrendChart |
| C2 | **Sync re-render collision crash** — sheet-dismiss + `nav.push` in one commit | defer via `presentDeferred`/`DispatchQueue.main.async`; `Crash_BeyondThenDiscover` | ✅ deferral intact in the coordinator + ChapterDetail; test present |
| C4 | **WebContent/XPC over-release** (WKWebView) | retired WKWebView → native `NSTextView` `.sheet` + ordered `dismantleNSView` | ✅ zero `WKWebView`/`WebContent` references remain |
| C3 | **Speech permission dialog blocking** launch/tests | `requestPermissions()` is a no-op under test | ✅ present |
| — | force-unwrap / `as!` / `try!` on runtime paths | B1/B2 lint | ✅ none (FoundationTutor-only pass) |
| — | `Dictionary(uniqueKeysWithValues:)` dup-key crash | gotcha/convention | ✅ zero uses |
| — | KVO / `NotificationCenter` observer leaks | `check_kvo_observer_leak`, `check_notificationcenter_leak` | ✅ clean |
| — | `Timer` retain (no `[weak self]`) | `check_lifetime_hazards` (LH004b) | ✅ clean (value-type-ViewModifier cases allowlisted) |
| — | tuple-keypath crash (`\.offset`/`\.element.*`) | race/deadlock lint | ✅ clean |

**Main-thread / hang / jank:**
- **Launch I/O is off-main.** `SubjectRegistry.reload()` and `DataStore.loadAllOffThread`
  decode JSON on `Task.detached(.userInitiated)` and publish via `MainActor.run`;
  `SanskritDictionary` is lazy + pre-warmed. No synchronous pack/store read blocks the
  main thread at launch.
- **No main-thread blocking primitives:** zero `DispatchQueue.main.sync`, zero
  `DispatchSemaphore`/`.wait()`, zero synchronous network (the sole egress is the
  opt-in `FreeOnlineTranslationProvider`, async).
- **AMD R9 M290X GPU:** particle counts + animation FPS gated on `HardwareTier.isLegacy`
  (I1/I2); every `withAnimation` routed through `withAnimationRespectingReduceMotion`
  (LH005b lint, empty allowlist); `Timer`s invalidate on disappear + `scenePhase` (I9).
- **Perf baselines:** `testPackDecodePerformance` (cold-launch decode) + per-render
  index caches guard regressions.

Net: **no known crash / hang / main-thread-block / jank class is reintroduced.** The
driver-specific crashes (C1/C2) only ever reproduced on the AMD R9 M290X, so the code
patterns are confirmed clean here but final proof is still the §6 iMac run.

## Honesty note
This audit makes the codebase *statically* as iMac-ready as possible from the dev
Mac. It does **not** prove a Big-Sur build — that claim can only be made after the
§6 iMac run.
