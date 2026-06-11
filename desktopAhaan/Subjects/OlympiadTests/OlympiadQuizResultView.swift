import SwiftUI
import AppKit

// MARK: - OlympiadQuizResultView
//
// The score-screen after the kid hits Submit Paper. Computes the
// authored +4 / -1 / 0 marking locally (no SRS write — these papers
// sit OUTSIDE the spaced-repetition layer, mirroring the Milestone
// Checkpoint stance), shows the breakdown, and lets the kid scroll
// through every question with their answer vs. the correct one + the
// worked solution from the bundled Solutions.md.
//
// Big Sur safety: pure SwiftUI, no Charts, animations gated.

@MainActor
struct OlympiadQuizResultView: View {
    let paper: OlympiadPaper
    let questions: [OlympiadQuestion]
    let selectedByQuestionId: [String: String]

    @Environment(\.presentationMode) private var presentationMode
    /// One-shot guard so SwiftUI's onAppear-firing-twice (it does, on
    /// Big Sur, when a .sheet is pushed onto a NavigationView) doesn't
    /// log a duplicate row. Even though `recordOlympiadAttempt` is
    /// itself idempotent on UUID, gating here avoids two identical
    /// UUID generations racing.
    ///
    /// Uses `DataStore.shared` directly (not `@EnvironmentObject`)
    /// because SwiftUI sheet content on Big Sur does NOT inherit
    /// environment objects from its presenter — this view is sheet-
    /// presented from `OlympiadQuizView`. Matches the convention used
    /// by `QuickCheckQuizScene` + the Boss-Quiz views.
    @State private var didRecordAttempt = false

