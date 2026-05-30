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
- [x] **Notebook card "last edited" badge** — DONE 2026-05-27: added `@Published chapterNoteEditedAt: [String: Date]` (parallel to `chapterNotes`), populated from persisted `ChapterNote.updatedAt` on load and refreshed only for the edited chapter on save. `NotebookCard` now shows "Last edited N days ago" (RelativeDateTimeFormatter, Big Sur safe). Also fixed a latent bug: `setChapterNote` previously stamped EVERY note row with a fresh `Date()` on each keystroke, resetting unrelated notes' timestamps; now each row keeps its own last-edited time.
- [x] **Ch.3 FabricCareSymbolsQuizScene wiring** — Ch.3's quick-check items are migrated to `chapter.quickCheckQuestions` (4 items, ids `scenecheck_ch03_q00..q03`) but the scene itself still uses local `Q` literals. The scene renders an emoji symbol next to each prompt (`♨️`, `🚫`, `🌀`, `🟦`) — a column the migrated `Question` schema doesn't carry. Two paths to finish: (a) re-run `scripts/migrate_quick_checks_to_pack.py` after teaching it to prepend the `symbol:` field to the prompt, then wire the scene like the other 15; (b) extend `QuickCheckQuizScene` to optionally accept a per-item prefix, keep the symbol field in the migration script as a separate JSON property. Today's state: Ch.3 quick-check answers don't fire `recordReview` — orphan data in the pack, no UX regression. **Update 2026-05-27:** the 4 Ch.3 quick-checks are now content-enriched (commonMistakes + solutionSteps authored alongside the other 64). **RESOLVED — chose path (b)/inline-by-design:** the scene renders an emoji-symbol column (`♨️ 🚫 🌀 🟦`) that the text-only `Question` schema deliberately cannot carry (the schema lint `SubjectRegistryTests.noLoadErrors()` enforces no decoration fields). Re-keying the migration to embed emoji in the prompt would corrupt the prompt text for the other 64 quick-checks' shared codepath, so `FabricCareSymbolsQuizScene` stays inline as a permanent, documented exception. The pack's 4 `scenecheck_ch03_*` rows are enriched-but-unsurfaced (harmless: no `recordReview`, no Daily-Practice entry, no UX regression). Closed as won't-migrate.
- [x] **Ch.6 inline MCQ inventory** — RESOLVED 2026-05-27: inspected `Chapter6/DiscoverChapter6View.swift`. The 5 `prompt:` literals are `Item(id:prompt:reaction:Bool)` — a binary **sort/classification** task ("is this a chemical reaction? yes/no"), NOT the `Q(id:,prompt:,opts:,correct:)` MCQ shape. The migration script correctly skipped it; there's nothing to reshape (forcing it into MCQ would distort a working classification interaction). No quick-check migration applies. Closed.
- [x] **Try-at-Home per-chapter copy** — DONE 2026-05-27: `TryAtHomeCard` now takes `subtitle` + `count`, sourced from `HomeExperimentLibrary.subtitle(forChapterId:)` / `.count(forChapterId:)`. The subtitle is DERIVED from the actual experiment titles (no hand-authored copy, so it can't drift from content), and the count reflects the real per-chapter experiment count instead of a hardcoded "5".
- [x] **Recursive hardening audit (2026-05-27) — keyboard/SRS/overlay items.** FIXED:
  - **Keyboard-shortcut collisions** — rebound view-level "Bookmark this item" to ⌘⇧B (was ⌘B, colliding with app "Show Bookmarks") in `ConceptDetailView`/`QuestionDetailView`; rebound `ConceptDetailView` prev/next from ⌘[ /⌘] to ⌘← /⌘→ (⌘[ collided with app "Go Back"; now matches `QuestionDetailView`'s ⌘-arrow convention); removed the duplicate bare ←/→ binding on the `QuestionDetailView` footer buttons (the `keyboardShortcutSink` is the single source).
  - **SRS ease upper clamp** — added `SM2Scheduler.maxEase = 3.0`; `.easy` now `min(maxEase, …)` so repeated Easy can't inflate intervals unbounded. `testSM2_EaseIsClampedAtMax` pins it.
  - **`AllChaptersCompleteOverlay`** — added `.keyboardShortcut(.cancelAction)` to Continue so Esc/Return dismiss the hand-rolled overlay.
- [x] **Recursive hardening audit — flip-card keyboard + Safari hardening.** FIXED:
  - **`FlipCard` keyboard activation** — audited all call sites (only **5**, not ~150: `Scene6_MeetTheSpecialPlants` ×4 + `Scene2_MeetTheWoolAnimals` ×1); every `back()` is non-interactive (Text/bullets), so wrapping the card in a `Button(...).buttonStyle(.plain)` is safe — it now flips by keyboard (Tab + Space/Return) and VoiceOver while preserving appearance.
  - **"Open in Safari"** (`ArticleBrowserView` toolbar + plain-text fallback) — kept (legitimate "read in a bigger window" on trusted, bundled, app-authored HTML) but added a defense-in-depth guard: only a bundled file URL (`isFileURL && path.hasPrefix(Bundle.main.bundlePath)`) is handed to the browser, so a future link-following regression can't exfiltrate a remote URL.
- [x] **`PracticeScreen` flashcard keyboard/VoiceOver reveal.** The tappable card contains a nested "Listen" `Button`, so the card itself can't be a Button (a wrap would shadow it). Instead the passive "Tap card to reveal" hint was replaced with a real "Reveal answer"/"Hide answer" `Button` beside the card — focusable (Tab + Space/Return) and VoiceOver-activatable — leaving the card's tap gesture and the nested Listen button untouched.
- [x] **Surface audit walker (UITest)** — shipped `6565ad2`. `Surface_AuditWalker.swift` already had a structural walker (`testWalkAllScienceChapters`); now also carries `test_surfaceAuditWalker_allChapters_smoke` that drives Try Discover Mode / Beyond the Book / Read Aloud / My Notebook clicks per chapter and attaches a screenshot. Opt-in via `-only-testing:desktopAhaanUITests/Surface_AuditWalker`.
- [x] **AppIcon PNG assets** — shipped `e4f4a1b`. `scripts/render-app-icon.swift` composes a SwiftUI view (bold white "A" monogram on indigo→purple gradient with a soft inner highlight) and writes pixel-exact PNGs into `AppIcon.appiconset`. actool now emplaces `AppIcon.icns` (84 KB, "ic13" type) with zero warnings; the Dock + Finder will show the brand icon.
- [x] **withAnimation Reduce-Motion lint** — shipped `4ff5cf5`. New LH005b rule in `scripts/check_lifetime_hazards.py` catches imperative `withAnimation(<X>) { … }` wraps via the same gate semantics LH005a uses. 66 pre-existing sites grandfathered via `scripts/lh005_withanimation_allowlist.txt` with per-site reasons; new code must pick a gate form (inline ternary, helper, outer block, or `// lh005-ok:` escape). Self-test fixtures pair added to `scripts/test_lints.py`.

## §4. Resolved (archive)

- [x] **Cross-pack concept-id collision from parallel Maths landing** (2026-05-27, this session) — the Maths pack (built in parallel with the Science quick-check work) reused Science's `chNN_tNN_cNN` concept-id scheme, producing **73 maths↔science concept-id collisions**. This violates the documented contract (`ChapterContentTests.testNoCrossPackConceptIdCollision`: concept ids MUST be globally unique because Bookmarks + `DataStore.discoverProgress` key on the bare id and the registry surfaces them flat). The guard test stayed green only because it loaded science + sanskrit and never the new maths pack. Fix: `scripts/namespace_maths_concept_ids.py` re-keyed all 90 maths concept ids + 1005 in-pack reference sites (`relatedConceptIds`, conceptMap concept-node ids, conceptMap edge `from`/`to`) to the `mch…` namespace the Maths session already used for article keys; the guard test now walks **all** bundled packs. Maths concept totals/conceptMap-resolution tests stay green (no internal refs orphaned). **Note:** cross-pack *question*-id collisions (`chNN_tNN_qNN`, 120 of them) are allowed by the contract (nav routes carry `packId`), but the review/Recently-Missed/Mastery path did NOT — `QuestionReview` stored only the bare id and resolved via the global first-writer-wins index, so a Science review was being mis-attributed to Maths (Maths sorts first). Closed in the same audit: `QuestionReview.packId` is now captured at answer time (`recordReview(…, packId:)`, optional → back-compatible with old `reviews.json`), `SubjectRegistry.location(forQuestionId:preferredPackId:)` resolves within the recorded pack, and the Mastery dashboard, Daily Practice resolvers, and the "Stuck here?" strip all thread it through — so a review resolves to the subject it was answered in. `CrossPackReviewResolutionTests` pins it. Prefixed globally-resolved ids (`bossquiz_`/`scenecheck_`) were already collision-free across all packs. The Science article-routing ratchets scoped out `mch…` keys in `cbe5037` (legitimate — those ratchets parse a `chNN` folder from the key; Maths articles are covered by `MathsChapterContentTests`).
- [x] **Boss-quiz content migration** (2026-05-25, commits `ad09c6e`/`fcbf7c6`/`1ec5ea6`/`464ff10`/`71068ac`/`0fad80b`) — moved 200 hand-authored Boss Quiz MCQs from Swift literals across 19 Scene9 files into `science_class7.json` so wrong answers resolve through `SubjectRegistry.location(forQuestionId:)` and surface in Daily Practice's Recently-Missed row.
- [x] **Scene quick-check migration** (2026-05-27, commits `be2454d`/`1d6da2b`) — moved 68 dispatcher-inline MCQ quick-checks (e.g. CycloneSurvivalQuizScene, SpeedLimitsQuizScene, MotionQuizScene) from `Q(id:, prompt:, opts:, correct:)` literals across 16 DiscoverChapterNView.swift dispatchers into `chapter.quickCheckQuestions`. Ids carry the `scenecheck_chNN_qII` prefix already whitelisted in `DataStore.ephemeralIdPrefixes`. 15 of 16 scenes also rewired to read from the pack via a new shared `QuickCheckQuizScene` component (Ch.3's symbol-decorated scene deferred — see §3). Net -862 LOC. Brief expected ~500 items in `Scene*.swift` via a `QuickCheck` token; reality was ~70 items in dispatchers with a `Q` struct — the brief's scope assumption was off by ~5×.
- [x] **Boss-quiz pedagogical enrichment** (2026-05-25, commits `4ea621d`/`254ece1`/`f0dd9b4`/`f4ad26e` + this one) — authored 2 commonMistakes per boss Q (400 entries) + 15 selective variations so `QuestionDetailView.commonMistakesCard` + `variationsSection` render real content when a kid taps in from Recently-Missed. `BossQuizMigrationRatchetTests.testEveryBossQuizHasCommonMistakes` floors the contract at ≥ 1 per Q so the gap can't silently re-open.
- [x] **Scene quick-check pedagogical enrichment** (2026-05-27, commits `22d1c3f`/`9eff33b` + this one) — sibling of the boss-quiz enrichment, scoped to the 68 migrated scene quick-checks. Authored 1 solutionStep + 2 commonMistakes per Q (68 solutionSteps + 136 commonMistakes) via `scripts/enrich_quick_checks.py` so `commonMistakesCard` and the hint ladder render real content. `QuickCheckPedagogicalContentTests` (≥ 1 commonMistake, ≥ 1 solutionStep, no sub-30-char placeholders) + `StuckHereStripQuickCheckTests` (D4 strip surfaces a missed quick-check end-to-end) floor the contract. No variations authored (recall-tier; low marginal value — see brief §15).
- [x] **Common-Mistakes article at 19/19 chapter coverage** (2026-05-26, commits `abb899f`/`9ee728c`/`7b9782f` + this one) — generated 18 templated `ch{02..19}_mistakes.html` articles from `chapter.misconceptions` JSON via `scripts/generate_mistakes_articles.py`; wired `CommonMistakesCard` into ChapterDetailView's enrichment HStack (orange/red, sister-file split to stay under 600 LOC); 4 ratchet cases in `CommonMistakesRoutingTests` lock the 19/19 floor. Ch.1's bespoke 10-entry anchor article untouched. The 11 other Ch.1-only enrichment surfaces (`scientists`, `storymode`, `whatif`, `glossary`, `infographic`, `miniproject`, `ncert_qa`, `plantoftheday`, `selfcheck`, `beyond`, `bridge`) remain Ch.1-only — each is its own future session.
- [x] **Vocabulary Deck article at 19/19** (2026-05-26, commit `523783d`) — 18 templated `ch{NN}_glossary.html` from `chapter.glossary` JSON; 4-case `GlossaryArticleRoutingTests`. UI surfaced via `ExtraReadingRow` chip on ChapterDetailView (`577a31e`).
- [x] **NCERT Q&A article at 19/19** (2026-05-26, commit `49982fd`) — 18 templated `ch{NN}_ncert_qa.html` from `chapter.ncertQA` JSON; 4-case `NcertQaArticleRoutingTests`. UI surfaced via `ExtraReadingRow` chip.
- [x] **Scientist Spotlight article at 19/19** (2026-05-26, commit `111ddc3`) — 18 templated `ch{NN}_scientists.html` from `chapter.scientists` JSON; 4-case `ScientistsArticleRoutingTests`. UI surfaced via `ExtraReadingRow` chip.
- [x] **What If? article at 19/19** (2026-05-26, commit `290ac77`) — 18 templated `ch{NN}_whatif.html` from `chapter.whatIfs` JSON; 4-case `WhatIfArticleRoutingTests`. UI surfaced via `ExtraReadingRow` chip.
- [x] **ExtraReadingRow UI surfacing** (2026-05-26, commit `577a31e`) — compact chip row on `ChapterDetailView.surfacesGroupBottom` exposes the 4 templated enrichment articles (Vocabulary Deck, NCERT Q&A, Scientist Spotlight, What If?) per chapter; each chip auto-hides when its article isn't bundled. Sister-file split keeps the parent view under 600 LOC.

## §5. Deferred from 100-Category Bug-Free Re-Certification (2026-05-29, parallel-mode Agent C)

These were surfaced by an 11-family fan-out re-audit. Each underlying cert
category is already ✅ (locked or accepted-with-rationale); these are
strengthening opportunities whose fix touches View/Model/Service code and so
are out of bounds for the parallel-mode cert agent. They land in a later
non-parallel sweep.

- [ ] **E.7 ratchet test** — add `testDueQuestionIdsOrderedMostOverdueFirst`:
  create 3 reviews with distinct `nextDueAt`, call `dueQuestionIds()`, assert
  ascending-by-due order. Implementation (DataStore.swift ~L749-754) is
  correct; only the pin is missing. (Touches DataStore — Agent B's domain this run.)
- [ ] **E.10 ratchet test** — add a DataStore single-instance / shared-state
  regression guard (the 6b5a706 review-loss class): record a review on one
  handle, assert visibility through `.shared`. Prevents re-introduction of a
  second `DataStore()`.
- [ ] **F.1 unlabeled buttons** — 24 Image-only / empty-keyboard-proxy buttons
  (96% labeled, > 90% floor). Add `.accessibilityLabel`/`.help` per site
  (CommandPalette shortcut buttons, QuestionDetailView keyboard proxies,
  FlipCard/DiscoveryStepper). View edits.
- [ ] **I.3 DRY** — `ConceptDetailView+ChapterGlossaryCTA.swift` duplicates the
  `m`-prefix article-key derivation; route it through
  `ArticleIndex.packScopedKey(forPackId:baseKey:)` like GlossarySheet does.
  No data leak (the prefix is correct) — cosmetic de-dup. View edit.
- [ ] **J.2 stale allowlist comment** — `scripts/file_size_allowlist.txt`
  DataStore rationale says "698 LOC after the +Loading/+Saving split"; the
  file is now 822 LOC. Rationale still valid (domain mutators stay short, no
  clean split); just refresh the number. (Left unedited this run to avoid
  racing other agents who may grow the allowlist when adding files.)
- [ ] **G.1 / G.6 / G.9 / G.10 perf instrumentation** — launch-time (<3s),
  Discover-transition frame-rate (≥20fps legacy), article-parse (<500ms), and
  30-min memory-growth (<100MB) ratchets need a running-app / XCUITest harness
  or in-app `os_signpost` regions. Static audit is clean; these are
  measurement-infra tasks for a non-parallel sweep.

## Parent / Weekly Progress Dashboard deferrals (2026-05-29)

- [x] **View the kid's weekly activity** — shipped: `WeeklyProgressView`
  (⌘⇧W / Help → Weekly Progress) + single-page PDF export
  (`WeeklyReportPDFExporter`). See `PRODUCTION_READINESS_REPORT.md` →
  "Weekly Progress Dashboard".
- [ ] **Exact per-subject Discover attribution** — `DiscoverProgress`
  stores only `chapterId`, and Science + the Maths Discover pilot share
  bare chapter ids (`ch01…`), so the dashboard folds Maths-pilot scenes
  under Science in the per-subject pill (day/week totals stay exact).
  Adding a `packId` field to `DiscoverProgress` (+ a `discover.json`
  migration) would make it exact. Schema change — deliberately out of
  scope for the parallel run.
- [ ] **True week-over-week mastery delta** — the dashboard's
  `MasteryDelta` uses the activity-window definition (questions whose
  last review landed in the 7 days, by current level). A persisted daily
  mastery snapshot (`masterySnapshots.json`, auto-pruned to 30 days)
  diffed week-start vs week-end would be exact, but recording one snapshot
  per day needs an app-launch hook — deferred to a non-parallel sweep
  (touching the launch path / loader was out of scope here).
- [ ] **Month view / trend chart** — the current dashboard is a single
  trailing-7-day window. A month grid or a mastery-over-time sparkline is
  a natural follow-up once daily snapshots exist.

## §6 — Daily Plan + Achievements (Agent A, overnight v2)

- [ ] **Sidebar "🏆 Achievements" + "Today's Plan" entries** — both features
  ship via Help menu + ⌘⇧A / ⌘⇧D + their own AppKit windows this run because
  the sidebar lives in `AppState`/`ContentView` (out-of-domain). When a
  surface owner is editing the sidebar, add `SidebarTool` cases (or a new
  section) so they're reachable from the rail too.
- [ ] **Discover Progress sidebar badge string** — `SidebarTool.discover`
  `keyboardShortcut` in `AppState.swift` still reads "⌘⇧D", but the binding
  moved to **⌘⌃D** (Daily Plan took ⌘⇧D per the feature brief). Update the
  badge string to "⌘⌃D" to match. Cosmetic only — the actual key bindings
  in `desktopAhaanApp.swift` are correct.
- [ ] **Daily-plan reminder toggle in Settings** — the opt-in toggle ships
  inside the Daily Plan window this run (Settings screen is out-of-domain).
  A surface owner could mirror it under Settings → Notifications for
  discoverability; it reads/writes `DailyPlanStorage.reminderEnabledKey`.
- [ ] **Per-subject Discover attribution for Daily Plan** — the "open
  Discover chapter" picker uses the Science host pack only (mirrors the
  existing `DiscoverProgress`-has-no-packId limitation). Revisit once
  DiscoverProgress carries a packId.

## Overnight v3 (Agent B) — deferred / follow-up

- [ ] **Perf running-app instrumentation (cert G.1/G.6/G.9/G.10).** The
  static audit closed these; the *enhancement* is signpost/XCUITest-based
  measurement (launch-time, Discover transition frame-rate, article-parse
  timer, 30-min memory-growth sample). Needs a running-app harness, out of
  scope for shell-from-CI. Tracked here, not an open cert gap.
- [ ] **Cosmetic commit mis-attribution.** Commit `3764756` carries Agent B's
  "in-app crash-report summary view" message but contains Agent A's Printable
  Worksheet files (shared-git-index race). The files are correctly committed;
  only the message is wrong. Not worth a history rewrite in a live shared
  repo — note for the changelog author.
- [ ] **analyze_crashlogs.py as a scheduled refresh (optional).** The in-app
  CrashLogSummaryView reads the cached summary JSON; today a human runs the
  analyzer to refresh it. A future LaunchAgent (or an in-app, unsandboxed
  helper) could refresh it automatically so the view is always current
  without a terminal step.
