import SwiftUI

struct DiscoverChapter2View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(2)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "The Mouth Lab",
        "The Swallow Wave",
        "The Stomach Bath",
        "The Intestine Villus Tour",
        "Liver, Pancreas & Bile",
        "The Four-Stomach Cow Tour",
        "Amoeba Pseudopod Hunt",
        "Taste & Flavour",
        "Three Jaws Compared",
        "Teeth Types Sorter",
        "Saliva Lab",
        "Cardiac Sphincter & Reflux",
        "Stomach pH Slider",
        "Bile Emulsifies Fat",
        "Villi Surface-Area Zoom",
        "Rumination Cycle",
        "Cow vs Goat vs Camel",
        "Food Vacuole Formation",
        "Pseudopod Catch",
        "Window in the Stomach",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 2 — Nutrition in Animals",
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
    /// Lookup-table dispatcher — see DiscoverChapter1View.swift for the
    /// rationale. Big switch in @ViewBuilder + 20+ cases blew compile
    /// time from ~5s to ~210s; AnyView lookup table fixes it.
    private func sceneBody(_ index: Int) -> AnyView {
        guard index >= 0 && index < sceneBuilders.count else {
            return AnyView(EmptyView())
        }
        return sceneBuilders[index]()
    }

    private var sceneBuilders: [() -> AnyView] {
        [
            { AnyView(Scene1_TheMouthLab(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_TheSwallowWave(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_TheStomachBath(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_IntestineVillus(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_LiverPancreasBile(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_FourStomachsOfACow(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_AmoebaPseudopodHunt(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_TasteAndFlavour(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(ThreeJawsComparedScene(onComplete: { self.markComplete(8) })) },
            { AnyView(TeethTypesSorterScene(onComplete: { self.markComplete(9) })) },
            { AnyView(SalivaLabScene(onComplete: { self.markComplete(10) })) },
            { AnyView(CardiacSphincterScene(onComplete: { self.markComplete(11) })) },
            { AnyView(StomachPHSliderScene(onComplete: { self.markComplete(12) })) },
            { AnyView(BileEmulsifiesFatScene(onComplete: { self.markComplete(13) })) },
            { AnyView(VilliSurfaceAreaScene(onComplete: { self.markComplete(14) })) },
            { AnyView(RuminationCycleScene(onComplete: { self.markComplete(15) })) },
            { AnyView(CowGoatCamelScene(onComplete: { self.markComplete(16) })) },
            { AnyView(FoodVacuoleFormationScene(onComplete: { self.markComplete(17) })) },
            { AnyView(PseudopodCatchScene(onComplete: { score in self.markComplete(18, score: score, max: 5) })) },
            { AnyView(WindowInTheStomachScene(onComplete: { self.markComplete(19) })) },
            { AnyView(Scene9_BossQuiz_Ch2(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(20, score: score, max: 15) })) }
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

// MARK: - Inline Scene 9: Three Jaws Compared (Topic 1 bridge)
private struct ThreeJawsComparedScene: View {
    let onComplete: () -> Void
    @State private var selected: String? = nil

    private struct Jaw: Identifiable {
        let id: String; let emoji: String; let name: String; let teeth: String; let diet: String
    }
    private let jaws: [Jaw] = [
        Jaw(id: "tiger", emoji: "🐅", name: "Tiger (carnivore)",
            teeth: "Long sharp canines + scissor-like premolars",
            diet: "Pure meat — tearing and slicing, almost no grinding."),
        Jaw(id: "cow", emoji: "🐄", name: "Cow (herbivore)",
            teeth: "Flat broad molars + no upper incisors",
            diet: "Grass + leaves — grinds endlessly to break plant cell walls."),
        Jaw(id: "human", emoji: "🧑", name: "Human (omnivore)",
            teeth: "Small canines + flat molars + sharp incisors",
            diet: "Mixed — bit of cutting, bit of grinding. Generalist.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Three Jaws, Three Diets")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Tap a head to inspect its teeth and what they tell you about its diet.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                HStack(spacing: 14) {
                    ForEach(jaws) { j in
                        Button { selected = j.id } label: {
                            VStack {
                                Text(j.emoji).font(.system(size: 64))
                                Text(j.name).font(.caption.weight(.semibold))
                                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                            }
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .fill(selected == j.id
                                      ? Color.compatIndigo.opacity(0.15)
                                      : Color.white.opacity(0.85)))
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(selected == j.id
                                              ? Color.compatIndigo.opacity(0.45)
                                              : Color.gray.opacity(0.18), lineWidth: 1))
                        }
                        .buttonStyle(.plain).pointingCursor()
                    }
                }
                if let sel = selected, let j = jaws.first(where: { $0.id == sel }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Teeth: \(j.teeth)").font(.callout)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Text("Diet: \(j.diet)").font(.callout)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                    }
                    .padding(14)
                    .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                    .padding(.horizontal, 24)
                }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 10: Teeth Types Sorter (Topic 1)
private struct TeethTypesSorterScene: View {
    let onComplete: () -> Void

    private enum Kind: String, CaseIterable {
        case incisor = "Incisor"
        case canine = "Canine"
        case premolar = "Premolar"
        case molar = "Molar"
    }
    private struct Job: Identifiable {
        let id: String; let label: String; let correct: Kind
    }
    private let jobs: [Job] = [
        Job(id: "j1", label: "Cuts an apple in half", correct: .incisor),
        Job(id: "j2", label: "Tears a piece of meat", correct: .canine),
        Job(id: "j3", label: "Crushes a peanut", correct: .premolar),
        Job(id: "j4", label: "Grinds rice into paste", correct: .molar)
    ]
    @State private var assignment: [String: Kind] = [:]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Which Tooth Does the Job?")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Match each chewing job to the tooth that handles it.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                ForEach(jobs) { j in jobRow(j) }
                if assignment.count == jobs.count {
                    let correct = jobs.reduce(0) { $0 + ((assignment[$1.id] == $1.correct) ? 1 : 0) }
                    Text("Score: \(correct) / \(jobs.count)")
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    @ViewBuilder
    private func jobRow(_ j: Job) -> some View {
        let picked = assignment[j.id]
        VStack(alignment: .leading, spacing: 8) {
            Text(j.label).font(.body)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            HStack(spacing: 6) {
                ForEach(Kind.allCases, id: \.self) { k in
                    let isPicked = picked == k
                    let tint: Color = picked == nil
                        ? Color.compatIndigo
                        : (isPicked
                           ? (k == j.correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger)
                           : Color.gray)
                    Button {
                        if assignment[j.id] == nil { assignment[j.id] = k }
                    } label: {
                        Text(k.rawValue)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                            .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                            .foregroundColor(tint)
                    }
                    .buttonStyle(.plain).pointingCursor().disabled(picked != nil)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, 24)
    }
}

// MARK: - Inline Scene 11: Saliva Lab (Topic 1)
private struct SalivaLabScene: View {
    let onComplete: () -> Void
    @State private var time: Double = 0  // seconds of chewing

    /// Starch breaks down with time. Sugar fraction starts at 0, plateaus near 1.
    private var sugar: Double { min(1.0, time / 30.0) }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Saliva Turns Starch into Sugar")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Chew a piece of bread for 30 seconds and it starts tasting sweet — that's salivary amylase at work.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                breadVisual.frame(width: 220, height: 100)
                Slider(value: $time, in: 0...30)
                    .frame(maxWidth: 340).padding(.horizontal, 24)
                Text("Chewed for \(Int(time))s — \(Int(sugar * 100))% sugar")
                    .font(.callout.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var breadVisual: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.compatBrown.opacity(0.5 + 0.4 * sugar))
                .frame(width: 200, height: 80)
            ForEach(0..<8, id: \.self) { i in
                Circle().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(sugar))
                    .frame(width: 10, height: 10)
                    .offset(x: CGFloat(i - 4) * 22, y: Double(i).truncatingRemainder(dividingBy: 2) == 0 ? -10 : 10)
            }
        }
    }
}

// MARK: - Inline Scene 12: Cardiac Sphincter & Reflux (Topic 1)
private struct CardiacSphincterScene: View {
    let onComplete: () -> Void
    @State private var open: Bool = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Cardiac Sphincter — The One-Way Gate")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Where the food-pipe meets the stomach, a muscular ring lets food in and (usually) keeps acid from coming back up. Reflux happens when that gate weakens.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                gateVisual.frame(width: 220, height: 200)
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) { open.toggle() }
                } label: {
                    Text(open ? "Close the gate" : "Open the gate")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                Text(open
                     ? "Open: a food bolus slides into the stomach — and if the gate is weak, stomach acid can splash back up the food-pipe (heartburn)."
                     : "Closed: the ring stays tight to keep acid below.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var gateVisual: some View {
        ZStack {
            // Tube
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                .frame(width: 70, height: 200)
            // Ring (sphincter)
            HStack(spacing: open ? 28 : 4) {
                Capsule().fill(DesignTokens.BrandColor.danger).frame(width: 18, height: 50)
                Capsule().fill(DesignTokens.BrandColor.danger).frame(width: 18, height: 50)
            }
            if open {
                Circle().fill(DesignTokens.BrandColor.primaryAction).frame(width: 26, height: 26).offset(y: 60)
            }
        }
    }
}

// MARK: - Inline Scene 13: Stomach pH Slider (Topic 1)
private struct StomachPHSliderScene: View {
    let onComplete: () -> Void
    @State private var ph: Double = 7

    private var phLabel: String {
        if ph < 2 { return "Very acidic — kills swallowed germs, activates pepsin." }
        if ph < 5 { return "Mildly acidic — like vinegar or coffee." }
        if ph < 8 { return "Neutral-ish — like water or saliva." }
        if ph < 11 { return "Mildly basic — like soap or baking soda." }
        return "Very basic — like drain cleaner. Stomach NEVER reaches here."
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Stomach pH Slider")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Healthy stomach acid is around pH 1.5 — strong enough to dissolve a steel nail. The stomach lining survives by making thick mucus every minute.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                phMeter.frame(width: 260, height: 60)
                Slider(value: $ph, in: 0...14)
                    .frame(maxWidth: 340).padding(.horizontal, 24)
                Text("pH \(String(format: "%.1f", ph))").font(.title3.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text(phLabel).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24).frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var phMeter: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                    colors: [DesignTokens.BrandColor.danger,
                             DesignTokens.BrandColor.mnemonicAccent,
                             DesignTokens.BrandColor.primaryAction,
                             Color.compatIndigo],
                    startPoint: .leading, endPoint: .trailing))
                .frame(height: 30)
            Circle().fill(Color.white)
                .frame(width: 22, height: 22)
                .overlay(Circle().strokeBorder(Color.gray, lineWidth: 1.5))
                .offset(x: CGFloat(ph / 14) * 238 + 4)
        }
        .frame(width: 260)
    }
}

// MARK: - Inline Scene 14: Bile Emulsifies Fat (Topic 1)
private struct BileEmulsifiesFatScene: View {
    let onComplete: () -> Void
    @State private var emulsified: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Bile Breaks Fat into Tiny Drops")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Fat won't mix with water. Bile (made by the liver) acts like dish soap — it breaks one big fat blob into thousands of tiny droplets so enzymes can reach them.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                emulsionVisual.frame(width: 260, height: 200)
                Button {
                    let a = reduceMotion ? Animation.linear(duration: 0.0) : .easeInOut(duration: 0.5)
                    withAnimation(a) { emulsified.toggle() }
                } label: {
                    Text(emulsified ? "Reset" : "Add bile")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.mnemonicAccent.opacity(0.5), lineWidth: 1))
                        .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
                }
                .buttonStyle(.plain).pointingCursor()
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var emulsionVisual: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.12))
            if emulsified {
                ForEach(0..<24, id: \.self) { i in
                    Circle().fill(DesignTokens.BrandColor.mnemonic.opacity(0.8))
                        .frame(width: 14, height: 14)
                        .offset(x: CGFloat((i % 6) - 3) * 32,
                                y: CGFloat((i / 6) - 1) * 40)
                }
            } else {
                Circle().fill(DesignTokens.BrandColor.mnemonic.opacity(0.85))
                    .frame(width: 110, height: 110)
            }
        }
    }
}

