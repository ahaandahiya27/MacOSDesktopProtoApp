import SwiftUI

// Discover Mode — Maths Ch.7 "A Tale of Three Intersecting Lines". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(107); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath7View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(107)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["Three Lines, One Triangle", "Angle Sum", "The Triangle Inequality", "Naming by Sides", "Triangles Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 7 — A Tale of Three Intersecting Lines",
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
            { AnyView(MathDiscoverInfoScene(title: "Three Lines, One Triangle", paragraphs: ["Three line segments meeting at three corners make a triangle. Its three angles always add to 180°. The three sides obey the triangle inequality: any two sides together must be longer than the third.", "Triangles are named by sides (equilateral, isosceles, scalene) and by angles (acute, right, obtuse)."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "Angle Sum", intro: "The three angles of any triangle add to 180°.", prompt: "The three angles of a triangle add to?", options: ["180°", "360°", "90°", "270°"], correctIndex: 0, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "The Triangle Inequality", intro: "Two sides together must beat the third, or the triangle can't close.", prompt: "Can a triangle have sides 2, 3 and 10 cm?", options: ["No — 2 + 3 < 10", "Yes", "Only if right-angled", "Only if isosceles"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Naming by Sides", intro: "All three sides equal makes an equilateral triangle.", prompt: "A triangle with all sides equal is?", options: ["Equilateral", "Isosceles", "Scalene", "Right"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "Triangles Boss Quiz", questions: [MathDiscoverBossQA(prompt: "Two angles are 60° and 70°. The third?", options: ["50°", "60°", "70°", "130°"], correct: 0), MathDiscoverBossQA(prompt: "A triangle with a 90° angle is?", options: ["Right-angled", "Acute", "Obtuse", "Equilateral"], correct: 0), MathDiscoverBossQA(prompt: "Sides 5, 5, 8 — what type by sides?", options: ["Isosceles", "Scalene", "Equilateral", "Right"], correct: 0), MathDiscoverBossQA(prompt: "Each angle of an equilateral triangle is?", options: ["60°", "90°", "45°", "180°"], correct: 0), MathDiscoverBossQA(prompt: "Can sides 4, 6, 9 form a triangle?", options: ["Yes — 4 + 6 > 9", "No", "Only if right", "Only if equilateral"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
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
