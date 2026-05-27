import SwiftUI

// Discover Mode — Maths Ch.3 "A Peek Beyond the Point". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(103); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath3View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(103)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["Beyond the Point", "Decimal Place Value", "Comparing Decimals", "What a Tenth Means", "Decimals Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 3 — A Peek Beyond the Point",
            sceneTitles: sceneTitles, currentScene: $currentScene, scene: sceneBody
        )
        .onAppear {
            let maxIndex = sceneTitles.count - 1
            if currentScene < 0 || currentScene > maxIndex { currentScene = max(0, min(currentScene, maxIndex)) }
        }
    }

    private func sceneBody(_ index: Int) -> AnyView {
        guard index >= 0 && index < sceneBuilders.count else { return AnyView(EmptyView()) }
        return sceneBuilders[index]()
    }

    private var sceneBuilders: [() -> AnyView] {
        [
            { AnyView(MathDiscoverInfoScene(title: "Beyond the Point", paragraphs: ["When one whole isn't enough detail, we split it into ten equal parts — tenths (0.1) — and split each tenth into ten again — hundredths (0.01).", "The decimal point separates whole units on the left from these smaller fraction-parts on the right. Each step right is ten times smaller."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "Decimal Place Value", intro: "The first digit after the point is tenths; the second is hundredths.", prompt: "What is the place value of 7 in 4.07?", options: ["7 hundredths", "7 tenths", "7 ones", "7 tens"], correctIndex: 0, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Comparing Decimals", intro: "Line up the points and compare place by place — 0.5 is five tenths, bigger than four tenths.", prompt: "Which is larger: 0.5 or 0.45?", options: ["0.5", "0.45", "They are equal", "Cannot tell"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "What a Tenth Means", intro: "0.1 is one part when a whole is cut into ten equal pieces.", prompt: "0.1 means one part out of how many?", options: ["10", "100", "1", "1000"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "Decimals Boss Quiz", questions: [MathDiscoverBossQA(prompt: "Write 'three tenths' as a decimal.", options: ["0.3", "0.03", "3.0", "0.13"], correct: 0), MathDiscoverBossQA(prompt: "What is 0.6 + 0.3?", options: ["0.9", "0.09", "0.63", "9"], correct: 0), MathDiscoverBossQA(prompt: "Which is the same value as 0.50?", options: ["0.5", "0.05", "5.0", "0.005"], correct: 0), MathDiscoverBossQA(prompt: "How is 0.25 read?", options: ["Twenty-five hundredths", "Twenty-five tenths", "Two and five", "25 ones"], correct: 0), MathDiscoverBossQA(prompt: "What is 1.0 − 0.4?", options: ["0.6", "0.4", "1.4", "0.96"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
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
