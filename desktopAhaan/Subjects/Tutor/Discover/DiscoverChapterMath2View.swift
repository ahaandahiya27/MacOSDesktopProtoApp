import SwiftUI

// Discover Mode — Maths Ch.2 "Arithmetic Expressions". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(102); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath2View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(102)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["Reading Expressions", "Order of Operations", "Brackets First", "The Distributive Property", "Arithmetic Expressions Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 2 — Arithmetic Expressions",
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
            { AnyView(MathDiscoverInfoScene(title: "Reading Expressions", paragraphs: ["An arithmetic expression is a recipe of numbers and operations, like 2 + 3 × 4. Different-looking expressions can have the same value, and you can often compare them without computing every step.", "Order matters: do brackets first, then × and ÷, then + and −. The terms (the parts joined by + and −) are the natural grouping."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "Order of Operations", intro: "Multiply and divide before you add and subtract — unless brackets tell you otherwise.", prompt: "What is 2 + 3 × 4?", options: ["20", "14", "24", "9"], correctIndex: 1, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Brackets First", intro: "Anything inside brackets is computed before the rest.", prompt: "What is (8 − 3) × 2?", options: ["10", "2", "13", "16"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "The Distributive Property", intro: "a × (b + c) = a×b + a×c — you can split a product over a sum.", prompt: "3 × (10 + 2) equals?", options: ["36", "32", "30", "23"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "Arithmetic Expressions Boss Quiz", questions: [MathDiscoverBossQA(prompt: "12 − 4 × 2 = ?", options: ["4", "16", "8", "20"], correct: 0), MathDiscoverBossQA(prompt: "Which equals 5 × 7 + 5 × 3?", options: ["5 × 10", "5 × 21", "10 × 7", "35 + 3"], correct: 0), MathDiscoverBossQA(prompt: "Is 7 + 9 the same as 9 + 7?", options: ["Yes — commutative", "No", "Only sometimes", "Only for even numbers"], correct: 0), MathDiscoverBossQA(prompt: "20 ÷ (2 + 3) = ?", options: ["4", "13", "8", "10"], correct: 0), MathDiscoverBossQA(prompt: "Remove brackets: 10 − (4 + 3) = ?", options: ["3", "9", "11", "17"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
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
