import SwiftUI

// Discover Mode — Maths Ch.1 "Large Numbers Around Us".
// Modelled exactly on DiscoverChapterMath10View (the pilot): a DiscoverShell
// drives the chrome; each scene is a Big-Sur-safe View with an onComplete
// callback; content (quick-checks + boss quiz) is inline, same as the pilot.
//
// Namespacing: Maths chapter ids (ch01) collide with Science's, so the scene
// cursor uses discoverScene(100 + number) = discoverScene(101) and
// markSceneComplete uses an "m"-prefixed chapterId ("mch01") to keep Discover
// progress separate from Science Ch.1. See MATHS_BUILD_CHECKPOINT.md.

struct DiscoverChapterMath1View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(101)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Place Value & the Lakh",
        "Indian vs International Commas",
        "Rounding & Approximation",
        "Patterns in Products",
        "Large Numbers Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 1 — Large Numbers Around Us",
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
            { AnyView(MathLakhPlaceValueScene(onComplete: { self.markComplete(0) })) },
            { AnyView(MathIndianCommasScene(onComplete: { score in self.markComplete(1, score: score, max: 1) })) },
            { AnyView(MathRoundingScene(onComplete: { score in self.markComplete(2, score: score, max: 1) })) },
            { AnyView(MathProductDigitsScene(onComplete: { score in self.markComplete(3, score: score, max: 1) })) },
            { AnyView(MathLargeNumbersBossQuizScene(onComplete: { score in self.markComplete(4, score: score, max: 5) })) }
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

// MARK: - Scene 1 · Place value & the lakh (visual hook)

private struct MathLakhPlaceValueScene: View {
    let onComplete: () -> Void

    // One lakh written across its six place-value columns.
    private let columns: [(label: String, digit: String)] = [
        ("Lakh", "1"), ("Ten\nThousand", "0"), ("Thousand", "0"),
        ("Hundred", "0"), ("Ten", "0"), ("One", "0")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Place Value & the Lakh")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("One lakh is written 1,00,000 — a 1 followed by five zeros. Each digit sits in a place worth ten times the place to its right. Slide one place left and the value grows ten-fold.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                placeValueGrid.padding(.vertical, DesignTokens.Spacing.lg)
                Text("The largest 5-digit number is 99,999. Add just 1 and every column rolls over — you land on 1,00,000, the smallest 6-digit number and exactly one lakh.")
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

    private var placeValueGrid: some View {
        HStack(spacing: 6) {
            ForEach(columns.indices, id: \.self) { i in
                VStack(spacing: 6) {
                    Text(columns[i].digit)
                        .font(.title.weight(.bold).monospacedDigit())
                        .foregroundColor(i == 0 ? Color.compatIndigo : DesignTokens.BrandColor.canvasText)
                        .frame(width: 40, height: 48)
                        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                            .fill(i == 0 ? Color.compatIndigo.opacity(0.14) : Color.compatIndigo.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                            .strokeBorder(Color.compatIndigo.opacity(0.3), lineWidth: 1))
                    Text(columns[i].label)
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .frame(width: 44)
                }
            }
        }
        .frame(maxWidth: 360)
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

// MARK: - Scene 2 · Indian vs International commas

private struct MathIndianCommasScene: View {
    let onComplete: (Int) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Indian vs International Commas")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("The Indian system groups digits 3–2–2: thousand, then lakh, then crore (12,34,56,789). The International system groups in threes: thousand, million, billion (123,456,789). Same number, different comma rhythm.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                MathQuickCheck(
                    prompt: "How is 4567890 written with Indian commas?",
                    options: ["45,67,890", "4,567,890", "456,7890", "4,56,7890"],
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

// MARK: - Scene 3 · Rounding & approximation

private struct MathRoundingScene: View {
    let onComplete: (Int) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Rounding & Approximation")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("To round to a place, look at the digit just to its right: 5 or more rounds up, less than 5 rounds down. A crowd of 47,832 is “about 48 thousand” — close enough when an exact count isn't needed.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                MathQuickCheck(
                    prompt: "Round 47,832 to the nearest thousand.",
                    options: ["47,000", "48,000", "47,800", "50,000"],
                    correctIndex: 1,
                    onComplete: onComplete
                )
                .padding(.top, DesignTokens.Spacing.sm)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Scene 4 · Patterns in products

private struct MathProductDigitsScene: View {
    let onComplete: (Int) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Patterns in Products")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("You can guess a product's size before multiplying. A 3-digit number (100–999) times a 2-digit number (10–99) lands somewhere between 100×10 = 1,000 and 999×99 = 98,901 — so the answer has 4 or 5 digits.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                MathQuickCheck(
                    prompt: "A 3-digit number times a 2-digit number gives a product with how many digits?",
                    options: ["exactly 5", "4 or 5", "exactly 4", "always 6"],
                    correctIndex: 1,
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

private struct MathLargeNumbersBossQuizScene: View {
    let onComplete: (Int) -> Void

    private struct QA { let prompt: String; let options: [String]; let correct: Int }
    private let questions = [
        QA(prompt: "How many zeros are in one lakh (1,00,000)?", options: ["4", "5", "6", "3"], correct: 1),
        QA(prompt: "One crore equals how many lakhs?", options: ["10", "100", "1,000", "50"], correct: 1),
        QA(prompt: "What is the smallest 6-digit number?", options: ["1,00,000", "99,999", "10,000", "9,99,999"], correct: 0),
        QA(prompt: "In 3,45,678 what is the place value of the digit 3?", options: ["3,000", "30,000", "3,00,000", "300"], correct: 2),
        QA(prompt: "Round 6,38,500 to the nearest lakh.", options: ["6,00,000", "7,00,000", "6,40,000", "6,38,000"], correct: 0)
    ]

    @State private var index = 0
    @State private var score = 0
    @State private var selected: Int? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Large Numbers Boss Quiz")
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
            Text(score == questions.count ? "Perfect — you've mastered large numbers!" : "Great effort — revisit place value and rounding, then try again any time.")
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
