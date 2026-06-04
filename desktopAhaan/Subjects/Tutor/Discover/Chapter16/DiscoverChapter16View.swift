import SwiftUI

struct DiscoverChapter16View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(16)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Earth's Water Pie",
        "Water Table Slider",
        "Aquifer Cross-Section",
        "Drip / Sprinkler / Flood",
        "Rainwater Harvesting",
        "Bawdi — the Stepwell",
        "Daily Water Audit",
        "World Water Day Pledge",
        "Water Cycle Wheel",
        "Drought vs Flood",
        "Distillation Lab",
        "Filter the Muddy Water",
        "RO Purifier Inside",
        "Indian River Atlas",
        "Glacier Meltdown Story",
        "Water-Borne Diseases",
        "Tap Drip Counter",
        "Climate Change Effect",
        "Water Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 16 — Water: A Precious Resource",
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
            { AnyView(Scene1_WaterPie(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_WaterTableSlider(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_AquiferCrossSection(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_IrrigationCompare(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(3, score: score, max: 3) })) },
            { AnyView(Scene5_RainwaterHarvesting(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_BawdiStepwell(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_WaterAudit(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_WaterPledge(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(7) })) },
            { AnyView(WaterCycleWheelScene(onComplete: { self.markComplete(8) })) },
            { AnyView(DroughtVsFloodScene(onComplete: { self.markComplete(9) })) },
            { AnyView(DistillationLabScene(onComplete: { self.markComplete(10) })) },
            { AnyView(FilterMuddyWaterScene(onComplete: { self.markComplete(11) })) },
            { AnyView(ROPurifierScene(onComplete: { self.markComplete(12) })) },
            { AnyView(IndianRiverAtlasScene(onComplete: { self.markComplete(13) })) },
            { AnyView(GlacierMeltdownScene(onComplete: { self.markComplete(14) })) },
            { AnyView(WaterBorneDiseasesScene(onComplete: { self.markComplete(15) })) },
            { AnyView(TapDripCounterScene(onComplete: { self.markComplete(16) })) },
            { AnyView(ClimateChangeWaterScene(onComplete: { self.markComplete(17) })) },
            { AnyView(QuickCheckQuizScene(
                title: "Water Quiz",
                questions: Array(self.chapter.quickCheckQuestionsList.prefix(4)),
                onComplete: { score in self.markComplete(18, score: score, max: 4) }
            )) },
            { AnyView(Scene9_BossQuiz_Ch16(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.16

private struct WaterCycleWheelScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("☀️", "Sun heats water in oceans, lakes."),
        ("💨", "Water evaporates into vapour, rises."),
        ("☁️", "Cools high up — condenses into clouds."),
        ("🌧", "Falls as rain or snow over land + sea."),
        ("🏞", "Flows back to oceans through rivers. Cycle repeats.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("The Water Cycle").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text(steps[step].0).font(.system(size: 100))
            Text(steps[step].1).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            Button { withAnimation { step = (step + 1) % steps.count } } label: {
                Text("Next stage").font(.body.weight(.semibold))
                    .padding(.horizontal, 18).padding(.vertical, 9)
                    .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                    .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                    .foregroundColor(Color.compatIndigo)
            }.buttonStyle(.plain).pointingCursor()
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct DroughtVsFloodScene: View {
    let onComplete: () -> Void
    @State private var drought: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Drought vs Flood").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("Drought", on: drought) { drought = true }
                pickChip("Flood", on: !drought) { drought = false }
            }
            Text(drought ? "🏜" : "🌊").font(.system(size: 100))
            Text(drought
                 ? "Drought: long period of little or no rain. Crops fail, wells dry. Marathwada (Maharashtra) and Bundelkhand often hit. Causes water scarcity, farmer distress."
                 : "Flood: too much water at once. Rivers overflow, fields submerge. Assam, Bihar, Mumbai face floods every monsoon. Causes property loss, water-borne disease.")
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

private struct DistillationLabScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🧪", "Salty water in a flask. Heat it."),
        ("💨", "Water boils → vapour rises. Salt stays behind."),
        ("❄️", "Vapour hits cold condenser, turns back to pure water."),
        ("💧", "Pure distilled water drips into collector. Used in car batteries, labs.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Distillation — Pure Water from Anywhere").font(.largeTitle.bold())
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

private struct FilterMuddyWaterScene: View {
    let onComplete: () -> Void
    @State private var step: Int = 0
    private let steps = [
        ("🟫", "Muddy river water."),
        ("⚪", "Let large grit settle to the bottom (sedimentation)."),
        ("🌊", "Pour gently into another container (decantation)."),
        ("🧽", "Filter through layered cloth + sand + gravel."),
        ("💧", "Clear water — BOIL before drinking to kill germs.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Filter Muddy Water").font(.largeTitle.bold())
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

private struct ROPurifierScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("RO Purifier — How It Works").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("💧→🧪→💎").font(.system(size: 80))
            VStack(alignment: .leading, spacing: 6) {
                Text("1. Pre-filter: catches sand + visible dirt.").font(.callout)
                Text("2. Activated carbon: removes chlorine + odour.").font(.callout)
                Text("3. RO membrane: tiny pores (~0.0001 µm) block dissolved salts, heavy metals, bacteria.").font(.callout)
                Text("4. UV lamp: kills any remaining germs.").font(.callout)
            }
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .padding(14).frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
            .padding(.horizontal, 24)
            Text("Note: RO wastes 3 L of water for every 1 L of pure water. Use the reject water for plants or floor cleaning.")
                .font(.caption.italic()).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .padding(.horizontal, 24).multilineTextAlignment(.center)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct IndianRiverAtlasScene: View {
    let onComplete: () -> Void
    @State private var sel: String? = nil
    private struct R: Identifiable { let id: String; let name: String; let detail: String }
    private let rivers: [R] = [
        R(id: "ganga", name: "Ganga", detail: "Holiest river. Flows 2525 km from Gangotri glacier to Bay of Bengal. Major lifeline for North India."),
        R(id: "yamuna", name: "Yamuna", detail: "Largest tributary of Ganga. Passes through Delhi, Agra, where Taj Mahal sits on its banks."),
        R(id: "brahma", name: "Brahmaputra", detail: "Originates in Tibet, flows through Assam. Causes annual floods that also enrich the soil."),
        R(id: "narmada", name: "Narmada", detail: "Flows westward (most Indian rivers flow east). Sardar Sarovar Dam on it powers Gujarat."),
        R(id: "godavari", name: "Godavari", detail: "Largest river of South India. 1465 km, originates near Nashik.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Major Rivers of India").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(rivers) { r in
                Button { sel = r.id } label: {
                    HStack {
                        Text(r.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                    }
                    .padding(12).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(sel == r.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, 24)
            }
            if let s = sel, let r = rivers.first(where: { $0.id == s }) {
                Text(r.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, 24)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct GlacierMeltdownScene: View {
    let onComplete: () -> Void
    @State private var year: Double = 1950
    private var glacier: Double { max(0.2, 1.0 - (year - 1950) / 200) }
    private var glacierWidth: CGFloat { 240 * CGFloat(glacier) }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Glaciers Are Shrinking").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            RoundedRectangle(cornerRadius: 16).fill(Color.compatIndigo.opacity(0.45))
                .frame(width: glacierWidth, height: 120)
            Text("Year: \(Int(year))").font(.title2.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $year, in: 1950...2100).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("Himalayan glaciers — source of Ganga, Yamuna, Brahmaputra — have lost 30% of ice since 1950. If trend continues, Asia's rivers face severe summer shortages by 2100.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct WaterBorneDiseasesScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct D: Identifiable { let id: String; let name: String; let detail: String }
    private let dis: [D] = [
        D(id: "diar", name: "Diarrhoea", detail: "Most common. Caused by bacteria/viruses in dirty water. Kills 100,000+ Indian children/yr. Treat with ORS."),
        D(id: "chol", name: "Cholera", detail: "Vibrio cholerae bacteria. Causes severe watery diarrhoea. Epidemic potential — needs antibiotics + IV fluid."),
        D(id: "typh", name: "Typhoid", detail: "Salmonella typhi. High fever, weakness. Vaccine + chlorinated water prevent it."),
        D(id: "hep", name: "Hepatitis A & E", detail: "Liver virus from faecal contamination. Jaundice + nausea. Boiling water kills the virus.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Water-Borne Diseases").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(dis) { d in
                Button { tapped.insert(d.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(d.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        if tapped.contains(d.id) {
                            Text(d.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

private struct TapDripCounterScene: View {
    let onComplete: () -> Void
    @State private var dripsPerMin: Double = 30
    private var litresPerDay: Double { dripsPerMin * 60 * 24 / 20000 }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("A Dripping Tap Wastes…").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("💧").font(.system(size: 100))
            Text("\(Int(dripsPerMin)) drips / min").font(.callout.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $dripsPerMin, in: 1...100).frame(maxWidth: 340).padding(.horizontal, 24)
            Text("\(String(format: "%.1f", litresPerDay)) L wasted / day")
                .font(.title.weight(.bold).monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.danger)
            Text("That's \(Int(litresPerDay * 365)) L/year — enough for a family's drinking water for weeks. Fix that leaky tap!")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, 24)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, 12)
        }.frame(maxWidth: .infinity).padding(.bottom, 12) }
    }
}

private struct ClimateChangeWaterScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct E: Identifiable { let id: String; let title: String; let detail: String }
    private let effects: [E] = [
        E(id: "intense", title: "More intense storms", detail: "Warmer air holds more moisture → fewer but heavier rain events."),
        E(id: "drought", title: "Longer droughts", detail: "Higher evaporation rates dry up soil between rains."),
        E(id: "glacier", title: "Melting glaciers", detail: "Short-term floods, long-term river shortages."),
        E(id: "sea", title: "Rising seas", detail: "Coastal cities like Mumbai, Kolkata, Chennai face flooding + saltwater contaminating freshwater aquifers.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Climate Change → Water Crisis").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(effects) { e in
                Button { tapped.insert(e.id) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(e.title).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        if tapped.contains(e.id) {
                            Text(e.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

