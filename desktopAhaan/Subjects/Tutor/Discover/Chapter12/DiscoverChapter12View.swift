import SwiftUI

struct DiscoverChapter12View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(12)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Flower Anatomy",
        "Pollination Match",
        "Self vs Cross Pollination",
        "Fertilisation",
        "Seed Dispersal",
        "Vegetative Propagation",
        "Budding",
        "Fragmentation",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 12 — Reproduction in Plants",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_FlowerAnatomy(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_PollinationMatch(pack: pack, chapter: chapter, onComplete: { score in markComplete(1, score: score, max: 4) })
        case 2: Scene3_SelfVsCross(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_Fertilisation(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_SeedDispersal(pack: pack, chapter: chapter, onComplete: { score in markComplete(4, score: score, max: 4) })
        case 5: Scene6_VegetativePropagation(pack: pack, chapter: chapter, onComplete: { markComplete(5) })
        case 6: Scene7_Budding(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_Fragmentation(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch12(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
