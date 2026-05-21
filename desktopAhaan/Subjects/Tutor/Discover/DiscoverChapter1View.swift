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
                try? await Task.sleep(nanoseconds: 400_000_000)
                advanceDiscoverScene($currentScene, total: sceneTitles.count, reduceMotion: reduceMotion)
            }
        }
    }
}

// MARK: - Three Partnerships Lab (inline Scene 9)
//
// Extends Topic 2 ("Plants that don't make their own food") beyond the
// Cuscuta / Pitcher / Bread-mould / Lichen flip cards of Scene 6 into a
// "give/get" interactive that drives home the central idea of
// mutualism — in a real partnership, BOTH organisms exchange something
// they need. Three canonical pairings: Lichen (alga + fungus),
// Mycorrhiza (plant root + fungus), Rhizobium (bacterium + legume root).
// Same three the NEET-grade callout in Scene 6 mentioned; this scene
// makes the trade concrete.
//
// Interaction: each pairing row has a "Reveal the trade" button. Tap
// reveals two arrows: what Partner A gives → Partner B, and what
// Partner B gives → Partner A. After all three pairings have been
// revealed, a "Both win!" badge appears below the third row.
//
// Big Sur compatible: no .symbolEffect, no .foregroundStyle, no
// .scrollPosition. Plain SwiftUI .opacity + withAnimation. No bare
// .foregroundColor(.yellow|.orange|.teal) on Text. Body text routes
// through DesignTokens.BrandColor.canvasText so it holds AA contrast
// on the Discover gradient.
private struct SymbiosisPartnershipsLabScene: View {
    let onComplete: () -> Void

    @State private var revealed: Set<String> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct Partnership: Identifiable {
        let id: String
        let title: String
        let leftEmoji: String
        let leftName: String
        let rightEmoji: String
        let rightName: String
        /// what left gives to right
        let leftGives: String
        /// what right gives to left
        let rightGives: String
    }

    private let partnerships: [Partnership] = [
        Partnership(
            id: "lichen",
            title: "Lichen",
            leftEmoji: "🟢", leftName: "Alga",
            rightEmoji: "🍄", rightName: "Fungus",
            leftGives: "Sugar made by photosynthesis",
            rightGives: "Shelter, water, and minerals"
        ),
        Partnership(
            id: "mycorrhiza",
            title: "Mycorrhiza",
            leftEmoji: "🌳", leftName: "Plant root",
            rightEmoji: "🍄", rightName: "Soil fungus",
            leftGives: "Sugar from the leaves above",
            rightGives: "Far-reaching threads that grab water + phosphorus"
        ),
        Partnership(
            id: "rhizobium",
            title: "Rhizobium",
            leftEmoji: "🌱", leftName: "Bean/pea root",
            rightEmoji: "🦠", rightName: "Rhizobium bacterium",
            leftGives: "A safe root-nodule home + food",
            rightGives: "Fixes nitrogen from the air into a usable form"
        )
    ]

    private var allRevealed: Bool {
        revealed.count == partnerships.count
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                titleBlock
                ForEach(partnerships) { p in
                    partnershipRow(p)
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .padding(.horizontal, 24)
                }
                if allRevealed {
                    bothWinBadge
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .padding(.horizontal, 24)
                }
                LookingAheadCallout(
                    title: "Class 11 / NEET — Mutualism",
                    detail: "These three partnerships are the most-tested examples of mutualism. Mycorrhiza powers ~80% of all land plants in the wild. Rhizobium is why farmers rotate beans into a wheat field — the bacteria leave behind 'free' nitrogen in the soil for the next crop."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)
                TryAtHomeCallout(
                    title: "Spot a partnership outside",
                    detail: "Find any wall or tree bark and look for the crusty grey-green or yellow lichen — alga + fungus. If you grow beans or peas in a pot, gently scrape the soil around the root after a few weeks: you'll see tiny pink-white bumps. Those are the Rhizobium nodules in action."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)
                GotItButton(action: onComplete)
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var titleBlock: some View {
        VStack(spacing: 6) {
            Text("Three Partnerships, One Idea")
                .font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .padding(.top, 18)
            Text("In a real partnership, BOTH organisms give something AND get something. Tap each card to see the trade.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }

    @ViewBuilder
    private func partnershipRow(_ p: Partnership) -> some View {
        let isRevealed = revealed.contains(p.id)
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                partnerChip(emoji: p.leftEmoji, name: p.leftName)
                Text("+")
                    .font(.title3.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                partnerChip(emoji: p.rightEmoji, name: p.rightName)
                Spacer(minLength: 8)
                Text(p.title)
                    .font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            if isRevealed {
                tradeArrows(p)
                    .transition(.opacity)
            } else {
                Button {
                    let animation = reduceMotion
                        ? Animation.linear(duration: 0.0)
                        : Animation.easeInOut(duration: 0.25)
                    withAnimation(animation) { _ = revealed.insert(p.id) }
                } label: {
                    Text("Reveal the trade")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.compatIndigo.opacity(0.12))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1)
                        )
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain)
                .pointingCursor()
                .accessibilityLabel("Reveal the give-and-take inside the \(p.title) partnership")
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.gray.opacity(0.18), lineWidth: 1)
        )
    }

    private func partnerChip(emoji: String, name: String) -> some View {
        HStack(spacing: 6) {
            Text(emoji)
                .font(.title2)
            Text(name)
                .font(.callout.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule().fill(Color.gray.opacity(0.10))
        )
    }

    private func tradeArrows(_ p: Partnership) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "arrow.right")
                    .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
                Text("\(p.leftName) gives: ")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                + Text(p.leftGives)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "arrow.left")
                    .foregroundColor(DesignTokens.BrandColor.lookingAhead)
                Text("\(p.rightName) gives: ")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                + Text(p.rightGives)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
        }
        .padding(.top, 4)
    }

    private var bothWinBadge: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(DesignTokens.BrandColor.primaryAction)
                .font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text("Both partners win.")
                    .font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("That's mutualism — a partnership where the trade benefits both sides.")
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(DesignTokens.BrandColor.primaryAction.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(DesignTokens.BrandColor.primaryAction.opacity(0.45), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("All three partnerships revealed — both partners win in each, which is the definition of mutualism.")
    }
}

