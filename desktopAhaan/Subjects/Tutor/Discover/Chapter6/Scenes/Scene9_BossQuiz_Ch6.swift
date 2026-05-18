import SwiftUI
import AppKit
import PDFKit

/// Scene 9 — Boss Quiz Ch6. Five hand-authored MCQs on Physical and Chemical Changes.
struct Scene9_BossQuiz_Ch6: View {
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

    private var quiz: [Ch6QuizItem] { Self.items }

    private static let items: [Ch6QuizItem] = [
        Ch6QuizItem(
            prompt: "Which of these is a chemical change?",
            options: ["Melting ice", "Tearing paper", "Burning wood", "Dissolving sugar"],
            answer: "Burning wood",
            explanation: "Burning wood produces ash, CO\u{2082}, and water vapour \u{2014} all new substances. That makes it a chemical change."
        ),
        Ch6QuizItem(
            prompt: "Rusting of iron requires:",
            options: ["Only water", "Only oxygen", "Both water and oxygen", "Neither"],
            answer: "Both water and oxygen",
            explanation: "Iron reacts with both water (moisture) and oxygen from the air to form iron oxide (rust). Remove either and rusting stops."
        ),
        Ch6QuizItem(
            prompt: "Which method prevents rusting by coating iron with zinc?",
            options: ["Painting", "Oiling", "Galvanisation", "Alloying"],
            answer: "Galvanisation",
            explanation: "Galvanisation coats iron with a layer of zinc. Zinc reacts first with moisture and oxygen, protecting the iron underneath."
        ),
        Ch6QuizItem(
            prompt: "Crystallisation is an example of a:",
            options: ["Chemical change", "Physical change", "Nuclear change", "Biological change"],
            answer: "Physical change",
            explanation: "In crystallisation, dissolved particles simply rearrange into a crystal pattern. No new substance is formed, so it is a physical change."
        ),
        Ch6QuizItem(
            prompt: "Which is a sign of a chemical change?",
            options: ["Change of shape", "Change of size", "Change of colour and gas produced", "Change of state"],
            answer: "Change of colour and gas produced",
            explanation: "When a new colour appears and gas bubbles form, new substances are being created \u{2014} clear signs of a chemical reaction."
        ),
    ]

    var body: some View {
        VStack(spacing: 14) {
            Text("Boss Quiz")
                .font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .padding(.top, 18)

            ProgressView(value: Double(currentQ), total: 5)
                .frame(maxWidth: 520)

            if !done {
                let item = quiz[currentQ]
                Text("Question \(currentQ + 1) of 5")
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
                    ForEach(item.options, id: \.self) { opt in
                        Ch6AnswerButton(
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
                            Text(item.explanation)
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

    fileprivate func state(for option: String, in item: Ch6QuizItem) -> AnswerState {
        guard let p = picks[currentQ] else { return .neutral }
        if option == item.answer { return .correct }
        if option == p { return .wrong }
        return .neutral
    }

    private func pick(_ option: String, in item: Ch6QuizItem) {
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
            Text("\u{1F389}")
                .font(.system(size: 76))
            Text("You finished Chapter 6 Discover Mode!")
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
                    Label("\u{1F393} Print my certificate", systemImage: "doc.richtext")
                }
                
                .accentColor(Color.compatIndigo)

                Button("Back to chapter") {
                    onComplete(score)
                }
                
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
        guard let nsImage = renderViewToImage(Ch6CertificateView(score: score, total: 5), size: CGSize(width: 600, height: 400)),
              let page = PDFPage(image: nsImage) else {
            pdfStatus = "Couldn't render certificate."
            return
        }
        let doc = PDFDocument()
        doc.insert(page, at: 0)

        let downloads = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Downloads")
        let filename = "discover_ch06_certificate_\(timestamp()).pdf"
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

private struct Ch6QuizItem {
    let prompt: String
    let options: [String]
    let answer: String
    let explanation: String
}

private struct Ch6AnswerButton: View {
    let label: String
    let state: Scene9_BossQuiz_Ch6.AnswerState
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

private struct Ch6CertificateView: View {
    let score: Int
    let total: Int
    var body: some View {
        VStack(spacing: 14) {
            Text("\u{1F393}").font(.system(size: 72))
            Text("Certificate of Discovery")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color.compatIndigo)
            Text("Chapter 6 \u{2014} Physical and Chemical Changes")
                .font(.title3)
            Text("Awarded to a curious learner")
                .font(.body)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.top, 8)
            Text("Final score: \(score) / \(total)")
                .font(.title2.bold())
                .padding(.top, 12)
            Text(formattedCurrentDate())
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.top, 16)
        }
        .padding(40)
        .frame(width: 600, height: 420)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(NSColor.controlBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(Color.compatIndigo, lineWidth: 4)
                        .padding(8)
                )
        )
    }
}
