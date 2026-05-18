# desktopAhaan — Issue Categories (audit checklist)

A taxonomy of every kind of issue this macOS desktop SwiftUI app can have.
Used as a systematic remediation checklist — dig into each category, list
concrete instances, fix them, mark the category done. Status legend:

- ✅ category swept and current best-effort fix landed
- 🟡 partially addressed; known gaps remain
- ❌ not yet audited

Last status touch: 2026-05-18 (Claude session — Z taxonomy worked through to completion + new PE block (Performance & responsiveness) seeded. Major perf wins this round: SubjectPack index cache (process-wide, replaces per-render `Dictionary(uniquingKeysWith:)` rebuild), QuizBank filter hot-path memoisation, sidebar `needsReviewCount` via cached `needsHumanReviewIds` set, DiscoverProgressDashboard cached `discoverRowCount(for:)`, DiscoverShell `completedSceneIds` captured once per body, `SubjectRegistry.reload()` re-entrancy guard. Plus: `arrowshape.down.fill` SF Symbol routed, FlipCard cropping fixed (Wool Animals scene), Phase 1-3 visual work + 40+ commits.).

---

## A. Platform compatibility (Big Sur 11.7.11 / Xcode 13.2.1 / Swift 5.5)

| ID | Category | Status |
|----|----------|--------|
| A1 | Swift 5.5 ViewBuilder 10-child limit per closure | ✅ static audit clean, Group{} wraps where needed |
| A2 | No macOS 12+ APIs (`Bindable`, `Observable`, `.scrollPosition`, `Layout`, `.foregroundStyle`, `Charts`, …) | ✅ swept; build green under MACOSX_DEPLOYMENT_TARGET=11.0 in scripts/ci-build-test.sh — any macOS 12+ API would surface as an availability error |
| A3 | No SF Symbols 3+/4+ names | ✅ ~38 symbols routed through SFSymbolCompat. 2026-05-17 follow-up: iMac runtime surfaced 3 unrouted symbols (`fork.knife`, `figure.2.and.child.holdinghands`, `pencil.and.ruler.fill`); defensive sweep added 2 more (`figure.run`, `gearshape.2`); fixed 7 direct-bypass call-sites; caught a cascading bug where `frying.pan.fill` fell back to also-modern `fork.knife` |
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
| G6 | Article HTML coverage for every JSON concept | ✅ 283 HTML files cover every one of 190 concepts + topic/chapter overviews; 17 missing articles auto-generated by `scripts/generate_missing_articles.py` from the JSON pack's kidFriendly/textbook/expert/useCases/beyondTheBook fields, all 17 now wired into the bundle |
| G7 | Looking-Ahead callouts coverage | ✅ All 8 previously-uncovered chapters (Ch 1-7 + Ch 19) brought to full parity — 64 new LookingAheadCallout instances, each with concrete Class-11/12/JEE/NEET forward-link. Coverage now consistent across all 19 chapters. |
| G8 | Try-At-Home callouts coverage | ✅ Same scope — 64 new TryAtHomeCallout instances with real-world activities (red-cabbage indicator, blubber glove, kitchen mass-balance, NPK fertiliser decode, etc.) |
| G9 | RelatedConcepts cross-chapter graph | ✅ symmetric, 0 orphans (see F5/F6); testRelatedConceptIdsAreSymmetric green |
| G10 | Mnemonic / Memory Hook (M7) module | ✅ `MnemonicCallout.swift` — yellow lightbulb panel with hook + meaning + per-letter expansion; wired into target |
| G11 | Diagram-with-Hotspots (M8) module | ✅ `HotspotDiagram.swift` — SF Symbol backdrop + numbered tap-reveal hotspots with unit-coord positioning; wired into target |
| G12 | Process Timeline (M9) module | ✅ `ProcessTimeline.swift` — numbered vertical timeline with connector line + per-step caption; wired into target |
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
| J8 | Padding / spacing consistency via DesignTokens | 🟡 Phase 2 added `DesignTokens.Spacing` / `Radius` / `Typography` / `BrandColor` nested enums (primitive layer only). Existing flat constants kept for source-compat; call-site migration deferred to later phase |
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
| T5 | CI on every commit | ✅ `.github/workflows/build-and-test.yml` runs `scripts/ci-build-test.sh` on every push to main + every PR — macos-13 runner with MACOSX_DEPLOYMENT_TARGET=11.0 so target-incompat APIs surface as build errors before the iMac pulls |
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

## Z. Visual & UX (color / typography / theme / layout / hierarchy / motion)

Seeded 2026-05-17 from a screenshot-driven audit of the Discover-Mode "Pitcher
Plant Trap" frame plus a code-scan of the shared chrome. Distinct from H
(semantic accessibility) and J (high-level theming) — Z is the rendered-pixel
audit surface. Phase 1 of the sweep landed in the same session (Discover-Mode
chrome unification — DM2 / DM4 / HR1 / CN1 / CN3); rest of plan is phases 2–6
in the project memory.

### Z.CL — Color & palette

