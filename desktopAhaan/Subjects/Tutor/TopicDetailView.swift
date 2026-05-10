import SwiftUI

/// Lists every concept and question in a topic. Concepts come first, then
/// questions, separated by a section header.
struct TopicDetailView: View {
    let pack: SubjectPack
    let topic: Topic

    var body: some View {
        List {
            Section {
                ArticleEntryButton(entry: ArticleIndex.entry(forTopicId: topic.id))
                    .padding(.bottom, 12)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)

            if !topic.concepts.isEmpty {
                Section("Concepts") {
                    ForEach(topic.concepts) { c in
                        NavigationLink(value: TutorRoute.concept(packId: pack.id, conceptId: c.id)) {
                            ConceptRow(concept: c)
                        }
                    }
                }
            }
            if !topic.questions.isEmpty {
                Section("Questions") {
                    ForEach(topic.questions) { q in
                        NavigationLink(value: TutorRoute.question(packId: pack.id, questionId: q.id)) {
                            QuestionRow(question: q)
                        }
                    }
                }
            }
        }
        .listStyle(.inset)
        .navigationTitle(topic.title)
    }
}

private struct ConceptRow: View {
    let concept: Concept
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundStyle(.indigo)
                .font(.title3)
            VStack(alignment: .leading, spacing: 4) {
                Text(concept.title).font(.headline)
                Text(concept.explanation(at: .oneLine))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                if concept.needsHumanReview {
                    Label("Needs review", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption2).foregroundStyle(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

private struct QuestionRow: View {
    let question: Question
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "questionmark.app.fill")
                .foregroundStyle(.orange)
                .font(.title3)
            VStack(alignment: .leading, spacing: 4) {
                Text(question.prompt)
                    .font(.body)
                    .lineLimit(2)
                HStack(spacing: 10) {
                    Text(question.questionType.displayName)
                        .font(.caption2.bold())
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(.indigo.opacity(0.15), in: Capsule())
                    Text(String(repeating: "●", count: question.difficulty))
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
