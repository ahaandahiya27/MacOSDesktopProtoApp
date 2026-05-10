import SwiftUI

/// Top-level app shell. Two-section sidebar:
///   • Subjects — dynamically populated from SubjectRegistry
///   • Tools    — Search, Bookmarks, Settings
///
/// Sanskrit Kosh is rendered by SanskritSubjectHomeView (which wraps the
/// existing translator/scan/practice/history/favorites screens). Other
/// subjects use the generic SubjectHomeView (chapter/topic/concept/question
/// navigation stack).
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subjectRegistry: SubjectRegistry

    var body: some View {
        NavigationSplitView {
            sidebar
                .navigationTitle("Sanskrit Kosh")
        } detail: {
            detailPane
        }
    }

    // MARK: - Sidebar

    private var sidebar: some View {
        // Bind directly to the AppState's `sidebarSelection`. The published
        // property has a non-nil default, and macOS List(selection:) handles
        // optional binding internally — no DispatchQueue.main.async wrapper
        // needed. (The earlier wrapper was masking an AttributeGraph cycle
        // that no longer occurs after AppState's default was set.)
        List(selection: Binding(
            get: { appState.sidebarSelection },
            set: { newValue in
                // Defer to next run-loop tick to avoid "Publishing changes
                // from within view updates" runtime warning.
                DispatchQueue.main.async {
                    appState.sidebarSelection = newValue ?? .subject("sanskrit_class7")
                }
            }
        )) {
            Section("Subjects") {
                if subjectRegistry.isLoading {
                    HStack(spacing: 8) {
                        ProgressView().controlSize(.small)
                        Text("Loading subjects…")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } else if subjectRegistry.packs.isEmpty {
                    Text("No subjects loaded")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(subjectRegistry.packs) { pack in
                        Label {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(pack.title).font(.body)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                Text("\(pack.conceptCount) concepts · \(pack.questionCount) questions")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Text(pack.coverEmoji)
                        }
                        .tag(SidebarSelection.subject(pack.id))
                    }
                }
            }

            Section("Quiz Bank") {
                Label {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Practice Questions").font(.body)
                        Text("\(subjectRegistry.packs.reduce(0) { $0 + $1.questionCount }) questions across all chapters")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "list.bullet.clipboard.fill")
                }
                .tag(SidebarSelection.quizBank)
            }

            Section("Tools") {
                ForEach(SidebarTool.allCases) { tool in
                    Label(tool.title, systemImage: tool.systemImage)
                        .symbolRenderingMode(.hierarchical)
                        .tag(SidebarSelection.tool(tool))
                }
            }
        }
    }

    // MARK: - Detail

    @ViewBuilder
    private var detailPane: some View {
        switch appState.sidebarSelection {
        case .subject(let id):
            if let pack = subjectRegistry.pack(withId: id) {
                if id == "sanskrit_class7" {
                    SanskritSubjectHomeView()
                } else {
                    SubjectHomeView(pack: pack)
                }
            } else {
                ContentUnavailableView(
                    "Subject not loaded",
                    systemImage: "books.vertical",
                    description: Text("Pack '\(id)' isn't bundled. Run the ContentPipeline to generate it.")
                )
            }
        case .quizBank:
            QuizBankView()
        case .tool(.search):
            SearchView()
        case .tool(.bookmarks):
            BookmarksView()
        case .tool(.settings):
            SettingsScreen()
        }
    }
}