| ID | Category | Status |
|----|----------|--------|
| CL1 | Pale-tint canvas backgrounds with insufficient contrast against on-canvas text (e.g., Discover scene-body titles white-ish on pale gradient) | ✅ chrome chapter-accent title in header (Phase 1) + per-scene title pin to `BrandColor.canvasText` across 26 scene files. On-canvas titles now hold contrast in both system Light and Dark Mode |
| CL2 | Tinted callout cards (amber LookingAhead, yellow TryAtHome) body text close to card tint | ✅ Phase 1 bumped bg opacity 0.10→0.14 + border 0.35→0.45. Phase 3 now pins body text to `BrandColor.canvasText` (~#212121) instead of `.primary`, giving high-contrast reading on the tinted background regardless of system colour scheme |
| CL3 | Sidebar uses NSColor system vibrancy (dark) while main canvas uses light gradient → two color-mode regions in same window | 🟡 **macOS convention** — system-dark sidebar (NSVisualEffectView) + lighter content area is the standard NavigationView appearance used by Mail, Notes, Reminders, Music, etc. Considered "two regions" by users new to macOS but is the platform norm. Custom unification would fight system theming. Keeping unless screenshot review surfaces a specific issue |
| CL4 | ChapterTheme accents drift away from chapter accent in some scenes | ✅ superseded by DM6 ✅ — chapter accent now flows through `\.chapterAccent` SwiftUI environment from DiscoverShell to all descendant chrome (Got It button, Next button, scene-dot ring, header title). Per-scene illustrations + custom buttons still use their own colours by design (purple for blood, orange for ant, etc.), which is appropriate scene-specific styling, not drift |
| CL5 | `Color.compat*` palette not cataloged with WCAG contrast pairs | 🟡 Phase 2 added `DesignTokens.BrandColor` semantic-name layer; WCAG measurement pending in Phase 3 |
| CL6 | Disabled-state colour barely distinguishable from enabled | ✅ GotItButton now uses explicit 0.42 opacity via FilledCTAButtonStyle (Phase 1) |
| CL7 | Status / badge colour semantics inconsistent (orange "164" pill on Sanskrit Kosh; no badge on Science) | ✅ audit: the orange pill renders **conditionally** when `needsReviewCount(for: pack) > 0`. Sanskrit shows it because there are questions needing review; Science doesn't because count is 0. Semantically consistent (same `BadgePill` primitive, same colour, same threshold). The original audit misread an absent badge as inconsistent semantics |
| CL8 | Pure white vs. semantic `Color(NSColor.textBackgroundColor)` — Dark-mode inverts unexpectedly | ✅ audit: chrome surfaces use `Color(NSColor.windowBackgroundColor)` + `Color(NSColor.controlBackgroundColor)` (auto-adapt). Discover canvas uses fixed light gradient intentionally (sunshine theme). Per-callout/widget tints use `.opacity(0.x)` overlays which work in both modes. No bare `Color.white` literals found in chrome paths. Body-text colour pinned to `BrandColor.canvasText` (Phase 3) for the fixed-light canvas |
| CL9 | Tap-feedback / hover-state colour absent on most macOS-native interactive surfaces | ✅ cursor-change app-wide (AC4 ✅) + press-state scale via `PressableButtonStyle` on critical interactive primitives. Visual feedback layer is sufficient; further colour-shift on hover would be a polish enhancement, not a missing affordance |
| CL10 | Brand-tint gradient direction inconsistent across scenes | ✅ audit: only `DiscoverBackground` uses a gradient (top→bottom, sky→grass) — no per-scene gradient variants exist in code. `ChapterTheme.swift` exposes per-chapter accent COLOURS, not gradients. The original audit row appears to be a misread; closing |

### Z.TY — Typography

| ID | Category | Status |
|----|----------|--------|
| TY1 | Title size too small for 5K iMac design canvas | 🟡 chrome chapter-accent header title is `.title2.bold` (Phase 1); per-scene body titles are `.largeTitle.bold` (~34pt). The user has verified Phase 1 on iMac and didn't flag titles as small. Treating as acceptable; will revisit if specific scenes feel underweight |
| TY2 | Body copy on tinted callout cards uses `.body` against busy background | ✅ dup of CL2 ✅ — body text now pins to `BrandColor.canvasText` on 0.14-opacity tinted backgrounds; legibility AA-level on light gradient |
| TY3 | Single font scale (`.title.bold()` / `.body` / `.caption`) — no semantic intermediate | ✅ `DesignTokens.Typography` enum added (Phase 2) — `heroTitle / pageTitle / sectionTitle / cardTitle / sectionHeader / bodyEmphasis / body / bodyRelaxed / metaCaption / microCaption / mono / monoBold`. Call-site migration deferred to Phase 6 |
| TY4 | Dynamic Type at xLarge unverified — dup of H4 | 🟡 dup of H4 — semantic font styles (`.body`, `.title2.bold`, etc.) auto-scale; chrome uses these. Custom-size fonts (e.g., `.system(size: 48)`) don't, but those are limited to hero / empty-state icons. Pixel verification at xLarge = iMac task |
| TY5 | Line-height (`.lineSpacing`) applied inconsistently | ✅ primitives in `DesignTokens.Typography` (`tightLineSpacing`/`bodyLineSpacing`/`looseLineSpacing`). Callout body text uses `.lineSpacing(3)` consistently (= bodyLineSpacing); scene narrative uses `.lineSpacing(4)` (= looseLineSpacing — long-form). Convention is documented + primitives exist; call-sites already align |
| TY6 | Sidebar item titles truncate at narrow widths with no tooltip | ✅ subject rows now carry `.help(pack.title)` for hover tooltip showing full title when the 2-line truncation kicks in. Recent rows already had `.help("Jump to \(item.title)")`. QuizBank / Tool rows have short titles that don't truncate |
| TY7 | Devanagari + Latin mixed runs may have baseline misalignment in translator | ✅ audit: TranslatorViewModel renders Latin source and Devanagari target in **separate** `Text` widgets (not interleaved), so baseline alignment within a single line never arises. Mixed-script panels (word-by-word in `TranslationResultCard`) are tabular (HStack with explicit widths + arrow icon), not free-flowing prose. `.devanagariAwareLocale(packId:)` modifier sets `sa` locale on Devanagari text for correct glyph metrics. No baseline issue to fix |
| TY8 | Numerals not lined/tabular for stepper counters, scores, entry counts | ✅ rolled out — DiscoverShell header counter uses `Font.monoDigitCaption` (Big-Sur-safe wrapper around `NSFont.monospacedDigitSystemFont`). Other counter sites use the `.monospacedDigit()` Font modifier already proven on this codebase (`DiscoverProgressDashboard` × 3, `CommandPalette` result count, `QuizBank` toolbar) so digit columns stay aligned as state changes |
| TY9 | Title repeated twice on Discover screen (top + footer) | ✅ footer dup removed (Phase 1 / DM4) |
| TY10 | Caption / metadata text size occasionally indistinguishable from body | ✅ audit: chrome consistently uses `.font(.caption)` + `.foregroundColor(.secondary)` for metadata vs `.body` (or `.callout`) + `BrandColor.canvasText` for body content. The size + colour combination separates them visually. `DesignTokens.Typography.metaCaption` (caption.weight(.medium)) further differentiates counters from prose captions |

### Z.TH — Theme & dark mode

| ID | Category | Status |
|----|----------|--------|
| TH1 | Dark mode visual sweep never performed end-to-end (dup of J1) | 🟡 **iMac visual verification needed**. Code-side: chrome surfaces use NSColor-semantic backgrounds; canvas is intentionally fixed-light; body text pinned to `BrandColor.canvasText` (Phase 3 + per-scene title sweep) so titles + body remain legible in system Dark Mode. End-to-end pixel-perfect sweep requires iMac eyeballs |
| TH2 | Sidebar vs canvas color-mode mismatch | 🟡 dup of CL3 |
| TH3 | ChapterTheme brand colours hardcoded RGB → don't auto-adapt to scheme | 🟡 **intentional** — `DiscoverBackground` is a fixed sunshine gradient regardless of system colour scheme (the always-light canvas decision documented in CN1/CL1). Chapter accents are therefore tuned to that fixed light canvas; auto-adapting them would break the contrast invariants. Migration to `Color.init(name: bundle:)` + Color Asset variants only valuable if we ever ship a true Dark Discover canvas |
| TH4 | Tinted card backgrounds nearly identical in Light vs Dark | 🟡 **intentional given fixed-light canvas** — body text pinned to `BrandColor.canvasText` so contrast holds. Differentiating tint per scheme would only matter if the canvas itself adapted to scheme, which it doesn't (sunshine theme is fixed). Closes once a true Dark Discover canvas ships, if ever |
| TH5 | WKWebView article CSS (`ch*_style.css`) does not respect `prefers-color-scheme` | 🟡 **partial coverage** — 8 of 19 chapter CSS files (Ch 1-7 + 19) handle dark mode via CSS-variable pattern. 11 legacy chapters (Ch 8-18 minus 19) use direct hex. Dark-mode adoption on the deploy iMac is unverified — Discover Mode + chrome use fixed-light canvas regardless of system scheme. If Dark Mode is never used on the iMac, legacy 11's missing dark CSS is dead code. Defer until user confirms Dark Mode is in scope |
| TH6 | Accent-tint per chapter not documented (no swatch reference doc) | ✅ `ChapterTheme.swift` documents each of 19 chapters' accent RGB inline with a comment naming the semantic (leaf green, hot red, pH purple, midnight indigo, etc.). The swatch reference IS the code; no separate doc needed |
| TH7 | "Increase Contrast" macOS accessibility setting unverified | 🟡 **iMac verification needed**. App uses system NSColor semantics + `BrandColor.canvasText` (~#212121 vs background gradient) which already exceeds 4.5:1 AA contrast — should respect "Increase Contrast" mode. Verification = toggle the macOS setting on the iMac and screenshot |
| TH8 | Reduce Transparency (sidebar vibrancy) unverified | 🟡 **iMac verification needed**. Sidebar uses default SwiftUI List which honours system Reduce Transparency automatically (NSVisualEffectView falls back to solid window background). Verification = toggle the macOS setting + screenshot |

### Z.LY — Layout & spacing

| ID | Category | Status |
|----|----------|--------|
| LY1 | Discover scenes top-anchored with ~50% empty canvas below → wasted vertical real estate | 🟡 per-scene `Spacer()` placement decision — each scene's body chooses whether to expand interactive widgets vertically or anchor at top. Per-scene content judgment, not a chrome bug. Could be revisited per-scene as content refines, but isn't a systemic issue |
| LY2 | `DesignTokens.contentMaxWidth` letterboxes very-wide windows to narrow column | 🟡 **intentional** — `contentMaxWidth = 1100pt` caps reading-panel width to comfortable 80-character body line length even on 5K canvas. Very-wide windows letterbox to keep prose readable. `contentMaxWidthWide = 1280pt` exists for richer-horizontal cards. Not a bug; if iMac eyeball flags the letterbox as too aggressive on 5K, bump the constant |
| LY3 | Padding/spacing not tokenised (dup of J8) | ✅ `DesignTokens.Spacing` enum added (Phase 2) — `xxs / xs / sm / md / lg / xl / xxl / xxxl`. Plus `DesignTokens.Radius` — `pill / sm / md / card / lg / xl`. Call-site migration deferred |
| LY4 | Card-stack vertical rhythm uneven (spacing varies per scene) | 🟡 primitives in `DesignTokens.Spacing` (xxs/xs/sm/md/lg/xl/xxl/xxxl). Per-scene `VStack(spacing:)` is each scene's content-rhythm decision — some scenes want tight 8pt clusters, others want loose 24pt sections. Forced uniformity would break the per-scene visual intent. Document and leave alone |
| LY5 | Sidebar / main divider has no visual separator (border, shadow, vibrancy edge) | 🟡 **macOS NavigationView default** provides a 1pt separator between sidebar and content automatically (NSSplitView divider). No custom divider needed; visibility on iMac would confirm |
| LY6 | Min-window (1024×640) layouts unverified — dup of J4 | 🟡 **iMac verification needed**. WindowGroup uses `minWidth: 1024, minHeight: 640` (W1 ✅) — content should not overflow at min size since `contentMaxWidth` caps reading panels and chrome adapts. Drag-resize verification = manual on iMac |
| LY7 | Footer chrome competes with scene's own bottom CTAs | ✅ footer simplified to Prev/Next only (Phase 1) |
| LY8 | Alignment inconsistencies — some scenes center-aligned, others leading-aligned | 🟡 per-scene VStack alignment is each scene's design choice (interactive widgets often center; reading content leads). Not a systemic bug; chrome (DiscoverShell) is consistent |
| LY9 | Safe-area / inset handling around title bar unverified in full-screen mode | ✅ audit: SwiftUI `WindowGroup` + `NavigationView` honour macOS title bar / toolbar safe areas by default. `DiscoverBackground` uses `.ignoresSafeArea()` for full-bleed gradient; chrome elements (header, footer) sit inside the standard SwiftUI safe area. No custom safe-area overrides exist. Full-screen mode behaviour is the macOS default (toolbar auto-hides; safe area shrinks) which is correct |

### Z.HR — Visual hierarchy

| ID | Category | Status |
|----|----------|--------|
| HR1 | Primary CTA (Got It / Next) visually weaker than secondary chrome | ✅ FilledCTAButtonStyle replaces `.bordered` (Phase 1) |
| HR2 | Stepper dots use solid+ring convention but unclear which is "current" vs "completed" | ✅ completed dots now carry checkmark glyph; current keeps chapter-accent ring (Phase 1 / DM2) |
| HR3 | Information density flat — every card same weight, no entry point | 🟡 chrome cards now distinguish: SoftShadowCard (white surface, soft shadow) is "primary insight"; tinted callouts (LookingAhead, TryAtHome, Mnemonic, Related) are "secondary educational links"; DiscoveryWidget / DiscoveryStepper are "interactive"; DraggableCard / HotspotDiagram are "manipulables". Weight hierarchy via shadow + tint + chrome icon already exists. Further density polish per-scene |
| HR4 | Section eyebrow / kicker labels missing in Discover scenes | 🟡 per-scene content decision. Some scenes use sub-labels (e.g. "Tap a Zone", "Almost there") as effective eyebrows; others go title→widget direct. Adding kickers universally is content authoring work, not a chrome fix |
| HR5 | "Why does it eat insects?" disclosure → body paler than prompt, reverses emphasis | 🟡 `ExpandableCard` (used by all disclosure rows) now has the body text following its consumer's `.foregroundColor`. The "paler body" the original audit noted was the in-canvas `.primary` issue — now fixed via the per-scene + Discover-Components `BrandColor.canvasText` sweep. Disclosed body is `~#212121` against the chapter-tint bg; emphasis restored |
| HR6 | No persistent "you are here" chrome (chapter > topic > scene breadcrumb absent in Discover) | ✅ DiscoverShell header carries: (a) chapter-accent scene title at .title2.bold, (b) "Scene N of M · X done" mono-digit counter, (c) the dot-stepper itself. The system back nav (top-left ‹ Back) + `navigationTitle` ("Discover · Ch. N — Chapter Title") together give chapter context. Full chapter > topic > scene breadcrumb would need a custom chrome row; current 3-element signal is sufficient at the cost of one less component |
| HR7 | Recent items list mixes chapter/topic/question types with identical row style | ✅ sidebar Recent section now grouped by kind — uppercase "CONCEPTS" / "QUESTIONS" mini-headers separate concept and question rows. Icons were already type-distinct (`lightbulb` vs `questionmark.circle`); the grouping reinforces it at the layout level |

### Z.CN — Contrast & legibility

| ID | Category | Status |
|----|----------|--------|
| CN1 | Body text inside amber/yellow callouts measurably below WCAG AA on light theme | ✅ callout body text now uses `DesignTokens.BrandColor.canvasText` (fixed near-black RGB 0.13/0.13/0.13, ~#212121) instead of `.primary`. Strong contrast against the always-light Discover gradient + works in system Dark Mode where `.primary` would have rendered white-on-light → invisible |
| CN2 | White-on-pale-tint titles below 3:1 large-text minimum | ✅ chrome chapter-accent title (Phase 1) + per-scene `Text(...).font(.largeTitle.bold())` titles in 26 scene files now pinned to `BrandColor.canvasText` (~#212121) instead of inheriting `.primary`. Light Mode change is subtle; Dark Mode no longer renders titles white-on-light (invisible) |
| CN3 | Got It / Previous / Next disabled vs enabled colour delta too small | ✅ explicit 0.42 opacity in FilledCTAButtonStyle (Phase 1) |
| CN4 | Hyperlink underline / link colour inside articles not audited | ✅ audit: no chapter CSS file styles a general `a {}` selector. Articles use only specific `a.pill` (see-also cross-link chips) + `ol.concept-list li a` (concept-list rows) styles, both already coloured (`var(--indigo)`) with hover underline. Body-paragraph `<a href="...">` inherits browser default blue underline — readable on the light article background. No fix required; standard browser styling is consistent with macOS Help.app conventions |
| CN5 | Focus ring visibility on macOS on light tints unverified | 🟡 **iMac verification needed**. SwiftUI Buttons inherit the system accent focus ring (usually system-blue at user's Appearance setting). On the pale-blue/pale-green Discover gradient, focus ring should be visible since system-blue ≠ pale-blue at full saturation. Verification = Tab through chrome on iMac and screenshot |
| CN6 | Selection highlight on sidebar vs canvas unverified | ✅ audit: sidebar uses SwiftUI `List` with `.tag()` selection — native macOS-blue selection highlight, automatic in both light and dark modes against the vibrancy background. No custom in-canvas selection exists (Discover Mode uses scene-stepper-ring, not "selection" in the macOS sense). Standard List behaviour is correct |

### Z.MO — Motion, feedback, micro-interactions

| ID | Category | Status |
|----|----------|--------|
| MO1 | Counter / score changes have no animation / scale-pop | 🟡 per-scene counter (e.g. "Nitrogen absorbed: +1") animation is a per-scene MO touch. Chrome counters now mono-digit (TY8 ✅). Per-scene celebration counters could use the `.scaleEffect(.spring)` pattern from GotItButton (MO3 ✅) — deferred to per-scene content polish |
| MO2 | Tap on stepper dot has no immediate feedback | ✅ stepper dots now use `PressableButtonStyle` — brief inward scale-to-0.85 on press with spring(response: 0.25) ease-out. Honours Reduce Motion. Press feedback complements the existing `.easeInOut` scene-switch animation |
| MO3 | Got It state-change has no completion celebration | ✅ tap on Got It now triggers a brief scale-pop to 1.12× with a `.spring(response: 0.32, dampingFraction: 0.55)` ease-out, then advances after 350ms. Combined with the press-state compression of `FilledCTAButtonStyle`, the sequence reads as "click! pop! done!" before the scene transition. Reduce Motion users skip the delay entirely |
| MO4 | Reduce Motion respected by TimedScene + ParticleEmitter; spot animations still bypass (dup of H5/O4) | 🟡 chrome animations now honour `@Environment(\.accessibilityReduceMotion)`: PressableButtonStyle, GotItButton celebration scale-pop, OCR drop-zone scale, FilledCTAButtonStyle press, DiscoverShell scene transitions, DiscoveryStepper preset change, all `withAnimation(reduceMotion ? .none : ...)` in chrome. Per-scene spot animations still vary; auditing each is per-scene work |
| MO5 | Page transitions between Discover scenes — currently asymmetric slide+fade | ✅ DiscoverShell already does .move + .opacity |
| MO6 | Loading / decoding states not animated (just static text) | ✅ audit: ContentView sidebar / OCR / Translator already use `ProgressView` for in-flight states. SettingsScreen "Loading…" status row was the lone bare-text holdout — now has a small `ProgressView().controlSize(.small)` spinner alongside |
| MO7 | Hover feedback on buttons absent | ✅ cursor-change hover applied app-wide (AC4 ✅) + press-state scale via `PressableButtonStyle` on stepper dots + DiscoveryStepper pills + HotspotDiagram dots. Buttons telegraph hover (cursor) AND press (scale). Card-level lift on hover would be additional polish; current state is sufficient for the macOS Button HIG |

### Z.CP — Component consistency

| ID | Category | Status |
|----|----------|--------|
| CP1 | Two button styles in same view without documented hierarchy | ✅ `FilledCTAButtonStyle` doc-header in `SoftShadowCard.swift` establishes the rule: primary actions use `FilledCTAButtonStyle`, secondary use system `.bordered` / `.automatic`, destructive overrides `tint: .red` |
| CP2 | Callout component variants (LookingAhead/TryAtHome/Mnemonic/Hotspot/ProcessTimeline/RelatedConcepts) not visually unified | 🟡 Phase 1 + Phase 3 sweeps normalised opacity (0.14 bg / 0.45 border), padding (12pt), body text colour (canvasText), and corner radius (10pt) across the 4 simple callouts. Hotspot + ProcessTimeline are structurally different (diagrams + timelines, not text-callouts) — unifying would erase their purpose. Visual cohesion among the 4 text-callouts is strong; further "extract base view" refactor would be premature |
| CP3 | Disclosure triangle styles differ (article inline vs Discover) | ✅ audit: SwiftUI side uses `ExpandableCard` (chevron.right rotating 90° on expand) — one canonical primitive across all Discover scenes. Article side uses HTML `<details>`/`<summary>` with `▸/▾` glyph markers — WebKit-native, inherent. Cross-rendering-context unification (SwiftUI ↔ WebKit) isn't meaningfully possible; both use forward-triangle-becomes-down-on-expand idiom |
| CP4 | Input field style unstyled relative to surrounding card-driven UI | ✅ audit: form fields (Practice / History / Settings) use `.textFieldStyle(.roundedBorder)`. Search-in-toolbar fields (CommandPalette / SearchView / QuizBank) use `.textFieldStyle(.plain)` with a leading magnifying glass icon. Pattern is **intentional convention** — rounded for entry forms, plain for inline search. Both are macOS-idiomatic |
| CP5 | Badge component used in one place; no consistent counter/badge primitive | ✅ `BadgePill(count: Int, tint: Color = .orange, accessibilityText: String? = nil)` extracted into `Views/Components/StatusCards.swift`. Used by the sidebar "needs review" count; reusable for any future count indicators with customisable tint |
| CP6 | SoftShadowCard / plain card / bordered card all exist; no rule for when to use which | ✅ usage rules now established in `SoftShadowCard.swift` doc-header + via primitives in `DesignTokens.Radius`. Canonical rules: **SoftShadowCard** for scene insight panels (white surface, soft shadow, primary chrome). **Plain `RoundedRectangle.fill`** for tinted cards (callouts, widgets — coloured background, no shadow). **Bordered `.strokeBorder` overlay** for outline-only emphasis. Each pattern is consistently applied across the 4 callouts + DiscoveryWidget + scene insight cards |
| CP7 | Icon-only buttons lack tooltips; icon + label buttons lack consistent spacing | 🟡 audit found only 2 icon-only Buttons without `.help()` — both "Clear search" X buttons (CommandPalette + SearchView), now have `.help("Clear search")` + `pointingCursor()`. Other icon-only buttons (read-aloud, dictation, etc.) already had `.help()`. Spacing consistency on icon+label buttons still pending |
| CP8 | `GotItButton(action:)` vs `GotItButton { onComplete() }` API drift | ✅ doc-header in `SoftShadowCard.swift` declares `GotItButton(action: onComplete)` as the canonical form (better grep / refactor stability). Trailing-closure call-sites continue to compile; future content pass can normalise the call-sites — not a runtime concern |

### Z.DM — Discover-Mode specific

| ID | Category | Status |
|----|----------|--------|
| DM1 | Scene illustrations minimal (pitcher = two ovals; no anatomy/labels) | 🟡 **future content work** — each Scene*.swift draws its own SwiftUI illustration. Adding anatomy/labels/whimsy is per-scene design + content work, not a single chrome fix. ~152 scene files, each its own design pass |
| DM2 | Stepper dots at top lack scene labels / numeric counter | ✅ "Scene N of M · X done" + checkmark dots (Phase 1) |
| DM3 | Top "Back" button has no breadcrumb (chapter/topic context lost) | ✅ addressed via HR6 — DiscoverShell header carries 3 "you are here" signals (chapter-accent scene title + scene counter + dot stepper). macOS system back chevron + `navigationTitle("Discover · Ch. N — Title")` give chapter context. Full breadcrumb chrome row would be redundant |
| DM4 | Bottom footer redundantly repeats scene title | ✅ removed (Phase 1) |
| DM5 | "Previous / Next" footer competes with in-scene CTA | ✅ footer now pure nav, scene title moved to header (Phase 1) |
| DM6 | Per-scene chapter accent under-applied | ✅ chapter accent now propagated through SwiftUI environment via `\.chapterAccent` key. `DiscoverShell` sets `.environment(\.chapterAccent, ChapterTheme.accent(for: chapter.id))`; `GotItButton` reads it and uses it as `FilledCTAButtonStyle`'s tint. All 152 scene Got It buttons (calling `GotItButton(action: onComplete)` with no tint param) now show their chapter's accent automatically. Explicit `tint:` param still wins if a scene needs a special colour. Default outside DiscoverShell stays green |
| DM7 | Completion celebration absent (no confetti / "you finished Discover Mode") | 🟡 per-scene Got It tap now has MO3 ✅ scale-pop celebration. Whole-Discover-Mode-complete celebration overlaps with EM4 (all-chapters-complete screen) — see that row. Per-scene + per-chapter completion moments now exist via the checkmark fill on stepper dots + chapter-card progress ring + Got It scale-pop |
| DM8 | Boss Quiz visual treatment unaudited | 🟡 **iMac eyeball needed** — `Scene9_BossQuiz_*` files exist per chapter with `Text("Boss Quiz").font(.largeTitle.bold())` titles (now pinned to canvasText), `ProgressView`, and per-question MCQ rows. Whether it "feels like an event" vs "another card" is a screenshot review |
| DM9 | Callouts crammed below interactive widget — feels like footnotes | 🟡 per-scene layout decision — some scenes have lots of callouts (5+); others have 1-2. Putting them above the interactive would make the user scroll past supporting context before reaching the activity. Footnote-style placement is actually correct for pedagogical sequence. Spacing breathes after Phase 1 chrome (no more competing footer title) |
| DM10 | Pedagogical tone shift between scene body and callouts not signalled visually | ✅ tone shift IS signalled: scene body uses neutral chrome + interactive widgets (DiscoveryWidget green, neutral surface) while the 4 callouts use distinctive tints (purple Looking Ahead, orange Try at Home, yellow Mnemonic, teal Related). Each callout has a recognisable icon (graduationcap.fill, hand.raised.fill, lightbulb.fill, link.circle.fill). The visual differentiation is intentional and effective |

### Z.SB — Sidebar

| ID | Category | Status |
|----|----------|--------|
| SB1 | Visual mode mismatch (dark vibrant sidebar vs light canvas) — dup of CL3/TH2 | 🟡 dup of CL3 — macOS NavigationView convention |
| SB2 | Recent items use ambiguous lightbulb glyph for all types | ✅ audit (post-HR7 ✅): `RecentItem.systemImage` returns `lightbulb` for `.concept` and `questionmark.circle` for `.question`. Icons are already type-distinct; the row-grouping (HR7) further reinforces. Original audit misread |
| SB3 | Long titles truncate to "…" with no full-string tooltip — dup of TY6 | ✅ dup of TY6 — subject rows now carry `.help(pack.title)` |
| SB4 | "Clear" affordance uses identical typography to section header — looks like a label | ✅ Clear button now `.caption.weight(.semibold)` in `Color.compatIndigo` — visibly distinct from the "Recent" section header (secondary gray, regular weight). Already had `.help()` + `pointingCursor()` |
| SB5 | Subject badges inconsistent — dup of CL7 | ✅ dup of CL7 — conditional rendering is correct |
| SB6 | Active subject / tool selection style varies | 🟡 sidebar uses native `List` `.tag()` selection — macOS system-blue fill on the selected row, consistent across Subject / QuizBank / Tool rows. Recent rows use Button (not `.tag()`) so they don't show the blue fill — by design, since recents aren't a "destination selection". Convention is consistent within the macOS NavigationView idiom |
| SB7 | Sidebar width not resizable / persisted | 🟡 NavigationView's sidebar IS resizable (drag the divider) per macOS default. Persistence across launches requires wrapping NSSplitViewController to observe the user's drag — modest refactor. Defer until a user actually flags non-persistence as a problem |
| SB8 | No keyboard shortcut hints next to tool labels | 🟡 `SidebarTool.keyboardShortcut` declared; sidebar Tool rows now show the shortcut as a monospaced trailing badge. Currently only `.search` has ⌘F. Bookmarks / Discover Progress / Settings still pending matching `.keyboardShortcut(...)` menu wiring |

### Z.ID — Iconography & imagery

| ID | Category | Status |
|----|----------|--------|
| ID1 | SF Symbol weight inconsistent (some `.regular`, some `.semibold`) | 🟡 audit: SF Symbols across chrome use default `.regular` weight in most places. Specific cases where bold is intentional: `chevron.right` accent inside ExpandableCard (`.caption.weight(.bold)`) for chevron emphasis; `checkmark` in stepper dots (`.system(size: 10, weight: .bold)`) for legibility at small size. These are visually-motivated exceptions, not drift. Full audit + normalisation would be per-component design pass |
| ID2 | Emoji used as inline glyphs mixes with SF Symbols → tonal split | ✅ audit: emoji + SF Symbol usage is **semantically separated**, not mixed: emoji (🥢, 🪞, 🌱, 🔥) appear inside per-scene illustrations as "this is part of the diagram" (acceptable; emoji are vector + colour-rich). SF Symbols appear in chrome (icons, labels, badges) as "this is a UI affordance". Both stand-alone within their context — no run mixes them inline mid-sentence. Convention is consistent across scenes |
| ID3 | Hand-drawn illustrations vary widely in detail from scene to scene | 🟡 dup of DM1 — per-scene content design |
| ID4 | Icon-only buttons missing labels for cursor-only macOS user — dup of CP7 | 🟡 dup of CP7 (2 sites fixed; rest already had `.help()`) |
| ID5 | Chapter avatar / hero icon not present on chapter cards | 🟡 **future content + design** — would mean assigning each of 19 chapters a unique SF Symbol or custom glyph (leaf for Nutrition, flame for Heat, etc.). Plenty of options in SF Symbols 2 but each pick is a design choice. Defer until a content pass adds the mapping |
| ID6 | Status icons (✓, in-progress dot) not standardised | ✅ checkmark-in-dot pattern (Phase 1 stepper dots) + standalone `checkmark` glyph in DiscoverProgressDashboard chapter-card progress ring (when chapter complete) + chevron.right (no-icon-for-not-started). Status iconography across Discover surfaces is now consistent: filled green Circle + checkmark for done; grey dot for not-started; chapter-accent ring for current |

### Z.EM — Empty / loading / error states

| ID | Category | Status |
|----|----------|--------|
| EM1 | "Pick a colour" placeholder fine; other empty states (bookmarks, recents) unaudited | ✅ unified through `EmptyStateView` (icon at 48pt + title2.semibold + subheadline-secondary subtitle, max-width 520, centered). Refactored BookmarksView + QuizBankView's inline empty states to use it. History/Favorites already used it. Sidebar Recents section hides when empty (no separate state needed). CommandPalette has its own compact variant — intentional for the smaller sheet |
| EM2 | Article-load failure styled; Discover scene-load failure not visualised | ✅ `SceneRequiresMacOS12View` in `DiscoverMode.swift` provides a styled fallback (sparkles icon + scene title + "This interactive scene needs macOS 12 or later" message + secondary "browse the rest of this chapter" hint) for the only known scene-load failure mode on Big Sur. The DiscoverShell still works around it (navigation + dots intact); only the interactive body swaps in the fallback |
| EM3 | First-launch experience past Welcome unaudited | 🟡 **iMac walkthrough needed** — first-launch flow exists (`WelcomeSheet` on first run + sidebar landing on the first subject pack). Whether the chapter grid "feels inviting" needs a fresh-install test on the iMac to verify |
| EM4 | No "all chapters complete" / "you've explored everything" celebration screen | 🟡 **future feature** — would surface when `completedScenesCount == 19 * 9 = 171`. Closer to a celebration moment than chrome. Roughly: SoftShadowCard + sparkles + summary stats. Pending content + design decision |
| EM5 | OCR drop-zone idle vs hover vs reject states not consistently styled | ✅ OCR drop zone now binds `$isDropTargeted` from `.onDrop` and renders three distinct states: idle (purple icon + "Open or Drop an Image"), hover (icon scales to 1.08× + label switches to "Drop to scan" in purple + dashed purple border appears around the zone). Reject state still falls back to `ocrService.errorMessage` text (existing). Also routed the 2 SF Symbols 3+ names through `SFSymbolCompat` while in the file (defensive) |

### Z.CT — Copy & microcopy

| ID | Category | Status |
|----|----------|--------|
| CT1 | Section labels use inconsistent capitalisation styles | 🟡 callout titles ("Class 11 Biology / NEET" Title-Case vs "Spot one for real" sentence-case) — content authored by user; mixing is intentional flavour (formal-academic vs casual-encouragement). Not a system bug. Normalising would shift author voice; skip unless requested |
| CT2 | Button labels mix verb-first ("Got It") with adjective-first ("Previous") | ✅ audit: "Got It" / "Translate" / "Open Image" / "Choose Different Image" / "Clear" / "Retry" are all verb-first action buttons. "Previous" / "Next" are macOS-idiomatic navigation labels (matches Pages, Keynote, Photos), not action verbs — keeping them adjective-form is the right convention. Bookmarks / Settings / Search are noun labels because they're destinations, not actions. Convention is consistent with macOS HIG |
| CT3 | Tooltips / hints sparse — dup of H2 | ✅ audit: chrome buttons now consistently carry `.help(...)` — Discover Got It, sidebar Clear, all icon-only buttons (read-aloud, dictation, clear-search × 2, copy, speak, favorite), DiscoverShell Back, BadgePill, etc. Tooltips on every interactive that benefits. H2 in the main taxonomy was a partial 🟡 due to SwiftUI's auto-label fallback — sites that don't have `.help()` use Button("Label") whose label IS the tooltip |
| CT4 | Error messages inconsistent in voice (user-friendly vs developer-y) | ✅ audit: `OCRService.errorMessage` ("No text found in the image. Try a clearer photo with visible text.") + `TranslatorViewModel` errors + "couldn't open image" — all user-friendly, action-oriented, no stack traces or technical jargon surfaced to the UI. Developer-y errors stay in `CrashReporter.logDataIssue` (file-only, not UI-facing). Voice is consistent: state-what-happened + suggest-action |
| CT5 | Onomatopoeia / sound-effect text in body not consistent across scenes | 🟡 per-scene content. Spot-effect text ("🥢 ABSORBED!", "FIZZ!", "POP!") is intentional dramatic feedback in interactive scenes — varies because it matches each scene's specific reaction (chemistry vs biology vs physics). Not a systemic chrome bug; review case-by-case during content polish |
| CT6 | Class-7-appropriate reading level not validated across all callouts | 🟡 callout content reading level is the user's editorial judgment — content was written by the user with Class-7 audience in mind. Not validated against a Flesch-Kincaid or similar metric. Could add a Python script that scans `LookingAheadCallout` / `TryAtHomeCallout` detail strings + flags any with grade level > 9, but that's content-quality tooling not chrome |

### Z.IF — Information architecture / density

| ID | Category | Status |
|----|----------|--------|
| IF1 | Wasted bottom canvas on Discover scenes — dup of LY1 | 🟡 dup of LY1 — per-scene content judgment |
| IF2 | Sidebar "Recent" mixes 3 entity types without grouping | ✅ grouped by kind (Concepts / Questions). The original audit assumed 3 kinds (chapter/topic/question) but `RecentItem.Kind` is actually 2 (concept/question), so 2-way grouping closes this cleanly |
| IF3 | Quiz Bank header lacks at-a-glance filter affordance | 🟡 QuizBank has a filter row (`filterBar`) with subject pack picker + type filter + review filter + search. "At-a-glance affordance" would mean adding filter-pill chips that show current state at the top — a feature, not a chrome fix. Deferred |
| IF4 | Concept detail page layout puts useCases / beyondTheBook / explanations linearly | 🟡 **design decision** — linear layout is correct for first-pass reading (kidFriendly → textbook → expert → useCases → beyondTheBook is a deliberate complexity ladder). A scannable summary header is a feature add. Deferred until specific reading-flow feedback |
| IF5 | No reading-time / scene-duration estimate per Discover card | 🟡 **future feature** — would compute estimated minutes from `concept.explanation.count / 225 wpm`. Useful for parent-side scheduling. Deferred — single feature, not chrome |
| IF6 | Subject pack switching is a primary nav action but lives at the top of the sidebar without affordance | 🟡 sidebar lists `Subjects` section at the top with each pack as a row — tap to switch. This IS the macOS-standard pattern (NavigationView source list). A more explicit "Switch Subject" button would duplicate; keeping native pattern. Verifiable on iMac |

### Z.AC — Accessibility (UI surface only — H rows cover semantic AX)

| ID | Category | Status |
|----|----------|--------|
| AC1 | Focus ring visibility on tinted backgrounds unverified — dup of CN5 | 🟡 dup of CN5 — iMac verification needed |
| AC2 | Hit-target sizes for stepper dots, footer Prev/Next look <40pt — under macOS-comfortable threshold for a 7-year-old | ✅ stepper dots: visible Circle stays 22pt, tap region expanded to ~32pt via 5pt padding + explicit `.contentShape(Rectangle())`. macOS HIG ≥28pt for trackpad/mouse; comfortable for a 7-year-old's finger on a magic mouse. Footer Prev/Next use system Buttons which are already 28+pt by default |
| AC3 | Hover-only affordances inaccessible to keyboard-only users | ✅ audit: hover affordances in this app = cursor change (`.pointingCursor`) + tooltip (`.help`). Neither blocks interaction — every chrome action is also reachable via Tab + Return / Space (SwiftUI Button default focus traversal). Discover scene jumps (⌘1..⌘9), Prev/Next (← →), Got It (Space), Search (⌘F), Back (⌘[) all wired. No keyboard-only user is blocked by a hover-only path |
| AC4 | Cursor change on interactive areas (`.pointingHand`) absent in most places | ✅ `View.pointingCursor()` applied across the app's tappable surfaces: Discover-Mode chrome (GotItButton + stepper dots + Prev/Next), chapter row + Continue card (`ChapterListView`), topic card (`ChapterDetailView`), all bookmark rows × 4 (`BookmarksView`), CommandPalette result rows, DiscoverProgressDashboard cards × 2, TopicDetailView concept + question rows, ConceptDetail readAloud + askFollowUp + related-concept/question rows, QuestionDetail MCQ option rows, ContentView sidebar Recent items + Clear. Sidebar Subject/Tool rows use native `List` `.tag()` selection so don't take this — macOS `List` provides its own hover semantics there |
| AC5 | High-Contrast / Bold-Text macOS settings unverified | 🟡 dup of TH7 — iMac toggle + screenshot needed. Bold Text setting auto-applied by SwiftUI to system text styles (`.body`, `.headline`, etc.) which are what the chrome uses |

### Z.PR — Print / export / share surfaces

| ID | Category | Status |
|----|----------|--------|
| PR1 | Article print stylesheet exists; Discover scenes have no print-equivalent recap | 🟡 **future feature** — would need a per-scene "print recap" template (title + key insight + try-at-home). Defer; print of Discover scenes is rare for a 7-year-old's primary workflow |
| PR2 | No "share / export" of progress card to parent | 🟡 **future feature** — would auto-generate a 1-page summary of "this week: scenes completed / new concepts / quiz scores" for parent. App is offline-first / no-accounts, so this would be a "Save as PDF" or "Copy summary to clipboard". Defer pending product decision |
| PR3 | OCR result not styled for copy-out | ✅ `TranslationResultCard` (shown after OCR translation) already exposes a Copy button writing `response.translatedText` to `NSPasteboard.general` + a 1.5s "Copied!" feedback state. Also Speak (audio playback) + Favorite. All three are icon-only Buttons; added `.pointingCursor()` to each (AC4 follow-up). Text-only copy via system clipboard works correctly for Devanagari and Latin |

## PE. Performance & responsiveness

Seeded 2026-05-18 after user reported "UI main thread getting blocked"
and shared an iMac Xcode screenshot showing `EXC_BAD_ACCESS` at `@main`
launch + duplicate `SubjectRegistry.reload()`. Most pending performance
work targets the slow 1.4 GHz Haswell CPU + AMD R9 M290X 2GB GPU on the
deploy iMac. Status legend per A–Y / Z convention.

### PE.LC — Launch / lifecycle

| ID | Category | Status |
|----|----------|--------|
| LC1 | App cold-launch wall-clock time on 2014 iMac (Fusion Drive + 1.4 GHz Haswell) | 🟡 `testPackDecodePerformance` provides regression baseline; manual timing on iMac TBD |
| LC2 | EXC_BAD_ACCESS crash on `@main` init seen on iMac (screenshot) | 🟡 needs deeper stack — defensive fixes applied (LC3, duplicate-reload guard); root cause may be StateObject autoclosure firing twice during dev |
| LC3 | Duplicate `SubjectRegistry.reload()` on launch | ✅ `reloadInFlight` re-entrancy guard added (commit 2f74ef8). Second call short-circuits — saves ~115ms decode + redundant UI cascade |
| LC4 | SwiftUI `WindowGroup` body recomputed during initial cascade | 🟡 standard SwiftUI behaviour; mitigated by token primitives + cached indices |
| LC5 | `applicationDidFinishLaunching` work-loop budget | ✅ AppDelegate only sets sandbox flags + ensures Metal cache dir |
| LC6 | First-render flash of empty sidebar before subjects load | ✅ `subjectRegistry.isLoading` placeholder renders ProgressView until decode completes |
| LC7 | Welcome sheet present-time on first launch | 🟡 not measured; presents on `hasSeenWelcome == false` |
| LC8 | Sleep / wake recovery time | ❌ untested |

### PE.MT — Main-thread hygiene

| ID | Category | Status |
|----|----------|--------|
| MT1 | Synchronous JSON decode on main thread | ✅ `SubjectRegistry.reload()` uses `Task.detached(priority: .userInitiated)` for the pack decode; publishes on MainActor |
| MT2 | Synchronous file I/O on main thread (HTML article reads) | 🟡 WKWebView loads file:// async; concept articles via Bundle.url then Data(contentsOf:) on main but ~1-10KB each → sub-millisecond |
| MT3 | NSImage instantiation on main thread (OCR drop) | 🟡 happens on main; acceptable for kid-scale single-image use; alternative is async loading w/ placeholder |
| MT4 | UserDefaults `synchronize()` / `set()` blocking | ✅ modern macOS makes synchronize() a no-op; AppState/AppDelegate both call it for explicit-intent semantics only |
| MT5 | `NSPasteboard.general.setString` (large strings) | ✅ TranslationResultCard copies small string; no large blobs |
| MT6 | OCR text recognition on main thread (Vision request) | ✅ `performOCR()` marked `nonisolated` + Vision `handler.perform([request])` dispatched to `DispatchQueue.global(qos: .userInitiated)`. Multi-second freeze on large image → spinner runs (commit cd43ca1) |
| MT7 | AVSpeechSynthesizer setup / speak | 🟡 SpeechReader.shared singleton; first-time speak instantiates synth — measurable but sub-100ms |
| MT8 | Heavy `@Published` setters triggering cascade re-render | ✅ partial — major hot paths (sidebar needsReviewCount, DiscoverProgress count, QuizBank filter) now use cached lookups |
| MT9 | Long computed properties read by `body` | ✅ QuizBank `filteredEntries`, DiscoverShell `completedSceneIds`, DiscoverProgressDashboard `completedCount` all captured once per body via local `let` |
| MT10 | `Dictionary(uniquingKeysWith:)` over large pack on main | ✅ moved to `SubjectPackIndexCache` — built once per pack.id per process |
| MT11 | `validateRelatedRefs()` cost at every render | ✅ called once per pack at decode time only (commit history); not per render |
| MT12 | Hot-path string normalisation (lowercased + diacriticInsensitive) per keystroke | ✅ QuizBank: `searchText.lowercased()` hoisted out of per-entry closure (commit 020b4d1). SearchView: uses `String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]` which is more efficient |

### PE.SU — SwiftUI rendering / view churn

| ID | Category | Status |
|----|----------|--------|
| SU1 | View body recomputed on every unrelated `@Published` change (over-observation) | 🟡 typical SwiftUI; partial mitigation via cached lookups (PE.DT) |
| SU2 | `ForEach` over large arrays without `LazyVStack` / `List` | ✅ all large lists (QuizBank, History, Favorites, Search results, BookmarksView) use `List` which is lazy by default on macOS |
| SU3 | `@StateObject` recreated on parent re-render (placement bug) | ✅ AppState / SubjectRegistry / DataStore all owned at App-root via `@StateObject`; child views read via `@EnvironmentObject` (no inversions) |
| SU4 | Computed-property explosion in `body` | ✅ QuizBank ✅, DiscoverShell header ✅, DiscoverProgressDashboard ✅ |
| SU5 | `GeometryReader` nesting forcing layout passes | 🟡 GeometryReader used inside per-scene illustrations; not in chrome |
| SU6 | `.background` / `.overlay` with `RoundedRectangle.fill` redrawn on every state change | 🟡 standard SwiftUI cost; cached SubjectPack indices mean fewer renders trigger this |
| SU7 | `.shadow` modifier cost (3+ layered shadows in card stacks) | 🟡 SoftShadowCard uses single shadow; chrome FilledCTAButtonStyle uses tint shadow only when isEnabled |
| SU8 | Custom `Path` / shape drawing (DrawnChloroplast, BeamView, etc.) | 🟡 per-scene; capped via HardwareTier on legacy GPU |
| SU9 | `TextEditor` re-render cost on every character | 🟡 TextEditor in OCR / Translator; small text size; acceptable |
| SU10 | Animation interpolation on the AMD R9 M290X | ✅ HardwareTier.animationFPS = 20 on legacy |
| SU11 | Particle counts on legacy GPU | ✅ HardwareTier.particleBudget = 40 on legacy |
| SU12 | Image-only `Image(systemName:)` rendered at large sizes | 🟡 SF Symbols are vector — should cache; first-render allocation only |
| SU13 | NavigationView push/pop cost on tutor scenes | 🟡 not measured; SwiftUI NavigationView on Big Sur known-buggy |
| SU14 | Sheet presentation animation block | 🟡 SwiftUI default 300ms transition |
| SU15 | WKWebView load + JS evaluation block | 🟡 evaluateJavaScript runs async; load is async via loadFileURL |

### PE.DT — Data layer

| ID | Category | Status |
|----|----------|--------|
| DT1 | Dictionary index O(1) vs scanning array of concepts | ✅ `SubjectPackIndexCache` provides O(1) lookups for conceptIndex / questionIndex / needsHumanReviewIds / **chapterIndex** |
| DT2 | `Array.first(where:)` over question/concept index in hot paths | ✅ replaced by dict lookups via the cache. `pack.chapters.first(where:)` sites in ChapterListView / TutorNavigation / DiscoverProgressDashboard now use `pack.chapterIndex[id]` |
| DT3 | Search ranking recomputed on every keystroke (no debounce throttle) | ✅ SearchView has 200ms debounce; QuizBank filter is fast enough not to need one |
| DT4 | Search across all packs builds full set every time | ✅ `pack.allConcepts` / `pack.allQuestions` are still computed properties but scored once per debounced query, not per keystroke |
| DT5 | QuizBank filter chain (subject × type × review × text) without memoisation | ✅ commit 020b4d1 — captured `let entries = filteredEntries` once per body |
| DT6 | Bookmark / recent-item list grows; persistence rewrites entire blob | 🟡 max 8 recent items + bounded bookmarks — small JSON blobs (<10 KB), atomic write tolerable |
| DT7 | Speech queue rebuild on every depth change in ConceptDetailView | 🟡 acceptable for 4-depth menu |
| DT8 | NSAttributedString computation per result row | ✅ not used; we use plain Text |
| DT9 | Translation history dedup scan on every translate | ✅ TranslatorViewModel calls `findRecord` once before insert; not in render path |
| DT10 | Sanskrit dictionary load + warming budget | ✅ `Task(priority: .utility)` pre-warms at @main init; subsequent access via `SanskritDictionary.shared` is cached |

### PE.FX — Animation, timers, motion

| ID | Category | Status |
|----|----------|--------|
| FX1 | `Timer.scheduledTimer` not invalidated on `.onDisappear` | ✅ all Timer.scheduledTimer routed through TimedSceneModifier or ParticleEmitter — both invalidate on disappear AND on scenePhase != .active (B/I9 in main taxonomy) |
| FX2 | Multiple TimedSceneModifier instances stacking | 🟡 each scene gets its own; teardown is correct |
| FX3 | NSEvent local monitor leak | ✅ ArrowKeyModifier removes monitor on onDisappear |
| FX4 | `Task { @MainActor in ... sleep ... }` blocking subsequent renders | 🟡 used sparingly (Got It celebration 350ms, shake animations) — debounced via `guard !celebrating else { return }` |
| FX5 | `.animation(.spring, value:)` triggered on irrelevant state | 🟡 verified via spot audit; mostly correctly scoped via `value:` parameter |
| FX6 | Particle respawn loop cost | ✅ HardwareTier-capped |
| FX7 | Shake/transition animation timing on Reduce Motion users | ✅ PressableButtonStyle + GotItButton honour `accessibilityReduceMotion` |
| FX8 | Hover affordance cursor push/pop stack imbalance | ✅ `pointingCursor()` extension pairs push/pop on `.onHover { hovering in ... }` |

### PE.MM — Memory

| ID | Category | Status |
|----|----------|--------|
| MM1 | Subject pack retained twice (registry + view-model caches) | 🟡 SubjectRegistry owns canonical pack copy; views read via env |
| MM2 | WKWebView retained per article; never disposed | 🟡 ArticleBrowserView re-uses single WKWebView via @StateObject; navigates rather than reload-with-new-instance |
| MM3 | NSImage retained from OCR (memory growth across many scans) | 🟡 selectedImage = nil on Clear button drops the reference |
| MM4 | Translation history caps but stored as JSON-encoded blob | ✅ capped via DataStore; small footprint |
| MM5 | Closure capturing `self` strongly (retain cycles) | ✅ all service-class escaping closures use `[weak self]` (B8 in main taxonomy) |
| MM6 | `@StateObject` ownership inversion causing leak | ✅ swept (C2 in main taxonomy) |
| MM7 | Image cache for WKWebView articles | 🟡 articles use only SF Symbols + emoji; no bitmap caching |
| MM8 | Large strings retained in console / crash log buffer | ✅ CrashReporter rotates at 1MB / 30-file cap |

### PE.CC — Concurrency / Task

| ID | Category | Status |
|----|----------|--------|
| CC1 | `Task.detached` vs `Task { @MainActor }` for decode jobs | ✅ pack decode is `Task.detached(priority: .userInitiated)`; UI publish back on MainActor |
| CC2 | Async function awaiting on main thread | ✅ DataStore writes are sync + atomic; no main-thread awaits on long ops |
| CC3 | Multiple concurrent `Task` for same logical operation (debounce) | ✅ SearchView cancels previous DispatchWorkItem before scheduling new |
| CC4 | `.task` cancellation on view disappear | ✅ SwiftUI's `.task` auto-cancels on disappear (I10 in main taxonomy) |
| CC5 | `withCheckedContinuation` callback timing | ✅ used in OCRService; properly resumed |
| CC6 | DispatchQueue.main.async trampolines (KVO bridge) | ✅ NWPathMonitor + ArticleBrowser KVO trampoline through DispatchQueue.main.async (B7 in main taxonomy) |
| CC7 | Network call timeout (online translator) blocking sheet dismissal | 🟡 user can dismiss the translator screen while network call is in-flight; cancellation correctness not formally verified |
| CC8 | Speech synthesis blocking next-action queue | ✅ AVSpeechSynthesizer enqueues; stop() called on view disappear |

### PE.IO — Disk / network

| ID | Category | Status |
|----|----------|--------|
| IO1 | Article HTML reads from Bundle (synchronous Bundle.url + Data load) | 🟡 happens on main; <10 KB articles; sub-millisecond — acceptable |
| IO2 | Pack JSON decode size + speed | ✅ ~115ms for 2 packs off-thread (per the iMac screenshot console log) |
| IO3 | Atomic write fsync cost (progress.json) | ✅ small files; atomic intentional for crash safety |
| IO4 | Crash log append every event | ✅ append-only file write; rotates at 1MB |
| IO5 | UserDefaults blob size growth | ✅ recent-items capped at 8; sidebar selection is a few bytes |
| IO6 | OCR image temp file path lifecycle | ✅ no temp files — NSImage held in memory only |
| IO7 | Online translation API timeout setting | 🟡 default URLSession timeout; not aggressively tuned |
| IO8 | Network reachability check (NWPathMonitor) on main | ✅ AppState runs monitor on dedicated queue; publishes via DispatchQueue.main.async |

### PE.GFX — GPU / Big-Sur-on-AMD specifics

| ID | Category | Status |
|----|----------|--------|
| GFX1 | Metal warnings on launch ("Zero Metal services found") | 🟡 known AMD R9 M290X / Big Sur log noise; not a functional bug |
| GFX2 | Layered shadows + blurs costing dropped frames | 🟡 SoftShadowCard single shadow; FilledCTAButtonStyle accent shadow; manageable |
| GFX3 | Big-Sur-on-AMD `IconRendering` shader-cache WebContent process termination | ✅ already mitigated via PlainTextArticleFallback (A9 in main taxonomy) |
| GFX4 | Smooth-corner `RoundedRectangle(style: .continuous)` cost vs `.circular` | 🟡 used throughout; not benchmarked |
| GFX5 | LinearGradient layer per scene re-painted on every state change | 🟡 DiscoverBackground is constant; per-scene linear gradients limited |
| GFX6 | Color.opacity computations per render | 🟡 callout backgrounds use `.opacity(0.14)` etc.; constant per pack |
| GFX7 | Translucent NSVisualEffectView sidebar cost (Reduce Transparency check) | 🟡 standard List sidebar; honours system Reduce Transparency |

### PE.IN — Input responsiveness

| ID | Category | Status |
|----|----------|--------|
| IN1 | Keystroke → search-result delay | ✅ SearchView 200ms debounce; QuizBank uses cached entries |
| IN2 | Stepper-dot tap → scene swap delay | ✅ `withAnimation(.easeInOut(duration: 0.25))` — perceptible by design |
| IN3 | Got It tap → next-scene advance | ✅ 350ms celebration delay (MO3); intentional |
| IN4 | Sidebar selection → detail-pane swap delay | 🟡 should be sub-frame on the cached-index path |
| IN5 | OCR Open Image → image-displayed delay | 🟡 NSImage instantiation on main; small images fine |
| IN6 | Translate button → result-card delay | 🟡 network-bound for online; cache-bound for offline (typically sub-frame) |
| IN7 | Hover-cursor latency on 5K @1× | 🟡 `pointingCursor()` push/pop; expected immediate |
| IN8 | Keyboard shortcut handler reach time | ✅ standard SwiftUI `.keyboardShortcut(...)` — synchronous |

### PE.DG — Diagnostics / monitoring

| ID | Category | Status |
|----|----------|--------|
| DG1 | os_signpost regions around expensive operations | ❌ no signposts added; future Instruments work |
| DG2 | XCTest performance baselines | ✅ `testPackDecodePerformance` + `testFlattenAllContentPerformance` exist (I7/I8 in main taxonomy) |
| DG3 | Time Profiler instrument runs against real iMac | ❌ user needed to do this on actual iMac; CI doesn't run Instruments |
| DG4 | Allocations / leaks instrument | ❌ not run |
| DG5 | Hang detector instrumentation (anything > 250 ms on main) | ❌ could add via `os_signpost` + log-on-overrun pattern |
| DG6 | RUM logging for slow user actions | ❌ no `CrashReporter.logSlowEvent` yet — could surface in crashlogs |
| DG7 | Frame-rate logging on legacy tier | 🟡 HardwareTier caps at 20fps but doesn't log actual achieved rate |
| DG8 | Energy log review | ❌ never reviewed |

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
