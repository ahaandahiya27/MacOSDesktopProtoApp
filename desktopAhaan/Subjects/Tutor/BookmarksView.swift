import SwiftUI

struct BookmarksView: View {
    var body: some View {
        TutorNavigationContainer {
            BookmarksContent()
        }
    }
}

private struct BookmarksContent: View {
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject private var nav: TutorNavigationState

    var bookmarks: [StudyBookmark] {
        dataStore.bookmarksByDate
    }

    var body: some View {
        Group {
            if bookmarks.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                        .accessibilityHidden(true)
                    Text("No bookmarks yet")
                        .font(.title2.weight(.semibold))
                    Text("Star concepts you want to revisit — tap the bookmark icon on any concept page.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 360)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(grouped, id: \.0) { (packId, items) in
                        Section(header: Text(packTitle(for: packId))) {
                            ForEach(items) { b in
                                bookmarkRow(b)
                            }
                            .onDelete { offsets in
                                for offset in offsets {
                                    dataStore.deleteBookmark(items[offset])
                                }
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

    private var grouped: [(String, [StudyBookmark])] {
        Dictionary(grouping: bookmarks, by: \.subjectPackId)
            .map { ($0.key, $0.value) }
            .sorted { $0.0 < $1.0 }
    }

    private func packTitle(for id: String) -> String {
        subjectRegistry.pack(withId: id)?.title ?? id
    }

    @ViewBuilder
    private func bookmarkRow(_ b: StudyBookmark) -> some View {
        if let pack = subjectRegistry.pack(withId: b.subjectPackId),
           let concept = pack.conceptIndex[b.conceptId] {
            Button {
                nav.push(.concept(packId: pack.id, conceptId: concept.id))
            } label: {
                bookmarkLabel(b)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .contextMenu {
                Button("Open") { nav.push(.concept(packId: pack.id, conceptId: concept.id)) }
                Button("Remove bookmark") { dataStore.deleteBookmark(b) }
            }
        } else {
            Button { appState.sidebarSelection = .subject(b.subjectPackId) } label: {
                bookmarkLabel(b)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .contextMenu {
                Button("Remove bookmark") { dataStore.deleteBookmark(b) }
            }
        }
    }

    private func bookmarkLabel(_ b: StudyBookmark) -> some View {
        HStack {
            Image(systemName: "bookmark.fill").foregroundColor(Color.compatIndigo)
            VStack(alignment: .leading, spacing: 2) {
                Text(b.conceptTitle).font(.headline)
                Text("Saved \(b.addedAt, style: .date)")
                    .font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.secondary)
        }
    }
}
