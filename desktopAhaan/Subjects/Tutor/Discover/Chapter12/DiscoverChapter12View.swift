import SwiftUI

struct DiscoverChapter12View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(12)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Flower Anatomy",
        "Pollination Match",
        "Self vs Cross Pollination",
        "Fertilisation",
        "Seed Dispersal",
        "Vegetative Propagation",
        "Budding",
        "Fragmentation",
        "Stamen vs Pistil Sorter",
        "Wind vs Insect Pollination",
        "Spore Formation Lab",
        "Mango Embryo Inside Seed",
        "Coconut Floats: Water Dispersal",
        "Burr Hooks: Animal Dispersal",
        "Bee Waggle Dance",
        "Cuttings, Layering, Grafting",
        "Tubers, Bulbs & Runners",
        "Hibiscus Bisexual Flower",
        "Reproduction Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 12 — Reproduction in Plants",
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
            { AnyView(Scene1_FlowerAnatomy(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_PollinationMatch(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(1, score: score, max: 4) })) },
            { AnyView(Scene3_SelfVsCross(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_Fertilisation(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_SeedDispersal(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(4, score: score, max: 4) })) },
            { AnyView(Scene6_VegetativePropagation(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_Budding(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_Fragmentation(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(StamenPistilSorterScene(onComplete: { self.markComplete(8) })) },
            { AnyView(WindInsectPollinationScene(onComplete: { self.markComplete(9) })) },
            { AnyView(SporeFormationScene(onComplete: { self.markComplete(10) })) },
            { AnyView(MangoEmbryoScene(onComplete: { self.markComplete(11) })) },
            { AnyView(CoconutWaterDispersalScene(onComplete: { self.markComplete(12) })) },
            { AnyView(BurrHooksScene(onComplete: { self.markComplete(13) })) },
            { AnyView(BeeWaggleDanceScene(onComplete: { self.markComplete(14) })) },
            { AnyView(CuttingsLayeringScene(onComplete: { self.markComplete(15) })) },
            { AnyView(TubersBulbsRunnersScene(onComplete: { self.markComplete(16) })) },
            { AnyView(HibiscusBisexualScene(onComplete: { self.markComplete(17) })) },
            { AnyView(ReproductionQuizScene(onComplete: { score in self.markComplete(18, score: score, max: 4) })) },
            { AnyView(Scene9_BossQuiz_Ch12(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.12

private struct StamenPistilSorterScene: View {
    let onComplete: () -> Void
    @State private var pick: String? = nil
    private struct Part: Identifiable { let id: String; let name: String; let isStamen: Bool; let detail: String }
    private let parts: [Part] = [
        Part(id: "anther", name: "Anther", isStamen: true, detail: "Top of stamen — makes + releases pollen."),
        Part(id: "filament", name: "Filament", isStamen: true, detail: "Stalk holding the anther up."),
        Part(id: "stigma", name: "Stigma", isStamen: false, detail: "Sticky top of pistil — catches pollen."),
        Part(id: "style", name: "Style", isStamen: false, detail: "Tube the pollen tube travels down."),
        Part(id: "ovary", name: "Ovary", isStamen: false, detail: "Bottom — holds ovules. Becomes the fruit.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Male or Female Part?").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🌸").font(.system(size: 90))
            ForEach(parts) { p in
                Button { pick = p.id } label: {
                    HStack {
                        Text(p.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                        Text(p.isStamen ? "Stamen" : "Pistil").font(.caption)
                            .foregroundColor(p.isStamen ? DesignTokens.BrandColor.lookingAhead : DesignTokens.BrandColor.relatedConcepts)
                    }
                    .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(pick == p.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
            }
            if let s = pick, let p = parts.first(where: { $0.id == s }) {
                Text(p.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct WindInsectPollinationScene: View {
    let onComplete: () -> Void
    @State private var wind: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Wind vs Insect Pollination").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Wind", on: wind) { wind = true }
                pickChip("Insect", on: !wind) { wind = false }
            }
            Text(wind ? "🌾💨" : "🌻🐝").font(.system(size: 100))
            Text(wind
                 ? "Wind-pollinated: small dull flowers, no nectar, huge amounts of light dry pollen. Grass, wheat, rice. Hay fever season is when they release pollen!"
                 : "Insect-pollinated: bright showy flowers, scent, nectar, sticky heavy pollen. Bees, butterflies, beetles do the work. Most fruits + flowering plants.")
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

private struct SporeFormationScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🍄", "Fern frond underside has tiny brown dots — sori."),
        ("🟤", "Each sorus contains hundreds of sporangia (spore cases)."),
        ("💥", "When ripe, sporangia burst — release thousands of dust-like spores."),
        ("🌱", "A spore lands on damp soil, germinates into a new fern. No flower needed!")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Spore Formation — Ferns & Mosses").font(.largeTitle.bold())
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

private struct MangoEmbryoScene: View {
    let onComplete: () -> Void
    @State private var cut: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Inside a Mango Seed").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(cut ? "🥭✂️" : "🥭").font(.system(size: 100))
            Button { withAnimation { cut.toggle() } } label: {
                Text(cut ? "Reassemble" : "Cut it open").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            if cut {
                Text("Inside the hard seed coat: a tiny embryo (the baby plant) + cotyledons (food reserve to feed it until photosynthesis takes over). Plant the seed — given water and warmth, the baby grows into a sapling.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct CoconutWaterDispersalScene: View {
    let onComplete: () -> Void
    @State private var floating: Bool = false
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Coconut — The Floating Seed").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🥥").font(.system(size: 100))
                .offset(x: floating ? 80 : -80)
                .animation(.linear(duration: 4).repeatForever(autoreverses: true))
            Button { floating.toggle() } label: {
                Text(floating ? "Stop drift" : "Set adrift").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            Text("Coconut shells have a tough waterproof husk, an air pocket inside. Falls into the sea, drifts thousands of km, washes up on a faraway beach, sprouts a new tree. That's how coconuts colonised tropical islands worldwide.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct BurrHooksScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Burrs — Animal Dispersal").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🪝").font(.system(size: 100))
            Text("Some seeds (Xanthium, Aerva, Cocklebur) wear tiny hooks. Stick to fur, socks, hair as animals or humans walk past. Hours later they fall off km away. A Swiss engineer noticed how burrs stuck to his dog's fur in 1941 — and invented Velcro.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct BeeWaggleDanceScene: View {
    let onComplete: () -> Void
    @State private var dance: Bool = false
    @State private var angle: Double = 0
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Bee Waggle Dance — Map by Movement").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🐝").font(.system(size: 90))
                .rotationEffect(.degrees(angle))
            Button { dance.toggle(); startDance() } label: {
                Text(dance ? "Stop" : "Dance").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.mnemonicAccent.opacity(0.5), lineWidth: 1))
                    .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
            }.buttonStyle(.plain).pointingCursor()
            Text("Back at the hive, a forager bee dances a figure-8. The angle of the waggle = direction of the flower relative to the sun. Length of the waggle = how far. Bees follow + find the flower kilometres away.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
    private func startDance() {
        if dance {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                angle = 35
            }
        } else { angle = 0 }
    }
}

private struct CuttingsLayeringScene: View {
    let onComplete: () -> Void
    @State private var pick: String = "cutting"
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Three Ways to Clone a Plant").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 8) {
                pickChip("Cutting", val: "cutting", on: pick) { pick = "cutting" }
                pickChip("Layering", val: "layering", on: pick) { pick = "layering" }
                pickChip("Grafting", val: "grafting", on: pick) { pick = "grafting" }
            }
            let body: String = {
                switch pick {
                case "cutting": return "Cutting: snip a stem, dip in rooting powder, plant in moist soil. Roses, hibiscus, sugarcane multiply this way."
                case "layering": return "Layering: bend a low branch to the ground, bury part of it. New roots grow from the buried portion. Detach and you have a clone. Jasmine, strawberry."
                default: return "Grafting: join a desired top (scion) onto a hardy root (stock). Mangoes — the famous Alphonso top is grafted onto common mango stock so every mango tastes the same."
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
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Capsule().fill(on == val ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                .foregroundColor(Color.compatIndigo)
        }.buttonStyle(.plain).pointingCursor()
    }
}

private struct TubersBulbsRunnersScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct Org: Identifiable { let id: String; let emoji: String; let name: String; let detail: String }
    private let orgs: [Org] = [
        Org(id: "potato", emoji: "🥔", name: "Potato (tuber)", detail: "Eyes on the potato = buds. Each can grow into a new plant. That's how farmers replant."),
        Org(id: "onion", emoji: "🧅", name: "Onion (bulb)", detail: "Underground bulb is a stem with fleshy leaves storing food. Buds at the base sprout into new plants."),
        Org(id: "ginger", emoji: "🫚", name: "Ginger (rhizome)", detail: "Horizontal underground stem. Cut a piece with a bud → grows a new ginger plant."),
        Org(id: "straw", emoji: "🍓", name: "Strawberry (runner)", detail: "Stems crawl along the ground. New roots + plants pop up where they touch soil.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Tubers, Bulbs & Runners").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(orgs) { o in
                Button { tapped.insert(o.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack { Text(o.emoji).font(.title2)
                            Text(o.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText) }
                        if tapped.contains(o.id) {
                            Text(o.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

private struct HibiscusBisexualScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Hibiscus — A Bisexual Flower").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🌺").font(.system(size: 110))
            Text("Hibiscus, rose, mustard, tulip — these flowers have BOTH male (stamen) and female (pistil) parts in the same flower. They can self-pollinate or cross-pollinate.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Text("Contrast: papaya, cucumber, maize have separate male + female flowers — sometimes on the same plant, sometimes on different plants.")
                .font(.caption.italic()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct ReproductionQuizScene: View {
    let onComplete: (Int) -> Void
    private struct Q: Identifiable {
        let id: String; let prompt: String; let opts: [String]; let correct: Int
    }
    private let qs: [Q] = [
        Q(id: "q1", prompt: "Pollen lands on which part of the flower?",
          opts: ["Petal", "Stigma", "Sepal"], correct: 1),
        Q(id: "q2", prompt: "Coconuts disperse mainly by…",
          opts: ["Wind", "Water", "Insects"], correct: 1),
        Q(id: "q3", prompt: "Eyes on a potato are…",
          opts: ["Holes for breathing", "Buds that can grow new plants", "Where roots come out"], correct: 1),
        Q(id: "q4", prompt: "Asexual reproduction means…",
          opts: ["Two parents needed", "Only one parent — clones", "Always two-step process"], correct: 1)
    ]
    @State private var picks: [String: Int] = [:]
    private var score: Int { qs.reduce(0) { $0 + ((picks[$1.id] == $1.correct) ? 1 : 0) } }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Reproduction Quiz").font(.largeTitle.bold())
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
