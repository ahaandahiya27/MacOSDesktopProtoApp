import SwiftUI

struct DiscoverChapter11View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(11)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Heart Beats",
        "Pulse Counter",
        "Blood Sort",
        "Artery / Vein / Capillary",
        "Kidney Filter",
        "Xylem Water Climb",
        "Phloem Sugar Pipeline",
        "Transpiration Pull",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 11 — Transportation in Animals and Plants",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_HeartBeats(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_PulseCounter(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_BloodSort(pack: pack, chapter: chapter, onComplete: { score in markComplete(2, score: score, max: 4) })
        case 3: Scene4_ArteryVeinCapillary(pack: pack, chapter: chapter, onComplete: { score in markComplete(3, score: score, max: 3) })
        case 4: Scene5_KidneyFilter(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_XylemWaterClimb(pack: pack, chapter: chapter, onComplete: { markComplete(5) })
        case 6: Scene7_PhloemSugarPipeline(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_TranspirationPull(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch11(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
