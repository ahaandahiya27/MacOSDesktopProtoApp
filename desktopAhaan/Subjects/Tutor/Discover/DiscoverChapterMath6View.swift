import SwiftUI

// Discover Mode — Maths Ch.6 "Number Play". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(106); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath6View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(106)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["Numbers That Play", "Fibonacci Numbers", "Parity Rules", "Square Numbers", "Number Play Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 6 — Number Play",
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
            { AnyView(MathDiscoverInfoScene(title: "Numbers That Play", paragraphs: ["Numbers hide patterns. The Virahāṅka–Fibonacci sequence adds the two before it: 1, 1, 2, 3, 5, 8, 13… Parity (even/odd) follows tidy rules, and square numbers (1, 4, 9, 16, 25…) grow in a steady pattern.", "Spotting a pattern lets you predict the next number without starting over."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "Fibonacci Numbers", intro: "Each term is the sum of the two before it.", prompt: "Fibonacci: 1, 1, 2, 3, 5, 8, … what comes next?", options: ["13", "11", "16", "10"], correctIndex: 0, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Parity Rules", intro: "Odd plus odd is always even (3 + 5 = 8).", prompt: "odd + odd = ?", options: ["Even", "Odd", "Could be either", "Zero"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Square Numbers", intro: "1, 4, 9, 16, 25 … each is a number times itself.", prompt: "Which square number comes after 9 and 16?", options: ["25", "20", "24", "36"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "Number Play Boss Quiz", questions: [MathDiscoverBossQA(prompt: "even + even = ?", options: ["Even", "Odd", "Either", "One"], correct: 0), MathDiscoverBossQA(prompt: "Fibonacci after 5, 8, 13 is?", options: ["21", "18", "26", "20"], correct: 0), MathDiscoverBossQA(prompt: "Is 7 a prime number?", options: ["Yes", "No", "Only sometimes", "It is even"], correct: 0), MathDiscoverBossQA(prompt: "Sum of the first five odd numbers (1+3+5+7+9)?", options: ["25", "20", "24", "15"], correct: 0), MathDiscoverBossQA(prompt: "odd × even = ?", options: ["Even", "Odd", "Prime", "One"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
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
