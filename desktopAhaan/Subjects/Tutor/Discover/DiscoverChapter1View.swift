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
    }

    @ViewBuilder
    private func sceneBody(_ index: Int) -> some View {
        switch index {
        case 0: Scene1_PlantKitchen(pack: pack, chapter: chapter, onComplete: { markComplete(0) })
        case 1: Scene2_PhotosynthesisLab(pack: pack, chapter: chapter, onComplete: { markComplete(1) })
        case 2: Scene3_InsideALeaf(pack: pack, chapter: chapter, onComplete: { markComplete(2) })
        case 3: Scene4_ColorTheChlorophyll(pack: pack, chapter: chapter, onComplete: { markComplete(3) })
        case 4: Scene5_AutotrophHeterotroph(pack: pack, chapter: chapter, onComplete: { score in markComplete(4, score: score, max: 12) })
        case 5: Scene6_MeetTheSpecialPlants(pack: pack, chapter: chapter, onComplete: { markComplete(5) })
        case 6: Scene7_PitcherPlantTrap(pack: pack, chapter: chapter, onComplete: { markComplete(6) })
        case 7: Scene8_NitrogenCycle(pack: pack, chapter: chapter, onComplete: { markComplete(7) })
        case 8: SymbiosisPartnershipsLabScene(onComplete: { markComplete(8) })
        case 9: Scene9_BossQuiz(pack: pack, chapter: chapter, onComplete: { score in markComplete(9, score: score, max: 5) })
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
