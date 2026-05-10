import SwiftUI
import SwiftData

/// Renders a single question with: prompt, collapsible solution, common
/// mistakes, and 2+ variations (each with its own answer + steps).
struct QuestionDetailView: View {
    let pack: SubjectPack
    let question: Question

    @State private var revealSolution = false
    @State private var typedAnswer = ""
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                promptCard
                if let opts = question.options, !opts.isEmpty {
                    optionsList(opts)
                }
                userAnswerField
                solutionDisclosure
                commonMistakesCard
                variationsSection
            }
            .padding(20)
            .frame(maxWidth: 820, alignment: .leading)
        }
        .navigationTitle("Question")
    }

    // MARK: - Sections

    private var header: some View {
        HStack(spacing: 12) {
            Label(question.questionType.displayName, systemImage: "questionmark.app.fill")
                .font(.caption.bold())
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(.indigo.opacity(0.15), in: Capsule())
            QuestionDifficultyBadge(level: question.difficulty)
            Spacer()
            if !question.pageRefs.isEmpty {
                Text("p. \(question.pageRefs.map(String.init).joined(separator: ", "))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var promptCard: some View {
        Text(question.prompt)
            .font(.title3)
            .lineSpacing(4)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.background.secondary, in: RoundedRectangle(cornerRadius: 14))
    }

    private func optionsList(_ options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Options").font(.caption).foregroundStyle(.secondary).textCase(.uppercase)
            ForEach(Array(options.enumerated()), id: \.offset) { idx, opt in
                HStack {
                    Text("\(["A","B","C","D","E","F"][safe: idx] ?? "?").")
                        .font(.body.bold())
                        .frame(width: 22, alignment: .leading)
                        .foregroundStyle(.indigo)
                    Text(opt).font(.body)
                    Spacer()
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(.background.secondary, in: RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    private var userAnswerField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Try it yourself").font(.caption).foregroundStyle(.secondary).textCase(.uppercase)
            HStack(spacing: 8) {
                TextField("Type your answer", text: $typedAnswer)
                    .textFieldStyle(.roundedBorder)
                Button("Check") { recordAttempt() }
                    .buttonStyle(.borderedProminent)
                    .disabled(typedAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }

    private var solutionDisclosure: some View {
        DisclosureGroup(isExpanded: $revealSolution) {
            VStack(alignment: .leading, spacing: 10) {
                Text(question.answer)
                    .font(.body.bold())
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
                ForEach(Array(question.solutionSteps.enumerated()), id: \.offset) { idx, step in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(idx + 1).")
                            .font(.body.bold())
                            .foregroundStyle(.indigo)
                            .frame(width: 22, alignment: .trailing)
                        Text(step)
                            .font(.body)
                            .lineSpacing(3)
                    }
                }
            }
            .padding(.top, 6)
        } label: {
            Label("Show worked solution", systemImage: "lightbulb.fill")
                .font(.headline)
        }
        .padding(16)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder
    private var commonMistakesCard: some View {
        if !question.commonMistakes.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Label("Common mistakes", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline)
                ForEach(Array(question.commonMistakes.enumerated()), id: \.offset) { _, m in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                        Text(m).font(.callout).lineSpacing(3)
                    }
                }
            }
            .padding(16)
            .background(.red.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
        }
    }

    @ViewBuilder
    private var variationsSection: some View {
        if !question.variations.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Label("Now try these variations", systemImage: "arrow.triangle.branch")
                    .font(.headline)
                ForEach(question.variations) { v in
                    VariationCard(variation: v)
                }
            }
        }
    }

    // MARK: - Actions

    private func recordAttempt() {
        let normalizedUser = typedAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let normalizedTruth = question.answer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let isCorrect = !normalizedUser.isEmpty &&
            (normalizedUser == normalizedTruth || normalizedTruth.contains(normalizedUser))

        modelContext.insert(QuestionAttempt(
            subjectPackId: pack.id,
            questionId: question.id,
            userAnswer: typedAnswer,
            isCorrect: isCorrect
        ))
        do { try modelContext.save() }
        catch { print("[QuestionDetailView] attempt save failed: \(error)") }
        revealSolution = true
    }
}

// MARK: - DifficultyBadge

struct QuestionDifficultyBadge: View {
    let level: Int
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= level ? "circle.fill" : "circle")
                    .font(.caption2)
                    .foregroundStyle(i <= level ? color : .secondary.opacity(0.4))
            }
        }
        // Otherwise VoiceOver reads "circle.fill, circle.fill, circle, circle, circle".
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Difficulty \(level) of 5")
    }
    private var color: Color {
        switch level {
        case 1...2: return .green
        case 3:     return .yellow
        default:    return .orange
        }
    }
}

// MARK: - VariationCard

private struct VariationCard: View {
    let variation: QuestionVariation
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            DisclosureGroup(isExpanded: $expanded) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(variation.answer)
                        .font(.body.bold())
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 6))
                    ForEach(Array(variation.solutionSteps.enumerated()), id: \.offset) { idx, step in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(idx + 1).").font(.callout.bold()).foregroundStyle(.indigo)
                            Text(step).font(.callout).lineSpacing(3)
                        }
                    }
                }
                .padding(.top, 4)
            } label: {
                Text(variation.prompt)
                    .font(.body)
                    .lineSpacing(3)
            }
        }
        .padding(14)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Array safe-index helper (private)

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
