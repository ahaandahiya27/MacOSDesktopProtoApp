import SwiftUI

/// Outcome of the user's most recent Check tap on this question. Used to
/// drive the correctness banner and to gate when the worked solution is
/// revealed.
enum AttemptOutcome: Equatable {
    case unchecked
    case correct
    case incorrect(userInput: String)
}

struct QuestionDetailView: View {
    let pack: SubjectPack
    let question: Question

    @State private var revealSolution = false
    @State private var typedAnswer = ""
    @State private var attemptOutcome: AttemptOutcome = .unchecked
    @State private var selectedOptionIndex: Int? = nil
    /// For .matchTheFollowing: the user's current left -> right assignment.
    /// Keys are the `left` values from question.matchPairs; values are a
    /// `right` choice picked from the shuffled right column. Missing keys
    /// mean "not yet assigned".
    @State private var matchAssignment: [String: String] = [:]
    /// Stable shuffled order of the right column. Computed once per question
    /// so the choices don't reshuffle as the user picks. Reset on question
    /// change.
    @State private var shuffledRights: [String] = []
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var nav: TutorNavigationState
    @EnvironmentObject var appState: AppState

    private var currentSiblingIndex: Int? {
        nav.questionSiblings.firstIndex {
            $0.packId == pack.id && $0.questionId == question.id
        }
    }
    private var hasPrevious: Bool {
        if let idx = currentSiblingIndex { return idx > 0 }
        return false
    }
    private var hasNext: Bool {
        if let idx = currentSiblingIndex { return idx < nav.questionSiblings.count - 1 }
        return false
    }
    private var siblingPositionLabel: String? {
        guard let idx = currentSiblingIndex else { return nil }
        return "\(idx + 1) / \(nav.questionSiblings.count)"
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    breadcrumb
                    header
                    promptCard
                    answerInteractionGroup
                    postAttemptGroup
                }
                .padding(20)
                .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                .frame(maxWidth: .infinity)
                .id("__top__")
            }
            .onAppear {
                resetMatchStateIfNeeded()
                // Land at the top whenever this detail is first shown.
                // Deferred to the next runloop tick so the inner VStack has
                // laid out before we ask the proxy to scroll.
                DispatchQueue.main.async {
                    proxy.scrollTo("__top__", anchor: .top)
                }
                recordRecent()
            }
            .onChange(of: question.id) { _ in
                // Reset per-question state when Prev/Next swaps the question.
                revealSolution = false
                typedAnswer = ""
                attemptOutcome = .unchecked
                selectedOptionIndex = nil
                matchAssignment = [:]
                shuffledRights = []
                resetMatchStateIfNeeded()
                // Snap back to the top so the new prompt is visible.
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo("__top__", anchor: .top)
                }
                recordRecent()
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle(String(question.prompt.prefix(50)))
        .background(keyboardShortcutSink)
        .toolbar {
            bookmarkToolbarItem
            reviewToolbarItem
        }
    }

    private var isQuestionBookmarked: Bool {
        dataStore.isQuestionBookmarked(
            subjectPackId: pack.id, questionId: question.id
        )
    }

    @ToolbarContentBuilder
    private var bookmarkToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Button {
                dataStore.toggleQuestionBookmark(
                    subjectPackId: pack.id,
                    questionId: question.id,
                    questionPrompt: question.prompt
                )
            } label: {
                Label(
                    isQuestionBookmarked ? "Bookmarked" : "Bookmark",
                    systemImage: isQuestionBookmarked
                        ? "bookmark.fill" : "bookmark"
                )
            }
            .keyboardShortcut("b", modifiers: .command)
            .help(isQuestionBookmarked
                  ? "Remove bookmark"
                  : "Bookmark this question to revisit it later")
        }
    }

    /// Toolbar button (parent action): flip this question out of the
    /// "needs review" queue. Only relevant when the pack flagged it for
    /// review in the first place; otherwise the toolbar slot is empty.
    @ToolbarContentBuilder
    private var reviewToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            reviewButton
        }
    }

    @ViewBuilder
    private var reviewButton: some View {
        if question.needsHumanReview {
            let isReviewed = dataStore.isReviewed(questionId: question.id)
            Button {
                dataStore.setReviewed(
                    questionId: question.id,
                    reviewed: !isReviewed
                )
            } label: {
                Label(
                    isReviewed ? "Reviewed" : "Mark reviewed",
                    systemImage: isReviewed
                        ? "checkmark.seal.fill"
                        : "exclamationmark.triangle.fill"
                )
            }
            .help(isReviewed
                  ? "This question has been triaged. Click to send it back to the Needs Review queue."
                  : "Mark this question as triaged. It will drop out of the Needs Review filter in Quiz Bank.")
        } else {
            EmptyView()
        }
    }

    // MARK: - Prev/Next

    @ViewBuilder
    private var navigationFooter: some View {
        HStack(spacing: 12) {
            Button(action: gotoPrevious) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Previous")
                }
            }
            .disabled(!hasPrevious)
            .keyboardShortcut(.leftArrow, modifiers: [])
            .accessibilityLabel("Previous question")

            Spacer()
            if let label = siblingPositionLabel {
                Text(label)
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
            }
            Spacer()

            Button(action: gotoNext) {
                HStack(spacing: 4) {
                    Text("Next")
                    Image(systemName: "chevron.right")
                }
            }
            .disabled(!hasNext)
            .keyboardShortcut(.rightArrow, modifiers: [])
            .accessibilityLabel("Next question")
        }
        .padding(.top, 8)
    }

    /// Two zero-size buttons that exist purely to register the arrow-key
    /// shortcuts even when the user hasn't focused the visible navigation
    /// buttons. Placed in a background so they don't occupy layout space.
    private var keyboardShortcutSink: some View {
        ZStack {
            Button(action: gotoPrevious) { EmptyView() }
                .keyboardShortcut(.leftArrow, modifiers: [])
                .disabled(!hasPrevious)
            Button(action: gotoNext) { EmptyView() }
                .keyboardShortcut(.rightArrow, modifiers: [])
                .disabled(!hasNext)
            // Cmd+arrow alternatives — also work when the answer field has
            // focus (where bare arrow keys would move the text cursor).
            Button(action: gotoPrevious) { EmptyView() }
                .keyboardShortcut(.leftArrow, modifiers: .command)
                .disabled(!hasPrevious)
            Button(action: gotoNext) { EmptyView() }
                .keyboardShortcut(.rightArrow, modifiers: .command)
                .disabled(!hasNext)
        }
        .frame(width: 0, height: 0)
        .opacity(0)
        .allowsHitTesting(false)
    }

    private func gotoPrevious() {
        guard let idx = currentSiblingIndex, idx > 0 else { return }
        let prev = nav.questionSiblings[idx - 1]
        nav.replaceTop(.question(packId: prev.packId, questionId: prev.questionId))
    }

    private func gotoNext() {
        guard let idx = currentSiblingIndex,
              idx < nav.questionSiblings.count - 1 else { return }
        let next = nav.questionSiblings[idx + 1]
        nav.replaceTop(.question(packId: next.packId, questionId: next.questionId))
    }

    // MARK: - Body subgroups
    //
    // Swift 5.5 / Xcode 13 (Big Sur) @ViewBuilder caps at 10 subviews per
    // closure; the body VStack exceeds that, so the answer-interaction and
    // post-attempt subviews are bundled into Groups here.

    @ViewBuilder
    private var answerInteractionGroup: some View {
        if let opts = question.options, !opts.isEmpty {
            optionsList(opts)
        }
        if question.questionType == .matchTheFollowing,
           let pairs = question.matchPairs, !pairs.isEmpty {
            matchTheFollowingSection(pairs: pairs)
        }
        userAnswerField
        if attemptOutcome != .unchecked {
            correctnessBanner
        }
    }

    @ViewBuilder
    private var postAttemptGroup: some View {
        solutionDisclosure
        commonMistakesCard
        variationsSection
        if currentSiblingIndex != nil {
            navigationFooter
        }
    }

    // MARK: - Sections

    /// Walks the pack to find which chapter+topic owns this question. Returns
    /// nil for orphans (shouldn't happen in normal data but stays defensive).
    private var location: (chapter: Chapter, topic: Topic)? {
        for chapter in pack.chapters {
            for topic in chapter.topics where topic.questions.contains(where: { $0.id == question.id }) {
                return (chapter, topic)
            }
        }
        return nil
    }

    @ViewBuilder
    private var breadcrumb: some View {
        if let loc = location {
            HStack(spacing: 4) {
                Text(pack.coverEmoji)
                Text(pack.title).font(.caption.weight(.medium))
                Text("›").foregroundColor(.secondary)
                Text("Ch. \(loc.chapter.number)").font(.caption)
                Text("›").foregroundColor(.secondary)
                Text(loc.topic.title).font(.caption).lineLimit(1).truncationMode(.tail)
                Spacer(minLength: 0)
            }
            .foregroundColor(.secondary)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(pack.title), Chapter \(loc.chapter.number), \(loc.topic.title)")
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Label(question.questionType.displayName, systemImage: "questionmark.circle.fill")
                .font(.caption.bold())
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
            QuestionDifficultyBadge(level: question.difficulty)
            Spacer()
            if !question.pageRefs.isEmpty {
                Text("p. \(question.pageRefs.map(String.init).joined(separator: ", "))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var promptCard: some View {
        Text(question.prompt)
            .font(.title3)
            .devanagariAwareLocale(packId: pack.id)
            .lineSpacing(4)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.1))
            )
    }

    /// Index of the correct option, if we can find it. Comparison uses the
    /// same AnswerValidator as the free-text path so trivial whitespace /
    /// case differences between the pack JSON's `answer` and the matching
    /// `options[i]` entry don't cause false negatives.
    private func correctOptionIndex(_ options: [String]) -> Int? {
        options.firstIndex { AnswerValidator.matches(userInput: $0, truth: question.answer) }
    }

    @ViewBuilder
    private func optionsList(_ options: [String]) -> some View {
        let isMCQ = question.questionType == .mcq
        let correctIdx = isMCQ ? correctOptionIndex(options) : nil
        VStack(alignment: .leading, spacing: 8) {
            Text("Options").font(.caption).foregroundColor(.secondary).textCase(.uppercase)
            ForEach(Array(options.enumerated()), id: \.offset) { idx, opt in
                if isMCQ {
                    mcqOptionRow(idx: idx, opt: opt, correctIdx: correctIdx)
                } else {
                    // Non-MCQ (e.g. some legacy entries): keep the static
                    // read-only row so we don't break older question shapes.
                    optionRow(idx: idx, opt: opt)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.1))
                        )
                }
            }
            if isMCQ {
                HStack {
                    Spacer()
                    Button("Check") { recordMCQAttempt(options: options) }
                        .disabled(selectedOptionIndex == nil || attemptOutcome != .unchecked)
                }
                .padding(.top, 4)
            }
        }
    }

    /// Pure layout for one row of the options list. Pulled out so MCQ + the
    /// non-MCQ fallback can share the chrome.
    private func optionRow(idx: Int, opt: String) -> some View {
        HStack {
            Text("\(["A","B","C","D","E","F"][safe: idx] ?? "?").")
                .font(.body.bold())
                .frame(width: 22, alignment: .leading)
                .foregroundColor(Color.compatIndigo)
            Text(opt).font(.body)
            Spacer()
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
    }

    @ViewBuilder
    private func mcqOptionRow(idx: Int, opt: String, correctIdx: Int?) -> some View {
        Button(action: {
            // Once an attempt is checked, lock the selection — Prev/Next
            // resets and lets the user retry on a fresh question.
            guard attemptOutcome == .unchecked else { return }
            if selectedOptionIndex == idx {
                selectedOptionIndex = nil
            } else {
                selectedOptionIndex = idx
            }
        }) {
            HStack {
                optionRow(idx: idx, opt: opt)
                if attemptOutcome != .unchecked && idx == correctIdx {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else if case .incorrect = attemptOutcome, selectedOptionIndex == idx {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(mcqRowBackground(idx: idx, correctIdx: correctIdx))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(mcqRowBorder(idx: idx, correctIdx: correctIdx), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .contentShape(Rectangle())
        .accessibilityLabel("\(["A","B","C","D","E","F"][safe: idx] ?? "?"). \(opt)")
    }

    private func mcqRowBackground(idx: Int, correctIdx: Int?) -> Color {
        switch attemptOutcome {
        case .unchecked:
            return selectedOptionIndex == idx
                ? Color.compatIndigo.opacity(0.12)
                : Color.gray.opacity(0.1)
        case .correct:
            return idx == correctIdx ? Color.green.opacity(0.18) : Color.gray.opacity(0.06)
        case .incorrect:
            if idx == correctIdx { return Color.green.opacity(0.18) }
            if selectedOptionIndex == idx { return Color.red.opacity(0.15) }
            return Color.gray.opacity(0.06)
        }
    }

    private func mcqRowBorder(idx: Int, correctIdx: Int?) -> Color {
        switch attemptOutcome {
        case .unchecked:
            return selectedOptionIndex == idx ? Color.compatIndigo : Color.clear
        case .correct:
            return idx == correctIdx ? Color.green : Color.clear
        case .incorrect:
            if idx == correctIdx { return Color.green }
            if selectedOptionIndex == idx { return Color.red }
            return Color.clear
        }
    }

    // MARK: - Match-the-following

    @ViewBuilder
    private func matchTheFollowingSection(pairs: [MatchPair]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Match each item")
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)

            ForEach(pairs) { pair in
                matchRow(for: pair, allPairs: pairs)
            }

            HStack {
                Spacer()
                Button("Check") { recordMatchAttempt(pairs: pairs) }
                    .disabled(matchAssignment.count != pairs.count
                              || attemptOutcome != .unchecked)
            }
            .padding(.top, 4)
        }
    }

    @ViewBuilder
    private func matchRow(for pair: MatchPair, allPairs: [MatchPair]) -> some View {
        let chosen = matchAssignment[pair.left]
        let rowState: MatchRowState = {
            guard attemptOutcome != .unchecked else { return .pending }
            if chosen == pair.right { return .correctChoice }
            return .wrongChoice
        }()

        HStack(alignment: .center, spacing: 12) {
            Text(pair.left)
                .font(.body.weight(.semibold))
                .frame(minWidth: 110, alignment: .leading)
                .foregroundColor(Color.compatIndigo)

            // Right-side picker. We use Menu (macOS 11+) rather than .picker
            // styles that need macOS 12 (e.g. .menu style).
            Menu {
                ForEach(shuffledRights, id: \.self) { r in
                    Button(r) {
                        guard attemptOutcome == .unchecked else { return }
                        matchAssignment[pair.left] = r
                    }
                }
                if chosen != nil {
                    Divider()
                    Button("Clear") {
                        guard attemptOutcome == .unchecked else { return }
                        matchAssignment.removeValue(forKey: pair.left)
                    }
                }
            } label: {
                HStack {
                    Text(chosen ?? "Choose…")
                        .foregroundColor(chosen == nil ? .secondary : .primary)
                        .lineLimit(2)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(matchRowBackground(state: rowState))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(matchRowBorder(state: rowState), lineWidth: 1)
                )
            }
            .menuStyle(.borderlessButton)
            .frame(maxWidth: .infinity, alignment: .leading)
            .disabled(attemptOutcome != .unchecked)

            // After Check, show ✓ or ✗ so the user sees per-row correctness
            // even without re-reading the whole worked solution.
            if attemptOutcome != .unchecked {
                Image(systemName: rowState == .correctChoice ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(rowState == .correctChoice ? .green : .red)
            }
        }
    }

    private enum MatchRowState { case pending, correctChoice, wrongChoice }

    private func matchRowBackground(state: MatchRowState) -> Color {
        switch state {
        case .pending:       return Color.gray.opacity(0.1)
        case .correctChoice: return Color.green.opacity(0.15)
        case .wrongChoice:   return Color.red.opacity(0.12)
        }
    }
    private func matchRowBorder(state: MatchRowState) -> Color {
        switch state {
        case .pending:       return Color.gray.opacity(0.3)
        case .correctChoice: return Color.green
        case .wrongChoice:   return Color.red
        }
    }

    private func resetMatchStateIfNeeded() {
        guard question.questionType == .matchTheFollowing,
              let pairs = question.matchPairs, !pairs.isEmpty else { return }
        if shuffledRights.isEmpty {
            shuffledRights = pairs.map { $0.right }.shuffled()
        }
    }

    private func recordRecent() {
        let chapterLabel = location.map { "Ch. \($0.chapter.number) — \($0.topic.title)" }
            ?? pack.title
        let displayTitle = String(question.prompt.prefix(80))
        appState.recordRecent(RecentItem(
            packId: pack.id,
            kind: .question,
            routeId: question.id,
            title: displayTitle,
            subtitle: chapterLabel
        ))
    }

    /// Free-text answer field. Hidden for MCQ — selection IS the answer
    /// there, and a second input would be misleading.
    @ViewBuilder
    private var userAnswerField: some View {
        if question.questionType != .mcq && question.questionType != .matchTheFollowing {
            VStack(alignment: .leading, spacing: 6) {
                Text("Try it yourself").font(.caption).foregroundColor(.secondary).textCase(.uppercase)
                HStack(spacing: 8) {
                    TextField("Type your answer", text: $typedAnswer, onCommit: { recordAttempt() })
                        .textFieldStyle(.roundedBorder)
                    DictationButton(transcript: $typedAnswer)
                    Button("Check") { recordAttempt() }
                        .disabled(typedAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                  || attemptOutcome != .unchecked)
                }
            }
        }
    }

    private var solutionDisclosure: some View {
        ExpandableCard(
            isExpanded: $revealSolution,
            systemImage: "lightbulb.fill",
            title: "Show worked solution"
        ) {
            VStack(alignment: .leading, spacing: 10) {
                Text(question.answer)
                    .font(.body.bold())
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.12)))
                ForEach(Array(question.solutionSteps.enumerated()), id: \.offset) { idx, step in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(idx + 1).")
                            .font(.body.bold())
                            .foregroundColor(Color.compatIndigo)
                            .frame(width: 22, alignment: .trailing)
                        Text(step)
                            .font(.body)
                            .lineSpacing(3)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var commonMistakesCard: some View {
        // Only show after the kid has answered incorrectly OR after they've
        // explicitly revealed the solution. Showing it on first render trains
        // memorization of the wrong moves before any thinking happens.
        let shouldShow: Bool = {
            if revealSolution { return true }
            if case .incorrect = attemptOutcome { return true }
            return false
        }()
        if shouldShow && !question.commonMistakes.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Label("Common mistakes", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline)
                ForEach(Array(question.commonMistakes.enumerated()), id: \.offset) { _, m in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                        Text(m).font(.callout).lineSpacing(3)
                    }
                }
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color.red.opacity(0.08)))
        }
    }

    @ViewBuilder
    private var variationsSection: some View {
        if !question.variations.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Label("Now try these variations", systemImage: "arrow.triangle.branch")
                    .font(.headline)
                ForEach(question.variations) { v in
                    QuestionVariationCard(variation: v)
                }
            }
        }
    }

    // MARK: - Correctness banner

    @ViewBuilder
    private var correctnessBanner: some View {
        switch attemptOutcome {
        case .unchecked:
            EmptyView()
        case .correct:
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Correct").font(.headline).foregroundColor(.green)
                    Text("Nice work — the worked solution below explains why.")
                        .font(.callout)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.12)))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.green.opacity(0.4), lineWidth: 1)
            )
        case .incorrect(let userInput):
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Not quite").font(.headline).foregroundColor(.red)
                    if !userInput.isEmpty {
                        Text("You answered: \(userInput)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    Text("The correct answer is shown below.")
                        .font(.callout)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.10)))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.red.opacity(0.4), lineWidth: 1)
            )
        }
    }

    // MARK: - Actions

    private func recordAttempt() {
        let userInput = typedAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userInput.isEmpty else { return }
        // For free-text answer types where the truth is often a full sentence,
        // accept correct *phrases* via subset-tolerant matching. Strict match
        // is kept for fill-in-blank and numerical.
        let isCorrect: Bool
        switch question.questionType {
        case .shortAnswer, .longAnswer:
            isCorrect = AnswerValidator.matchesLenient(userInput: userInput, truth: question.answer)
        default:
            isCorrect = AnswerValidator.matches(userInput: userInput, truth: question.answer)
        }

        dataStore.insertAttempt(QuestionAttempt(
            subjectPackId: pack.id,
            questionId: question.id,
            userAnswer: typedAnswer,
            isCorrect: isCorrect
        ))
        attemptOutcome = isCorrect ? .correct : .incorrect(userInput: userInput)
        revealSolution = true
        maybeAutoAdvanceAfterCorrect(isCorrect)
    }

    private func recordMCQAttempt(options: [String]) {
        guard let idx = selectedOptionIndex, options.indices.contains(idx) else { return }
        let selected = options[idx]
        let isCorrect = AnswerValidator.matches(userInput: selected, truth: question.answer)

        dataStore.insertAttempt(QuestionAttempt(
            subjectPackId: pack.id,
            questionId: question.id,
            userAnswer: selected,
            isCorrect: isCorrect
        ))
        attemptOutcome = isCorrect ? .correct : .incorrect(userInput: selected)
        revealSolution = true
        maybeAutoAdvanceAfterCorrect(isCorrect)
    }

    private func recordMatchAttempt(pairs: [MatchPair]) {
        let allAssigned = pairs.allSatisfy { matchAssignment[$0.left] != nil }
        guard allAssigned else { return }
        let allCorrect = pairs.allSatisfy { matchAssignment[$0.left] == $0.right }
        let summary = pairs
            .map { "\($0.left) → \(matchAssignment[$0.left] ?? "?")" }
            .joined(separator: "; ")

        dataStore.insertAttempt(QuestionAttempt(
            subjectPackId: pack.id,
            questionId: question.id,
            userAnswer: summary,
            isCorrect: allCorrect
        ))
        attemptOutcome = allCorrect ? .correct : .incorrect(userInput: summary)
        revealSolution = true
        maybeAutoAdvanceAfterCorrect(allCorrect)
    }

    /// If the user has flipped on "Auto-advance after correct answer" in
    /// Settings AND there's a next sibling, jump to the next question after
    /// a brief delay so the kid can read the green banner.
    private func maybeAutoAdvanceAfterCorrect(_ isCorrect: Bool) {
        guard isCorrect, SettingsManager.shared.autoAdvanceOnCorrect, hasNext else { return }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_400_000_000)
            // The user may have manually navigated away during the delay.
            if hasNext && attemptOutcome == .correct {
                gotoNext()
            }
        }
    }
}

// MARK: - Array safe-index helper (private)

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
