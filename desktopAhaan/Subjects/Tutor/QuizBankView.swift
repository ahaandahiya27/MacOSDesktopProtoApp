import SwiftUI

struct QuizBankView: View {
    var body: some View {
        TutorNavigationContainer {
            QuizBankContent()
        }
    }
}

private struct QuizBankContent: View {
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject private var nav: TutorNavigationState
    @EnvironmentObject private var dataStore: DataStore

    @State private var typeFilter: QuestionType? = nil
    @State private var difficultyFilter: Int? = nil
    @State private var chapterFilter: String? = nil
    /// Subject (pack) filter. Bug fix: without this scope, two packs with
    /// overlapping chapter IDs (Sanskrit Ch4 vs Science Ch4 = Heat) would
    /// both match a single chapterFilter pick. Selecting a subject narrows
    /// every downstream control — including which chapters appear in the
    /// chapter dropdown — to that pack only.
    @State private var packFilter: String? = nil
    @State private var reviewFilter: ReviewFilter = .all
    @State private var searchText = ""
    @State private var cachedEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)] = []

    enum ReviewFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case reviewed = "Reviewed"
        case needsReview = "Needs review"
        var id: String { rawValue }
    }

    private func rebuildCache() {
        cachedEntries = subjectRegistry.packs.flatMap { pack in
            pack.chapters.flatMap { chapter in
                chapter.topics.flatMap { topic in
                    topic.questions.map { (pack, chapter, $0) }
                }
            }
        }
    }

    private var filteredEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)] {
        // Hot-path performance: hoist `searchText.lowercased()` out of the
        // per-entry closure so it's computed ONCE per filter call instead of
        // ~791 times per keystroke. On the 1.4 GHz Haswell iMac CPU this was
        // a measurable main-thread block while typing in the search field.
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespaces)
        let needle: String? = trimmedSearch.isEmpty ? nil : trimmedSearch.lowercased()
        let pf = packFilter
        let tf = typeFilter
        let df = difficultyFilter
        let cf = chapterFilter
        let rf = reviewFilter

        return cachedEntries.filter { entry in
            if let pf = pf, entry.pack.id != pf { return false }
            if let tf = tf, entry.question.questionType != tf { return false }
            if let df = df, entry.question.difficulty != df { return false }
            if let cf = cf, entry.chapter.id != cf { return false }
            switch rf {
            case .all: break
            case .reviewed:
                // "Reviewed" = no JSON flag OR the parent marked it in-app.
                if dataStore.effectiveNeedsReview(entry.question) { return false }
            case .needsReview:
                if !dataStore.effectiveNeedsReview(entry.question) { return false }
            }
            if let needle = needle,
               !entry.question.prompt.lowercased().contains(needle) {
                return false
            }
            return true
        }
    }

    /// Pack-aware. When a subject is selected, the chapter dropdown only
    /// lists that subject's chapters — fixes the cross-pack chapter-id
    /// collision (e.g., "Ch.4" meaning Sanskrit Ch4 vs Science Heat).
    private var availablePacks: [(id: String, label: String)] {
        var seen = Set<String>()
        return cachedEntries.compactMap { entry in
            guard seen.insert(entry.pack.id).inserted else { return nil }
            return (entry.pack.id, "\(entry.pack.coverEmoji) \(entry.pack.title)")
        }
    }

    /// Push a question detail view, also recording the current filtered list
    /// as the sibling set so Prev/Next inside the detail view can walk it.
    /// The `siblings` snapshot is passed in from `body` to avoid a second
    /// ~791-entry filter pass on the main thread (the Late-2014 iMac CPU
    /// couldn't absorb it — the hang widened the window for SwiftUI's
    /// attribute graph to corrupt on a fast double-click).
    private func openQuestion(_ entry: (pack: SubjectPack, chapter: Chapter, question: Question),
                              siblings: [QuestionRef]) {
        nav.questionSiblings = siblings
        nav.push(.question(packId: entry.pack.id, questionId: entry.question.id))
    }

    private var availableChapters: [(id: String, label: String)] {
        var seen = Set<String>()
        return cachedEntries.compactMap { entry in
            // Restrict to selected pack so chapter IDs are unambiguous.
            if let pf = packFilter, entry.pack.id != pf { return nil }
            guard seen.insert(entry.chapter.id).inserted else { return nil }
            return (entry.chapter.id, "Ch. \(entry.chapter.number) — \(entry.chapter.title)")
        }
    }

    var body: some View {
        // Compute filteredEntries ONCE per body render — was called twice
        // (`.isEmpty` check + `List(...)` initializer) which doubled the
        // ~791-entry filter cost on every render. Also derive the sibling
        // refs once here so openQuestion() doesn't have to recompute the
        // filter on click (see openQuestion docstring).
        let entries = filteredEntries
        let siblingRefs = entries.map {
            QuestionRef(packId: $0.pack.id, questionId: $0.question.id)
        }

        return VStack(spacing: 0) {
            filterBar
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.vertical, 10)
                .background(Color(NSColor.controlBackgroundColor))

            Divider()

            if entries.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "No questions match",
                    subtitle: "Try adjusting your filters — or clear them to see every question across all chapters."
                )
            } else {
                List(entries, id: \.question.id) { entry in
                    Button {
                        openQuestion(entry, siblings: siblingRefs)
                    } label: {
                        QuizBankRow(pack: entry.pack, chapter: entry.chapter, question: entry.question)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .pointingCursor()
                    .accessibilityHint("Opens this question for practice")
                    .accessibilityIdentifier("quizbank-question-row-\(entry.question.id)")
                    .contextMenu {
                        Button("Open") { openQuestion(entry, siblings: siblingRefs) }
                    }
                }
                .listStyle(.inset)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Quiz Bank")
        .onAppear { rebuildCache() }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Text("Showing \(entries.count) of \(cachedEntries.count)")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
            }
        }
    }

    private var filterBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: DesignTokens.Spacing.xs) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search questions...", text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear search")
                    .accessibilityHint("Empties the search field and shows all questions")
                    .accessibilityIdentifier("quizbank-search-clear")
                }
            }
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                    .fill(Color.gray.opacity(0.1))
            )
            .frame(minWidth: 140)

            // Subject (pack) filter — first dropdown so the user sees that
            // picking a subject narrows everything downstream (chapter list,
            // results) to one pack at a time.
            Picker("Subject", selection: $packFilter) {
                Text("All Subjects").tag(String?.none)
                ForEach(availablePacks, id: \.id) { p in
                    Text(p.label).tag(String?.some(p.id))
                }
            }
            .fixedSize()
            .onChange(of: packFilter) { _ in
                // Reset chapter selection when changing subject — a chapter id
                // from one pack is meaningless in another (and would silently
                // match a same-number chapter, which is exactly the bug we
                // are fixing here).
                chapterFilter = nil
            }

            Picker("Type", selection: $typeFilter) {
                Text("All Types").tag(QuestionType?.none)
                ForEach([QuestionType.mcq, .shortAnswer, .longAnswer, .numerical, .trueFalse, .matchTheFollowing, .fillInBlank], id: \.self) { t in
                    Text(t.displayName).tag(QuestionType?.some(t))
                }
            }
            .fixedSize()

            Picker("Difficulty", selection: $difficultyFilter) {
                Text("All Levels").tag(Int?.none)
                ForEach(1...5, id: \.self) { d in
                    Text("Level \(d)").tag(Int?.some(d))
                }
            }
            .fixedSize()

            Picker("Chapter", selection: $chapterFilter) {
                Text("All Chapters").tag(String?.none)
                ForEach(availableChapters, id: \.id) { ch in
                    Text(ch.label).tag(String?.some(ch.id))
                }
            }
            .frame(minWidth: 120)

            Picker("Review", selection: $reviewFilter) {
                ForEach(ReviewFilter.allCases) { rf in
                    Text(rf.rawValue).tag(rf)
                }
            }
            .fixedSize()
            .help("Filter to questions a parent should triage (flagged with needsHumanReview).")

            Spacer()
        }
    }
}

