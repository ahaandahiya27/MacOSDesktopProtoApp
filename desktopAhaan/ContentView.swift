import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var dataStore: DataStore
    @AppStorage(AppStorageKeys.hasSeenWelcome) private var hasSeenWelcome: Bool = false
    @State private var showShortcutsSheet = false
    @State private var showCommandPalette = false

    var body: some View {
        VStack(spacing: 0) {
            if let error = dataStore.lastSaveError {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .accessibilityHidden(true)
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
        .sheet(isPresented: Binding(get: { !hasSeenWelcome }, set: { if !$0 { hasSeenWelcome = true } })) {
            WelcomeSheet { hasSeenWelcome = true }
        }
        .sheet(isPresented: $showShortcutsSheet) {
            KeyboardShortcutsSheet { showShortcutsSheet = false }
        }
        .sheet(isPresented: $showCommandPalette) {
            CommandPalette { showCommandPalette = false }
                .environmentObject(subjectRegistry)
                .environmentObject(appState)
                .environmentObject(dataStore)
        }
        .background(
            // Invisible buttons hosting global keyboard shortcuts.
            // Gated on `noOtherSheetOpen` so triggering ⌘K or ⌘/ while the
            // welcome sheet (or another sheet) is up is a no-op rather than
            // a sheet-stacking glitch.
            ZStack {
                Button("Show keyboard shortcuts") {
                    if noOtherSheetOpen { showShortcutsSheet = true }
                }
                .keyboardShortcut("/", modifiers: .command)

                Button("Open command palette") {
                    if noOtherSheetOpen { showCommandPalette = true }
                }
                .keyboardShortcut("k", modifiers: .command)
            }
            .opacity(0)
            .frame(width: 0, height: 0)
            .accessibilityHidden(true)
        )
        // The Help → "desktopAhaan Help" menu item posts this notification.
        // We point it at the keyboard-shortcuts sheet for now — that's the
        // most useful in-app help we have today (shortcuts + a brief
        // overview header).
        .onReceive(NotificationCenter.default.publisher(for: .openInAppHelp)) { _ in
            if noOtherSheetOpen { showShortcutsSheet = true }
        }
    }

    private var noOtherSheetOpen: Bool {
        hasSeenWelcome && !showShortcutsSheet && !showCommandPalette
    }

    /// Count questions in a pack that the parent still needs to triage.
    /// `effectiveNeedsReview` honors the in-app "Mark reviewed" override, so
    /// the badge decrements as the parent works through the list.
    private func needsReviewCount(for pack: SubjectPack) -> Int {
        pack.chapters.reduce(0) { chCount, ch in
            chCount + ch.topics.reduce(0) { tCount, t in
                tCount + t.questions.reduce(0) { qCount, q in
                    qCount + (dataStore.effectiveNeedsReview(q) ? 1 : 0)
                }
            }
        }
    }

    /// Sidebar section header with a small "Clear" button on the right.
    private var recentHeader: some View {
        HStack {
            Text("Recent")
            Spacer()
            Button("Clear") { appState.clearRecents() }
                .buttonStyle(.plain)
                .pointingCursor()
                .font(.caption.weight(.semibold))
                .foregroundColor(Color.compatIndigo)
                .help("Clear recent items")
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
                                HStack(spacing: 6) {
                                    Text(pack.title).font(.body)
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                    Spacer(minLength: 0)
                                    let n = needsReviewCount(for: pack)
                                    if n > 0 {
                                        Text("\(n)")
                                            .font(.caption2.weight(.semibold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 1)
                                            .background(Capsule().fill(Color.orange))
                                            .accessibilityLabel("\(n) questions need review")
                                            .help("\(n) questions need review")
                                    }
                                }
                                Text("\(pack.conceptCount) concepts · \(pack.questionCount) questions")
                                    .font(.caption)
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
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } icon: {
                    Image(systemName: SFSymbolCompat.name("list.bullet.clipboard.fill"))
                }
                .tag(SidebarSelection.quizBank)
            }

            if !appState.recentItems.isEmpty {
                Section(header: recentHeader) {
                    ForEach(appState.recentItems) { item in
                        Button {
                            appState.openRecent(item)
                        } label: {
                            Label {
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(item.title)
                                        .font(.body)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Text(item.subtitle)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            } icon: {
                                Image(systemName: item.systemImage)
                            }
                        }
                        .buttonStyle(.plain)
                        .pointingCursor()
                        .help("Jump to \(item.title)")
                    }
                }
            }

            Section(header: Text("Tools")) {
                ForEach(SidebarTool.allCases) { tool in
                    HStack {
                        Label(tool.title, systemImage: tool.systemImage)
                        Spacer(minLength: 6)
                        if let shortcut = tool.keyboardShortcut {
                            Text(shortcut)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                                .accessibilityHidden(true)
                        }
                    }
                    .tag(SidebarSelection.tool(tool))
                }
            }
        }
        .frame(minWidth: 220, idealWidth: 260, maxWidth: 320)
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
                        .accessibilityHidden(true)
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
        case .tool(.discover):
            DiscoverProgressDashboard()
        case .tool(.settings):
            SettingsScreen()
        }
    }
}

/// One-time welcome sheet shown on first launch. Dismissed via the
/// `hasSeenWelcome` AppStorage flag, so it never reappears for the same user.
private struct WelcomeSheet: View {
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Text("\u{1F44B}")
                .font(.system(size: 56))
            Text("Welcome to Sanskrit Kosh")
                .font(.title.bold())
            Text("Pick a subject from the sidebar on the left to start. Use the Sanskrit translator, browse the Science tutor's chapters and topics, or jump into Discover Mode for interactive scenes.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .lineSpacing(4)
                .padding(.horizontal, 8)
            Button(action: onDismiss) {
                Text("Let's go")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.bordered)
            .accentColor(Color.compatIndigo)
            .keyboardShortcut(.defaultAction)
        }
        .padding(28)
        .frame(minWidth: 420, idealWidth: 480, maxWidth: 560,
               minHeight: 340, idealHeight: 380)
        // Invisible Esc handler so the welcome sheet also responds to Esc
        // (the "Let's go" button owns .defaultAction for ⏎; a Button can
        // only carry one keyboardShortcut so we attach .cancelAction here).
        .background(
            Button("Dismiss", action: onDismiss)
                .keyboardShortcut(.cancelAction)
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        )
    }
}