// MARK: - Inline Scene 15: Villi Surface-Area Zoom (Topic 1)
private struct VilliSurfaceAreaScene: View {
    let onComplete: () -> Void
    @State private var zoom: Int = 0  // 0 = flat tube, 1 = folds, 2 = villi, 3 = microvilli

    private let captions = [
        "A 6-metre intestine looks like a smooth tube — until you zoom in.",
        "1st zoom: the wall has wide folds, multiplying surface ×3.",
        "2nd zoom: every fold is covered in finger-like villi, ×30.",
        "3rd zoom: every villus has thousands of microvilli, ×600. Total surface ≈ a tennis court."
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Why the Small Intestine Is So Long")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                zoomVisual.frame(width: 280, height: 160)
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        zoom = zoom >= 3 ? 0 : zoom + 1
                    }
                } label: {
                    Text(zoom >= 3 ? "Reset" : "Zoom in")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                Text(captions[zoom])
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24).frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    @ViewBuilder
    private var zoomVisual: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14).fill(Color.pink.opacity(0.18))
                .frame(width: 280, height: 160)
            if zoom == 0 {
                Capsule().fill(Color.pink.opacity(0.45)).frame(width: 220, height: 30)
            } else if zoom == 1 {
                HStack(spacing: 6) {
                    ForEach(0..<5, id: \.self) { _ in
                        Capsule().fill(Color.pink.opacity(0.55)).frame(width: 30, height: 60)
                    }
                }
            } else if zoom == 2 {
                HStack(spacing: 3) {
                    ForEach(0..<14, id: \.self) { _ in
                        Capsule().fill(Color.pink.opacity(0.65)).frame(width: 10, height: 80)
                    }
                }
            } else {
                HStack(spacing: 1) {
                    ForEach(0..<40, id: \.self) { _ in
                        Capsule().fill(Color.pink.opacity(0.85)).frame(width: 3, height: 100)
                    }
                }
            }
        }
    }
}

