import SwiftUI
import AppKit

struct ChapterDetailView: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var nav: TutorNavigationState
    @EnvironmentObject private var dataStore: DataStore
    @State private var presentedSheet: SheetKind?

    /// Single source of truth for which enrichment sheet is on screen.
    /// SwiftUI on macOS Big Sur (11) silently drops all-but-the-last
    /// `.sheet(isPresented:)` modifier on a given view, so we route
    /// every sheet through one `.sheet(item:)`. Identifiable conformance
    /// is required so the .sheet(item:) modifier can key the
    /// re-presentation.
    private enum SheetKind: Identifiable {
        case homeExperiments
        case notebook
        case article(ArticleEntry)
        case glossary
        case insideTheLeafTour       // Ch.1 pilot — Phase 2B
        case ch1ConceptMap           // Ch.1 pilot — Phase 2E
        case insideTheWireTour       // Ch.14 propagation (2026-05-24)
        case insideTheLensTour       // Ch.15 propagation (2026-05-24)

        var id: String {
            switch self {
            case .homeExperiments:
                return "homeExperiments"
            case .notebook:
                return "notebook"
            case .article(let entry):
                return "article-\(entry.id)"
            case .glossary:
                return "glossary"
            case .insideTheLeafTour:
                return "insideTheLeafTour"
            case .ch1ConceptMap:
                return "ch1ConceptMap"
            case .insideTheWireTour:
                return "insideTheWireTour"
            case .insideTheLensTour:
                return "insideTheLensTour"
            }
        }
    }

    /// Returns the chapter's "Beyond the Book" article entry ONLY when
    /// the HTML file is actually findable in Bundle.main. Catches the
    /// failure mode where someone (me!) adds a new HTML to disk but
    /// forgets to add it to the Xcode project — without this gate, the
    /// card opens an empty "Article not found" sheet on click.
    private var beyondTheBookEntry: ArticleEntry? {
        guard let entry = ArticleIndex.entries["\(chapter.id)_beyond"] else {
            return nil
        }
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
            ch1PilotInteractives  // empty unless chapter.id == "ch01"
            propagatedPilotInteractives  // empty unless chapter.id ∈ {ch04,ch06,ch07,ch14,ch15}
            DeepDiveSection(chapter: chapter)
            NcertQASectionView(chapter: chapter)
            MisconceptionsSectionView(chapter: chapter)
            MediaAssetGallerySectionView(pack: pack, chapter: chapter)
            WhatIfsSectionView(chapter: chapter)
            MiniProjectsSectionView(chapter: chapter)
            TimelinesSectionView(chapter: chapter)
        }
    }

    /// Per-chapter Surface-2 / Surface-3 mounts propagated from the Ch.1
    /// pilot (2026-05-24). Each entry is its own gate on chapter.id so
    /// the wrong sandbox / tour never leaks into the wrong chapter. The
    /// gates here are deliberately mutually exclusive — no chapter ships
    /// more than one custom interactive in this round. This block is
    /// one direct child of surfacesGroupTop so the @ViewBuilder 10-
    /// child cap on that Group is preserved on Big Sur.
    @ViewBuilder
    private var propagatedPilotInteractives: some View {
        if chapter.id == "ch04" {
            BuildAHeatFlowSandbox(chapterId: chapter.id)
        } else if chapter.id == "ch06" {
            BuildAReactionSandbox(chapterId: chapter.id)
        } else if chapter.id == "ch07" {
            BuildAClimateSandbox(chapterId: chapter.id)
        } else if chapter.id == "ch14" {
            insideTheWireTourCTA
        } else if chapter.id == "ch15" {
            insideTheLensTourCTA
        }
    }

    /// CTA card opening InsideTheWireTour sheet. Ch.14 only.
    private var insideTheWireTourCTA: some View {
        Button {
            DispatchQueue.main.async { presentedSheet = .insideTheWireTour }
        } label: {
            Ch1PilotCTACard(
                symbol: "bolt.fill",
                title: "Inside the wire",
                subtitle: "Shrink to electron-size and trace the chain from battery to glowing filament — five-stop guided journey.",
                gradient: [
                    Color(red: 0.85, green: 0.65, blue: 0.10),
                    Color(red: 0.60, green: 0.20, blue: 0.10)
                ]
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("Inside the wire — five-stop electron-flow tour")
        .accessibilityHint("Opens a sheet that walks you from a battery's negative terminal through a copper lattice to a glowing bulb filament.")
    }

    /// CTA card opening InsideTheLensTour sheet. Ch.15 only.
    private var insideTheLensTourCTA: some View {
        Button {
            DispatchQueue.main.async { presentedSheet = .insideTheLensTour }
        } label: {
            Ch1PilotCTACard(
                symbol: "eye.fill",
                title: "Inside the lens",
                subtitle: "Follow a ray of light from a distant star through a convex lens — when does it form a real image, when does it magnify?",
                gradient: [
                    Color(red: 0.45, green: 0.30, blue: 0.70),
                    Color(red: 0.20, green: 0.45, blue: 0.75)
                ]
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("Inside the lens — five-stop refraction tour")
        .accessibilityHint("Opens a sheet that walks you through how a convex lens refracts light, forms a real inverted image, and acts as a magnifying glass.")
    }

    /// Ch.1 pilot — five net-new pedagogical surfaces mount here. The
    /// conditional `if chapter.id == "ch01"` is the leak-prevention
    /// point: every other chapter sees an EmptyView for this slot, so
    /// pixel + structural parity for Ch.2..19 is preserved. The
    /// Ch2_19_StructuralRatchetTests guards against accidentally
    /// editing JSON for those chapters; this conditional guards
    /// against accidentally mounting Ch.1 views elsewhere.
    @ViewBuilder
    private var ch1PilotInteractives: some View {
        if chapter.id == "ch01" {
            BuildAPlantSandbox(chapterId: chapter.id)
            insideTheLeafTourCTA
            ch1ConceptMapCTA
        }
    }

    /// CTA card that opens Ch1ConceptMap as a sheet (Phase 2E).
    private var ch1ConceptMapCTA: some View {
        Button {
            DispatchQueue.main.async { presentedSheet = .ch1ConceptMap }
        } label: {
            Ch1PilotCTACard(
                symbol: "point.3.connected.trianglepath.dotted",
                title: "See the connections",
                subtitle: "Visualise how this chapter's ideas link together — and where they reach into Ch.10 and Ch.17.",
                gradient: [
                    Color(red: 0.40, green: 0.30, blue: 0.70),
                    Color(red: 0.20, green: 0.45, blue: 0.65)
                ]
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("See the connections — concept map for this chapter")
        .accessibilityHint("Opens a sheet showing how the chapter's concepts link to each other and to other chapters.")
    }

    /// CTA card that opens the InsideTheLeafTour sheet. Ch.1 pilot only;
    /// the parent gate (`chapter.id == "ch01"`) keeps this off Ch.2..19.
    /// Visual built from `Ch1PilotCTACard` (sister file) so the LOC
    /// stays under the 600 ceiling here.
    private var insideTheLeafTourCTA: some View {
        Button {
            DispatchQueue.main.async { presentedSheet = .insideTheLeafTour }
        } label: {
            Ch1PilotCTACard(
                symbol: "magnifyingglass.circle.fill",
                title: "Inside the Leaf",
                subtitle: "Shrink yourself to a stoma, then to a chloroplast, then to a thylakoid — five-stop guided journey.",
                gradient: [
                    Color(red: 0.18, green: 0.50, blue: 0.42),
                    Color(red: 0.10, green: 0.30, blue: 0.55)
                ]
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("Inside the Leaf — five-stop guided tour")
        .accessibilityHint("Opens a sheet that walks you through a leaf from outside to inside a chloroplast.")
    }

    @ViewBuilder
    private var surfacesGroupBottom: some View {
        Group {
            CurriculumBridgeChip(chapter: chapter)
            glossaryButton
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
                DispatchQueue.main.async { presentedSheet = .glossary }
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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(chapter.summary)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)

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
                // reading), "Try at Home" sheet (hands-on experiments), and
                // "Notebook" sheet (free-form per-chapter writing).
                // Beyond/Home are content-gated; Notebook is always shown.
                VStack(spacing: 12) {
                    if beyondTheBookEntry != nil || HomeExperimentLibrary.hasExperiments(for: chapter.id) {
                        HStack(spacing: 12) {
                            if let entry = beyondTheBookEntry {
                                BeyondTheBookCard(entry: entry) {
                                    DispatchQueue.main.async {
                                        presentedSheet = .article(entry)
                                    }
                                }
                            }
                            if HomeExperimentLibrary.hasExperiments(for: chapter.id) {
                                // Defer the sheet-present to the next runloop tick.
                                // Same C2 cascade fix as the Try Discover Mode nav.push
                                // — setting presentedSheet inside the Button action
                                // can collide with the Button-press render commit on
                                // ChapterDetailView, sometimes tripping "Entangling
                                // fence requested after pre-commit" → EXC_BAD_ACCESS.
                                TryAtHomeCard {
                                    DispatchQueue.main.async { presentedSheet = .homeExperiments }
                                }
                            }
                        }
                    }
                    NotebookCard(
                        hasNotes: !(dataStore.chapterNotes[chapter.id]?.isEmpty ?? true)
                    ) {
                        DispatchQueue.main.async { presentedSheet = .notebook }
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
        .sheet(item: $presentedSheet) { kind in
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
                GlossarySheet(
                    chapter: chapter,
                    onDismiss: { presentedSheet = nil }
                )
            case .insideTheLeafTour:
                InsideTheLeafTour(
                    chapterId: chapter.id,
                    onDismiss: { presentedSheet = nil }
                )
            case .ch1ConceptMap:
                Ch1ConceptMap(
                    pack: pack,
                    chapter: chapter,
                    onDismiss: { presentedSheet = nil }
                )
            case .insideTheWireTour:
                InsideTheWireTour(
                    chapterId: chapter.id,
                    onDismiss: { presentedSheet = nil }
                )
            case .insideTheLensTour:
                InsideTheLensTour(
                    chapterId: chapter.id,
                    onDismiss: { presentedSheet = nil }
                )
            }
        }
    }

}


// MARK: - Notebook card / sheet — lifted to ChapterDetailView+Notebook.swift
//        to keep this file under the 600 LOC Big Sur type-checker ceiling.

// MARK: - Beyond the Book card

private struct BeyondTheBookCard: View {
    let entry: ArticleEntry
    let onTap: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text("📖")
                        .font(.system(size: 26))
                    Text("Beyond the Book")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Text(entry.title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.92))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text("≈ \(entry.estimatedMinutes) min read")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.45, green: 0.30, blue: 0.65),
                                Color(red: 0.25, green: 0.40, blue: 0.70)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isHovered ? 1.01 : 1.0)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        // Hover scale is a motion cue — gate it on Reduce Motion so
        // accessibility users don't get the 1% pulse on every chapter
        // detail card. The opacity-only TopicCard hover stays unchanged.
        .onHover { hovering in
            isHovered = hovering && !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        }
        .accessibilityIdentifier("beyond-the-book")
        .accessibilityLabel("Beyond the Book")
        .accessibilityHint("Opens a long-form enrichment article for this chapter.")
    }
}

// MARK: - Try at Home card

private struct TryAtHomeCard: View {
    let onTap: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text("🧪")
                        .font(.system(size: 26))
                    Text("Try at Home")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Text("Hands-on experiments you can do this weekend.")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.92))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text("5 experiments")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.85, green: 0.45, blue: 0.25),
                                Color(red: 0.65, green: 0.30, blue: 0.50)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isHovered ? 1.01 : 1.0)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        // Hover scale is a motion cue — gate it on Reduce Motion so
        // accessibility users don't get the 1% pulse on every chapter
        // detail card. The opacity-only TopicCard hover stays unchanged.
        .onHover { hovering in
            isHovered = hovering && !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        }
        .accessibilityLabel("Try at Home")
        .accessibilityHint("Opens hands-on home experiments for this chapter.")
    }
}


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
