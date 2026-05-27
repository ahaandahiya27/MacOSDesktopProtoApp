import SwiftUI

// Discover Mode — Maths Ch.15 "Finding the Unknown". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(115); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath15View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(115)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["Finding the Unknown", "Undo to Solve", "Divide to Solve", "Keep It Balanced", "Equations Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 15 — Finding the Unknown",
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
            { AnyView(MathDiscoverInfoScene(title: "Finding the Unknown", paragraphs: ["An equation is a balance: both sides weigh the same. To find the unknown, do the SAME thing to both sides until the letter stands alone.", "Use inverse operations — undo +5 with −5, undo ×3 with ÷3 — and always check by substituting your answer back in."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "Undo to Solve", intro: "Subtract 5 from both sides: x + 5 = 12 gives x = 7.", prompt: "Solve x + 5 = 12. x = ?", options: ["7", "17", "60", "5"], correctIndex: 0, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Divide to Solve", intro: "Divide both sides by 3: 3x = 12 gives x = 4.", prompt: "Solve 3x = 12. x = ?", options: ["4", "36", "9", "15"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Keep It Balanced", intro: "Whatever you do to one side, do to the other.", prompt: "To keep an equation balanced, you must do the same to?", options: ["Both sides", "The left only", "The right only", "Neither"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "Equations Boss Quiz", questions: [MathDiscoverBossQA(prompt: "Solve x − 4 = 6. x = ?", options: ["10", "2", "24", "-2"], correct: 0), MathDiscoverBossQA(prompt: "Solve x ÷ 2 = 5. x = ?", options: ["10", "2.5", "7", "3"], correct: 0), MathDiscoverBossQA(prompt: "Solve 2x + 1 = 9. x = ?", options: ["4", "5", "8", "3.5"], correct: 0), MathDiscoverBossQA(prompt: "Is x = 3 a solution of x + 4 = 7?", options: ["Yes", "No", "Only if x is even", "Cannot tell"], correct: 0), MathDiscoverBossQA(prompt: "The inverse operation of '+5' is?", options: ["−5", "×5", "÷5", "+5 again"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
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