// MARK: - Inline Scene 16: Rumination Cycle (Topic 2)
private struct RuminationCycleScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0

    private let stages = [
        ("🌿", "1. Cow swallows grass quickly into the rumen — first chamber."),
        ("🫧", "2. Bacteria + rumen churning soften the grass into 'cud'."),
        ("⬆️", "3. Cow brings cud back up to the mouth — chews thoroughly."),
        ("🍽", "4. Re-swallowed; passes through the next 3 chambers for true digestion.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("The Rumination Cycle")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text(stages[stage].0).font(.system(size: 90))
                Text(stages[stage].1).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24).frame(maxWidth: DesignTokens.contentMaxWidth)
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        stage = (stage + 1) % stages.count
                    }
                } label: {
                    Text("Next stage")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 17: Cow vs Goat vs Camel (Topic 2)
private struct CowGoatCamelScene: View {
    let onComplete: () -> Void

    private struct Animal: Identifiable {
        let id: String; let emoji: String; let name: String; let strategy: String
    }
    private let animals: [Animal] = [
        Animal(id: "cow", emoji: "🐄", name: "Cow",
               strategy: "Four-chambered stomach. Eats fast in the field, ruminates safely in the barn."),
        Animal(id: "goat", emoji: "🐐", name: "Goat",
               strategy: "Same four chambers but smaller. Eats almost anything — leaves, bark, even tin cans (not really nutritious!)."),
        Animal(id: "camel", emoji: "🐪", name: "Camel",
               strategy: "Three-chambered. Stores chewed food + water for days; can drink 100 L in one go.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Three Ruminant Strategies")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                ForEach(animals) { a in
                    HStack(spacing: 14) {
                        Text(a.emoji).font(.system(size: 50))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(a.name).font(.headline)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                            Text(a.strategy).font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                    .padding(.horizontal, 24)
                }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 18: Food Vacuole Formation (Topic 3)
private struct FoodVacuoleFormationScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0

    private let stages = [
        "1. Amoeba spots food. Cytoplasm starts to flow toward it.",
        "2. Two pseudopodia extend outward, wrapping around the food.",
        "3. The two arms meet on the far side — food trapped inside.",
        "4. The trapped pocket pinches off into a food vacuole — digestion begins."
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Amoeba: Food Vacuole Forms")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                amoebaVisual.frame(width: 220, height: 180)
                Text(stages[stage])
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24).frame(maxWidth: DesignTokens.contentMaxWidth)
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        stage = (stage + 1) % stages.count
                    }
                } label: {
                    Text(stage == stages.count - 1 ? "Replay" : "Next stage")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var amoebaVisual: some View {
        ZStack {
            Circle().fill(DesignTokens.BrandColor.relatedConcepts.opacity(0.35))
                .frame(width: 130, height: 130)
            if stage >= 1 {
                Capsule().fill(DesignTokens.BrandColor.relatedConcepts.opacity(0.35))
                    .frame(width: 40, height: 70)
                    .offset(x: 60 - CGFloat(stage * 10), y: -20)
                Capsule().fill(DesignTokens.BrandColor.relatedConcepts.opacity(0.35))
                    .frame(width: 40, height: 70)
                    .offset(x: 60 - CGFloat(stage * 10), y: 20)
            }
            // The food
            Circle().fill(DesignTokens.BrandColor.danger.opacity(0.8))
                .frame(width: 22, height: 22)
                .offset(x: stage >= 3 ? 0 : 80)
        }
    }
}

// MARK: - Inline Scene 19: Pseudopod Catch (Topic 3)
//
// Timing mini-game: bits of "food" drift past an amoeba. Tap "Grab" when
// food crosses the catch zone. 5 rounds, score what you caught.
private struct PseudopodCatchScene: View {
    let onComplete: (Int) -> Void
    @State private var round: Int = 0
    @State private var caught: Int = 0
    @State private var foodPosition: CGFloat = -120   // x offset
    @State private var roundActive: Bool = false

    private let totalRounds = 5

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Pseudopod Catch")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Tap Grab! the moment food drifts over the amoeba. Real amoebas have only one shot per meal — focus on timing.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                catchVisual.frame(width: 280, height: 140)
                HStack(spacing: 14) {
                    Button { startRound() } label: {
                        Text(round >= totalRounds ? "Replay" : "Release food")
                            .font(.body.weight(.semibold))
                            .padding(.horizontal, 16).padding(.vertical, 9)
                            .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                            .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                            .foregroundColor(Color.compatIndigo)
                    }
                    .buttonStyle(.plain).pointingCursor().disabled(roundActive)
                    Button { grab() } label: {
                        Text("Grab!")
                            .font(.body.weight(.bold))
                            .padding(.horizontal, 16).padding(.vertical, 9)
                            .background(Capsule().fill(DesignTokens.BrandColor.primaryAction.opacity(0.18)))
                            .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.primaryAction.opacity(0.5), lineWidth: 1))
                            .foregroundColor(DesignTokens.BrandColor.primaryAction)
                    }
                    .buttonStyle(.plain).pointingCursor().disabled(!roundActive)
                }
                Text("Caught: \(caught) / \(totalRounds) · Round: \(min(round + 1, totalRounds))")
                    .font(.callout.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                GotItButton(action: { onComplete(caught) }).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private var catchVisual: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14).fill(Color.gray.opacity(0.08))
                .frame(width: 280, height: 140)
            Circle().fill(DesignTokens.BrandColor.relatedConcepts.opacity(0.35))
                .frame(width: 80, height: 80)
            if roundActive {
                Circle().fill(DesignTokens.BrandColor.danger.opacity(0.9))
                    .frame(width: 22, height: 22)
                    .offset(x: foodPosition)
            }
            // catch zone hint
            Rectangle().strokeBorder(DesignTokens.BrandColor.primaryAction.opacity(0.35), lineWidth: 1)
                .frame(width: 50, height: 100)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func startRound() {
        if round >= totalRounds { round = 0; caught = 0 }
        roundActive = true
        foodPosition = -120
        Task { @MainActor in
            // Animate food across 280pt in ~1.8s
            withAnimation(.linear(duration: 1.8)) { foodPosition = 120 }
            try? await Task.sleep(nanoseconds: 1_800_000_000)
            if roundActive {
                roundActive = false
                round += 1
            }
        }
    }

    private func grab() {
        // Catch window: |x| < 25 counts as in the catch zone
        if abs(foodPosition) < 25 { caught += 1 }
        roundActive = false
        round += 1
    }
}

