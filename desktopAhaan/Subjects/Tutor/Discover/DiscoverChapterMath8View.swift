import SwiftUI

// Discover Mode — Maths Ch.8 "Working with Fractions".
// Same proven shape as DiscoverChapterMath1View / Math10View: a DiscoverShell
// drives the chrome; each scene is a Big-Sur-safe View with an onComplete
// callback; quick-checks + boss quiz are inline. NEP Ch.8 scope is fraction
// MULTIPLICATION and DIVISION (× whole, × fraction, "of", ÷ by reciprocal).
//
// Namespacing: scene cursor uses discoverScene(108) and markSceneComplete uses
// an "m"-prefixed chapterId ("mch08") so progress stays separate from Science
// Ch.8. See MATHS_BUILD_CHECKPOINT.md.

struct DiscoverChapterMath8View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(108)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Fraction × Whole Number",
        "Fraction × Fraction",
        "“Of” Means Multiply",
        "Dividing by a Fraction",
        "Fractions Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 8 — Working with Fractions",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
        .onAppear {
            let maxIndex = sceneTitles.count - 1
            if currentScene < 0 || currentScene > maxIndex {
                currentScene = max(0, min(currentScene, maxIndex))
            }
        }
    }

    private func sceneBody(_ index: Int) -> AnyView {
        guard index >= 0 && index < sceneBuilders.count else { return AnyView(EmptyView()) }
        return sceneBuilders[index]()
    }

    private var sceneBuilders: [() -> AnyView] {
        [
            { AnyView(MathFractionTimesWholeScene(onComplete: { self.markComplete(0) })) },
            { AnyView(MathFractionTimesFractionScene(onComplete: { score in self.markComplete(1, score: score, max: 1) })) },
            { AnyView(MathFractionOfScene(onComplete: { score in self.markComplete(2, score: score, max: 1) })) },
            { AnyView(MathFractionDivideScene(onComplete: { score in self.markComplete(3, score: score, max: 1) })) },
            { AnyView(MathFractionsBossQuizScene(onComplete: { score in self.markComplete(4, score: score, max: 5) })) }
        ]
    }

    private func markComplete(_ index: Int, score: Int? = nil, max: Int? = nil) {
        dataStore.markSceneComplete(chapterId: "m\(chapter.id)", sceneId: "scene\(index + 1)", score: score, maxScore: max)
        if index < sceneTitles.count - 1 {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 400_000_000)
                advanceDiscoverScene($currentScene, total: sceneTitles.count, reduceMotion: reduceMotion)
            }
        }
    }
}

// MARK: - Scene 1 · Fraction × whole number (visual hook)

private struct MathFractionTimesWholeScene: View {
    let onComplete: () -> Void

    // 3 × (2/5): ten fifths laid out, first six shaded = 6/5 = 1 whole + 1/5.
    private let shadedCount = 6
    private let totalCells = 10

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Fraction × Whole Number")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Multiplying a fraction by a whole number is just repeated addition: 3 × 2/5 means 2/5 + 2/5 + 2/5. Add the shaded fifths and you get 6/5 — one whole and one extra fifth.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                fifthsGrid.padding(.vertical, DesignTokens.Spacing.lg)
                Text("Shortcut: multiply the whole number by the top, keep the bottom — 3 × 2/5 = (3 × 2)/5 = 6/5.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var fifthsGrid: some View {
        VStack(spacing: 6) {
            ForEach(0..<2, id: \.self) { row in
                HStack(spacing: DesignTokens.Spacing.xs) {
                    ForEach(0..<5, id: \.self) { col in
                        let idx = row * 5 + col
                        RoundedRectangle(cornerRadius: 4)
                            .fill(idx < shadedCount
                                  ? Color.compatIndigo.opacity(0.55)
                                  : Color.compatIndigo.opacity(0.08))
                            .overlay(RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(Color.compatIndigo.opacity(0.35), lineWidth: 1))
                            .frame(width: 44, height: 30)
                    }
                }
            }
            Text("6 fifths shaded = 6/5")
                .font(.caption.weight(.semibold))
                .foregroundColor(Color.compatIndigo)
        }
        .frame(maxWidth: 300)
    }
}

// MARK: - Reusable single-question quick-check

private struct MathQuickCheck: View {
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let onComplete: (Int) -> Void

