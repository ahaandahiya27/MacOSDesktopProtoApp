import SwiftUI
import AppKit

// MARK: - MockTestRunnerView
//
// v9 Exam Simulation · Phase 2. The timed runner: a pinned countdown header, a
// one-question-at-a-time card (reusing the shared `MCQOptionRow`), a
// mark-for-review flag, a tappable question grid, and Prev / Next / Submit. Owns
// its `MockTestRunState` (`@StateObject`) so the clock + answers survive a body
// re-render; reports the graded `MockTestResult` back via `onFinish`.
//
// Big Sur safe: `LazyVGrid` + `Picker`-free, AppKit monospaced clock font,
// DesignTokens, SFSymbol-free glyphs, `withAnimationRespectingReduceMotion`, and
// explicit a11y. No macOS 12+ APIs.
@MainActor
struct MockTestRunnerView: View {
    @StateObject private var run: MockTestRunState
    let onFinish: (MockTestResult) -> Void

    @State private var showSubmitConfirm = false

    init(paper: MockTestPaper, onFinish: @escaping (MockTestResult) -> Void) {
        _run = StateObject(wrappedValue: MockTestRunState(paper: paper))
        self.onFinish = onFinish
    }

    /// Big monospaced-digit clock (SwiftUI's `.monospacedDigit()` Font is 12+).
    private static let clockFont = Font(
        NSFont.monospacedDigitSystemFont(ofSize: 26, weight: .bold))

