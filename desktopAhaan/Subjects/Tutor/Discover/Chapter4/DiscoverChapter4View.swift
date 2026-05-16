import SwiftUI

struct DiscoverChapter4View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(4)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Hot or Cold?",
        "Build Your Thermometer",
        "Three Highways of Heat",
        "Hot Soup, Cold Spoon",
        "Sea Breeze, Land Breeze",
        "Conductor or Insulator?",
        "Fluffy Birds, Fluffy Sweaters",
        "Temperature vs Heat",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 4 — Heat",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_HotOrCold(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_BuildYourThermometer(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_ThreeHighwaysOfHeat(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_HotSoupColdSpoon(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_SeaBreezeLandBreeze(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_ConductorOrInsulator(pack: pack, chapter: chapter, onComplete: { score in markComplete(5, score: score, max: 12) })
        case 6: Scene7_FluffyBirdsFluffySweaters(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_TemperatureVsHeat(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch4(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
