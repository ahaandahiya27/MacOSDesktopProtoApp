import SwiftUI

struct DiscoverChapter6View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(6)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Ice to Water to Steam",
        "Tearing vs Burning Paper",
        "Five Signs of Chemical Change",
        "The Rusting Experiment",
        "Galvanisation Shield",
        "Physical or Chemical?",
        "Crystal Garden",
        "Kitchen Chemistry",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 6 — Physical and Chemical Changes",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_IceToWaterToSteam(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_TearingVsBurningPaper(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_FiveSignsOfChemicalChange(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_TheRustingExperiment(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_GalvanisationShield(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_PhysicalOrChemicalSorting(pack: pack, chapter: chapter, onComplete: { score in markComplete(5, score: score, max: 12) })
        case 6: Scene7_CrystalGarden(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_KitchenChemistry(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch6(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
