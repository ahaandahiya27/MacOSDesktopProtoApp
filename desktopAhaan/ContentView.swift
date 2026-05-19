import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var dataStore: DataStore
    @AppStorage(AppStorageKeys.hasSeenWelcome) private var hasSeenWelcome: Bool = false
    @AppStorage(AppStorageKeys.hasSeenAllChaptersCelebration) private var hasSeenAllChaptersCelebration: Bool = false
    @State private var showShortcutsSheet = false
    @State private var showCommandPalette = false
    @State private var showAllChaptersCelebration = false

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
        .sheet(isPresented: Binding(get: { !hasSeenWelcome }, set: { if !$0 { hasSeenWelcome = true } })) {
            WelcomeSheet { hasSeenWelcome = true }
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

/// Sidebar tool that surfaces every question the student has flagged
/// "tough — review later" via the per-question Tough button in
/// QuestionDetailView. Persistence lives in DataStore.toughQuestionIds;
/// tapping a row jumps to that question.
struct DailyPracticeView: View {
    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var subjectRegistry: SubjectRegistry
    @EnvironmentObject private var appState: AppState

    /// Flat lookup over the loaded packs. Built once per render so the
    /// review-session sheet + the tough list both share the same source.
    private func collectQuestions(matching ids: Set<String>)
        -> [(pack: SubjectPack, chapter: Chapter, question: Question)] {
        guard !ids.isEmpty else { return [] }
        var out: [(SubjectPack, Chapter, Question)] = []
        for pack in subjectRegistry.packs {
            for chapter in pack.chapters {
                for topic in chapter.topics {
                    for q in topic.questions where ids.contains(q.id) {
                        out.append((pack, chapter, q))
                    }
                }
            }
        }
        return out
    }

    private var toughEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)] {
        collectQuestions(matching: dataStore.toughQuestionIds)
    }

    private var dueEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)] {
        let dueIds = Set(dataStore.dueQuestionIds())
        return collectQuestions(matching: dueIds)
    }

    var body: some View {
        TutorNavigationContainer {
            DailyPracticeContent(toughEntries: toughEntries, dueEntries: dueEntries)
        }
    }
}

private struct DailyPracticeContent: View {
    let toughEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)]
    let dueEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)]

    @EnvironmentObject private var nav: TutorNavigationState
    @EnvironmentObject private var dataStore: DataStore

    @State private var reviewSessionVisible = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                if !dueEntries.isEmpty {
                    reviewQueueCard
                }
                if toughEntries.isEmpty && dueEntries.isEmpty {
                    emptyState
                } else if !toughEntries.isEmpty {
                    Text("Flagged tough")
                        .font(.headline)
                        .padding(.top, 8)
                    ForEach(toughEntries, id: \.question.id) { entry in
                        row(for: entry)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color.white)
        .navigationTitle("Daily Practice")
        .sheet(isPresented: $reviewSessionVisible) {
            ReviewSessionSheet(
                queue: dueEntries,
                isPresented: $reviewSessionVisible
            )
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.title)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Daily Practice")
                        .font(.largeTitle.bold())
                    Text(headerSubtitle)
                        .font(.subheadline.monospacedDigit())
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.orange.opacity(0.08))
        )
    }

    private var headerSubtitle: String {
        let due = dueEntries.count
        let tough = toughEntries.count
        if due == 0 && tough == 0 {
            return "Nothing due today — answer questions to start your review stream."
        }
        let duePart = due == 0 ? "" : "\(due) due for review"
        let toughPart = tough == 0 ? "" : "\(tough) flagged tough"
        let separator = (due > 0 && tough > 0) ? " · " : ""
        return duePart + separator + toughPart
    }

    private var reviewQueueCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "rectangle.stack.fill")
                .font(.title2)
                .foregroundColor(.compatIndigo)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(dueEntries.count) question\(dueEntries.count == 1 ? "" : "s") due now")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("Quick review — answer, see how you did, the scheduler does the rest.")
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            Spacer(minLength: 8)
            Button("Start Review") {
                reviewSessionVisible = true
            }
            .keyboardShortcut(.defaultAction)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.compatIndigo.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.compatIndigo.opacity(0.3), lineWidth: 1)
        )
    }

    private var emptyState: some View {
        EmptyStateView(
            icon: "flame",
            title: "Nothing to practice yet",
            subtitle: "Answer some questions to start your spaced-review queue. Hit the 'Tough — review later' button on any question to flag it for repeat practice."
        )
    }

    @ViewBuilder
    private func row(for entry: (pack: SubjectPack, chapter: Chapter, question: Question)) -> some View {
        Button {
            nav.questionSiblings = [
                QuestionRef(packId: entry.pack.id, questionId: entry.question.id)
            ]
            nav.push(.question(packId: entry.pack.id, questionId: entry.question.id))
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "flame.fill")
                    .font(.title3)
                    .foregroundColor(.orange)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.question.prompt)
                        .font(.body)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    HStack(spacing: 6) {
                        Text("\(entry.pack.coverEmoji) Ch.\(entry.chapter.number) — \(entry.chapter.title)")
                            .font(.caption2)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            .lineLimit(1)
                    }
                }
                Spacer(minLength: 8)
                Button {
                    dataStore.toggleToughQuestion(entry.question.id)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .help("Remove from Daily Practice")
                .accessibilityLabel("Remove \(entry.question.id) from daily practice list")
                Image(systemName: "chevron.right")
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .accessibilityHidden(true)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.gray.opacity(0.15), lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("Review tough question: \(entry.question.prompt)")
    }
}