// MARK: - Inline Scene 10: Stomata Open & Close (Topic 1)
//
// Deepens "Inside a Leaf" by zooming in on the gas-exchange pore on the
// leaf underside. Tap the toggle: guard cells swell → pore opens, CO₂
// flows in / H₂O exits; guard cells deflate → pore closes (mid-day heat
// or no light). The arrows make the trade-off concrete.
private struct StomataOpenCloseScene: View {
    let onComplete: () -> Void
    @State private var isOpen: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Stomata: Open & Close")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Each tiny pore in the leaf has two guard cells. When they swell, the pore opens; when they deflate, it closes. Tap to see the trade.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                stomaDiagram
                    .frame(width: 320, height: 220)
                Button {
                    let a = reduceMotion ? Animation.linear(duration: 0.0) : .easeInOut(duration: 0.3)
                    withAnimation(a) { isOpen.toggle() }
                } label: {
                    Text(isOpen ? "Close the pore" : "Open the pore")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 20).padding(.vertical, 10)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain)
                .pointingCursor()
                stomaCaption
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var stomaDiagram: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(Color.green.opacity(0.18))
            HStack(spacing: isOpen ? 28 : 4) {
                Capsule().fill(Color.green.opacity(0.85)).frame(width: 24, height: 80)
                Capsule().fill(Color.green.opacity(0.85)).frame(width: 24, height: 80)
            }
            if isOpen {
                VStack(spacing: 0) {
                    Image(systemName: "arrow.down")
                        .foregroundColor(DesignTokens.BrandColor.relatedConcepts)
                        .font(.title3)
                    Text("CO₂ in")
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                }
                .offset(y: -50)
                VStack(spacing: 0) {
                    Text("H₂O out")
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Image(systemName: "arrow.up")
                        .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                        .font(.title3)
                }
                .offset(y: 50)
            }
        }
    }

    private var stomaCaption: some View {
        let body: String = isOpen
            ? "Open: photosynthesis can pull CO₂ in, but water vapour escapes too — a trade. Most plants open stomata in the morning when light is best and water-loss is manageable."
            : "Closed: water is conserved, but photosynthesis pauses. Cacti close stomata in the day and open them at night to save water in the desert."
        return Text(body)
            .font(.callout)
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .multilineTextAlignment(.leading)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
    }
}

// MARK: - Inline Scene 11: Light & Photosynthesis Rate (Topic 1)
private struct LightAndRateScene: View {
    let onComplete: () -> Void
    @State private var lightLevel: Double = 0.4

