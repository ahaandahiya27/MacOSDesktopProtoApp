import SwiftUI

struct DiscoverChapter3View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(3)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "From Fluff to Fibre",
        "Meet the Wool Animals",
        "The Shearing Day",
        "The Wool Pipeline",
        "Sorter's Disease Lab",
        "Silkworm Life Cycle",
        "The Cocoon Reel",
        "Fibre vs Fibre Game",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 3 — Fibre to Fabric",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_FluffToFibre(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_MeetTheWoolAnimals(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_TheShearingDay(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_TheWoolPipeline(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_SortersDiseaseLab(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_SilkwormLifeCycle(pack: pack, chapter: chapter, onComplete: { markComplete(5) })
        case 6: Scene7_TheCocoonReel(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_FibreVsFibreGame(pack: pack, chapter: chapter, onComplete: { score in markComplete(7, score: score, max: 6) })
        case 8: Scene9_BossQuiz_Ch3(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
