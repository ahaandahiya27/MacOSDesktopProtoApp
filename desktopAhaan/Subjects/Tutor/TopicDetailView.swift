import SwiftUI
import AppKit

struct TopicDetailView: View {
    let pack: SubjectPack
    let topic: Topic
    @EnvironmentObject private var nav: TutorNavigationState

    /// The chapter that owns this topic — looked up once for the
    /// real-world examples / mnemonic chip strips (which read from
    /// `chapter.realWorldExamples` / `chapter.mnemonics`).
    private var owningChapter: Chapter? {
        pack.chapters.first { $0.topics.contains(where: { $0.id == topic.id }) }
    }

    var body: some View {
        List {
            Section {
                ArticleEntryButton(entry: ArticleIndex.entry(forTopicId: topic.id))
                    .padding(.bottom, 12)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)

            // Real-world examples + mnemonics chip strips. These are
            // owned by the chapter, not the topic — so they appear on
            // every topic page in the chapter. Auto-hide when the
            // chapter has none authored. Wrapped in a Section to play
            // nicely with the List layout (the chip strip uses its own
            // horizontal ScrollView internally).
            if let chapter = owningChapter {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        RealWorldExamplesStripView(chapter: chapter)
                        MnemonicsStripView(chapter: chapter)
                    }
                    .padding(.vertical, 4)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            if !topic.concepts.isEmpty {
                Section(header: Text("Concepts").accessibilityAddTraits(.isHeader)) {
                    ForEach(topic.concepts) { c in
                        Button {
                            nav.push(.concept(packId: pack.id, conceptId: c.id))
                        } label: {
                            ConceptRow(concept: c)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .pointingCursor()
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
                Section(header: Text("Questions").accessibilityAddTraits(.isHeader)) {
                    ForEach(topic.questions) { q in
                        Button {
                            nav.push(.question(packId: pack.id, questionId: q.id))
                        } label: {
                            QuestionRow(question: q)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .pointingCursor()
                        .contextMenu {
                            Button("Open") { nav.push(.question(packId: pack.id, questionId: q.id)) }
                        }
                    }
                }
            }

            if topic.concepts.isEmpty && topic.questions.isEmpty {
                Section {
                    Text("No concepts or questions in this topic yet \u{2014} open the article above to learn the basics.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.inset)
        // Center the bounded-width column inside the full detail pane
        // instead of pinning to leading; matches Concept/Question detail.
        .frame(maxWidth: DesignTokens.contentMaxWidthWide)
        .frame(maxWidth: .infinity, alignment: .center)
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
                        .font(.caption).foregroundColor(DesignTokens.BrandColor.tryAtHome)
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
            Image(systemName: "questionmark.circle.fill")
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
                        .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
