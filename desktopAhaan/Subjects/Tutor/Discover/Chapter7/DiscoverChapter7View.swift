import SwiftUI

struct DiscoverChapter7View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(7)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Weather vs Climate",
        "Build a Weather Station",
        "Climate Zones Map",
        "Polar Bear Survival Kit",
        "Tropical Rainforest Life",
        "Adaptation Match Game",
        "Migration Superhero",
        "Desert Survival Tricks",
        "Rainfall & Humidity Slider",
        "Hibernation vs Migration",
        "Camel — Desert Adaptations",
        "Penguin — Polar Adaptations",
        "Mountain Goat Toolkit",
        "Monsoon Pattern Map",
        "Weather Symbols Quiz",
        "Climate Change Story",
        "Indian Climate Zones",
        "Animal-Habitat Matcher",
        "Weather Forecast Tools",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 7 — Weather, Climate and Adaptations",
            sceneTitles: sceneTitles,
            currentScene: $currentScene,
            scene: sceneBody
        )
    }

    private func sceneBody(_ index: Int) -> AnyView {
        guard index >= 0 && index < sceneBuilders.count else { return AnyView(EmptyView()) }
        return sceneBuilders[index]()
    }

    private var sceneBuilders: [() -> AnyView] {
        [
            { AnyView(Scene1_WeatherVsClimate(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_BuildAWeatherStation(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_ClimateZonesMap(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_PolarBearSurvivalKit(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_TropicalRainforestLife(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_AdaptationMatchGame(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(5, score: score, max: 12) })) },
            { AnyView(Scene7_MigrationSuperhero(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_DesertSurvivalTricks(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(RainfallHumiditySliderScene(onComplete: { self.markComplete(8) })) },
            { AnyView(HibernationMigrationScene(onComplete: { self.markComplete(9) })) },
            { AnyView(CamelDesertScene(onComplete: { self.markComplete(10) })) },
            { AnyView(PenguinPolarScene(onComplete: { self.markComplete(11) })) },
            { AnyView(MountainGoatToolkitScene(onComplete: { self.markComplete(12) })) },
            { AnyView(MonsoonMapScene(onComplete: { self.markComplete(13) })) },
            { AnyView(WeatherSymbolsQuizScene(onComplete: { score in self.markComplete(14, score: score, max: 4) })) },
            { AnyView(ClimateChangeStoryScene(onComplete: { self.markComplete(15) })) },
            { AnyView(IndianClimateZonesScene(onComplete: { self.markComplete(16) })) },
            { AnyView(AnimalHabitatMatcherScene(onComplete: { self.markComplete(17) })) },
            { AnyView(WeatherForecastToolsScene(onComplete: { self.markComplete(18) })) },
            { AnyView(Scene9_BossQuiz_Ch7(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 5) })) }
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

// MARK: - Inline scenes for Ch.7

private struct RainfallHumiditySliderScene: View {
    let onComplete: () -> Void
    @State private var rainfall: Double = 50
    private var label: String {
        if rainfall < 25 { return "Desert (< 25 cm/yr) — only cacti and camels." }
        if rainfall < 75 { return "Grassland — wheat, herds, mild seasons." }
        if rainfall < 150 { return "Temperate forest — oak, deer, four seasons." }
        return "Tropical rainforest — Amazon, Western Ghats. Dense canopy."
    }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Rainfall Shapes Habitats").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("\(Int(rainfall)) cm / year").font(.title2.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $rainfall, in: 0...300).frame(maxWidth: 340).padding(.horizontal, 24)
            Text(label).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct HibernationMigrationScene: View {
    let onComplete: () -> Void
    @State private var hibernate: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Survive Winter — Two Strategies").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip(label: "Hibernate", picked: hibernate) { hibernate = true }
                pickChip(label: "Migrate", picked: !hibernate) { hibernate = false }
            }
            Text(hibernate ? "🐻" : "🦢").font(.system(size: 100))
            Text(hibernate
                 ? "Hibernate: bears, marmots, hedgehogs eat heavily in autumn, then sleep deeply in dens. Body temperature, heart rate, breathing all drop to save energy. Wake up in spring."
                 : "Migrate: birds (Arctic tern, Siberian crane), butterflies (monarch), wildebeest. Travel thousands of km to warmer feeding grounds. Return home next season.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func pickChip(label: String, picked: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(picked ? .bold : .regular))
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Capsule().fill(picked ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct CamelDesertScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct Trait: Identifiable { let id: String; let title: String; let detail: String }
    private let traits: [Trait] = [
        Trait(id: "hump", title: "The hump", detail: "Stores fat (not water). Body breaks down fat for energy + makes water as a byproduct."),
        Trait(id: "eyes", title: "Long eyelashes + nostrils that close", detail: "Block sandstorms. Camels can walk through one without breathing in sand."),
        Trait(id: "feet", title: "Wide flat feet", detail: "Spread weight on soft sand — same idea as snowshoes."),
        Trait(id: "temp", title: "Tolerates body-temp swing", detail: "Body temperature can vary 6 °C between night and day to save water — most mammals would die.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Camel — The Desert Toolkit").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🐪").font(.system(size: 100))
            ForEach(traits) { t in
                Button { tapped.insert(t.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(t.title).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        if tapped.contains(t.id) {
                            Text(t.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

private struct PenguinPolarScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct Trait: Identifiable { let id: String; let title: String; let detail: String }
    private let traits: [Trait] = [
        Trait(id: "blubber", title: "Thick blubber + dense feathers", detail: "Layer of fat under the skin + waterproof feathers trap warmth."),
        Trait(id: "huddle", title: "Huddling behaviour", detail: "Hundreds stand pressed together. Outer penguins rotate in. Reduces wind exposure by 70%."),
        Trait(id: "feet", title: "Counter-current blood flow in feet", detail: "Cold blood from the foot pre-warms before reaching the body — feet stay near 0 °C, body stays at 38 °C."),
        Trait(id: "swim", title: "Streamlined body + flippers", detail: "Can swim up to 35 km/h to chase fish. Useless on land — they waddle.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Penguin — The Polar Toolkit").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🐧").font(.system(size: 100))
            ForEach(traits) { t in
                Button { tapped.insert(t.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(t.title).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        if tapped.contains(t.id) {
                            Text(t.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

private struct MountainGoatToolkitScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0
    private let stages = [
        ("🦴", "Strong sturdy legs — climb steep rocky terrain."),
        ("🦶", "Split-hoof grip — each half flexes independently for traction."),
        ("🧥", "Thick double-layered coat — survives -30 °C winters."),
        ("🌬", "Bigger lungs + more red blood cells — extracts O₂ from thin air.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Mountain Goat Toolkit").font(.largeTitle.bold())
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

private struct MonsoonMapScene: View {
    let onComplete: () -> Void
    @State private var phase: Int = 0
    private let phases = [
        ("☀️", "May: Indian land heats up faster than the Indian Ocean."),
        ("🌬", "June: Hot air over land rises; ocean's moist air rushes in to replace it."),
        ("☔️", "Jul-Sep: That moist air dumps rain across India — the SW monsoon."),
        ("❄️", "Nov-Feb: Pattern reverses — cool dry air flows from land to sea (NE monsoon).")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("The Indian Monsoon").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(phases[phase].0).font(.system(size: 100))
            Text(phases[phase].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { phase = (phase + 1) % phases.count } } label: {
                Text("Next month").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct WeatherSymbolsQuizScene: View {
    let onComplete: (Int) -> Void
    private struct Q: Identifiable {
        let id: String; let prompt: String; let opts: [String]; let correct: Int
    }
    private let qs: [Q] = [
        Q(id: "q1", prompt: "What does ☀️ mean on a forecast?",
          opts: ["Sunny / clear", "Cloudy", "Foggy"], correct: 0),
        Q(id: "q2", prompt: "What does 🌧 mean?",
          opts: ["Snow", "Rain", "Drizzle only"], correct: 1),
        Q(id: "q3", prompt: "What does ⛈ mean?",
          opts: ["Heat wave", "Thunderstorm", "Wind"], correct: 1),
        Q(id: "q4", prompt: "What does 🌫 mean?",
          opts: ["Fog / mist", "Smoke", "Pollen"], correct: 0)
    ]
    @State private var picks: [String: Int] = [:]
    private var score: Int { qs.reduce(0) { $0 + ((picks[$1.id] == $1.correct) ? 1 : 0) } }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Weather Symbols Quiz").font(.largeTitle.bold())
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

private struct ClimateChangeStoryScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🏭", "Burning coal, oil, gas releases CO₂."),
        ("🌫", "CO₂ traps the Sun's heat in the atmosphere — greenhouse effect."),
        ("🌡", "Average global temperature has risen ~1.1 °C since 1900."),
        ("🌊", "Ice caps melt → sea levels rise. Storms get stronger. Crops fail.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Climate Change in Four Steps").font(.largeTitle.bold())
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

private struct IndianClimateZonesScene: View {
    let onComplete: () -> Void
    @State private var selected: String? = nil
    private struct Zone: Identifiable { let id: String; let emoji: String; let name: String; let detail: String }
    private let zones: [Zone] = [
        Zone(id: "tropwet", emoji: "🌴", name: "Tropical Wet (Kerala, coastal Karnataka)", detail: "Heavy monsoon rain, hot all year. Rainforests, paddy fields, coconut groves."),
        Zone(id: "tropdry", emoji: "🌾", name: "Tropical Dry (Maharashtra, Andhra)", detail: "Hot summer, dry winter. Cotton, millet, scrubland."),
        Zone(id: "arid", emoji: "🏜", name: "Arid (Rajasthan, Kutch)", detail: "Below 25 cm rain/yr. Camels, cacti, ghuda."),
        Zone(id: "alpine", emoji: "🏔", name: "Alpine (Himachal, Ladakh)", detail: "Cold winters, snow. Apple orchards, yaks."),
        Zone(id: "temperate", emoji: "🌳", name: "Temperate (Himalayan foothills)", detail: "Mild summers, snowy winters. Tea estates, pine forests.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Indian Climate Zones").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(zones) { z in
                Button { selected = z.id } label: {
                    HStack(spacing: 10) {
                        Text(z.emoji).font(.title)
                        Text(z.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                    }
                    .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(selected == z.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
            }
            if let s = selected, let z = zones.first(where: { $0.id == s }) {
                Text(z.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct AnimalHabitatMatcherScene: View {
    let onComplete: () -> Void
    private enum Hab: String, CaseIterable { case desert = "Desert"; case polar = "Polar"; case rainforest = "Rainforest"; case mountain = "Mountain" }
    private struct A: Identifiable { let id: String; let emoji: String; let name: String; let correct: Hab }
    private let animals: [A] = [
        A(id: "camel", emoji: "🐪", name: "Camel", correct: .desert),
        A(id: "penguin", emoji: "🐧", name: "Penguin", correct: .polar),
        A(id: "toucan", emoji: "🦜", name: "Toucan", correct: .rainforest),
        A(id: "yak", emoji: "🐃", name: "Yak", correct: .mountain),
        A(id: "fennec", emoji: "🦊", name: "Fennec Fox", correct: .desert),
        A(id: "polarBear", emoji: "🐻‍❄️", name: "Polar Bear", correct: .polar)
    ]
    @State private var pick: [String: Hab] = [:]
    @State private var selectedId: String? = nil
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Match Animal to Habitat").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Tap an animal, then tap its habitat.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            HStack(spacing: 8) {
                ForEach(animals) { a in chipAnimal(a) }
            }
            HStack(spacing: 6) {
                ForEach(Hab.allCases, id: \.self) { h in chipHab(h) }
            }
            if pick.count == animals.count {
                let correct = animals.reduce(0) { $0 + ((pick[$1.id] == $1.correct) ? 1 : 0) }
                Text("\(correct) / \(animals.count) correct.").font(.headline)
                    .foregroundColor(correct == animals.count
                                     ? DesignTokens.BrandColor.primaryAction
                                     : DesignTokens.BrandColor.canvasText)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func chipAnimal(_ a: A) -> some View {
        let assigned = pick[a.id]
        let isSelected = selectedId == a.id
        let tint: Color = assigned == nil
            ? (isSelected ? Color.compatIndigo : Color.gray)
            : (assigned == a.correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger)
        return Button { if pick[a.id] == nil { selectedId = a.id } } label: {
            VStack { Text(a.emoji).font(.title3); Text(a.name).font(.caption2) }
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).fill(tint.opacity(isSelected ? 0.18 : 0.06)))
                .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(tint.opacity(0.4), lineWidth: 1))
        }.buttonStyle(.plain).pointingCursor()
    }
    private func chipHab(_ h: Hab) -> some View {
        Button {
            if let s = selectedId, pick[s] == nil { pick[s] = h; selectedId = nil }
        } label: {
            Text(h.rawValue).font(.caption.weight(.semibold))
                .padding(.horizontal, 10).padding(.vertical, 6)
                .background(Capsule().fill(Color.compatIndigo.opacity(0.10)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.4), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor().disabled(selectedId == nil)
    }
}

private struct WeatherForecastToolsScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct Tool: Identifiable { let id: String; let emoji: String; let name: String; let detail: String }
    private let tools: [Tool] = [
        Tool(id: "satellite", emoji: "🛰", name: "Weather satellites", detail: "INSAT-3D over India watches cloud movement + sea-surface temperature every 15 min."),
        Tool(id: "radar", emoji: "📡", name: "Doppler radar", detail: "Bounces radio waves off rain droplets. Shows where rain is falling RIGHT NOW."),
        Tool(id: "balloon", emoji: "🎈", name: "Weather balloons", detail: "Sent up daily from 50+ Indian stations. Measure temperature + humidity to 30 km up."),
        Tool(id: "buoy", emoji: "🌊", name: "Ocean buoys", detail: "Float in the Bay of Bengal + Arabian Sea. First warning of brewing cyclones.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("How Forecasters Predict Weather").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(tools) { t in
                Button { tapped.insert(t.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack { Text(t.emoji).font(.title2)
                            Text(t.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText) }
                        if tapped.contains(t.id) {
                            Text(t.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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
