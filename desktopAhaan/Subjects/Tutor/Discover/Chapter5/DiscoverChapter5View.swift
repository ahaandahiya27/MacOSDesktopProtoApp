import SwiftUI

struct DiscoverChapter5View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(5)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Sour or Bitter?",
        "Build Your pH Strip",
        "Three Indicator Tests",
        "Neutralisation in Action",
        "Ant Sting First Aid",
        "Acid or Base Sorting Lab",
        "Soil pH and the Farmer",
        "Acid Rain Story",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 5 — Acids, Bases and Salts",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_SourOrBitter(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_BuildYourpHStrip(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_ThreeIndicatorTests(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_NeutralisationInAction(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_AntStingFirstAid(pack: pack, chapter: chapter, onComplete: { markComplete(4) })
        case 5: Scene6_AcidOrBaseSortingLab(pack: pack, chapter: chapter, onComplete: { score in markComplete(5, score: score, max: 12) })
        case 6: Scene7_SoilpHAndFarmer(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_AcidRainStory(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: Scene9_BossQuiz_Ch5(pack: pack, chapter: chapter, onComplete: { score in markComplete(8, score: score, max: 5) })
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
