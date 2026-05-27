import SwiftUI

// Discover Mode — Maths Ch.14 "Constructions and Tilings". Built on
// MathDiscoverComponents (2026-05-27 build-out). Scene cursor
// discoverScene(114); markSceneComplete "m\(chapter.id)" so progress
// stays separate from any Science chapter sharing the chNN id.

struct DiscoverChapterMath14View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(114)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = ["Compass & Tiles", "The 360° Rule", "Perpendicular Bisector", "Bisecting an Angle", "Constructions Boss Quiz"]

    var body: some View {
        DiscoverShell(
            pack: pack, chapter: chapter,
            navigationTitle: "Discover · Maths Ch. 14 — Constructions and Tilings",
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
            { AnyView(MathDiscoverInfoScene(title: "Compass & Tiles", paragraphs: ["With just a compass and straight-edge you can build exact shapes: a perpendicular bisector cuts a segment in half at 90°, and you can construct and bisect angles precisely.", "Tiles cover a plane with no gaps when the angles meeting at each point add to exactly 360°."], onComplete: { self.markComplete(0) })) },
            { AnyView(MathDiscoverQuickScene(title: "The 360° Rule", intro: "Around a point, angles must total 360° for tiles to fit.", prompt: "Angles meeting at a point in a tiling add to?", options: ["360°", "180°", "90°", "270°"], correctIndex: 0, onComplete: { s in self.markComplete(1, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Perpendicular Bisector", intro: "It crosses the segment at its midpoint, at 90°.", prompt: "A perpendicular bisector cuts a segment into two equal parts at?", options: ["90°", "45°", "60°", "180°"], correctIndex: 0, onComplete: { s in self.markComplete(2, score: s, max: 1) })) },
            { AnyView(MathDiscoverQuickScene(title: "Bisecting an Angle", intro: "Bisecting splits an angle into two equal halves.", prompt: "Bisecting a 90° angle gives two angles of?", options: ["45°", "90°", "30°", "60°"], correctIndex: 0, onComplete: { s in self.markComplete(3, score: s, max: 1) })) },
            { AnyView(MathDiscoverBossQuizScene(title: "Constructions Boss Quiz", questions: [MathDiscoverBossQA(prompt: "Tiles meeting at a vertex must total?", options: ["360°", "180°", "90°", "720°"], correct: 0), MathDiscoverBossQA(prompt: "Bisecting a 60° angle gives?", options: ["30°", "60°", "120°", "15°"], correct: 0), MathDiscoverBossQA(prompt: "A square's corner angle is?", options: ["90°", "60°", "120°", "45°"], correct: 0), MathDiscoverBossQA(prompt: "Can identical squares tile a plane with no gaps?", options: ["Yes", "No", "Only with triangles", "Only 3 at a vertex"], correct: 0), MathDiscoverBossQA(prompt: "A perpendicular bisector passes through the segment's?", options: ["Midpoint", "Endpoint", "Longest side", "Corner"], correct: 0)], onComplete: { s in self.markComplete(4, score: s, max: 5) })) }
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
