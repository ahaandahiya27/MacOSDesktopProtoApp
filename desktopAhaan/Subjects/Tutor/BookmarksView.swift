import SwiftUI
import SwiftData

/// Lists every concept the user has bookmarked, grouped by subject. Tapping
/// a bookmark navigates to that concept inside its subject's NavigationStack.
struct BookmarksView: View {
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var appState: AppState
    @Query(sort: [SortDescriptor(\StudyBookmark.addedAt, order: .reverse)]) private var bookmarks: [StudyBookmark]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if bookmarks.isEmpty {
                ContentUnavailableView(
                    "No bookmarks yet",
                    systemImage: "bookmark",
                    description: Text("Tap the bookmark icon on any concept to save it here.")
                )
            } else {
                List {
                    ForEach(grouped, id: \.0) { (packId, items) in
                        Section(packTitle(for: packId)) {
                            ForEach(items) { b in
                                Button {
                                    open(b)
                                } label: {
                                    HStack {
                                        Image(systemName: "bookmark.fill").foregroundStyle(.indigo)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(b.conceptTitle).font(.headline)
                                            Text("Saved \(b.addedAt, style: .date)")
                                                .font(.caption).foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right").foregroundStyle(.secondary)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            .onDelete { offsets in
                                for offset in offsets {
                                    modelContext.delete(items[offset])
                                }
                                do { try modelContext.save() }
                                catch { print("[BookmarksView] delete save failed: \(error)") }
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
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

    private func open(_ b: StudyBookmark) {
        // Switch the sidebar to the bookmark's subject. The user can then
        // drill into the concept manually. (Cross-stack push isn't reliable
        // on macOS NavigationStack; surfacing the subject is the safest UX.)
        appState.sidebarSelection = .subject(b.subjectPackId)
    }
}
