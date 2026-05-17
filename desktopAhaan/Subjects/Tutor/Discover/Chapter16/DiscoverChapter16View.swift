import SwiftUI

struct DiscoverChapter16View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(16)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Earth's Water Pie",
        "Water Table Slider",
        "Aquifer Cross-Section",
        "Drip / Sprinkler / Flood",
        "Rainwater Harvesting",
        "Bawdi — the Stepwell",
        "Daily Water Audit",
        "World Water Day Pledge",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 16 — Water: A Precious Resource",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_WaterPie(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_WaterTableSlider(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_AquiferCrossSection(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_IrrigationCompare(pack: pack, chapter: chapter, onComplete: { score in markComplete(3, score: score, max: 3) })
        case 4: Scene5_RainwaterHarvesting(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_BawdiStepwell(pack: pack, chapter: chapter, onComplete: { markComplete(5) })
        case 6: Scene7_WaterAudit(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_WaterPledge(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch16(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
