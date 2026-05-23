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

        var id: String {
            switch self {
            case .homeExperiments:
                return "homeExperiments"
            case .notebook:
                return "notebook"
            case .article(let entry):
                return "article-\(entry.id)"
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

                // "Go deeper" disclosure — grade-tagged stretch topics for
                // fast learners (`chapter.deepDive`). The widget hides
                // itself when the chapter has no stretch topics, so packs
                // that haven't been authored yet stay visually unchanged.
                // See `DeepDiveSection.swift` for the disclosure body +
                // detail sheet wiring.
                DeepDiveSection(chapter: chapter)
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
                    chapterFolder: entry.chapterFolder
                )
                .frame(minWidth: 720, idealWidth: 920,
                       minHeight: 540, idealHeight: 680)
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
