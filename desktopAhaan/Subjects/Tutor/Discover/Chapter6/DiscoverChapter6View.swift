import SwiftUI

struct DiscoverChapter6View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(6)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Ice to Water to Steam",
        "Tearing vs Burning Paper",
        "Five Signs of Chemical Change",
        "The Rusting Experiment",
        "Galvanisation Shield",
        "Physical or Chemical?",
        "Crystal Garden",
        "Kitchen Chemistry",
        "Reversible vs Irreversible",
        "Combustion: Three Things Needed",
        "Photosynthesis = Chemical",
        "Curdling Milk Story",
        "Burning Magnesium Ribbon",
        "Mass Conservation Lab",
        "Crystallisation vs Evaporation",
        "Mixing Without Reacting",
        "Speed of a Reaction Slider",
        "Heat or Cold? — Energy of Change",
        "Real-World Chemical Change Atlas",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 6 — Physical and Chemical Changes",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
        // Defensive (2026-05-21): a stale @AppStorage value from before
        // a scene-count change could point past sceneTitles.count - 1.
        // sceneBody guards out-of-range by returning EmptyView, but a
        // blank canvas reads as a crash to the kid. Force a valid index
        // on every appearance.
        .onAppear {
            let maxIndex = sceneTitles.count - 1
            if currentScene < 0 || currentScene > maxIndex {
                currentScene = max(0, min(currentScene, maxIndex))
            }
        }
    }
    private func sceneBody(_ index: Int) -> AnyView {
        guard index >= 0 && index < sceneBuilders.count else { return AnyView(EmptyView()) }
        return sceneBuilders[index]()
    }

    private var sceneBuilders: [() -> AnyView] {
        [
            { AnyView(Scene1_IceToWaterToSteam(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_TearingVsBurningPaper(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_FiveSignsOfChemicalChange(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_TheRustingExperiment(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_GalvanisationShield(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_PhysicalOrChemicalSorting(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(5, score: score, max: 12) })) },
            { AnyView(Scene7_CrystalGarden(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_KitchenChemistry(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(ReversibleIrreversibleScene(onComplete: { self.markComplete(8) })) },
            { AnyView(CombustionTriangleScene(onComplete: { self.markComplete(9) })) },
            { AnyView(PhotosynthesisChemicalScene(onComplete: { self.markComplete(10) })) },
            { AnyView(CurdlingMilkScene(onComplete: { self.markComplete(11) })) },
            { AnyView(BurningMagnesiumScene(onComplete: { self.markComplete(12) })) },
            { AnyView(MassConservationLabScene(onComplete: { self.markComplete(13) })) },
            { AnyView(CrystallisationVsEvaporationScene(onComplete: { self.markComplete(14) })) },
            { AnyView(MixingWithoutReactingScene(onComplete: { self.markComplete(15) })) },
            { AnyView(ReactionSpeedSliderScene(onComplete: { self.markComplete(16) })) },
            { AnyView(EnergyOfChangeScene(onComplete: { self.markComplete(17) })) },
            { AnyView(ChemicalChangeAtlasScene(onComplete: { self.markComplete(18) })) },
            { AnyView(Scene9_BossQuiz_Ch6(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.6

private struct ReversibleIrreversibleScene: View {
    let onComplete: () -> Void
    @State private var reversible: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Reversible or Irreversible?").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip(label: "Reversible", picked: reversible) { reversible = true }
                pickChip(label: "Irreversible", picked: !reversible) { reversible = false }
            }
            Text(reversible
                 ? "Reversible: melt ice → freeze water back. Stretch rubber → release. Dissolve sugar → evaporate to recover. The original stuff comes back."
                 : "Irreversible: burning paper, baking a cake, rusting iron, frying an egg. New substance is made and you cannot undo it.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.leading).padding(14)
                .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                .padding(.horizontal, DesignTokens.Spacing.xl)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
    private func pickChip(label: String, picked: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(picked ? .bold : .regular))
                .padding(.horizontal, 18).padding(.vertical, 9)
                .background(Capsule().fill(picked ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct CombustionTriangleScene: View {
    let onComplete: () -> Void
    @State private var fuel: Bool = false
    @State private var oxygen: Bool = false
    @State private var heat: Bool = false
    private var burns: Bool { fuel && oxygen && heat }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Fire Triangle").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Burning needs ALL three: a fuel, oxygen, and a spark of heat. Remove any one → fire goes out.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
            Text(burns ? "🔥" : "💨").font(.system(size: 120))
            HStack(spacing: DesignTokens.Spacing.md) {
                toggleChip("Fuel", on: $fuel)
                toggleChip("O₂", on: $oxygen)
                toggleChip("Heat", on: $heat)
            }
            Text(burns ? "All three present — fire ignites." : "Missing one — no combustion.")
                .font(.callout.weight(.semibold))
                .foregroundColor(burns ? DesignTokens.BrandColor.danger : DesignTokens.BrandColor.canvasText)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
    private func toggleChip(_ label: String, on: Binding<Bool>) -> some View {
        Button { on.wrappedValue.toggle() } label: {
            Text(label).font(.body.weight(.semibold))
                .padding(.horizontal, DesignTokens.Spacing.lg).padding(.vertical, DesignTokens.Spacing.sm)
                .background(Capsule().fill(on.wrappedValue ? DesignTokens.BrandColor.danger.opacity(0.2) : Color.gray.opacity(0.1)))
                .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                .foregroundColor(DesignTokens.BrandColor.danger)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct PhotosynthesisChemicalScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Photosynthesis is a Chemical Change").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            VStack(spacing: DesignTokens.Spacing.sm) {
                Text("6 CO₂ + 6 H₂O").font(.title2.weight(.bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
                Image(systemName: "arrow.down").foregroundColor(DesignTokens.BrandColor.primaryAction)
                    .font(.title2)
                Text("sunlight + chlorophyll").font(.caption.italic())
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                Image(systemName: "arrow.down").foregroundColor(DesignTokens.BrandColor.primaryAction)
                    .font(.title2)
                Text("C₆H₁₂O₆ + 6 O₂").font(.title2.weight(.bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            .padding(20).frame(maxWidth: DesignTokens.contentMaxWidth)
            .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.card).fill(Color.white.opacity(0.85)))
            .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.card).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
            .padding(.horizontal, DesignTokens.Spacing.xl)
            Text("Water + carbon dioxide become sugar + oxygen. Completely new substances → chemical change. Reverses in respiration, where sugar + O₂ → CO₂ + water + energy.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct CurdlingMilkScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🥛", "Fresh milk: white liquid, pH ~6.7 (mildly acidic but smooth)."),
        ("🦠", "Add lactic-acid bacteria (a spoon of curd)."),
        ("🧪", "Bacteria eat lactose, release lactic acid. pH drops."),
        ("🥣", "At pH ~4.6, milk proteins clump. You have dahi.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Why Milk Becomes Curd").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(steps[step].0).font(.system(size: 100))
            Text(steps[step].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { step = (step + 1) % steps.count } } label: {
                Text("Next").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct BurningMagnesiumScene: View {
    let onComplete: () -> Void
    @State private var burning: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Burning Magnesium Ribbon").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("A textbook chemical change. Silvery ribbon + oxygen → blinding white light + white powder (magnesium oxide).")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
            ZStack {
                if burning {
                    Circle().fill(Color.white).frame(width: 140, height: 140)
                        .shadow(color: .yellow.opacity(0.6), radius: 30)
                    Text("✨").font(.system(size: 60))
                } else {
                    Capsule().fill(Color.gray.opacity(0.5)).frame(width: 160, height: 14)
                }
            }
            .frame(height: 160)
            Button { withAnimation { burning.toggle() } } label: {
                Text(burning ? "Cool down" : "Light it").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(DesignTokens.BrandColor.danger.opacity(0.18)))
                    .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                    .foregroundColor(DesignTokens.BrandColor.danger)
            }.buttonStyle(.plain).pointingCursor()
            Text("2 Mg + O₂ → 2 MgO. Don't look directly — the light has UV!")
                .font(.callout.italic()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.horizontal, DesignTokens.Spacing.xl).multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct MassConservationLabScene: View {
    let onComplete: () -> Void
    @State private var reacted: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Mass is Conserved").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Sealed beaker on a balance: vinegar + baking soda → CO₂ bubbles. If the lid is on, the mass stays exactly the same. Atoms just rearranged.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
            HStack(spacing: 30) {
                VStack {
                    Text("100 g").font(.title.monospacedDigit()).foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text("Before").font(.caption).foregroundColor(.secondary)
                }
                Image(systemName: "arrow.right").foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                VStack {
                    Text(reacted ? "100 g" : "—").font(.title.monospacedDigit()).foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text("After").font(.caption).foregroundColor(.secondary)
                }
            }
            Button { withAnimation { reacted.toggle() } } label: {
                Text(reacted ? "Reset" : "React (sealed)").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct CrystallisationVsEvaporationScene: View {
    let onComplete: () -> Void
    @State private var crystal: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Crystallisation vs Evaporation").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip(label: "Crystallisation", picked: crystal) { crystal = true }
                pickChip(label: "Evaporation", picked: !crystal) { crystal = false }
            }
            Text(crystal ? "💎" : "💨").font(.system(size: 100))
            Text(crystal
                 ? "Slow cooling of a hot saturated solution → pure regular-shaped crystals form. Better than evaporation because impurities stay in solution."
                 : "Heating drives off water → leaves all the solid behind, including impurities. Cheaper but less pure.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
    private func pickChip(label: String, picked: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(picked ? .bold : .regular))
                .padding(.horizontal, 14).padding(.vertical, DesignTokens.Spacing.sm)
                .background(Capsule().fill(picked ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct MixingWithoutReactingScene: View {
    let onComplete: () -> Void
    private struct Item: Identifiable {
        let id: String; let prompt: String; let reaction: Bool
    }
    private let items: [Item] = [
        Item(id: "i1", prompt: "Sand + iron filings — magnet pulls iron out", reaction: false),
        Item(id: "i2", prompt: "Sugar dissolved in water", reaction: false),
        Item(id: "i3", prompt: "Vinegar + baking soda fizzing", reaction: true),
        Item(id: "i4", prompt: "Salt + pepper in a bowl", reaction: false),
        Item(id: "i5", prompt: "Iron + dilute acid → hydrogen", reaction: true)
    ]
    @State private var picks: [String: Bool] = [:]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Just Mixed or Truly Reacted?").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Mixing alone = physical change. A reaction = chemical change with new substances.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
            ForEach(items) { i in row(i) }
            if picks.count == items.count {
                let correct = items.reduce(0) { $0 + ((picks[$1.id] == $1.reaction) ? 1 : 0) }
                Text("Score: \(correct) / \(items.count)").font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
    @ViewBuilder
    private func row(_ it: Item) -> some View {
        let pick = picks[it.id]
        VStack(alignment: .leading, spacing: 6) {
            Text(it.prompt).font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: DesignTokens.Spacing.sm) {
                ans("Mix only", false, pick, it.reaction, it.id)
                ans("Reaction", true, pick, it.reaction, it.id)
            }
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, DesignTokens.Spacing.xl)
    }
    private func ans(_ label: String, _ v: Bool, _ pick: Bool?, _ correct: Bool, _ id: String) -> some View {
        let isPicked = pick == v
        let tint: Color = pick == nil
            ? Color.compatIndigo
            : (isPicked ? (v == correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger) : Color.gray)
        return Button {
            if picks[id] == nil { picks[id] = v }
        } label: {
            Text(label).font(.caption.weight(.semibold))
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                .foregroundColor(tint)
        }.buttonStyle(.plain).pointingCursor().disabled(pick != nil)
    }
}

private struct ReactionSpeedSliderScene: View {
    let onComplete: () -> Void
    @State private var temp: Double = 25
    private var speed: Double { min(1.0, 0.05 + (temp - 5) / 100) }
    private var label: String {
        if temp < 10 { return "Cold: reactions crawl. That's why we keep food in a fridge." }
        if temp < 40 { return "Room temp: normal speed." }
        if temp < 70 { return "Warm: roughly doubles every +10 °C." }
        return "Hot: very fast — used in industrial reactors."
    }
    var body: some View {
        let fillH: CGFloat = 180 * CGFloat(speed)
        return ScrollView { LazyVStack(spacing: 14) {
            Text("What Speeds Up a Reaction?").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1))
                    .frame(width: 80, height: 180)
                RoundedRectangle(cornerRadius: 12).fill(DesignTokens.BrandColor.danger.opacity(0.6))
                    .frame(width: 80, height: fillH)
            }
            Text("Temperature: \(Int(temp)) °C").font(.callout.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $temp, in: 0...100).frame(maxWidth: 340).padding(.horizontal, DesignTokens.Spacing.xl)
            Text(label).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct EnergyOfChangeScene: View {
    let onComplete: () -> Void
    @State private var releases: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Heat or Cold? — Energy of Change").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip(label: "Releases heat", picked: releases) { releases = true }
                pickChip(label: "Absorbs heat", picked: !releases) { releases = false }
            }
            Text(releases ? "🔥" : "🥶").font(.system(size: 100))
            Text(releases
                 ? "Exothermic — releases heat. Examples: burning fuel, neutralising acid + base, cement setting."
                 : "Endothermic — absorbs heat (cools the surroundings). Examples: dissolving ammonium nitrate, melting ice, photosynthesis (uses sunlight).")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
    private func pickChip(label: String, picked: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(picked ? .bold : .regular))
                .padding(.horizontal, 14).padding(.vertical, DesignTokens.Spacing.sm)
                .background(Capsule().fill(picked ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct ChemicalChangeAtlasScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct Place: Identifiable { let id: String; let emoji: String; let name: String; let detail: String }
    private let places: [Place] = [
        Place(id: "kitchen", emoji: "🍳", name: "Kitchen", detail: "Cooking egg, baking bread, fermenting dosa batter — all chemical."),
        Place(id: "body", emoji: "🫀", name: "Your body", detail: "Digesting food, breathing, exercising — chains of chemical reactions."),
        Place(id: "factory", emoji: "🏭", name: "Factories", detail: "Steel from iron ore, plastic from petroleum, fertilisers from nitrogen."),
        Place(id: "nature", emoji: "🌱", name: "Outdoors", detail: "Leaves photosynthesising, fruits ripening, iron gates rusting.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Chemical Change is Everywhere").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(places) { p in
                Button { tapped.insert(p.id) } label: {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        HStack {
                            Text(p.emoji).font(.title2)
                            Text(p.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        }
                        if tapped.contains(p.id) {
                            Text(p.detail).font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text("Tap to reveal").font(.caption.italic())
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }
                    .padding(DesignTokens.Spacing.md)
                    .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, DesignTokens.Spacing.xl)
            }
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}
