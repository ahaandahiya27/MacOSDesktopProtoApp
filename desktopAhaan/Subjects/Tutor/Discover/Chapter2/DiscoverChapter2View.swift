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
                try? await Task.sleep(nanoseconds: DiscoverTiming.settleDelayNs)
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
                            .padding(DesignTokens.Spacing.md)
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
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Text("Teeth: \(j.teeth)").font(.callout)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Text("Diet: \(j.diet)").font(.callout)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                    }
                    .padding(14)
                    .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                }
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
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
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    @ViewBuilder
    private func jobRow(_ j: Job) -> some View {
        let picked = assignment[j.id]
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
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
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, DesignTokens.Spacing.xl)
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
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                breadVisual.frame(width: 220, height: 100)
                Slider(value: $time, in: 0...30)
                    .frame(maxWidth: 340).padding(.horizontal, DesignTokens.Spacing.xl)
                Text("Chewed for \(Int(time))s — \(Int(sugar * 100))% sugar")
                    .font(.callout.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var breadVisual: some View {
        let breadAlpha: Double = 0.5 + 0.4 * sugar
        return ZStack {
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(Color.compatBrown.opacity(breadAlpha))
                .frame(width: 200, height: 80)
            ForEach(0..<8, id: \.self) { i in
                let crumbX: CGFloat = CGFloat(i - 4) * 22
                let crumbY: CGFloat = Double(i).truncatingRemainder(dividingBy: 2) == 0 ? -10 : 10
                Circle().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(sugar))
                    .frame(width: 10, height: 10)
                    .offset(x: crumbX, y: crumbY)
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
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                gateVisual.frame(width: 220, height: 200)
                Button {
                    withAnimationRespectingReduceMotion(.easeInOut(duration: 0.25)) { open.toggle() }
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
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var gateVisual: some View {
        ZStack {
            // Tube
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
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
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                phMeter.frame(width: 260, height: 60)
                Slider(value: $ph, in: 0...14)
                    .frame(maxWidth: 340).padding(.horizontal, DesignTokens.Spacing.xl)
                Text("pH \(String(format: "%.1f", ph))").font(.title3.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text(phLabel).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl).frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var phMeter: some View {
        let knobX: CGFloat = CGFloat(ph / 14) * 238 + 4
        return ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
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
                .offset(x: knobX)
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
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                emulsionVisual.frame(width: 260, height: 200)
                Button {
                    let a = reduceMotion ? Animation.linear(duration: 0.0) : .easeInOut(duration: 0.5)
                    withAnimationRespectingReduceMotion(a) { emulsified.toggle() }
                } label: {
                    Text(emulsified ? "Reset" : "Add bile")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.mnemonicAccent.opacity(0.5), lineWidth: 1))
                        .foregroundColor(DesignTokens.BrandColor.mnemonicAccent)
                }
                .buttonStyle(.plain).pointingCursor()
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var emulsionVisual: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.12))
            if emulsified {
                ForEach(0..<24, id: \.self) { i in
                    let dropX: CGFloat = CGFloat((i % 6) - 3) * 32
                    let dropY: CGFloat = CGFloat((i / 6) - 1) * 40
                    Circle().fill(DesignTokens.BrandColor.mnemonic.opacity(0.8))
                        .frame(width: 14, height: 14)
                        .offset(x: dropX,
                                y: dropY)
                }
            } else {
                Circle().fill(DesignTokens.BrandColor.mnemonic.opacity(0.85))
                    .frame(width: 110, height: 110)
            }
        }
    }
}

// VilliSurfaceAreaScene + RuminationCycleScene live in
// DiscoverChapter2View+InlineScenesC.swift — lifted to keep this file under
// the 600-LOC Big Sur type-checker ceiling (sibling of +InlineScenesB.swift).
