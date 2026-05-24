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
    @State private var picks: [String?] = Array(repeating: nil, count: 15)
    @State private var score: Int = 0
    @State private var revealed: [Bool] = Array(repeating: false, count: 15)
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
        ),
            Ch1QuizItem(
                prompt: "Photosynthesis needs water, sunlight, chlorophyll and which gas?",
                options: ["Oxygen", "Nitrogen", "Carbon dioxide", "Helium"],
                answer: "Carbon dioxide",
                explanation: "Plants pull in CO₂ through stomata; with water and light energy they make glucose and release O₂."
            ),
            Ch1QuizItem(
                prompt: "A mushroom growing on a rotting log is an example of a:",
                options: ["Producer", "Saprotroph", "Parasite", "Carnivore"],
                answer: "Saprotroph",
                explanation: "Saprotrophs feed on dead and decaying matter — they help nature recycle."
            ),
            Ch1QuizItem(
                prompt: "Leguminous plants like pea and gram enrich soil with nitrogen because:",
                options: ["Their leaves smell of nitrogen", "Rhizobium bacteria in their root nodules fix nitrogen", "They drink nitrogen from clouds", "They are insectivorous"],
                answer: "Rhizobium bacteria in their root nodules fix nitrogen",
                explanation: "Farmers grow pulses between crops to put nitrogen back into the soil — a free fertiliser."
            ),
            Ch1QuizItem(
                prompt: "A lichen is a partnership between:",
                options: ["Two plants", "Two animals", "A fungus and an alga", "A fungus and a bacterium only"],
                answer: "A fungus and an alga",
                explanation: "The alga makes food by photosynthesis; the fungus gives shelter and water. Both gain — mutualism."
            ),
            Ch1QuizItem(
                prompt: "Plants store excess food made in leaves mostly as:",
                options: ["Salt", "Starch", "Sand", "Oxygen"],
                answer: "Starch",
                explanation: "Test a leaf with iodine — it turns blue-black where starch is stored."
            ),
        Ch1QuizItem(
            prompt: "Van Helmont grew a willow sapling from 2 kg to 76 kg over five years. The soil weighed almost the same at the end. Where did the extra mass come from?",
            options: ["From the water alone", "From CO\u{2082} in the air", "From the pot itself", "From sunlight directly"],
            answer: "From CO\u{2082} in the air",
            explanation: "Trees pull carbon out of the air through photosynthesis. Most of the dry mass of a tree was once a gas."
        ),
        Ch1QuizItem(
            prompt: "Jagdish Chandra Bose became famous for inventing the crescograph, which proved that:",
            options: ["Plants make their own food", "Plants respond to stimuli like animals do", "Plants have DNA", "Plants are made of cells"],
            answer: "Plants respond to stimuli like animals do",
            explanation: "Bose's machine magnified plant movement 10,000\u{00D7}, showing that plants react to light, heat and touch."
        ),
        Ch1QuizItem(
            prompt: "Chlorophyll (green pigment in plants) and haemoglobin (red pigment in blood) are almost the same molecule. They differ mainly in the metal at their centre. Chlorophyll has magnesium; haemoglobin has:",
            options: ["Copper", "Zinc", "Iron", "Gold"],
            answer: "Iron",
            explanation: "The same ring of atoms with different metals: Mg in chlorophyll, Fe in haemoglobin. That tiny swap changes the colour and the job."
        ),
        Ch1QuizItem(
            prompt: "The sea slug Elysia chlorotica is unusual because it eats algae and then:",
            options: ["Spits the chloroplasts out", "Keeps the chloroplasts alive in its skin and makes its own food", "Turns into a plant", "Stops eating forever"],
            answer: "Keeps the chloroplasts alive in its skin and makes its own food",
            explanation: "It is one of the only animals that can photosynthesise \u{2014} the line between plant and animal blurs."
        ),
        Ch1QuizItem(
            prompt: "Photosynthesis turns roughly what fraction of the sunlight that hits a leaf into stored food?",
            options: ["Almost 100\u{0025}", "About 50\u{0025}", "About 20\u{0025}", "Only 3 to 6\u{0025}"],
            answer: "Only 3 to 6\u{0025}",
            explanation: "Solar panels can reach 20\u{0025}. Photosynthesis is much less efficient \u{2014} but plants do many other things at once."
        )
    ]

    var body: some View {
        // ScrollView + LazyVStack gives the quiz card + answer rows a
        // natural bounded height so the shell footer (Previous / Next)
        // stays reachable even on shorter windows.
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Boss Quiz")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)

                ProgressView(value: Double(currentQ), total: 15)
                    .frame(maxWidth: 520)

                if !done {
                    let item = quiz[currentQ]
                    Text("Question \(currentQ + 1) of 15")
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
                        Button(currentQ < 14 ? "Next question" : "See my score") {
                            advance()
                        }

                        .accentColor(Color.compatIndigo)
                    }
                } else {
                    completionView
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
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
        // SRS write-through: capture the answer at the same instant
        // we record it for the score. Format pinned by
        // BossQuizSRSWiringTests; `bossquiz_chNN_qII` is the stable
        // id every chapter's wiring emits. First-try correct → .good,
        // wrong → .forgot; the kid can't reattempt within one Boss
        // Quiz session so .hard never fires here. The hint-ladder
        // path (D5) is where .hard lives.
        let ephemeralId = String(
            format: "bossquiz_ch%02d_q%02d", chapter.number, currentQ
        )
        DataStore.shared.recordEphemeralReview(
            ephemeralId: ephemeralId,
            quality: isRight ? .good : .forgot
        )
        if isRight {
            score += 1
            withAnimation(reduceMotion ? nil : .spring()) { revealed[currentQ] = true }
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
            withAnimation(reduceMotion ? nil : .easeInOut.delay(0.4)) { revealed[currentQ] = true }
        }
    }

    private func advance() {
        if currentQ < 14 {
            withAnimation(reduceMotion ? nil : .easeInOut) { currentQ += 1 }
        } else {
            withAnimation(reduceMotion ? nil : .easeInOut) { done = true; celebrate = true }
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
            Text("Score: \(score) / 15")
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
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
        }
        .frame(maxWidth: 560)
        .padding(20)
    }

    private func saveCertificate() {
        guard let nsImage = renderViewToImage(CertificateView(score: score, total: 15), size: CGSize(width: 600, height: 400)),
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
