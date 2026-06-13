import SwiftUI

// Discover Mode — Maths Ch.4 "Expressions Using Letter-Numbers". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(104); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath4View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(104)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["Letter-Numbers", "Substituting a Value", "Dropping the × Sign", "Collecting Like Terms", "Letter-Numbers Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 4 — Expressions Using Letter-Numbers",
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
            { AnyView(MathDiscoverInfoScene(title: "Letter-Numbers", paragraphs: ["A letter like x or n stands in for a number we don't know yet. An expression such as 2n + 1 is a rule: whatever n is, double it and add one.", "We drop the multiplication sign — 3y means 3 × y — and we 'substitute' by replacing the letter with a value."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "Substituting a Value", intro: "Replace the letter with the number, then compute.", prompt: "If x = 5, what is x + 3?", options: ["8", "53", "15", "2"], correctIndex: 0, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Dropping the × Sign", intro: "3y is shorthand for 3 × y.", prompt: "What does 3y mean?", options: ["3 × y", "3 + y", "3 to the power y", "y ÷ 3"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Collecting Like Terms", intro: "Terms with the same letter combine: 2a + 3a = 5a.", prompt: "Simplify 2a + 3a.", options: ["5a", "6a", "5", "23a"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "Letter-Numbers Boss Quiz", questions: [MathDiscoverBossQA(prompt: "If n = 4, what is 2n?", options: ["8", "24", "6", "42"], correct: 0), MathDiscoverBossQA(prompt: "Write 'a number b, doubled then plus 1'.", options: ["2b + 1", "b + 2", "2 + b", "b² + 1"], correct: 0), MathDiscoverBossQA(prompt: "Simplify 5x − 2x.", options: ["3x", "7x", "3", "10x"], correct: 0), MathDiscoverBossQA(prompt: "If p = 10, what is p ÷ 2 + 1?", options: ["6", "5", "11", "21"], correct: 0), MathDiscoverBossQA(prompt: "4(x) is the same as?", options: ["4 × x", "4 + x", "x to the 4", "x ÷ 4"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
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
