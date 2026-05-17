import SwiftUI

struct DiscoverChapter10View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(10)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Inhale, Exhale",
        "Aerobic vs Anaerobic",
        "Yeast & Sugar Lab",
        "Lime Water Test",
        "Fish Gill Flow",
        "How Insects & Worms Breathe",
        "Plant Stomata Zoom",
        "Rest vs Run",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 10 — Respiration in Organisms",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_InhaleExhale(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_AerobicAnaerobic(pack: pack, chapter: chapter, onComplete: { score in markComplete(1, score: score, max: 4) })
        case 2: Scene3_YeastSugarLab(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_LimeWaterTest(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_FishGillFlow(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_InsectsWorms(pack: pack, chapter: chapter, onComplete: { markComplete(5) })
        case 6: Scene7_StomataZoom(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_RestVsRun(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch10(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