    var body: some View {
        VStack(spacing: 0) {
            chrome
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    scoreCard
                    breakdownList
                }
                .padding(20)
                .frame(maxWidth: 720, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .onAppear { recordAttemptOnce() }
    }

    /// Capture this submission into the persisted attempt store the
    /// first time the result view appears. Idempotent — the
    /// `didRecordAttempt` flag prevents the second SwiftUI onAppear
    /// fire from creating a duplicate row.
    private func recordAttemptOnce() {
        guard !didRecordAttempt else { return }
        didRecordAttempt = true
        let t = tally
        let pct = max(0, min(100, t.percentage))
        let attempt = OlympiadAttempt(
            id: UUID(),
            paperId: paper.id,
            attemptedAt: Date(),
            correct: t.correct,
            wrong: t.wrong,
            skipped: t.skipped,
            scoreOutOfMax: t.scoreOutOfMax,
            maxMarks: paper.maxMarks,
            percentage: pct
        )
        DataStore.shared.recordOlympiadAttempt(attempt)
    }

    /// Open an `NSSavePanel` for the kid (or parent) to save the
    /// per-question score report as a styled HTML file. We don't emit
    /// PDF directly — the parent prints to PDF from Preview/Safari if
    /// they want one. See OlympiadScoreReportRenderer for the
    /// rationale (WKWebView createPDF is risky on Big Sur's AMD GPU,
    /// PDFKit page layout is fiddly).
    private func saveScoreReport() {
        let html = OlympiadScoreReportRenderer.render(
            paper: paper,
            questions: questions,
            selectedByQuestionId: selectedByQuestionId
        )
        let panel = NSSavePanel()
        panel.title = "Save Score Report"
        let stem = (paper.questionPaperPDF as NSString).deletingPathExtension
        panel.nameFieldStringValue = "\(stem)_ScoreReport.html"
        panel.directoryURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.begin { response in
            guard response == .OK, let dest = panel.url else { return }
            do {
                try html.data(using: .utf8)?.write(to: dest, options: .atomic)
            } catch {
                CrashReporter.shared.logDataIssue(
                    "OlympiadResult: write score report to '\(dest.path)' failed: \(error.localizedDescription)"
                )
            }
        }
    }

    // MARK: - Score math

    private struct Tally {
        let correct: Int
        let wrong: Int
        let skipped: Int
        let scoreOutOfMax: Int
        let percentage: Int
    }

    private var tally: Tally {
        var correct = 0, wrong = 0, skipped = 0
        for q in questions {
            guard let chosen = selectedByQuestionId[q.id] else { skipped += 1; continue }
            if chosen.uppercased() == q.correctAnswer.uppercased() {
                correct += 1
            } else {
                wrong += 1
            }
        }
        let score = correct * paper.marksCorrect
                  + wrong * paper.marksWrong
                  + skipped * paper.marksSkipped
        // Broken into distinct, explicitly-typed steps. The original single
        // nested ternary (Int/Double conversions + division + literal * inside
        // one expression) is exactly the shape that hangs/segfaults the Swift
        // 5.5 type-checker on the Big-Sur iMac — Xcode's own type-checker flags
        // it as "unable to type-check in reasonable time".
        let pct: Int
        if paper.maxMarks > 0 {
            let safeScore: Int = max(0, score)
            let ratio: Double = Double(safeScore) / Double(paper.maxMarks)
            pct = Int(ratio * 100.0)
        } else {
            pct = 0
        }
        return Tally(correct: correct, wrong: wrong, skipped: skipped,
                     scoreOutOfMax: score, percentage: pct)
    }

    // MARK: - Chrome

    private var chrome: some View {
        HStack(spacing: 12) {
            // Defer the dismiss one runloop tick: this result view is a .sheet
            // over a pushed QuizView, and tearing down a sheet in the same
            // commit as any nav change is the Big-Sur "entangling fence"
            // EXC_BAD_ACCESS class. Deferring keeps the teardown isolated.
            Button(action: { DispatchQueue.main.async { presentationMode.wrappedValue.dismiss() } }) {
                Image(systemName: SFSymbolCompat.name("xmark.circle.fill"))
                    .font(.title3)
            }
            .keyboardShortcut("w", modifiers: .command)
            .accessibilityLabel("Close results")
            .help("Close results")
            Spacer()
            Text("Results — \(paper.chapterTitle)")
                .font(.body.weight(.semibold))
            Spacer()
            Button(action: { saveScoreReport() }) {
                Label("Save Report", systemImage: SFSymbolCompat.name("arrow.down.doc.fill"))
                    .font(.callout.weight(.semibold))
            }
            .help("Save a printable HTML score report. Open in Preview or Safari to print or save as PDF.")
            .accessibilityLabel("Save score report")
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
        .background(Color(NSColor.controlBackgroundColor))
    }

    // MARK: - Score card

    private var scoreCard: some View {
        let t = tally
        return VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Text("🏆").font(.system(size: 32))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Your score")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(t.scoreOutOfMax) / \(paper.maxMarks)")
                        .font(.system(size: 32, weight: .bold).monospacedDigit())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text("\(t.percentage)%")
                        .font(.title3.weight(.semibold).monospacedDigit())
                        .foregroundColor(DesignTokens.BrandColor.primaryAction)
                }
                Spacer()
            }
            HStack(spacing: 14) {
                scoreChip(emoji: "✅", label: "Correct", value: t.correct, tint: .green)
                scoreChip(emoji: "❌", label: "Wrong", value: t.wrong, tint: .red)
                scoreChip(emoji: "⏭", label: "Skipped", value: t.skipped, tint: .gray)
            }
            Text("Marking: +\(paper.marksCorrect) for each correct · \(paper.marksWrong) for each wrong · \(paper.marksSkipped) for unattempted. Maximum \(paper.maxMarks).")
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(DesignTokens.BrandColor.primaryAction.opacity(0.08))
        )
    }

    private func scoreChip(emoji: String, label: String, value: Int, tint: Color) -> some View {
        VStack(spacing: 4) {
            Text(emoji).font(.title2)
            Text("\(value)")
                .font(.title2.weight(.bold).monospacedDigit())
                .foregroundColor(tint)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.7))
        )
    }

    // MARK: - Breakdown list

    private var breakdownList: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Question-by-question")
                .font(.title3.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            ForEach(questions) { q in
                breakdownRow(q: q)
            }
        }
    }

    private func breakdownRow(q: OlympiadQuestion) -> some View {
        let chosen = selectedByQuestionId[q.id]
        let isCorrect = chosen?.uppercased() == q.correctAnswer.uppercased()
        let isSkipped = chosen == nil
        let statusEmoji: String = isSkipped ? "⏭" : (isCorrect ? "✅" : "❌")
        let statusTint: Color = isSkipped ? .gray : (isCorrect ? .green : .red)

        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(statusEmoji)
                Text("Q \(q.number)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .foregroundColor(statusTint)
                Text(q.stem)
                    .font(.body)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            HStack(spacing: 18) {
                answerLabel(prefix: "Your answer:",
                            letter: chosen,
                            text: chosen.flatMap { letterText(q: q, letter: $0) } ?? "Not attempted",
                            tint: isSkipped ? .gray : (isCorrect ? .green : .red))
                if !isCorrect {
                    answerLabel(prefix: "Correct:",
                                letter: q.correctAnswer,
                                text: letterText(q: q, letter: q.correctAnswer) ?? "",
                                tint: .green)
                }
            }
            if !isCorrect, let explanation = q.explanation, !explanation.isEmpty {
                Text(explanation)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.yellow.opacity(0.10))
                    )
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.55))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(statusTint.opacity(0.20), lineWidth: 1)
        )
    }

    private func answerLabel(prefix: String, letter: String?, text: String, tint: Color) -> some View {
        HStack(spacing: 4) {
            Text(prefix)
                .font(.caption)
                .foregroundColor(.secondary)
            if let letter = letter {
                Text("(\(letter))")
                    .font(.caption.weight(.semibold).monospacedDigit())
                    .foregroundColor(tint)
            }
            Text(text)
                .font(.caption)
                .foregroundColor(tint)
                .lineLimit(2)
        }
    }

    private func letterText(q: OlympiadQuestion, letter: String) -> String? {
        switch letter.uppercased() {
        case "A": return q.options.indices.contains(0) ? q.options[0] : nil
        case "B": return q.options.indices.contains(1) ? q.options[1] : nil
        case "C": return q.options.indices.contains(2) ? q.options[2] : nil
        case "D": return q.options.indices.contains(3) ? q.options[3] : nil
        default:  return nil
        }
    }
}