    /// Photosynthesis rate plateaus at high light — chloroplasts saturate.
    /// Linear up to ~0.7 light, then plateaus near 1.0.
    private var rate: Double { min(1.0, lightLevel * 1.35) }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Light & Photosynthesis Rate")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Slide to change how bright the sunlight is. Watch the sugar-making rate respond — up to a point.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                rateBar
                    .frame(width: 220, height: 180)
                HStack(spacing: 8) {
                    Image(systemName: "sun.min.fill").foregroundColor(.gray)
                    Slider(value: $lightLevel, in: 0...1)
                    Image(systemName: "sun.max.fill").foregroundColor(DesignTokens.BrandColor.mnemonic)
                }
                .frame(maxWidth: 340)
                .padding(.horizontal, 24)
                rateCaption
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var rateBar: some View {
        VStack {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1))
                RoundedRectangle(cornerRadius: 10)
                    .fill(DesignTokens.BrandColor.primaryAction.opacity(0.6))
                    .frame(height: 180 * CGFloat(rate))
            }
            .frame(width: 80, height: 180)
            Text("Sugar / min: \(Int(rate * 100))")
                .font(.caption.monospacedDigit().weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
        }
    }

    private var rateCaption: some View {
        let body: String = {
            if lightLevel < 0.2 { return "Too dim — chlorophyll has little energy to work with. Photosynthesis crawls." }
            if lightLevel < 0.7 { return "Sweet spot — rate climbs with brightness. Every extra photon makes more sugar." }
            return "Saturated — chloroplasts are maxed out. Adding more light won't make more sugar; only adding more chloroplasts (a bigger leaf) would."
        }()
        return Text(body)
            .font(.callout)
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .multilineTextAlignment(.leading)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
    }
}

// MARK: - Inline Scene 12: Water's Journey (Topic 1)
private struct WaterJourneyScene: View {
    let onComplete: () -> Void
    /// 0 = nothing, 1 = root, 2 = stem, 3 = leaf, 4 = transpired
    @State private var stage: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let stages = [
        "Tap Start to follow a water drop from root to leaf.",
        "1. Root hairs absorb water from soil (osmosis).",
        "2. Xylem tubes carry water up the stem like a straw.",
        "3. Water reaches the leaves and supplies photosynthesis.",
        "4. Excess water evaporates from stomata — transpiration pulls the next drop up."
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Water's Journey")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                plantDiagram
                    .frame(width: 220, height: 280)
                Button {
                    let a = reduceMotion ? Animation.linear(duration: 0.0) : .easeOut(duration: 0.3)
                    withAnimation(a) {
                        if stage >= 4 { stage = 0 } else { stage += 1 }
                    }
                } label: {
                    Text(stage >= 4 ? "Reset" : (stage == 0 ? "Start" : "Next stage"))
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 20).padding(.vertical, 10)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain)
                .pointingCursor()
                Text(stages[stage])
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var plantDiagram: some View {
        ZStack {
            // Leaves
            Capsule().fill(stage >= 3 ? Color.compatTeal : Color.green.opacity(0.5))
                .frame(width: 70, height: 30).offset(x: -25, y: -90)
            Capsule().fill(stage >= 3 ? Color.compatTeal : Color.green.opacity(0.5))
                .frame(width: 70, height: 30).offset(x: 25, y: -110)
            // Stem
            Rectangle().fill(stage >= 2 ? Color.compatTeal : Color.compatBrown.opacity(0.5))
                .frame(width: 10, height: 160)
            // Roots
            ForEach(0..<3, id: \.self) { i in
                Rectangle().fill(stage >= 1 ? Color.compatTeal : Color.compatBrown.opacity(0.5))
                    .frame(width: 4, height: 30)
                    .offset(x: CGFloat(i - 1) * 14, y: 100)
                    .rotationEffect(.degrees(Double(i - 1) * 25))
            }
            // Soil
            RoundedRectangle(cornerRadius: 6).fill(Color.compatBrown.opacity(0.18))
                .frame(width: 200, height: 30).offset(y: 100)
            // Transpiration arrows
            if stage >= 4 {
                Image(systemName: "arrow.up").foregroundColor(DesignTokens.BrandColor.relatedConcepts)
                    .offset(x: -35, y: -130)
                Image(systemName: "arrow.up").foregroundColor(DesignTokens.BrandColor.relatedConcepts)
                    .offset(x: 35, y: -150)
            }
        }
    }
}

// MARK: - Inline Scene 13: Parasite, Partner, or Predator? (Topic 2)
private struct ParasitePartnerPredatorScene: View {
    let onComplete: (Int) -> Void

    private enum Kind: String, CaseIterable {
        case parasite = "Parasite"
        case partner = "Partner"
        case predator = "Predator"
    }
    private struct Q: Identifiable {
        let id: String; let emoji: String; let name: String; let detail: String; let correct: Kind
    }
    private let questions: [Q] = [
        Q(id: "q1", emoji: "🌿", name: "Cuscuta", detail: "Wraps around host plants, sucks their sap.",
          correct: .parasite),
        Q(id: "q2", emoji: "🌳", name: "Lichen",
          detail: "Alga + fungus living together; both gain from the deal.",
          correct: .partner),
        Q(id: "q3", emoji: "🍶", name: "Pitcher Plant",
          detail: "Lures insects into a digestive cup.", correct: .predator)
    ]

