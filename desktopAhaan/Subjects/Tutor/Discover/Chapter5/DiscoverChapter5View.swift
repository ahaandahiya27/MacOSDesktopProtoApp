import SwiftUI

struct DiscoverChapter5View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(5)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Sour or Bitter?",
        "Build Your pH Strip",
        "Three Indicator Tests",
        "Neutralisation in Action",
        "Ant Sting First Aid",
        "Acid or Base Sorting Lab",
        "Soil pH and the Farmer",
        "Acid Rain Story",
        "pH Ladder Slider",
        "Household Substance Sorter",
        "Litmus Paper Test",
        "Olfactory & Universal Indicator",
        "Cabbage Juice Magic",
        "Salt Formation Steps",
        "Common Salt Story",
        "Antacid Inside Your Stomach",
        "Toothpaste & Tooth Decay",
        "Strong vs Weak Acid",
        "Acid Rain Survivor Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 5 — Acids, Bases and Salts",
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
            { AnyView(Scene1_SourOrBitter(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_BuildYourpHStrip(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_ThreeIndicatorTests(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_NeutralisationInAction(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_AntStingFirstAid(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_AcidOrBaseSortingLab(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(5, score: score, max: 12) })) },
            { AnyView(Scene7_SoilpHAndFarmer(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_AcidRainStory(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(PHLadderSliderScene(onComplete: { self.markComplete(8) })) },
            { AnyView(HouseholdAcidBaseSorterScene(onComplete: { self.markComplete(9) })) },
            { AnyView(LitmusPaperTestScene(onComplete: { self.markComplete(10) })) },
            { AnyView(UniversalIndicatorScene(onComplete: { self.markComplete(11) })) },
            { AnyView(CabbageJuiceMagicScene(onComplete: { self.markComplete(12) })) },
            { AnyView(SaltFormationStepsScene(onComplete: { self.markComplete(13) })) },
            { AnyView(CommonSaltStoryScene(onComplete: { self.markComplete(14) })) },
            { AnyView(AntacidStomachScene(onComplete: { self.markComplete(15) })) },
            { AnyView(ToothDecayScene(onComplete: { self.markComplete(16) })) },
            { AnyView(StrongVsWeakAcidScene(onComplete: { self.markComplete(17) })) },
            { AnyView(AcidRainQuizScene(onComplete: { score in self.markComplete(18, score: score, max: 4) })) },
            { AnyView(Scene9_BossQuiz_Ch5(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline Scene 9: pH Ladder Slider
private struct PHLadderSliderScene: View {
    let onComplete: () -> Void
    @State private var ph: Double = 7
    private var label: String {
        if ph < 3 { return "Strong acid — battery acid, lemon juice." }
        if ph < 6 { return "Mild acid — vinegar, tea, tomato." }
        if ph < 8 { return "Neutral — pure water, blood, milk." }
        if ph < 11 { return "Mild base — baking soda, sea water." }
        return "Strong base — drain cleaner, lye."
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("The pH Ladder").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(
                            colors: [DesignTokens.BrandColor.danger,
                                     DesignTokens.BrandColor.mnemonicAccent,
                                     DesignTokens.BrandColor.primaryAction,
                                     Color.compatIndigo,
                                     Color.purple],
                            startPoint: .leading, endPoint: .trailing))
                        .frame(height: 30)
                    Circle().fill(Color.white).frame(width: 22, height: 22)
                        .overlay(Circle().strokeBorder(Color.gray, lineWidth: 1.5))
                        .offset(x: CGFloat(ph / 14) * 240 + 4)
                }
                .frame(width: 260)
                Text("pH \(String(format: "%.1f", ph))").font(.title2.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Slider(value: $ph, in: 0...14).frame(maxWidth: 340).padding(.horizontal, 24)
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

// MARK: - Inline Scene 10: Household Sorter (tap-to-assign)
private struct HouseholdAcidBaseSorterScene: View {
    let onComplete: () -> Void

    private enum Bucket: String, CaseIterable {
        case acid = "Acid"; case neutral = "Neutral"; case base = "Base"
    }
    private struct Item: Identifiable { let id: String; let name: String; let correct: Bucket }
    private let items: [Item] = [
        Item(id: "lemon", name: "Lemon juice", correct: .acid),
        Item(id: "soap", name: "Soap solution", correct: .base),
        Item(id: "water", name: "Pure water", correct: .neutral),
        Item(id: "vinegar", name: "Vinegar", correct: .acid),
        Item(id: "milk-mag", name: "Milk of magnesia", correct: .base),
        Item(id: "sugar", name: "Sugar water", correct: .neutral),
        Item(id: "baking", name: "Baking soda", correct: .base),
        Item(id: "curd", name: "Curd", correct: .acid)
    ]
    @State private var assignment: [String: Bucket] = [:]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Acid, Neutral, or Base?").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Sort these kitchen and bathroom items.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                ForEach(items) { it in row(it) }
                if assignment.count == items.count {
                    let correct = items.reduce(0) { $0 + ((assignment[$1.id] == $1.correct) ? 1 : 0) }
                    Text("Score: \(correct) / \(items.count)").font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }

    @ViewBuilder
    private func row(_ it: Item) -> some View {
        let pick = assignment[it.id]
        HStack(spacing: 10) {
            Text(it.name).font(.callout.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Spacer(minLength: 8)
            ForEach(Bucket.allCases, id: \.self) { b in
                let isPicked = pick == b
                let tint: Color = pick == nil
                    ? Color.compatIndigo
                    : (isPicked ? (b == it.correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger) : Color.gray)
                Button {
                    if assignment[it.id] == nil { assignment[it.id] = b }
                } label: {
                    Text(b.rawValue).font(.caption.weight(.semibold))
                        .padding(.horizontal, 8).padding(.vertical, 5)
                        .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                        .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                        .foregroundColor(tint)
                }
                .buttonStyle(.plain).pointingCursor().disabled(pick != nil)
            }
        }
        .padding(.horizontal, 14).padding(.vertical, 8)
        .frame(maxWidth: DesignTokens.contentMaxWidth)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, 24)
    }
}

// MARK: - Inline Scene 11: Litmus Paper Test (toggle reveal)
private struct LitmusPaperTestScene: View {
    let onComplete: () -> Void
    @State private var dipped: String? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Litmus Paper Test").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Blue litmus turns red in acid. Red litmus turns blue in base. Tap to dip.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                HStack(spacing: 24) {
                    paperVisual(initial: .blue, in: "acid", current: dipped)
                    paperVisual(initial: .red, in: "base", current: dipped)
                }
                HStack(spacing: 14) {
                    Button { dipped = "acid" } label: {
                        Text("Dip in acid").font(.body.weight(.semibold))
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(Capsule().fill(DesignTokens.BrandColor.danger.opacity(0.15)))
                            .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                            .foregroundColor(DesignTokens.BrandColor.danger)
                    }
                    .buttonStyle(.plain).pointingCursor()
                    Button { dipped = "base" } label: {
                        Text("Dip in base").font(.body.weight(.semibold))
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                            .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                            .foregroundColor(Color.compatIndigo)
                    }
                    .buttonStyle(.plain).pointingCursor()
                    Button { dipped = nil } label: { Text("Reset").font(.caption) }
                        .buttonStyle(.plain).pointingCursor()
                }
                if let d = dipped {
                    Text(d == "acid"
                         ? "Blue → Red, Red unchanged. So the liquid is acidic."
                         : "Red → Blue, Blue unchanged. So the liquid is basic.")
                        .font(.callout.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .multilineTextAlignment(.center).padding(.horizontal, 24)
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                }
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }

    private func paperVisual(initial: Color, in liquid: String, current: String?) -> some View {
        let isBlue = initial == .blue
        let finalColor: Color = {
            guard let c = current else { return initial }
            if isBlue && c == "acid" { return DesignTokens.BrandColor.danger }
            if !isBlue && c == "base" { return Color.compatIndigo }
            return initial
        }()
        return VStack {
            Capsule().fill(finalColor).frame(width: 36, height: 100)
            Text(isBlue ? "Blue litmus" : "Red litmus").font(.caption2)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
    }
}

// MARK: - Inline Scene 12: Universal Indicator (slider with color band)
private struct UniversalIndicatorScene: View {
    let onComplete: () -> Void
    @State private var ph: Double = 7

    private var bandColor: Color {
        if ph < 3 { return DesignTokens.BrandColor.danger }
        if ph < 6 { return DesignTokens.BrandColor.mnemonicAccent }
        if ph < 8 { return DesignTokens.BrandColor.primaryAction }
        if ph < 11 { return Color.compatIndigo }
        return Color.purple
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Universal Indicator — One Paper for Any pH").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Universal indicator mixes several dyes. The colour you get maps to an exact pH on the chart.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                RoundedRectangle(cornerRadius: 12).fill(bandColor)
                    .frame(width: 160, height: 100)
                Text("pH ≈ \(String(format: "%.1f", ph))").font(.title3.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Slider(value: $ph, in: 0...14).frame(maxWidth: 340).padding(.horizontal, 24)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 13: Cabbage Juice Magic (toggle)
private struct CabbageJuiceMagicScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0
    private let captions = [
        "Red cabbage juice is purple at neutral.",
        "Add lemon (acid): it turns red.",
        "Add baking soda (base): it turns blue/green.",
        "Same liquid — natural pH indicator from kitchen!"
    ]
    private let colors: [Color] = [
        Color.purple,
        DesignTokens.BrandColor.danger,
        DesignTokens.BrandColor.primaryAction,
        Color.compatIndigo
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Cabbage Juice Magic").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ZStack {
                    RoundedRectangle(cornerRadius: 18).strokeBorder(Color.gray, lineWidth: 2)
                        .frame(width: 120, height: 160)
                    RoundedRectangle(cornerRadius: 12).fill(colors[stage].opacity(0.7))
                        .frame(width: 100, height: 120).offset(y: 16)
                }
                Text(captions[stage]).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                Button { withAnimation { stage = (stage + 1) % captions.count } } label: {
                    Text("Next").font(.body.weight(.semibold))
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

// MARK: - Inline Scene 14: Salt Formation Steps (stepper)
private struct SaltFormationStepsScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0

    private let steps = [
        ("HCl", "Start: an acid — hydrochloric acid (in your stomach)."),
        ("HCl + NaOH", "Add: a base — sodium hydroxide solution."),
        ("NaCl + H₂O", "React: they neutralise each other."),
        ("NaCl", "Evaporate: water leaves behind salt — common table salt.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Acid + Base → Salt").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text(steps[step].0).font(.system(size: 36, weight: .bold, design: .monospaced))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text(steps[step].1).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                Button { withAnimation { step = (step + 1) % steps.count } } label: {
                    Text("Next step").font(.body.weight(.semibold))
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

// MARK: - Inline Scene 15: Common Salt Story (tap-to-reveal)
private struct CommonSaltStoryScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct Fact: Identifiable { let id: String; let title: String; let detail: String }
    private let facts: [Fact] = [
        Fact(id: "ocean", title: "From the sea", detail: "India produces ~5 million tonnes of salt yearly, mostly by evaporating sea water in coastal pans (Gujarat, Tamil Nadu)."),
        Fact(id: "march", title: "Salt March 1930", detail: "Mahatma Gandhi walked 240 miles to Dandi to break the British salt tax — pivotal in Indian independence."),
        Fact(id: "iodine", title: "Iodised salt", detail: "Tiny iodine added prevents goitre (thyroid swelling) — mandatory in India since 1992."),
        Fact(id: "preserve", title: "Salt preserves food", detail: "Pickles, dried fish, achaar — salt pulls water out of bacteria so they can't grow.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("The Story of Common Salt").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ForEach(facts) { f in
                    Button { tapped.insert(f.id) } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(f.title).font(.headline)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                            if tapped.contains(f.id) {
                                Text(f.detail).font(.callout)
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

// MARK: - Inline Scene 16: Antacid in Your Stomach (animation toggle)
private struct AntacidStomachScene: View {
    let onComplete: () -> Void
    @State private var taken: Bool = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Antacid in Your Stomach").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Acidity = too much HCl in the stomach. Antacids contain bases (Mg(OH)₂ in Milk of Magnesia, or NaHCO₃ in some tablets) that neutralise the excess acid.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                ZStack {
                    RoundedRectangle(cornerRadius: 32).fill(taken
                                                            ? DesignTokens.BrandColor.primaryAction.opacity(0.25)
                                                            : DesignTokens.BrandColor.danger.opacity(0.35))
                        .frame(width: 160, height: 200)
                    Text(taken ? "😊" : "🥵").font(.system(size: 60))
                }
                Button { withAnimation { taken.toggle() } } label: {
                    Text(taken ? "Wait, undo" : "Take antacid").font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(DesignTokens.BrandColor.primaryAction.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.primaryAction.opacity(0.5), lineWidth: 1))
                        .foregroundColor(DesignTokens.BrandColor.primaryAction)
                }
                .buttonStyle(.plain).pointingCursor()
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 17: Tooth Decay & Toothpaste (stepper)
private struct ToothDecayScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🍬", "1. Sugary food left on teeth."),
        ("🦠", "2. Mouth bacteria eat the sugar — they make acid."),
        ("🦷", "3. Acid eats enamel — that's a cavity starting."),
        ("🪥", "4. Basic toothpaste neutralises the mouth acid. Brush twice a day!")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Why You Brush Your Teeth").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text(steps[step].0).font(.system(size: 100))
                Text(steps[step].1).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                Button { withAnimation { step = (step + 1) % steps.count } } label: {
                    Text("Next").font(.body.weight(.semibold))
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

