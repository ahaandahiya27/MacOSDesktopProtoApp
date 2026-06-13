import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var dataStore: DataStore
    @AppStorage(AppStorageKeys.hasSeenWelcomeTour) private var hasSeenWelcomeTour: Bool = false
    @AppStorage(AppStorageKeys.hasSeenAllChaptersCelebration) private var hasSeenAllChaptersCelebration: Bool = false
    @AppStorage(AppStorageKeys.whatsNewLastSeenVersion) private var whatsNewLastSeenVersion: String = ""
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
        case welcomeTour, whatsNew, shortcuts, commandPalette
        case aboutDeepDive, aboutAudio, aboutDailyPractice
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
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .accessibilityHidden(true)
                    Text(error)
                        .font(.caption)
                    Spacer()
                    Button("Dismiss") { dataStore.lastSaveError = nil }
                        .font(.caption)
                        .accessibilityIdentifier("content-dismiss-save-error")
                }
                .padding(DesignTokens.Spacing.sm)
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
            case .welcomeTour:
                WelcomeTourSheet {
                    hasSeenWelcomeTour = true
                    presentedSheet = nil
                    // After dismissing the welcome tour, also persist
                    // the current app version as the last-seen What's
                    // New version so a brand-new install doesn't see
                    // both the tour and the release notes back-to-back.
                    whatsNewLastSeenVersion = WhatsNewSheet.currentVersion
                }
            case .whatsNew:
                WhatsNewSheet {
                    whatsNewLastSeenVersion = WhatsNewSheet.currentVersion
                    presentedSheet = nil
                }
            case .shortcuts:
                KeyboardShortcutsSheet { presentedSheet = nil }
            case .commandPalette:
                CommandPalette { presentedSheet = nil }
                    .environmentObject(subjectRegistry)
                    .environmentObject(appState)
                    .environmentObject(dataStore)
            case .aboutDeepDive:
                FeatureExplainerSheet.aboutDeepDive { presentedSheet = nil }
            case .aboutAudio:
                FeatureExplainerSheet.aboutAudio { presentedSheet = nil }
            case .aboutDailyPractice:
                FeatureExplainerSheet.aboutDailyPractice { presentedSheet = nil }
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
                .accessibilityIdentifier("content-shortcut-show-keyboard-shortcuts")

                Button("Open command palette") {
                    if noOtherSheetOpen { presentedSheet = .commandPalette }
                }
                .keyboardShortcut("k", modifiers: .command)
                .accessibilityIdentifier("content-shortcut-open-command-palette")
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
        // Help → Show Welcome Tour
        .onReceive(NotificationCenter.default.publisher(for: .showWelcomeTour)) { _ in
            if presentedSheet == nil { presentedSheet = .welcomeTour }
        }
        // Help → What's New
        .onReceive(NotificationCenter.default.publisher(for: .showWhatsNew)) { _ in
            if presentedSheet == nil { presentedSheet = .whatsNew }
        }
        // Help → About Deep Dive Mode
        .onReceive(NotificationCenter.default.publisher(for: .showAboutDeepDive)) { _ in
            if presentedSheet == nil { presentedSheet = .aboutDeepDive }
        }
        // Help → About Audio Narration
        .onReceive(NotificationCenter.default.publisher(for: .showAboutAudio)) { _ in
            if presentedSheet == nil { presentedSheet = .aboutAudio }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showAboutDailyPractice)) { _ in
            if presentedSheet == nil { presentedSheet = .aboutDailyPractice }
        }
        .onAppear {
            // First-launch auto-present: show the welcome tour. Then,
            // once the kid has seen it, on later version bumps surface
            // What's New. Two-step gate keeps a brand-new install from
            // seeing both back-to-back (the tour callback advances the
            // What's New cursor to current version).
            if presentedSheet != nil { return }
            if !hasSeenWelcomeTour {
                presentedSheet = .welcomeTour
            } else if whatsNewLastSeenVersion != WhatsNewSheet.currentVersion {
                presentedSheet = .whatsNew
            }
        }
    }

    private var noOtherSheetOpen: Bool {
        hasSeenWelcomeTour && presentedSheet == nil
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
                .accessibilityHint("Removes all items from the Recent list")
                .accessibilityIdentifier("sidebar-recent-clear")
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
        .accessibilityHint("Reopens this recent item in the detail pane")
        .accessibilityIdentifier("sidebar-recent-row-\(item.id)")
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
                    HStack(spacing: DesignTokens.Spacing.sm) {
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
                        // Due-count badge on the Daily Practice row.
                        // Updates whenever dataStore.questionReviews
                        // mutates because dueQuestionCount(at:) reads
                        // the published map. Capped visually at 99+
                        // to avoid a wide sidebar column on a long
                        // back-from-vacation day.
                        if tool == .dailyPractice {
                            let due = dataStore.dueQuestionCount()
                            if due > 0 {
                                BadgePill(
                                    count: min(due, 99),
                                    tint: .orange,
                                    accessibilityText: "\(due) question\(due == 1 ? "" : "s") due for review"
                                )
                            }
                        }
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
                VStack(spacing: DesignTokens.Spacing.md) {
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
                    .accessibilityHint("Reloads the subject pack from disk")
                    .accessibilityIdentifier("content-subject-not-loaded-retry")
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
        case .tool(.mastery):
            MasteryDashboard()
        case .tool(.discover):
            DiscoverProgressDashboard()
        case .tool(.olympiad):
            NavigationView {
                OlympiadHubView()
            }
        case .tool(.settings):
            SettingsScreen()
        }
    }
}

// MARK: - WelcomeSheet retired 2026-05-23
//
// The single-panel WelcomeSheet was replaced by the 3-panel
// `WelcomeTourSheet` (Subjects/Tutor/WelcomeTourSheet.swift), which
// also points the kid at the Discover Mode banner, the Go Deeper
// disclosure, and the article read-aloud feature. The
// `hasSeenWelcome` AppStorage key is retained in AppStorageKeys.swift
// for backwards compatibility with existing user defaults but is no
// longer consumed by any view — the new gate is `hasSeenWelcomeTour`.
//
// The "welcome-lets-go" accessibility identifier the locking
// XCUITest (`Crash1_TryDiscoverMode_Ch1.dismissWelcomeIfNeeded`) keys
// on now lives on WelcomeTourSheet's primary button under
// `welcome-tour-primary` — the test's `dismissWelcomeIfNeeded` helper
// uses `.waitForExistence(timeout: 2)` so a missing identifier still
// no-ops cleanly; iMac sessions running the locking test should
// update that helper to look for `welcome-tour-primary` instead.

// MARK: - Daily Practice (Option B of the 2026-05-19 audit sweep)
