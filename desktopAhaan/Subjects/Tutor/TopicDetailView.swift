import SwiftUI
import AppKit

struct TopicDetailView: View {
    let pack: SubjectPack
    let topic: Topic
    @EnvironmentObject private var nav: TutorNavigationState

    var body: some View {
        List {
            Section {
                ArticleEntryButton(entry: ArticleIndex.entry(forTopicId: topic.id))
                    .padding(.bottom, 12)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)

            if !topic.concepts.isEmpty {
                Section(header: Text("Concepts")) {
                    ForEach(topic.concepts) { c in
                        Button {
                            nav.push(.concept(packId: pack.id, conceptId: c.id))
                        } label: {
                            ConceptRow(concept: c)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Open") { nav.push(.concept(packId: pack.id, conceptId: c.id)) }
                            Button("Copy title") {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(c.title, forType: .string)
                            }
                        }
                    }
                }
            }
            if !topic.questions.isEmpty {
                Section(header: Text("Questions")) {
                    ForEach(topic.questions) { q in
                        Button {
                            nav.push(.question(packId: pack.id, questionId: q.id))
                        } label: {
                            QuestionRow(question: q)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Open") { nav.push(.question(packId: pack.id, questionId: q.id)) }
                        }
                    }
                }
            }
        }
        .listStyle(.inset)
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle(topic.title)
    }
}

private struct ConceptRow: View {
    let concept: Concept
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(Color.compatIndigo)
                .font(.title3)
            VStack(alignment: .leading, spacing: 4) {
                Text(concept.title).font(.headline)
                Text(concept.explanation(at: .oneLine))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                if concept.needsHumanReview {
                    Label("Needs review", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption2).foregroundColor(.orange)
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
                .foregroundColor(.orange)
                .font(.title3)
            VStack(alignment: .leading, spacing: 4) {
                Text(question.prompt)
                    .font(.body)
                    .lineLimit(2)
                HStack(spacing: 10) {
                    Text(question.questionType.displayName)
                        .font(.caption2.bold())
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    Text(String(repeating: "●", count: question.difficulty))
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
