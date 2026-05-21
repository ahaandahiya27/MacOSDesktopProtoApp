import SwiftUI

struct DiscoverChapter4View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(4)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Hot or Cold?",
        "Build Your Thermometer",
        "Three Highways of Heat",
        "Hot Soup, Cold Spoon",
        "Sea Breeze, Land Breeze",
        "Conductor or Insulator?",
        "Fluffy Birds, Fluffy Sweaters",
        "Temperature vs Heat",
        "Celsius vs Fahrenheit Slider",
        "Clinical vs Lab Thermometer",
        "Expansion & Contraction Lab",
        "Bimetallic Strip Bend",
        "Convection Current Bowl",
        "Radiation: Dark vs Light Cloth",
        "Why Vacuum Flask Works",
        "Thermos Layers Quiz",
        "Heat-Wave Survival Tips",
        "States of Matter Heat Ladder",
        "Specific Heat Race",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 4 — Heat",
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
            { AnyView(Scene1_HotOrCold(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_BuildYourThermometer(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_ThreeHighwaysOfHeat(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_HotSoupColdSpoon(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_SeaBreezeLandBreeze(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_ConductorOrInsulator(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(5, score: score, max: 12) })) },
            { AnyView(Scene7_FluffyBirdsFluffySweaters(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_TemperatureVsHeat(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(CelsiusFahrenheitSliderScene(onComplete: { self.markComplete(8) })) },
            { AnyView(ClinicalVsLabThermometerScene(onComplete: { self.markComplete(9) })) },
            { AnyView(ExpansionContractionLabScene(onComplete: { self.markComplete(10) })) },
            { AnyView(BimetallicStripScene(onComplete: { self.markComplete(11) })) },
            { AnyView(ConvectionCurrentBowlScene(onComplete: { self.markComplete(12) })) },
            { AnyView(RadiationDarkLightClothScene(onComplete: { self.markComplete(13) })) },
            { AnyView(VacuumFlaskScene(onComplete: { self.markComplete(14) })) },
            { AnyView(ThermosLayersQuizScene(onComplete: { score in self.markComplete(15, score: score, max: 4) })) },
            { AnyView(HeatWaveSurvivalScene(onComplete: { self.markComplete(16) })) },
            { AnyView(StatesOfMatterHeatLadderScene(onComplete: { self.markComplete(17) })) },
            { AnyView(SpecificHeatRaceScene(onComplete: { self.markComplete(18) })) },
            { AnyView(Scene9_BossQuiz_Ch4(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline Scene 9: Celsius vs Fahrenheit (slider)
private struct CelsiusFahrenheitSliderScene: View {
    let onComplete: () -> Void
    @State private var celsius: Double = 25
    private var fahrenheit: Double { celsius * 9.0 / 5.0 + 32 }
    private var label: String {
        if celsius < 0 { return "Below freezing — ice!" }
        if celsius < 10 { return "Cold — heavy jacket weather." }
        if celsius < 25 { return "Cool to mild — perfect for outdoor cricket." }
        if celsius < 35 { return "Warm — Delhi spring or Mumbai winter." }
        if celsius < 42 { return "Hot — typical Indian summer day." }
        return "Heatwave! Stay indoors, drink water."
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Celsius ↔ Fahrenheit").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("India and most of the world use °C. The US uses °F. Both measure the same heat — just different scales.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                HStack(spacing: 24) {
                    VStack { Text("\(Int(celsius))").font(.system(size: 56, weight: .bold).monospacedDigit())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Text("°C").font(.caption).foregroundColor(.secondary) }
                    Text("=").font(.title.bold()).foregroundColor(.secondary)
                    VStack { Text("\(Int(fahrenheit))").font(.system(size: 56, weight: .bold).monospacedDigit())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Text("°F").font(.caption).foregroundColor(.secondary) }
                }
                Slider(value: $celsius, in: -10...50).frame(maxWidth: 340).padding(.horizontal, 24)
                Text(label).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 10: Clinical vs Lab Thermometer (binary compare)
private struct ClinicalVsLabThermometerScene: View {
    let onComplete: () -> Void
    @State private var clinical: Bool = true

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Two Kinds of Thermometer").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                HStack(spacing: 14) {
                    pickerChip(label: "Clinical", picked: clinical) { clinical = true }
                    pickerChip(label: "Lab", picked: !clinical) { clinical = false }
                }
                Text(clinical ? "🌡️" : "🔬").font(.system(size: 90))
                let body = clinical
                    ? "Range: 35–42 °C. Reads body temperature only. Has a 'kink' near the bulb so the mercury stays put when you remove it — that's why you shake it down before re-use."
                    : "Range: -10 to 110 °C. Reads any liquid/solid. No kink — mercury falls back instantly when removed. Used in labs for boiling/freezing experiments."
                Text(body).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.leading)
                    .padding(14)
                    .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                    .padding(.horizontal, 24)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }

    private func pickerChip(label: String, picked: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(picked ? .bold : .regular))
                .padding(.horizontal, 18).padding(.vertical, 9)
                .background(Capsule().fill(picked ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }
        .buttonStyle(.plain).pointingCursor()
    }
}

// MARK: - Inline Scene 11: Expansion & Contraction Lab (toggle reveal)
private struct ExpansionContractionLabScene: View {
    let onComplete: () -> Void
    @State private var heated: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Heat Makes Things Bigger").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Heat a metal ring and it expands — a marble that fit before now slides through too easily. Cool it and it contracts back. Same for railway tracks, power lines, mercury in a tube.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                Circle().strokeBorder(DesignTokens.BrandColor.danger, lineWidth: 6)
                    .frame(width: heated ? 180 : 120, height: heated ? 180 : 120)
                Button {
                    let a = reduceMotion ? Animation.linear(duration: 0.0) : .easeInOut(duration: 0.4)
                    withAnimation(a) { heated.toggle() }
                } label: {
                    Text(heated ? "Cool it back" : "Heat the ring").font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(DesignTokens.BrandColor.danger.opacity(0.18)))
                        .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                        .foregroundColor(DesignTokens.BrandColor.danger)
                }
                .buttonStyle(.plain).pointingCursor()
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 12: Bimetallic Strip Bend (slider)
private struct BimetallicStripScene: View {
    let onComplete: () -> Void
    @State private var temp: Double = 25

    private var bend: Double { (temp - 25) * 0.5 } // pos => bend up

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Bimetallic Strip — Heat Makes It Bend").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Two metals fused together. Brass expands more than steel, so heating makes the strip curl. Used in thermostats and electric iron auto-cutoffs.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                ZStack {
                    Capsule().fill(DesignTokens.BrandColor.mnemonicAccent)
                        .frame(width: 180, height: 14)
                        .offset(y: -CGFloat(bend))
                        .rotationEffect(.degrees(bend))
                    Capsule().fill(Color.gray)
                        .frame(width: 180, height: 14)
                        .offset(y: 8 - CGFloat(bend))
                        .rotationEffect(.degrees(bend))
                }
                .frame(height: 80)
                Slider(value: $temp, in: -10...80).frame(maxWidth: 340).padding(.horizontal, 24)
                Text("Temperature: \(Int(temp)) °C").font(.callout.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 13: Convection Current Bowl (stage stepper)
private struct ConvectionCurrentBowlScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0

    private let captions = [
        "Bottom of the pan is on the flame.",
        "1. Water at the bottom heats up — molecules speed up, expand, density drops.",
        "2. Lighter hot water rises; cooler water from above falls to take its place.",
        "3. A loop forms — that's a convection current. Whole pan heats evenly."
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Convection Current in a Pan").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(Color.gray.opacity(0.18))
                        .frame(width: 240, height: 140)
                    if stage >= 1 {
                        Image(systemName: "arrow.up").foregroundColor(DesignTokens.BrandColor.danger)
                            .offset(x: -60, y: 0)
                    }
                    if stage >= 2 {
                        Image(systemName: "arrow.down").foregroundColor(DesignTokens.BrandColor.relatedConcepts)
                            .offset(x: 60, y: 0)
                    }
                    if stage >= 3 {
                        Image(systemName: "arrow.right").foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            .offset(x: 0, y: 50)
                        Image(systemName: "arrow.left").foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            .offset(x: 0, y: -50)
                    }
                }
                Text(captions[stage]).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                Button { withAnimation { stage = (stage + 1) % captions.count } } label: {
                    Text("Next stage").font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 14: Radiation: Dark vs Light Cloth (compare)
private struct RadiationDarkLightClothScene: View {
    let onComplete: () -> Void
    @State private var darkSelected: Bool = true

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Why We Wear White in Summer").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                HStack(spacing: 14) {
                    Button { withAnimation { darkSelected = true } } label: {
                        Circle().fill(Color.black).frame(width: 60, height: 60)
                            .overlay(Circle().strokeBorder(darkSelected ? Color.compatIndigo : Color.gray, lineWidth: 3))
                    }.buttonStyle(.plain).pointingCursor()
                    Button { withAnimation { darkSelected = false } } label: {
                        Circle().fill(Color.white).frame(width: 60, height: 60)
                            .overlay(Circle().strokeBorder(!darkSelected ? Color.compatIndigo : Color.gray, lineWidth: 3))
                    }.buttonStyle(.plain).pointingCursor()
                }
                HStack(spacing: 8) {
                    Text(darkSelected ? "Dark cloth" : "Light cloth").font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Image(systemName: darkSelected ? "thermometer.sun" : "thermometer.snowflake")
                        .foregroundColor(DesignTokens.BrandColor.danger)
                }
                Text(darkSelected
                     ? "Dark colours absorb most of the sunlight that hits them and turn it into heat. Great in winter; awful in May."
                     : "Light colours reflect most of the sunlight back. Body stays cooler. That's why white kurta is summer wear in India.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 15: Vacuum Flask (zoom reveal)
private struct VacuumFlaskScene: View {
    let onComplete: () -> Void
    @State private var open: Bool = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Why Vacuum Flask Keeps Tea Hot").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ZStack {
                    RoundedRectangle(cornerRadius: 22).fill(Color.gray.opacity(0.2))
                        .frame(width: 140, height: 240)
                    if open {
                        RoundedRectangle(cornerRadius: 16).fill(Color.white)
                            .frame(width: 100, height: 200)
                            .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.gray, lineWidth: 1))
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 40))
                            .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                    } else {
                        Image(systemName: "thermometer").font(.system(size: 60))
                            .foregroundColor(DesignTokens.BrandColor.danger)
                    }
                }
                Button { withAnimation { open.toggle() } } label: {
                    Text(open ? "Close" : "Cut it open").font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                if open {
                    Text("Inside: a glass bottle with double walls + the air pumped out between them = vacuum. Heat can't travel by conduction or convection through vacuum. The silvered inner surface reflects radiation back. All three heat paths blocked.")
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .multilineTextAlignment(.leading)
                        .padding(14)
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                        .padding(.horizontal, 24)
                }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 16: Thermos Layers Quiz (MCQ)
private struct ThermosLayersQuizScene: View {
    let onComplete: (Int) -> Void

    private struct Q: Identifiable {
        let id: String; let prompt: String; let opts: [String]; let correct: Int
    }
    private let qs: [Q] = [
        Q(id: "q1", prompt: "Which heat path does the vacuum block?",
          opts: ["Conduction + convection", "Radiation only", "Nothing — it's just decorative"], correct: 0),
        Q(id: "q2", prompt: "Why is the inner wall silvered?",
          opts: ["For style", "To reflect radiation back inside", "To make it heavier"], correct: 1),
        Q(id: "q3", prompt: "If the vacuum was filled with air, would it still keep heat?",
          opts: ["Yes, just as well", "No, heat would escape much faster", "Only in winter"], correct: 1),
        Q(id: "q4", prompt: "Cork stopper at the top stops which heat path most?",
          opts: ["Conduction through the lid", "Cooking the tea", "Adding flavour"], correct: 0)
    ]
    @State private var picks: [String: Int] = [:]
    private var score: Int { qs.reduce(0) { $0 + ((picks[$1.id] == $1.correct) ? 1 : 0) } }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Thermos Layers Quiz").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ForEach(qs) { q in qCard(q) }
                if picks.count == qs.count {
                    Text("Score: \(score) / \(qs.count)").font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                }
                GotItButton(action: { onComplete(score) }).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }

    @ViewBuilder
    private func qCard(_ q: Q) -> some View {
        let pick = picks[q.id]
        VStack(alignment: .leading, spacing: 8) {
            Text(q.prompt).font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
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
                }
                .buttonStyle(.plain).pointingCursor().disabled(pick != nil)
            }
        }
        .padding(12)
        .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, 24)
    }
}

// MARK: - Inline Scene 17: Heat-Wave Survival Tips (tap-to-reveal)
private struct HeatWaveSurvivalScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []

    private struct Tip: Identifiable { let id: String; let title: String; let detail: String }
    private let tips: [Tip] = [
        Tip(id: "wear", title: "Wear loose, light cotton", detail: "Cotton breathes; light colours reflect sunlight."),
        Tip(id: "drink", title: "Drink water every hour", detail: "Even before you feel thirsty. Coconut water, ORS, buttermilk also help."),
        Tip(id: "noon", title: "Avoid 12–3 PM outdoors", detail: "Sun is most intense; UV + heat radiation peak."),
        Tip(id: "wet", title: "Wet your wrists & neck", detail: "Major blood vessels close to skin — evaporation cools the blood fast."),
        Tip(id: "fan", title: "Use a wet curtain on a fan", detail: "DIY desert cooler — evaporation chills the air without electricity.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Heat-Wave Survival Tips").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ForEach(tips) { tip in
                    Button { tapped.insert(tip.id) } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tip.title).font(.headline)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                            if tapped.contains(tip.id) {
                                Text(tip.detail).font(.callout)
                                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                                    .fixedSize(horizontal: false, vertical: true)
                            } else {
                                Text("Tap to reveal").font(.caption.italic())
                                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                    }
                    .buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
                }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 18: States of Matter Heat Ladder (slider)
private struct StatesOfMatterHeatLadderScene: View {
    let onComplete: () -> Void
    @State private var temp: Double = 25

    private var state: String {
        if temp < 0 { return "Ice (solid) — molecules vibrate in fixed places." }
        if temp < 100 { return "Water (liquid) — molecules slide past each other." }
        return "Steam (gas) — molecules fly apart freely."
    }
    private var emoji: String {
        if temp < 0 { return "🧊" }; if temp < 100 { return "💧" }; return "💨"
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Add Heat → Change State").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text(emoji).font(.system(size: 100))
                Text("\(Int(temp)) °C").font(.title2.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Slider(value: $temp, in: -20...130).frame(maxWidth: 340).padding(.horizontal, 24)
                Text(state).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 19: Specific Heat Race (timing comparison)
private struct SpecificHeatRaceScene: View {
    let onComplete: () -> Void
    @State private var running: Bool = false
    @State private var waterTemp: Double = 20
    @State private var sandTemp: Double = 20

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Water vs Sand — Race to Hot").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Heat the same mass of water and sand with the same flame. Watch them race.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                HStack(spacing: 30) {
                    barReadout(label: "Water", temp: waterTemp, color: DesignTokens.BrandColor.relatedConcepts)
                    barReadout(label: "Sand", temp: sandTemp, color: DesignTokens.BrandColor.mnemonicAccent)
                }
                Button { startRace() } label: {
                    Text(running ? "Racing…" : "Start race").font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(DesignTokens.BrandColor.danger.opacity(0.18)))
                        .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                        .foregroundColor(DesignTokens.BrandColor.danger)
                }
                .buttonStyle(.plain).pointingCursor().disabled(running)
                Text("Sand heats up about 5× faster than water for the same energy. That's why beach sand is scorching while the sea stays cool.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }

    private func barReadout(label: String, temp: Double, color: Color) -> some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.1))
                    .frame(width: 60, height: 120)
                RoundedRectangle(cornerRadius: 8).fill(color.opacity(0.7))
                    .frame(width: 60, height: CGFloat((temp - 20) / 80) * 120)
            }
            Text(label).font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("\(Int(temp)) °C").font(.caption2.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
    }

    private func startRace() {
        waterTemp = 20; sandTemp = 20
        running = true
        Task { @MainActor in
            withAnimation(.linear(duration: 3.0)) {
                sandTemp = 90
                waterTemp = 35
            }
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            running = false
        }
    }
}
