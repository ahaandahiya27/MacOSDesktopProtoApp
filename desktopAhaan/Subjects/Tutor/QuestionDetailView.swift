import SwiftUI

struct QuestionDetailView: View {
    let pack: SubjectPack
    let question: Question

    @State private var revealSolution = false
    @State private var typedAnswer = ""
    @EnvironmentObject var dataStore: DataStore

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
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle(String(question.prompt.prefix(50)))
    }

    // MARK: - Sections

    private var header: some View {
        HStack(spacing: 12) {
            Label(question.questionType.displayName, systemImage: "questionmark.app.fill")
                .font(.caption.bold())
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
            QuestionDifficultyBadge(level: question.difficulty)
            Spacer()
            if !question.pageRefs.isEmpty {
                Text("p. \(question.pageRefs.map(String.init).joined(separator: ", "))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var promptCard: some View {
        Text(question.prompt)
            .font(.title3)
            .lineSpacing(4)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.1))
            )
    }

    private func optionsList(_ options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Options").font(.caption).foregroundColor(.secondary).textCase(.uppercase)
            ForEach(Array(options.enumerated()), id: \.offset) { idx, opt in
                HStack {
                    Text("\(["A","B","C","D","E","F"][safe: idx] ?? "?").")
                        .font(.body.bold())
                        .frame(width: 22, alignment: .leading)
                        .foregroundColor(Color.compatIndigo)
                    Text(opt).font(.body)
                    Spacer()
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                )
            }
        }
    }

    private var userAnswerField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Try it yourself").font(.caption).foregroundColor(.secondary).textCase(.uppercase)
            HStack(spacing: 8) {
                TextField("Type your answer", text: $typedAnswer, onCommit: { recordAttempt() })
                    .textFieldStyle(.roundedBorder)
                Button("Check") { recordAttempt() }
                    .disabled(typedAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }

    private var solutionDisclosure: some View {
        ExpandableCard(
            isExpanded: $revealSolution,
            systemImage: "lightbulb.fill",
            title: "Show worked solution"
        ) {
            VStack(alignment: .leading, spacing: 10) {
                Text(question.answer)
                    .font(.body.bold())
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.12)))
                ForEach(Array(question.solutionSteps.enumerated()), id: \.offset) { idx, step in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(idx + 1).")
                            .font(.body.bold())
                            .foregroundColor(Color.compatIndigo)
                            .frame(width: 22, alignment: .trailing)
                        Text(step)
                            .font(.body)
                            .lineSpacing(3)
                    }
                }
            }
        }
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
                            .foregroundColor(.red)
                        Text(m).font(.callout).lineSpacing(3)
                    }
                }
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color.red.opacity(0.08)))
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

        dataStore.insertAttempt(QuestionAttempt(
            subjectPackId: pack.id,
            questionId: question.id,
            userAnswer: typedAnswer,
            isCorrect: isCorrect
        ))
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
                    .foregroundColor(i <= level ? color : .secondary.opacity(0.4))
            }
        }
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
        ExpandableCard(
            isExpanded: $expanded,
            systemImage: "arrow.triangle.branch",
            title: variation.prompt,
            tint: Color.compatIndigo
        ) {
            VStack(alignment: .leading, spacing: 8) {
                Text(variation.answer)
                    .font(.body.bold())
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.green.opacity(0.12)))
                ForEach(Array(variation.solutionSteps.enumerated()), id: \.offset) { idx, step in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(idx + 1).").font(.callout.bold()).foregroundColor(Color.compatIndigo)
                        Text(step).font(.callout).lineSpacing(3)
                    }
                }
            }
        }
    }
}

// MARK: - Array safe-index helper (private)

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
