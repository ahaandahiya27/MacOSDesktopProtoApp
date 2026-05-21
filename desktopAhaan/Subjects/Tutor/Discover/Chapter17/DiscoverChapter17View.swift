import SwiftUI

struct DiscoverChapter17View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(17)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Forest Layers",
        "Decomposer Cycle",
        "Food Web Builder",
        "Forest as Sponge",
        "O₂ ⇄ CO₂ Balance",
        "Animal Niche Match",
        "Deforestation Domino",
        "Reforestation Plan",
        "Indian Forest Types",
        "Tree of Life — Banyan",
        "Wildlife Sanctuary Atlas",
        "Producer→Consumer→Decomposer",
        "Carbon Storage Slider",
        "Tribal Communities & Forests",
        "Project Tiger Story",
        "Forest Fire Triangle",
        "Sustainable Logging",
        "Chipko Movement Story",
        "Forest Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 17 — Forests: Our Lifeline",
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
            { AnyView(Scene1_ForestLayers(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_DecomposerCycle(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_FoodWebBuilder(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_ForestAsSponge(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_O2CO2Balance(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_AnimalNicheMatch(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(5, score: score, max: 4) })) },
            { AnyView(Scene7_DeforestationDomino(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_ReforestationPlan(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(IndianForestTypesScene(onComplete: { self.markComplete(8) })) },
            { AnyView(BanyanTreeScene(onComplete: { self.markComplete(9) })) },
            { AnyView(WildlifeSanctuaryAtlasScene(onComplete: { self.markComplete(10) })) },
            { AnyView(ProducerConsumerDecomposerScene(onComplete: { self.markComplete(11) })) },
            { AnyView(CarbonStorageSliderScene(onComplete: { self.markComplete(12) })) },
            { AnyView(TribalCommunitiesScene(onComplete: { self.markComplete(13) })) },
            { AnyView(ProjectTigerScene(onComplete: { self.markComplete(14) })) },
            { AnyView(ForestFireTriangleScene(onComplete: { self.markComplete(15) })) },
            { AnyView(SustainableLoggingScene(onComplete: { self.markComplete(16) })) },
            { AnyView(ChipkoMovementScene(onComplete: { self.markComplete(17) })) },
            { AnyView(ForestQuizScene(onComplete: { score in self.markComplete(18, score: score, max: 4) })) },
            { AnyView(Scene9_BossQuiz_Ch17(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.17

private struct IndianForestTypesScene: View {
    let onComplete: () -> Void
    @State private var sel: String? = nil
    private struct F: Identifiable { let id: String; let name: String; let region: String; let detail: String }
    private let forests: [F] = [
        F(id: "tropmoist", name: "Tropical Evergreen", region: "Western Ghats, NE India",
          detail: "Heavy rain, dense canopy. Mahogany, teak. Never sheds all leaves."),
        F(id: "tropdry", name: "Tropical Deciduous", region: "Central + South India",
          detail: "Sheds leaves in dry season. Sal, sheesham. Most of India's forests."),
        F(id: "alpine", name: "Alpine", region: "Above 3500m in Himalaya",
          detail: "Pine, juniper, rhododendron. Snow-line vegetation."),
        F(id: "mangrove", name: "Mangrove", region: "Sundarbans, Andaman coasts",
          detail: "Salt-tolerant trees with stilt roots. Home to Royal Bengal tigers."),
        F(id: "thorn", name: "Thorn / Scrub", region: "Rajasthan, parts of Gujarat",
          detail: "Acacia, cactus, ber. Surviving on minimal water.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Forest Types of India").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(forests) { f in
                Button { sel = f.id } label: {
                    HStack {
                        Text(f.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                        Text(f.region).font(.caption).foregroundColor(.secondary).lineLimit(1)
                    }
                    .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(sel == f.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
            }
            if let s = sel, let f = forests.first(where: { $0.id == s }) {
                Text(f.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct BanyanTreeScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Banyan — One Tree, Many Trunks").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🌳").font(.system(size: 110))
            Text("India's national tree. Aerial roots drop from branches → touch ground → thicken into new trunks. A single banyan can spread over 2 hectares and live 500+ years.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Text("The Great Banyan in Kolkata's botanical garden has ~3600 aerial roots and looks like a whole forest from one seed.")
                .font(.caption.italic()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.horizontal, 24).multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct WildlifeSanctuaryAtlasScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct S: Identifiable { let id: String; let name: String; let detail: String }
    private let sancs: [S] = [
        S(id: "jim", name: "Jim Corbett (Uttarakhand)", detail: "India's first national park (1936). Royal Bengal tigers + elephants."),
        S(id: "kaziranga", name: "Kaziranga (Assam)", detail: "World's largest population of one-horned rhinos. UNESCO heritage site."),
        S(id: "gir", name: "Gir (Gujarat)", detail: "Only home of Asiatic lions outside Africa."),
        S(id: "ranthambore", name: "Ranthambore (Rajasthan)", detail: "Best place to spot tigers in the wild."),
        S(id: "sundarbans", name: "Sundarbans (W. Bengal)", detail: "Mangrove tiger habitat. Tigers actually swim here.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Wildlife Sanctuaries of India").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(sancs) { s in
                Button { tapped.insert(s.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(s.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        if tapped.contains(s.id) {
                            Text(s.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

private struct ProducerConsumerDecomposerScene: View {
    let onComplete: () -> Void
    @State private var role: String = "producer"
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Producer · Consumer · Decomposer").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 8) {
                pickChip("Producer", v: "producer", on: role) { role = "producer" }
                pickChip("Consumer", v: "consumer", on: role) { role = "consumer" }
                pickChip("Decomposer", v: "decomposer", on: role) { role = "decomposer" }
            }
            Text(role == "producer" ? "🌳" : role == "consumer" ? "🦌" : "🍄").font(.system(size: 100))
            let body: String = {
                switch role {
                case "producer": return "Producers (green plants) make food from sunlight via photosynthesis. Foundation of every food chain."
                case "consumer": return "Consumers eat other organisms. Herbivores (deer) eat plants. Carnivores (tiger) eat meat. Omnivores (bear) eat both."
                default: return "Decomposers (fungi, bacteria, earthworms) break down dead organisms. Recycle nutrients back to soil. Without them, dead matter would pile up forever."
                }
            }()
            Text(body).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func pickChip(_ label: String, v: String, on: String, tap: @escaping () -> Void) -> some View {
        Button(action: tap) {
            Text(label).font(.body.weight(on == v ? .bold : .regular))
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Capsule().fill(on == v ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct CarbonStorageSliderScene: View {
    let onComplete: () -> Void
    @State private var trees: Double = 100
    private var co2Stored: Double { trees * 22 } // ~22 kg/year per tree
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Forests Are Carbon Vaults").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Each tree absorbs ~22 kg of CO₂ per year. A whole forest is a giant air-cleaner.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            Text("\(Int(trees)) trees").font(.title2.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $trees, in: 10...1000).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("= \(Int(co2Stored)) kg CO₂ stored / year")
                .font(.title.weight(.bold).monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.primaryAction)
            Text("Equivalent to taking ~\(Int(co2Stored / 4600)) cars off the road for a year. Plant trees!")
                .font(.caption.italic()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.horizontal, 24).multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct TribalCommunitiesScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Forests Are Home to Adivasi Communities").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🏘🌳").font(.system(size: 90))
            Text("India has ~700 tribal groups, ~104 million people. Many live in or near forests — Gonds (central India), Santhals (eastern), Bhils (western), Nagas (NE). They depend on forests for food, medicine, fuel, building materials.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Text("Forest Rights Act (2006) recognises tribal communities' right to live in + use forest land.")
                .font(.caption.italic()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.horizontal, 24).multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct ProjectTigerScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🐅", "1973: Project Tiger launched. India had ~1827 tigers."),
        ("📉", "By 2006: dropped to ~1411. Habitat loss + poaching."),
        ("🛡", "9 tiger reserves expanded to 54 today. Stronger laws."),
        ("📈", "2022 census: 3682 tigers — India hosts 70% of world's wild tigers!")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Project Tiger — Saving the Royal Bengal").font(.largeTitle.bold())
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

private struct ForestFireTriangleScene: View {
    let onComplete: () -> Void
    @State private var dry: Bool = false
    @State private var spark: Bool = false
    @State private var wind: Bool = false
    private var burns: Bool { dry && spark && wind }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Forest Fire Triangle").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Forest fires need: dry vegetation, a spark, and wind to spread. Remove any one and the fire can't catch.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            Text(burns ? "🔥🌲" : "🌲").font(.system(size: 100))
            HStack(spacing: 12) {
                toggleChip("Dry", on: $dry)
                toggleChip("Spark", on: $spark)
                toggleChip("Wind", on: $wind)
            }
            Text(burns ? "🚨 Forest fire raging." : "🌲 Safe.")
                .font(.headline)
                .foregroundColor(burns ? DesignTokens.BrandColor.danger : DesignTokens.BrandColor.primaryAction)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func toggleChip(_ label: String, on: Binding<Bool>) -> some View {
        Button { on.wrappedValue.toggle() } label: {
            Text(label).font(.body.weight(.semibold))
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Capsule().fill(on.wrappedValue ? DesignTokens.BrandColor.danger.opacity(0.2) : Color.gray.opacity(0.1)))
                .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                .foregroundColor(DesignTokens.BrandColor.danger)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct SustainableLoggingScene: View {
    let onComplete: () -> Void
    @State private var sustainable: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Logging — Sustainable vs Clearcut").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Sustainable", on: sustainable) { sustainable = true }
                pickChip("Clearcut", on: !sustainable) { sustainable = false }
            }
            Text(sustainable ? "🌲🪓🌱" : "🪵🪵🪵").font(.system(size: 80))
            Text(sustainable
                 ? "Sustainable: cut only mature trees, replant saplings, leave forest structure intact. Forest regenerates."
                 : "Clearcut: every tree removed. Soil erodes, biodiversity collapses, can take 50+ years to recover (if ever). Banned in many countries.")
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

private struct ChipkoMovementScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Chipko — Hugging Trees to Save Them").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🤗🌳").font(.system(size: 100))
            Text("1973, Reni village, Uttarakhand. Contractors arrived to cut trees. Women led by Gaura Devi hugged the trees ('chipko' = to stick). Loggers couldn't cut without hurting them. The movement spread, India banned tree-felling in much of the Himalaya for 15 years.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Text("Sundarlal Bahuguna and Chandi Prasad Bhatt became its faces. A turning point in Indian environmental history.")
                .font(.caption.italic()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.horizontal, 24).multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct ForestQuizScene: View {
    let onComplete: (Int) -> Void
    private struct Q: Identifiable {
        let id: String; let prompt: String; let opts: [String]; let correct: Int
    }
    private let qs: [Q] = [
        Q(id: "q1", prompt: "Forests act like a giant sponge because they:",
          opts: ["Look soft", "Absorb rainwater + release slowly", "Have moss"], correct: 1),
        Q(id: "q2", prompt: "Decomposers turn dead matter into:",
          opts: ["Stone", "Humus + nutrients in soil", "Plastic"], correct: 1),
        Q(id: "q3", prompt: "India's national tree?",
          opts: ["Mango", "Banyan", "Neem"], correct: 1),
        Q(id: "q4", prompt: "Chipko movement was about:",
          opts: ["Saving rivers", "Hugging trees to stop felling", "Building dams"], correct: 1)
    ]
    @State private var picks: [String: Int] = [:]
    private var score: Int { qs.reduce(0) { $0 + ((picks[$1.id] == $1.correct) ? 1 : 0) } }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Forest Quiz").font(.largeTitle.bold())
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
