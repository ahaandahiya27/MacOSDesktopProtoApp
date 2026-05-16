# Big Sur Backport Audit

## Summary

| Metric | Value |
|--------|-------|
| Total .swift files | 156 |
| Total SLOC | 27,189 |
| Total incompatible API call sites | **~780+** |
| Estimated effort | **70–100 hours** |
| Recommended strategy | **C — Mixed: some features must be disabled on Big Sur** |

### Critical constraint

**Xcode 13.2.1 ships the macOS 12.1 SDK.** This means:
- macOS 13+ APIs (NavigationStack, ImageRenderer, LabeledContent, etc.) are **not in the SDK** — they cannot even be referenced behind `#available`. They must be **fully replaced**.
- macOS 14+ APIs (SwiftData, @Bindable, ContentUnavailableView, .onKeyPress, etc.) are **not in the SDK** — must be **fully replaced**.
- macOS 12 APIs (Canvas, TimelineView, .foregroundStyle, .focused, .searchable, etc.) **are** in the SDK and can be gated with `if #available(macOS 12, *)`, but won't execute on Big Sur 11. Fallbacks needed.

---

## Findings by Category

### 1. SwiftData (macOS 14+ — NOT in Xcode 13 SDK) — CRITICAL

SwiftData is the entire persistence layer. **6 @Model classes, ~20+ consumer files, ~120+ call sites.** This is the single largest blocker. Must be replaced with **UserDefaults + JSON file storage** (simpler than Core Data for this use case).

| File | Lines | API | Replacement strategy |
|------|-------|-----|----------------------|
| Models/TranslationRecord.swift | 2,5 | `import SwiftData`, `@Model` | Replace with Codable class + JSON file persistence |
| Models/PracticeProgress.swift | 2,5 | `import SwiftData`, `@Model` | Replace with Codable class + JSON file persistence |
| Models/StudyState.swift | 2,8,27,46 | `import SwiftData`, `@Model` (×3: StudyBookmark, QuestionAttempt, StudySession) | Replace with Codable classes + JSON file persistence |
| Subjects/Tutor/Discover/DiscoverProgress.swift | 2,11 | `import SwiftData`, `@Model` | Replace with Codable class + JSON file persistence |
| Extensions/ModelContext+SafeSave.swift | 2,4-13 | `import SwiftData`, `extension ModelContext` | Replace with persistence manager helper |
| desktopAhaanApp.swift | 2,21-43,50 | `import SwiftData`, `ModelContainer`, `ModelConfiguration`, `.modelContainer()` | Replace with custom persistence manager injected via `.environmentObject()` |
| Views/Home/TranslatorScreen.swift | 2,8,94,138 | `import SwiftData`, `@Environment(\.modelContext)`, `modelContext` usage | Use persistence manager |
| Views/History/HistoryScreen.swift | 2,5,9,38,60-62,101 | `import SwiftData`, `@Query`, `@Environment(\.modelContext)`, `@Bindable` | Replace @Query with @Published array, @Bindable with @ObservedObject |
| Views/Favorites/FavoritesScreen.swift | 2,5-6,12,44 | `import SwiftData`, `@Query`, `#Predicate`, `@Environment(\.modelContext)` | Replace with persistence manager |
| Views/Practice/PracticeScreen.swift | 2,6,25,284,309,315 | `import SwiftData`, `@Environment(\.modelContext)`, `ModelContext` param | Use persistence manager |
| Views/Settings/SettingsScreen.swift | 2,26,301-303 | `import SwiftData`, `@Environment(\.modelContext)`, `modelContext.delete(model:)` | Use persistence manager |
| Views/OCR/OCRTranslationScreen.swift | 2,11,51,151 | `import SwiftData`, `@Environment(\.modelContext)` | Use persistence manager |
| ViewModels/TranslatorViewModel.swift | 3,59,86-90,107-133 | `import SwiftData`, `ModelContext`, `#Predicate`, `FetchDescriptor` | Replace with persistence manager methods |
| ViewModels/PracticeViewModel.swift | 3,62,74,77,89-109 | `import SwiftData`, `ModelContext`, `#Predicate`, `FetchDescriptor` | Replace with persistence manager methods |
| Subjects/Tutor/BookmarksView.swift | 2,9-10,43,45 | `import SwiftData`, `@Query`, `@Environment(\.modelContext)` | Replace with persistence manager |
| Subjects/Tutor/ConceptDetailView.swift | 2,14-15,268-276 | `import SwiftData`, `@Environment(\.modelContext)`, `@Query` | Replace with persistence manager |
| Subjects/Tutor/QuestionDetailView.swift | 2,12,161,167 | `import SwiftData`, `@Environment(\.modelContext)` | Replace with persistence manager |
| Subjects/Tutor/Discover/DiscoverChapter1View.swift | 2,18-19,30,190,192 | `import SwiftData`, `@Environment(\.modelContext)`, `@Query`, `#Predicate` | Replace with persistence manager |
| Subjects/Tutor/Discover/Chapter2/DiscoverChapter2View.swift | 2,15-16,27,186,188 | Same pattern | Replace with persistence manager |
| Subjects/Tutor/Discover/Chapter3/DiscoverChapter3View.swift | 2,15-16,27,186,188 | Same pattern | Replace with persistence manager |
| Subjects/Tutor/Discover/Chapter4/DiscoverChapter4View.swift | 2,9-10,21,180,182 | Same pattern | Replace with persistence manager |
| Subjects/Tutor/Discover/Chapter5/DiscoverChapter5View.swift | 2,9-10,21,180,182 | Same pattern | Replace with persistence manager |
| Subjects/Tutor/Discover/Chapter6/DiscoverChapter6View.swift | 2,9-10,21,180,182 | Same pattern | Replace with persistence manager |
| Subjects/Tutor/Discover/Chapter7/DiscoverChapter7View.swift | 2,9-10,21,136,138 | Same pattern | Replace with persistence manager |
| Subjects/Tutor/Discover/Chapter19/DiscoverChapter19View.swift | 2,9-10,21,180,182 | Same pattern | Replace with persistence manager |

