import SwiftUI

// MARK: - OlympiadPaperReaderView
//
// Native SwiftUI read-only viewer for an Olympiad paper. Replaces the
// earlier "Open Paper" path which routed through ArticleBrowserView's
// NSAttributedString structured-block renderer — that renderer is
// tuned to the NCERT article HTML (which uses `<p>` / `<h1-3>` /
// `<aside class="fact-box">` / etc.), and the Olympiad print-style
// HTML uses an entirely different shape (`<div class="q">`,
// `<div class="opts">`, `<table>`, `<hr>`) that the structured parser
// silently ignores. Net effect on Big Sur: title loaded but body was
// rendered empty.
//
// Approach: we already PARSE the bundled QuestionPaper.md + Solutions.md
// into `[OlympiadQuestion]` for the interactive quiz; the reader just
// renders the SAME data non-interactively. No HTML pipeline involved
// → no NSTextView / structured-renderer / parseBlocks dependency.
//
// Big Sur safety: pure SwiftUI, no WKWebView / WebContent risk, no
// macOS 12+ APIs. ScrollView + LazyVStack (10.15 baseline) over a
// per-question card.

@MainActor
struct OlympiadPaperReaderView: View {
    let paper: OlympiadPaper

    @Environment(\.presentationMode) private var presentationMode
    @State private var questions: [OlympiadQuestion] = []
    @State private var hydrateError: String?

    var body: some View {
        VStack(spacing: 0) {
            chrome
            Divider()
            if questions.isEmpty {
                placeholder
            } else {
                body_
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear { hydrateIfNeeded() }
    }

    // MARK: - Chrome

    private var chrome: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            Button {
                // Deferred dismiss — same Big-Sur entangling-fence guard
                // used in OlympiadQuizResultView's chrome.
                DispatchQueue.main.async { presentationMode.wrappedValue.dismiss() }
            } label: {
                Image(systemName: SFSymbolCompat.name("xmark.circle.fill"))
                    .font(.title3)
            }
            .keyboardShortcut("w", modifiers: .command)
            .help("Close paper")
            .accessibilityLabel("Close paper")
            Spacer()
            Text("Open Paper — \(paper.chapterTitle)")
                .font(.body.weight(.semibold))
            Spacer()
            // Spacer balance with leading button width.
            Color.clear.frame(width: 28, height: 1)
        }
        .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 10)
        .background(Color(NSColor.controlBackgroundColor))
    }

    private var placeholder: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
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
                ProgressView("Loading paper…")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var body_: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                hero
                ForEach(questions) { q in
                    questionCard(q)
                }
                footer
            }
            .padding(.horizontal, DesignTokens.Spacing.xl).padding(.vertical, 20)
            .frame(maxWidth: 760, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    // MARK: - Hero

    private var hero: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(paper.subjectName + " — Chapter " + String(paper.chapterNumber))
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
            Text(paper.chapterTitle)
                .font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Olympiad-level Class 7 paper · \(paper.questionCount) MCQs · \(paper.suggestedTimeMinutes) minutes · max \(paper.maxMarks) marks.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 10) {
                schemeChip(text: "+\(paper.marksCorrect) correct", tint: .green)
                schemeChip(text: "\(paper.marksWrong) wrong", tint: .red)
                schemeChip(text: "\(paper.marksSkipped) skipped", tint: .gray)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(DesignTokens.BrandColor.primaryAction.opacity(0.08))
        )
    }

    private func schemeChip(text: String, tint: Color) -> some View {
        Text(text)
            .font(.caption.weight(.semibold).monospacedDigit())
            .foregroundColor(tint)
            .padding(.horizontal, DesignTokens.Spacing.sm).padding(.vertical, 3)
            .background(Capsule().fill(tint.opacity(0.12)))
    }

    // MARK: - Per-question card

    private func questionCard(_ q: OlympiadQuestion) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: DesignTokens.Spacing.sm) {
                Text("Q \(q.number)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .foregroundColor(.white)
                    .padding(.horizontal, DesignTokens.Spacing.sm).padding(.vertical, 3)
                    .background(Capsule().fill(DesignTokens.BrandColor.primaryAction))
                Text(q.stem)
                    .font(.body)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            // Defensive — parser guarantees 4 options but a future malformed
            // paper could ship 0..3. Bounds-check via .indices, id: \.self
            // (NOT tuple-keypath enumerated, which is the Van-Helmont
            // EXC_BAD_ACCESS class).
            ForEach(q.options.indices, id: \.self) { idx in
                let letters = ["A", "B", "C", "D"]
                let letter = idx < letters.count ? letters[idx] : "?"
                let isCorrect = letter == q.correctAnswer.uppercased()
                optionRow(letter: letter, text: q.options[idx], isCorrect: isCorrect)
            }
            if let expl = q.explanation, !expl.isEmpty {
                workedSolution(expl)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(Color.white.opacity(0.65))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .strokeBorder(DesignTokens.BrandColor.primaryAction.opacity(0.15), lineWidth: 1)
        )
    }

    private func optionRow(letter: String, text: String, isCorrect: Bool) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("(\(letter))")
                .font(.subheadline.weight(.semibold).monospacedDigit())
                .foregroundColor(isCorrect ? .green : .secondary)
                .frame(width: 32, alignment: .leading)
            Text(text)
                .font(.body)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            if isCorrect {
                Image(systemName: SFSymbolCompat.name("checkmark.circle.fill"))
                    .foregroundColor(.green)
            }
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isCorrect ? Color.green.opacity(0.10) : Color.gray.opacity(0.04))
        )
    }

    private func workedSolution(_ explanation: String) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Working")
                .font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            Text(explanation)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                .fill(Color.yellow.opacity(0.08))
        )
    }

    // MARK: - Footer

    private var footer: some View {
        Text("End of paper — \(paper.questionCount) questions, max \(paper.maxMarks) marks.")
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, DesignTokens.Spacing.md)
            .padding(.bottom, DesignTokens.Spacing.xl)
    }

    // MARK: - Hydrate

    private func hydrateIfNeeded() {
        guard questions.isEmpty, hydrateError == nil else { return }
        Task.detached(priority: .userInitiated) {
            let parsed = paper.loadQuestions()
            await MainActor.run {
                if parsed.isEmpty {
                    hydrateError = "Bundled question paper for this chapter couldn't be read."
                } else {
                    questions = parsed
                }
            }
        }
    }
}
