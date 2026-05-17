import SwiftUI

struct DiscoverChapter17View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(17)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Forest Layers",
        "Decomposer Cycle",
        "Food Web Builder",
        "Forest as Sponge",
        "O₂ ⇄ CO₂ Balance",
        "Animal Niche Match",
        "Deforestation Domino",
        "Reforestation Plan",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 17 — Forests: Our Lifeline",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_ForestLayers(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_DecomposerCycle(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_FoodWebBuilder(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_ForestAsSponge(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_O2CO2Balance(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_AnimalNicheMatch(pack: pack, chapter: chapter, onComplete: { score in markComplete(5, score: score, max: 4) })
        case 6: Scene7_DeforestationDomino(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_ReforestationPlan(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch17(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
