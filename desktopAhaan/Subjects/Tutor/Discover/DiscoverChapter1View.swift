import SwiftUI

struct DiscoverChapter1View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(1)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // Scene 9 (Three Partnerships Lab) added 2026-05-20 — pilot extension
    // of the Discover lineup to deepen Topic 2 coverage. Inline scene
    // (see SymbiosisPartnershipsLabScene struct below) follows the
    // DailyPracticeView / ReviewSessionSheet pattern of living inside its
    // owner's file to avoid the Xcode pbxproj add-files ceremony.
    private let sceneTitles = [
        "Plant Kitchen",
        "Photosynthesis Lab",
        "Inside a Leaf",
        "Why Are Leaves Green?",
        "Autotroph or Heterotroph?",
        "Meet the Special Plants",
        "The Pitcher Plant Trap",
        "The Nitrogen Cycle",
        "Three Partnerships",
        "Stomata: Open & Close",
        "Light & Photosynthesis Rate",
        "Water's Journey",
        "Parasite, Partner, or Predator?",
        "Venus Flytrap Reflex",
        "Sort the Feeders",
        "Soil Layers Lab",
        "Rhizobium: Nitrogen Factory",
        "Food Chain Builder",
        "Compost Pit Timeline",
        "Van Helmont's Willow",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 1 — Nutrition in Plants",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
        // Defensive (2026-05-21): a stale @AppStorage value from before
        // the Van Helmont scene was inserted could in theory point past
        // sceneTitles.count - 1. Clamp on appear so the dispatcher
        // never indexes into nothing. The guard inside sceneBody
        // already returns EmptyView() for out-of-range indices, so this
        // is belt-and-braces — but a visible blank canvas reads as a
        // crash to the kid.
        .onAppear {
            let maxIndex = sceneTitles.count - 1
            if currentScene < 0 || currentScene > maxIndex {
                currentScene = max(0, min(currentScene, maxIndex))
            }
        }
    }

    /// Lookup-table dispatcher. The previous big switch over 20 cases
    /// inside `@ViewBuilder` forced Swift to type-check 20-deep nested
    /// `_ConditionalContent<…>` and pushed the Debug compile of this
    /// file from ~5s to ~210s — risky for the Xcode 13.2.1 deploy
    /// target. Returning AnyView via a closure array short-circuits the
    /// type-inferencer and brings build time back to seconds. The tiny
    /// AnyView type-erasure cost is irrelevant at the chapter-dispatch
    /// level (one view per scene).
    private func sceneBody(_ index: Int) -> AnyView {
        guard index >= 0 && index < sceneBuilders.count else {
            return AnyView(EmptyView())
        }
        return sceneBuilders[index]()
    }

    private var sceneBuilders: [() -> AnyView] {
        [
            { AnyView(Scene1_PlantKitchen(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_PhotosynthesisLab(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_InsideALeaf(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_ColorTheChlorophyll(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_AutotrophHeterotroph(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(4, score: score, max: 12) })) },
            { AnyView(Scene6_MeetTheSpecialPlants(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_PitcherPlantTrap(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_NitrogenCycle(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(SymbiosisPartnershipsLabScene(onComplete: { self.markComplete(8) })) },
            { AnyView(StomataOpenCloseScene(onComplete: { self.markComplete(9) })) },
            { AnyView(LightAndRateScene(onComplete: { self.markComplete(10) })) },
            { AnyView(WaterJourneyScene(onComplete: { self.markComplete(11) })) },
            { AnyView(ParasitePartnerPredatorScene(onComplete: { score in self.markComplete(12, score: score, max: 3) })) },
            { AnyView(VenusFlytrapReflexScene(onComplete: { score in self.markComplete(13, score: score, max: 5) })) },
            { AnyView(SortTheFeedersScene(onComplete: { self.markComplete(14) })) },
            { AnyView(SoilLayersLabScene(onComplete: { self.markComplete(15) })) },
            { AnyView(RhizobiumNitrogenScene(onComplete: { self.markComplete(16) })) },
            { AnyView(FoodChainBuilderScene(onComplete: { self.markComplete(17) })) },
            { AnyView(CompostTimelineScene(onComplete: { self.markComplete(18) })) },
            { AnyView(VanHelmontWillowScene(onComplete: { self.markComplete(19) })) },
            { AnyView(Scene9_BossQuiz(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(20, score: score, max: 15) })) }
        ]
    }

    private func markComplete(_ index: Int, score: Int? = nil, max: Int? = nil) {
        let id = "scene\(index + 1)"
        dataStore.markSceneComplete(chapterId: chapter.id, sceneId: id, score: score, maxScore: max)
        if index < sceneTitles.count - 1 {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: DiscoverTiming.settleDelayNs)
                advanceDiscoverScene($currentScene, total: sceneTitles.count, reduceMotion: reduceMotion)
            }
        }
    }
}

