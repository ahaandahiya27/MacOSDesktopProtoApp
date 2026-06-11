import SwiftUI

struct DiscoverChapter3View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(3)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "From Fluff to Fibre",
        "Meet the Wool Animals",
        "The Shearing Day",
        "The Wool Pipeline",
        "Sorter's Disease Lab",
        "Silkworm Life Cycle",
        "The Cocoon Reel",
        "Fibre vs Fibre Game",
        "Sheep Breeds Atlas",
        "Wool Quality Grader",
        "Carding & Spinning Lab",
        "Dye Vat — Tap to Mix",
        "Looms Through Time",
        "Sericulture Calendar",
        "Mulberry vs Tasar Silk",
        "Cotton vs Jute Tug",
        "Natural vs Synthetic Sorter",
        "Fabric Care Symbols Quiz",
        "Indian Textile Map",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 3 — Fibre to Fabric",
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
            { AnyView(Scene1_FluffToFibre(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_MeetTheWoolAnimals(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_TheShearingDay(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_TheWoolPipeline(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_SortersDiseaseLab(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_SilkwormLifeCycle(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_TheCocoonReel(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_FibreVsFibreGame(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(7, score: score, max: 6) })) },
            { AnyView(SheepBreedsAtlasScene(onComplete: { self.markComplete(8) })) },
            { AnyView(WoolQualityGraderScene(onComplete: { self.markComplete(9) })) },
            { AnyView(CardingSpinningLabScene(onComplete: { self.markComplete(10) })) },
            { AnyView(DyeVatMixScene(onComplete: { self.markComplete(11) })) },
            { AnyView(LoomsThroughTimeScene(onComplete: { self.markComplete(12) })) },
            { AnyView(SericultureCalendarScene(onComplete: { self.markComplete(13) })) },
            { AnyView(MulberryVsTasarScene(onComplete: { self.markComplete(14) })) },
            { AnyView(CottonVsJuteTugScene(onComplete: { score in self.markComplete(15, score: score, max: 5) })) },
            { AnyView(NaturalVsSyntheticSorterScene(onComplete: { self.markComplete(16) })) },
            { AnyView(FabricCareSymbolsQuizScene(onComplete: { score in self.markComplete(17, score: score, max: 4) })) },
            { AnyView(IndianTextileMapScene(onComplete: { self.markComplete(18) })) },
            { AnyView(Scene9_BossQuiz_Ch3(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline Scene 9: Sheep Breeds Atlas (tap-to-reveal)
private struct SheepBreedsAtlasScene: View {
    let onComplete: () -> Void
    @State private var selected: String? = nil

    private struct Breed: Identifiable {
        let id: String; let emoji: String; let name: String; let region: String; let known: String
    }
    private let breeds: [Breed] = [
        Breed(id: "lohi", emoji: "🐏", name: "Lohi", region: "Rajasthan / Punjab", known: "Soft carpet wool; tolerates extreme heat."),
        Breed(id: "rampur", emoji: "🐏", name: "Rampur-Bushair", region: "Himalayan foothills", known: "Brown medium-grade wool; thrives in cold."),
        Breed(id: "nali", emoji: "🐏", name: "Nali", region: "Rajasthan / Haryana", known: "White carpet-grade wool; calm temperament."),
        Breed(id: "bakharwal", emoji: "🐐", name: "Bakharwal", region: "Jammu & Kashmir", known: "Long under-coat wool for warm shawls."),
        Breed(id: "marwari", emoji: "🐏", name: "Marwari", region: "Western Rajasthan", known: "Coarse desert wool; very hardy.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Sheep Breeds of India")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Tap any breed to learn where it lives and what wool it gives.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                ForEach(breeds) { b in
                    Button { selected = b.id } label: {
                        HStack(spacing: DesignTokens.Spacing.md) {
                            Text(b.emoji).font(.title)
                            Text(b.name).font(.headline)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                            Spacer()
                            Text(b.region).font(.caption)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                        .padding(DesignTokens.Spacing.md)
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(selected == b.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(selected == b.id ? Color.compatIndigo.opacity(0.45) : Color.gray.opacity(0.18), lineWidth: 1))
                    }
                    .buttonStyle(.plain).pointingCursor()
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                }
                if let sel = selected, let b = breeds.first(where: { $0.id == sel }) {
                    Text(b.known).font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                }
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Inline Scene 10: Wool Quality Grader (slider)
private struct WoolQualityGraderScene: View {
    let onComplete: () -> Void
    @State private var coarseness: Double = 0.4  // 0=fine, 1=coarse

    private var grade: String {
        if coarseness < 0.25 { return "Merino-fine — for soft sweaters next to skin." }
        if coarseness < 0.55 { return "Medium — most common, for jackets and blankets." }
        if coarseness < 0.85 { return "Carpet-grade — durable but scratchy, for rugs." }
        return "Hair — too coarse to spin; used for ropes and stuffing."
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Wool Quality Grader")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Wool isn't one thing — fineness ranges from baby-soft Merino to scratchy carpet wool.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                ZStack {
                    RoundedRectangle(cornerRadius: 16).fill(Color.compatBrown.opacity(0.15))
                        .frame(width: 220, height: 80)
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        let strandW: CGFloat = CGFloat(2 + coarseness * 6)
                        ForEach(0..<20, id: \.self) { _ in
                            Capsule().fill(Color.compatBrown.opacity(0.6))
                                .frame(width: strandW, height: 50)
                        }
                    }
                }
                Text("Coarseness").font(.caption.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                Slider(value: $coarseness, in: 0...1).frame(maxWidth: 340).padding(.horizontal, DesignTokens.Spacing.xl)
                Text(grade).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl).frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Inline Scene 11: Carding & Spinning Lab (stage stepper)
private struct CardingSpinningLabScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0

    private let stages = [
        ("🐑", "Raw fleece — tangled, dirty, full of plant bits."),
        ("🧼", "Scour: wash in warm soapy water to remove grease."),
        ("🪮", "Card: pull the clean fibres straight with combs."),
        ("🧵", "Spin: twist parallel fibres into a strong yarn.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("From Fleece to Yarn")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text(stages[stage].0).font(.system(size: 100))
                Text(stages[stage].1).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl).frame(maxWidth: DesignTokens.contentMaxWidth)
                Button {
                    withAnimationRespectingReduceMotion(.easeInOut(duration: 0.25)) {
                        stage = (stage + 1) % stages.count
                    }
                } label: {
                    Text("Next stage").font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Inline Scene 12: Dye Vat — Tap to Mix (toggle reveal)
private struct DyeVatMixScene: View {
    let onComplete: () -> Void
    @State private var dyed: Bool = false
    @State private var color: Int = 0
    private let colors: [Color] = [
        DesignTokens.BrandColor.danger,
        DesignTokens.BrandColor.mnemonicAccent,
        DesignTokens.BrandColor.primaryAction,
        Color.compatIndigo
    ]
    private let names = ["Madder red", "Turmeric yellow", "Indigo blue → mixed for green", "Pure indigo"]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Dye Vat — Pick a Plant Source")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Indian textiles use natural dyes from madder root, turmeric, and indigo plant. Tap to dip white yarn in each vat.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                HStack(spacing: 14) {
                    ForEach(0..<colors.count, id: \.self) { i in
                        Button { withAnimation { color = i; dyed = true } } label: {
                            Circle().fill(colors[i])
                                .frame(width: 52, height: 52)
                                .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
                                .overlay(Circle().strokeBorder(
                                    color == i ? Color.compatIndigo : .clear, lineWidth: 3))
                        }
                        .buttonStyle(.plain).pointingCursor()
                    }
                }
                yarnVisual.frame(width: 220, height: 80)
                if dyed {
                    Text(names[color]).font(.callout.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                }
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var yarnVisual: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { i in
                let yarnX: CGFloat = CGFloat(i - 6) * 16
                Capsule().fill(dyed ? colors[color] : Color.gray.opacity(0.15))
                    .frame(width: 14, height: 60)
                    .offset(x: yarnX)
            }
        }
    }
}

// MARK: - Inline Scene 13: Looms Through Time (comparison)
private struct LoomsThroughTimeScene: View {
    let onComplete: () -> Void

    private struct Loom: Identifiable {
        let id: String; let emoji: String; let era: String; let detail: String
    }
    private let looms: [Loom] = [
        Loom(id: "back", emoji: "🪡", era: "Ancient (~5000 BCE)",
             detail: "Backstrap loom — tied to the weaver's waist. Used everywhere from Mesopotamia to Andes."),
        Loom(id: "pit", emoji: "⛲️", era: "Medieval India",
             detail: "Pit loom — weaver sits with legs in a pit; one of the most efficient handlooms even today."),
        Loom(id: "frame", emoji: "🪟", era: "European 1500s",
             detail: "Horizontal frame loom — bigger fabrics, faster pedalling."),
        Loom(id: "power", emoji: "🏭", era: "Industrial 1785+",
             detail: "Power loom — Cartwright's invention; one mill could replace 100 hand weavers.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Looms Through Time")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ForEach(looms) { l in
                    HStack(spacing: 14) {
                        Text(l.emoji).font(.system(size: 48))
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                            Text(l.era).font(.headline)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                            Text(l.detail).font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(DesignTokens.Spacing.md)
                    .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                }
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Inline Scene 14: Sericulture Calendar (week slider)
private struct SericultureCalendarScene: View {
    let onComplete: () -> Void
    @State private var week: Double = 0

    private var phase: String {
        if week < 1 { return "Week 0: Eggs hatch into tiny silkworm larvae." }
        if week < 4 { return "Weeks 1-3: Larvae eat mulberry leaves 24×7 — grow 10,000× in size." }
        if week < 5 { return "Week 4: Each spins a cocoon around itself (1 km of silk thread)." }
        if week < 7 { return "Weeks 5-6: Inside the cocoon, larva turns into pupa, then moth." }
        return "Week 7+: For silk, farmers boil cocoons before moth emerges, to preserve the thread."
    }
    private var emoji: String {
        if week < 1 { return "🥚" }; if week < 4 { return "🐛" }
        if week < 5 { return "🥥" }; if week < 7 { return "🦋" }
        return "🧵"
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Sericulture Calendar")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text(emoji).font(.system(size: 100))
                Text("Week \(Int(week))").font(.headline.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Slider(value: $week, in: 0...8).frame(maxWidth: 340).padding(.horizontal, DesignTokens.Spacing.xl)
                Text(phase).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl).frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Inline Scene 15: Mulberry vs Tasar Silk (toggle compare)
private struct MulberryVsTasarScene: View {
    let onComplete: () -> Void
    @State private var pickMulberry: Bool = true

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Mulberry vs Tasar Silk")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                HStack(spacing: 14) {
                    Button { pickMulberry = true } label: {
                        Text("Mulberry").font(.body.weight(pickMulberry ? .bold : .regular))
                            .padding(.horizontal, 18).padding(.vertical, 9)
                            .background(Capsule().fill(pickMulberry ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                            .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                            .foregroundColor(Color.compatIndigo)
                    }.buttonStyle(.plain).pointingCursor()
                    Button { pickMulberry = false } label: {
                        Text("Tasar").font(.body.weight(!pickMulberry ? .bold : .regular))
                            .padding(.horizontal, 18).padding(.vertical, 9)
                            .background(Capsule().fill(!pickMulberry ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                            .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                            .foregroundColor(Color.compatIndigo)
                    }.buttonStyle(.plain).pointingCursor()
                }
                let detail: String = pickMulberry
                    ? "Mulberry silk: from the Bombyx mori moth, fed only mulberry leaves. White-to-cream sheen, smooth. ~70% of world silk. Karnataka, Andhra, Tamil Nadu lead Indian production."
                    : "Tasar silk: from wild Antheraea moths feeding on Sal, Arjun, or Oak leaves. Coppery, coarser, and stronger. Jharkhand, Chhattisgarh, Odisha are major producers."
                Text(detail).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.leading)
                    .padding(14)
                    .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Inline Scene 16: Cotton vs Jute Tug (quiz)
private struct CottonVsJuteTugScene: View {
    let onComplete: (Int) -> Void

    private struct Q: Identifiable { let id: String; let prompt: String; let correctCotton: Bool }
    private let questions: [Q] = [
        Q(id: "q1", prompt: "Sewn into shirts and bedsheets — soft against skin", correctCotton: true),
        Q(id: "q2", prompt: "Used to make rough sacks for grain and potatoes", correctCotton: false),
        Q(id: "q3", prompt: "Grows best in black soil of Maharashtra and Gujarat", correctCotton: true),
        Q(id: "q4", prompt: "Major crop of West Bengal — grown in wet, hot climate", correctCotton: false),
        Q(id: "q5", prompt: "Bolls open on the plant to reveal white fluff", correctCotton: true)
    ]
    @State private var answers: [String: Bool] = [:]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Cotton or Jute?")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("For each clue, pick the right fibre.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                ForEach(questions) { q in qRow(q) }
                if answers.count == questions.count {
                    let score = questions.reduce(0) { $0 + ((answers[$1.id] == $1.correctCotton) ? 1 : 0) }
                    Text("Score: \(score) / \(questions.count)")
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    GotItButton(action: { onComplete(score) }).padding(.bottom, DesignTokens.Spacing.md)
                } else {
                    GotItButton(action: { onComplete(0) }).padding(.bottom, DesignTokens.Spacing.md)
                }
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    @ViewBuilder
    private func qRow(_ q: Q) -> some View {
        let picked = answers[q.id]
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text(q.prompt).font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: DesignTokens.Spacing.sm) {
                ansButton(label: "Cotton", value: true, picked: picked, correct: q.correctCotton, id: q.id)
                ansButton(label: "Jute", value: false, picked: picked, correct: q.correctCotton, id: q.id)
            }
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, DesignTokens.Spacing.xl)
    }

    private func ansButton(label: String, value: Bool, picked: Bool?, correct: Bool, id: String) -> some View {
        let isPicked = picked == value
        let tint: Color = picked == nil
            ? Color.compatIndigo
            : (isPicked ? (value == correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger) : Color.gray)
        return Button {
            if answers[id] == nil { answers[id] = value }
        } label: {
            Text(label).font(.caption.weight(.semibold))
                .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 6)
                .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                .foregroundColor(tint)
        }
        .buttonStyle(.plain).pointingCursor().disabled(picked != nil)
    }
}

// MARK: - Inline Scene 17: Natural vs Synthetic Sorter (tap-to-assign)
private struct NaturalVsSyntheticSorterScene: View {
    let onComplete: () -> Void

    private struct Fibre: Identifiable {
        let id: String; let name: String; let isNatural: Bool
    }
    private let fibres: [Fibre] = [
        Fibre(id: "cotton", name: "Cotton", isNatural: true),
        Fibre(id: "wool", name: "Wool", isNatural: true),
        Fibre(id: "silk", name: "Silk", isNatural: true),
        Fibre(id: "jute", name: "Jute", isNatural: true),
        Fibre(id: "polyester", name: "Polyester", isNatural: false),
        Fibre(id: "nylon", name: "Nylon", isNatural: false),
        Fibre(id: "acrylic", name: "Acrylic", isNatural: false),
        Fibre(id: "rayon", name: "Rayon", isNatural: false)
    ]
    @State private var assignment: [String: Bool] = [:]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Natural or Synthetic?")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap each chip — Natural (from plants/animals) or Synthetic (made in factories).")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                ForEach(fibres) { f in row(f) }
                if assignment.count == fibres.count {
                    let correct = fibres.reduce(0) { $0 + ((assignment[$1.id] == $1.isNatural) ? 1 : 0) }
                    Text("Sorted \(correct) / \(fibres.count) correctly.")
                        .font(.headline)
                        .foregroundColor(correct == fibres.count
                                         ? DesignTokens.BrandColor.primaryAction
                                         : DesignTokens.BrandColor.canvasText)
                }
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    @ViewBuilder
    private func row(_ f: Fibre) -> some View {
        let pick = assignment[f.id]
        HStack(spacing: 10) {
            Text(f.name).font(.callout.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Spacer(minLength: 8)
            ForEach([true, false], id: \.self) { val in
                let isPicked = pick == val
                let tint: Color = pick == nil
                    ? Color.compatIndigo
                    : (isPicked ? (val == f.isNatural ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger) : Color.gray)
                Button {
                    if assignment[f.id] == nil { assignment[f.id] = val }
                } label: {
                    Text(val ? "Natural" : "Synthetic")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                        .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                        .foregroundColor(tint)
                }
                .buttonStyle(.plain).pointingCursor().disabled(pick != nil)
            }
        }
        .padding(.horizontal, 14).padding(.vertical, DesignTokens.Spacing.sm)
        .frame(maxWidth: DesignTokens.contentMaxWidth)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, DesignTokens.Spacing.xl)
    }
}

