import SwiftUI

struct DiscoverChapter19View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(19)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Spinning Earth",
        "Why Seasons Happen",
        "Moon Phases Wheel",
        "Eclipse Builder",
        "Tides and the Moon",
        "Solar System Sorter",
        "Constellation Connect",
        "ISRO Space Missions",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 19 — Earth, Moon and the Sun",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_SpinningEarth(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_WhySeasonsHappen(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_MoonPhasesWheel(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_EclipseBuilder(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_TidesAndTheMoon(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_SolarSystemSorter(pack: pack, chapter: chapter, onComplete: { score in markComplete(5, score: score, max: 16) })
        case 6: Scene7_ConstellationConnect(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_ISROSpaceMissions(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch19(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
