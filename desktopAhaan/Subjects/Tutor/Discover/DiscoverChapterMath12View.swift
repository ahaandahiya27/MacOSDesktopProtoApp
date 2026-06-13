import SwiftUI

// Discover Mode — Maths Ch.12 "Another Peek Beyond the Point". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(112); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath12View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(112)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["Decimals at Work", "Multiplying Decimals", "Multiplying by 10", "Dividing by 10", "Decimal Operations Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 12 — Another Peek Beyond the Point",
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
            { AnyView(MathDiscoverInfoScene(title: "Decimals at Work", paragraphs: ["To multiply decimals, multiply as whole numbers, then count the total decimal places in both factors and put the point that many places from the right: 0.2 × 0.3 = 0.06.", "Multiplying by 10, 100, 1000 shifts the point right; dividing shifts it left. Estimating first helps you place the point correctly."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "Multiplying Decimals", intro: "Count decimal places: 0.2 (one) × 0.3 (one) = 0.06 (two).", prompt: "What is 0.2 × 0.3?", options: ["0.06", "0.6", "0.5", "6"], correctIndex: 0, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Multiplying by 10", intro: "Multiplying by 10 shifts the point one place right.", prompt: "What is 0.45 × 10?", options: ["4.5", "45", "0.045", "450"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Dividing by 10", intro: "Dividing by 10 shifts the point one place left.", prompt: "What is 6.0 ÷ 10?", options: ["0.6", "60", "0.06", "6"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "Decimal Operations Boss Quiz", questions: [MathDiscoverBossQA(prompt: "0.5 × 0.5 = ?", options: ["0.25", "2.5", "0.1", "25"], correct: 0), MathDiscoverBossQA(prompt: "1.2 × 10 = ?", options: ["12", "1.2", "120", "0.12"], correct: 0), MathDiscoverBossQA(prompt: "0.8 ÷ 2 = ?", options: ["0.4", "4", "0.04", "1.6"], correct: 0), MathDiscoverBossQA(prompt: "How many decimal places in the product 0.4 × 0.07?", options: ["3", "2", "1", "4"], correct: 0), MathDiscoverBossQA(prompt: "0.3 × 100 = ?", options: ["30", "3", "300", "0.003"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
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
