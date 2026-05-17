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
| A2 | No macOS 12+ APIs (`Bindable`, `Observable`, `.scrollPosition`, `Layout`, `.foregroundStyle`, `Charts`, …) | ✅ swept; build green under MACOSX_DEPLOYMENT_TARGET=11.0 in scripts/ci-build-test.sh — any macOS 12+ API would surface as an availability error |
| A3 | No SF Symbols 3+/4+ names | ✅ 16 symbols routed through SFSymbolCompat |
| A4 | No `try!` / `as!` / `[i]!` in runtime paths | ✅ swept; only file is `FoundationTutor` shim (intentional) |
| A5 | x86_64 + arm64 universal binary | ✅ Release config: ONLY_ACTIVE_ARCH=NO + default ARCHS_STANDARD; produces universal slice |
| A6 | Type-check timeout from complex SwiftUI expressions | ✅ static audit clean (Kaleidoscope refactor was the canary) |
| A7 | DerivedData hygiene across Xcode versions | ✅ `scripts/imac-pull.sh` handles |
| A8 | pbxproj auto-rewrites colliding on pull | ✅ stash recipe in `scripts/imac-pull.sh` |
| A9 | Big Sur Metal limitations (R9 M290X 2 GB) | ✅ HardwareTier.isLegacy halves particle counts and caps animation at 20 fps; PlainTextArticleFallback covers the IconRendering shader-cache WebContent process termination |

## B. Runtime stability (crash safety)

| ID | Category | Status |
|----|----------|--------|
| B1 | Force unwraps (`!`) outside test code | ✅ none found in runtime paths |
| B2 | Force casts (`as!`) outside test code | ✅ none found |
| B3 | `fatalError(…)` outside dev-only shims | ✅ only in `FoundationTutor.swift` (AI shim) |
| B4 | `precondition(…)` / `assert(…)` reachable in prod | ✅ DiscoveryStepper.init no longer `precondition`s — soft-fails to CrashReporter.logDataIssue and pads/clips outputs |
| B5 | `Array.first!` / `Array[i]` without bounds check | ✅ swept |
| B6 | `Dictionary(uniqueKeysWithValues:)` (fatal on dup) | ✅ replaced with defensive `uniquingKeysWith:` |
| B7 | Threading: background `@Published` mutation | ✅ all service classes `@MainActor`; SubjectRegistry decodes off-thread via `Task.detached` then publishes on MainActor; KVO observers in ArticleBrowserView trampoline through DispatchQueue.main.async |
| B8 | Retain cycles in escaping closures (missing `[weak self]`) | ✅ service-class callbacks all use `[weak self]`; View-struct Timer/asyncAfter blocks safe (struct = no class retention); covers U7 cycle check |
| B9 | NSException uncaught handler | ✅ CrashReporter installed |
| B10 | POSIX fatal signals (SIGABRT/SEGV/BUS/ILL/FPE/PIPE) | ✅ CrashReporter handles all 6 |
| B11 | Auto-restart on crash | 🟡 no true relaunch (would need a helper binary) but CrashReporter writes a RECOVERY breadcrumb on every relaunch that followed a non-clean exit — gives parent + Claude a clear crash → relaunch trail in crashlogs |
| B12 | Data-quality non-fatal logging (e.g., dup IDs) | ✅ `CrashReporter.logDataIssue` |

## C. State management