    @State private var selected: Int? = nil

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text(prompt)
                .font(.title3.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.xl)
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
                    .padding(.horizontal, DesignTokens.Spacing.lg).padding(.vertical, DesignTokens.Spacing.md)
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

// MARK: - Scene 2 · Fraction × fraction

private struct MathFractionTimesFractionScene: View {
    let onComplete: (Int) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Fraction × Fraction")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("To multiply two fractions, multiply the tops together and the bottoms together: 2/3 × 3/4 = (2×3)/(3×4) = 6/12, which simplifies to 1/2. Always simplify the answer when you can.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                MathQuickCheck(
                    prompt: "What is 2/3 × 3/4 (simplified)?",
                    options: ["1/2", "6/7", "5/7", "6/12"],
                    correctIndex: 0,
                    onComplete: onComplete
                )
                .padding(.top, DesignTokens.Spacing.sm)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Scene 3 · "Of" means multiply

private struct MathFractionOfScene: View {
    let onComplete: (Int) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("“Of” Means Multiply")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("In maths, “of” is a multiply sign in disguise. Half of 10 is 1/2 × 10 = 5. A third of a class of 12 is 1/3 × 12 = 4. Multiplying by a fraction smaller than 1 always makes the number shrink.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                MathQuickCheck(
                    prompt: "What is 1/3 of 12?",
                    options: ["4", "36", "9", "3"],
                    correctIndex: 0,
                    onComplete: onComplete
                )
                .padding(.top, DesignTokens.Spacing.sm)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Scene 4 · Dividing by a fraction

private struct MathFractionDivideScene: View {
    let onComplete: (Int) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Dividing by a Fraction")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Dividing by a fraction means asking “how many of these fit?” To do it, flip the second fraction (its reciprocal) and multiply: 3/4 ÷ 1/2 = 3/4 × 2/1 = 6/4 = 3/2. Dividing by a number smaller than 1 makes the answer bigger.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                MathQuickCheck(
                    prompt: "What is 3/4 ÷ 1/2?",
                    options: ["3/2", "3/8", "2/3", "6"],
                    correctIndex: 0,
                    onComplete: onComplete
                )
                .padding(.top, DesignTokens.Spacing.sm)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Scene 5 · Boss quiz (5-question sequence)

private struct MathFractionsBossQuizScene: View {
    let onComplete: (Int) -> Void

    private struct QA { let prompt: String; let options: [String]; let correct: Int }
    private let questions = [
        QA(prompt: "What is 4 × 3/5?", options: ["12/5", "7/5", "12/25", "4/5"], correct: 0),
        QA(prompt: "What is 1/2 × 1/3?", options: ["1/6", "2/5", "1/5", "2/6"], correct: 0),
        QA(prompt: "What is 1/4 of 20?", options: ["5", "4", "80", "16"], correct: 0),
        QA(prompt: "What is 1/2 ÷ 1/4?", options: ["2", "1/8", "1/2", "8"], correct: 0),
        QA(prompt: "When you multiply 8 by 3/4, the answer is…", options: ["less than 8", "more than 8", "equal to 8", "exactly 12"], correct: 0)
    ]

    @State private var index = 0
    @State private var score = 0
    @State private var selected: Int? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Fractions Boss Quiz")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
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
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private func questionCard(_ q: QA) -> some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text(q.prompt)
                .font(.title3.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.xl)
            ForEach(q.options.indices, id: \.self) { i in
                Button {
                    guard selected == nil else { return }
                    selected = i
                    if i == q.correct { score += 1 }
                } label: {
                    Text(q.options[i])
                        .font(.body.weight(.medium))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .padding(.horizontal, DesignTokens.Spacing.lg).padding(.vertical, DesignTokens.Spacing.md)
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
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("You scored \(score) / \(questions.count)")
                .font(.title2.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text(score == questions.count ? "Perfect — you've mastered multiplying and dividing fractions!" : "Great effort — remember: × tops and bottoms, ÷ flip-and-multiply. Try again any time.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.xl)
            GotItButton(action: { onComplete(score) }).padding(.top, 6)
        }
    }

    private func optionFill(_ i: Int, _ q: QA) -> Color {
        guard let s = selected else { return Color.compatIndigo.opacity(0.08) }
        if i == q.correct { return Color.green.opacity(0.18) }
        if i == s { return Color.red.opacity(0.15) }
        return Color.compatIndigo.opacity(0.05)
    }
}
