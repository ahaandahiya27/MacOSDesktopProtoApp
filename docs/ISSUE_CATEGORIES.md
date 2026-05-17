# desktopAhaan — Issue Categories (audit checklist)

A taxonomy of every kind of issue this macOS desktop SwiftUI app can have.
Used as a systematic remediation checklist — dig into each category, list
concrete instances, fix them, mark the category done. Status legend:

- ✅ category swept and current best-effort fix landed
- 🟡 partially addressed; known gaps remain
- ❌ not yet audited

Last status touch: 2026-05-17 (Claude session — Rohan's iMac stability sweep).

---

## A. Platform compatibility (Big Sur 11.7.11 / Xcode 13.2.1 / Swift 5.5)

| ID | Category | Status |
|----|----------|--------|
| A1 | Swift 5.5 ViewBuilder 10-child limit per closure | ✅ static audit clean, Group{} wraps where needed |
| A2 | No macOS 12+ APIs (`Bindable`, `Observable`, `.scrollPosition`, `Layout`, `.foregroundStyle`, `Charts`, …) | 🟡 swept; sweep again after any major view rewrite |
| A3 | No SF Symbols 3+/4+ names | ✅ 16 symbols routed through SFSymbolCompat |
| A4 | No `try!` / `as!` / `[i]!` in runtime paths | ✅ swept; only file is `FoundationTutor` shim (intentional) |
| A5 | x86_64 + arm64 universal binary | ❌ not verified — check build settings |
| A6 | Type-check timeout from complex SwiftUI expressions | ✅ static audit clean (Kaleidoscope refactor was the canary) |
| A7 | DerivedData hygiene across Xcode versions | ✅ `scripts/imac-pull.sh` handles |
| A8 | pbxproj auto-rewrites colliding on pull | ✅ stash recipe in `scripts/imac-pull.sh` |
| A9 | Big Sur Metal limitations (R9 M290X 2 GB) | 🟡 HardwareTier exists; particle budgets honour `isLegacy` |

## B. Runtime stability (crash safety)

| ID | Category | Status |
|----|----------|--------|
| B1 | Force unwraps (`!`) outside test code | ✅ none found in runtime paths |
| B2 | Force casts (`as!`) outside test code | ✅ none found |
| B3 | `fatalError(…)` outside dev-only shims | ✅ only in `FoundationTutor.swift` (AI shim) |
| B4 | `precondition(…)` / `assert(…)` reachable in prod | ✅ DiscoveryStepper.init no longer `precondition`s — soft-fails to CrashReporter.logDataIssue and pads/clips outputs |
| B5 | `Array.first!` / `Array[i]` without bounds check | ✅ swept |
| B6 | `Dictionary(uniqueKeysWithValues:)` (fatal on dup) | ✅ replaced with defensive `uniquingKeysWith:` |
| B7 | Threading: background `@Published` mutation | ✅ all service classes `@MainActor`; SubjectRegistry now actually decodes off-thread (was lying) |
| B8 | Retain cycles in escaping closures (missing `[weak self]`) | ✅ service-class callbacks all use `[weak self]`; View-struct Timer/asyncAfter blocks safe (struct = no class retention) |
| B9 | NSException uncaught handler | ✅ CrashReporter installed |
| B10 | POSIX fatal signals (SIGABRT/SEGV/BUS/ILL/FPE/PIPE) | ✅ CrashReporter handles all 6 |
| B11 | Auto-restart on crash | ❌ deferred — needs relauncher helper executable |
| B12 | Data-quality non-fatal logging (e.g., dup IDs) | ✅ `CrashReporter.logDataIssue` |

## C. State management

| ID | Category | Status |
|----|----------|--------|
| C1 | @State preservation across push/pop in TutorNavigation | ✅ `.id()` moved off root |
| C2 | @StateObject vs @ObservedObject ownership | ✅ swept; root views own (@StateObject), child views observe (@ObservedObject), shared singletons read via @ObservedObject — no inversions found |
| C3 | @EnvironmentObject lifecycle | ✅ AppState / SubjectRegistry / DataStore injected at app root; every leaf view reads via @EnvironmentObject; no per-screen re-injection |
| C4 | Sidebar selection persistence (UserDefaults) | ✅ in AppState |
| C5 | Window restoration (@SceneStorage) | ❌ not implemented — relaunch lands at root |
| C6 | Recent items persistence | ✅ JSON encoded in UserDefaults |
| C7 | Per-scene Discover completion persistence | ✅ DataStore.discoverProgress |
| C8 | Filter/search persistence across navigation | ✅ via C1 fix |
| C9 | Scroll position persistence | 🟡 SwiftUI keeps List state if identity is stable; verified for QuizBank, others need spot-check |
| C10 | pendingRoute one-shot consumption | ✅ in TutorNavigationContainer |
| C11 | Question siblings (Prev/Next) state | ✅ in TutorNavigationState |

## D. Navigation & routing

| ID | Category | Status |
|----|----------|--------|
| D1 | Back button always returns to caller | ✅ + RouteNotFoundView fallback for stale routes |
| D2 | Route to non-existent ID surfaces error, not blank | ✅ RouteNotFoundView + CrashReporter.logDataIssue |
| D3 | ⌘[ shortcut works | ✅ wired in TutorNavigationContainer |
| D4 | Sidebar selection survives quit/relaunch | ✅ persisted |
| D5 | Deep-link from CommandPalette | ✅ via pendingRoute |
| D6 | Multiple TutorNavigationContainer instances don't share `path` accidentally | ✅ each is its own @StateObject |
| D7 | Modal sheets dismiss cleanly | ✅ every .sheet has a Close/Cancel path; Welcome/KeyboardShortcuts/CommandPalette/AskFollowUp all reachable |
| D8 | Tab cycles focus on macOS | 🟡 default SwiftUI tab order; not manually overridden |
| D9 | Esc dismisses sheets/popovers | ✅ .keyboardShortcut(.cancelAction) on Welcome/KeyboardShortcuts/CommandPalette/AskFollowUp |
| D10 | Return activates primary button | ✅ .keyboardShortcut(.defaultAction) on Welcome and Topic-Detail primary CTAs |
| D11 | Arrow keys navigate lists | ❌ audit pending — default List behaviour relied upon |

## E. Search behaviour

| ID | Category | Status |
|----|----------|--------|
| E1 | Global Search shows source pack per result | ✅ Section header per pack |
| E2 | Global Search subject-scope toggle | ✅ "All / Science / Sanskrit" capsule row, hidden when only one pack loaded |
| E3 | QuizBank subject filter (chapter-id collision fix) | ✅ pack picker added |
| E4 | Debouncing of text input | ✅ 200 ms in SearchView |
| E5 | Diacritic & case insensitivity | ✅ `.caseInsensitive, .diacriticInsensitive` |
| E6 | Empty state UI | ✅ in both SearchView and QuizBank |
| E7 | Result ranking / relevance | ✅ score-based: title/prompt prefix (100) > contains (50) > body/answer (10-20) |
| E8 | Search clears properly on navigate | ✅ via C1 fix (state survives, user can clear) |
| E9 | Tokenization (multi-word queries) | ✅ AND-of-tokens — every whitespace-separated token must match; per-token scores summed |

## F. Data integrity

| ID | Category | Status |
|----|----------|--------|
| F1 | Concept IDs unique across pack | ✅ enforced by edf4c8b |
| F2 | Question IDs unique across pack | ✅ enforced by 44e284b |
| F3 | Concept-ID topic prefix matches parent topic | ✅ post edf4c8b |
| F4 | Question-ID topic prefix matches parent topic | 🟡 180 IDs use `ch##_topup_q##` (intentional bulk-load marker) instead of `ch##_t##_q##`; uniqueness still enforced via F2, no runtime impact |
| F5 | relatedConceptIds resolve | ✅ orphan removed |
| F6 | relatedQuestionIds resolve | ✅ 66 orphan refs pruned from science pack; SubjectPack.validateRelatedRefs() runs at load and logs any future orphans to CrashReporter |
| F7 | All four explanation depths populated | 🟡 spot-checked; bulk audit pending |
| F8 | useCases ≥ 3 per concept | 🟡 enforced by content pipeline; need re-audit |
| F9 | beyondTheBook non-empty | 🟡 spot-checked |
| F10 | pageRefs reasonable (within textbook page range) | ❌ not audited |
| F11 | JSON schema decoding `do/catch` (don't crash on malformed pack) | ✅ per-pack do/catch in SubjectRegistry.reload; failures pipe to CrashReporter.logDataIssue AND surface in Settings |

## G. Content coverage parity (science only — Sanskrit not in scope)

| ID | Category | Status |
|----|----------|--------|
| G1 | Each chapter has 3 topics in JSON | ✅ verified |
| G2 | Each topic has ≥ 2 concepts | ✅ verified |
| G3 | Each topic has ≥ 3 MCQs | ✅ ch07_t03 fixed |
| G4 | Each chapter has a DiscoveryWidget | ✅ all 18 chapters covered |
| G5 | Variant widget toolkit (Slider / Toggle / Stepper) | ✅ 3 variants shipped, 2 chapters demo |
| G6 | Article HTML coverage for every JSON concept | 🟡 most chapters; Ch5/6/7 t03 still no HTML |
| G7 | Looking-Ahead callouts coverage | 🟡 most scenes; need final pass |
| G8 | Try-At-Home callouts coverage | 🟡 most scenes |
| G9 | RelatedConcepts cross-chapter graph | 🟡 partially populated |
| G10 | Mnemonic / Memory Hook (M7) module | ❌ not yet implemented as a structured component |
| G11 | Diagram-with-Hotspots (M8) module | ❌ not yet implemented |
| G12 | Process Timeline (M9) module | ❌ not yet implemented |
| G13 | ChapterManifest auto-generated coverage matrix | ❌ matrix is hand-computed today |

## H. Accessibility

| ID | Category | Status |
|----|----------|--------|
| H1 | VoiceOver `.accessibilityLabel` on every interactive | 🟡 swept icon-only Buttons in SearchView, QuizBank, CommandPalette, ArticleBrowser, Favorites; bulk audit of Discover scenes still pending |
| H2 | `.accessibilityHint` where non-obvious | 🟡 |
| H3 | `.accessibilityValue` for stateful controls (sliders, pickers) | 🟡 some (DiscoveryWidget done) |
| H4 | Dynamic Type Large / xLarge no clipping | ❌ not tested |
| H5 | Reduce Motion respected on animations | 🟡 some scenes do, others assume default |
| H6 | Color-contrast both Light / Dark | ❌ not verified |
| H7 | Keyboard-only navigation full coverage | ❌ |
| H8 | Focus management across views | ❌ |
| H9 | `.accessibilityElement(children: …)` correctly groups | 🟡 some (DiscoveryWidget, RouteNotFoundView) |

## I. Performance

| ID | Category | Status |
|----|----------|--------|
| I1 | Particle counts capped on legacy GPU | ✅ HardwareTier.particleBudget |
| I2 | Animation FPS capped at 20 on legacy | ✅ HardwareTier.animationFPS |
| I3 | Long modifier chains causing type-check blowup | ✅ resolved |
| I4 | Large List → LazyVStack migration | ❌ Lists not yet converted |
| I5 | Image decoding off main thread | 🟡 only SF Symbols + emoji; no heavy bitmap loads |
| I6 | JSON parse on main thread (app launch) | 🟡 SubjectRegistry parses synchronously at startup; acceptable for size |
| I7 | App cold-launch time | ❌ not benchmarked |
| I8 | Memory footprint at idle | ❌ |
| I9 | Background Timer cleanup on scene disappear | ✅ all Timer.scheduledTimer usage routes through TimedSceneModifier or ParticleEmitter — both invalidate on disappear AND on scenePhase != .active |
| I10 | `.task` cancellation on view disappear | ✅ SwiftUI's `.task` auto-cancels on disappear; remaining `Task { @MainActor in … }` are intentional fire-and-forget (logger pre-warm, notification posts) |

## J. Theming & visual polish

| ID | Category | Status |
|----|----------|--------|
| J1 | Light + Dark mode both render | ❌ not systematically tested |
| J2 | Color tokens via `Color.compat*` instead of hex literals | 🟡 mostly compliant |
| J3 | Typography via `Theme.Typography.*` | 🟡 inconsistent — many raw `.font(.title2.bold())` calls |
| J4 | Layout at 1024×640 min window | 🟡 minWidth/minHeight lowered to 1024/640 (W1); visual verification at min size pending |
| J5 | Layout at 2560×1440 design canvas | ✅ primary test target |
| J6 | Layout at very-wide windows | 🟡 |
| J7 | SF Symbols 2 fallbacks for SF Symbols 3+ | ✅ |
| J8 | Padding / spacing consistency via DesignTokens | 🟡 partial |
| J9 | Empty / error / loading states styled | 🟡 SearchView has empty-state, RouteNotFoundView has error-state |
| J10 | Sheet sizes set explicitly (`.frame(minWidth:minHeight:)`) | ❌ |

## K. Offline & sandbox

| ID | Category | Status |
|----|----------|--------|
| K1 | Zero network calls in shipped paths | 🟡 ONE optional path — `FreeOnlineTranslationProvider`; disabled by Settings → "Dictionary Only" |
| K2 | All assets bundled | ✅ |
| K3 | No telemetry | ✅ |
| K4 | App Sandbox enabled | ✅ verified `com.apple.security.app-sandbox` ON |
| K5 | `network.client` entitlement state | ✅ ON, justified — only the online translation fallback needs it; documented in docs/SECURITY.md |
| K6 | `files.user-selected.read-only` state | ✅ ON, justified — required by OCR "Open Image…" command; documented |
| K7 | Writes scoped to Application Support | ✅ for progress + crash logs |

## L. Persistence & user data

| ID | Category | Status |
|----|----------|--------|
| L1 | Atomic writes for progress.json | ✅ verified — DataStore + CrashReporter both use `.atomic` |
| L2 | Bookmarks persisted | ✅ |
| L3 | Recent items persisted (≤8) | ✅ |
| L4 | Window frame restoration on relaunch | ✅ system default (`NSQuitAlwaysKeepsWindows`) restores last frame; sidebar selection separately via @AppStorage |
| L5 | Settings via @AppStorage | ✅ hasSeenWelcome + 19 per-chapter Discover cursors routed through `AppStorageKeys` registry; SettingsManager.shared backs the audio/locale settings |
| L6 | Crash log rotation (avoid unbounded growth) | ✅ 30-file cap + 1 MB per-day rotation |
| L7 | Migration on schema bump | ❌ no formal migration path |

## M. Input handling

| ID | Category | Status |
|----|----------|--------|
| M1 | TextField bounds (max length, prevent newlines) | ✅ translator 500c, OCR 2000c, AskFollowUp 500c; search boxes unbounded (intentional — short queries) |
| M2 | Slider bounds (range respected) | ✅ |
| M3 | Picker default selection invariant (never nil-on-required) | ✅ all pickers either bind to enum (Settings/QuizBank typeFilter/ReviewFilter/Concept depth/Sanskrit tab) or Optional with explicit "All" tag — no nil-on-required |
| M4 | Empty-query search shows guidance, not crash | ✅ |
| M5 | Drag/drop file handling (Sanskrit scan) | 🟡 needs verification |

## N. Sanskrit / translator specific

| ID | Category | Status |
|----|----------|--------|
| N1 | Devanagari font rendering | ✅ DevanagariFont modifier |
| N2 | Locale-aware text (Sanskrit pack uses `sa` locale) | ✅ DevanagariAwareFont |
| N3 | Online vs offline source disambiguation | ✅ |
| N4 | Practice mode flow | ❌ not audited this session |
| N5 | Translation history dedup | ❌ |
| N6 | Scan / OCR error handling | ❌ |

## O. Discover Mode

| ID | Category | Status |
|----|----------|--------|
| O1 | Scene1–8 completion tracking + Got-It button | ✅ |
| O2 | Boss Quiz scoring | ✅ |
| O3 | Animation timers cleanup on scene leave | ✅ `.timedScene` lifecycle |
| O4 | ReduceMotion fallback per scene | 🟡 most scenes; needs audit |
| O5 | ViewBuilder ≤10 per scene closure | ✅ |
| O6 | DiscoveryWidget injection per chapter | ✅ 18/18 chapters |
| O7 | DiscoveryToggle / DiscoveryStepper rollout (M2 variety) | 🟡 demo injections only; could expand |
| O8 | Cross-scene state preservation | 🟡 per `currentScene` AppStorage — works |

## P. Tutor / reading

| ID | Category | Status |
|----|----------|--------|
| P1 | Article HTML rendering (WKWebView) | 🟡 works; no security audit yet |
| P2 | Inline image handling | 🟡 |
| P3 | Hyperlinks within articles | ❌ |
| P4 | Print-style readability CSS | ✅ ch*_style.css per chapter |
| P5 | Concept ↔ Article binding via ArticleIndex | ✅ |

## Q. Menus, commands, shortcuts

| ID | Category | Status |
|----|----------|--------|
| Q1 | File menu disabled where appropriate | ❌ Open Image is enabled (correct) |
| Q2 | Help → desktopAhaan Help | 🟡 wired to a Notification but no in-app help yet |
| Q3 | Help → Reveal/Clear Crash Logs | ✅ |
| Q4 | Keyboard shortcut collisions | ✅ audited; resolved ⌘[ double-fire (menu Command + local Button both bound — local removed, menu posts notification that view observes) |
| Q5 | ⌘W closes window cleanly | 🟡 — single-window app, behaviour default |
| Q6 | ⌘Q flushes ProgressStore before quit | ✅ `applicationWillTerminate` hooks UserDefaults flush + clean-quit log; DataStore writes are already synchronous + atomic |
| Q7 | Menu enablement state | 🟡 |

## R. Logging & diagnostics

| ID | Category | Status |
|----|----------|--------|
| R1 | os.Logger usage with subsystem/category | ✅ |
| R2 | No `print()` in shipped runtime code | ✅ all runtime prints routed to Logger; only DEBUG-gated debugLog remains in SubjectRegistry |
| R3 | Verbose logging disabled by default | ✅ |
| R4 | Crash log format human-readable | ✅ |
| R5 | Data-issue logging (defensive Dictionary collisions) | ✅ |

## S. Build process & infra

| ID | Category | Status |
|----|----------|--------|
| S1 | Build with zero warnings | 🟡 build green; warning-count not enforced |
| S2 | Resources copied (HTML / CSS / JSON) | ✅ |
| S3 | Asset catalog usage | ❌ not yet — system colours only |
| S4 | Single-scheme build | ✅ |
| S5 | xcodebuild CI script | ❌ |
| S6 | pbxproj reviewable diffs | 🟡 — diffs noisy but manageable |

## T. Testing

| ID | Category | Status |
|----|----------|--------|
| T1 | Unit tests (`Testing` framework) | ❌ minimal |
| T2 | UI tests (XCUIAutomation) | ❌ none |
| T3 | Smoke test for navigation | ❌ |
| T4 | Snapshot tests | ❌ |
| T5 | CI on every commit | ❌ |
| T6 | Pre-commit hooks | ❌ |
| T7 | Static analysis (treat warnings as errors) | ❌ |

## U. Code quality / hygiene

| ID | Category | Status |
|----|----------|--------|
| U1 | File organisation by feature | ✅ |
| U2 | Naming conventions (PascalCase / camelCase) | ✅ |
| U3 | Comments explain WHY not WHAT | 🟡 mostly compliant; some legacy WHAT comments |
| U4 | Dead code removed | 🟡 |
| U5 | TODO/FIXME tracking | ❌ no central inventory |
| U6 | Function length / complexity limits | 🟡 some long view-body functions |
| U7 | Cyclic dependency check | ❌ |

## V. Security

| ID | Category | Status |
|----|----------|--------|
| V1 | App Sandbox enabled in entitlements | ✅ verified |
| V2 | Minimal entitlements (every key justified) | ✅ verified — 4 keys, all used; XML comments + docs/SECURITY.md table |
| V3 | No hardcoded secrets / keys | ✅ grep-audited; all TranslationProviders return `requiresAPIKey=false` |
| V4 | Atomic file writes | ✅ verified — CrashReporter + DataStore both use `.atomic` |
| V5 | Input sanitisation on search/text | ✅ (no eval / injection surfaces) |
| V5b | WKWebView JS-disabled + scoped read access | ✅ in-page JS off via per-navigation `WKWebpagePreferences.allowsContentJavaScript = false`; native `evaluateJavaScript` still works for Read Aloud |
| V6 | URL handler attack surface (custom schemes) | ✅ none registered — no `CFBundleURLTypes`, no `onOpenURL` |
| V7 | Privacy strings for mic + speech | ✅ via `INFOPLIST_KEY_*` build settings |

## W. Window management

| ID | Category | Status |
|----|----------|--------|
| W1 | Resizable with min 1024×640 | ✅ window frame minWidth: 1024, minHeight: 640 (split-screen tile half on 5K @1×) |
| W2 | Sheet sizing on macOS (explicit frame) | ✅ Welcome / KeyboardShortcuts / CommandPalette all carry explicit min/idealWidth + min/idealHeight |
| W3 | Drag-resize doesn't strand popovers | ❌ |
| W4 | Window restoration on relaunch | ✅ system default — see L4 |
| W5 | NSWindow.allowsAutomaticWindowTabbing disabled | ✅ |

## X. Workflow / tooling

| ID | Category | Status |
|----|----------|--------|
| X1 | iMac pull-and-build script | ✅ `scripts/imac-pull.sh` |
| X2 | Crash log capture + Help menu | ✅ |
| X3 | Memory / reference docs (CLAUDE memories) | ✅ multiple files in memory/ |
| X4 | CLAUDE.md in repo | ❌ |
| X5 | README.md in repo | ❌ |
| X6 | Contributing guidelines | ❌ |
| X7 | Branch policy / commit conventions | ✅ conventional commits in use |

## Y. Content pipeline (auxiliary scripts in ContentPipeline/)

| ID | Category | Status |
|----|----------|--------|
| Y1 | JSON generation reproducibility | 🟡 |
| Y2 | Schema validation on output | ❌ |
| Y3 | Page-ref backfill from textbook | ❌ |
| Y4 | Diff-friendly JSON formatting | 🟡 — `ensure_ascii=False` rule learnt the hard way |

---

## How to use this checklist

1. Pick a category (e.g., **H** Accessibility).
2. Open this file, scan the rows marked 🟡 or ❌.
3. Ask Claude: "Audit category **H** in detail — list every concrete instance
   that fails the criterion, then fix the top N."
4. Claude returns a concrete bug list scoped to that category.
5. Triage with Rohan (each bug: fix now, defer, or close as won't-fix).
6. Land fixes in one or more commits per category.
7. Flip the rows to ✅ once the category is swept clean.

Categories that are pure content (G, P) move fastest. Categories that
need test coverage (T) and security review (V) require deeper passes
across multiple sessions.

If a new category emerges (e.g., new subject area, new platform target),
add it here first so the audit surface stays explicit.