### 2. Navigation APIs (macOS 13+ — NOT in Xcode 13 SDK)

Must be **fully replaced** with NavigationView (available macOS 10.15+).

| File | Line | API | Replacement strategy |
|------|------|-----|----------------------|
| ContentView.swift | 16 | `NavigationSplitView` | Replace with `NavigationView { sidebar; detail }` |
| Subjects/Tutor/AskFollowUpView.swift | 19 | `NavigationStack` | Replace with `NavigationView` |
| Subjects/Tutor/QuizBankView.swift | 44 | `NavigationStack(path:)` | Replace with NavigationView + programmatic NavigationLink |
| Subjects/Tutor/QuizBankView.swift | 76 | `.navigationDestination(for:)` | Replace with NavigationLink(destination:) |
| Subjects/Tutor/QuizBankView.swift | 61 | `NavigationLink(value:)` | Replace with NavigationLink(destination:) |
| Subjects/Tutor/SanskritSubjectHomeView.swift | 20 | `NavigationStack` | Replace with `NavigationView` |
| Subjects/Tutor/SubjectHomeView.swift | 13 | `NavigationStack(path:)` | Replace with NavigationView + state-driven navigation |
| Subjects/Tutor/SubjectHomeView.swift | 15 | `.navigationDestination(for:)` | Replace with NavigationLink(destination:) |
| Subjects/Articles/ArticleBrowserView.swift | 21 | `NavigationStack` | Replace with `NavigationView` |
| Subjects/Tutor/ChapterListView.swift | 9 | `NavigationLink(value:)` | Replace with NavigationLink(destination:) |
| Subjects/Tutor/ChapterDetailView.swift | 20,27 | `NavigationLink(value:)` (×2) | Replace with NavigationLink(destination:) |
| Subjects/Tutor/ConceptDetailView.swift | 228,244 | `NavigationLink(value:)` (×2) | Replace with NavigationLink(destination:) |
| Subjects/Tutor/TopicDetailView.swift | 21,30 | `NavigationLink(value:)` (×2) | Replace with NavigationLink(destination:) |

### 3. Other macOS 14+ APIs (NOT in Xcode 13 SDK)

