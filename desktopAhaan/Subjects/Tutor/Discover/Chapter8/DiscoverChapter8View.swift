import SwiftUI

struct DiscoverChapter8View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(8)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Hot Air Rises",
        "Air Pressure Drop",
        "Land Breeze, Sea Breeze",
        "Uneven Heating Builds Wind",
        "Cyclone Eye",
        "Thunderstorm Safety",
        "Cyclone Warning Codes",
        "Anemometer Reader",
        "Beaufort Scale Slider",
        "Tornado Tube Lab",
        "Lightning Distance Counter",
        "Storm Surge Animation",
        "Cyclone Names Atlas",
        "Wind Direction Compass",
        "Pressure Belt Diagram",
        "Cyclone Survival Quiz",
        "Trade Winds Map",
        "Tropical vs Temperate Cyclone",
        "Doppler Radar Reader",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 8 — Winds, Storms and Cyclones",
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
            { AnyView(Scene1_HotAirRises(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_AirPressureDrop(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_LandBreezeSeaBreeze(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_UnevenHeating(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_CycloneEye(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_ThunderstormSafety(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(5, score: score, max: 6) })) },
            { AnyView(Scene7_CycloneWarningCodes(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(6, score: score, max: 4) })) },
            { AnyView(Scene8_AnemometerReader(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(BeaufortScaleSliderScene(onComplete: { self.markComplete(8) })) },
            { AnyView(TornadoTubeLabScene(onComplete: { self.markComplete(9) })) },
            { AnyView(LightningDistanceScene(onComplete: { self.markComplete(10) })) },
            { AnyView(StormSurgeScene(onComplete: { self.markComplete(11) })) },
            { AnyView(CycloneNamesAtlasScene(onComplete: { self.markComplete(12) })) },
            { AnyView(WindCompassScene(onComplete: { self.markComplete(13) })) },
            { AnyView(PressureBeltScene(onComplete: { self.markComplete(14) })) },
            { AnyView(QuickCheckQuizScene(
                title: "Cyclone Survival Quiz",
                questions: Array(self.chapter.quickCheckQuestionsList.prefix(4)),
                onComplete: { score in self.markComplete(15, score: score, max: 4) }
            )) },
            { AnyView(TradeWindsMapScene(onComplete: { self.markComplete(16) })) },
            { AnyView(TropicalVsTemperateScene(onComplete: { self.markComplete(17) })) },
            { AnyView(DopplerRadarScene(onComplete: { self.markComplete(18) })) },
            { AnyView(Scene9_BossQuiz_Ch8(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.8

private struct BeaufortScaleSliderScene: View {
    let onComplete: () -> Void
    @State private var speed: Double = 10
    private var label: String {
        if speed < 5 { return "Calm — smoke rises straight up. Force 0." }
        if speed < 20 { return "Light breeze — leaves rustle. Force 2-3." }
        if speed < 40 { return "Strong breeze — kites fly. Force 5-6." }
        if speed < 75 { return "Gale — branches break, walking is hard. Force 8-9." }
        return "Hurricane — devastation. Force 12+."
    }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("The Beaufort Wind Scale").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("\(Int(speed)) km/h").font(.title2.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $speed, in: 0...130).frame(maxWidth: 340).padding(.horizontal, 24)
            Text(label).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct TornadoTubeLabScene: View {
    let onComplete: () -> Void
    @State private var spinning: Bool = false
    @State private var rotation: Double = 0
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Tornado Tube — Vortex Demo").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Two bottles, one with water, connected by a cap. Swirl the top bottle — water funnels down in a tornado shape. Same physics as a real tornado.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            ZStack {
                if spinning {
                    Image(systemName: "tornado").font(.system(size: 110))
                        .foregroundColor(Color.compatIndigo)
                        .rotationEffect(.degrees(rotation))
                } else {
                    Image(systemName: "drop.fill").font(.system(size: 80))
                        .foregroundColor(Color.compatIndigo)
                }
            }
            .frame(height: 140)
            Button { withAnimation { spinning.toggle() }; spin() } label: {
                Text(spinning ? "Stop" : "Spin").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func spin() {
        if spinning {
            withAnimationRespectingReduceMotion(.linear(duration: HardwareTier.duration(ideal: 1)).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        } else { rotation = 0 }
    }
}

private struct LightningDistanceScene: View {
    let onComplete: () -> Void
    @State private var seconds: Double = 3
    private var km: Double { seconds * 0.343 } // speed of sound ~343 m/s
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("How Far Was That Lightning?").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Light arrives instantly. Sound takes time. Count seconds between flash and thunder — divide by ~3 → distance in km.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            HStack(spacing: 24) {
                VStack { Image(systemName: "bolt.fill").font(.system(size: 60))
                    .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
                    Text("Flash").font(.caption) }
                Image(systemName: "arrow.right").foregroundColor(.secondary)
                VStack { Text("\(String(format: "%.1f", km)) km").font(.title.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    Text("\(Int(seconds))s delay").font(.caption) }
            }
            Slider(value: $seconds, in: 1...30).frame(maxWidth: 340).padding(.horizontal, 24)
            Text(seconds < 10
                 ? "Less than 3 km away — DANGER. Stay indoors."
                 : "Far enough — keep watching the sky.")
                .font(.callout.weight(.semibold))
                .foregroundColor(seconds < 10
                                 ? DesignTokens.BrandColor.danger
                                 : DesignTokens.BrandColor.primaryAction)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct StormSurgeScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0
    private let stages = [
        ("🌊", "1. Storm winds push sea water toward the coast."),
        ("📈", "2. Sea level rises 3-8 m above normal — that's storm surge."),
        ("🏘", "3. Surge floods coastal villages, fields, roads."),
        ("⚠️", "4. Surge kills more cyclone victims than wind. Always heed warnings.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Storm Surge — The Hidden Killer").font(.largeTitle.bold())
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

private struct CycloneNamesAtlasScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct C: Identifiable { let id: String; let name: String; let year: String; let detail: String }
    private let cyclones: [C] = [
        C(id: "phailin", name: "Phailin", year: "2013", detail: "Hit Odisha at 200 km/h. Mass evacuation of 1 million saved most lives."),
        C(id: "fani", name: "Fani", year: "2019", detail: "Severe cyclone hit Puri. Excellent forecasting + early warning saved ~1 million."),
        C(id: "amphan", name: "Amphan", year: "2020", detail: "Bay of Bengal supercyclone. Hit Sundarbans + Bengal at peak intensity."),
        C(id: "tauktae", name: "Tauktae", year: "2021", detail: "Rare Arabian Sea cyclone. Hit Gujarat — disrupted oil rigs.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Recent Indian Cyclones").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Indian Ocean cyclones are named by IMD + 12 neighbour countries. Tap each.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            ForEach(cyclones) { c in
                Button { tapped.insert(c.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack { Text(c.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                            Spacer(); Text(c.year).font(.caption.monospacedDigit()).foregroundColor(.secondary) }
                        if tapped.contains(c.id) {
                            Text(c.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

private struct WindCompassScene: View {
    let onComplete: () -> Void
    @State private var angle: Double = 0
    private var dir: String {
        let a = (angle + 22.5).truncatingRemainder(dividingBy: 360)
        let dirs = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let i = Int(a / 45) % 8
        return dirs[i]
    }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Wind Direction Compass").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("A wind named 'south wind' blows FROM the south. Forecasts use compass directions for clarity.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            ZStack {
                Circle().stroke(Color.gray.opacity(0.4), lineWidth: 2).frame(width: 200, height: 200)
                Text("N").offset(y: -88).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("E").offset(x: 88).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("S").offset(y: 88).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("W").offset(x: -88).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                Image(systemName: "arrow.up").font(.system(size: 80, weight: .bold))
                    .foregroundColor(DesignTokens.BrandColor.danger)
                    .rotationEffect(.degrees(angle))
            }
            Text("Wind from: \(dir)").font(.title3.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $angle, in: 0...360).frame(maxWidth: 340).padding(.horizontal, 24)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct PressureBeltScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        "Equator: hot air rises → low pressure belt. Lots of rain (rainforests live here)." ,
        "~30°N/S: descending air → high pressure belt. Deserts here (Sahara, Thar, Outback).",
        "~60°N/S: warm air meets polar air → low pressure. Storm tracks (temperate cyclones).",
        "Poles: cold heavy air → high pressure. Dry, icy. Antarctica."
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Pressure Belts of Earth").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            VStack(spacing: 4) {
                ForEach(0..<steps.count, id: \.self) { i in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(i + 1).").font(.body.bold())
                            .foregroundColor(i == step
                                             ? DesignTokens.BrandColor.danger
                                             : DesignTokens.BrandColor.canvasTextSecondary)
                        Text(steps[i]).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .fill(i == step ? Color.compatIndigo.opacity(0.10) : .clear))
                }
            }.padding(.horizontal, 24).frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
            Button { withAnimation { step = (step + 1) % steps.count } } label: {
                Text("Next belt").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}


private struct TradeWindsMapScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Trade Winds — Earth's Global Winds").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🌍").font(.system(size: 120))
            Text("Trade winds blow from the subtropical high (30°N or S) toward the equator. Steady, predictable — once helped sailing ships cross the Atlantic and reach India.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Text("Westerlies blow from 30° → 60°. Polar easterlies from 90° → 60°.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct TropicalVsTemperateScene: View {
    let onComplete: () -> Void
    @State private var tropical: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Two Kinds of Cyclones").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Tropical", on: tropical) { tropical = true }
                pickChip("Temperate", on: !tropical) { tropical = false }
            }
            Text(tropical
                 ? "Tropical cyclone (Indian Ocean): forms over warm sea > 26 °C. Spirals around an eye. Brings storm surge. May-Nov."
                 : "Temperate cyclone (Europe, USA): forms at 30-60° latitude where warm + cold air meet. No clear eye. Brings widespread rain + snow.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.leading).padding(14)
                .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                .padding(.horizontal, 24)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func pickChip(_ label: String, on: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(on ? .bold : .regular))
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Capsule().fill(on ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct DopplerRadarScene: View {
    let onComplete: () -> Void
    @State private var scan: Double = 0
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Doppler Radar — Watching the Storm").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ZStack {
                Circle().fill(Color.gray.opacity(0.1)).frame(width: 220, height: 220)
                ForEach(0..<3, id: \.self) { i in
                    Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .frame(width: CGFloat(70 + i * 60), height: CGFloat(70 + i * 60))
                }
                Image(systemName: "cloud.heavyrain.fill")
                    .font(.system(size: 30))
                    .foregroundColor(DesignTokens.BrandColor.danger)
                    .offset(x: 60 * cos(scan), y: 60 * sin(scan))
                Rectangle().fill(DesignTokens.BrandColor.primaryAction.opacity(0.4))
                    .frame(width: 110, height: 3)
                    .rotationEffect(.radians(scan))
                    .offset(x: 55 * cos(scan), y: 55 * sin(scan))
            }
            Text("IMD has 30+ Doppler radars across India. Each one tracks rainfall up to 250 km away in real time.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Slider(value: $scan, in: 0...(2 * .pi)).frame(maxWidth: 340).padding(.horizontal, 24)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}