private struct QuizBankRow: View {
    let pack: SubjectPack
    let chapter: Chapter
    let question: Question

    @EnvironmentObject private var dataStore: DataStore

    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Text(question.questionType.displayName)
                .font(.caption2.bold())
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .foregroundColor(.white)
                .background(Capsule().fill(badgeColor))

            VStack(alignment: .leading, spacing: 3) {
                Text(question.prompt)
                    .font(.body)
                    .lineLimit(2)
                    .devanagariAwareLocale(packId: pack.id)
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Text("\(pack.coverEmoji) Ch. \(chapter.number)")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, DesignTokens.Spacing.xxs)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.12)))
                        .foregroundColor(Color.compatIndigo)
                        .accessibilityLabel("\(pack.title), Chapter \(chapter.number)")
                    QuestionDifficultyBadge(level: question.difficulty)
                    if dataStore.effectiveNeedsReview(question) {
                        Label("Needs review", systemImage: "exclamationmark.triangle.fill")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(.orange)
                            .accessibilityLabel("Flagged for human review")
                    } else if question.needsHumanReview {
                        // JSON flag is still on, but the parent marked it
                        // reviewed in-app — show a subtle green confirmation.
                        Label("Reviewed", systemImage: "checkmark.seal.fill")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(.green)
                            .accessibilityLabel("Already triaged")
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, DesignTokens.Spacing.xs)
    }

    private var badgeColor: Color {
        switch question.questionType {
        case .mcq:              return .blue
        case .shortAnswer:      return .orange
        case .longAnswer:       return .purple
        case .numerical:        return .green
        case .trueFalse:        return Color.compatTeal
        case .matchTheFollowing: return .pink
        case .fillInBlank:      return Color.compatCyan
        }
    }
}