// MARK: - Window in the Stomach (inline Scene 20)
//
// True story enrichment beyond NCERT: in 1822 a fur trader named Alexis
// St Martin was shot in the side. The wound healed but a small hole into
// his stomach refused to close — about the size of a 5-rupee coin. His
// doctor, William Beaumont, dropped food on a string through the hole
// and pulled it back out at intervals to time digestion. That gruesome
// study is where the world's first digestion timetable came from.
//
// Interaction: kid taps food items, sees how long Beaumont measured
// each one to digest. A short "What we owe him" reveal after all five
// foods have been tried. Big Sur compatible.
private struct WindowInTheStomachScene: View {
    let onComplete: () -> Void

    private struct FoodTiming: Identifiable {
        let id: String
        let emoji: String
        let name: String
        let minutes: Int
        let why: String
    }

    private let foods: [FoodTiming] = [
        FoodTiming(id: "apple",   emoji: "🍎", name: "Raw apple cubes",     minutes: 90,
                   why: "Soft fruits digest fast — sugars and water are easy work."),
        FoodTiming(id: "cabbage", emoji: "🥬", name: "Boiled cabbage",      minutes: 150,
                   why: "Cooked vegetables sit in the stomach a bit longer. Fibre slows things down."),
        FoodTiming(id: "beef",    emoji: "🥩", name: "Roast beef",          minutes: 210,
                   why: "Protein and fat take more time. Acid and enzymes attack them slowly."),
        FoodTiming(id: "potato",  emoji: "🍟", name: "Fried potatoes",      minutes: 270,
                   why: "Fat from frying coats the food, blocking acid. Worst offender on Beaumont's list."),
        FoodTiming(id: "milk",    emoji: "🥛", name: "Raw cow's milk",      minutes: 135,
                   why: "Milk fat slows digestion a little; sugars and proteins do the rest of the work."),
    ]

