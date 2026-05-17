import SwiftUI

struct DiscoverChapter8View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(8)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Hot Air Rises",
        "Air Pressure Drop",
        "Land Breeze, Sea Breeze",
        "Uneven Heating Builds Wind",
        "Cyclone Eye",
        "Thunderstorm Safety",
        "Cyclone Warning Codes",
        "Anemometer Reader",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 8 — Winds, Storms and Cyclones",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_HotAirRises(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_AirPressureDrop(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_LandBreezeSeaBreeze(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_UnevenHeating(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_CycloneEye(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_ThunderstormSafety(pack: pack, chapter: chapter, onComplete: { score in markComplete(5, score: score, max: 6) })
        case 6: Scene7_CycloneWarningCodes(pack: pack, chapter: chapter, onComplete: { score in markComplete(6, score: score, max: 4) })
        case 7: Scene8_AnemometerReader(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch8(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