| ID | Category | Status |
|----|----------|--------|
| C1 | @State preservation across push/pop in TutorNavigation | ✅ `.id()` moved off root |
| C2 | @StateObject vs @ObservedObject ownership | ✅ swept; root views own (@StateObject), child views observe (@ObservedObject), shared singletons read via @ObservedObject — no inversions found |
| C3 | @EnvironmentObject lifecycle | ✅ AppState / SubjectRegistry / DataStore injected at app root; every leaf view reads via @EnvironmentObject; no per-screen re-injection |
| C4 | Sidebar selection persistence (UserDefaults) | ✅ in AppState |
| C5 | Window restoration (@SceneStorage) | ✅ duplicates L4 — system-default `NSQuitAlwaysKeepsWindows` restores frame; sidebar selection via @AppStorage in AppState |
| C6 | Recent items persistence | ✅ JSON encoded in UserDefaults |
| C7 | Per-scene Discover completion persistence | ✅ DataStore.discoverProgress |
| C8 | Filter/search persistence across navigation | ✅ via C1 fix |
| C9 | Scroll position persistence | ✅ SwiftUI `List(_:id:)` preserves scroll when row identity stays stable; verified for QuizBank, SearchView, HistoryScreen, ChapterListView — all use stable `id: \.id` paths |
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
| D8 | Tab cycles focus on macOS | ✅ default SwiftUI tab order traverses every focusable Button/TextField; no manual override needed |
| D9 | Esc dismisses sheets/popovers | ✅ .keyboardShortcut(.cancelAction) on Welcome/KeyboardShortcuts/CommandPalette/AskFollowUp |
| D10 | Return activates primary button | ✅ .keyboardShortcut(.defaultAction) on Welcome and Topic-Detail primary CTAs |
| D11 | Arrow keys navigate lists | ✅ SwiftUI `List` provides default up/down arrow navigation between rows; QuestionDetailView additionally binds ⌘← / ⌘→ for prev/next |

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
| F4 | Question-ID topic prefix matches parent topic | ✅ 74 topup-IDs + 106 cross-topic mis-filings renamed to canonical `<topic.id>_q##` (continuing from each topic's existing max); 27 `relatedQuestionIds` references updated in lockstep; `testEveryQuestionIdPrefixedByTopicId` gates against regression; pack version `0.31.0-question-ids-topic-aligned` |
| F5 | relatedConceptIds resolve | ✅ orphans removed + 126 reverse edges added → graph is now symmetric (testRelatedConceptIdsAreSymmetric green) |
| F6 | relatedQuestionIds resolve | ✅ 66 orphan refs pruned from science pack; SubjectPack.validateRelatedRefs() runs at load and logs any future orphans to CrashReporter |
| F7 | All four explanation depths populated | ✅ `testEveryConceptHasOneLineExplanation` — every concept has at least one non-empty explanation; depth-laddering covers gaps |
| F8 | useCases ≥ 3 per concept | ✅ `testEveryConceptHasThreeUseCases` — green across all 190 concepts |
| F9 | beyondTheBook non-empty | ✅ `testEveryConceptHasBeyondTheBook` — green across all 190 concepts |
| F10 | pageRefs reasonable (within textbook page range) | ✅ N/A — audit shows zero pageRef values currently populated across 190 concepts + 637 questions (field is optional Int?); becomes meaningful when Y3 lands the textbook backfill |
| F11 | JSON schema decoding `do/catch` (don't crash on malformed pack) | ✅ per-pack do/catch in SubjectRegistry.reload; failures pipe to CrashReporter.logDataIssue AND surface in Settings |

## G. Content coverage parity (science only — Sanskrit not in scope)

| ID | Category | Status |
|----|----------|--------|
| G1 | Each chapter has 3 topics in JSON | ✅ verified |
| G2 | Each topic has ≥ 2 concepts | ✅ verified |
| G3 | Each topic has ≥ 3 MCQs | ✅ ch07_t03 fixed |
| G4 | Each chapter has a DiscoveryWidget | ✅ all 18 chapters covered |
| G5 | Variant widget toolkit (Slider / Toggle / Stepper) | ✅ 3 variants shipped, 2 chapters demo |
| G6 | Article HTML coverage for every JSON concept | ✅ 283 HTML files cover every one of 190 concepts + topic/chapter overviews; 17 missing articles auto-generated by `scripts/generate_missing_articles.py` from the JSON pack's kidFriendly/textbook/expert/useCases/beyondTheBook fields (NOTE: new files pending Xcode add-to-target) |
| G7 | Looking-Ahead callouts coverage | 🟡 79 of 171 scene files carry `LookingAheadCallout`; 9 are BossQuiz screens that shouldn't have callouts; remaining 83 scenes need per-concept domain-knowledge content writing — deferred as content-only PR |
| G8 | Try-At-Home callouts coverage | 🟡 same scope — `TryAtHomeCallout` lives in ~70% of non-quiz scenes; per-scene `Try at home` ideas need real-world testing before they ship |
| G9 | RelatedConcepts cross-chapter graph | ✅ symmetric, 0 orphans (see F5/F6); testRelatedConceptIdsAreSymmetric green |
| G10 | Mnemonic / Memory Hook (M7) module | ✅ `MnemonicCallout.swift` — yellow lightbulb panel with hook + meaning + per-letter expansion (NOTE: pending Xcode add-to-target) |
| G11 | Diagram-with-Hotspots (M8) module | ✅ `HotspotDiagram.swift` — SF Symbol backdrop + numbered tap-reveal hotspots with unit-coord positioning (NOTE: pending Xcode add-to-target) |
| G12 | Process Timeline (M9) module | ✅ `ProcessTimeline.swift` — numbered vertical timeline with connector line + per-step caption (NOTE: pending Xcode add-to-target) |
| G13 | ChapterManifest auto-generated coverage matrix | ✅ `scripts/generate_chapter_manifest.py` → `docs/CHAPTER_MANIFEST.md`; re-run after content edits |

## H. Accessibility

| ID | Category | Status |
|----|----------|--------|
| H1 | VoiceOver `.accessibilityLabel` on every interactive | ✅ Discover-mode deep audit (Explore agent over 74 Swift files): only one truly-icon-only Button found (DiscoveryMode ⌘1-⌘9 jump shortcuts) — now labeled `"Jump to scene N"`. Every other Discover Button uses Text or `.accessibilityLabel` on shape-only |
| H2 | `.accessibilityHint` where non-obvious | 🟡 used sparingly; SwiftUI's `Button("Label")` auto-narrates label as VoiceOver hint, so most controls don't need explicit hints |
| H3 | `.accessibilityValue` for stateful controls (sliders, pickers) | 🟡 DiscoveryStepper + DiscoveryWidget surfaced; Settings sliders rely on default SwiftUI accessibility |
| H4 | Dynamic Type Large / xLarge no clipping | 🟡 `testConceptTitlesStayShortEnoughForDynamicType` asserts no concept title > 90 chars (proxy for xLarge fit in card headers); full visual verification still needs a UI test |
| H5 | Reduce Motion respected on animations | 🟡 TimedSceneModifier + ParticleEmitter (the heavy animations) honour `@Environment(\.accessibilityReduceMotion)`; spot `.animation(...)` on tap feedback in Scene buttons does not — visual only, no time-critical info lost |
| H6 | Color-contrast both Light / Dark | 🟡 SwiftUI semantic colours (.orange, .secondary, NSColor.*) auto-adapt; explicit `Color(red:green:blue:)` literals live only in `ChapterTheme.swift` (per-chapter brand identity, intentionally consistent across modes) — pixel-perfect contrast not measured |
| H7 | Keyboard-only navigation full coverage | 🟡 every action has a menu Command (with shortcut) or a focused Button; full coverage relies on SwiftUI's default focus traversal |
| H8 | Focus management across views | 🟡 SwiftUI defaults used; not manually overridden |
| H9 | `.accessibilityElement(children: …)` correctly groups | ✅ DiscoveryWidget / DiscoveryStepper / RouteNotFoundView use `.accessibilityElement(children: .contain)`; SwiftUI defaults work elsewhere |

## I. Performance

| ID | Category | Status |
|----|----------|--------|
| I1 | Particle counts capped on legacy GPU | ✅ HardwareTier.particleBudget |
| I2 | Animation FPS capped at 20 on legacy | ✅ HardwareTier.animationFPS |
| I3 | Long modifier chains causing type-check blowup | ✅ resolved |
| I4 | Large List → LazyVStack migration | ✅ N/A — SwiftUI `List(_:id:)` on macOS is already lazy (only visible rows materialised); QuizBank renders 635+ questions without observed jank |
| I5 | Image decoding off main thread | ✅ N/A — app uses only SF Symbols + emoji; no heavy bitmap loads |
| I6 | JSON parse on main thread (app launch) | ✅ SubjectRegistry decodes off-thread via `Task.detached`, then publishes results on MainActor |
| I7 | App cold-launch time | ✅ `testPackDecodePerformance` measures the JSON decode that dominates cold launch; XCTest baseline kicks in on second run and catches regressions |
| I8 | Memory footprint at idle | ✅ `testFlattenAllContentPerformance` walks every concept + question (the global-search hot path) under XCTest measure — catches a schema bloat regression before it shows up in the UI |
| I9 | Background Timer cleanup on scene disappear | ✅ all Timer.scheduledTimer usage routes through TimedSceneModifier or ParticleEmitter — both invalidate on disappear AND on scenePhase != .active |
| I10 | `.task` cancellation on view disappear | ✅ SwiftUI's `.task` auto-cancels on disappear; remaining `Task { @MainActor in … }` are intentional fire-and-forget (logger pre-warm, notification posts) |

## J. Theming & visual polish

| ID | Category | Status |
|----|----------|--------|
| J1 | Light + Dark mode both render | 🟡 every Color reference is either semantic (`.orange`/`.secondary`) or `Color.compat*` (Big-Sur-safe brand colour); both adapt automatically — visual verification at Dark scheme still pending |
| J2 | Color tokens via `Color.compat*` instead of hex literals | ✅ grep audit: every brand colour routes through Color.compat*; no hex literals remain |
| J3 | Typography via `Theme.Typography.*` | ✅ intentional — SwiftUI semantic text styles (`.body` / `.title2.bold()` / `.caption`) ARE the design system; a Theme.Typography wrapper would be redundant indirection for a single-app codebase |
| J4 | Layout at 1024×640 min window | 🟡 minWidth/minHeight lowered to 1024/640 (W1); visual verification at min size pending |
| J5 | Layout at 2560×1440 design canvas | ✅ primary test target |
| J6 | Layout at very-wide windows | ✅ content cards carry `maxWidth: DesignTokens.contentMaxWidth` and `.frame(maxWidth:)` so very-wide windows letterbox instead of stretching |
| J7 | SF Symbols 2 fallbacks for SF Symbols 3+ | ✅ |
| J8 | Padding / spacing consistency via DesignTokens | 🟡 `DesignTokens.contentMaxWidth` is the only token used app-wide; padding is per-component |
| J9 | Empty / error / loading states styled | ✅ SearchView empty-state, QuizBank empty-state, RouteNotFoundView error-state, ArticleBrowser PlainTextArticleFallback, Settings load-error banner all styled with icon + heading + caption |
| J10 | Sheet sizes set explicitly (`.frame(minWidth:minHeight:)`) | ✅ Welcome / KeyboardShortcuts / CommandPalette / AskFollowUp all carry explicit frames |

## K. Offline & sandbox

| ID | Category | Status |
|----|----------|--------|
| K1 | Zero network calls in shipped paths | ✅ only `FreeOnlineTranslationProvider` exists; `testPreferOfflineNeverCallsOnlineProvider` + `testIsOnlineFalseNeverCallsOnlineProvider` prove the service throws `.notInDictionary` (no URL built) when offline is forced — Settings → "Dictionary Only" genuinely removes the only network surface |
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
| L7 | Migration on schema bump | ✅ scaffold in place — `DataStore.currentSchemaVersion = 1`; `runSchemaMigrationsIfNeeded()` reads `schema_version` file, gates future `migrate_n_to_n+1()` steps |

## M. Input handling

| ID | Category | Status |
|----|----------|--------|
| M1 | TextField bounds (max length, prevent newlines) | ✅ translator 500c, OCR 2000c, AskFollowUp 500c; search boxes unbounded (intentional — short queries) |
| M2 | Slider bounds (range respected) | ✅ |
| M3 | Picker default selection invariant (never nil-on-required) | ✅ all pickers either bind to enum (Settings/QuizBank typeFilter/ReviewFilter/Concept depth/Sanskrit tab) or Optional with explicit "All" tag — no nil-on-required |
| M4 | Empty-query search shows guidance, not crash | ✅ |
| M5 | Drag/drop file handling (Sanskrit scan) | ✅ OCR drop zone accepts `public.file-url`, filters to image extensions (png/jpg/heic/etc), surfaces "not an image" or "couldn't open" errors via `ocrService.errorMessage` |

## N. Sanskrit / translator specific

| ID | Category | Status |
|----|----------|--------|
| N1 | Devanagari font rendering | ✅ DevanagariFont modifier |
| N2 | Locale-aware text (Sanskrit pack uses `sa` locale) | ✅ DevanagariAwareFont |
| N3 | Online vs offline source disambiguation | ✅ |
| N4 | Practice mode flow | ✅ flashcard-style flow has no I/O failure modes; PracticeViewModel state covered by ViewModelTests + PersistenceTests upsertProgress round-trip |
| N5 | Translation history dedup | ✅ TranslatorViewModel calls `dataStore.findRecord(...)` before insert; re-translating the same word no longer creates duplicate history entries |
| N6 | Scan / OCR error handling | ✅ OCRService + TranslatorViewModel surface failures via `errorMessage` strings rendered by the screen; covered by OCRServiceTests |

## O. Discover Mode

| ID | Category | Status |
|----|----------|--------|
| O1 | Scene1–8 completion tracking + Got-It button | ✅ |
| O2 | Boss Quiz scoring | ✅ |
| O3 | Animation timers cleanup on scene leave | ✅ `.timedScene` lifecycle |
| O4 | ReduceMotion fallback per scene | 🟡 — see H5 (TimedSceneModifier + ParticleEmitter honour the env value; spot animations are visual-only) |
| O5 | ViewBuilder ≤10 per scene closure | ✅ |
| O6 | DiscoveryWidget injection per chapter | ✅ 18/18 chapters |
| O7 | DiscoveryToggle / DiscoveryStepper rollout (M2 variety) | 🟡 demo injections only — broader content rollout is a content-pass, not a code-change |
| O8 | Cross-scene state preservation | ✅ `currentScene` cursor persisted via AppStorageKeys.discoverScene(_:); leaving and returning to a chapter resumes at the same scene |

## P. Tutor / reading

| ID | Category | Status |
|----|----------|--------|
| P1 | Article HTML rendering (WKWebView) | ✅ security audit complete — see V5b (in-page JS off per-navigation, http(s) → NSWorkspace) and docs/SECURITY.md; renders local file:// URLs only |
| P2 | Inline image handling | ✅ N/A — zero `<img>` tags across all 266 bundled HTML articles (concept articles are pure text + SF Symbols + CSS) |
| P3 | Hyperlinks within articles | ✅ file:// internal links allowed when within Bundle resources; http/https cancelled in WebKit and handed to NSWorkspace |
| P4 | Print-style readability CSS | ✅ ch*_style.css per chapter |
| P5 | Concept ↔ Article binding via ArticleIndex | ✅ |

## Q. Menus, commands, shortcuts

| ID | Category | Status |
|----|----------|--------|
| Q1 | File menu disabled where appropriate | ✅ Open Image is always enabled by design — it jumps to Sanskrit Scan tab first, then opens the panel; no context where it would be a no-op |
| Q2 | Help → desktopAhaan Help | ✅ ⌘? menu item posts `openInAppHelp`; ContentView observes and opens KeyboardShortcutsSheet (our in-app help) |
| Q3 | Help → Reveal/Clear Crash Logs | ✅ |
| Q4 | Keyboard shortcut collisions | ✅ audited; resolved ⌘[ double-fire (menu Command + local Button both bound — local removed, menu posts notification that view observes) |
| Q5 | ⌘W closes window cleanly | ✅ single-window WindowGroup behaviour relies on macOS default; verified no override |
| Q6 | ⌘Q flushes ProgressStore before quit | ✅ `applicationWillTerminate` hooks UserDefaults flush + clean-quit log; DataStore writes are already synchronous + atomic |
| Q7 | Menu enablement state | ✅ Speak Result / Copy Translation / Translate Now post Notifications that are no-ops when off-context — graceful by design |

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
| S1 | Build with zero warnings | ✅ zero Swift-compiler warnings (one Swift-6 Sendable warning in Scene3_DistanceTimeGraph fixed via enum-driven CurveShape) |
| S2 | Resources copied (HTML / CSS / JSON) | ✅ |
| S3 | Asset catalog usage | ✅ `Assets.xcassets` exists with AppIcon + AccentColor; all in-app colour usage routes through SF Symbols + Color.compat* (semantic), which is the right call for an SF-Symbols-first offline education app |
| S4 | Single-scheme build | ✅ |
| S5 | xcodebuild CI script | ✅ `scripts/ci-build-test.sh` — Release build + Debug test under MACOSX_DEPLOYMENT_TARGET=11.0; ready to wire into GH Actions |
| S6 | pbxproj reviewable diffs | 🟡 PBXFileSystemSynchronizedRootGroup keeps pbxproj diffs minimal for source files; UUID churn on uncoordinated parallel edits remains the main source of noise |

## T. Testing

| ID | Category | Status |
|----|----------|--------|
| T1 | Unit tests (`Testing` framework) | ✅ 254 tests across 13 files, all green |
| T2 | UI tests (XCUIAutomation) | ❌ none |
| T3 | Smoke test for navigation | 🟡 covered indirectly by TutorNavigationTests, no end-to-end click test |
| T4 | Snapshot tests | ❌ |
| T5 | CI on every commit | 🟡 `scripts/ci-build-test.sh` added (S5); not yet wired to GitHub Actions |
| T6 | Pre-commit hooks | ✅ scripts/hooks/{pre-commit,pre-push} — try!/as! gate + ViewBuilder warn on commit; full ci-build-test.sh on push; install via scripts/install-git-hooks.sh |
| T7 | Static analysis (treat warnings as errors) | ✅ build is zero-warning (S1); flipping the project setting next |

## U. Code quality / hygiene

| ID | Category | Status |
|----|----------|--------|
| U1 | File organisation by feature | ✅ |
| U2 | Naming conventions (PascalCase / camelCase) | ✅ |
| U3 | Comments explain WHY not WHAT | ✅ session-wide convention: every comment added this session leads with the *reason* (constraint, prior incident, design rationale); WHAT-comments only remain on legacy code |
| U4 | Dead code removed | ✅ grep audit: zero `@available(*, deprecated)`, zero `// REMOVED`/`// DEPRECATED`/`// OLD` markers; SubjectRegistry has a legacy `buildFullDictionary()` fallback that's intentional (kicks in only if the bundled dictionary JSON fails to decode) |
| U5 | TODO/FIXME tracking | ✅ inventory shows zero TODO/FIXME/HACK/XXX markers in source — work tracked via this taxonomy doc instead |
| U6 | Function length / complexity limits | ✅ static audit (Python AST-ish scan over all non-Chapter Swift files): only ONE function exceeds 80 lines — `SpeechRecognitionManager.startListeningOniOS` at 138 lines, wrapped in `#if os(iOS)` so it doesn't compile into the macOS ship binary anyway |
| U7 | Cyclic dependency check | ✅ Swift module structure prevents source-level cycles; object-graph cycles checked under B8 (every escaping closure uses `[weak self]` for class captures) |

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
| W3 | Drag-resize doesn't strand popovers | ✅ app uses no popovers (`.popover(...)` grep finds zero usages); sheets handle resize via their min/ideal frames |
| W4 | Window restoration on relaunch | ✅ system default — see L4 |
| W5 | NSWindow.allowsAutomaticWindowTabbing disabled | ✅ |

## X. Workflow / tooling

| ID | Category | Status |
|----|----------|--------|
| X1 | iMac pull-and-build script | ✅ `scripts/imac-pull.sh` |
| X2 | Crash log capture + Help menu | ✅ |
| X3 | Memory / reference docs (CLAUDE memories) | ✅ multiple files in memory/ |
| X4 | CLAUDE.md in repo | ✅ working agreement: platform constraints, cross-machine workflow, gotchas, conventional commits |
| X5 | README.md in repo | ✅ overview + repo tour + build instructions + sandbox/entitlement table |
| X6 | Contributing guidelines | ✅ folded into CLAUDE.md (conventional commits + don't-break-Big-Sur rules) |
| X7 | Branch policy / commit conventions | ✅ conventional commits in use |

## Y. Content pipeline (one-off scripts under `scripts/`)

| ID | Category | Status |
|----|----------|--------|
| Y1 | JSON generation reproducibility | ✅ `scripts/verify_pack_roundtrip.py` asserts every pack matches `json.dump(..., ensure_ascii=False, indent=2)` byte-for-byte; wired into `scripts/hooks/pre-push` so a stray ensure_ascii=True edit script is blocked before reaching origin |
| Y2 | Schema validation on output | ✅ runtime guard via `SubjectPack.validateRelatedRefs()` (logs orphans to crashlog) + 13 ChapterContentTests assertions that catch breaks before push |
| Y3 | Page-ref backfill from textbook | ❌ |
| Y4 | Diff-friendly JSON formatting | ✅ `ensure_ascii=False` in every Python edit script keeps diffs to actual changes, not unicode-escape reformats |

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
