import SwiftUI

struct DiscoverChapter1View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(1)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Plant Kitchen",
        "Photosynthesis Lab",
        "Inside a Leaf",
        "Why Are Leaves Green?",
        "Autotroph or Heterotroph?",
        "Meet the Special Plants",
        "The Pitcher Plant Trap",
        "The Nitrogen Cycle",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 1 — Nutrition in Plants",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_PlantKitchen(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_PhotosynthesisLab(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_InsideALeaf(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_ColorTheChlorophyll(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_AutotrophHeterotroph(pack: pack, chapter: chapter, onComplete: { score in markComplete(4, score: score, max: 12) })
        case 5: Scene6_MeetTheSpecialPlants(pack: pack, chapter: chapter, onComplete: { markComplete(5) })
        case 6: Scene7_PitcherPlantTrap(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_NitrogenCycle(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
        default: EmptyView()
        }
    }

    private func markComplete(_ index: Int, score: Int? = nil, max: Int? = nil) {
        let id = "scene\(index + 1)"
        dataStore.markSceneComplete(chapterId: chapter.id, sceneId: id, score: score, maxScore: max)
        if index < sceneTitles.count - 1 {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 400_000_000)
                advanceDiscoverScene($currentScene, total: sceneTitles.count, reduceMotion: reduceMotion)
            }
        }
    }
}