    @State private var answers: [String: Kind] = [:]
    private var score: Int {
        questions.reduce(0) { $0 + ((answers[$1.id] == $1.correct) ? 1 : 0) }
    }
    private var allAnswered: Bool { answers.count == questions.count }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Parasite, Partner, or Predator?")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("For each plant, pick the right category.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                ForEach(questions) { q in
                    questionCard(q)
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .padding(.horizontal, 24)
                }
                if allAnswered {
                    Text("Score: \(score) / \(questions.count)")
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .padding(.top, 8)
                }
                GotItButton(action: { onComplete(score) }).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    @ViewBuilder
    private func questionCard(_ q: Q) -> some View {
        let answer = answers[q.id]
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Text(q.emoji).font(.title)
                VStack(alignment: .leading, spacing: 2) {
                    Text(q.name).font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text(q.detail).font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
            }
            HStack(spacing: 8) {
                ForEach(Kind.allCases, id: \.self) { k in
                    answerButton(q: q, kind: k, picked: answer)
                }
            }
            if let picked = answer {
                Text(picked == q.correct ? "Correct — \(q.correct.rawValue)." : "Not quite — the answer is \(q.correct.rawValue).")
                    .font(.caption)
                    .foregroundColor(picked == q.correct
                                     ? DesignTokens.BrandColor.primaryAction
                                     : DesignTokens.BrandColor.danger)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
    }

    private func answerButton(q: Q, kind: Kind, picked: Kind?) -> some View {
        let isPicked = picked == kind
        let isCorrect = kind == q.correct
        let tint: Color = {
            guard picked != nil else { return Color.compatIndigo }
            if isPicked { return isCorrect ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger }
            return Color.gray
        }()
        return Button {
            if answers[q.id] == nil { answers[q.id] = kind }
        } label: {
            Text(kind.rawValue)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10).padding(.vertical, 6)
                .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                .foregroundColor(tint)
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .disabled(picked != nil)
    }
}

// MARK: - Inline Scene 14: Venus Flytrap Reflex (Topic 2)
//
// Timing mini-game: a "fly" appears on the open trap; the kid has a
// short window to tap "Snap!" before the fly escapes. Caught flies
// count toward score. 5 rounds total.
private struct VenusFlytrapReflexScene: View {
    let onComplete: (Int) -> Void

    @State private var round: Int = 0
    @State private var caught: Int = 0
    @State private var flyOnTrap: Bool = false
    @State private var trapClosed: Bool = false
    @State private var roundActive: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let totalRounds = 5

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Venus Flytrap Reflex")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("A bug lands on the trap — tap Snap! before it escapes. The trap closes when triggered twice within seconds (a real safety check the plant evolved).")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                trapVisual
                    .frame(width: 240, height: 160)
                controlRow
                Text("Caught: \(caught) / \(totalRounds)  ·  Round: \(min(round + 1, totalRounds))")
                    .font(.callout.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                if round >= totalRounds {
                    Text("Done! The real plant catches 1-3 bugs in its life — most rounds are practice.")
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .padding(.horizontal, 24)
                        .multilineTextAlignment(.center)
                }
                GotItButton(action: { onComplete(caught) }).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var trapVisual: some View {
        ZStack {
            // Two clamshell leaves
            HStack(spacing: trapClosed ? 0 : 6) {
                lobe(rotation: trapClosed ? 10 : -25)
                lobe(rotation: trapClosed ? -10 : 25)
            }
            if flyOnTrap && !trapClosed {
                Text("🪰").font(.title)
            }
        }
    }

    private func lobe(rotation: Double) -> some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(LinearGradient(colors: [Color.green, Color.red.opacity(0.55)],
                                  startPoint: .top, endPoint: .bottom))
            .frame(width: 95, height: 110)
            .rotationEffect(.degrees(rotation))
    }

    private var controlRow: some View {
        HStack(spacing: 14) {
            Button { startRound() } label: {
                Text(round >= totalRounds ? "Replay" : "Release a bug")
                    .font(.body.weight(.semibold))
                    .padding(.horizontal, 16).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }
            .buttonStyle(.plain).pointingCursor()
            .disabled(roundActive)

            Button { snap() } label: {
                Text("Snap!")
                    .font(.body.weight(.bold))
                    .padding(.horizontal, 16).padding(.vertical, 9)
                    .background(Capsule().fill(DesignTokens.BrandColor.danger.opacity(0.18)))
                    .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                    .foregroundColor(DesignTokens.BrandColor.danger)
            }
            .buttonStyle(.plain).pointingCursor()
            .disabled(!flyOnTrap || trapClosed)
        }
    }

