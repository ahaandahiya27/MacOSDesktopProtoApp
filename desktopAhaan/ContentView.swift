import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var dataStore: DataStore
    @AppStorage(AppStorageKeys.hasSeenWelcome) private var hasSeenWelcome: Bool = false
    @AppStorage(AppStorageKeys.hasSeenAllChaptersCelebration) private var hasSeenAllChaptersCelebration: Bool = false
    @State private var showAllChaptersCelebration = false

    /// Single source of truth for which sheet is on screen. Big Sur
    /// SwiftUI silently no-ops all but the LAST `.sheet(isPresented:)`
    /// modifier on a given view chain — so chaining `welcome + shortcuts
    /// + commandPalette` left the welcome sheet silently broken AND
    /// destabilised child sheet lifecycles (Try-at-Home dismiss was
    /// landing in objc_release with EXC_BAD_ACCESS, same crash class
    /// we fixed in ChapterDetailView commit 21f3d11). One `.sheet(item:)`
    /// keyed on an Identifiable enum is the canonical Big Sur fix.
    @State private var presentedSheet: ContentSheet?
    private enum ContentSheet: String, Identifiable {
        case welcome, shortcuts, commandPalette
        var id: String { rawValue }
    }

    /// Sum of every Boss Quiz score the student has earned across the 19
    /// chapters' Scene 9. nil-out when no Boss Quizzes have been completed
    /// (avoids showing "0/0" in the celebration overlay).
    private var bossQuizTotalScore: Int? {
        let rows = dataStore.discoverProgress.filter { $0.sceneId == "scene9" && $0.score != nil }
        guard !rows.isEmpty else { return nil }
        return rows.reduce(0) { $0 + ($1.score ?? 0) }
    }

    private var bossQuizTotalMax: Int? {
        let rows = dataStore.discoverProgress.filter { $0.sceneId == "scene9" && $0.maxScore != nil }
        guard !rows.isEmpty else { return nil }
        return rows.reduce(0) { $0 + ($1.maxScore ?? 0) }
    }

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
        .overlay(
            // All-19-chapters-complete celebration (DM7/EM4). Fires once
            // when the student finishes the 171st scene and hasn't seen
            // this overlay before. Setting hasSeenAllChaptersCelebration
            // in onDisappear ensures it's persisted only after the user
            // explicitly dismisses (or the overlay closes itself).
            Group {
                if showAllChaptersCelebration {
                    AllChaptersCompleteOverlay(
                        isVisible: $showAllChaptersCelebration,
                        totalScenes: DataStore.totalDiscoverScenes,
                        totalBossQuizScore: bossQuizTotalScore,
                        totalBossQuizMax: bossQuizTotalMax
                    )
                    .transition(.opacity)
                }
            }
        )
        .onChange(of: dataStore.discoverProgress.count) { _ in
            if dataStore.allDiscoverChaptersComplete && !hasSeenAllChaptersCelebration {
                showAllChaptersCelebration = true
            }
        }
        .onChange(of: showAllChaptersCelebration) { newValue in
            // Persist the dismissal flag once the overlay closes — both
            // for explicit user dismiss AND for any programmatic close.
            if newValue == false && dataStore.allDiscoverChaptersComplete {
                hasSeenAllChaptersCelebration = true
            }
        }
        .sheet(item: $presentedSheet) { kind in
            switch kind {
            case .welcome:
                WelcomeSheet {
                    hasSeenWelcome = true
                    presentedSheet = nil
                }
            case .shortcuts:
                KeyboardShortcutsSheet { presentedSheet = nil }
            case .commandPalette:
                CommandPalette { presentedSheet = nil }
                    .environmentObject(subjectRegistry)
                    .environmentObject(appState)
                    .environmentObject(dataStore)
            }
        }
        .background(
            // Invisible buttons hosting global keyboard shortcuts.
            // Gated on `noOtherSheetOpen` so triggering ⌘K or ⌘/ while the
            // welcome sheet (or another sheet) is up is a no-op rather than
            // a sheet-stacking glitch.
            ZStack {
                Button("Show keyboard shortcuts") {
                    if noOtherSheetOpen { presentedSheet = .shortcuts }
                }
                .keyboardShortcut("/", modifiers: .command)

                Button("Open command palette") {
                    if noOtherSheetOpen { presentedSheet = .commandPalette }
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
            if noOtherSheetOpen { presentedSheet = .shortcuts }
        }
        .onAppear {
            // Drive the welcome sheet through the same single-sheet
            // dispatcher rather than a stacked .sheet(isPresented:) with
            // a synthetic Binding. Only fires once per install (gated by
            // the @AppStorage flag) and only if no other sheet is up.
            if !hasSeenWelcome && presentedSheet == nil {
                presentedSheet = .welcome
            }
        }
    }

    private var noOtherSheetOpen: Bool {
        hasSeenWelcome && presentedSheet == nil
    }

    /// Count questions in a pack that the parent still needs to triage.
    /// `effectiveNeedsReview` honors the in-app "Mark reviewed" override, so
    /// the badge decrements as the parent works through the list.
    /// Pack's "needs review" count using the cached `needsHumanReviewIds`
    /// set. Replaces the previous chapter→topic→question walk that did
    /// ~640 `effectiveNeedsReview()` calls per render, per pack (the
    /// sidebar re-rendered on every dataStore publish).
    ///
    /// `pack.needsHumanReviewIds` is process-cached by pack.id. The
    /// `subtracting` op is O(|needsHumanReviewIds|) which is far smaller
    /// than total question count.
    private func needsReviewCount(for pack: SubjectPack) -> Int {
        pack.needsHumanReviewIds.subtracting(dataStore.reviewedQuestionIds).count
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

    /// Per-kind subgroup label inside the Recent section ("Concepts" /
    /// "Questions"). Same `.uppercase + .caption2.weight(.semibold)`
    /// treatment used by macOS sidebars for tertiary group labels.
    /// Marked `.accessibilityHidden` because the screen-reader already
    /// announces each row's kind via its icon + title.
    @ViewBuilder
    private func recentGroupHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption2.weight(.semibold))
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .listRowBackground(Color.clear)
            .accessibilityHidden(true)
    }

    /// One Recent-item row. Extracted from the inline `ForEach` so the
    /// two type-grouped iterations share rendering.
    @ViewBuilder
    private func recentRow(_ item: RecentItem) -> some View {
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
                                        BadgePill(count: n, accessibilityText: "\(n) questions need review")
                                    }
                                }
                                Text("\(pack.conceptCount) concepts · \(pack.questionCount) questions")
                                    .font(.caption.monospacedDigit())
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Text(pack.coverEmoji)
                        }
                        .tag(SidebarSelection.subject(pack.id))
                        .help(pack.title)
                        .accessibilityIdentifier("subject-row-\(pack.id)")
                    }
                }
            }

            Section(header: Text("Quiz Bank")) {
                Label {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Practice Questions").font(.body)
                        Text("\(subjectRegistry.packs.reduce(0) { $0 + $1.questionCount }) questions across all chapters")
                            .font(.caption.monospacedDigit())
                            .foregroundColor(.secondary)
                    }
                } icon: {
                    Image(systemName: SFSymbolCompat.name("list.bullet.clipboard.fill"))
                }
                .tag(SidebarSelection.quizBank)
            }

            if !appState.recentItems.isEmpty {
                Section(header: recentHeader) {
                    let recentConcepts = appState.recentItems.filter { $0.kind == .concept }
                    let recentQuestions = appState.recentItems.filter { $0.kind == .question }
                    if !recentConcepts.isEmpty {
                        recentGroupHeader("Concepts")
                        ForEach(recentConcepts) { item in recentRow(item) }
                    }
                    if !recentQuestions.isEmpty {
                        recentGroupHeader("Questions")
                        ForEach(recentQuestions) { item in recentRow(item) }
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
        case .tool(.dailyPractice):
            DailyPracticeView()
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
            .accessibilityIdentifier("welcome-lets-go")
            .accessibilityLabel("Let's go")
            .accessibilityHint("Dismisses the welcome screen. You can replay it from Settings if you want it back.")
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

// MARK: - Daily Practice (Option B of the 2026-05-19 audit sweep)
