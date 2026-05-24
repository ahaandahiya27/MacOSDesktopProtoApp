import SwiftUI

// Extracted from ContentView.swift 2026-05-22 (E1 split). Contains
// DailyPracticeView (sidebar tool) + ReviewSessionSheet + the
// DailyPracticeContent inner builder. All three are referenced only
// from ContentView and its sidebar/detailPane routing, so the move
// is behaviour-preserving.


/// Sidebar tool that surfaces every question the student has flagged
/// "tough — review later" via the per-question Tough button in
/// QuestionDetailView. Persistence lives in DataStore.toughQuestionIds;
/// tapping a row jumps to that question.
struct DailyPracticeView: View {
    @EnvironmentObject private var dataStore: DataStore
    @EnvironmentObject private var subjectRegistry: SubjectRegistry
    @EnvironmentObject private var appState: AppState

    /// Flat lookup over the loaded packs. O(ids.count) lookups against
    /// the precomputed SubjectRegistry.location(forQuestionId:) index —
    /// previously O(packs × chapters × topics × questions) = ~4400
    /// iterations per render across BOTH tough and due lists.
    private func collectQuestions(matching ids: Set<String>)
        -> [(pack: SubjectPack, chapter: Chapter, question: Question)] {
        guard !ids.isEmpty else { return [] }
        return ids.compactMap { subjectRegistry.location(forQuestionId: $0) }
    }

    private var toughEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)] {
        collectQuestions(matching: dataStore.toughQuestionIds)
    }

    private var dueEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)] {
        let dueIds = Set(dataStore.dueQuestionIds())
        return collectQuestions(matching: dueIds)
    }

    /// Ordered recently-missed entries. Order preserved from
    /// `recentlyMissedQuestionIds` (most-recent first) — that's why
    /// this isn't a Set / collectQuestions(matching:) routing.
    private var recentlyMissedEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)] {
        dataStore.recentlyMissedQuestionIds().compactMap {
            subjectRegistry.location(forQuestionId: $0)
        }
    }

    var body: some View {
        TutorNavigationContainer {
            DailyPracticeContent(
                toughEntries: toughEntries,
                dueEntries: dueEntries,
                recentlyMissedEntries: recentlyMissedEntries
            )
        }
    }
}

private struct DailyPracticeContent: View {
    let toughEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)]
    let dueEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)]
    /// Resolved recently-missed canonical questions (ephemerals are
    /// silently dropped — the subjectRegistry resolver returns nil
    /// for `bossquiz_*` ids). Order preserved most-recent-first.
    let recentlyMissedEntries: [(pack: SubjectPack, chapter: Chapter, question: Question)]

    @EnvironmentObject private var nav: TutorNavigationState
    @EnvironmentObject private var dataStore: DataStore

    @State private var reviewSessionVisible = false

    /// Persisted N-day review streak. Updated by DataStore.recordReview
    /// each time a question is rated; idempotent within a calendar day.
    @AppStorage(AppStorageKeys.reviewStreakDays) private var streakDays: Int = 0
    @AppStorage(AppStorageKeys.reviewStreakBest) private var streakBest: Int = 0
    @AppStorage(AppStorageKeys.reviewStreakLastDate) private var streakLastDate: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                if !dueEntries.isEmpty {
                    reviewQueueCard
                }
                if streakDays > 0 || streakBest > 0 {
                    streakHistoryCard
                }
                if toughEntries.isEmpty && dueEntries.isEmpty && recentlyMissedEntries.isEmpty {
                    emptyState
                } else {
                    if !recentlyMissedEntries.isEmpty {
                        Text("Recently missed")
                            .font(.headline)
                            .padding(.top, 8)
                        ForEach(recentlyMissedEntries, id: \.question.id) { entry in
                            row(for: entry)
                        }
                    }
                    if !toughEntries.isEmpty {
                        Text("Flagged tough")
                            .font(.headline)
                            .padding(.top, 8)
                        ForEach(toughEntries, id: \.question.id) { entry in
                            row(for: entry)
                        }
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
                Spacer(minLength: 0)
                if streakDays > 0 {
                    streakBadge
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.orange.opacity(0.08))
        )
    }

    /// "🔥 N-day streak" chip on the right of the header. Only shows once
    /// the kid has answered at least one question — a zero-streak chip
    /// reads as nagging and we don't ship that vibe.
    private var streakBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                .font(.callout)
            Text("\(streakDays)-day streak")
                .font(.callout.monospacedDigit().weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule().fill(Color.white)
        )
        .overlay(
            Capsule().strokeBorder(DesignTokens.BrandColor.tryAtHome.opacity(0.35), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Current streak: \(streakDays) day\(streakDays == 1 ? "" : "s")")
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

    /// Streak history strip — surfaces the all-time best alongside the
    /// current streak, plus a "last review" date readout so the kid
    /// can see when they last practised. Only renders when there's
    /// some streak history to show; suppressed entirely on day 0.
    private var streakHistoryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Label("Streak history", systemImage: "calendar")
                    .font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Spacer()
            }
            HStack(spacing: 18) {
                statBlock(value: "\(streakDays)", label: "Current",
                          color: DesignTokens.BrandColor.tryAtHome)
                statBlock(value: "\(streakBest)", label: "Best ever",
                          color: DesignTokens.BrandColor.primaryAction)
                statBlock(value: streakLastDate.isEmpty ? "—" : streakLastDate,
                          label: "Last review",
                          color: DesignTokens.BrandColor.canvasTextSecondary)
            }
            if streakDays == streakBest && streakBest > 1 {
                Text("🏆 You're on your best-ever streak — keep going!")
                    .font(.caption.italic())
                    .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
    }

    private func statBlock(value: String, label: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.title3.weight(.bold).monospacedDigit())
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
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
            // Skip card — bottom-right escape hatch. The kid hits this if
            // the prompt is confusing, a typo slipped in, or they want to
            // move past without scoring. Doesn't call recordReview so the
            // SM-2 scheduler is unaffected.
            HStack {
                Spacer()
                Button("Skip this card") { advance() }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .keyboardShortcut("s", modifiers: [])
                    .accessibilityLabel("Skip this card without scoring (press S)")
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func qualityButtons(
        for entry: (pack: SubjectPack, chapter: Chapter, question: Question)
    ) -> some View {
        // ⌘1-⌘4 shortcuts on each button so a 20-card session takes a
        // minute, not five. KeyEquivalent literals are macOS 10.15+ so
        // Big Sur compatible.
        HStack(spacing: 10) {
            qualityButton(label: "Forgot", color: .red, quality: .forgot,
                          q: entry.question.id, shortcut: "1")
            qualityButton(label: "Hard", color: .orange, quality: .hard,
                          q: entry.question.id, shortcut: "2")
            qualityButton(label: "Good", color: .compatIndigo, quality: .good,
                          q: entry.question.id, shortcut: "3")
            qualityButton(label: "Easy", color: .green, quality: .easy,
                          q: entry.question.id, shortcut: "4")
        }
    }

    private func qualityButton(label: String, color: Color,
                                quality: ReviewQuality, q: String,
                                shortcut: KeyEquivalent) -> some View {
        Button {
            dataStore.recordReview(questionId: q, quality: quality)
            advance()
        } label: {
            VStack(spacing: 2) {
                Text(label)
                    .font(.body.weight(.semibold))
                Text("⌘\(String(shortcut.character))")
                    .font(.caption2.monospacedDigit())
                    .foregroundColor(color.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
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
        .keyboardShortcut(shortcut, modifiers: .command)
        .accessibilityLabel("Mark answer as \(label) (⌘\(String(shortcut.character)))")
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