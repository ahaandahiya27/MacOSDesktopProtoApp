import SwiftUI

struct DiscoverChapter19View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(19)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Spinning Earth",
        "Why Seasons Happen",
        "Moon Phases Wheel",
        "Eclipse Builder",
        "Tides and the Moon",
        "Solar System Sorter",
        "Constellation Connect",
        "ISRO Space Missions",
        "Sun Size Slider",
        "Planet Distance Map",
        "Inner vs Outer Planets",
        "Galactic Address",
        "Day Length by Latitude",
        "Asteroids vs Comets",
        "Apollo 11 Story",
        "Black Hole Reveal",
        "ISS — Living in Space",
        "James Webb Telescope",
        "Astronomy Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 19 — Earth, Moon and the Sun",
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
            { AnyView(Scene1_SpinningEarth(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_WhySeasonsHappen(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_MoonPhasesWheel(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_EclipseBuilder(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_TidesAndTheMoon(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_SolarSystemSorter(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(5, score: score, max: 16) })) },
            { AnyView(Scene7_ConstellationConnect(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_ISROSpaceMissions(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(SunSizeSliderScene(onComplete: { self.markComplete(8) })) },
            { AnyView(PlanetDistanceMapScene(onComplete: { self.markComplete(9) })) },
            { AnyView(InnerVsOuterPlanetsScene(onComplete: { self.markComplete(10) })) },
            { AnyView(GalacticAddressScene(onComplete: { self.markComplete(11) })) },
            { AnyView(DayLengthByLatitudeScene(onComplete: { self.markComplete(12) })) },
            { AnyView(AsteroidsVsCometsScene(onComplete: { self.markComplete(13) })) },
            { AnyView(ApolloElevenScene(onComplete: { self.markComplete(14) })) },
            { AnyView(BlackHoleRevealScene(onComplete: { self.markComplete(15) })) },
            { AnyView(ISSLivingInSpaceScene(onComplete: { self.markComplete(16) })) },
            { AnyView(JamesWebbTelescopeScene(onComplete: { self.markComplete(17) })) },
            { AnyView(QuickCheckQuizScene(
                title: "Astronomy Quiz",
                questions: Array(self.chapter.quickCheckQuestionsList.prefix(4)),
                onComplete: { score in self.markComplete(18, score: score, max: 4) }
            )) },
            { AnyView(Scene9_BossQuiz_Ch19(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.19

private struct SunSizeSliderScene: View {
    let onComplete: () -> Void
    @State private var sun: Double = 100
    private var earths: Double { sun * 109 / 100 } // ~109 Earths across Sun's diameter
    private var sunDiameter: CGFloat { CGFloat(sun) * 2.5 }
    private var earthDiameter: CGFloat { max(4, CGFloat(sun) * 2.5 / 109) }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("How Big is the Sun?").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ZStack {
                Circle().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(0.8))
                    .frame(width: sunDiameter, height: sunDiameter)
                Circle().fill(Color.compatTeal).frame(width: earthDiameter, height: earthDiameter)
            }
            .frame(height: 280)
            Slider(value: $sun, in: 30...100).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("Sun's diameter is ~109× Earth's diameter. You could fit 1.3 MILLION Earths inside the Sun by volume.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct PlanetDistanceMapScene: View {
    let onComplete: () -> Void
    @State private var sel: String? = nil
    private struct P: Identifiable { let id: String; let emoji: String; let name: String; let dist: String; let detail: String }
    private let planets: [P] = [
        P(id: "mer", emoji: "☿", name: "Mercury", dist: "58M km", detail: "Closest to Sun. Daytime 430°C, night -180°C."),
        P(id: "ven", emoji: "♀", name: "Venus", dist: "108M km", detail: "Hottest planet (462°C surface) due to runaway greenhouse."),
        P(id: "earth", emoji: "🌍", name: "Earth", dist: "150M km", detail: "Our home. The only known planet with liquid water + life."),
        P(id: "mars", emoji: "♂", name: "Mars", dist: "228M km", detail: "Red dust. Largest volcano (Olympus Mons, 22 km tall)."),
        P(id: "jup", emoji: "♃", name: "Jupiter", dist: "778M km", detail: "Biggest planet. Giant red spot is a 350-year-old storm."),
        P(id: "sat", emoji: "♄", name: "Saturn", dist: "1.4B km", detail: "Stunning rings made of ice + rock chunks.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Planet Distance Atlas").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(planets) { p in
                Button { sel = p.id } label: {
                    HStack {
                        Text(p.emoji).font(.title2)
                        Text(p.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                        Text(p.dist).font(.caption.monospacedDigit()).foregroundColor(.secondary)
                    }
                    .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(sel == p.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
            }
            if let s = sel, let p = planets.first(where: { $0.id == s }) {
                Text(p.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct InnerVsOuterPlanetsScene: View {
    let onComplete: () -> Void
    @State private var inner: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Inner vs Outer Planets").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Inner (4)", on: inner) { inner = true }
                pickChip("Outer (4)", on: !inner) { inner = false }
            }
            Text(inner ? "☿♀🌍♂" : "♃♄♅♆").font(.system(size: 80))
            Text(inner
                 ? "Mercury, Venus, Earth, Mars. Small, rocky, dense. Close to the Sun. No or few moons. Solid surfaces."
                 : "Jupiter, Saturn, Uranus, Neptune. Huge gas + ice giants. Far from Sun. Many moons + ring systems. No solid surface to land on.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func pickChip(_ label: String, on: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(on ? .bold : .regular))
                .padding(.horizontal, 18).padding(.vertical, 9)
                .background(Capsule().fill(on ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct GalacticAddressScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🏠", "Your home, your city, India, Earth."),
        ("🌍🌑☀️", "Earth is one of 8 planets orbiting the Sun (Solar System)."),
        ("🌌", "Sun is one of ~400 BILLION stars in the Milky Way galaxy."),
        ("🔭", "Milky Way is one of ~2 trillion galaxies in the observable universe."),
        ("📍", "Your full galactic address: Earth → Solar System → Milky Way → Local Group → Virgo Supercluster → Observable Universe.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Your Galactic Address").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(steps[step].0).font(.system(size: 90))
            Text(steps[step].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { step = (step + 1) % steps.count } } label: {
                Text("Zoom out").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct DayLengthByLatitudeScene: View {
    let onComplete: () -> Void
    @State private var lat: Double = 28
    private var daylight: String {
        if lat > 66 { return "Arctic Circle: 6 months continuous daylight (summer) OR darkness (winter)." }
        if lat > 40 { return "Northern Europe / Canada: long summer days (~16 hrs), short winter (~8 hrs)." }
        if lat > 20 { return "Northern India (Delhi 28°N): summer 13.5h, winter 10.5h day." }
        if lat > -20 { return "Tropics (Mumbai, Bangalore): days ~12 hours all year round." }
        return "Southern Hemisphere: seasons + day lengths reversed."
    }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Day Length Varies by Latitude").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("\(String(format: "%.0f", lat))°").font(.title.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $lat, in: -70...70).frame(maxWidth: 340).padding(.horizontal, 24)
            Text(daylight).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct AsteroidsVsCometsScene: View {
    let onComplete: () -> Void
    @State private var asteroid: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Asteroids vs Comets").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Asteroid", on: asteroid) { asteroid = true }
                pickChip("Comet", on: !asteroid) { asteroid = false }
            }
            Text(asteroid ? "🪨" : "☄️").font(.system(size: 100))
            Text(asteroid
                 ? "Asteroids: rocky/metallic chunks. Most in the asteroid belt between Mars and Jupiter. Largest: Ceres (940 km). Caused dinosaur extinction 66 mya."
                 : "Comets: balls of dust + ice. Long elliptical orbits. When near the Sun, ice vaporises → glowing tail. Halley's comet returns every 76 years.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func pickChip(_ label: String, on: Bool, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(on ? .bold : .regular))
                .padding(.horizontal, 18).padding(.vertical, 9)
                .background(Capsule().fill(on ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct ApolloElevenScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🚀", "16 July 1969: Saturn V rocket launches from Cape Kennedy."),
        ("🌙", "4 days later: Lunar Module 'Eagle' separates and descends."),
        ("👨‍🚀", "20 July 1969: Neil Armstrong steps onto the Moon. 'One small step…'"),
        ("🪨", "Returns with 22 kg of moon rocks. 12 astronauts have walked the Moon (1969-1972).")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Apollo 11 — Humans on the Moon").font(.largeTitle.bold())
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

private struct BlackHoleRevealScene: View {
    let onComplete: () -> Void
    @State private var revealed: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Black Holes — Gravity Wells").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ZStack {
                Circle().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(0.4))
                    .frame(width: 180, height: 180)
                Circle().fill(Color.black).frame(width: revealed ? 90 : 0, height: revealed ? 90 : 0)
            }
            .frame(height: 200)
            Button { withAnimation { revealed.toggle() } } label: {
                Text(revealed ? "Hide" : "Reveal black hole").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            Text("When a massive star runs out of fuel, it collapses under its own gravity into a point so dense that nothing — not even light — can escape. First photographed in 2019 (M87 galaxy). Our Milky Way has one at its centre, Sgr A*.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct ISSLivingInSpaceScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct F: Identifiable { let id: String; let title: String; let detail: String }
    private let facts: [F] = [
        F(id: "speed", title: "Travels 28,000 km/h", detail: "Orbits Earth in 90 minutes. Astronauts see 16 sunrises every day."),
        F(id: "size", title: "Size of a football field", detail: "Largest human-made object in orbit. 460 tonnes. Assembled 1998-2011."),
        F(id: "crew", title: "6-7 astronauts on board", detail: "From USA, Russia, Japan, Europe, Canada. Rotated every 6 months."),
        F(id: "rakesh", title: "First Indian: Rakesh Sharma 1984", detail: "Said 'Saare jahan se acchha' from space when asked how India looks.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("International Space Station").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🛰").font(.system(size: 100))
            ForEach(facts) { f in
                Button { tapped.insert(f.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(f.title).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        if tapped.contains(f.id) {
                            Text(f.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

private struct JamesWebbTelescopeScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("James Webb Space Telescope").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🔭").font(.system(size: 100))
            Text("Launched 2021. Successor to Hubble. 1.5 million km from Earth (Lagrange point L2). Sees in INFRARED — light from the very first galaxies, 13.5 billion light years away. Has imaged: water vapour on exoplanets, ancient galaxy formation, deep field with 10,000+ galaxies in a thumbnail-sized patch of sky.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

