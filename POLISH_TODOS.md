# Polish TODOs — desktopAhaan

Living list of polish + UI gaps surfaced by `SURFACE_AUDIT.md`. Items move from here into per-session work; each line carries enough context that a future session can pick it up cold.

## §1. Shipped surfaces — small polish gaps (Phase 3 candidates this session)

- [x] **P1 · Hover-scale Reduce Motion gate** — shipped in `dbc565a`. The four ChapterDetail cards (Discover banner / Beyond / Try at Home / Notebook) clamp `isHovered` to false when `NSWorkspace.shared.accessibilityDisplayShouldReduceMotion` is true.
- [x] **P2 · Topic card chevron a11y hint** — shipped in `dbc565a`. Parent Button now carries `.accessibilityLabel(topic.title)` + `.accessibilityHint("Opens topic — N concepts, M questions.")`.
- [x] **P3 · Topic Detail section headers** — shipped in `dbc565a`. Both "Concepts" / "Questions" labels now carry `.accessibilityAddTraits(.isHeader)`.
- [x] **P4 · Question Detail match-pairs a11y hint** — shipped `c5ca9f9`. Per-row `.accessibilityLabel("Match for \(pair.left)")` + contextual hint that flips between "Pick the right-side option that matches X" and "Currently matched to Y. Open to change or clear."
- [x] **P5 · Discover scene-progress dots** — already shipped (`DiscoverMode.swift:363-365`). Dot container carries `.accessibilityElement(children: .contain)` + `.accessibilityLabel("Scene progress")` + `.accessibilityValue("Scene N of M")`. The audit suggested `.ignore` but `.contain` keeps per-dot navigation alongside the aggregate value.
- [x] **P6 · KeyboardShortcutsSheet chip a11y** — shipped in `dbc565a`. Each chip row now combines via `.accessibilityElement(children: .ignore)` + label = description + value = "Keyboard shortcut: <combo>" so VoiceOver reads naturally instead of spelling out the modifier glyphs.
- [x] **P7 · Article Read-Aloud chapter context** — shipped `af367bf`. `ArticleEntryButton` now forwards `entry.title` through `articleTitle` so the read-aloud button's a11y label says "Read <Title> aloud" on both call paths (ChapterDetailView already passed it).
- [x] **P8 · Article paragraph index a11y value** — already shipped (`ArticleBrowserView.swift:145-151`). Article host carries `.accessibilityElement(children: .contain)` + a per-state `.accessibilityValue("Reading paragraph N of M")` when narration is active.

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

- [x] **First-launch window-frame guard** — shipped `eaf15ee`. `clampWindowIdeal(design:visible:comfortableFraction:)` returns the design size unchanged when both axes fit inside `NSScreen.main.visibleFrame`, otherwise scales both to 85% of visible. Wired through a new `firstLaunchFrame` static on the App struct. 6 unit tests in `WindowClampTests`.
- [ ] **Notebook card "last edited" badge** — `ChapterDetailView+Notebook.swift` `NotebookCard` shows just `hasNotes: Bool`. Could surface "Last edited N days ago" for a small recency cue.
- [ ] **Try-at-Home per-chapter copy** — `TryAtHomeCard` hard-codes "Hands-on experiments you can do this weekend." Could use per-chapter copy from `HomeExperimentLibrary`.
- [x] **Surface audit walker (UITest)** — shipped `6565ad2`. `Surface_AuditWalker.swift` already had a structural walker (`testWalkAllScienceChapters`); now also carries `test_surfaceAuditWalker_allChapters_smoke` that drives Try Discover Mode / Beyond the Book / Read Aloud / My Notebook clicks per chapter and attaches a screenshot. Opt-in via `-only-testing:desktopAhaanUITests/Surface_AuditWalker`.
- [x] **AppIcon PNG assets** — shipped `e4f4a1b`. `scripts/render-app-icon.swift` composes a SwiftUI view (bold white "A" monogram on indigo→purple gradient with a soft inner highlight) and writes pixel-exact PNGs into `AppIcon.appiconset`. actool now emplaces `AppIcon.icns` (84 KB, "ic13" type) with zero warnings; the Dock + Finder will show the brand icon.
- [x] **withAnimation Reduce-Motion lint** — shipped `4ff5cf5`. New LH005b rule in `scripts/check_lifetime_hazards.py` catches imperative `withAnimation(<X>) { … }` wraps via the same gate semantics LH005a uses. 66 pre-existing sites grandfathered via `scripts/lh005_withanimation_allowlist.txt` with per-site reasons; new code must pick a gate form (inline ternary, helper, outer block, or `// lh005-ok:` escape). Self-test fixtures pair added to `scripts/test_lints.py`.

## §4. Resolved (archive)

- [x] **Boss-quiz content migration** (2026-05-25, commits `ad09c6e`/`fcbf7c6`/`1ec5ea6`/`464ff10`/`71068ac`/`0fad80b`) — moved 200 hand-authored Boss Quiz MCQs from Swift literals across 19 Scene9 files into `science_class7.json` so wrong answers resolve through `SubjectRegistry.location(forQuestionId:)` and surface in Daily Practice's Recently-Missed row.
- [x] **Boss-quiz pedagogical enrichment** (2026-05-25, commits `4ea621d`/`254ece1`/`f0dd9b4`/`f4ad26e` + this one) — authored 2 commonMistakes per boss Q (400 entries) + 15 selective variations so `QuestionDetailView.commonMistakesCard` + `variationsSection` render real content when a kid taps in from Recently-Missed. `BossQuizMigrationRatchetTests.testEveryBossQuizHasCommonMistakes` floors the contract at ≥ 1 per Q so the gap can't silently re-open.
- [x] **Common-Mistakes article at 19/19 chapter coverage** (2026-05-26, commits `abb899f`/`9ee728c`/`7b9782f` + this one) — generated 18 templated `ch{02..19}_mistakes.html` articles from `chapter.misconceptions` JSON via `scripts/generate_mistakes_articles.py`; wired `CommonMistakesCard` into ChapterDetailView's enrichment HStack (orange/red, sister-file split to stay under 600 LOC); 4 ratchet cases in `CommonMistakesRoutingTests` lock the 19/19 floor. Ch.1's bespoke 10-entry anchor article untouched. The 11 other Ch.1-only enrichment surfaces (`scientists`, `storymode`, `whatif`, `glossary`, `infographic`, `miniproject`, `ncert_qa`, `plantoftheday`, `selfcheck`, `beyond`, `bridge`) remain Ch.1-only — each is its own future session.
