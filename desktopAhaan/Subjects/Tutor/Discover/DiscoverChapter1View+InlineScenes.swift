import SwiftUI

// MARK: - Inline Scenes for Chapter 1 Discover Mode
//
// Extracted from DiscoverChapter1View.swift 2026-05-22 to drop the
// dispatcher file below the ~600-line / 80-line-body threshold the
// 10-hour refactor mandate requires. The dispatcher in
// DiscoverChapter1View.swift references these structs via a `switch
// currentScene` block; they are otherwise unreferenced (verified via
// repo-wide grep before the split). Removing `private` turned them
// from file-private to module-internal — Same module, identical
// behaviour.

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
struct SymbiosisPartnershipsLabScene: View {
    let onComplete: () -> Void

    @State private var revealed: Set<String> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    struct Partnership: Identifiable {
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
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                }
                if allRevealed {
                    bothWinBadge
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                }
                LookingAheadCallout(
                    title: "Class 11 / NEET — Mutualism",
                    detail: "These three partnerships are the most-tested examples of mutualism. Mycorrhiza powers ~80% of all land plants in the wild. Rhizobium is why farmers rotate beans into a wheat field — the bacteria leave behind 'free' nitrogen in the soil for the next crop."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)
                TryAtHomeCallout(
                    title: "Spot a partnership outside",
                    detail: "Find any wall or tree bark and look for the crusty grey-green or yellow lichen — alga + fungus. If you grow beans or peas in a pot, gently scrape the soil around the root after a few weeks: you'll see tiny pink-white bumps. Those are the Rhizobium nodules in action."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)
                GotItButton(action: onComplete)
                    .padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
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
                .padding(.horizontal, DesignTokens.Spacing.xl)
        }
    }

    @ViewBuilder
    private func partnershipRow(_ p: Partnership) -> some View {
        let isRevealed = revealed.contains(p.id)
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: DesignTokens.Spacing.md) {
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
                    withAnimationRespectingReduceMotion(animation) { _ = revealed.insert(p.id) }
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
            HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                Image(systemName: "arrow.right")
                    .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
                Text("\(p.leftName) gives: ")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                + Text(p.leftGives)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
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
        .padding(.top, DesignTokens.Spacing.xs)
    }

    private var bothWinBadge: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(DesignTokens.BrandColor.primaryAction)
                .font(.title3)
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
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
struct StomataOpenCloseScene: View {
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
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                stomaDiagram
                    .frame(width: 320, height: 220)
                Button {
                    let a = reduceMotion ? Animation.linear(duration: 0.0) : .easeInOut(duration: 0.3)
                    withAnimationRespectingReduceMotion(a) { isOpen.toggle() }
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
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
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
            .padding(DesignTokens.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
    }
}

// MARK: - Inline Scene 11: Light & Photosynthesis Rate (Topic 1)
struct LightAndRateScene: View {
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
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                rateBar
                    .frame(width: 220, height: 180)
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: "sun.min.fill").foregroundColor(.gray)
                    Slider(value: $lightLevel, in: 0...1)
                    Image(systemName: "sun.max.fill").foregroundColor(DesignTokens.BrandColor.mnemonic)
                }
                .frame(maxWidth: 340)
                .padding(.horizontal, DesignTokens.Spacing.xl)
                rateCaption
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var rateBar: some View {
        let barH: CGFloat = 180 * CGFloat(rate)
        return VStack {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1))
                RoundedRectangle(cornerRadius: 10)
                    .fill(DesignTokens.BrandColor.primaryAction.opacity(0.6))
                    .frame(height: barH)
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
            .padding(DesignTokens.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
    }
}

// MARK: - Inline Scene 12: Water's Journey (Topic 1)
struct WaterJourneyScene: View {
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
                    withAnimationRespectingReduceMotion(a) {
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
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
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
                let rootX: CGFloat = CGFloat(i - 1) * 14
                let rootAngle: Double = Double(i - 1) * 25
                Rectangle().fill(stage >= 1 ? Color.compatTeal : Color.compatBrown.opacity(0.5))
                    .frame(width: 4, height: 30)
                    .offset(x: rootX, y: 100)
                    .rotationEffect(.degrees(rootAngle))
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

// Scenes ParasitePartnerPredator…CompostTimeline/VanHelmontWillow live in
// DiscoverChapter1View+InlineScenesB.swift and +InlineScenesC.swift —
// split out to bring this file under the 600-LOC Big Sur ceiling.
