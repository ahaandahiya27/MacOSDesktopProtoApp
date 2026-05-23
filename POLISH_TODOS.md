# Polish TODOs — desktopAhaan

Living list of polish + UI gaps surfaced by `SURFACE_AUDIT.md`. Items move from here into per-session work; each line carries enough context that a future session can pick it up cold.

## §1. Shipped surfaces — small polish gaps (Phase 3 candidates this session)

- [ ] **P1 · Hover-scale Reduce Motion gate** — `ChapterDetailView.swift` `DiscoverEntryBanner`, `BeyondTheBookCard`, `TryAtHomeCard` all apply `scaleEffect(isHovered ? 1.01 : 1.0)` without a Reduce Motion gate. Fix: wrap the hovered-state mutation in `respectReduceMotion(animation:)` or read `NSWorkspace.shared.accessibilityDisplayShouldReduceMotion` and clamp `isHovered` to false. Same pattern in `TopicCard`.
- [ ] **P2 · Topic card chevron a11y hint** — `ChapterDetailView.swift` `TopicCard` body has a trailing `Image(systemName: "chevron.right")` but the parent Button has no `.accessibilityHint`. VoiceOver currently reads only the topic title; users don't hear "Opens topic — X concepts, Y questions." Fix: add hint to the parent Button.
- [ ] **P3 · Topic Detail section headers** — `TopicDetailView.swift` "Concepts" / "Questions" section labels are styled headers but lack `.accessibilityAddTraits(.isHeader)`, so VoiceOver users can't skip between sections with the rotor.
- [ ] **P4 · Question Detail match-pairs a11y hint** — `QuestionDetailView.swift` match-pairs sub-view has interactive cards with no `.accessibilityHint`. Add one: "Drag the left card onto its matching right card."
- [ ] **P5 · Discover scene-progress dots** — `DiscoverMode.swift` scene dot container should expose `.accessibilityValue("Scene N of M")` so VoiceOver users hear their position.
- [ ] **P6 · KeyboardShortcutsSheet chip a11y** — `KeyboardShortcutsSheet.swift` shortcut chips (`⌘K` etc.) read as "command K" to VoiceOver; the description text is what's meaningful. Wrap chips in `.accessibilityHidden(true)`.
- [ ] **P7 · Article Read-Aloud chapter context** — `ArticleBrowserView.swift` `readAloudButton` `.accessibilityLabel` could include the chapter title for richer context ("Read Ch.5 article aloud").
- [ ] **P8 · Article paragraph index a11y value** — `NativeArticleRepresentable` host could carry `.accessibilityValue("Reading paragraph N of M")` so screen-reader users hear narration progress without leaving the article surface.

## §2. UI gaps — schema-only content types (large, multi-session)

The 15 Optional `Chapter` content fields populate from JSON (332 of 342 parity cells ✅) but no view renders them. Each entry below is a discrete UI ship.

- [x] **DeepDive · 'Go deeper' disclosure** — `chapter.deepDive: [StretchTopic]?`. **SHIPPED in this session** as `DeepDiveSection.swift` + `DeepDiveDetailSheet.swift`, wired into `ChapterDetailView`.
- [ ] **MediaAssetView · chapter visual library** — `chapter.mediaAssets: [MediaAsset]?`. Five backends: illustration (asset-catalog image), shapeDiagram (registered SwiftUI Shape), animatedSceneRef (jump to existing Discover scene), bundledVideo (AVPlayerView), narratedWalkthrough (TTS over text). Estimate 1 full session.
- [ ] **Misconceptions · 'Common mistakes' panel** — `chapter.misconceptions: [Misconception]?`. Surface as a collapsible card on ChapterDetailView below DeepDive. High pedagogical ROI.
- [ ] **NCERT Q&A · canonical textbook questions** — `chapter.ncertQA: [NcertQAEntry]?`. Surface as a sheet from ChapterDetailView OR as a section inside QuizBankView. Highest user-value of the deferred lot (matches exact textbook prompts).
- [ ] **Glossary · per-chapter terms** — `chapter.glossary: [GlossaryTerm]?`. Could appear as a Help-menu-accessible sheet OR as inline tap-to-define on terms inside concept body text.
- [ ] **Mnemonics · memorization aids** — `chapter.mnemonics: [Mnemonic]?`. Note: `MnemonicCallout.swift` exists for use INSIDE Discover scenes but does not pull from `chapter.mnemonics`. Surface as chips under each Topic Detail.
- [ ] **WhatIfs · counterfactual scenarios** — `chapter.whatIfs: [WhatIfScenario]?`. Surface as a sheet or collapsible.
- [ ] **Real-world examples** — `chapter.realWorldExamples: [RealWorldExample]?`. Surface as a chip strip under each Topic.
- [ ] **Exam connections** — `chapter.examConnections: [ExamConnection]?`. Surface inside QuestionDetailView next to each question.
- [ ] **Cross-chapter refs** — `chapter.crossChapterRefs: [CrossChapterRef]?`. Surface as a "Connected ideas" footer on ChapterDetailView.
- [ ] **Curriculum bridge** — `chapter.curriculumBridge: CurriculumBridge?`. Surface as a chip near the DeepDive disclosure ("In Class 8 this becomes…").
- [ ] **Gallery** — `chapter.gallery: [GalleryItem]?`. Possibly merge with MediaAssetView when that lands.
- [ ] **Timelines** — `chapter.timelines: [ContentTimeline]?`. Surface as a horizontal scroll inside ChapterDetailView for chapters that have one.
- [ ] **Mini-projects** — `chapter.miniProjects: [MiniProject]?`. Surface inside the existing "Try at Home" sheet OR as a separate "Build something" card.
- [ ] **Scientist profiles** — `chapter.scientists: [ScientistProfile]?`. Surface as a small avatar carousel.

## §3. Misc / latent

- [ ] **First-launch window-frame guard** — `desktopAhaanApp.swift` `WindowGroup.frame` idealWidth 2200 / idealHeight 1380 is tuned for the 5K iMac and on a 13" MBP opens at ~95% of screen height. Big Sur clips correctly so it's not a bug — polish would clamp to ~85% of available height when bounds are smaller.
- [ ] **Notebook card "last edited" badge** — `ChapterDetailView+Notebook.swift` `NotebookCard` shows just `hasNotes: Bool`. Could surface "Last edited N days ago" for a small recency cue.
- [ ] **Try-at-Home per-chapter copy** — `TryAtHomeCard` hard-codes "Hands-on experiments you can do this weekend." Could use per-chapter copy from `HomeExperimentLibrary`.
- [ ] **Surface audit walker (UITest)** — Build `desktopAhaanUITests/Surface_AuditWalker.swift` so the iMac (with AX granted) can mechanise the static audit into a runtime walk + screenshot pass.

## §4. Resolved (archive)

(none yet)
