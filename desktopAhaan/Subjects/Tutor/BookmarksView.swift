import SwiftUI

struct BookmarksView: View {
    var body: some View {
        TutorNavigationContainer {
            BookmarksContent()
        }
    }
}

/// Unified bookmark entry — concepts and questions share the same list now.
/// The associated value is the original record so delete/open work on the
/// concrete type without re-querying the data store.
private enum BookmarkEntry: Identifiable {
    case concept(StudyBookmark)
    case question(QuestionBookmark)

    var id: String {
        switch self {
        case .concept(let b):  return "c::\(b.id)"
        case .question(let b): return "q::\(b.id)"
        }
    }

    var subjectPackId: String {
        switch self {
        case .concept(let b):  return b.subjectPackId
        case .question(let b): return b.subjectPackId
        }
    }

    var addedAt: Date {
        switch self {
        case .concept(let b):  return b.addedAt
        case .question(let b): return b.addedAt
        }
    }
}

private struct BookmarksContent: View {
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject private var nav: TutorNavigationState

    private var entries: [BookmarkEntry] {
        let concepts = dataStore.bookmarksByDate.map(BookmarkEntry.concept)
        let questions = dataStore.questionBookmarksByDate.map(BookmarkEntry.question)
        return (concepts + questions).sorted { $0.addedAt > $1.addedAt }
    }

    var body: some View {
        Group {
            if entries.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                        .accessibilityHidden(true)
                    Text("No bookmarks yet")
                        .font(.title2.weight(.semibold))
                    Text("Star concepts or questions you want to revisit — tap the bookmark icon on any concept or question page.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 520)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(grouped, id: \.0) { (packId, items) in
                        Section(header: Text(packTitle(for: packId))) {
                            ForEach(items) { entry in
                                entryRow(entry)
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Bookmarks")
    }

    private var grouped: [(String, [BookmarkEntry])] {
        Dictionary(grouping: entries, by: \.subjectPackId)
            .map { ($0.key, $0.value) }
            .sorted { $0.0 < $1.0 }
    }

    private func packTitle(for id: String) -> String {
        subjectRegistry.pack(withId: id)?.title ?? id
    }

    @ViewBuilder
    private func entryRow(_ entry: BookmarkEntry) -> some View {
        switch entry {
        case .concept(let b):  conceptRow(b)
        case .question(let b): questionRow(b)
        }
    }

    @ViewBuilder
    private func conceptRow(_ b: StudyBookmark) -> some View {
        if let pack = subjectRegistry.pack(withId: b.subjectPackId),
           let concept = pack.conceptIndex[b.conceptId] {
            Button {
                nav.push(.concept(packId: pack.id, conceptId: concept.id))
            } label: {
                bookmarkLabel(
                    icon: "lightbulb.fill",
                    title: b.conceptTitle,
                    date: b.addedAt,
                    kind: "Concept"
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .contextMenu {
                Button("Open") { nav.push(.concept(packId: pack.id, conceptId: concept.id)) }
                Button("Remove bookmark") { dataStore.deleteBookmark(b) }
            }
        } else {
            Button { appState.sidebarSelection = .subject(b.subjectPackId) } label: {
                bookmarkLabel(
                    icon: "lightbulb",
                    title: b.conceptTitle,
                    date: b.addedAt,
                    kind: "Concept (missing)"
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .contextMenu {
                Button("Remove bookmark") { dataStore.deleteBookmark(b) }
            }
        }
    }

    @ViewBuilder
    private func questionRow(_ b: QuestionBookmark) -> some View {
        if let pack = subjectRegistry.pack(withId: b.subjectPackId),
           pack.questionIndex[b.questionId] != nil {
            Button {
                nav.push(.question(packId: pack.id, questionId: b.questionId))
            } label: {
                bookmarkLabel(
                    icon: "questionmark.circle.fill",
                    title: b.questionPrompt,
                    date: b.addedAt,
                    kind: "Question"
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .contextMenu {
                Button("Open") { nav.push(.question(packId: pack.id, questionId: b.questionId)) }
                Button("Remove bookmark") { dataStore.deleteQuestionBookmark(b) }
            }
        } else {
            Button { appState.sidebarSelection = .subject(b.subjectPackId) } label: {
                bookmarkLabel(
                    icon: "questionmark.circle",
                    title: b.questionPrompt,
                    date: b.addedAt,
                    kind: "Question (missing)"
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .contextMenu {
                Button("Remove bookmark") { dataStore.deleteQuestionBookmark(b) }
            }
        }
    }

    private func bookmarkLabel(icon: String, title: String,
                               date: Date, kind: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(Color.compatIndigo)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                    .truncationMode(.tail)
                HStack(spacing: 8) {
                    Text(kind)
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(Color.compatIndigo)
                    Text("Saved \(date, style: .date)")
                        .font(.caption).foregroundColor(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.secondary)
        }
    }
}
