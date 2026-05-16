import SwiftUI
import AppKit
import PDFKit

/// Scene 9 — Boss Quiz Ch3. Five MCQs at kid level, hand-authored.
/// Right answer flashes green + sparkles; wrong answer red-shakes.
/// After all 5, confetti + score + "Print my certificate" button (saves PDF to ~/Downloads).
struct Scene9_BossQuiz_Ch3: View {
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

    private var quiz: [Ch3QuizItem] {
        [
            Ch3QuizItem(
                prompt: "Which animal gives us cashmere wool?",
                options: ["Sheep", "Goat", "Alpaca", "Camel"],
                answer: "Goat",
                explanation: "Cashmere goats produce the most luxurious wool, especially those in the Himalayas."
            ),
            Ch3QuizItem(
                prompt: "What process removes grease from raw fleece?",
                options: ["Dyeing", "Scouring", "Carding", "Spinning"],
                answer: "Scouring",
                explanation: "Scouring uses warm water and detergent to wash out grease, dirt, and debris."
            ),
            Ch3QuizItem(
                prompt: "How many days does a silkworm spend as a larva?",
                options: ["10", "15", "25", "35"],
                answer: "25",
                explanation: "A silkworm caterpillar eats mulberry leaves for about 25-28 days before spinning its cocoon."
            ),
            Ch3QuizItem(
                prompt: "Which is a synthetic fibre?",
                options: ["Cotton", "Wool", "Polyester", "Silk"],
                answer: "Polyester",
                explanation: "Polyester is made from petroleum. Cotton, wool, and silk are natural fibres."
            ),
            Ch3QuizItem(
                prompt: "Wool sorters used to catch what disease from infected fleece?",
                options: ["Measles", "Anthrax", "Polio", "Malaria"],
                answer: "Anthrax",
                explanation: "Sorter's disease (anthrax) is caused by spores in raw fleece. Modern safety prevents this."
            )
        ]
    }

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
                        Ch3AnswerButton(
                            label: opt,
                            state: state(for: opt, in: item)
                        ) {
                            pick(opt, in: item)
                        }
                    }
                }
                .frame(maxWidth: 600)

                Spacer()
            } else {
                VStack(spacing: 20) {
                    ZStack {
                        Text("🎉")
                            .font(.system(size: 80))
                    }
                    .frame(height: 120)

                    VStack(spacing: 8) {
                        Text("Quiz Complete!")
                            .font(.headline)
                            .foregroundColor(.green)
                        Text("You scored \(score) / 5")
                            .font(.title2.weight(.bold))
                            .foregroundColor(Color.compatIndigo)
                    }

                    Button {
                        generateCertificate()
                    } label: {
                        Label("🎓 Print my certificate", systemImage: "printer")
                            .frame(maxWidth: .infinity)
                    }
                    
                    .accentColor(.green)

                    if let status = pdfStatus {
                        Text(status)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
            }

            GotItButton {
                if !done {
                    Task { @MainActor in
                        try? await Task.sleep(nanoseconds: 300_000_000)
                        onComplete(score)
                    }
                }
            }
            .padding(.bottom, 12)
        }
    }

    // MARK: - Quiz Logic

    private func state(for option: String, in item: Ch3QuizItem) -> Ch3AnswerButtonState {
        guard let picked = picks[currentQ] else { return .normal }

        if picked == option {
            if option == item.answer {
                return .correct
            } else {
                return .incorrect
            }
        }

        if revealed[currentQ] && option == item.answer {
            return .revealed
        }

        return .normal
    }

    private func pick(_ option: String, in item: Ch3QuizItem) {
        guard picks[currentQ] == nil else { return }

        picks[currentQ] = option

        if option == item.answer {
            score += 1
            withAnimation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.5)) {
                // Correct
            }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 800_000_000)
                advance()
            }
        } else {
            Task { @MainActor in
                withAnimation(.easeInOut(duration: 0.3)) {
                    shake = -6
                }
                try? await Task.sleep(nanoseconds: 150_000_000)
                withAnimation(.easeInOut(duration: 0.3)) {
                    shake = 6
                }
                try? await Task.sleep(nanoseconds: 150_000_000)
                withAnimation(.easeInOut(duration: 0.3)) {
                    shake = 0
                }
                try? await Task.sleep(nanoseconds: 500_000_000)
                revealed[currentQ] = true
            }
        }
    }

    private func advance() {
        if currentQ < 4 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentQ += 1
            }
        } else {
            withAnimation(.easeInOut(duration: 0.4)) {
                done = true
                celebrate = true
            }
        }
    }

    private func generateCertificate() {
        guard let image = renderViewToImage(certificateView(), size: CGSize(width: 600, height: 400)),
              let pdfPage = PDFPage(image: image) else {
            pdfStatus = "Couldn't render certificate."
            return
        }
        let pdf = PDFDocument()
        pdf.insert(pdfPage, at: 0)

        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        let downloadsDir = homeDir.appendingPathComponent("Downloads")
        let filename = "FibreFabric_Certificate_\(DateFormatter.certificateDateFormat().string(from: Date())).pdf"
        let fileURL = downloadsDir.appendingPathComponent(filename)

        if pdf.write(to: fileURL) {
            pdfStatus = "✓ Saved to Downloads!"
        } else {
            pdfStatus = "Error saving PDF"
        }
    }

    @ViewBuilder
    private func certificateView() -> some View {
        VStack(spacing: 20) {
            Text("🎓 Certificate of Completion 🎓")
                .font(.title.bold())
            Text("Fibre to Fabric")
                .font(.headline)
            Divider()
            Text("Presented to a brilliant learner")
                .font(.body)
            Text("for completing the Discover Mode experience")
                .font(.caption)
            Text("and scoring \(score) / 5 on the Boss Quiz")
                .font(.caption.weight(.semibold))
            Text(Date(), style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(40)
        .frame(width: 600, height: 400)
        .background(
            LinearGradient(
                colors: [Color.compatIndigo.opacity(0.1), .purple.opacity(0.1)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .border(Color.compatIndigo, width: 3)
    }
}

// MARK: - Answer Button

private struct Ch3AnswerButton: View {
    let label: String
    let state: Ch3AnswerButtonState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .frame(maxWidth: .infinity)
                .padding(14)
                .background(backgroundColor())
                .foregroundColor(.primary)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(borderColor(), lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
        .disabled(state != .normal)
    }

    private func backgroundColor() -> Color {
        switch state {
        case .normal: return .gray.opacity(0.05)
        case .correct: return .green.opacity(0.2)
        case .incorrect: return .red.opacity(0.2)
        case .revealed: return .yellow.opacity(0.2)
        }
    }

    private func borderColor() -> Color {
        switch state {
        case .normal: return .clear
        case .correct: return .green
        case .incorrect: return .red
        case .revealed: return .yellow
        }
    }
}

enum Ch3AnswerButtonState {
    case normal, correct, incorrect, revealed
}

// MARK: - Quiz Item

private struct Ch3QuizItem {
    let prompt: String
    let options: [String]
    let answer: String
    let explanation: String
}

// MARK: - Helpers

extension DateFormatter {
    static func certificateDateFormat() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