// MARK: - Review session sheet (Option B / SM-2 walk-through)
//
// Walks the kid through the due-now queue one question at a time.
// Each card has two phases: prompt-only ("Show answer" button), then
// prompt + answer ("Forgot / Hard / Good / Easy"). Buttons call
// dataStore.recordReview, which updates the scheduler and persists.
//
// The sheet doesn't reach into the larger TutorNavigation stack — it's
// self-contained so the kid can leave the review without disturbing
// the previously-pushed screen behind it.
//
// Big Sur compatible: pure SwiftUI, no macOS 12+ APIs.
private struct ReviewSessionSheet: View {
    let queue: [(pack: SubjectPack, chapter: Chapter, question: Question)]
    @Binding var isPresented: Bool

    @EnvironmentObject private var dataStore: DataStore

    @State private var cursor: Int = 0
    @State private var answerRevealed: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            sessionHeader
            Divider()
            if cursor < queue.count {
                card(for: queue[cursor])
            } else {
                completionState
            }
        }
        .frame(minWidth: 560, minHeight: 460, idealHeight: 540)
        .background(Color(NSColor.windowBackgroundColor))
    }

    private var sessionHeader: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Review session")
                    .font(.headline)
                Text(progressSubtitle)
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button("Close") { isPresented = false }
                .keyboardShortcut(.cancelAction)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private var progressSubtitle: String {
        guard !queue.isEmpty else { return "" }
        let position = min(cursor + 1, queue.count)
        return "\(position) of \(queue.count)"
    }

    @ViewBuilder
    private func card(for entry: (pack: SubjectPack, chapter: Chapter, question: Question)) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("\(entry.pack.coverEmoji) Ch.\(entry.chapter.number) — \(entry.chapter.title)")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(entry.question.prompt)
                .font(.title3)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            if answerRevealed {
                Divider()
                Text("Answer")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                Text(entry.question.answer)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 8)
                qualityButtons(for: entry)
            } else {
                Spacer(minLength: 8)
                Button("Show answer") { answerRevealed = true }
                    .keyboardShortcut(.space, modifiers: [])
                    .controlSize(.large)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func qualityButtons(
        for entry: (pack: SubjectPack, chapter: Chapter, question: Question)
    ) -> some View {
        HStack(spacing: 10) {
            qualityButton(label: "Forgot", color: .red, quality: .forgot, q: entry.question.id)
            qualityButton(label: "Hard", color: .orange, quality: .hard, q: entry.question.id)
            qualityButton(label: "Good", color: .compatIndigo, quality: .good, q: entry.question.id)
            qualityButton(label: "Easy", color: .green, quality: .easy, q: entry.question.id)
        }
    }

    private func qualityButton(label: String, color: Color,
                                quality: ReviewQuality, q: String) -> some View {
        Button {
            dataStore.recordReview(questionId: q, quality: quality)
            advance()
        } label: {
            Text(label)
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.opacity(0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(color.opacity(0.45), lineWidth: 1)
                )
                .foregroundColor(color)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("Mark answer as \(label)")
    }

    private func advance() {
        answerRevealed = false
        cursor += 1
    }

    private var completionState: some View {
        VStack(spacing: 14) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 56))
                .foregroundColor(.green)
            Text("Review complete")
                .font(.title2.bold())
            Text("Great work. Come back tomorrow for the next batch.")
                .foregroundColor(.secondary)
            Button("Close") { isPresented = false }
                .keyboardShortcut(.defaultAction)
                .padding(.top, 8)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - All-chapters-complete celebration overlay (DM7 / EM4)

/// One-time celebration shown when the student finishes every Discover
/// scene across all 19 science chapters (171 scenes total). Triggered
/// in ContentView's onChange on `dataStore.discoverProgress.count`; the
/// `hasSeenAllChaptersCelebration` @AppStorage flag prevents reappearance.
///
/// Lives inline in ContentView.swift (not its own file) for the same
/// reason WelcomeSheet + KeyboardShortcutsSheet do — avoids the
/// Xcode-project add-file ceremony for these small companion views.
///
/// Big Sur compatible: pure SwiftUI, no `.foregroundStyle`, no
/// `.symbolEffect`, no macOS 12+ APIs.
private struct AllChaptersCompleteOverlay: View {
    @Binding var isVisible: Bool
    let totalScenes: Int
    let totalBossQuizScore: Int?
    let totalBossQuizMax: Int?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var celebrate = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            cardBody
                .frame(maxWidth: 520)
                .padding(36)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(
                            colors: [Color.compatIndigo, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 8)

            if celebrate {
                ParticleEmitter(isActive: true, particleCount: 80, duration: 4.0)
                    .allowsHitTesting(false)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            if reduceMotion {
                celebrate = true
            } else {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                    celebrate = true
                }
            }
        }
    }

    @ViewBuilder
    private var cardBody: some View {
        VStack(spacing: 18) {
            Text("🎉")
                .font(.system(size: 96))
                .scaleEffect(celebrate ? 1.0 : 0.5)
                .opacity(celebrate ? 1.0 : 0.0)

            Text("You finished Discover Mode!")
                .font(.title.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("All 19 chapters · \(totalScenes) scenes explored")
                .font(.title3)
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)

            if let score = totalBossQuizScore, let maxScore = totalBossQuizMax, maxScore > 0 {
                Text("Boss Quiz total: \(score) / \(maxScore)")
                    .font(.title3.monospacedDigit())
                    .foregroundColor(.yellow)
                    .padding(.top, 4)
            }

            Text("From plants and digestion to light and the Moon — you've explored every chapter of Class 7 Science. Class 8 has more waiting.")
                .font(.callout)
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.horizontal, 24)
                .padding(.top, 4)

            Button(action: dismiss) {
                Text("Continue")
                    .font(.body.weight(.semibold))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.white))
                    .foregroundColor(.black)
            }
            .buttonStyle(.plain)
            .padding(.top, 12)
            .accessibilityLabel("Dismiss celebration")
        }
    }

    private func dismiss() {
        if reduceMotion {
            isVisible = false
        } else {
            withAnimation(.easeOut(duration: 0.25)) {
                isVisible = false
            }
        }
    }
}