    private func startRound() {
        if round >= totalRounds {
            round = 0; caught = 0
        }
        flyOnTrap = false; trapClosed = false; roundActive = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 600_000_000)
            withAnimation { flyOnTrap = true }
            // Window: 1500ms before fly escapes
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            if flyOnTrap && !trapClosed {
                // Escaped
                withAnimation { flyOnTrap = false }
                round += 1; roundActive = false
            }
        }
    }

    private func snap() {
        if flyOnTrap && !trapClosed {
            let a = reduceMotion ? Animation.linear(duration: 0.0) : .easeIn(duration: 0.15)
            withAnimation(a) {
                trapClosed = true; flyOnTrap = false
            }
            caught += 1
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 800_000_000)
                round += 1; roundActive = false
                withAnimation { trapClosed = false }
            }
        }
    }
}

// MARK: - Inline Scene 15: Sort the Feeders (Topic 2 → 3 bridge)
private struct SortTheFeedersScene: View {
    let onComplete: () -> Void

    private enum Bucket: String, CaseIterable {
        case autotroph = "Autotroph"
        case parasite = "Parasite"
        case saprotroph = "Saprotroph"
        case insectivore = "Insectivore"
    }
    private struct Org: Identifiable {
        let id: String; let emoji: String; let name: String; let correct: Bucket
    }
    private let organisms: [Org] = [
        Org(id: "rice", emoji: "🌾", name: "Rice plant", correct: .autotroph),
        Org(id: "cuscuta", emoji: "🌿", name: "Cuscuta", correct: .parasite),
        Org(id: "mould", emoji: "🍞", name: "Bread mould", correct: .saprotroph),
        Org(id: "pitcher", emoji: "🍶", name: "Pitcher Plant", correct: .insectivore),
        Org(id: "oak", emoji: "🌳", name: "Oak tree", correct: .autotroph),
        Org(id: "mush", emoji: "🍄", name: "Mushroom", correct: .saprotroph)
    ]

    @State private var assignment: [String: Bucket] = [:]
    private var allSorted: Bool { assignment.count == organisms.count }
    private var correctCount: Int {
        organisms.reduce(0) { $0 + ((assignment[$1.id] == $1.correct) ? 1 : 0) }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Sort the Feeders")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Tap an organism, then tap a bucket to file it. Mix-up an answer? Hit Reset to try again.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                organismRow
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                bucketRow
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                if allSorted {
                    Text("Sorted \(correctCount) / \(organisms.count) correctly.")
                        .font(.headline)
                        .foregroundColor(correctCount == organisms.count
                                          ? DesignTokens.BrandColor.primaryAction
                                          : DesignTokens.BrandColor.canvasText)
                }
                HStack(spacing: 14) {
                    Button("Reset") { assignment = [:] }
                        .disabled(assignment.isEmpty)
                    GotItButton(action: onComplete)
                }
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var organismRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Organisms").font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            HStack(spacing: 6) {
                ForEach(organisms) { o in
                    organismChip(o)
                }
            }
        }
    }

    private var bucketRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Buckets — tap to file the selected organism")
                .font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            HStack(spacing: 6) {
                ForEach(Bucket.allCases, id: \.self) { b in
                    bucketChip(b)
                }
            }
        }
    }

    @State private var selectedOrg: String? = nil
    private func organismChip(_ o: Org) -> some View {
        let assigned = assignment[o.id]
        let isSelected = selectedOrg == o.id
        let tint: Color = assigned == nil
            ? (isSelected ? Color.compatIndigo : Color.gray)
            : (assigned == o.correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger)
        return Button { if assignment[o.id] == nil { selectedOrg = o.id } } label: {
            VStack(spacing: 2) {
                Text(o.emoji).font(.title3)
                Text(o.name).font(.caption2)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8).fill(tint.opacity(isSelected ? 0.2 : 0.08)))
            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(tint.opacity(0.45), lineWidth: 1))
        }
        .buttonStyle(.plain).pointingCursor()
    }

    private func bucketChip(_ b: Bucket) -> some View {
        Button {
            if let s = selectedOrg, assignment[s] == nil {
                assignment[s] = b
                selectedOrg = nil
            }
        } label: {
            Text(b.rawValue)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10).padding(.vertical, 6)
                .background(Capsule().fill(Color.compatIndigo.opacity(0.10)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.4), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }
        .buttonStyle(.plain).pointingCursor()
        .disabled(selectedOrg == nil)
    }
}