| File | Line | API | Replacement strategy |
|------|------|-----|----------------------|
| ContentView.swift | 110 | `ContentUnavailableView` | Replace with custom VStack(Image+Text) |
| Subjects/Tutor/SearchView.swift | 37 | `ContentUnavailableView` | Replace with custom VStack |
| Subjects/Tutor/BookmarksView.swift | 15 | `ContentUnavailableView` | Replace with custom VStack |
| Subjects/Tutor/QuizBankView.swift | 54 | `ContentUnavailableView` | Replace with custom VStack |
| Subjects/Tutor/QuizBankView.swift | 81 | `ContentUnavailableView` | Replace with custom VStack |
| Subjects/Tutor/SubjectHomeView.swift | 58 | `ContentUnavailableView` | Replace with custom VStack |
| Views/History/HistoryScreen.swift | 100 | `@Bindable` | Replace with separate view approach (pass record and closure) |
| Views/Components/TranslationResultCard.swift | 26 | `.symbolEffect(.pulse)` | Remove (cosmetic only) |
| Views/Components/InputCard.swift | 63 | `.symbolEffect(.pulse)` | Remove (cosmetic only) |
| 8 DiscoverChapter*View files | 49-50 | `.onKeyPress(.leftArrow/.rightArrow)` (×16) | Replace with `.onAppear` + NSEvent local monitor |

### 4. macOS 13+ APIs (NOT in Xcode 13 SDK)

| File | Line | API | Replacement strategy |
|------|------|-----|----------------------|
| Views/Settings/SettingsScreen.swift | 118,158,201,203,205,231,241,267-272 | `LabeledContent` (×10) | Replace with `HStack { Text(...) Spacer() content }` |
| Views/Components/InputCard.swift | 27 | `.scrollContentBackground(.hidden)` | Remove modifier |
| 7 BossQuiz scene files | various | `ImageRenderer` (×7) | Replace with AppKit-based PDF rendering |

**ImageRenderer occurrences:**
- Scenes/Scene9_BossQuiz.swift:222
- Chapter3/Scenes/Scene9_BossQuiz_Ch3.swift:213
- Chapter4/Scenes/Scene9_BossQuiz_Ch4.swift:218
- Chapter5/Scenes/Scene9_BossQuiz_Ch5.swift:213
- Chapter6/Scenes/Scene9_BossQuiz_Ch6.swift:211
- Chapter7/Scenes/Scene9_BossQuiz_Ch7.swift:186
- Chapter19/Scenes/Scene9_BossQuiz_Ch19.swift:213

### 5. macOS 12+ APIs (IN Xcode 13 SDK — need `#available` gate OR replacement)

These APIs exist in the macOS 12.1 SDK that ships with Xcode 13.2.1, so they CAN be compiled.
However, they won't run on Big Sur 11.0 — they need fallbacks for macOS 11.

#### 5a. `.foregroundStyle` → `.foregroundColor` (macOS 12+)

**546 occurrences across 105 files.** This is the highest-volume change.

