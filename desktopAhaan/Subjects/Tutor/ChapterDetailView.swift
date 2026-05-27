import SwiftUI
import AppKit

struct ChapterDetailView: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var nav: TutorNavigationState
    @EnvironmentObject private var dataStore: DataStore

    /// Owns the `presented: SheetKind?` state that ChapterDetailView
    /// previously held as `@State`. Extracting this lets the pilot
    /// CTAs live in `ChapterDetailView+PropagatedCTAs.swift` and the
    /// SheetKind enum live with the coordinator — they all need to
    /// touch the same Identifiable binding, and private @State can't
    /// cross file boundaries. See PilotInteractiveSheetCoordinator
    /// for the full lineage + rationale.
    ///
    /// Single source of truth for which enrichment sheet is on
    /// screen. SwiftUI on macOS Big Sur (11) silently drops all-but-
    /// the-last `.sheet(isPresented:)` modifier on a given view, so
    /// we route every sheet through one `.sheet(item:)` bound to
    /// `$sheetCoordinator.presented`.
    @StateObject private var sheetCoordinator = PilotInteractiveSheetCoordinator()

    /// Returns the chapter's "Beyond the Book" article entry ONLY when
    /// the HTML file is actually findable in Bundle.main. Catches the
    /// failure mode where someone (me!) adds a new HTML to disk but
    /// forgets to add it to the Xcode project — without this gate, the
    /// card opens an empty "Article not found" sheet on click.
    private var beyondTheBookEntry: ArticleEntry? {
        return resolvedArticleEntry(forKey: "\(chapter.id)_beyond")
    }

    /// Returns the chapter's "Common Mistakes" article entry ONLY when
    /// the HTML file is findable in Bundle.main — same gate as
    /// `beyondTheBookEntry`. Surfaces on ChapterDetailView via the
    /// `CommonMistakesCard` alongside Beyond-the-Book. Wired up
    /// 2026-05-26 with the enrichment-consistency push that brought
    /// `ch{NN}_mistakes` coverage to 19/19 chapters.
    private var commonMistakesEntry: ArticleEntry? {
        return resolvedArticleEntry(forKey: "\(chapter.id)_mistakes")
    }

    /// GlossarySheet → article handoff (defer one tick — Big Sur drops sheet-from-sheet).
    private func openGlossaryArticleFromSheet() {
        guard let entry = resolvedArticleEntry(forKey: "\(chapter.id)_glossary") else { return }
        sheetCoordinator.presented = nil
        DispatchQueue.main.async { sheetCoordinator.presented = .article(entry) }
    }

    /// Bundle-existence-gated entry lookup. Returns nil if missing/unbundled (card auto-hides).
    private func resolvedArticleEntry(forKey key: String) -> ArticleEntry? {
        guard pack.id == "science_class7" || pack.id == "maths_class7" else { return nil }
        let lookup = pack.id == "maths_class7" ? "m" + key : key   // Maths keys are mch01_… (Science reuses ch01…)
        guard let entry = ArticleIndex.entries[lookup] else { return nil }
        let name = entry.filename.replacingOccurrences(of: ".html", with: "")
        let resolved = Bundle.main.url(forResource: name, withExtension: "html",
                                        subdirectory: entry.chapterFolder)
            ?? Bundle.main.url(forResource: name, withExtension: "html")
        return resolved != nil ? entry : nil
    }

    /// Container for the 12 content-surface widgets that sit beneath
    /// the topic cards. Each auto-hides when its backing JSON field is
    /// nil/empty. Lifted out of `body` so the parent VStack stays at
    /// 5 direct children (under the @ViewBuilder cap on Big Sur).
    @ViewBuilder
    private var contentSurfacesGroup: some View {
        // Split into two inner Groups so each stays under the
        // @ViewBuilder 10-child cap on Big Sur. Adding Gallery +
        // Scientists pushed the original Group from 10 to 12.
        Group {
            surfacesGroupTop
            surfacesGroupBottom
        }
    }

    @ViewBuilder
    private var surfacesGroupTop: some View {
        Group {
            ch1PilotInteractives(pack: pack, chapter: chapter, coordinator: sheetCoordinator)
            propagatedPilotInteractives(pack: pack, chapter: chapter, coordinator: sheetCoordinator)
            DeepDiveSection(chapter: chapter)
            NcertQASectionView(chapter: chapter)
            MisconceptionsSectionView(chapter: chapter)
            MediaAssetGallerySectionView(pack: pack, chapter: chapter)
            WhatIfsSectionView(chapter: chapter)
            MiniProjectsSectionView(chapter: chapter)
            TimelinesSectionView(chapter: chapter)
        }
    }

    @ViewBuilder
    private var surfacesGroupBottom: some View {
        Group {
            conceptMapCTA(chapter: chapter, coordinator: sheetCoordinator)
            RelatedChaptersStrip(pack: pack, chapter: chapter)
            CurriculumBridgeChip(chapter: chapter)
            glossaryButton
            // Extra-reading chips for the 4 templated enrichment
            // articles shipped 2026-05-26 (Vocabulary Deck, NCERT Q&A,
            // Scientist Spotlight, What If?). Each chip auto-hides
            // when its article isn't bundled; the whole row hides
            // when none are bundled.
            ExtraReadingRow(pack: pack, chapter: chapter) { entry in
                sheetCoordinator.presented = .article(entry)
            }
            GallerySectionView(chapter: chapter)
            ScientistsSectionView(chapter: chapter)
            CrossChapterRefsFooter(pack: pack, chapter: chapter)
        }
    }

    /// Lightweight "Glossary" launcher chip — sits among the content
    /// surfaces. Auto-hides when `chapter.glossary` is empty so we
    /// don't show a button to nothing.
    @ViewBuilder
    private var glossaryButton: some View {
        if !chapter.glossaryList.isEmpty {
            Button {
                DispatchQueue.main.async { sheetCoordinator.presented = .glossary }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: SFSymbolCompat.name("character.book.closed"))
                        .font(.body)
                        .foregroundColor(Color.compatIndigo)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Glossary")
                            .font(.callout.weight(.semibold))
                        Text("\(chapter.glossaryList.count) term\(chapter.glossaryList.count == 1 ? "" : "s") for this chapter")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.secondary)
                        .accessibilityHidden(true)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.compatIndigo.opacity(0.08))
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Glossary — \(chapter.glossaryList.count) terms")
            .accessibilityHint("Opens the chapter's glossary in a sheet.")
        }
    }

    /// Chapter-scoped "Stuck here?" signals — derived per-render so
    /// new tough flags / missed reviews / bookmarks land immediately.
    private var stuckSignals: StuckSignals {
        ChapterStuckHereStrip.signals(
            chapter: chapter,
            toughQuestionIds: Set(dataStore.questionIdsScoped(Array(dataStore.toughQuestionIds), toPackId: pack.id)),
            recentlyMissedIds: dataStore.questionIdsScoped(dataStore.recentlyMissedQuestionIds(), toPackId: pack.id),
            bookmarkedConceptIds: Set(
                dataStore.studyBookmarks
                    .filter { $0.subjectPackId == pack.id }
                    .map(\.conceptId)
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(chapter.summary)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)

                // "Stuck here?" — auto-hides on empty signal set.
                ChapterStuckHereStrip(
                    pack: pack,
                    chapter: chapter,
                    signals: stuckSignals,
                    onTapQuestion: { qid in
                        nav.questionSiblings = [
                            QuestionRef(packId: pack.id, questionId: qid)
                        ]
                        nav.push(.question(packId: pack.id, questionId: qid))
                    },
                    onTapConcept: { cid in
                        nav.push(.concept(packId: pack.id, conceptId: cid))
                    }
                )

                if DiscoverMode.hasExperience(for: pack, chapter: chapter) {
                    Button {
                        // CRITICAL (2026-05-22 07:35 fix): defer the
                        // navigation push to the next runloop tick.
                        // Rohan reported the crash pattern: open Try at
                        // Home / Beyond the Book / My Notebook, dismiss,
                        // THEN click Try Discover Mode → EXC_BAD_ACCESS
                        // in objc_release. Cause: the sheet's dismiss
                        // and the nav.push trigger overlapping re-renders
                        // of ChapterDetailView in the same runloop tick.
                        // SwiftUI's "Entangling fence requested after
                        // pre-commit" warning fires when one render
                        // commit hasn't finished before the next one
                        // starts. DispatchQueue.main.async pushes the
                        // navigation to the next tick so the sheet-
                        // dismiss commit completes first. Same effect
                        // when navigating directly (no prior sheet) —
                        // the one-tick delay is imperceptible.
                        let packId = pack.id
                        let chapterId = chapter.id
                        DispatchQueue.main.async {
                            nav.push(.discover(packId: packId, chapterId: chapterId))
                        }
                    } label: {
                        DiscoverEntryBanner(
                            sceneCount: DataStore.discoverSceneCounts[chapter.number] ?? 9
                        )
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("try-discover-mode")
                    .accessibilityLabel("Try Discover Mode")
                    .accessibilityHint("Opens an interactive scene-based version of this chapter — drag, tap, and explore concepts.")
                }

                // Enrichment surfaces: "Beyond the Book" article (long-form
                // reading), "Common Mistakes" article (revision-tier
                // wrong-answer review — added 2026-05-26 to bring the
                // surface to 19/19 chapter coverage), "Try at Home" sheet
                // (hands-on experiments), and "Notebook" sheet (free-form
                // per-chapter writing). Beyond/Mistakes/Home are
                // content-gated; Notebook is always shown.
                VStack(spacing: 12) {
                    if beyondTheBookEntry != nil
                        || commonMistakesEntry != nil
                        || HomeExperimentLibrary.hasExperiments(forPackId: pack.id, chapterId: chapter.id) {
                        HStack(spacing: 12) {
                            if let entry = beyondTheBookEntry {
                                BeyondTheBookCard(entry: entry) {
                                    DispatchQueue.main.async {
                                        sheetCoordinator.presented = .article(entry)
                                    }
                                }
                            }
                            if let entry = commonMistakesEntry {
                                CommonMistakesCard(entry: entry) {
                                    DispatchQueue.main.async {
                                        sheetCoordinator.presented = .article(entry)
                                    }
                                }
                            }
                            if HomeExperimentLibrary.hasExperiments(forPackId: pack.id, chapterId: chapter.id) {
                                // Defer the sheet-present to the next runloop tick.
                                // Same C2 cascade fix as the Try Discover Mode nav.push
                                // — setting sheetCoordinator.presented inside the Button action
                                // can collide with the Button-press render commit on
                                // ChapterDetailView, sometimes tripping "Entangling
                                // fence requested after pre-commit" → EXC_BAD_ACCESS.
                                TryAtHomeCard {
                                    DispatchQueue.main.async { sheetCoordinator.presented = .homeExperiments }
                                }
                            }
                        }
                    }
                    NotebookCard(
                        hasNotes: !(dataStore.chapterNotes[chapter.id]?.isEmpty ?? true)
                    ) {
                        DispatchQueue.main.async { sheetCoordinator.presented = .notebook }
                    }
                }

                ForEach(chapter.topics) { topic in
                    Button {
                        nav.push(.topic(packId: pack.id, topicId: topic.id))
                    } label: {
                        TopicCard(topic: topic)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .pointingCursor()
                    // VoiceOver was hearing only the topic title. Adding
                    // a hint so users know what the tap does and what's
                    // behind it (concept / question counts).
                    .accessibilityLabel(topic.title)
                    .accessibilityHint("Opens topic — \(topic.concepts.count) concepts, \(topic.questions.count) questions.")
                    .contextMenu {
                        Button("Open") { nav.push(.topic(packId: pack.id, topicId: topic.id)) }
                        Button("Copy title") {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(topic.title, forType: .string)
                        }
                    }
                }

                // 12 content surfaces for the previously-unrendered
                // Chapter content types. Each auto-hides when its
                // backing JSON field is nil/empty. Grouped to stay
                // under the SwiftUI @ViewBuilder direct-child cap of
                // 10 — `Group { ... }` wraps don't change rendering,
                // they just let buildBlock fold them into one child
                // of the parent VStack.
                contentSurfacesGroup
            }
            .padding(20)
            // Center the bounded-width column inside the full-width
            // detail pane. Same pattern as ConceptDetailView / QuestionDetailView.
            .frame(maxWidth: DesignTokens.contentMaxWidthWide, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Ch. \(chapter.number) — \(chapter.title)")
        .sheet(item: $sheetCoordinator.presented) { kind in
            switch kind {
            case .homeExperiments:
                HomeExperimentsSheet(
                    chapterId: chapter.id,
                    chapterTitle: "Ch. \(chapter.number) — \(chapter.title)"
                )
            case .notebook:
                ChapterNotebookSheet(
                    chapterId: chapter.id,
                    chapterTitle: "Ch. \(chapter.number) — \(chapter.title)"
                )
                .environmentObject(dataStore)
            case .article(let entry):
                ArticleBrowserView(
                    initialFile: entry.filename,
                    chapterFolder: entry.chapterFolder,
                    articleTitle: entry.title
                )
                .frame(minWidth: 720, idealWidth: 920,
                       minHeight: 540, idealHeight: 680)
            case .glossary:
                GlossarySheet(pack: pack, chapter: chapter,
                              onDismiss: { sheetCoordinator.presented = nil },
                              onOpenFullArticle: openGlossaryArticleFromSheet)
            case .insideTheLeafTour:
                InsideTheLeafTour(
                    chapterId: chapter.id,
                    onDismiss: { sheetCoordinator.presented = nil }
                )
            case .conceptMap:
                ConceptMapView(
                    pack: pack,
                    chapter: chapter,
                    onDismiss: { sheetCoordinator.presented = nil }
                )
            case .insideTheWireTour:
                InsideTheWireTour(
                    chapterId: chapter.id,
                    onDismiss: { sheetCoordinator.presented = nil }
                )
            case .insideTheLensTour:
                InsideTheLensTour(
                    chapterId: chapter.id,
                    onDismiss: { sheetCoordinator.presented = nil }
                )
            case .insideTheAlveolusTour:
                InsideTheAlveolusTour(
                    chapterId: chapter.id,
                    onDismiss: { sheetCoordinator.presented = nil }
                )
            case .insideTheXylemTour:
                InsideTheXylemAscentTour(
                    chapterId: chapter.id,
                    onDismiss: { sheetCoordinator.presented = nil }
                )
            case .insideTheDigestiveTour:
                InsideTheDigestiveTour(
                    chapterId: chapter.id,
                    onDismiss: { sheetCoordinator.presented = nil }
                )
            }
        }
    }

}


// MARK: - Notebook card / sheet — lifted to ChapterDetailView+Notebook.swift
//        to keep this file under the 600 LOC Big Sur type-checker ceiling.

// MARK: - Enrichment + Try-at-Home cards
// BeyondTheBookCard + TryAtHomeCard live in ChapterDetailView+EnrichmentCards.swift,
// CommonMistakesCard in ChapterDetailView+CommonMistakesCard.swift, the
// HomeExperiment library/sheet in ChapterDetailView+HomeExperiments.swift —
// all lifted to keep this file under the 600-LOC Big Sur type-checker ceiling.


// MARK: - HomeExperiment / library / sheet / card — lifted to
//        ChapterDetailView+HomeExperiments.swift (same reason).


private struct DiscoverEntryBanner: View {
    /// Live scene count for THIS chapter — was hard-coded "9 interactive
    /// scenes" pre-2026-05-21, which lied to the kid once we expanded
    /// every chapter to 20+. Reads through DataStore.discoverSceneCounts
    /// keyed by chapter.number; defaults to 9 if not in the table (e.g.
    /// content packs that never grew beyond the original 9).
    let sceneCount: Int

    @State private var isHovered = false

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Text("✨")
                .font(.system(size: 38))
            VStack(alignment: .leading, spacing: 4) {
                Text("Try Discover Mode")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Text("\(sceneCount) interactive scenes — animations, mini-games, and a final boss quiz.")
                    .font(.callout)
                    .foregroundColor(.white.opacity(0.92))
            }
            Spacer()
            Image(systemName: "arrow.right.circle.fill")
                .font(.title)
                .foregroundColor(.white.opacity(0.95))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.30, green: 0.65, blue: 0.45),
                            Color(red: 0.20, green: 0.45, blue: 0.75)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 6)
        )
        .scaleEffect(isHovered ? 1.01 : 1.0)
        // Same Reduce Motion gate as the two enrichment cards above —
        // clamp the hover state to false so scaleEffect stays at 1.0.
        .onHover { hovering in
            isHovered = hovering && !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Opens an illustrated, interactive learning experience for this chapter.")
    }
}

private struct TopicCard: View {
    let topic: Topic
    @State private var isHovered = false

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(topic.title)
                    .font(.title3.bold())
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(topic.summary)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineSpacing(3)
                HStack(spacing: 12) {
                    Label("\(topic.concepts.count) concepts", systemImage: "lightbulb")
                    Label("\(topic.questions.count) questions", systemImage: "questionmark.circle")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isHovered ? Color.gray.opacity(0.18) : Color.gray.opacity(0.1))
        )
        .onHover { hovering in isHovered = hovering }
    }
}