    var body: some View {
        VStack(spacing: 0) {
            timerHeader
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                    questionCard
                    gridSection
                }
                .padding(DesignTokens.Spacing.lg)
                .frame(maxWidth: 680, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            Divider()
            navRow
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear { run.start() }
        .onDisappear { run.stop() }
        .onChange(of: run.isFinished) { finished in
            if finished, let result = run.result { onFinish(result) }
        }
        .alert(isPresented: $showSubmitConfirm) { submitAlert }
    }

    // MARK: - Timer header

    private var timerHeader: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text(run.formattedRemaining)
                    .font(Self.clockFont)
                    .foregroundColor(run.isLowTime
                                     ? DesignTokens.BrandColor.danger
                                     : DesignTokens.BrandColor.canvasText)
                Text("time left")
                    .font(.caption2)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(run.formattedRemaining) remaining\(run.isLowTime ? ", under a minute left" : "")")
            .accessibilityIdentifier("mocktest-clock")

            Spacer(minLength: 0)

            Text("\(run.answeredCount) of \(run.paper.count) answered")
                .font(.callout.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .accessibilityLabel("\(run.answeredCount) of \(run.paper.count) answered")
        }
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.vertical, DesignTokens.Spacing.md)
        .overlay(answeredProgressBar, alignment: .bottom)
    }

    private var answeredProgressBar: some View {
        GeometryReader { geo in
            let fraction: CGFloat = CGFloat(max(0, min(1, run.answeredFraction)))
            let fillWidth: CGFloat = fraction * geo.size.width
            ZStack(alignment: .leading) {
                Rectangle().fill(DesignTokens.BrandColor.mutedSurface.opacity(0.4))
                Rectangle().fill(DesignTokens.BrandColor.primaryAction)
                    .frame(width: fillWidth)
            }
        }
        .frame(height: 3)
        .accessibilityHidden(true)
    }

    // MARK: - Question card

    @ViewBuilder
    private var questionCard: some View {
        if let q = run.current {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                questionMeta(q)
                Text(q.question.prompt)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .fixedSize(horizontal: false, vertical: true)
                optionsList(q)
                markRow(q)
            }
            .padding(DesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                    .fill(DesignTokens.BrandColor.primaryAction.opacity(0.05))
            )
        } else {
            Text("No question to show.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
    }

    private func questionMeta(_ q: MockTestQuestion) -> some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Text("Question \(run.index + 1) of \(run.paper.count)")
                .font(.caption.weight(.bold))
                .foregroundColor(DesignTokens.BrandColor.primaryAction)
            bankChip(q.bank)
            Spacer(minLength: 0)
            Text("\(q.subjectTitle) · \(q.chapterTitle)")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Question \(run.index + 1) of \(run.paper.count). \(q.bank.displayName). \(q.subjectTitle), \(q.chapterTitle).")
    }

    private func bankChip(_ bank: MockTestBank) -> some View {
        Text(bank.displayName)
            .font(.caption2.weight(.semibold))
            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, DesignTokens.Spacing.xxs)
            .background(
                Capsule().fill(DesignTokens.BrandColor.mutedSurface.opacity(0.4)))
            .accessibilityHidden(true)
    }

    private func optionsList(_ q: MockTestQuestion) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            let options = q.question.options ?? []
            ForEach(options.indices, id: \.self) { idx in
                let option = options[idx]
                MCQOptionRow(
                    option: option, isAnswer: false,
                    isSelected: run.selection(forPaperId: q.id) == option,
                    revealed: false,
                    onTap: { run.select(option) })
            }
        }
    }

    private func markRow(_ q: MockTestQuestion) -> some View {
        let marked = run.isMarked(q.id)
        return Button(action: { run.toggleMarkForReview() }) {
            HStack(spacing: DesignTokens.Spacing.xs) {
                Text(marked ? "🚩" : "⚐").accessibilityHidden(true)
                Text(marked ? "Marked for review" : "Mark for review")
                    .font(.callout.weight(.semibold))
            }
            .foregroundColor(marked
                             ? DesignTokens.BrandColor.primaryAction
                             : DesignTokens.BrandColor.canvasTextSecondary)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .frame(minHeight: 44, alignment: .leading)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(marked ? "Marked for review" : "Mark for review")
        .accessibilityHint("Flags this question so you can come back to it before submitting")
        .accessibilityAddTraits(marked ? .isSelected : [])
        .accessibilityIdentifier("mocktest-mark-review")
    }

    // MARK: - Question grid

    private var gridSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Questions")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 44), spacing: DesignTokens.Spacing.sm)],
                      spacing: DesignTokens.Spacing.sm) {
                ForEach(run.paper.questions.indices, id: \.self) { i in
                    gridCell(i)
                }
            }
            gridLegend
        }
    }

    private func gridCell(_ i: Int) -> some View {
        let status = run.status(forIndex: i)
        return Button(action: { run.go(to: i) }) {
            Text("\(i + 1)")
                .font(.callout.weight(.semibold).monospacedDigit())
                .foregroundColor(cellTextColor(status))
                .frame(minWidth: 44, minHeight: 44)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                        .fill(cellFill(status)))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                        .stroke(status == .current
                                ? DesignTokens.BrandColor.primaryAction
                                : Color.clear, lineWidth: 2))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Question \(i + 1), \(cellStatusLabel(status))")
        .accessibilityHint("Jump to question \(i + 1)")
        .accessibilityIdentifier("mocktest-grid-\(i + 1)")
    }

    private var gridLegend: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            legendDot(DesignTokens.BrandColor.primaryAction.opacity(0.25), "Answered")
            legendDot(DesignTokens.BrandColor.warning.opacity(0.35), "Marked")
            legendDot(Color.gray.opacity(0.12), "Not yet")
        }
        .accessibilityHidden(true)
    }

    private func legendDot(_ color: Color, _ label: String) -> some View {
        HStack(spacing: DesignTokens.Spacing.xxs) {
            RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(color)
                .frame(width: 14, height: 14)
            Text(label).font(.caption2)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
    }

    // MARK: - Nav row

    private var navRow: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            navButton("‹ Prev", enabled: run.canGoPrevious,
                      identifier: "mocktest-prev") { run.goPrevious() }
                .keyboardShortcut(.leftArrow, modifiers: .option)
            navButton("Next ›", enabled: run.canGoNext,
                      identifier: "mocktest-next") { run.goNext() }
                .keyboardShortcut(.rightArrow, modifiers: .option)
            Spacer(minLength: 0)
            submitButton
        }
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.vertical, DesignTokens.Spacing.md)
    }

    private var submitButton: some View {
        Button(action: { attemptSubmit() }) {
            Text("Submit")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.vertical, DesignTokens.Spacing.sm)
                .frame(minHeight: 44)
                .background(Capsule().fill(DesignTokens.BrandColor.success))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Submit test")
        .accessibilityHint("Finishes the test and shows your score")
        .accessibilityIdentifier("mocktest-submit")
    }

    private func navButton(_ title: String, enabled: Bool, identifier: String,
                           action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(enabled
                                 ? DesignTokens.BrandColor.primaryAction
                                 : DesignTokens.BrandColor.mutedSurface)
                .padding(.horizontal, DesignTokens.Spacing.md)
                .padding(.vertical, DesignTokens.Spacing.sm)
                .frame(minHeight: 44)
                .background(
                    Capsule().stroke(enabled
                                     ? DesignTokens.BrandColor.primaryAction
                                     : DesignTokens.BrandColor.mutedSurface, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityLabel(title.replacingOccurrences(of: "‹ ", with: "")
            .replacingOccurrences(of: " ›", with: ""))
        .accessibilityIdentifier(identifier)
    }

    // MARK: - Submit flow

    private func attemptSubmit() {
        let unanswered = run.paper.count - run.answeredCount
        if unanswered > 0 {
            showSubmitConfirm = true
        } else {
            run.submit()
        }
    }

    private var submitAlert: Alert {
        let unanswered = run.paper.count - run.answeredCount
        return Alert(
            title: Text("Submit now?"),
            message: Text("You still have \(unanswered) unanswered question\(unanswered == 1 ? "" : "s"). Unanswered questions score 0."),
            primaryButton: .default(Text("Keep going"), action: {}),
            secondaryButton: .destructive(Text("Submit anyway"), action: { run.submit() }))
    }

    // MARK: - Grid status styling

    private func cellFill(_ status: MockTestRunState.SlotStatus) -> Color {
        switch status {
        case .current:        return DesignTokens.BrandColor.primaryAction.opacity(0.18)
        case .markedAnswered: return DesignTokens.BrandColor.warning.opacity(0.35)
        case .marked:         return DesignTokens.BrandColor.warning.opacity(0.35)
        case .answered:       return DesignTokens.BrandColor.primaryAction.opacity(0.25)
        case .untouched:      return Color.gray.opacity(0.12)
        }
    }

    private func cellTextColor(_ status: MockTestRunState.SlotStatus) -> Color {
        switch status {
        case .untouched: return DesignTokens.BrandColor.canvasTextSecondary
        default:         return DesignTokens.BrandColor.canvasText
        }
    }

    private func cellStatusLabel(_ status: MockTestRunState.SlotStatus) -> String {
        switch status {
        case .current:        return "current"
        case .markedAnswered: return "answered and marked for review"
        case .marked:         return "marked for review"
        case .answered:       return "answered"
        case .untouched:      return "not answered"
        }
    }
}
