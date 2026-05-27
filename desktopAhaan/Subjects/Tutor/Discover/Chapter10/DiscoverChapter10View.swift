import SwiftUI

struct DiscoverChapter10View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(10)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Inhale, Exhale",
        "Aerobic vs Anaerobic",
        "Yeast & Sugar Lab",
        "Lime Water Test",
        "Fish Gill Flow",
        "How Insects & Worms Breathe",
        "Plant Stomata Zoom",
        "Rest vs Run",
        "Breathing Rate by Activity",
        "Lung Anatomy Map",
        "Diaphragm Pump",
        "Cellular Respiration Equation",
        "Hold Your Breath Timer",
        "Smoking & Lungs",
        "Hiccups & Sneezes",
        "Animal Respiration Atlas",
        "Mountain Sickness Story",
        "CPR Lifesaver Steps",
        "Respiration Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 10 — Respiration in Organisms",
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
            { AnyView(Scene1_InhaleExhale(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_AerobicAnaerobic(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(1, score: score, max: 4) })) },
            { AnyView(Scene3_YeastSugarLab(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_LimeWaterTest(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_FishGillFlow(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_InsectsWorms(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_StomataZoom(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_RestVsRun(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(BreathingRateByActivityScene(onComplete: { self.markComplete(8) })) },
            { AnyView(LungAnatomyMapScene(onComplete: { self.markComplete(9) })) },
            { AnyView(DiaphragmPumpScene(onComplete: { self.markComplete(10) })) },
            { AnyView(CellularRespirationEquationScene(onComplete: { self.markComplete(11) })) },
            { AnyView(HoldYourBreathTimerScene(onComplete: { self.markComplete(12) })) },
            { AnyView(SmokingLungsScene(onComplete: { self.markComplete(13) })) },
            { AnyView(HiccupsSneezesScene(onComplete: { self.markComplete(14) })) },
            { AnyView(AnimalRespirationAtlasScene(onComplete: { self.markComplete(15) })) },
            { AnyView(MountainSicknessScene(onComplete: { self.markComplete(16) })) },
            { AnyView(CPRLifesaverScene(onComplete: { self.markComplete(17) })) },
            { AnyView(QuickCheckQuizScene(
                title: "Respiration Quiz",
                questions: Array(self.chapter.quickCheckQuestionsList.prefix(4)),
                onComplete: { score in self.markComplete(18, score: score, max: 4) }
            )) },
            { AnyView(Scene9_BossQuiz_Ch10(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.10

private struct BreathingRateByActivityScene: View {
    let onComplete: () -> Void
    @State private var activity: Int = 0
    private let activities = [
        ("😴 Sleeping", 12),
        ("🚶 Walking", 18),
        ("🏃 Running", 30),
        ("🚴 Cycling hard", 40),
        ("🏊 Swimming sprint", 50)
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Breaths Per Minute by Activity").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(activities[activity].0).font(.system(size: 60))
            Text("\(activities[activity].1)").font(.system(size: 64, weight: .bold).monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("breaths / min").font(.caption).foregroundColor(.secondary)
            HStack(spacing: 8) {
                ForEach(0..<activities.count, id: \.self) { i in
                    Button { withAnimation { activity = i } } label: {
                        Text(activities[i].0.prefix(3)).font(.title3)
                            .padding(6)
                            .background(Circle().fill(activity == i ? Color.compatIndigo.opacity(0.2) : Color.gray.opacity(0.08)))
                    }.buttonStyle(.plain).pointingCursor()
                }
            }
            Text("Cells need more oxygen during exercise → lungs work harder.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct LungAnatomyMapScene: View {
    let onComplete: () -> Void
    @State private var part: String? = nil
    private struct P: Identifiable { let id: String; let name: String; let detail: String }
    private let parts: [P] = [
        P(id: "nose", name: "Nose + nasal passage", detail: "Filters dust, warms + moistens incoming air."),
        P(id: "tra", name: "Trachea (windpipe)", detail: "Tube held open by C-rings of cartilage. Cilia + mucus catch dust."),
        P(id: "bro", name: "Bronchi + bronchioles", detail: "Trachea splits into two bronchi → many smaller bronchioles in each lung."),
        P(id: "alv", name: "Alveoli", detail: "300 million tiny air sacs. Where O₂ enters blood and CO₂ leaves.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Lung Anatomy Map").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(parts) { p in
                Button { part = p.id } label: {
                    HStack {
                        Text(p.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                    }
                    .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(part == p.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
            }
            if let s = part, let p = parts.first(where: { $0.id == s }) {
                Text(p.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct DiaphragmPumpScene: View {
    let onComplete: () -> Void
    @State private var inhale: Bool = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("The Diaphragm — Your Breathing Pump").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ZStack {
                RoundedRectangle(cornerRadius: 18).strokeBorder(Color.gray, lineWidth: 2)
                    .frame(width: 140, height: 180)
                Ellipse().fill(Color.pink.opacity(inhale ? 0.6 : 0.3))
                    .frame(width: 110, height: inhale ? 140 : 100).offset(y: inhale ? -10 : 10)
                Rectangle().fill(DesignTokens.BrandColor.danger.opacity(0.5))
                    .frame(width: 130, height: 6)
                    .offset(y: inhale ? 70 : 40)
            }
            Button { withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.4)) { inhale.toggle() } } label: {
                Text(inhale ? "Exhale" : "Inhale").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            Text(inhale
                 ? "Inhale: diaphragm flattens, chest expands, air rushes IN to fill the bigger volume."
                 : "Exhale: diaphragm relaxes upward, chest shrinks, air pushed OUT.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct CellularRespirationEquationScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Cellular Respiration — The Reverse").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            VStack(spacing: 8) {
                Text("C₆H₁₂O₆ + 6 O₂").font(.title2.weight(.bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
                Image(systemName: "arrow.down").foregroundColor(DesignTokens.BrandColor.primaryAction)
                    .font(.title2)
                Text("inside mitochondria").font(.caption.italic()).foregroundColor(.secondary)
                Image(systemName: "arrow.down").foregroundColor(DesignTokens.BrandColor.primaryAction)
                    .font(.title2)
                Text("6 CO₂ + 6 H₂O + ⚡ energy").font(.title2.weight(.bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            .padding(20).frame(maxWidth: DesignTokens.contentMaxWidth)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.85)))
            .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
            .padding(.horizontal, 24)
            Text("EXACT reverse of photosynthesis. Sugar + oxygen → CO₂ + water + ENERGY for the cell. Powers every heartbeat, every neuron.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct HoldYourBreathTimerScene: View {
    let onComplete: () -> Void
    @State private var seconds: Int = 0
    @State private var running: Bool = false
    @State private var bestSeconds: Int = 0
    /// Generation counter — bumped on stop() and onDisappear so any
    /// stale Task started by a previous start() exits its sleep loop
    /// immediately instead of ticking on for up to 10 minutes after
    /// the scene is dismissed.
    @State private var generation: Int = 0
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Hold Your Breath").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Tap Start, hold your breath, tap Stop when you have to breathe.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            Text("\(seconds) s").font(.system(size: 80, weight: .bold).monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            HStack(spacing: 14) {
                Button { start() } label: {
                    Text("Start").font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(DesignTokens.BrandColor.primaryAction.opacity(0.18)))
                        .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.primaryAction.opacity(0.5), lineWidth: 1))
                        .foregroundColor(DesignTokens.BrandColor.primaryAction)
                }.buttonStyle(.plain).pointingCursor().disabled(running)
                Button { stop() } label: {
                    Text("Stop").font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(DesignTokens.BrandColor.danger.opacity(0.18)))
                        .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                        .foregroundColor(DesignTokens.BrandColor.danger)
                }.buttonStyle(.plain).pointingCursor().disabled(!running)
            }
            if bestSeconds > 0 {
                Text("Your best: \(bestSeconds) s").font(.callout.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            Text("Average for a healthy kid: 30-60s. Free divers can hold for 8+ minutes after years of training!")
                .font(.caption).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.horizontal, 24).multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
        .onDisappear { running = false; generation += 1 }
    }
    private func start() {
        seconds = 0; running = true
        generation += 1
        let myGen = generation
        Task { @MainActor in
            while running && seconds < 600 && myGen == generation {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if myGen != generation || !running { break }
                seconds += 1
            }
        }
    }
    private func stop() {
        running = false
        generation += 1
        if seconds > bestSeconds { bestSeconds = seconds }
    }
}

private struct SmokingLungsScene: View {
    let onComplete: () -> Void
    @State private var smoking: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Smoking & Lungs").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(smoking ? "🫁🌫" : "🫁").font(.system(size: 100))
            Button { withAnimation { smoking.toggle() } } label: {
                Text(smoking ? "Stop smoking" : "Smoking →").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(DesignTokens.BrandColor.danger.opacity(0.18)))
                    .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                    .foregroundColor(DesignTokens.BrandColor.danger)
            }.buttonStyle(.plain).pointingCursor()
            Text(smoking
                 ? "Tobacco smoke paralyses cilia (the hair-like cleaners), coats alveoli with tar, and brings in toxic gases. Cancer risk multiplies. Quitting reverses some damage."
                 : "Healthy lungs are pink, cilia sweep dust away, alveoli are clean. Breathing feels easy.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct HiccupsSneezesScene: View {
    let onComplete: () -> Void
    @State private var pick: String = "hiccup"
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Why Do We Hiccup or Sneeze?").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Hiccup", val: "hiccup", on: pick) { pick = "hiccup" }
                pickChip("Sneeze", val: "sneeze", on: pick) { pick = "sneeze" }
                pickChip("Yawn", val: "yawn", on: pick) { pick = "yawn" }
            }
            Text(pick == "hiccup" ? "😬" : pick == "sneeze" ? "🤧" : "😮").font(.system(size: 100))
            let body: String = {
                switch pick {
                case "hiccup": return "Hiccup: diaphragm spasms unexpectedly, then the vocal cords snap shut → 'hic!' Often triggered by eating too fast or excitement."
                case "sneeze": return "Sneeze: reflex to clear the nose. Air rushes out at up to 160 km/h to expel dust, pollen, or virus particles."
                default: return "Yawn: thought to cool the brain or signal tiredness. Contagious because of mirror neurons in our brains."
                }
            }()
            Text(body).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func pickChip(_ label: String, val: String, on: String, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(on == val ? .bold : .regular))
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Capsule().fill(on == val ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct AnimalRespirationAtlasScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct A: Identifiable { let id: String; let emoji: String; let name: String; let how: String }
    private let animals: [A] = [
        A(id: "fish", emoji: "🐟", name: "Fish", how: "Gills — extract O₂ dissolved in water."),
        A(id: "frog", emoji: "🐸", name: "Frog", how: "Lungs on land + skin underwater. Skin must stay moist."),
        A(id: "insect", emoji: "🐝", name: "Insect", how: "Tracheae — branching air tubes carry O₂ directly to every cell."),
        A(id: "worm", emoji: "🪱", name: "Earthworm", how: "Through moist skin. No lungs, no gills."),
        A(id: "bird", emoji: "🦅", name: "Bird", how: "Lungs + air sacs throughout body. Most efficient design — needed for flight.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("How Different Animals Breathe").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(animals) { a in
                Button { tapped.insert(a.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack { Text(a.emoji).font(.title2)
                            Text(a.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText) }
                        if tapped.contains(a.id) {
                            Text(a.how).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

private struct MountainSicknessScene: View {
    let onComplete: () -> Void
    @State private var altitude: Double = 500
    private var status: String {
        if altitude < 1500 { return "Plains — normal oxygen. Easy breathing." }
        if altitude < 3000 { return "Hill station — slightly thinner air. Most people fine." }
        if altitude < 4500 { return "Acclimatize zone — climb slowly, drink water." }
        if altitude < 5500 { return "Risk of altitude sickness — headache, nausea, breathlessness." }
        return "Death zone — without oxygen masks, body deteriorates fast."
    }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Mountain Sickness — Less Oxygen Up High").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Altitude: \(Int(altitude)) m").font(.title2.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $altitude, in: 0...8848).frame(maxWidth: 340).padding(.horizontal, 24)
            Text(status).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Text("Everest summit (8848 m) has 1/3 the oxygen of sea level. Sherpas have evolved larger lungs + more red blood cells.")
                .font(.caption).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.horizontal, 24).multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct CPRLifesaverScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("👀", "1. Check: is the person responsive? Tap their shoulder, shout."),
        ("📞", "2. Call 102 (ambulance) or get someone else to."),
        ("🫳", "3. Place both hands centred on chest. Press hard, 5 cm deep."),
        ("🎵", "4. Compress at 100-120/min — same beat as 'Stayin' Alive'."),
        ("🔁", "5. Keep going until paramedics arrive. Don't stop.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("CPR — Buy Time Until Help Arrives").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(steps[step].0).font(.system(size: 100))
            Text(steps[step].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { step = (step + 1) % steps.count } } label: {
                Text("Next step").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            Text("Real CPR needs hands-on training. Many schools + societies offer free classes — worth taking when you're older.")
                .font(.caption.italic()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.horizontal, 24).multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

