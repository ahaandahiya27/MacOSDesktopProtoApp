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

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 0) {
            header
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
        .sheet(isPresented: $showingResult) {
            OlympiadQuizResultView(
                paper: paper,
                questions: questions,
                selectedByQuestionId: selectedByQuestionId
            )
            .frame(minWidth: 720, minHeight: 540)
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
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
                .fill(Color.white.opacity(0.65))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusCard)
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
                if currentIndex > 0 { currentIndex -= 1 }
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
                if currentIndex + 1 < questions.count { currentIndex += 1 }
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
                }
            }
        }
    }
}