// MARK: - Inline Scene 16: Soil Layers Lab (Topic 3)
private struct SoilLayersLabScene: View {
    let onComplete: () -> Void

    private struct Layer: Identifiable {
        let id: String; let name: String; let depth: String; let detail: String; let color: Color
    }
    private let layers: [Layer] = [
        Layer(id: "litter", name: "Litter", depth: "0–2 cm",
              detail: "Dead leaves, twigs. Earthworms and fungi feed here.",
              color: Color.compatBrown.opacity(0.4)),
        Layer(id: "topsoil", name: "Topsoil", depth: "2–25 cm",
              detail: "Roots + humus. Nitrogen, phosphorus, potassium — most plant food lives here.",
              color: Color.compatBrown.opacity(0.55)),
        Layer(id: "subsoil", name: "Subsoil", depth: "25–80 cm",
              detail: "Mostly clay + minerals. Deep roots reach for water.",
              color: Color.orange.opacity(0.45)),
        Layer(id: "parent", name: "Parent Rock", depth: "80 cm+",
              detail: "Slowly weathers into soil over thousands of years.",
              color: Color.gray.opacity(0.5))
    ]

    @State private var tapped: Set<String> = []

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Soil Layers Lab")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Tap each layer to see what lives there. Soil isn't one thing — it's a stack of zones.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                VStack(spacing: 0) {
                    ForEach(layers) { layer in
                        layerBand(layer)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)
                if tapped.count == layers.count {
                    Text("Whole profile explored.")
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.primaryAction)
                }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    @ViewBuilder
    private func layerBand(_ layer: Layer) -> some View {
        let isOpen = tapped.contains(layer.id)
        Button { tapped.insert(layer.id) } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(layer.name).font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Spacer()
                    Text(layer.depth).font(.caption.monospacedDigit())
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
                if isOpen {
                    Text(layer.detail).font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("Tap to reveal").font(.caption.italic())
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(layer.color)
        }
        .buttonStyle(.plain).pointingCursor()
    }
}

// MARK: - Inline Scene 17: Rhizobium Nitrogen Factory (Topic 3)
private struct RhizobiumNitrogenScene: View {
    let onComplete: () -> Void
    @State private var noduleOpen: Bool = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Rhizobium: The Nitrogen Factory")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Bean and pea roots have pink-white bumps called nodules. Inside each one, Rhizobium bacteria pull nitrogen straight out of the air.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                rootDiagram.frame(width: 220, height: 200)
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) { noduleOpen.toggle() }
                } label: {
                    Text(noduleOpen ? "Hide the bacteria" : "Magnify a nodule")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                if noduleOpen { magnifiedCard }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var rootDiagram: some View {
        ZStack {
            Rectangle().fill(Color.compatBrown.opacity(0.6)).frame(width: 10, height: 180)
            ForEach(0..<5, id: \.self) { i in
                Circle().fill(Color.pink.opacity(0.6))
                    .frame(width: 22, height: 22)
                    .offset(x: i.isMultiple(of: 2) ? -18 : 18, y: -70 + CGFloat(i * 30))
            }
        }
    }

    private var magnifiedCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Inside the nodule").font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Rhizobium bacteria take N₂ gas from the air pockets in soil and turn it into NH₃ (ammonia) — a form roots can absorb. The plant gives them shelter + sugar in exchange. This is why farmers rotate beans into a wheat field: the bacteria leave behind 'free' nitrogen the next crop can use.")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: DesignTokens.contentMaxWidth)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.2), lineWidth: 1))
        .padding(.horizontal, 24)
    }
}

// MARK: - Inline Scene 18: Food Chain Builder (Topic 3)
private struct FoodChainBuilderScene: View {
    let onComplete: () -> Void

