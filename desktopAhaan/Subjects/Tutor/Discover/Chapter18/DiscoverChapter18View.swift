import SwiftUI

struct DiscoverChapter18View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(18)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Where Drain Water Goes",
        "WWTP Stage Builder",
        "Sort the Contaminants",
        "Open Drain Hazards",
        "Compost Pit Builder",
        "Sanitation Map",
        "Soak-Pit Design",
        "Better Practices",
        "Sewage System History",
        "Anaerobic Digester Lab",
        "BOD — Water Quality Score",
        "Sludge to Biogas",
        "Pollutant Lifecycle",
        "Swachh Bharat Story",
        "Toilet Design Atlas",
        "Greywater vs Blackwater",
        "Industrial Effluent Treatment",
        "Sanitation Worker's Day",
        "Wastewater Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 18 — Wastewater Story",
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
            { AnyView(Scene1_WhereDrainWaterGoes(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_WWTPStageBuilder(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_SortContaminants(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(2, score: score, max: 5) })) },
            { AnyView(Scene4_OpenDrainHazards(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_CompostPitBuilder(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_SanitationMap(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_SoakPitDesign(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_BetterPractices(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(7, score: score, max: 5) })) },
            { AnyView(SewageHistoryScene(onComplete: { self.markComplete(8) })) },
            { AnyView(AnaerobicDigesterScene(onComplete: { self.markComplete(9) })) },
            { AnyView(BODScoreScene(onComplete: { self.markComplete(10) })) },
            { AnyView(SludgeToBiogasScene(onComplete: { self.markComplete(11) })) },
            { AnyView(PollutantLifecycleScene(onComplete: { self.markComplete(12) })) },
            { AnyView(SwachhBharatScene(onComplete: { self.markComplete(13) })) },
            { AnyView(ToiletDesignAtlasScene(onComplete: { self.markComplete(14) })) },
            { AnyView(GreywaterBlackwaterScene(onComplete: { self.markComplete(15) })) },
            { AnyView(IndustrialEffluentScene(onComplete: { self.markComplete(16) })) },
            { AnyView(SanitationWorkerScene(onComplete: { self.markComplete(17) })) },
            { AnyView(QuickCheckQuizScene(
                title: "Wastewater Quiz",
                questions: Array(self.chapter.quickCheckQuestionsList.prefix(4)),
                onComplete: { score in self.markComplete(18, score: score, max: 4) }
            )) },
            { AnyView(Scene9_BossQuiz_Ch18(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.18

private struct SewageHistoryScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🏛", "~2600 BCE: Indus Valley (Mohenjo-daro, Harappa) had brick-lined sewers — first in the world."),
        ("🏰", "Roman empire: Cloaca Maxima drained Rome's filth into the Tiber river."),
        ("🦠", "1850s London: 'Great Stink' + cholera → engineer Bazalgette built the first modern sewer network."),
        ("🚽", "Today: large cities run treatment plants. Many Indian towns still use open drains.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Sewage Systems Through History").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(steps[step].0).font(.system(size: 100))
            Text(steps[step].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { step = (step + 1) % steps.count } } label: {
                Text("Next era").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct AnaerobicDigesterScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Anaerobic Digester — Where Sludge Becomes Energy").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🛢").font(.system(size: 100))
            Text("Sealed tank, no oxygen. Bacteria break down organic sludge slowly over 20-30 days. Outputs: biogas (60% methane fuel + CO₂) and a dry residue used as fertiliser. Cities run these to power their treatment plants from the sewage they treat — closed loop!")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct BODScoreScene: View {
    let onComplete: () -> Void
    @State private var bod: Double = 5
    private var rating: String {
        if bod < 2 { return "Excellent — drinking-water quality." }
        if bod < 5 { return "Good — safe for fish, swimming." }
        if bod < 10 { return "Polluted — fish struggle." }
        return "Very polluted — sewage-grade. Most life dead."
    }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("BOD — How Polluted is the Water?").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("BOD (Biological Oxygen Demand) = how much O₂ microbes need to break down the organic muck in water. Higher BOD = more pollution.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
            Text("BOD: \(String(format: "%.1f", bod)) mg/L")
                .font(.title.monospacedDigit()).foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $bod, in: 0...30).frame(maxWidth: 340).padding(.horizontal, DesignTokens.Spacing.xl)
            Text(rating).font(.callout.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct SludgeToBiogasScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0
    private let stages = [
        ("💩", "Settled sludge from treatment plant — full of organic muck."),
        ("🛢", "Sealed digester tank, no oxygen, heated to 35-55 °C."),
        ("🦠", "Anaerobic bacteria break it down over 20-30 days."),
        ("🔥", "Output: biogas (methane) fuels boilers + dry residue is fertiliser.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Sludge → Biogas").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(stages[stage].0).font(.system(size: 100))
            Text(stages[stage].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { stage = (stage + 1) % stages.count } } label: {
                Text("Next").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct PollutantLifecycleScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0
    private let stages = [
        ("🏠", "1. Used in homes — soap, oil, detergent, food scraps."),
        ("🕳", "2. Down the drain → enters sewers."),
        ("🏭", "3. Treatment plant filters + biologically breaks down."),
        ("🌊", "4. Cleaner water released to river. Sludge → biogas + fertiliser.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Lifecycle of a Pollutant").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(stages[stage].0).font(.system(size: 100))
            Text(stages[stage].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { stage = (stage + 1) % stages.count } } label: {
                Text("Next").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct SwachhBharatScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Swachh Bharat Abhiyan").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🧹🇮🇳").font(.system(size: 100))
            Text("Launched 2 Oct 2014 — Gandhi's birthday. Goal: clean India, 100 million toilets built. By 2019, India declared open-defecation-free. Behaviour change campaigns reached 600 million Indians. One of the world's largest sanitation drives in history.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct ToiletDesignAtlasScene: View {
    let onComplete: () -> Void
    @State private var sel: String? = nil
    private struct T: Identifiable { let id: String; let name: String; let detail: String }
    private let toilets: [T] = [
        T(id: "twin", name: "Twin-pit toilet (rural)",
          detail: "Two pits used alternately. While one fills, the other composts. After 2 years, dig out as humus."),
        T(id: "septic", name: "Septic tank (suburban)",
          detail: "Sealed tank settles solids, lets liquid leach through soil. Needs pumping every 2-5 years."),
        T(id: "sewer", name: "Connected sewer (cities)",
          detail: "Underground pipe network to a central treatment plant. Most efficient but expensive."),
        T(id: "ecosan", name: "Eco-san (waterless)",
          detail: "Separates urine + faeces, composts on-site. No water needed. Used in water-scarce areas.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Toilet Designs Around India").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(toilets) { t in
                Button { sel = t.id } label: {
                    HStack {
                        Text(t.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                    }
                    .padding(DesignTokens.Spacing.md).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(sel == t.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, DesignTokens.Spacing.xl)
            }
            if let s = sel, let t = toilets.first(where: { $0.id == s }) {
                Text(t.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct GreywaterBlackwaterScene: View {
    let onComplete: () -> Void
    @State private var grey: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Greywater vs Blackwater").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Greywater", on: grey) { grey = true }
                pickChip("Blackwater", on: !grey) { grey = false }
            }
            Text(grey ? "🚿🧼" : "🚽💩").font(.system(size: 80))
            Text(grey
                 ? "Greywater: from sinks, showers, washing machines. Has soap + dirt but no faecal matter. Can be reused for gardens after simple filtering."
                 : "Blackwater: from toilets. Has faeces + urine. Needs full treatment before reuse or release. Carries bacteria, viruses, hormones.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
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

private struct IndustrialEffluentScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct E: Identifiable { let id: String; let title: String; let detail: String }
    private let effs: [E] = [
        E(id: "dye", title: "Textile dyes", detail: "Tirupur and Surat textile mills released coloured + chemical effluent. Now must use ETPs (Effluent Treatment Plants) by law."),
        E(id: "lead", title: "Heavy metals (lead, mercury)", detail: "From battery factories, tanneries. Don't degrade — accumulate in fish and humans. Cause brain damage."),
        E(id: "oil", title: "Oil + grease", detail: "From petroleum refineries, ports. Forms a film on water, blocking oxygen for marine life."),
        E(id: "thermal", title: "Thermal pollution", detail: "Power plants release hot water back into rivers. Heat kills fish + accelerates algal blooms.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Industrial Effluent — Tougher Than Sewage").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(effs) { e in
                Button { tapped.insert(e.id) } label: {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        Text(e.title).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        if tapped.contains(e.id) {
                            Text(e.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text("Tap to reveal").font(.caption.italic())
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }.padding(DesignTokens.Spacing.md).frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, DesignTokens.Spacing.xl)
            }
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct SanitationWorkerScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("The People Who Keep Cities Clean").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🦺🧹").font(.system(size: 100))
            Text("Sanitation workers (safai karamcharis) clean streets, drains, sewers. Many work without protective gear, exposed to toxic gases and waste. Manual scavenging is banned by law (1993, 2013), but enforcement is patchy. Every 16 May, India observes Safai Karmachari Diwas to honour their work.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

