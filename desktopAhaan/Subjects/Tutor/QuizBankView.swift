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

    @State private var typeFilter: QuestionType? = nil
    @State private var difficultyFilter: Int? = nil
    @State private var chapterFilter: String? = nil
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
        cachedEntries.filter { entry in
            if let tf = typeFilter, entry.question.questionType != tf { return false }
            if let df = difficultyFilter, entry.question.difficulty != df { return false }
            if let cf = chapterFilter, entry.chapter.id != cf { return false }
            switch reviewFilter {
            case .all: break
            case .reviewed: if entry.question.needsHumanReview { return false }
            case .needsReview: if !entry.question.needsHumanReview { return false }
            }
            if !searchText.isEmpty {
                let text = searchText.lowercased()
                if !entry.question.prompt.lowercased().contains(text) { return false }
            }
            return true
        }
    }

    /// Push a question detail view, also recording the current filtered list
    /// as the sibling set so Prev/Next inside the detail view can walk it.
    private func openQuestion(_ entry: (pack: SubjectPack, chapter: Chapter, question: Question)) {
        nav.questionSiblings = filteredEntries.map {
            QuestionRef(packId: $0.pack.id, questionId: $0.question.id)
        }
        nav.push(.question(packId: entry.pack.id, questionId: entry.question.id))
    }

    private var availableChapters: [(id: String, label: String)] {
        var seen = Set<String>()
        return cachedEntries.compactMap { entry in
            guard seen.insert(entry.chapter.id).inserted else { return nil }
            return (entry.chapter.id, "Ch. \(entry.chapter.number) — \(entry.chapter.title)")
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            filterBar
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(NSColor.controlBackgroundColor))

            Divider()

            if filteredEntries.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                        .accessibilityHidden(true)
                    Text("No questions match")
                        .font(.title2.weight(.semibold))
                    Text("Try adjusting your filters.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredEntries, id: \.question.id) { entry in
                    Button {
                        openQuestion(entry)
                    } label: {
                        QuizBankRow(pack: entry.pack, chapter: entry.chapter, question: entry.question)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Open") { openQuestion(entry) }
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
                Text("Showing \(filteredEntries.count) of \(cachedEntries.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var filterBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 4) {
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
                }
            }
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
            )
            .frame(minWidth: 140)

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

struct QuizBankRoute: Hashable {
    let packId: String
    let questionId: String
}

private struct QuizBankRow: View {
    let pack: SubjectPack
    let chapter: Chapter
    let question: Question

    var body: some View {
        HStack(spacing: 12) {
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
                HStack(spacing: 8) {
                    Text("\(pack.coverEmoji) Ch. \(chapter.number)")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.12)))
                        .foregroundColor(Color.compatIndigo)
                        .accessibilityLabel("\(pack.title), Chapter \(chapter.number)")
                    QuestionDifficultyBadge(level: question.difficulty)
                    if question.needsHumanReview {
                        Label("Needs review", systemImage: "exclamationmark.triangle.fill")
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(.orange)
                            .accessibilityLabel("Flagged for human review")
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
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
