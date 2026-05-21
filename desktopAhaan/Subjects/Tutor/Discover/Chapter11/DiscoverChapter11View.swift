import SwiftUI

struct DiscoverChapter11View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(11)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Heart Beats",
        "Pulse Counter",
        "Blood Sort",
        "Artery / Vein / Capillary",
        "Kidney Filter",
        "Xylem Water Climb",
        "Phloem Sugar Pipeline",
        "Transpiration Pull",
        "Four Chamber Heart Map",
        "Blood Types ABO Wheel",
        "Sweat & Skin Excretion",
        "Dialysis vs Real Kidney",
        "Lymph — The Second Highway",
        "Blood Pressure Cuff",
        "Cardio Healthy Habits",
        "Root Hair Surface Area",
        "Guttation vs Transpiration",
        "Insect Open Circulation",
        "Transportation Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 11 — Transportation in Animals and Plants",
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
            { AnyView(Scene1_HeartBeats(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_PulseCounter(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_BloodSort(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(2, score: score, max: 4) })) },
            { AnyView(Scene4_ArteryVeinCapillary(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(3, score: score, max: 3) })) },
            { AnyView(Scene5_KidneyFilter(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_XylemWaterClimb(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_PhloemSugarPipeline(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_TranspirationPull(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(FourChamberHeartScene(onComplete: { self.markComplete(8) })) },
            { AnyView(BloodTypesABOScene(onComplete: { self.markComplete(9) })) },
            { AnyView(SweatSkinExcretionScene(onComplete: { self.markComplete(10) })) },
            { AnyView(DialysisVsKidneyScene(onComplete: { self.markComplete(11) })) },
            { AnyView(LymphHighwayScene(onComplete: { self.markComplete(12) })) },
            { AnyView(BloodPressureCuffScene(onComplete: { self.markComplete(13) })) },
            { AnyView(CardioHabitsScene(onComplete: { self.markComplete(14) })) },
            { AnyView(RootHairSurfaceAreaScene(onComplete: { self.markComplete(15) })) },
            { AnyView(GuttationVsTranspirationScene(onComplete: { self.markComplete(16) })) },
            { AnyView(InsectOpenCirculationScene(onComplete: { self.markComplete(17) })) },
            { AnyView(TransportationQuizScene(onComplete: { score in self.markComplete(18, score: score, max: 4) })) },
            { AnyView(Scene9_BossQuiz_Ch11(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.11

private struct FourChamberHeartScene: View {
    let onComplete: () -> Void
    @State private var pick: String? = nil
    private struct C: Identifiable { let id: String; let name: String; let detail: String }
    private let chambers: [C] = [
        C(id: "ra", name: "Right Atrium", detail: "Receives O₂-poor blood from body via veins."),
        C(id: "rv", name: "Right Ventricle", detail: "Pumps O₂-poor blood to the lungs."),
        C(id: "la", name: "Left Atrium", detail: "Receives O₂-rich blood from the lungs."),
        C(id: "lv", name: "Left Ventricle", detail: "Strongest chamber — pumps O₂-rich blood to the whole body.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Four-Chamber Heart Map").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("❤️").font(.system(size: 90))
            ForEach(chambers) { c in
                Button { pick = c.id } label: {
                    HStack {
                        Text(c.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                    }
                    .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(pick == c.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
            }
            if let s = pick, let c = chambers.first(where: { $0.id == s }) {
                Text(c.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct BloodTypesABOScene: View {
    let onComplete: () -> Void
    @State private var type: String = "A"
    private let types = ["A", "B", "AB", "O"]
    private var canReceiveFrom: String {
        switch type {
        case "A": return "A, O"
        case "B": return "B, O"
        case "AB": return "A, B, AB, O — universal recipient!"
        default: return "O only"
        }
    }
    private var canGiveTo: String {
        switch type {
        case "A": return "A, AB"
        case "B": return "B, AB"
        case "AB": return "AB only"
        default: return "A, B, AB, O — universal donor!"
        }
    }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Blood Types ABO Wheel").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 10) {
                ForEach(types, id: \.self) { t in
                    Button { type = t } label: {
                        Text(t).font(.title3.weight(.bold))
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(Circle().fill(type == t ? Color.compatIndigo.opacity(0.2) : Color.gray.opacity(0.1)))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                    }.buttonStyle(.plain).pointingCursor()
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Can receive from:").font(.caption.weight(.semibold)).foregroundColor(.secondary)
                Text(canReceiveFrom).font(.body).foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("Can give to:").font(.caption.weight(.semibold)).foregroundColor(.secondary)
                Text(canGiveTo).font(.body).foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            .padding(14)
            .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
            .padding(.horizontal, 24)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct SweatSkinExcretionScene: View {
    let onComplete: () -> Void
    @State private var sweating: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Sweat — Skin's Job").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(sweating ? "💦🧍" : "🧍").font(.system(size: 100))
            Button { withAnimation { sweating.toggle() } } label: {
                Text(sweating ? "Cool down" : "Get hot").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(DesignTokens.BrandColor.danger.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                    .foregroundColor(DesignTokens.BrandColor.danger)
            }.buttonStyle(.plain).pointingCursor()
            Text(sweating
                 ? "Sweat = water + salts + urea. Evaporation cools the skin AND removes wastes. A second 'kidney' for waste."
                 : "Resting: 2-3 million sweat glands waiting. Sweat is your built-in air conditioner.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct DialysisVsKidneyScene: View {
    let onComplete: () -> Void
    @State private var real: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Real Kidney vs Dialysis").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Real kidney", on: real) { real = true }
                pickChip("Dialysis machine", on: !real) { real = false }
            }
            Text(real ? "🫘" : "🧪").font(.system(size: 100))
            Text(real
                 ? "Two bean-shaped kidneys filter ~180 L of blood every day. Keeps the salt, water, and nutrient balance perfect. Discards waste as urine."
                 : "If kidneys fail: machine pumps blood through a filter outside the body. Takes 4 hours, 3× a week. Life-saving, but no substitute for the real thing.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
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

private struct LymphHighwayScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Lymph — The Body's Second Highway").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🩺").font(.system(size: 100))
            Text("Besides blood, your body has a SECOND fluid network — lymph. Drains excess tissue fluid, returns it to blood, and carries lymphocytes (immune cells) that fight infection. Lymph nodes (the swollen lumps when you're sick) are immune outposts.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct BloodPressureCuffScene: View {
    let onComplete: () -> Void
    @State private var systolic: Double = 120
    @State private var diastolic: Double = 80
    private var status: String {
        if systolic < 90 || diastolic < 60 { return "Low — feel dizzy when standing." }
        if systolic > 140 || diastolic > 90 { return "High — heart strain, doctor visit." }
        return "Normal — healthy range."
    }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Blood Pressure Cuff").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 8) {
                Text("\(Int(systolic))").font(.system(size: 56, weight: .bold).monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("/").font(.title.bold()).foregroundColor(.secondary)
                Text("\(Int(diastolic))").font(.system(size: 56, weight: .bold).monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text("mmHg").font(.caption).foregroundColor(.secondary)
            }
            Text("Systolic (heart pumps)").font(.caption).foregroundColor(.secondary)
            Slider(value: $systolic, in: 80...180).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("Diastolic (heart rests)").font(.caption).foregroundColor(.secondary)
            Slider(value: $diastolic, in: 50...120).frame(maxWidth: 340).padding(.horizontal, 24)
            Text(status).font(.callout.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct CardioHabitsScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct Habit: Identifiable { let id: String; let title: String; let detail: String }
    private let habits: [Habit] = [
        Habit(id: "ex", title: "30 min daily exercise", detail: "Strengthens heart muscle. Lowers resting heart rate."),
        Habit(id: "salt", title: "Less salt + processed food", detail: "Sodium raises blood pressure. Aim < 5g salt/day."),
        Habit(id: "veg", title: "Plenty of fruits + veggies", detail: "Fibre + potassium protect arteries."),
        Habit(id: "sleep", title: "7-9 hours sleep", detail: "Less sleep → higher blood pressure + inflammation.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Heart-Healthy Habits").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(habits) { h in
                Button { tapped.insert(h.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(h.title).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        if tapped.contains(h.id) {
                            Text(h.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

private struct RootHairSurfaceAreaScene: View {
    let onComplete: () -> Void
    @State private var zoomedIn: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Root Hairs — Tiny but Many").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ZStack {
                if zoomedIn {
                    HStack(spacing: 2) {
                        ForEach(0..<30, id: \.self) { _ in
                            Capsule().fill(Color.compatBrown.opacity(0.7))
                                .frame(width: 4, height: 80)
                        }
                    }
                } else {
                    Capsule().fill(Color.compatBrown.opacity(0.7))
                        .frame(width: 14, height: 160)
                }
            }
            .frame(height: 200)
            Button { withAnimation { zoomedIn.toggle() } } label: {
                Text(zoomedIn ? "Zoom out" : "Zoom in").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            Text(zoomedIn
                 ? "A single root has thousands of tiny finger-like root hairs. Each one absorbs water + minerals. Together — surface area of a football field."
                 : "From a distance, the root looks like one tube. Zoom in to see the secret to absorption.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct GuttationVsTranspirationScene: View {
    let onComplete: () -> Void
    @State private var guttation: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Guttation vs Transpiration").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Guttation", on: guttation) { guttation = true }
                pickChip("Transpiration", on: !guttation) { guttation = false }
            }
            Text(guttation ? "💧🍃" : "💨🍃").font(.system(size: 100))
            Text(guttation
                 ? "Guttation: tiny WATER DROPS at leaf edges, especially early morning. Pressure from roots pushes liquid water out through hydathodes. Happens in cool humid nights."
                 : "Transpiration: water VAPOUR escapes from stomata during the day. Drives the upward suction that pulls water from roots to leaves.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
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

private struct InsectOpenCirculationScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Insect Blood — No Vessels Needed").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🐝").font(.system(size: 100))
            Text("Insects don't have arteries or veins. Their 'blood' (hemolymph) sloshes freely inside the body cavity, washing over organs. A simple tube-heart pumps it from rear to front. Works because insects are small and use tracheae (not blood) to deliver O₂.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct TransportationQuizScene: View {
    let onComplete: (Int) -> Void
    private struct Q: Identifiable {
        let id: String; let prompt: String; let opts: [String]; let correct: Int
    }
    private let qs: [Q] = [
        Q(id: "q1", prompt: "What carries O₂-rich blood AWAY from the heart?",
          opts: ["Veins", "Arteries", "Lymph"], correct: 1),
        Q(id: "q2", prompt: "Where in a plant does sugar travel from leaves to roots?",
          opts: ["Xylem", "Phloem", "Stomata"], correct: 1),
        Q(id: "q3", prompt: "Universal blood donor type?",
          opts: ["A", "AB", "O"], correct: 2),
        Q(id: "q4", prompt: "Kidneys filter how much blood per day?",
          opts: ["~5 L", "~180 L", "~1500 L"], correct: 1)
    ]
    @State private var picks: [String: Int] = [:]
    private var score: Int { qs.reduce(0) { $0 + ((picks[$1.id] == $1.correct) ? 1 : 0) } }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Transportation Quiz").font(.largeTitle.bold())
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
