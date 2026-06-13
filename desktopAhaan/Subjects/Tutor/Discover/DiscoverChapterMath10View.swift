import SwiftUI

// Discover Mode — Maths Ch.10 "Operations with Integers" (pilot).
// Modelled on DiscoverChapter1View: a DiscoverShell drives the chrome,
// each scene is a simple Big-Sur-safe View with an onComplete callback.
//
// Namespacing note: Maths chapter ids (ch10) collide with Science's, so the
// scene cursor uses discoverScene(100 + number) and markSceneComplete uses an
// "m"-prefixed chapterId ("mch10") to keep Discover progress separate from
// Science's Ch.10. See MATHS_BUILD_CHECKPOINT.md.

struct DiscoverChapterMath10View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(110)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Meet the Number Line",
        "Adding Integers",
        "The Sign Rules",
        "Integer Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 10 — Operations with Integers",
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
            { AnyView(MathNumberLineScene(onComplete: { self.markComplete(0) })) },
            { AnyView(MathAddIntegersScene(onComplete: { score in self.markComplete(1, score: score, max: 1) })) },
            { AnyView(MathSignRulesScene(onComplete: { score in self.markComplete(2, score: score, max: 1) })) },
            { AnyView(MathIntegerBossQuizScene(onComplete: { score in self.markComplete(3, score: score, max: 4) })) }
        ]
    }

    private func markComplete(_ index: Int, score: Int? = nil, max: Int? = nil) {
        dataStore.markSceneComplete(chapterId: "m\(chapter.id)", sceneId: "scene\(index + 1)", score: score, maxScore: max)
        if index < sceneTitles.count - 1 {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: DiscoverTiming.settleDelayNs)
                advanceDiscoverScene($currentScene, total: sceneTitles.count, reduceMotion: reduceMotion)
            }
        }
    }
}

// MARK: - Scene 1 · Number line

private struct MathNumberLineScene: View {
    let onComplete: () -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Meet the Number Line")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Every integer has a home on the number line. Zero sits in the middle, positives stretch to the right, negatives to the left. Moving right adds; moving left subtracts.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                numberLine
                    .padding(.vertical, 18)
                Text("The further right a number sits, the bigger it is — so −2 is greater than −5, even though 5 looks bigger than 2.")
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

    private var numberLine: some View {
        let marks = Array(-5...5)
        return VStack(spacing: 6) {
            Rectangle()
                .fill(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.5))
                .frame(height: 2)
                .frame(maxWidth: 360)
            HStack(spacing: 0) {
                ForEach(marks.indices, id: \.self) { i in
                    let n = marks[i]
                    VStack(spacing: DesignTokens.Spacing.xs) {
                        Circle()
                            .fill(n == 0 ? Color.compatIndigo : DesignTokens.BrandColor.canvasTextSecondary.opacity(0.6))
                            .frame(width: n == 0 ? 12 : 8, height: n == 0 ? 12 : 8)
                        Text("\(n)")
                            .font(.caption.weight(n == 0 ? .bold : .regular))
                            .foregroundColor(n == 0 ? Color.compatIndigo : DesignTokens.BrandColor.canvasText)
                    }
                    .frame(width: 32)
                }
            }
            .frame(maxWidth: 360)
        }
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
                    .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).fill(optionFill(i)))
                    .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).strokeBorder(Color.compatIndigo.opacity(0.3), lineWidth: 1))
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

// MARK: - Scene 2 · Adding integers

private struct MathAddIntegersScene: View {
    let onComplete: (Int) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Adding Integers")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Same signs add and keep the sign: (+5) + (+3) = +8. Opposite signs cancel in pairs, and the bigger side wins: (+5) + (−3) = +2. Think of money — a deposit plus a smaller withdrawal still leaves you ahead.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                MathQuickCheck(
                    prompt: "What is (−5) + 3?",
                    options: ["−2", "2", "−8", "8"],
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

// MARK: - Scene 3 · Sign rules

private struct MathSignRulesScene: View {
    let onComplete: (Int) -> Void

    private let rules = [("+ × +", "+"), ("+ × −", "−"), ("− × +", "−"), ("− × −", "+")]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("The Sign Rules")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("When you multiply integers, the sizes multiply and the sign follows two rules: same signs make a positive, different signs make a negative.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                rulesGrid.padding(.vertical, 10)
                MathQuickCheck(
                    prompt: "What is (−4) × (−2)?",
                    options: ["−8", "8", "−6", "6"],
                    correctIndex: 1,
                    onComplete: onComplete
                )
                .padding(.top, DesignTokens.Spacing.xs)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var rulesGrid: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            ForEach(rules.indices, id: \.self) { i in
                HStack(spacing: 14) {
                    Text(rules[i].0)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Image(systemName: SFSymbolCompat.name("arrow.right"))
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    Text(rules[i].1 == "+" ? "positive" : "negative")
                        .font(.body.weight(.medium))
                        .foregroundColor(rules[i].1 == "+" ? .green : .red)
                }
                .padding(.horizontal, 18).padding(.vertical, DesignTokens.Spacing.sm)
                .frame(maxWidth: 300)
                .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).fill(Color.compatIndigo.opacity(0.06)))
            }
        }
    }
}

// MARK: - Scene 4 · Boss quiz (3-question sequence)

private struct MathIntegerBossQuizScene: View {
    let onComplete: (Int) -> Void

    private struct QA { let prompt: String; let options: [String]; let correct: Int }
    private let questions = [
        QA(prompt: "(−8) + (+5) = ?", options: ["−3", "3", "−13", "13"], correct: 0),
        QA(prompt: "5 − (−3) = ?", options: ["2", "8", "−8", "−2"], correct: 1),
        QA(prompt: "(−6) × 3 = ?", options: ["18", "−18", "−9", "9"], correct: 1),
        QA(prompt: "(−12) ÷ (−4) = ?", options: ["−3", "3", "−8", "8"], correct: 1)
    ]

    @State private var index = 0
    @State private var score = 0
    @State private var selected: Int? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Integer Boss Quiz")
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
                        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).fill(optionFill(i, q)))
                        .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).strokeBorder(Color.compatIndigo.opacity(0.3), lineWidth: 1))
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
            Text(score == questions.count ? "Perfect — you've mastered integer operations!" : "Great effort — revisit the sign rules and try again any time.")
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
