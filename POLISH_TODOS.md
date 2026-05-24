# Polish TODOs — desktopAhaan

Living list of polish + UI gaps surfaced by `SURFACE_AUDIT.md`. Items move from here into per-session work; each line carries enough context that a future session can pick it up cold.

## §1. Shipped surfaces — small polish gaps (Phase 3 candidates this session)

- [x] **P1 · Hover-scale Reduce Motion gate** — shipped in `dbc565a`. The four ChapterDetail cards (Discover banner / Beyond / Try at Home / Notebook) clamp `isHovered` to false when `NSWorkspace.shared.accessibilityDisplayShouldReduceMotion` is true.
- [x] **P2 · Topic card chevron a11y hint** — shipped in `dbc565a`. Parent Button now carries `.accessibilityLabel(topic.title)` + `.accessibilityHint("Opens topic — N concepts, M questions.")`.
- [x] **P3 · Topic Detail section headers** — shipped in `dbc565a`. Both "Concepts" / "Questions" labels now carry `.accessibilityAddTraits(.isHeader)`.
- [ ] **P4 · Question Detail match-pairs a11y hint** — `QuestionDetailView.swift` match-pairs sub-view has interactive cards with no `.accessibilityHint`. Add one: "Drag the left card onto its matching right card."
- [ ] **P5 · Discover scene-progress dots** — `DiscoverMode.swift` scene dot container should expose `.accessibilityValue("Scene N of M")` so VoiceOver users hear their position.
- [x] **P6 · KeyboardShortcutsSheet chip a11y** — shipped in `dbc565a`. Each chip row now combines via `.accessibilityElement(children: .ignore)` + label = description + value = "Keyboard shortcut: <combo>" so VoiceOver reads naturally instead of spelling out the modifier glyphs.
- [ ] **P7 · Article Read-Aloud chapter context** — `ArticleBrowserView.swift` `readAloudButton` `.accessibilityLabel` could include the chapter title for richer context ("Read Ch.5 article aloud").
- [ ] **P8 · Article paragraph index a11y value** — `NativeArticleRepresentable` host could carry `.accessibilityValue("Reading paragraph N of M")` so screen-reader users hear narration progress without leaving the article surface.

## §2. UI gaps — schema-only content types (large, multi-session)

The 15 Optional `Chapter` content fields populate from JSON (332 of 342 parity cells ✅) but no view renders them. Each entry below is a discrete UI ship.

- [x] **DeepDive · 'Go deeper' disclosure** — shipped 5fcc96e. DeepDiveSection.swift + DeepDiveDetailSheet.swift on ChapterDetailView.
- [x] **MediaAssetView · chapter visual library** — shipped 069a559. `MediaAssetView.swift` (5 backends: illustration / shapeDiagram / animatedSceneRef / bundledVideo / narratedWalkthrough) + `MediaAssetGallerySectionView.swift` on ChapterDetailView. ShapeDiagramRegistry is an empty stub — registering 76 chapter-specific diagrams is its own session; placeholder card renders cleanly for unregistered keys.
- [x] **Misconceptions · 'Common mistakes' panel** — shipped 069a559. `MisconceptionsSectionView.swift` on ChapterDetailView. Visually distinguishes "kids often think" from "actually".
- [x] **NCERT Q&A · canonical textbook questions** — shipped 069a559. `NcertQASectionView.swift` on ChapterDetailView. Per-question tap-to-reveal model answer with textbook page reference chip.
- [x] **Glossary · per-chapter terms** — shipped 069a559. `GlossarySheet.swift` accessed via `glossaryButton` chip on ChapterDetailView. Alphabetical scroll, tap term to expand example + Hindi.
- [x] **Mnemonics · memorization aids** — shipped 069a559. `MnemonicsStripView.swift` chip strip on TopicDetailView. Tap-to-popover unpacking + context.
- [x] **WhatIfs · counterfactual scenarios** — shipped 069a559. `WhatIfsSectionView.swift` collapsible on ChapterDetailView. Reveal-on-tap guided answers.
- [x] **Real-world examples** — shipped 069a559. `RealWorldExamplesStripView.swift` chip strip on TopicDetailView. Tap-to-popover 60–100-word bodies.
- [x] **Exam connections** — shipped 069a559. `ExamConnectionCalloutView.swift` inline beneath the post-attempt block in QuestionDetailView.
- [x] **Cross-chapter refs** — shipped 069a559. `CrossChapterRefsFooter.swift` at the bottom of ChapterDetailView. Tap a row → nav.push the referenced chapter.
- [x] **Curriculum bridge** — shipped 069a559. `CurriculumBridgeChip.swift` near the DeepDive disclosure. Tap → sheet with Class 8 + NEET / JEE previews.
- [x] **Gallery** — shipped. `GallerySectionView.swift` collapsible on ChapterDetailView. Asset hint routes "sfsymbol:" / "asset:" / "shape:" prefixes; falls back to a placeholder glyph for unrecognized or empty hints.
- [x] **Timelines** — shipped 069a559. `TimelinesSectionView.swift` on ChapterDetailView. Horizontal scroll of numbered step cards.
- [x] **Mini-projects** — shipped 069a559. `MiniProjectsSectionView.swift` collapsible on ChapterDetailView. Card per project + detail sheet with materials, steps, observation, why-it-works.
- [x] **Scientist profiles** — shipped. `ScientistsSectionView.swift` on ChapterDetailView. Compact card per scientist (initials avatar + name + one-line legacy); tap → sheet with the full 120–200 word narrative.

## §3. Misc / latent

- [ ] **First-launch window-frame guard** — `desktopAhaanApp.swift` `WindowGroup.frame` idealWidth 2200 / idealHeight 1380 is tuned for the 5K iMac and on a 13" MBP opens at ~95% of screen height. Big Sur clips correctly so it's not a bug — polish would clamp to ~85% of available height when bounds are smaller.
- [ ] **Notebook card "last edited" badge** — `ChapterDetailView+Notebook.swift` `NotebookCard` shows just `hasNotes: Bool`. Could surface "Last edited N days ago" for a small recency cue.
- [ ] **Try-at-Home per-chapter copy** — `TryAtHomeCard` hard-codes "Hands-on experiments you can do this weekend." Could use per-chapter copy from `HomeExperimentLibrary`.
- [ ] **Surface audit walker (UITest)** — Build `desktopAhaanUITests/Surface_AuditWalker.swift` so the iMac (with AX granted) can mechanise the static audit into a runtime walk + screenshot pass.
- [ ] **AppIcon PNG assets missing** — `desktopAhaan/Assets.xcassets/AppIcon.appiconset/Contents.json` declares ten icon slots (16/32/128/256/512 @1x and @2x) but zero PNG files are present. App ships with a generic Finder icon in the Dock. Generate source artwork + the ten PNGs in a future polish pass. Not a launch blocker.
- [ ] **withAnimation Reduce-Motion lint** — `scripts/check_lifetime_hazards.py` rule LH005 catches `.animation(<X>)` modifiers but not `withAnimation(<X>) { … }` imperative wraps. The 2026-05-24 audit closed 15 sites by hand; a lint extension would prevent recurrence project-wide (currently 220+ unguarded sites remain in low-visibility spots).

## §4. Resolved (archive)

(none yet)
