import SwiftUI
import AppKit
import PDFKit

/// Scene 9 — Boss Quiz Ch4. Five hand-authored MCQs on Heat.
/// Right answer flashes green + sparkles; wrong answer red-shakes.
/// After all 5, confetti + score + "Print my certificate" (PDF to ~/Downloads).
struct Scene9_BossQuiz_Ch4: View {
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

    private var quiz: [Ch4QuizItem] { Self.items }

    private static let items: [Ch4QuizItem] = [
        Ch4QuizItem(
            prompt: "Which of these is the best conductor of heat?",
            options: ["Wood", "Copper", "Wool", "Plastic"],
            answer: "Copper",
            explanation: "Copper is a metal and metals are excellent conductors of heat."
        ),
        Ch4QuizItem(
            prompt: "Heat from the Sun reaches us mainly by:",
            options: ["Conduction", "Convection", "Radiation", "All three equally"],
            answer: "Radiation",
            explanation: "Space is a vacuum — heat can only travel through it as radiation (infrared waves)."
        ),
        Ch4QuizItem(
            prompt: "A fluffed-up bird stays warm because:",
            options: [
                "Air trapped between feathers insulates",
                "Feathers are hot by themselves",
                "Blood flows faster in cold weather",
                "Skin becomes thick"
            ],
            answer: "Air trapped between feathers insulates",
            explanation: "Air is a poor conductor. Trapped air between fluffed feathers stops body heat escaping."
        ),
        Ch4QuizItem(
            prompt: "Cup A has 100 ml of water at 80°C. Cup B has 500 ml at 80°C. Which has more heat?",
            options: ["Cup A", "Cup B", "Both equal", "Cannot tell"],
            answer: "Cup B",
            explanation: "Same temperature, but Cup B has 5 times more water so it stores 5 times more heat energy."
        ),
        Ch4QuizItem(
            prompt: "A sea breeze blows from sea to land during the:",
            options: ["Day", "Night", "Both day and night", "Neither"],
            answer: "Day",
            explanation: "During the day land heats faster, hot air rises, and cooler air rushes in from the sea."
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
                    .foregroundStyle(.secondary)

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
                        Ch4AnswerButton(
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
                                .foregroundStyle(.yellow)
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
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                }
            } else {
                completionView
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            if celebrate {
                ParticleEmitter(isActive: true, particleCount: 100, duration: 3.0)
                    .allowsHitTesting(false)
                    .ignoresSafeArea()
            }
        }
    }

    // MARK: - Quiz mechanics

    fileprivate enum AnswerState { case neutral, picked, correct, wrong }

    fileprivate func state(for option: String, in item: Ch4QuizItem) -> AnswerState {
        guard let p = picks[currentQ] else { return .neutral }
        if option == item.answer { return .correct }
        if option == p { return .wrong }
        return .neutral
    }

    private func pick(_ option: String, in item: Ch4QuizItem) {
        guard picks[currentQ] == nil else { return }
        picks[currentQ] = option
        let isRight = option == item.answer
        if isRight {
            score += 1
            withAnimation(.spring()) { revealed[currentQ] = true }
        } else {
            if !reduceMotion {
                withAnimation(.spring(response: 0.18, dampingFraction: 0.4)) { shake = 14 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                    withAnimation(.spring(response: 0.18, dampingFraction: 0.4)) { shake = -10 }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
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
            Text("You finished Chapter 4 Discover Mode!")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Text("Score: \(score) / 5")
                .font(.title2)
                .foregroundStyle(.indigo)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(Capsule().fill(.indigo.opacity(0.12)))

            HStack(spacing: 12) {
                Button {
                    saveCertificate()
                } label: {
                    Label("🎓 Print my certificate", systemImage: "doc.richtext")
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigo)

                Button("Back to chapter") {
                    onComplete(score)
                }
                .buttonStyle(.bordered)
            }

            if let s = pdfStatus {
                Text(s)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: 560)
        .padding(20)
    }

    private func saveCertificate() {
        let renderer = ImageRenderer(content: CertificateView(score: score, total: 5))
        renderer.scale = 2.0
        guard let nsImage = renderer.nsImage,
              let tiff = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiff),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            pdfStatus = "Couldn't render certificate."
            return
        }

        let pdfPage: PDFPage? = {
            if let img = NSImage(data: pngData) {
                return PDFPage(image: img)
            }
            return nil
        }()
        guard let page = pdfPage else {
            pdfStatus = "Couldn't make a PDF page."
            return
        }
        let doc = PDFDocument()
        doc.insert(page, at: 0)

        let downloads = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Downloads")
        let filename = "discover_ch04_certificate_\(timestamp()).pdf"
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

private struct Ch4QuizItem {
    let prompt: String
    let options: [String]
    let answer: String
    let explanation: String
}

private struct Ch4AnswerButton: View {
    let label: String
    let state: Scene9_BossQuiz_Ch4.AnswerState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                Spacer()
                if state == .correct {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                } else if state == .wrong {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
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
    }

    private var background: Color {
        switch state {
        case .correct: return .green.opacity(0.14)
        case .wrong:   return .red.opacity(0.12)
        default:       return Color(nsColor: .windowBackgroundColor)
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
            Text("🎓").font(.system(size: 72))
            Text("Certificate of Discovery")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.indigo)
            Text("Chapter 4 — Heat")
                .font(.title3)
            Text("Awarded to a curious learner")
                .font(.body)
                .foregroundStyle(.secondary)
                .padding(.top, 8)
            Text("Final score: \(score) / \(total)")
                .font(.title2.bold())
                .padding(.top, 12)
            Text(Date(), format: .dateTime.day().month().year())
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 16)
        }
        .padding(40)
        .frame(width: 600, height: 420)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(.indigo, lineWidth: 4)
                        .padding(8)
                )
        )
    }
}
