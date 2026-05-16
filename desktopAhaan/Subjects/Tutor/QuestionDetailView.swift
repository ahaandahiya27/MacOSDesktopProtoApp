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
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var subjectRegistry: SubjectRegistry
    @EnvironmentObject var nav: TutorNavigationState

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
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                promptCard
                if let opts = question.options, !opts.isEmpty {
                    optionsList(opts)
                }
                userAnswerField
                if attemptOutcome != .unchecked {
                    correctnessBanner
                }
                solutionDisclosure
                commonMistakesCard
                variationsSection
                if currentSiblingIndex != nil {
                    navigationFooter
                }
            }
            .padding(20)
            .frame(maxWidth: 820, alignment: .leading)
        }
        .onChange(of: question.id) { _ in
            // Reset per-question state when Prev/Next swaps the question
            revealSolution = false
            typedAnswer = ""
            attemptOutcome = .unchecked
        }
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle(String(question.prompt.prefix(50)))
        .background(keyboardShortcutSink)
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

    // MARK: - Sections

    private var header: some View {
        HStack(spacing: 12) {
            Label(question.questionType.displayName, systemImage: "questionmark.app.fill")
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
            .lineSpacing(4)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.1))
            )
    }

    private func optionsList(_ options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Options").font(.caption).foregroundColor(.secondary).textCase(.uppercase)
            ForEach(Array(options.enumerated()), id: \.offset) { idx, opt in
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
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                )
            }
        }
    }

    private var userAnswerField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Try it yourself").font(.caption).foregroundColor(.secondary).textCase(.uppercase)
            HStack(spacing: 8) {
                TextField("Type your answer", text: $typedAnswer, onCommit: { recordAttempt() })
                    .textFieldStyle(.roundedBorder)
                Button("Check") { recordAttempt() }
                    .disabled(typedAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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
        if !question.commonMistakes.isEmpty {
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
                    VariationCard(variation: v)
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
        let isCorrect = AnswerValidator.matches(userInput: userInput, truth: question.answer)

        dataStore.insertAttempt(QuestionAttempt(
            subjectPackId: pack.id,
            questionId: question.id,
            userAnswer: typedAnswer,
            isCorrect: isCorrect
        ))
        attemptOutcome = isCorrect ? .correct : .incorrect(userInput: userInput)
        revealSolution = true
    }
}

// MARK: - AnswerValidator

/// Free-text answer matcher tuned for short, single-fact answers
/// (numbers, single nouns, short phrases). Used by both QuestionDetailView
/// and any future quiz UI.
///
/// Rules, evaluated in order:
///   1. Whitespace-trimmed, case-folded exact match.
///   2. If both sides parse as numbers (Int or Double), compare numerically
///      so "8" == "8.0" == " 8 ".
///   3. Token-set match for multi-word answers — order-independent equality
///      of the meaningful tokens (drops punctuation and stop-ish words),
///      so "8 teeth" matches "teeth 8" but NOT "abcd".
/// Substring matching is deliberately NOT used; it produced false positives
/// (e.g. the empty string matched every truth).
enum AnswerValidator {
    static func matches(userInput: String, truth: String) -> Bool {
        let u = normalize(userInput)
        let t = normalize(truth)
        if u.isEmpty || t.isEmpty { return false }
        if u == t { return true }
        if let un = Double(u), let tn = Double(t), un == tn { return true }
        let uTokens = tokenize(u)
        let tTokens = tokenize(t)
        if !uTokens.isEmpty && uTokens == tTokens { return true }
        return false
    }

    private static func normalize(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// Sorted set of meaningful tokens. Strips punctuation and a tiny set of
    /// English filler words so "the sun" and "sun" are considered equal.
    private static let stopWords: Set<String> = ["the", "a", "an", "is", "are"]
    private static func tokenize(_ s: String) -> [String] {
        let cleaned = s.unicodeScalars
            .map { CharacterSet.alphanumerics.contains($0) ? Character($0) : " " }
        return String(cleaned)
            .split(separator: " ")
            .map(String.init)
            .filter { !$0.isEmpty && !stopWords.contains($0) }
            .sorted()
    }
}

// MARK: - DifficultyBadge

struct QuestionDifficultyBadge: View {
    let level: Int
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= level ? "circle.fill" : "circle")
                    .font(.caption2)
                    .foregroundColor(i <= level ? color : .secondary.opacity(0.4))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Difficulty \(level) of 5")
    }
    private var color: Color {
        switch level {
        case 1...2: return .green
        case 3:     return .yellow
        default:    return .orange
        }
    }
}

// MARK: - VariationCard

private struct VariationCard: View {
    let variation: QuestionVariation
    @State private var expanded = false

    var body: some View {
        ExpandableCard(
            isExpanded: $expanded,
            systemImage: "arrow.triangle.branch",
            title: variation.prompt,
            tint: Color.compatIndigo
        ) {
            VStack(alignment: .leading, spacing: 8) {
                Text(variation.answer)
                    .font(.body.bold())
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.green.opacity(0.12)))
                ForEach(Array(variation.solutionSteps.enumerated()), id: \.offset) { idx, step in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(idx + 1).").font(.callout.bold()).foregroundColor(Color.compatIndigo)
                        Text(step).font(.callout).lineSpacing(3)
                    }
                }
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
