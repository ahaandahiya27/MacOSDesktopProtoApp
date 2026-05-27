import SwiftUI

// Discover Mode — Maths Ch.13 "Connecting the Dots". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(113); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath13View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(113)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["Connecting the Dots", "The Mean", "The Mode", "The Range", "Data Handling Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 13 — Connecting the Dots",
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
            { AnyView(MathDiscoverInfoScene(title: "Connecting the Dots", paragraphs: ["Data has a story. The mean (add up, divide by how many), the median (the middle value), and the mode (the most common value) each summarise a set with one number.", "The range (largest minus smallest) tells you how spread out the data is. Bar graphs let you see it all at a glance."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "The Mean", intro: "Add the values, divide by how many: (2+4+6) ÷ 3 = 4.", prompt: "Mean of 2, 4 and 6?", options: ["4", "12", "6", "3"], correctIndex: 0, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "The Mode", intro: "The value that appears most often.", prompt: "Mode of 3, 3, 5, 7?", options: ["3", "5", "4.5", "7"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "The Range", intro: "Largest minus smallest.", prompt: "Range of 2, 9 and 5?", options: ["7", "9", "5", "16"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "Data Handling Boss Quiz", questions: [MathDiscoverBossQA(prompt: "Mean of 10 and 20?", options: ["15", "30", "10", "5"], correct: 0), MathDiscoverBossQA(prompt: "Median (middle value) of 1, 3, 9?", options: ["3", "1", "9", "13"], correct: 0), MathDiscoverBossQA(prompt: "Mode of 4, 4, 4, 7, 9?", options: ["4", "7", "9", "5"], correct: 0), MathDiscoverBossQA(prompt: "Range of 12, 3 and 8?", options: ["9", "12", "8", "23"], correct: 0), MathDiscoverBossQA(prompt: "Mean of 5, 5 and 5?", options: ["5", "15", "3", "0"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
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
