import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        VStack(spacing: 0) {
            if let error = dataStore.lastSaveError {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text(error)
                        .font(.caption)
                    Spacer()
                    Button("Dismiss") { dataStore.lastSaveError = nil }
                        .font(.caption)
                }
                .padding(8)
                .background(Color.orange.opacity(0.1))
            }
            NavigationView {
                sidebar
                    .navigationTitle("Sanskrit Kosh")
                detailPane
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }

    // MARK: - Sidebar

    private var sidebar: some View {
        List(selection: Binding(
            get: { appState.sidebarSelection },
            set: { newValue in
                DispatchQueue.main.async {
                    appState.sidebarSelection = newValue ?? .subject("sanskrit_class7")
                }
            }
        )) {
            Section(header: Text("Subjects")) {
                if subjectRegistry.isLoading {
                    HStack(spacing: 8) {
                        ProgressView().controlSize(.small)
                        Text("Loading subjects…")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else if subjectRegistry.packs.isEmpty {
                    Text("No subjects loaded")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(subjectRegistry.packs) { pack in
                        Label {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(pack.title).font(.body)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                Text("\(pack.conceptCount) concepts · \(pack.questionCount) questions")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Text(pack.coverEmoji)
                        }
                        .tag(SidebarSelection.subject(pack.id))
                    }
                }
            }

            Section(header: Text("Quiz Bank")) {
                Label {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Practice Questions").font(.body)
                        Text("\(subjectRegistry.packs.reduce(0) { $0 + $1.questionCount }) questions across all chapters")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                } icon: {
                    Image(systemName: "list.bullet.clipboard.fill")
                }
                .tag(SidebarSelection.quizBank)
            }

            Section(header: Text("Tools")) {
                ForEach(SidebarTool.allCases) { tool in
                    Label(tool.title, systemImage: tool.systemImage)
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
                VStack(spacing: 12) {
                    Image(systemName: "books.vertical")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("Subject not loaded")
                        .font(.title2.weight(.semibold))
                    Text("This subject couldn't be loaded. Please restart the app.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task { await subjectRegistry.reload() }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
