import SwiftUI

// Discover Mode — Maths Ch.9 "Geometric Twins". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(109); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath9View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(109)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["Geometric Twins", "What Congruent Means", "The SSS Criterion", "Isosceles Angles", "Congruence Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 9 — Geometric Twins",
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
            { AnyView(MathDiscoverInfoScene(title: "Geometric Twins", paragraphs: ["Two figures are congruent when one is an exact copy of the other — same shape and same size, even if flipped or turned. For triangles, you don't need all six measurements; a few pin it down.", "The criteria are SSS, SAS, ASA and RHS. In an isosceles triangle, equal sides face equal angles; an equilateral triangle has three 60° angles."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "What Congruent Means", intro: "Congruent = same shape AND same size.", prompt: "Congruent figures have the?", options: ["Same shape and size", "Same shape only", "Same area only", "Same colour"], correctIndex: 0, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "The SSS Criterion", intro: "Three matching sides fix a triangle completely.", prompt: "If all three sides of two triangles are equal, they are congruent by?", options: ["SSS", "SAS", "ASA", "RHS"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Isosceles Angles", intro: "Equal sides face equal angles.", prompt: "In an isosceles triangle, the angles opposite the equal sides are?", options: ["Equal", "Right angles", "60° each", "Different"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "Congruence Boss Quiz", questions: [MathDiscoverBossQA(prompt: "Two triangles are congruent if they have the same?", options: ["Shape and size", "Shape only", "Perimeter only", "Area only"], correct: 0), MathDiscoverBossQA(prompt: "Two sides and the angle between them equal means congruent by?", options: ["SAS", "SSS", "ASA", "RHS"], correct: 0), MathDiscoverBossQA(prompt: "The RHS criterion is used for which triangles?", options: ["Right-angled", "Equilateral", "Obtuse", "Any"], correct: 0), MathDiscoverBossQA(prompt: "Each angle of an equilateral triangle is?", options: ["60°", "90°", "45°", "30°"], correct: 0), MathDiscoverBossQA(prompt: "ASA stands for?", options: ["Angle-Side-Angle", "Angle-Sum-Angle", "Area-Side-Area", "All-Sides-Above"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
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