Strategy: **Global replace** `.foregroundStyle(` → `.foregroundColor(` since `.foregroundColor` is available from macOS 10.15+ and `.foregroundStyle` is macOS 12+. The one-argument signature is compatible. `.foregroundStyle(.tertiary)` → `.foregroundColor(.secondary)` (tertiary doesn't exist in foregroundColor).

#### 5b. Canvas and TimelineView (macOS 12+)

**~30+ occurrences across ~20 Discover scene files.** These are core to the interactive science animations.

| File | API | Strategy |
|------|-----|----------|
| Discover/Components/ParticleEmitter.swift | Canvas + TimelineView | Gate with #available; static fallback |
| Discover/Scenes/Scene1_PlantKitchen.swift | TimelineView | Gate; static image fallback |
| Discover/Scenes/Scene3_InsideALeaf.swift | TimelineView + Canvas | Gate; static fallback |
| Discover/Chapter2/Scenes/Scene1_TheMouthLab.swift | Canvas (×2) | Gate; static fallback |
| Discover/Chapter2/Scenes/Scene2_TheSwallowWave.swift | Canvas (×2) | Gate; static fallback |
| Discover/Chapter2/Scenes/Scene4_IntestineVillus.swift | Canvas (×3) | Gate; static fallback |
| Discover/Chapter2/Scenes/Scene6_FourStomachsOfACow.swift | Canvas | Gate; static fallback |
| Discover/Chapter2/Scenes/Scene8_TasteAndFlavour.swift | Canvas | Gate; static fallback |
| Discover/Chapter3/Scenes/Scene1_FluffToFibre.swift | TimelineView + Canvas | Gate; static fallback |
| Discover/Chapter3/Scenes/Scene3_TheShearingDay.swift | Canvas (×2) | Gate; static fallback |
| Discover/Chapter3/Scenes/Scene5_SortersDiseaseLab.swift | Canvas | Gate; static fallback |
| Discover/Chapter3/Scenes/Scene6_SilkwormLifeCycle.swift | Canvas | Gate; static fallback |
| Discover/Chapter3/Scenes/Scene7_TheCocoonReel.swift | Canvas | Gate; static fallback |
| Discover/Chapter4/Scenes/Scene3_ThreeHighwaysOfHeat.swift | TimelineView + Canvas | Gate; static fallback |
| Discover/Chapter4/Scenes/Scene5_SeaBreezeLandBreeze.swift | TimelineView + Canvas | Gate; static fallback |
| Discover/Chapter5/Scenes/Scene4_NeutralisationInAction.swift | TimelineView + Canvas | Gate; static fallback |
| Discover/Chapter5/Scenes/Scene8_AcidRainStory.swift | TimelineView + Canvas | Gate; static fallback |
| Discover/Chapter6/Scenes/Scene1_IceToWaterToSteam.swift | TimelineView + Canvas | Gate; static fallback |
| Discover/Chapter6/Scenes/Scene4_TheRustingExperiment.swift | TimelineView + Canvas | Gate; static fallback |
| Discover/Chapter6/Scenes/Scene5_GalvanisationShield.swift | TimelineView + Canvas | Gate; static fallback |
| Discover/Chapter7/Scenes/Scene3_ClimateZonesMap.swift | Canvas | Gate; static fallback |
| Discover/Chapter7/Scenes/Scene4_PolarBearSurvivalKit.swift | Canvas | Gate; static fallback |
| Discover/Chapter7/Scenes/Scene7_MigrationSuperhero.swift | TimelineView + Canvas (×2) | Gate; static fallback |
| Discover/Chapter7/Scenes/Scene8_DesertSurvivalTricks.swift | Canvas | Gate; static fallback |
| Discover/Chapter19/Scenes/Scene3_MoonPhasesWheel.swift | Canvas | Gate; static fallback |

#### 5c. Other macOS 12+ APIs

| File | Line | API | Replacement strategy |
|------|------|-----|----------------------|
| Views/Practice/PracticeScreen.swift | 307 | `.onSubmit` | Replace with button / `.onReceive` pattern |
| Views/Settings/SettingsScreen.swift | 333 | `.onSubmit` | Replace with button / `.onReceive` pattern |
| Views/Practice/PracticeScreen.swift | 175 | `.background(.ultraThinMaterial)` | Replace with `.background(Color.gray.opacity(0.1))` |
| Views/Components/LanguageSelectorBar.swift | 62 | `.background(.ultraThinMaterial)` | Replace with `.background(Color.gray.opacity(0.1))` |
| Subjects/Tutor/SanskritSubjectHomeView.swift | 30 | `.background(.regularMaterial)` | Replace with `.background(Color(NSColor.controlBackgroundColor))` |
| Views/History/HistoryScreen.swift | 50 | `.searchable(text:prompt:)` | Replace with custom TextField in toolbar |
| Views/History/HistoryScreen.swift | 35 | `.swipeActions` | Replace with context menu |
| Views/Practice/PracticeScreen.swift | 306 | `.focused($isAnswerFocused)` | Remove focus modifier; use standard input |
| Views/Components/InputCard.swift | 25 | `.focused(isFocused)` | Remove focus modifier |
| Views/OCR/OCRTranslationScreen.swift | 125 | `.focused($isTextEditorFocused)` | Remove focus modifier |
| 8 DiscoverChapter*View files | various | `.focusable()` (×8) | Remove (only used for .onKeyPress support) |
| ContentView.swift | 90 | `.symbolRenderingMode(.hierarchical)` | Remove (purely cosmetic) |
| Subjects/Articles/ArticleEntryButton.swift | 15 | `.symbolRenderingMode(.hierarchical)` | Remove (purely cosmetic) |
| ~30+ files | various | `.tint(...)` (50+ occurrences) | Replace with `.accentColor(...)` |
| ~40+ files | various | `.buttonStyle(.bordered/.borderedProminent)` (70+ occurrences) | Replace with `.buttonStyle(DefaultButtonStyle())` or remove |

### 6. `.onChange(of:)` Two-Parameter Signature (macOS 14+)

The new `{ oldValue, newValue in }` signature is macOS 14+. Must convert to the macOS 11+ single-parameter signature `{ newValue in }`.

| File | Line | Current | Fix |
|------|------|---------|-----|
| Views/Components/InputCard.swift | 32 | `.onChange(of: text) { _, newValue in` | `.onChange(of: text) { newValue in` |
| Views/Settings/SettingsScreen.swift | 163 | `.onChange(of: newPIN) { _, value in` | `.onChange(of: newPIN) { value in` |
| Views/Settings/SettingsScreen.swift | 334 | `.onChange(of: pinInput) { _, value in` | `.onChange(of: pinInput) { value in` |
| Subjects/Tutor/ConceptDetailView.swift | 93 | `.onChange(of: depth) { _, _ in` | `.onChange(of: depth) { _ in` |
| Discover/Chapter4/Scenes/Scene6_ConductorOrInsulator.swift | 204 | `.onChange(of: geo.size) { _, _ in` | `.onChange(of: geo.size) { _ in` |
| Discover/Scenes/Scene5_AutotrophHeterotroph.swift | 121,137 | `.onChange(of: geo.size) { _, _ in` (×2) | `.onChange(of: geo.size) { _ in` |
| Discover/Chapter4/Scenes/Scene4_HotSoupColdSpoon.swift | 30 | `.onChange(of: isWooden) { _, _ in` | `.onChange(of: isWooden) { _ in` |
| Discover/Chapter7/Scenes/Scene6_AdaptationMatchGame.swift | 191 | `.onChange(of: geo.size) { _, _ in` | `.onChange(of: geo.size) { _ in` |
| Discover/Components/ParticleEmitter.swift | 40 | `.onChange(of: isActive) { _, newValue in` | `.onChange(of: isActive) { newValue in` |
| Discover/Chapter6/Scenes/Scene6_PhysicalOrChemicalSorting.swift | 216 | `.onChange(of: geo.size) { _, _ in` | `.onChange(of: geo.size) { _ in` |
| Discover/Chapter5/Scenes/Scene6_AcidOrBaseSortingLab.swift | 205 | `.onChange(of: geo.size) { _, _ in` | `.onChange(of: geo.size) { _ in` |

### 7. Swift Language Features (Swift 5.7+ — not in Xcode 13's Swift 5.5)

| File | Line | Feature | Fix |
|------|------|---------|-----|
| Subjects/Tutor/AskFollowUpView.swift | 50 | `if let error {` (Swift 5.7 shorthand) | `if let error = error {` |
| Discover/Chapter19/Scenes/Scene6_SolarSystemSorter.swift | 219 | `if let planet {` (Swift 5.7 shorthand) | `if let planet = planet {` |

### 8. Date.now (macOS 12+)

Used as default parameter values in model initializers.

| File | Line | Usage | Fix |
|------|------|-------|-----|
| Models/StudyState.swift | 18 | `addedAt: Date = .now` | `addedAt: Date = Date()` |
| Models/StudyState.swift | 36 | `attemptedAt: Date = .now` | `attemptedAt: Date = Date()` |
| Models/StudyState.swift | 56 | `date: Date = .now` | `date: Date = Date()` |

### 9. FoundationModels (macOS 26+)

| File | Line | API | Status |
|------|------|-----|--------|
| Subjects/AI/FoundationTutor.swift | 4-6 | `#if canImport(FoundationModels)` | **Already properly gated.** No changes needed. Will compile correctly on Xcode 13.2.1 via the `#else` shim path. |

### 10. Dependencies

- **No Package.swift** — no SPM packages.
- **No Podfile** — no CocoaPods.
- **No Cartfile** — no Carthage.
- **No third-party dependencies at all.** This is excellent for backporting.

### 11. Asset Catalog / SF Symbols

| File | Line | Symbol | Status |
|------|------|--------|--------|
| ContentView.swift | 82 | `list.bullet.clipboard.fill` | SF Symbols 3+ (macOS 12). Replace or gate. |
| Various files | various | Standard symbols (heart.fill, clock, etc.) | Available in SF Symbols 1-2. OK. |

A full symbol audit may reveal additional SF Symbols 3+ symbols. Most standard symbols used in this app (heart.fill, chevron.right, books.vertical, etc.) are available in SF Symbols 2 (Big Sur).

### 12. Build Settings

- **objectVersion = 77**: Must be lowered to 55 for Xcode 13.2.1.
- **MACOSX_DEPLOYMENT_TARGET = 14.0**: Must be lowered to 11.0 across all targets/configs.
- **SWIFT_VERSION = 5.0**: Compatible with Xcode 13.2.1. No change needed.
- **No .xcconfig files** found.
- **No Info.plist** found (likely using generated Info.plist from build settings).

---

## Recommended Strategy: C — Mixed Backport

### Why not A or B?

- **Strategy A (full backport)** is infeasible in reasonable time. SwiftData → JSON persistence alone is ~30-40 hours. The 546 `.foregroundStyle` replacements, ~30 Canvas/TimelineView gates, and navigation architecture rewrite add another ~30-40 hours.
- **Strategy B (gated backport with #available)** cannot work because macOS 13+ and 14+ APIs are **not in Xcode 13.2.1's SDK**. You can't `#available`-gate something that doesn't exist in the SDK.

### What Strategy C means

**Full replacement of all macOS 13+/14+ APIs** (they won't compile on Xcode 13) with backward-compatible equivalents. **Gating of macOS 12 APIs** with `#available` checks and fallbacks for Big Sur.

### Features that will be degraded on Big Sur (requiring your approval)

1. **Discover Mode animations** — Canvas/TimelineView scenes will show simplified static layouts instead of animated visuals. The educational content (text, quizzes) still works; only the animations degrade.
2. **Certificate PDF export** — ImageRenderer (macOS 13+) will be replaced with an AppKit-based NSHostingView → PDF approach that works on macOS 11+.
3. **Keyboard arrow-key navigation in Discover** — .onKeyPress is macOS 14+. Replaced with NSEvent local monitor (works on macOS 11+).
4. **Symbol pulse effects** — .symbolEffect is purely cosmetic. Removed on older OS.
5. **Material blur backgrounds** — Replaced with solid semi-transparent colors.
6. **Text field focus management** — .focused modifier removed; standard input behavior.
7. **History search** — .searchable replaced with inline TextField filter.
8. **Swipe actions on history items** — Replaced with right-click context menus.
9. **Button styling** — .bordered/.borderedProminent replaced with default macOS button styles.

**None of these degrade core functionality.** The app will still translate, display content, run quizzes, save history/favorites, and navigate all subjects.

### Work breakdown

| Task | Est. hours | Risk |
|------|-----------|------|
| SwiftData → JSON file persistence | 30-40 | High — most complex change |
| .foregroundStyle → .foregroundColor (546 sites) | 2-3 | Low — mechanical |
| Navigation rewrite (NavigationStack/SplitView → NavigationView) | 8-12 | Medium — architectural |
| Canvas/TimelineView gating + fallbacks | 6-10 | Medium — many files |
| .onChange signature fixes | 1 | Low — mechanical |
| ContentUnavailableView replacement | 1 | Low — simple custom view |
| LabeledContent replacement | 1 | Low — HStack pattern |
| ImageRenderer replacement | 3-4 | Medium — AppKit bridge |
| .onKeyPress → NSEvent monitor | 2 | Low |
| .tint/.buttonStyle/Material/misc | 3-4 | Low — mechanical |
| Swift 5.7 syntax fixes | 0.5 | Trivial |
| objectVersion + deployment target | 0.5 | Low |
| Testing & verification | 4-6 | Medium |
| **Total** | **~62-80** | |

---

## Decision needed before proceeding

Please confirm:

1. **Approve Strategy C** — proceed with full replacement of all 13+/14+ APIs and gated fallbacks for 12+ APIs, with the degraded features listed above?

2. **Or choose Strategy D** — the backport is too large, and alternatives should be considered (e.g., installing macOS Monterey via OCLP on mac2, which would eliminate all macOS 12 API issues and reduce scope by ~60%).

Awaiting your approval to begin Phase 2.