    private struct Org: Identifiable {
        let id: String; let emoji: String; let name: String; let position: Int
    }
    private let target: [Org] = [
        Org(id: "grass", emoji: "🌾", name: "Grass", position: 0),
        Org(id: "hopper", emoji: "🦗", name: "Grasshopper", position: 1),
        Org(id: "frog", emoji: "🐸", name: "Frog", position: 2),
        Org(id: "snake", emoji: "🐍", name: "Snake", position: 3),
        Org(id: "hawk", emoji: "🦅", name: "Hawk", position: 4)
    ]
    @State private var built: [Org] = []
    @State private var available: [Org] = []
    @State private var feedback: String = ""

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Food Chain Builder")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Tap organisms in order from producer (eats sunlight) to top predator (eaten by no one).")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                chainView
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                availableView
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                if !feedback.isEmpty {
                    Text(feedback).font(.callout.weight(.semibold))
                        .foregroundColor(feedback.hasPrefix("Perfect")
                                         ? DesignTokens.BrandColor.primaryAction
                                         : DesignTokens.BrandColor.danger)
                }
                HStack(spacing: 14) {
                    Button("Reset") { reset() }
                    GotItButton(action: onComplete)
                }
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
            .onAppear { reset() }
        }
    }

    private var chainView: some View {
        HStack(spacing: 6) {
            ForEach(0..<5, id: \.self) { i in
                if i < built.count {
                    orgCard(built[i], filled: true)
                    if i < 4 {
                        Image(systemName: "arrow.right")
                            .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
                    }
                } else {
                    placeholderCard
                    if i < 4 {
                        Image(systemName: "arrow.right")
                            .foregroundColor(Color.gray.opacity(0.3))
                    }
                }
            }
        }
    }

    private var availableView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Tap to add").font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            HStack(spacing: 6) {
                ForEach(available) { o in
                    Button { append(o) } label: { orgCard(o, filled: false) }
                        .buttonStyle(.plain).pointingCursor()
                }
            }
        }
    }

    private func orgCard(_ o: Org, filled: Bool) -> some View {
        VStack(spacing: 2) {
            Text(o.emoji).font(.title3)
            Text(o.name).font(.caption2)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8)
                    .fill(filled
                          ? DesignTokens.BrandColor.primaryAction.opacity(0.15)
                          : Color.gray.opacity(0.08)))
        .overlay(RoundedRectangle(cornerRadius: 8)
                 .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1))
    }

    private var placeholderCard: some View {
        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.05))
            .frame(width: 64, height: 64)
            .overlay(RoundedRectangle(cornerRadius: 8)
                     .strokeBorder(Color.gray.opacity(0.2),
                                   style: StrokeStyle(lineWidth: 1, dash: [4])))
    }

    private func reset() {
        built = []
        available = target.shuffled()
        feedback = ""
    }

    private func append(_ o: Org) {
        let expectedPos = built.count
        if o.position == expectedPos {
            built.append(o)
            available.removeAll { $0.id == o.id }
            if built.count == target.count {
                feedback = "Perfect! Energy flows from grass to hawk."
            }
        } else {
            feedback = "Not yet — \(o.name) doesn't fit at position \(expectedPos + 1)."
        }
    }
}

// MARK: - Inline Scene 19: Compost Pit Timeline (Topic 3)
private struct CompostTimelineScene: View {
    let onComplete: () -> Void
    @State private var day: Double = 0

