import SwiftUI

struct DiscoverChapter7View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(7)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Weather vs Climate",
        "Build a Weather Station",
        "Climate Zones Map",
        "Polar Bear Survival Kit",
        "Tropical Rainforest Life",
        "Adaptation Match Game",
        "Migration Superhero",
        "Desert Survival Tricks",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 7 — Weather, Climate and Adaptations",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_WeatherVsClimate(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_BuildAWeatherStation(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_ClimateZonesMap(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_PolarBearSurvivalKit(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_TropicalRainforestLife(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_AdaptationMatchGame(pack: pack, chapter: chapter, onComplete: { score in markComplete(5, score: score, max: 12) })
        case 6: Scene7_MigrationSuperhero(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_DesertSurvivalTricks(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch7(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
