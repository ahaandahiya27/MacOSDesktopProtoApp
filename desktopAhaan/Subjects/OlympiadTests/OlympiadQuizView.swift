import SwiftUI

// MARK: - OlympiadQuizView
//
// Approach B: in-app 60-MCQ quiz. Single-question-per-screen flow:
//   1. Header strip — paper title + question N of M + score-preview.
//   2. Question stem + 4 radio-style options.
//   3. Footer — Previous / Next, Mark for Review, Submit Paper.
//
// State is per-session (not persisted across launches — a future
// commit can add resume-attempt). Submit hands off to
// OlympiadQuizResultView which computes +4/−1/0 marking and shows the
// full breakdown.
//
// Big Sur safety: pure SwiftUI, no Charts, no .scrollPosition,
// keyboard shortcuts use macOS-11 baseline. Animations gated through
// `withAnimationRespectingReduceMotion` (chrome convention).

@MainActor
struct OlympiadQuizView: View {
    let paper: OlympiadPaper

    /// MCQs parsed once on appear. Empty → render placeholder.
    @State private var questions: [OlympiadQuestion] = []
    /// Per-question selected option index ("A"/"B"/"C"/"D" letter or
    /// nil = unattempted).
    @State private var selectedByQuestionId: [String: String] = [:]
    /// Per-question "I'll come back to this" mark.
    @State private var markedForReview: Set<String> = []
    /// Current index into `questions`.
    @State private var currentIndex: Int = 0
    /// Once true, the result view is presented modally.
    @State private var showingResult: Bool = false
    /// First-paint hydration error.
    @State private var hydrateError: String? = nil
    /// Wall-clock time the kid first opened this paper. Persisted in
    /// the in-progress record so a quit-and-resume continues the same
    /// countdown rather than refilling the 90 minutes.
    @State private var startedAt: Date? = nil
    /// Seconds remaining on the countdown. Re-evaluated on every
    /// ticker tick (1 Hz). When it hits 0, the result sheet is
    /// auto-presented and the in-progress record cleared.
    @State private var secondsRemaining: Int = 0
    /// Set to true when the kid asks to close mid-quiz with answers
    /// already on the paper. Triggers the exit-confirm sheet.
    @State private var showingExitConfirm: Bool = false
    /// Set to true when the ticker decides the clock just ran out
    /// (≤0). Triggers the auto-submit + a one-line "time's up" banner
    /// the kid sees while the result sheet animates in.
    @State private var timeUpBanner: Bool = false
    /// Ticker task — cancelled on disappear so it doesn't leak past
    /// the view's lifetime.
    @State private var tickerTask: Task<Void, Never>? = nil

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            header
            if timeUpBanner {
                timeUpRibbon
            }
            Divider()
            if questions.isEmpty {
                emptyState
            } else {
                quizBody
            }
            Divider()
            footer
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Quiz — \(paper.chapterTitle)")
        .onAppear { hydrateIfNeeded() }
        .onDisappear {
            tickerTask?.cancel()
            tickerTask = nil
        }
        .background(keyboardShortcutCatchers)
        .sheet(isPresented: $showingResult) {
            OlympiadQuizResultView(
                paper: paper,
                questions: questions,
                selectedByQuestionId: selectedByQuestionId
            )
            .frame(minWidth: 720, minHeight: 540)
            .onDisappear {
                // Submission is final — clear the in-progress record so
                // the hub stops showing Resume. The completed attempt
                // is already in the history store (recorded by
                // OlympiadQuizResultView.recordAttemptOnce).
                DataStore.shared.clearOlympiadInProgress(forPaperId: paper.id)
                // Dismiss back to the hub one runloop tick later —
                // direct dismiss inside a sheet.onDisappear is the
                // Big-Sur entangling-fence class.
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .sheet(isPresented: $showingExitConfirm) {
            exitConfirmSheet
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(paper.subjectName) — Chapter \(paper.chapterNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(paper.chapterTitle)
                    .font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            Spacer()
            countdownBadge
            VStack(alignment: .trailing, spacing: 2) {
                let attempted = selectedByQuestionId.count
                let marked = markedForReview.count
                Text("Attempted \(attempted) / \(paper.questionCount)")
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
                if marked > 0 {
                    Text("\(marked) marked for review")
                        .font(.caption.monospacedDigit())
                        .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(Color(NSColor.controlBackgroundColor))
    }

    /// mm:ss countdown badge. Goes orange under 10 min, red under
    /// 1 min. Hidden if startedAt is nil (questions haven't hydrated
    /// yet).
    @ViewBuilder
    private var countdownBadge: some View {
        if startedAt != nil {
            let mins = max(0, secondsRemaining) / 60
            let secs = max(0, secondsRemaining) % 60
            let tint: Color = {
                if secondsRemaining <= 60 { return .red }
                if secondsRemaining <= 600 { return .orange }
                return DesignTokens.BrandColor.primaryAction
            }()
            HStack(spacing: 5) {
                Image(systemName: SFSymbolCompat.name("timer"))
                    .font(.caption.weight(.semibold))
                Text(String(format: "%d:%02d", mins, secs))
                    .font(.callout.weight(.semibold).monospacedDigit())
            }
            .foregroundColor(tint)
            .padding(.horizontal, 10).padding(.vertical, 4)
            .background(Capsule().fill(tint.opacity(0.12)))
            .accessibilityLabel("Time remaining: \(mins) minutes, \(secs) seconds")
        }
    }

    /// One-line banner shown when the clock hits zero, between header
    /// and divider. The result sheet pushes immediately after — this
    /// is just a "what happened" cue for the kid so it doesn't feel
    /// like the app jumped randomly to results.
    private var timeUpRibbon: some View {
        HStack(spacing: 8) {
            Image(systemName: SFSymbolCompat.name("clock.badge.exclamationmark"))
                .foregroundColor(.red)
            Text("Time's up — submitting paper.")
                .font(.callout.weight(.semibold))
                .foregroundColor(.red)
            Spacer()
        }
        .padding(.horizontal, 18).padding(.vertical, 8)
        .background(Color.red.opacity(0.08))
    }

    /// Confirmation sheet shown when the kid tries to close mid-quiz
    /// with at least one answer on the paper. Resume keeps the
    /// in-progress record alive; Discard clears it.
    private var exitConfirmSheet: some View {
        VStack(spacing: 16) {
            Image(systemName: SFSymbolCompat.name("exclamationmark.triangle.fill"))
                .font(.system(size: 36))
                .foregroundColor(.orange)
            Text("Leave this quiz?")
                .font(.title3.weight(.semibold))
            Text("You have \(selectedByQuestionId.count) answer\(selectedByQuestionId.count == 1 ? "" : "s") on this paper. Your progress is saved — you can resume from the hub.")
                .font(.callout)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 12) {
                Button("Discard Quiz") {
                    showingExitConfirm = false
                    DataStore.shared.clearOlympiadInProgress(forPaperId: paper.id)
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .keyboardShortcut("d", modifiers: [])
                Spacer()
                Button("Keep Working") {
                    showingExitConfirm = false
                }
                .keyboardShortcut(.cancelAction)
                Button("Save & Exit") {
                    showingExitConfirm = false
                    // The in-progress record was already saved by the
                    // most recent state change; nothing further to
                    // persist. Just dismiss.
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(28)
        .frame(width: 420)
    }

    /// Invisible buttons that capture digit + close shortcuts. SwiftUI
    /// can't attach `.keyboardShortcut` to a bare View — it must be a
    /// Button. We layer four (one per option letter) behind the visible
    /// content via `.background(...)` so they intercept the key event
    /// regardless of focus.
    private var keyboardShortcutCatchers: some View {
        ZStack {
            optionShortcut(letter: "A", key: "1")
            optionShortcut(letter: "B", key: "2")
            optionShortcut(letter: "C", key: "3")
            optionShortcut(letter: "D", key: "4")
            Button("close") { attemptExit() }
                .keyboardShortcut("w", modifiers: [.command])
                .opacity(0)
                .frame(width: 0, height: 0)
                .accessibilityHidden(true)
        }
    }

    private func optionShortcut(letter: String, key: Character) -> some View {
        Button("Pick \(letter)") {
            guard currentIndex < questions.count else { return }
            let q = questions[currentIndex]
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.15)) {
                selectedByQuestionId[q.id] = letter
            }
            saveInProgressNow()
        }
        .keyboardShortcut(KeyEquivalent(key), modifiers: [])
        .opacity(0)
        .frame(width: 0, height: 0)
        .accessibilityHidden(true)
    }

    /// Either ask the kid for confirmation (if they've started
    /// answering) or just dismiss immediately. The Cmd-W shortcut +
    /// any future close button route through here.
    private func attemptExit() {
        if selectedByQuestionId.isEmpty {
            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
            }
        } else {
            showingExitConfirm = true
        }
    }

    // MARK: - Empty / loading

    private var emptyState: some View {
        VStack(spacing: 14) {
            Spacer()
            if let err = hydrateError {
                Image(systemName: SFSymbolCompat.name("exclamationmark.triangle.fill"))
                    .font(.system(size: 36))
                    .foregroundColor(.orange)
                Text("Couldn't load this paper")
                    .font(.title3.weight(.semibold))
                Text(err)
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ProgressView("Loading questions…")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Quiz body

    private var quizBody: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if currentIndex < questions.count {
                    questionCard(questions[currentIndex])
                }
            }
            .padding(20)
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private func questionCard(_ q: OlympiadQuestion) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("Q \(q.number)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Capsule().fill(DesignTokens.BrandColor.primaryAction))
                Text(q.stem)
                    .font(.body)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            // Tuple-keypath ForEach (`enumerated()` + id: \.offset) is
            // the EXC_BAD_ACCESS class fixed in commit db727b4 on
            // Swift 5.5. Iterate indices instead and subscript the
            // stable array.
            ForEach(q.options.indices, id: \.self) { idx in
                optionRow(q: q, optionIndex: idx, optionText: q.options[idx])
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(Color.white.opacity(0.65))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .strokeBorder(DesignTokens.BrandColor.primaryAction.opacity(0.18), lineWidth: 1)
        )
    }

    private func optionRow(q: OlympiadQuestion, optionIndex: Int, optionText: String) -> some View {
        // Defense-in-depth: the parser guarantees exactly 4 options, but a
        // future/malformed paper with a 5th option would otherwise index past
        // this 4-element literal and trap (EXC_BAD_INSTRUCTION) on the iMac.
        let letters = ["A", "B", "C", "D"]
        let letter = optionIndex < letters.count ? letters[optionIndex] : "?"
        let isSelected = selectedByQuestionId[q.id] == letter
        return Button {
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.15)) {
                if selectedByQuestionId[q.id] == letter {
                    selectedByQuestionId.removeValue(forKey: q.id)
                } else {
                    selectedByQuestionId[q.id] = letter
                }
            }
            saveInProgressNow()
        } label: {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .strokeBorder(
                            isSelected ? DesignTokens.BrandColor.primaryAction
                                       : Color.secondary.opacity(0.5),
                            lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Circle()
                            .fill(DesignTokens.BrandColor.primaryAction)
                            .frame(width: 12, height: 12)
                    }
                    Text(letter)
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(isSelected ? .white : .secondary)
                }
                Text(optionText)
                    .font(.body)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? DesignTokens.BrandColor.primaryAction.opacity(0.10)
                                    : Color.gray.opacity(0.05))
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Option \(letter): \(optionText)")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }

    // MARK: - Footer

    private var footer: some View {
        HStack(spacing: 14) {
            Button {
                if currentIndex > 0 {
                    currentIndex -= 1
                    saveInProgressNow()
                }
            } label: {
                Label("Previous", systemImage: SFSymbolCompat.name("chevron.left"))
            }
            .keyboardShortcut(.leftArrow, modifiers: [])
            .disabled(currentIndex == 0)
            .accessibilityLabel("Previous question")

            Button {
                guard currentIndex < questions.count else { return }
                let q = questions[currentIndex]
                if markedForReview.contains(q.id) {
                    markedForReview.remove(q.id)
                } else {
                    markedForReview.insert(q.id)
                }
                saveInProgressNow()
            } label: {
                let isMarked = currentIndex < questions.count
                    && markedForReview.contains(questions[currentIndex].id)
                Label(isMarked ? "Unmark" : "Mark for Review",
                      systemImage: SFSymbolCompat.name(isMarked ? "flag.slash" : "flag"))
            }
            .accessibilityLabel("Mark question for review")

            Spacer()

            Text("Question \(currentIndex + 1) of \(questions.count)")
                .font(.caption.monospacedDigit())
                .foregroundColor(.secondary)

            Spacer()

            Button {
                if currentIndex + 1 < questions.count {
                    currentIndex += 1
                    saveInProgressNow()
                }
            } label: {
                Label("Next", systemImage: SFSymbolCompat.name("chevron.right"))
            }
            .keyboardShortcut(.rightArrow, modifiers: [])
            .disabled(currentIndex + 1 >= questions.count)
            .accessibilityLabel("Next question")

            Button {
                showingResult = true
            } label: {
                Label("Submit Paper", systemImage: SFSymbolCompat.name("paperplane.fill"))
                    .padding(.horizontal, 8)
            }
            .keyboardShortcut("s", modifiers: [.command, .shift])
            .accessibilityLabel("Submit paper")
            .help("Submit and view your score (⌘⇧S).")
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(Color(NSColor.controlBackgroundColor))
    }

    // MARK: - Hydrate

    private func hydrateIfNeeded() {
        guard questions.isEmpty, hydrateError == nil else { return }
        // Bundle-resource decode is small but still measurable
        // (regex over ~10 KB of MD twice). Hop off main so the first
        // question doesn't flash empty for a frame on the AMD GPU.
        Task.detached(priority: .userInitiated) {
            let parsed = paper.loadQuestions()
            await MainActor.run {
                if parsed.isEmpty {
                    hydrateError = "Bundled resources for this paper couldn't be read."
                } else {
                    questions = parsed
                    restoreOrStart()
                    startTicker()
                }
            }
        }
    }

    /// On first questions-ready, either restore a saved in-progress
    /// record (kid is resuming) or start a fresh attempt (timestamp
    /// `now` so the countdown begins from full time).
    private func restoreOrStart() {
        if let saved = DataStore.shared.inProgressOlympiad(forPaperId: paper.id) {
            selectedByQuestionId = saved.selectedByQuestionId
            markedForReview = Set(saved.markedForReviewQuestionIds)
            // Clamp index — questions array shape is stable but defensive
            // is cheap, and a future authoring change could shorten a
            // paper, leaving the old index past the end.
            currentIndex = max(0, min(saved.currentIndex, questions.count - 1))
            startedAt = saved.startedAt
        } else {
            startedAt = Date()
            saveInProgressNow()
        }
    }

    /// Computes how many seconds are left on the clock, given
    /// `startedAt` and the paper's `suggestedTimeMinutes`. Capped at 0
    /// (never goes negative — the auto-submit fires on first ≤0 read).
    private func computeSecondsRemaining(now: Date = Date()) -> Int {
        guard let start = startedAt else { return paper.suggestedTimeMinutes * 60 }
        let total = paper.suggestedTimeMinutes * 60
        let elapsed = Int(now.timeIntervalSince(start))
        return max(0, total - elapsed)
    }

    /// 1 Hz ticker. Updates the `secondsRemaining` @State and, when
    /// the countdown hits 0, sets the time-up banner + presents the
    /// result sheet. Single-source-of-truth is `startedAt` plus
    /// wall-clock — the ticker is just a render trigger.
    private func startTicker() {
        tickerTask?.cancel()
        secondsRemaining = computeSecondsRemaining()
        tickerTask = Task { @MainActor in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
                let rem = computeSecondsRemaining()
                secondsRemaining = rem
                if rem <= 0 && !showingResult {
                    timeUpBanner = true
                    showingResult = true
                    return
                }
            }
        }
    }

    /// Persist the current state to `olympiad_in_progress.json`.
    /// Called after every kid-driven state change (option pick,
    /// navigate, mark). The DataStore `saveCoalesced` debounces to
    /// 250 ms so a rapid 1/2/3/4 sequence doesn't flush four times.
    private func saveInProgressNow() {
        guard let start = startedAt else { return }
        let record = OlympiadInProgress(
            paperId: paper.id,
            selectedByQuestionId: selectedByQuestionId,
            markedForReviewQuestionIds: Array(markedForReview),
            currentIndex: currentIndex,
            startedAt: start,
            lastUpdatedAt: Date()
        )
        DataStore.shared.saveOlympiadInProgress(record)
    }
}
