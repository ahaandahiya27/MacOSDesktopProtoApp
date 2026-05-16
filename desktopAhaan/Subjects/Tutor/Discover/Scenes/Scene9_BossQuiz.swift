import SwiftUI
import AppKit
import PDFKit

/// Scene 9 — Boss Quiz. Five MCQ-style questions pulled from the chapter
/// JSON. Right answer flashes green + sparkles; wrong answer red-shakes and
/// reveals the correct one. After all 5, a celebration overlay with confetti,
/// a score badge, and a "Print my certificate" button that saves a PDF to
/// `~/Downloads`.
struct Scene9_BossQuiz: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    @State private var currentQ: Int = 0
    @State private var picks: [String?] = Array(repeating: nil, count: 5)
    @State private var score: Int = 0
    @State private var revealed: [Bool] = Array(repeating: false, count: 5)
    @State private var done: Bool = false
    @State private var shake: CGFloat = 0
    @State private var celebrate = false
    @State private var pdfStatus: String? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// The boss quiz uses hand-authored MCQ items, not textbook questions —
    /// the textbook items in this chapter are mostly short/long-answer or
    /// "choose-correct-pairs" type, neither of which fits a quick celebration
    /// quiz for a 12-year-old. The hand-authored items below cover the same
    /// concepts (chlorophyll, oxygen, stomata, Cuscuta as parasite, pitcher
    /// plants and nitrogen) but in tappable 4-option form.
    private var quiz: [Ch1QuizItem] { Self.fallbacks }

    /// Hand-authored quiz items covering the chapter's core concepts.
    private static let fallbacks: [Ch1QuizItem] = [
        Ch1QuizItem(
            prompt: "What is the green pigment in leaves that captures sunlight called?",
            options: ["Chlorophyll", "Cytoplasm", "Cellulose", "Carotene"],
            answer: "Chlorophyll",
            explanation: "Chlorophyll is the green pigment inside chloroplasts that absorbs light energy for photosynthesis."
        ),
        Ch1QuizItem(
            prompt: "Photosynthesis releases which gas as a by-product?",
            options: ["Carbon dioxide", "Nitrogen", "Oxygen", "Hydrogen"],
            answer: "Oxygen",
            explanation: "Plants split water during photosynthesis and release oxygen into the air."
        ),
        Ch1QuizItem(
            prompt: "Tiny pores on the underside of a leaf are called:",
            options: ["Stomata", "Stamen", "Sepals", "Septa"],
            answer: "Stomata",
            explanation: "Stomata are tiny mouths that take in CO₂ and release O₂ during photosynthesis."
        ),
        Ch1QuizItem(
            prompt: "Cuscuta is a:",
            options: ["Saprotroph", "Parasite", "Insectivore", "Symbiont"],
            answer: "Parasite",
            explanation: "Cuscuta has no chlorophyll. It wraps around host plants and steals their food — a parasite."
        ),
        Ch1QuizItem(
            prompt: "Pitcher plants eat insects mainly to get:",
            options: ["Carbon", "Water", "Nitrogen", "Sunlight"],
            answer: "Nitrogen",
            explanation: "Pitcher plants grow in nitrogen-poor soil. Trapping insects supplies nitrogen for proteins."
        )
    ]

    var body: some View {
        VStack(spacing: 14) {
            Text("Boss Quiz")
                .font(.largeTitle.bold())
                .padding(.top, 18)

            ProgressView(value: Double(currentQ), total: 5)
                .frame(maxWidth: 520)

            if !done {
                let item = quiz[currentQ]
                Text("Question \(currentQ + 1) of 5")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                SoftShadowCard(padding: 18) {
                    Text(item.prompt)
                        .font(.title3.bold())
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: 600)
                .offset(x: shake)

                VStack(spacing: 10) {
                    ForEach(item.options, id: \.self) { opt in
                        Ch1AnswerButton(
                            label: opt,
                            state: state(for: opt, in: item)
                        ) {
                            pick(opt, in: item)
                        }
                    }
                }
                .frame(maxWidth: 600)

                if revealed[currentQ] {
                    SoftShadowCard(padding: 12) {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                            Text(item.explanation.isEmpty ? "Got it!" : item.explanation)
                                .font(.callout)
                            Spacer(minLength: 0)
                        }
                    }
                    .frame(maxWidth: 600)
                }

                if revealed[currentQ] {
                    Button(currentQ < 4 ? "Next question" : "See my score") {
                        advance()
                    }
                    
                    .accentColor(Color.compatIndigo)
                }
            } else {
                completionView
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            Group {
                if celebrate {
                    ParticleEmitter(isActive: true, particleCount: 100, duration: 3.0)
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
        )
    }

    // MARK: - Quiz mechanics

    fileprivate enum AnswerState { case neutral, picked, correct, wrong }

    fileprivate func state(for option: String, in item: Ch1QuizItem) -> AnswerState {
        guard let p = picks[currentQ] else { return .neutral }
        if option == item.answer { return .correct }
        if option == p { return .wrong }
        return .neutral
    }

    private func pick(_ option: String, in item: Ch1QuizItem) {
        guard picks[currentQ] == nil else { return }
        picks[currentQ] = option
        let isRight = option == item.answer
        if isRight {
            score += 1
            withAnimation(.spring()) { revealed[currentQ] = true }
        } else {
            if !reduceMotion {
                withAnimation(.spring(response: 0.18, dampingFraction: 0.4)) { shake = 14 }
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 180_000_000)
                    withAnimation(.spring(response: 0.18, dampingFraction: 0.4)) { shake = -10 }
                    try? await Task.sleep(nanoseconds: 180_000_000)
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) { shake = 0 }
                }
            }
            withAnimation(.easeInOut.delay(0.4)) { revealed[currentQ] = true }
        }
    }

    private func advance() {
        if currentQ < 4 {
            withAnimation(.easeInOut) { currentQ += 1 }
        } else {
            withAnimation(.easeInOut) { done = true; celebrate = true }
        }
    }

    // MARK: - Completion / certificate

    @ViewBuilder
    private var completionView: some View {
        VStack(spacing: 14) {
            Text("🎉")
                .font(.system(size: 76))
            Text("You finished Chapter 1 Discover Mode!")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Text("Score: \(score) / 5")
                .font(.title2)
                .foregroundColor(Color.compatIndigo)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.compatIndigo.opacity(0.12)))

            HStack(spacing: 12) {
                Button {
                    saveCertificate()
                } label: {
                    Label("🎓 Print my certificate", systemImage: "doc.richtext")
                }
                
                .accentColor(Color.compatIndigo)

                Button("Back to chapter") {
                    onComplete(score)
                }
                
            }

            if let s = pdfStatus {
                Text(s)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: 560)
        .padding(20)
    }

    private func saveCertificate() {
        guard let nsImage = renderViewToImage(CertificateView(score: score, total: 5), size: CGSize(width: 600, height: 400)),
              let page = PDFPage(image: nsImage) else {
            pdfStatus = "Couldn't render certificate."
            return
        }
        let doc = PDFDocument()
        doc.insert(page, at: 0)

        let downloads = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Downloads")
        let filename = "discover_ch01_certificate_\(timestamp()).pdf"
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

private struct Ch1QuizItem {
    let prompt: String
    let options: [String]
    let answer: String
    let explanation: String
}

private struct Ch1AnswerButton: View {
    let label: String
    let state: Scene9_BossQuiz.AnswerState
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
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
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
    }

    private var background: Color {
        switch state {
        case .correct: return .green.opacity(0.14)
        case .wrong:   return .red.opacity(0.12)
        default:       return Color(NSColor.windowBackgroundColor)
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

/// A printable certificate. Rendered to PDF via ImageRenderer.
private struct CertificateView: View {
    let score: Int
    let total: Int
    var body: some View {
        VStack(spacing: 14) {
            Text("🎓").font(.system(size: 72))
            Text("Certificate of Discovery")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color.compatIndigo)
            Text("Chapter 1 — Nutrition in Plants")
                .font(.title3)
            Text("Awarded to a curious learner")
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            Text("Final score: \(score) / \(total)")
                .font(.title2.bold())
                .padding(.top, 12)
            Text(formattedCurrentDate())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 16)
        }
        .padding(40)
        .frame(width: 600, height: 420)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(Color.compatIndigo, lineWidth: 4)
                        .padding(8)
                )
        )
    }
}