    private var stage: Int {
        if day < 8 { return 0 }
        if day < 18 { return 1 }
        return 2
    }
    private var stageLabel: String {
        ["Fresh waste — bacteria start eating sugars.",
         "Mushy — fungi join, breaking down tougher cellulose.",
         "Humus — black, crumbly soil. Plant food."][stage]
    }
    private var stageEmoji: String {
        ["🍌", "🥬", "🟫"][stage]
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Compost Pit Timeline")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Drag the slider across 30 days to watch bacteria and fungi turn kitchen waste into rich soil.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Text(stageEmoji).font(.system(size: 80))
                Text("Day \(Int(day))")
                    .font(.headline.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Slider(value: $day, in: 0...30)
                    .frame(maxWidth: 340)
                    .padding(.horizontal, 24)
                Text(stageLabel)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Van Helmont's Willow (inline Scene 20)
//
// Goes beyond NCERT to plant the central "where does a tree's mass come
// from?" question in the kid's mind. Belgian scientist Jan Baptista van
// Helmont in the 1640s grew a willow from 2 kg to 76 kg over 5 years
// using only rainwater — and the soil weight barely changed. Where did
// the extra 74 kg come from? The answer (mostly CO₂ from air) blows
// minds because it inverts intuition: a tree is, mostly, captured sky.
//
// Interaction: the kid moves a slider 0 → 5 years. Tree weight rises
// non-linearly while soil weight stays nearly flat. A "Where did the
// mass come from?" guessing step with three options reveals the
// CO₂-from-air answer with a short explanation card.
//
// Big Sur compatible: no .symbolEffect, no .foregroundStyle, no
// macOS 12+ APIs; body text routes through DesignTokens.BrandColor.
private struct VanHelmontWillowScene: View {
    let onComplete: () -> Void

    @State private var years: Double = 0
    @State private var guessRevealed = false
    @State private var pickedOption: String? = nil

    /// Named option type so SwiftUI gets a stable Identifiable view of
    /// the choices. Originally this was a tuple-array with
    /// `ForEach(options, id: \.label)` — keypath-into-labeled-tuple is
    /// fragile on Swift 5.5 (the Big Sur deploy compiler) and produced
    /// "Entangling fence requested after pre-commit" SwiftUI warnings
    /// plus an EXC_BAD_ACCESS during the transition into this scene.
    private struct GuessOption: Identifiable {
        let id: String       // also serves as the label
        let isCorrect: Bool
        let explanation: String
    }

    // Tree mass grew roughly: 2.3 kg start → 76 kg at 5 years. Smooth a
    // curve through that. Soil drops by ~60 g over 5 years (barely
    // moves on the kid-facing dial — we round to one decimal kg).
    private var treeKg: Double {
        // Polynomial fit close to 2.3 + (76 - 2.3) * (t/5)^1.5 — slow
        // start, faster middle, levelling near end.
        let t = max(0, min(5, years))
        let frac = pow(t / 5.0, 1.5)
        return 2.3 + (76.0 - 2.3) * frac
    }
    private var soilKg: Double {
        // Started at 90.7 kg, ended ~90.64 kg. Treat as constant in
        // display; show one decimal so the kid sees it doesn't move.
        let t = max(0, min(5, years))
        return 90.7 - 0.012 * t
    }

    private let options: [GuessOption] = [
        GuessOption(id: "From the soil",
                    isCorrect: false,
                    explanation: "The soil weighed almost the same at the end — only ~60 g less. The tree did not eat the soil."),
        GuessOption(id: "From the rainwater",
                    isCorrect: false,
                    explanation: "Water gave the tree hydrogen and oxygen, but not most of the mass. Trees are mostly carbon."),
        GuessOption(id: "From CO₂ in the air",
                    isCorrect: true,
                    explanation: "Photosynthesis pulls CO₂ out of the air and locks the carbon into wood, leaves and bark. A tree is, mostly, captured sky.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                Text("Van Helmont's Willow")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)

                Text("In the 1640s, Belgian scientist Jan Baptista van Helmont planted a 2 kg willow in 90 kg of dry soil. For 5 years he watered it with rainwater only. Move the slider and watch what happens.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: 600)

                // Visualisation
                HStack(alignment: .bottom, spacing: 28) {
                    VStack(spacing: 6) {
                        // No .animation(_:value:) — that's a macOS 12+
                        // modifier (CLAUDE.md forbids macOS 12 APIs on
                        // our Big Sur deploy target). Wrap the slider
                        // change in withAnimation in the binding instead.
                        Text("🌳")
                            .font(.system(size: 18 + CGFloat(treeKg * 0.55)))
                        Text("Tree: \(String(format: "%.1f", treeKg)) kg")
                            .font(.subheadline.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                    }
                    .frame(width: 160)

                    VStack(spacing: 6) {
                        Text("🟫")
                            .font(.system(size: 56))
                        Text("Soil: \(String(format: "%.2f", soilKg)) kg")
                            .font(.subheadline.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                    }
                    .frame(width: 160)
                }
                .frame(maxWidth: 600)
                .padding(.vertical, 8)

                SoftShadowCard(padding: 14) {
                    VStack(spacing: 8) {
                        Text("Time: \(Int(years.rounded())) year\(Int(years.rounded()) == 1 ? "" : "s")")
                            .font(.subheadline)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        Slider(value: $years, in: 0...5, step: 1)
                            .frame(maxWidth: 340)
                    }
                }
                .frame(maxWidth: 600)

                if years >= 5 && !guessRevealed {
                    VStack(spacing: 10) {
                        Text("Where did the extra 74 kg come from?")
                            .font(.title3.bold())
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .multilineTextAlignment(.center)
                        VStack(spacing: 8) {
                            ForEach(options) { opt in
                                Button {
                                    pickedOption = opt.id
                                    guessRevealed = true
                                } label: {
                                    HStack {
                                        Text(opt.id)
                                            .font(.body)
                                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.white)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .strokeBorder(Color.gray.opacity(0.25), lineWidth: 1.2)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(maxWidth: 520)
                    }
                    .padding(.top, 8)
                }

                if guessRevealed, let picked = pickedOption,
                   let chosen = options.first(where: { $0.id == picked }) {
                    SoftShadowCard(padding: 14) {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: chosen.isCorrect ? "checkmark.circle.fill" : "info.circle.fill")
                                .foregroundColor(chosen.isCorrect ? .green : Color.compatIndigo)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(chosen.isCorrect ? "Right!" : "Good guess, but not quite.")
                                    .font(.headline)
                                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                                Text(chosen.explanation)
                                    .font(.callout)
                                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                                    .multilineTextAlignment(.leading)
                                if !chosen.isCorrect {
                                    Text("The real answer: " + (options.first(where: { $0.isCorrect })?.explanation ?? ""))
                                        .font(.callout)
                                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                                        .padding(.top, 4)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: 600)

                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}