    @State private var revealed: Set<String> = []
    @State private var finishedShown: Bool = false

    private var allRevealed: Bool { revealed.count == foods.count }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Window in the Stomach")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)

                Text("In 1822 a fur trader called Alexis St Martin was shot in the side. The wound healed, but the hole into his stomach never closed. His doctor, William Beaumont, used that tiny opening to time how long different foods take to digest. Tap each food to see what Beaumont measured.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: 600)

                VStack(spacing: 10) {
                    ForEach(foods) { food in
                        WindowFoodCard(emoji: food.emoji,
                                       name: food.name,
                                       minutes: food.minutes,
                                       why: food.why,
                                       revealed: revealed.contains(food.id)) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                _ = revealed.insert(food.id)
                            }
                        }
                    }
                }
                .frame(maxWidth: 560)

                if allRevealed {
                    SoftShadowCard(padding: 14) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What the world owes one tiny hole")
                                .font(.headline)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                            Text("Beaumont published his digestion times in 1833. They became the foundation of modern gastric physiology. Alexis St Martin lived to 86 — outliving Beaumont by 27 years — and is buried in a quiet cemetery in Quebec. One messy accident and one curious doctor gave us the first real timetable of how the human stomach works.")
                                .font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .frame(maxWidth: 600)

                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}

private struct WindowFoodCard: View {
    let emoji: String
    let name: String
    let minutes: Int
    let why: String
    let revealed: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(emoji).font(.system(size: 28))
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    if revealed {
                        Text(formatMinutes(minutes))
                            .font(.subheadline.bold())
                            .foregroundColor(Color.compatIndigo)
                        Text(why)
                            .font(.caption)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("Tap to see digestion time")
                            .font(.caption)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                }
                Spacer()
                Image(systemName: revealed ? "checkmark.circle.fill" : "questionmark.circle")
                    .font(.title3)
                    .foregroundColor(revealed ? .green : DesignTokens.BrandColor.canvasTextSecondary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(revealed ? Color.compatIndigo.opacity(0.45) : Color.gray.opacity(0.20),
                                  lineWidth: 1.3)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(revealed)
    }

    private func formatMinutes(_ m: Int) -> String {
        let h = m / 60
        let r = m % 60
        if h == 0 { return "\(r) min" }
        if r == 0 { return "\(h) h" }
        return "\(h) h \(r) min"
    }
}
