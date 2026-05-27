import SwiftUI

// Shared Discover-Mode building blocks for the Maths chapter build-out
// (2026-05-27): Ch.2-7, 9, 11-15. Ch.1/8/10 predate this and keep their own
// inline copies — these generics let the remaining 12 chapters ship a complete
// 5-scene experience (info hook + 3 quick-checks + boss quiz) without 388 LOC
// of duplication each. All Big-Sur-safe: plain Buttons, no macOS 12+ APIs,
// RM-gated motion inherited from GotItButton / advanceDiscoverScene.

// MARK: - Single-question quick-check

struct MathDiscoverQuickCheck: View {
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let onComplete: (Int) -> Void

    @State private var selected: Int? = nil

    var body: some View {
        VStack(spacing: 12) {
            Text(prompt)
                .font(.title3.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            ForEach(options.indices, id: \.self) { i in
                Button {
                    if selected == nil { selected = i }
                } label: {
                    HStack {
                        Text(options[i])
                            .font(.body.weight(.medium))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                        if selected != nil && i == correctIndex {
                            Image(systemName: SFSymbolCompat.name("checkmark.circle.fill"))
                                .foregroundColor(.green)
                        } else if selected == i {
                            Image(systemName: SFSymbolCompat.name("xmark.circle.fill"))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 16).padding(.vertical, 12)
                    .frame(maxWidth: 320)
                    .background(RoundedRectangle(cornerRadius: 10).fill(optionFill(i)))
                    .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.compatIndigo.opacity(0.3), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .pointingCursor()
                .disabled(selected != nil)
            }
            if selected != nil {
                GotItButton(action: { onComplete(selected == correctIndex ? 1 : 0) })
                    .padding(.top, 6)
            }
        }
    }

    private func optionFill(_ i: Int) -> Color {
        guard let s = selected else { return Color.compatIndigo.opacity(0.08) }
        if i == correctIndex { return Color.green.opacity(0.18) }
        if i == s { return Color.red.opacity(0.15) }
        return Color.compatIndigo.opacity(0.05)
    }
}

// MARK: - Text-only explanation scene (visual hook / concept intro)

struct MathDiscoverInfoScene: View {
    let title: String
    let paragraphs: [String]
    let onComplete: () -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 18)
                    .padding(.horizontal, 24)
                ForEach(paragraphs.indices, id: \.self) { i in
                    Text(paragraphs[i])
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .padding(.horizontal, 24)
                }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Intro text + one quick-check

struct MathDiscoverQuickScene: View {
    let title: String
    let intro: String
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let onComplete: (Int) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 18)
                    .padding(.horizontal, 24)
                Text(intro)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                MathDiscoverQuickCheck(
                    prompt: prompt, options: options,
                    correctIndex: correctIndex, onComplete: onComplete
                )
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Generic boss-quiz scene (multi-question sequence)

struct MathDiscoverBossQA {
    let prompt: String
    let options: [String]
    let correct: Int
}

struct MathDiscoverBossQuizScene: View {
    let title: String
    let questions: [MathDiscoverBossQA]
    let onComplete: (Int) -> Void

    @State private var index = 0
    @State private var score = 0
    @State private var selected: Int? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 18)
                Text("Question \(min(index + 1, questions.count)) of \(questions.count) · Score \(score)")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                if index < questions.count {
                    questionCard(questions[index])
                } else {
                    finishCard
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private func questionCard(_ q: MathDiscoverBossQA) -> some View {
        VStack(spacing: 12) {
            Text(q.prompt)
                .font(.title3.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            ForEach(q.options.indices, id: \.self) { i in
                Button {
                    guard selected == nil else { return }
                    selected = i
                    if i == q.correct { score += 1 }
                } label: {
                    Text(q.options[i])
                        .font(.body.weight(.medium))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .padding(.horizontal, 16).padding(.vertical, 12)
                        .frame(maxWidth: 300)
                        .background(RoundedRectangle(cornerRadius: 10).fill(optionFill(i, q)))
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.compatIndigo.opacity(0.3), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .pointingCursor()
                .disabled(selected != nil)
            }
            if selected != nil {
                Button {
                    selected = nil
                    index += 1
                } label: {
                    Text(index == questions.count - 1 ? "Finish" : "Next")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 22).padding(.vertical, 10)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain)
                .pointingCursor()
                .padding(.top, 6)
            }
        }
    }

    private var finishCard: some View {
        VStack(spacing: 12) {
            Text("You scored \(score) / \(questions.count)")
                .font(.title2.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text(score == questions.count ? "Perfect — chapter mastered!" : "Great effort — revisit the scenes and try again any time.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            GotItButton(action: { onComplete(score) }).padding(.top, 6)
        }
    }

    private func optionFill(_ i: Int, _ q: MathDiscoverBossQA) -> Color {
        guard let s = selected else { return Color.compatIndigo.opacity(0.08) }
        if i == q.correct { return Color.green.opacity(0.18) }
        if i == s { return Color.red.opacity(0.15) }
        return Color.compatIndigo.opacity(0.05)
    }
}
