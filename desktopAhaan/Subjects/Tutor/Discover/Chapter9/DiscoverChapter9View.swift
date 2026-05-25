import SwiftUI

struct DiscoverChapter9View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(9)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Soil Profile Dig",
        "Sand, Clay or Loam?",
        "Percolation Rate",
        "Which Crop, Which Soil?",
        "Soil Erosion Story",
        "Air & Moisture in Soil",
        "Worm — the Engineer",
        "Conservation Hero",
        "How Soil Forms (Centuries)",
        "Indian Soil Types Atlas",
        "Soil pH for Crops",
        "Compost Pit Recipe",
        "Vermicompost Lab",
        "Crop Rotation Wheel",
        "Terrace Farming Reveal",
        "Soil Texture Pyramid",
        "Microbes in the Soil",
        "Water Holding Capacity",
        "Soil Quality Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 9 — Soil",
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
            { AnyView(Scene1_SoilProfileDig(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_SandClayLoam(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(1, score: score, max: 3) })) },
            { AnyView(Scene3_PercolationRate(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_WhichCropWhichSoil(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(3, score: score, max: 4) })) },
            { AnyView(Scene5_SoilErosionStory(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_AirMoistureInSoil(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_WormEngineer(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_ConservationHero(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(SoilFormationStepperScene(onComplete: { self.markComplete(8) })) },
            { AnyView(IndianSoilTypesAtlasScene(onComplete: { self.markComplete(9) })) },
            { AnyView(SoilPHForCropsScene(onComplete: { self.markComplete(10) })) },
            { AnyView(CompostPitRecipeScene(onComplete: { self.markComplete(11) })) },
            { AnyView(VermicompostLabScene(onComplete: { self.markComplete(12) })) },
            { AnyView(CropRotationWheelScene(onComplete: { self.markComplete(13) })) },
            { AnyView(TerraceFarmingScene(onComplete: { self.markComplete(14) })) },
            { AnyView(SoilTexturePyramidScene(onComplete: { self.markComplete(15) })) },
            { AnyView(MicrobesInSoilScene(onComplete: { self.markComplete(16) })) },
            { AnyView(WaterHoldingCapacityScene(onComplete: { self.markComplete(17) })) },
            { AnyView(SoilQualityQuizScene(onComplete: { score in self.markComplete(18, score: score, max: 4) })) },
            { AnyView(Scene9_BossQuiz_Ch9(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.9

private struct SoilFormationStepperScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🪨", "Step 1: bare rock. Sun, wind, ice, and water start breaking it."),
        ("🌧", "Step 2: rain seeps into cracks. Freeze-thaw breaks chunks off."),
        ("🦠", "Step 3: lichens and mosses move in. They release acid that dissolves rock."),
        ("🌱", "Step 4: dead plants + animal droppings add humus. Now plants can root."),
        ("🌳", "Step 5: after 1000+ years, full soil profile with multiple layers.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("How Soil Forms (Centuries)").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(steps[step].0).font(.system(size: 100))
            Text(steps[step].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { step = (step + 1) % steps.count } } label: {
                Text("Next").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct IndianSoilTypesAtlasScene: View {
    let onComplete: () -> Void
    @State private var selected: String? = nil
    private struct S: Identifiable { let id: String; let name: String; let region: String; let detail: String }
    private let soils: [S] = [
        S(id: "alluvial", name: "Alluvial", region: "Gangetic plain, Brahmaputra valley",
          detail: "Made from river sediment. Most fertile in India. Rice, wheat, sugarcane belt."),
        S(id: "black", name: "Black (Regur)", region: "Maharashtra, Madhya Pradesh, Gujarat",
          detail: "From volcanic rock. Holds water well. Cotton, soybean love it."),
        S(id: "red", name: "Red", region: "Tamil Nadu, Karnataka, Odisha",
          detail: "Iron-rich, less fertile. Millet, groundnut, pulses."),
        S(id: "laterite", name: "Laterite", region: "Kerala, Karnataka, Konkan",
          detail: "Heavy rain washes away nutrients. Used for bricks. Cashew, tea, rubber."),
        S(id: "desert", name: "Desert (Arid)", region: "Rajasthan, parts of Gujarat",
          detail: "Sandy, low water. Bajra (millet) survives well.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Indian Soil Types Atlas").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(soils) { s in
                Button { selected = s.id } label: {
                    HStack {
                        Text(s.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                        Text(s.region).font(.caption).foregroundColor(.secondary).lineLimit(1)
                    }
                    .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(selected == s.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
            }
            if let s = selected, let item = soils.first(where: { $0.id == s }) {
                Text(item.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct SoilPHForCropsScene: View {
    let onComplete: () -> Void
    @State private var ph: Double = 6.5
    private var crop: String {
        if ph < 5 { return "Acidic — only blueberries and tea like it this sour." }
        if ph < 6 { return "Mildly acidic — potatoes, peanuts." }
        if ph < 7.5 { return "Sweet spot — wheat, rice, beans, most vegetables." }
        if ph < 8.5 { return "Mildly alkaline — barley, sugar beet." }
        return "Too alkaline — most crops fail. Needs gypsum to fix."
    }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Soil pH Decides the Crop").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("pH \(String(format: "%.1f", ph))").font(.title2.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $ph, in: 3...10).frame(maxWidth: 340).padding(.horizontal, 24)
            Text(crop).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct CompostPitRecipeScene: View {
    let onComplete: () -> Void
    @State private var greens: Bool = false
    @State private var browns: Bool = false
    @State private var moisture: Bool = false
    @State private var air: Bool = false
    private var ready: Bool { greens && browns && moisture && air }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Compost Pit Recipe").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Add all four ingredients in the right balance. Microbes do the rest in 4-6 weeks.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            VStack(spacing: 8) {
                ingredientToggle("Greens (vegetable peels)", on: $greens)
                ingredientToggle("Browns (dry leaves)", on: $browns)
                ingredientToggle("Moisture (water)", on: $moisture)
                ingredientToggle("Air (turn weekly)", on: $air)
            }.padding(.horizontal, 24)
            Text(ready ? "🌱 Compost is brewing!" : "⏳ Add what's missing.")
                .font(.headline)
                .foregroundColor(ready ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.canvasTextSecondary)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func ingredientToggle(_ label: String, on: Binding<Bool>) -> some View {
        Button { on.wrappedValue.toggle() } label: {
            HStack {
                Image(systemName: on.wrappedValue ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(on.wrappedValue ? DesignTokens.BrandColor.primaryAction : .gray)
                Text(label).foregroundColor(DesignTokens.BrandColor.canvasText)
                Spacer()
            }
            .padding(10)
            .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.85)))
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct VermicompostLabScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0
    private let stages = [
        ("🍌", "Day 0: kitchen waste + paper in a bin."),
        ("🪱", "Add red wigglers — special composting worms."),
        ("💩", "Worms eat continuously. Their droppings = vermicompost."),
        ("🌿", "Week 4: rich black soil amendment, 5× more nitrogen than ordinary compost.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Vermicompost — Worms as Workers").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(stages[stage].0).font(.system(size: 100))
            Text(stages[stage].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { stage = (stage + 1) % stages.count } } label: {
                Text("Next").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct CropRotationWheelScene: View {
    let onComplete: () -> Void
    @State private var season: Int = 0
    private let crops = ["🌾 Wheat (winter)", "🌻 Mustard (spring)", "🥬 Pulses (summer)", "🌽 Maize (monsoon)"]
    private let benefits = [
        "Heavy nitrogen user. Next crop should restore N.",
        "Light nitrogen user, deep tap roots aerate soil.",
        "Legumes — Rhizobium in roots fixes nitrogen.",
        "Different pest cycle. Breaks insect populations."
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Crop Rotation Wheel").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Same field, different crop each season. Prevents soil exhaustion and breaks pest cycles.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            Text(crops[season]).font(.title2.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text(benefits[season]).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { season = (season + 1) % crops.count } } label: {
                Text("Next season").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct TerraceFarmingScene: View {
    let onComplete: () -> Void
    @State private var revealed: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Terrace Farming on Hillsides").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Sloped land + heavy rain = soil washes away. Solution: cut flat steps into the hillside.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            ZStack {
                Rectangle().fill(DesignTokens.BrandColor.primaryAction.opacity(0.45))
                    .frame(width: 240, height: 30).offset(y: -75)
                Rectangle().fill(DesignTokens.BrandColor.primaryAction.opacity(0.6))
                    .frame(width: revealed ? 200 : 240, height: 30).offset(y: -45)
                Rectangle().fill(DesignTokens.BrandColor.primaryAction.opacity(0.7))
                    .frame(width: revealed ? 160 : 240, height: 30).offset(y: -15)
                Rectangle().fill(DesignTokens.BrandColor.primaryAction.opacity(0.85))
                    .frame(width: revealed ? 120 : 240, height: 30).offset(y: 15)
            }
            .frame(height: 160)
            Button { withAnimation { revealed.toggle() } } label: {
                Text(revealed ? "Show plain slope" : "Cut terraces").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            Text(revealed
                 ? "Terraced: rainwater pools in each step, soaks in slowly. Rice fields in Sikkim, Nagaland, Philippines."
                 : "Plain slope: rain runs off, taking topsoil with it. Field becomes barren in 5-10 years.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct SoilTexturePyramidScene: View {
    let onComplete: () -> Void
    @State private var sand: Double = 0.4
    @State private var silt: Double = 0.3
    private var clay: Double { max(0, 1 - sand - silt) }
    private var soilType: String {
        if clay > 0.4 { return "Clay-heavy — sticky, holds water, slow drainage." }
        if sand > 0.6 { return "Sandy — drains fast, dries quick." }
        if silt > 0.5 { return "Silty — soft, smooth, often near rivers." }
        return "Loam — the gold standard. Ideal for most crops."
    }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Soil Texture Pyramid").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            VStack(spacing: 4) {
                HStack(spacing: 0) {
                    Rectangle().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(0.7)).frame(width: CGFloat(sand) * 240)
                    Rectangle().fill(Color.compatTeal.opacity(0.7)).frame(width: CGFloat(silt) * 240)
                    Rectangle().fill(Color.compatBrown.opacity(0.7)).frame(width: CGFloat(clay) * 240)
                }
                .frame(width: 240, height: 30).cornerRadius(6)
                Text("\(Int(sand * 100))% sand · \(Int(silt * 100))% silt · \(Int(clay * 100))% clay")
                    .font(.caption.monospacedDigit()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            Text("Sand %").font(.caption).foregroundColor(.secondary)
            Slider(value: $sand, in: 0...0.95).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("Silt %").font(.caption).foregroundColor(.secondary)
            Slider(value: $silt, in: 0...max(0, 0.95 - sand)).frame(maxWidth: 340).padding(.horizontal, 24)
            Text(soilType).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct MicrobesInSoilScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct M: Identifiable { let id: String; let emoji: String; let name: String; let role: String }
    private let microbes: [M] = [
        M(id: "rhizo", emoji: "🦠", name: "Rhizobium", role: "Lives in legume root nodules. Fixes atmospheric N₂ into NH₃."),
        M(id: "mycor", emoji: "🍄", name: "Mycorrhizal fungi", role: "Extends a plant's root reach 100×. Trades phosphorus for sugar."),
        M(id: "decom", emoji: "💀", name: "Decomposer bacteria", role: "Break down dead plants + animals into humus, releasing nutrients."),
        M(id: "earth", emoji: "🪱", name: "Earthworms", role: "Tunnel through soil, aerate it, mix layers, leave nutrient-rich castings.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Hidden Workers Under the Soil").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("One teaspoon of healthy soil has more microbes than people on Earth. Tap each.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            ForEach(microbes) { m in
                Button { tapped.insert(m.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack { Text(m.emoji).font(.title2)
                            Text(m.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText) }
                        if tapped.contains(m.id) {
                            Text(m.role).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text("Tap to reveal").font(.caption.italic())
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }.padding(12).frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct WaterHoldingCapacityScene: View {
    let onComplete: () -> Void
    @State private var sandWater: CGFloat = 1.0
    @State private var loamWater: CGFloat = 1.0
    @State private var clayWater: CGFloat = 1.0
    @State private var running: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Which Soil Holds Water?").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 24) {
                bar("Sand", level: sandWater, color: DesignTokens.BrandColor.mnemonicAccent)
                bar("Loam", level: loamWater, color: DesignTokens.BrandColor.primaryAction)
                bar("Clay", level: clayWater, color: Color.compatBrown)
            }
            Button { runDrain() } label: {
                Text(running ? "Draining…" : "Pour water + let it drain").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor().disabled(running)
            Text("Sand drains in seconds. Clay holds water for days. Loam — best of both.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func bar(_ label: String, level: CGFloat, color: Color) -> some View {
        VStack {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.1)).frame(width: 60, height: 140)
                RoundedRectangle(cornerRadius: 8).fill(color.opacity(0.7)).frame(width: 60, height: 140 * level)
            }
            Text(label).font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
        }
    }
    private func runDrain() {
        running = true
        sandWater = 1; loamWater = 1; clayWater = 1
        Task { @MainActor in
            withAnimationRespectingReduceMotion(.linear(duration: 2.0)) {
                sandWater = 0.1; loamWater = 0.5; clayWater = 0.85
            }
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            running = false
        }
    }
}

private struct SoilQualityQuizScene: View {
    let onComplete: (Int) -> Void
    private struct Q: Identifiable {
        let id: String; let prompt: String; let opts: [String]; let correct: Int
    }
    private let qs: [Q] = [
        Q(id: "q1", prompt: "Best soil for growing rice?",
          opts: ["Sandy", "Clay-heavy with water", "Desert"], correct: 1),
        Q(id: "q2", prompt: "What turns dead leaves into humus?",
          opts: ["Sunlight", "Decomposer microbes", "Rain only"], correct: 1),
        Q(id: "q3", prompt: "Heavy rain on bare slopes does what?",
          opts: ["Improves soil", "Erodes topsoil away", "Adds nutrients"], correct: 1),
        Q(id: "q4", prompt: "Loam soil is best because…",
          opts: ["it's pretty", "it balances drainage + nutrients", "it's expensive"], correct: 1)
    ]
    @State private var picks: [String: Int] = [:]
    private var score: Int { qs.reduce(0) { $0 + ((picks[$1.id] == $1.correct) ? 1 : 0) } }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Soil Quality Quiz").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(qs) { q in qCard(q) }
            if picks.count == qs.count {
                Text("Score: \(score) / \(qs.count)").font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            GotItButton(action: { onComplete(score) }).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    @ViewBuilder
    private func qCard(_ q: Q) -> some View {
        let pick = picks[q.id]
        VStack(alignment: .leading, spacing: 8) {
            Text(q.prompt).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            ForEach(0..<q.opts.count, id: \.self) { i in
                let isPicked = pick == i
                let tint: Color = pick == nil
                    ? Color.compatIndigo
                    : (isPicked ? (i == q.correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger) : Color.gray)
                Button {
                    if picks[q.id] == nil { picks[q.id] = i }
                } label: {
                    Text(q.opts[i]).font(.caption.weight(.semibold))
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                        .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                        .foregroundColor(tint)
                }.buttonStyle(.plain).pointingCursor().disabled(pick != nil)
            }
        }
        .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, 24)
    }
}
