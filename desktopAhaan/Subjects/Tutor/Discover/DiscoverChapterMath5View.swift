import SwiftUI

// Discover Mode — Maths Ch.5 "Parallel and Intersecting Lines". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(105); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath5View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(105)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["When Lines Cross", "Linear Pairs", "Vertically Opposite Angles", "Corresponding Angles", "Lines & Angles Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 5 — Parallel and Intersecting Lines",
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
            { AnyView(MathDiscoverInfoScene(title: "When Lines Cross", paragraphs: ["Where two lines cross, four angles form. Angles straight across from each other (vertically opposite) are equal; angles side by side on a straight line (a linear pair) add to 180°.", "Parallel lines never meet. When a third line (a transversal) cuts two parallel lines, matching corresponding angles are equal."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "Linear Pairs", intro: "Two angles that sit on a straight line always add to 180°.", prompt: "Two angles on a straight line add to?", options: ["180°", "90°", "360°", "100°"], correctIndex: 0, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Vertically Opposite Angles", intro: "The angles straight across an intersection are always equal.", prompt: "Vertically opposite angles are?", options: ["Equal", "Supplementary", "Always 90°", "Always 45°"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Corresponding Angles", intro: "Across two parallel lines, corresponding angles match.", prompt: "When a line crosses two parallel lines, corresponding angles are?", options: ["Equal", "Add to 90°", "Add to 180°", "Always 60°"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "Lines & Angles Boss Quiz", questions: [MathDiscoverBossQA(prompt: "If one angle in a linear pair is 70°, the other is?", options: ["110°", "70°", "20°", "290°"], correct: 0), MathDiscoverBossQA(prompt: "Vertically opposite to a 35° angle is?", options: ["35°", "145°", "55°", "325°"], correct: 0), MathDiscoverBossQA(prompt: "Two lines that never meet are?", options: ["Parallel", "Perpendicular", "Intersecting", "A transversal"], correct: 0), MathDiscoverBossQA(prompt: "Perpendicular lines meet at?", options: ["90°", "180°", "45°", "60°"], correct: 0), MathDiscoverBossQA(prompt: "Co-interior (allied) angles between parallel lines add to?", options: ["180°", "90°", "360°", "100°"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
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
