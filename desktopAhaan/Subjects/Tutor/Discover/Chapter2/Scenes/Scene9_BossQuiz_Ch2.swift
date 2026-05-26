import SwiftUI
import AppKit
import PDFKit

/// Scene 9 — Boss Quiz Ch2. Five MCQs at kid level covering:
/// 1. How many teeth does an adult have? (32)
/// 2. Which juice digests fat? (Bile)
/// 3. Which mode of nutrition does Amoeba use? (Holozoic)
/// 4. Where is most absorption done? (Small intestine)
/// 5. What's the first chamber of a cow's stomach? (Rumen)
///
/// On finish: confetti via ParticleEmitter, score badge, "Print my certificate" button.
struct Scene9_BossQuiz_Ch2: View {
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
                            AnswerButton(
                                label: opt,
                                state: state(for: opt, in: item)
                            ) {
                                pick(opt, in: item)
                            }
                        }
                    }
                    .frame(maxWidth: 600)
                } else {
                    VStack(spacing: 20) {
                        Text("🎉")
                            .font(.system(size: 80))
                            .opacity(celebrate ? 1 : 0)
                            .scaleEffect(celebrate ? 1.2 : 0.5)
                            .frame(height: 120)

                        Text("Quiz Complete!")
                            .font(.title.bold())
                            .foregroundColor(.green)

                        HStack(spacing: 16) {
                            Text("Score: \(score)/\(quiz.count)")
                                .font(.title2.bold())
                                .padding(12)
                                .background(Color.yellow.opacity(0.2))
                                .cornerRadius(8)

                            Text(badgeEmoji())
                                .font(.system(size: 40))
                        }

                        Button(action: { downloadCertificate() }) {
                            Label("🎓 Print my certificate", systemImage: "doc.text.fill")
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                        }
                        .accentColor(.blue)

                        if let status = pdfStatus {
                            Text(status)
                                .font(.caption)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }
                    .frame(maxWidth: 600)
                    .padding(.bottom, 12)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .overlay(
            Group {
                if celebrate {
                    ParticleEmitter(isActive: true, particleCount: 40, duration: 2.0)
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
        )
        .onAppear { if done { celebrate = true } }
    }

    // MARK: - Helpers

    private func state(for option: String, in item: Question) -> AnswerButton.State {
        guard let pick = picks[currentQ] else { return .neutral }
        guard revealed[currentQ] else { return .neutral }

        if option == item.answer {
            return pick == item.answer ? .correct : .correct
        } else {
            return pick == option ? .incorrect : .neutral
        }
    }

    @MainActor
    private func pick(_ option: String, in item: Question) {
        guard picks[currentQ] == nil else { return }

        picks[currentQ] = option
        let isCorrect = option == item.answer
        DataStore.shared.recordReview(
            questionId: item.id,
            quality: isCorrect ? .good : .forgot
        )

        if isCorrect {
            score += 1
            withAnimationRespectingReduceMotion(.spring(response: 0.35, dampingFraction: 0.6)) {
                revealed[currentQ] = true
            }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 800_000_000)
                advanceQuestion()
            }
        } else {
            Task { @MainActor in
                withAnimationRespectingReduceMotion(.easeInOut(duration: 0.1)) {
                    shake = -8
                }
                try? await Task.sleep(nanoseconds: 100_000_000)
                withAnimationRespectingReduceMotion(.easeInOut(duration: 0.1)) {
                    shake = 8
                }
                try? await Task.sleep(nanoseconds: 100_000_000)
                withAnimationRespectingReduceMotion(.easeInOut(duration: 0.1)) {
                    shake = 0
                }
                revealed[currentQ] = true
            }
        }
    }

    private func advanceQuestion() {
        if currentQ < quiz.count - 1 {
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.3)) {
                currentQ += 1
            }
        } else {
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.4)) {
                done = true
                celebrate = true
            }
            onComplete(score)
        }
    }

    private func badgeEmoji() -> String {
        switch score {
        case 5: return "🏆"
        case 4: return "🥇"
        case 3: return "🥈"
        default: return "📚"
        }
    }

    private func downloadCertificate() {
        let cert = generateCertificateImage()
        let url = (FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Downloads"))
            .appendingPathComponent("Chapter2_Certificate.pdf")

        let pdfDocument = PDFDocument()
        if let pdfPage = PDFPage(image: cert) {
            pdfDocument.insert(pdfPage, at: 0)
        }

        if pdfDocument.write(to: url) {
            pdfStatus = "Downloaded to ~/Downloads"
        } else {
            pdfStatus = "Error saving certificate"
        }
    }

    private func generateCertificateImage() -> NSImage {
        let frame = CGRect(x: 0, y: 0, width: 800, height: 600)
        let image = NSImage(size: frame.size)

        image.lockFocus()

        NSColor.white.setFill()
        frame.fill()

        NSColor.systemYellow.setStroke()
        NSBezierPath(rect: NSInsetRect(frame, 20, 20)).stroke()
        NSBezierPath(rect: NSInsetRect(frame, 25, 25)).stroke()

        let cert = NSAttributedString(
            string: "Certificate of Achievement",
            attributes: [
                .font: NSFont.boldSystemFont(ofSize: 48),
                .foregroundColor: NSColor.darkGray
            ]
        )
        cert.draw(at: CGPoint(x: 100, y: 450))

        let score_str = NSAttributedString(
            string: "Chapter 2 — Nutrition in Animals Quiz\nScore: \(score)/\(quiz.count)",
            attributes: [
                .font: NSFont.systemFont(ofSize: 24),
                .foregroundColor: NSColor.gray
            ]
        )
        score_str.draw(at: CGPoint(x: 100, y: 350))

        let date_str = NSAttributedString(
            string: "Date: \(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none))",
            attributes: [
                .font: NSFont.systemFont(ofSize: 14),
                .foregroundColor: NSColor.gray
            ]
        )
        date_str.draw(at: CGPoint(x: 100, y: 100))

        image.unlockFocus()
        return image
    }
}

// MARK: - Answer Button

struct AnswerButton: View {
    enum State {
        case neutral, correct, incorrect
    }

    let label: String
    let state: State
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.body)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        
        .foregroundColor(color(for: state))
        .background(backgroundColor(for: state))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor(for: state), lineWidth: 2)
        )
        .disabled(state != .neutral)
    }

    private func color(for state: State) -> Color {
        switch state {
        case .neutral: return .primary
        case .correct: return .green
        case .incorrect: return .red
        }
    }

    private func backgroundColor(for state: State) -> Color {
        switch state {
        case .neutral: return Color.gray.opacity(0.1)
        case .correct: return Color.green.opacity(0.2)
        case .incorrect: return Color.red.opacity(0.2)
        }
    }

    private func borderColor(for state: State) -> Color {
        switch state {
        case .neutral: return Color.gray.opacity(0.3)
        case .correct: return Color.green
        case .incorrect: return Color.red
        }
    }
}

