import SwiftUI

struct QuizBankView: View {
    @EnvironmentObject var subjectRegistry: SubjectRegistry

    @State private var typeFilter: QuestionType? = nil
    @State private var difficultyFilter: Int? = nil
    @State private var chapterFilter: String? = nil
    @State private var searchText = ""
    @State private var path = NavigationPath()

    private var allEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)] {
        subjectRegistry.packs.flatMap { pack in
            pack.chapters.flatMap { chapter in
                chapter.topics.flatMap { topic in
                    topic.questions.map { (pack, chapter, $0) }
                }
            }
        }
    }

    private var filteredEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)] {
        allEntries.filter { entry in
            if let tf = typeFilter, entry.question.questionType != tf { return false }
            if let df = difficultyFilter, entry.question.difficulty != df { return false }
            if let cf = chapterFilter, entry.chapter.id != cf { return false }
            if !searchText.isEmpty {
                let text = searchText.lowercased()
                if !entry.question.prompt.lowercased().contains(text) { return false }
            }
            return true
        }
    }

    private var availableChapters: [(id: String, label: String)] {
        var seen = Set<String>()
        return allEntries.compactMap { entry in
            guard seen.insert(entry.chapter.id).inserted else { return nil }
            return (entry.chapter.id, "Ch. \(entry.chapter.number) — \(entry.chapter.title)")
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                filterBar
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.bar)

                Divider()

                if filteredEntries.isEmpty {
                    ContentUnavailableView(
                        "No questions match",
                        systemImage: "magnifyingglass",
                        description: Text("Try adjusting your filters.")
                    )
                } else {
                    List(filteredEntries, id: \.question.id) { entry in
                        NavigationLink(value: QuizBankRoute(packId: entry.pack.id, questionId: entry.question.id)) {
                            QuizBankRow(chapter: entry.chapter, question: entry.question)
                        }
                    }
                    .listStyle(.inset)
                }
            }
            .navigationTitle("Quiz Bank")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Text("Showing \(filteredEntries.count) of \(allEntries.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationDestination(for: QuizBankRoute.self) { route in
                if let pack = subjectRegistry.pack(withId: route.packId),
                   let question = pack.allQuestions.first(where: { $0.id == route.questionId }) {
                    QuestionDetailView(pack: pack, question: question)
                } else {
                    ContentUnavailableView("Question not found", systemImage: "questionmark.folder")
                }
            }
        }
    }

    private var filterBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 4) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search questions...", text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(6)
            .background(.background.secondary, in: RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: 220)

            Picker("Type", selection: $typeFilter) {
                Text("All Types").tag(QuestionType?.none)
                ForEach([QuestionType.mcq, .shortAnswer, .longAnswer, .numerical, .trueFalse, .matchTheFollowing, .fillInBlank], id: \.self) { t in
                    Text(t.displayName).tag(QuestionType?.some(t))
                }
            }
            .frame(maxWidth: 160)

            Picker("Difficulty", selection: $difficultyFilter) {
                Text("All Levels").tag(Int?.none)
                ForEach(1...5, id: \.self) { d in
                    Text("Level \(d)").tag(Int?.some(d))
                }
            }
            .frame(maxWidth: 120)

            Picker("Chapter", selection: $chapterFilter) {
                Text("All Chapters").tag(String?.none)
                ForEach(availableChapters, id: \.id) { ch in
                    Text(ch.label).tag(String?.some(ch.id))
                }
            }
            .frame(maxWidth: 220)

            Spacer()
        }
    }
}

struct QuizBankRoute: Hashable {
    let packId: String
    let questionId: String
}

private struct QuizBankRow: View {
    let chapter: Chapter
    let question: Question

    var body: some View {
        HStack(spacing: 12) {
            Text(question.questionType.displayName)
                .font(.caption2.bold())
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .foregroundStyle(.white)
                .background(badgeColor, in: Capsule())

            VStack(alignment: .leading, spacing: 3) {
                Text(question.prompt)
                    .font(.body)
                    .lineLimit(2)
                HStack(spacing: 8) {
                    Text("Ch. \(chapter.number)")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.indigo.opacity(0.12), in: Capsule())
                        .foregroundStyle(.indigo)
                    QuestionDifficultyBadge(level: question.difficulty)
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
        case .trueFalse:        return .teal
        case .matchTheFollowing: return .pink
        case .fillInBlank:      return .cyan
        }
    }
}
