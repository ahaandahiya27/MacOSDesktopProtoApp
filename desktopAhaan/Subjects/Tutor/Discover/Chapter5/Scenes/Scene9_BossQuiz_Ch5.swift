import SwiftUI
import AppKit
import PDFKit

/// Scene 9 — Boss Quiz Ch5. Five hand-authored MCQs on Acids, Bases and Salts.
/// Right answer flashes green + sparkles; wrong answer red-shakes.
/// After all 5, confetti + score + "Print my certificate" (PDF to ~/Downloads).
@MainActor
struct Scene9_BossQuiz_Ch5: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void


    init(pack: SubjectPack, chapter: Chapter, onComplete: @escaping (Int) -> Void) {
        self.pack = pack
        self.chapter = chapter
        self.onComplete = onComplete
        let n = chapter.bossQuestions?.count ?? 0
        self._picks = State(initialValue: Array(repeating: nil, count: n))
        self._revealed = State(initialValue: Array(repeating: false, count: n))
    }
    @State private var currentQ: Int = 0
    @State private var picks: [String?] = []
    @State private var score: Int = 0
    @State private var revealed: [Bool] = []
    @State private var done: Bool = false
    @State private var shake: CGFloat = 0
    @State private var celebrate = false
    @State private var pdfStatus: String? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Boss-quiz MCQs sourced from the science pack
    /// (`chapter.bossQuestions`). Authored in `science_class7.json`
    /// and loaded via SubjectRegistry. Daily Practice "Recently
    /// Missed" picks up wrong-answer ids from the same SM-2 store
    /// once `recordReview(questionId:quality:)` fires below.
    private var quiz: [Question] { chapter.bossQuestionsList }
    var body: some View {
        // ScrollView + LazyVStack: natural bounded height keeps the shell
        // footer (Previous / Next) reachable even on shorter windows.
        // Confetti emitter sits in an .overlay on the ScrollView so it
        // covers the whole viewport during the celebration, not just the
        // VStack region.
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Boss Quiz")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)

                ProgressView(value: Double(currentQ), total: Double(quiz.count))
                    .frame(maxWidth: 520)

                if !done {
                    quizBody
                } else {
                    completionView
                        .padding(.bottom, DesignTokens.Spacing.md)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
        .overlay(
            Group {
                if celebrate {
                    ParticleEmitter(isActive: true, particleCount: HardwareTier.particleBudget, duration: 3.0)
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
        )
    }

    @ViewBuilder
    private var quizBody: some View {
        let item = quiz[currentQ]
        Text("Question \(currentQ + 1) of \(quiz.count)")
            .font(.subheadline)
            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

        SoftShadowCard(padding: 18) {
            Text(item.prompt)
                .font(.title3.bold())
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: 600)
        .offset(x: shake)

        VStack(spacing: 10) {
            ForEach(item.options ?? [], id: \.self) { opt in
                Ch5AnswerButton(
                    label: opt,
                    state: state(for: opt, in: item)
                ) {
                    Task { @MainActor in pick(opt, in: item) }
                }
            }
        }
        .frame(maxWidth: 600)

        if revealed[currentQ] {
            SoftShadowCard(padding: 12) {
                HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text(item.bossExplanation)
                        .font(.callout)
                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: 600)
        }

        if revealed[currentQ] {
            Button(currentQ < quiz.count - 1 ? "Next question" : "See my score") {
                advance()
            }
            .accentColor(Color.compatIndigo)
            .accessibilityIdentifier("boss-quiz-advance")
        }
    }
    // MARK: - Quiz mechanics

    fileprivate enum AnswerState { case neutral, picked, correct, wrong }

    fileprivate func state(for option: String, in item: Question) -> AnswerState {
        guard let p = picks[currentQ] else { return .neutral }
        if option == item.answer { return .correct }
        if option == p { return .wrong }
        return .neutral
    }

    private func pick(_ option: String, in item: Question) {
        guard picks[currentQ] == nil else { return }
        picks[currentQ] = option
        let isRight = option == item.answer
        DataStore.shared.recordReview(
            questionId: item.id,
            quality: isRight ? .good : .forgot
        )
        if isRight {
            score += 1
            withAnimationRespectingReduceMotion(.spring()) { revealed[currentQ] = true }
        } else {
            if !reduceMotion {
                withAnimationRespectingReduceMotion(.spring(response: 0.18, dampingFraction: 0.4)) { shake = 14 }
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 180_000_000)
                    withAnimationRespectingReduceMotion(.spring(response: 0.18, dampingFraction: 0.4)) { shake = -10 }
                    try? await Task.sleep(nanoseconds: 180_000_000)
                    withAnimationRespectingReduceMotion(.spring(response: 0.2, dampingFraction: 0.5)) { shake = 0 }
                }
            }
            withAnimationRespectingReduceMotion(.easeInOut.delay(0.4)) { revealed[currentQ] = true }
        }
    }

    private func advance() {
        if currentQ < quiz.count - 1 {
            withAnimationRespectingReduceMotion(.easeInOut) { currentQ += 1 }
        } else {
            withAnimationRespectingReduceMotion(.easeInOut) { done = true; celebrate = true }
        }
    }

    // MARK: - Completion / certificate

    @ViewBuilder
    private var completionView: some View {
        VStack(spacing: 14) {
            Text("\u{1F389}")
                .font(.system(size: 76))
            Text("You finished Chapter 5 Discover Mode!")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Text("Score: \(score) / \(quiz.count)")
                .font(.title2)
                .foregroundColor(Color.compatIndigo)
                .padding(.horizontal, 18)
                .padding(.vertical, DesignTokens.Spacing.sm)
                .background(Capsule().fill(Color.compatIndigo.opacity(0.12)))

            HStack(spacing: DesignTokens.Spacing.md) {
                Button {
                    saveCertificate()
                } label: {
                    Label("\u{1F393} Print my certificate", systemImage: "doc.richtext")
                }

                .accentColor(Color.compatIndigo)
                .accessibilityIdentifier("boss-quiz-print-certificate")

                Button("Back to chapter") {
                    onComplete(score)
                }
                .accessibilityIdentifier("boss-quiz-back-to-chapter")

            }

            if let s = pdfStatus {
                Text(s)
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
        .frame(maxWidth: 560)
        .padding(20)
    }

    private func saveCertificate() {
        guard let nsImage = renderViewToImage(CertificateView(score: score, total: quiz.count), size: CGSize(width: 600, height: 400)),
              let page = PDFPage(image: nsImage) else {
            pdfStatus = "Couldn't render certificate."
            return
        }
        let doc = PDFDocument()
        doc.insert(page, at: 0)

        let downloads = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Downloads")
        let filename = "discover_ch05_certificate_\(timestamp()).pdf"
        let url = downloads.appendingPathComponent(filename)
        if doc.write(to: url) {
            pdfStatus = "Saved to ~/Downloads/\(filename)"
        } else {
            pdfStatus = "Could not save PDF."
        }
    }

    private func timestamp() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd_HHmm"
        return f.string(from: Date())
    }
}

// MARK: - Local types
private struct Ch5AnswerButton: View {
    let label: String
    let state: Scene9_BossQuiz_Ch5.AnswerState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                Spacer()
                if state == .correct {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                } else if state == .wrong {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, DesignTokens.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(stroke, lineWidth: 1.5)
        )
        .accessibilityLabel(label)
        .accessibilityValue(state == .correct ? "Correct" : state == .wrong ? "Incorrect" : "Not answered")
        .accessibilityHint("Picks this quiz answer")
        .accessibilityIdentifier("boss-quiz-option-\(label)")
    }

    private var background: Color {
        switch state {
        case .correct: return .green.opacity(0.14)
        case .wrong:   return .red.opacity(0.12)
        default:       return Color.white
        }
    }
    private var stroke: Color {
        switch state {
        case .correct: return .green.opacity(0.55)
        case .wrong:   return .red.opacity(0.55)
        default:       return Color.gray.opacity(0.25)
        }
    }
}

/// Printable certificate rendered to PDF via ImageRenderer.
private struct CertificateView: View {
    let score: Int
    let total: Int
    var body: some View {
        VStack(spacing: 14) {
            Text("\u{1F393}").font(.system(size: 72))
            Text("Certificate of Discovery")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color.compatIndigo)
            Text("Chapter 5 \u{2014} Acids, Bases and Salts")
                .font(.title3)
            Text("Awarded to a curious learner")
                .font(.body)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.top, DesignTokens.Spacing.sm)
            Text("Final score: \(score) / \(total)")
                .font(.title2.bold())
                .padding(.top, DesignTokens.Spacing.md)
            Text(formattedCurrentDate())
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.top, DesignTokens.Spacing.lg)
        }
        .padding(40)
        .frame(width: 600, height: 420)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(NSColor.controlBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(Color.compatIndigo, lineWidth: 4)
                        .padding(DesignTokens.Spacing.sm)
                )
        )
    }
}
