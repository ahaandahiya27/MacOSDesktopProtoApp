import SwiftUI

struct DiscoverChapter14View: View {
    let pack: SubjectPack
    let chapter: Chapter

    @EnvironmentObject private var dataStore: DataStore
    @AppStorage(AppStorageKeys.discoverScene(14)) private var currentScene: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sceneTitles = [
        "Build a Circuit",
        "Series vs Parallel",
        "Heating Effect",
        "Inside an Electric Iron",
        "Magnetic Effect",
        "Build an Electromagnet",
        "Fuse & MCB",
        "Safety Lab",
        "Symbols of Components",
        "Voltage Slider",
        "Battery Types Atlas",
        "Conductor vs Insulator Sorter",
        "Maglev Train Story",
        "Solenoid Right-Hand Rule",
        "Electricity Bill Math",
        "DC vs AC Compare",
        "Live, Neutral, Earth Plug",
        "Power Generation Atlas",
        "Electric Current Quiz",
        "Boss Quiz"
    ]

    var body: some View {
        DiscoverShell(
            pack: pack,
            chapter: chapter,
            navigationTitle: "Discover · Ch. 14 — Electric Current and its Effects",
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
            { AnyView(Scene1_BuildACircuit(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(0) })) },
            { AnyView(Scene2_SeriesVsParallel(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(1) })) },
            { AnyView(Scene3_HeatingEffect(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(2) })) },
            { AnyView(Scene4_ElectricIron(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(3) })) },
            { AnyView(Scene5_MagneticEffect(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(4) })) },
            { AnyView(Scene6_BuildElectromagnet(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(5) })) },
            { AnyView(Scene7_FuseMCB(pack: self.pack, chapter: self.chapter, onComplete: { self.markComplete(6) })) },
            { AnyView(Scene8_SafetyLab(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(7, score: score, max: 5) })) },
            { AnyView(SymbolsComponentsScene(onComplete: { self.markComplete(8) })) },
            { AnyView(VoltageSliderScene(onComplete: { self.markComplete(9) })) },
            { AnyView(BatteryTypesAtlasScene(onComplete: { self.markComplete(10) })) },
            { AnyView(ConductorInsulatorSorterScene(onComplete: { self.markComplete(11) })) },
            { AnyView(MaglevTrainScene(onComplete: { self.markComplete(12) })) },
            { AnyView(SolenoidRightHandScene(onComplete: { self.markComplete(13) })) },
            { AnyView(ElectricityBillScene(onComplete: { self.markComplete(14) })) },
            { AnyView(DCvsACScene(onComplete: { self.markComplete(15) })) },
            { AnyView(LiveNeutralEarthScene(onComplete: { self.markComplete(16) })) },
            { AnyView(PowerGenerationAtlasScene(onComplete: { self.markComplete(17) })) },
            { AnyView(QuickCheckQuizScene(
                title: "Electric Current Quiz",
                questions: Array(self.chapter.quickCheckQuestionsList.prefix(4)),
                onComplete: { score in self.markComplete(18, score: score, max: 4) }
            )) },
            { AnyView(Scene9_BossQuiz_Ch14(pack: self.pack, chapter: self.chapter, onComplete: { score in self.markComplete(19, score: score, max: 10) })) }
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

// MARK: - Inline scenes for Ch.14

private struct SymbolsComponentsScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct C: Identifiable { let id: String; let symbol: String; let name: String }
    private let comps: [C] = [
        C(id: "cell", symbol: "─|├─", name: "Cell — long line is +ve, short line is -ve."),
        C(id: "bulb", symbol: "─⊗─", name: "Bulb — circle with X across it."),
        C(id: "switch", symbol: "─/ ─", name: "Switch — gap with hinged arm."),
        C(id: "wire", symbol: "──── ", name: "Wire — plain straight line."),
        C(id: "resistor", symbol: "─▭─", name: "Resistor — rectangle (or zigzag in older books).")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Circuit Diagram Symbols").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(comps) { c in
                Button { tapped.insert(c.id) } label: {
                    HStack {
                        Text(c.symbol).font(.system(.title3, design: .monospaced))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                        if tapped.contains(c.id) {
                            Text(c.name).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                        } else {
                            Text("Tap").font(.caption.italic())
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }.padding(DesignTokens.Spacing.md).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, DesignTokens.Spacing.xl)
            }
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct VoltageSliderScene: View {
    let onComplete: () -> Void
    @State private var v: Double = 1.5
    private var brightness: Double { min(1.0, v / 6.0) }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Voltage → Bulb Brightness").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            let shadowAlpha: Double = brightness * 0.8
            let shadowRadius: CGFloat = 30 * brightness
            ZStack {
                Circle().fill(DesignTokens.BrandColor.mnemonicAccent.opacity(brightness))
                    .frame(width: 120, height: 120)
                    .shadow(color: DesignTokens.BrandColor.mnemonicAccent.opacity(shadowAlpha),
                            radius: shadowRadius)
                Image(systemName: "lightbulb.fill").font(.system(size: 60))
                    .foregroundColor(brightness > 0.3 ? DesignTokens.BrandColor.canvasText : .gray)
            }
            Text("\(String(format: "%.1f", v)) V").font(.title2.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Slider(value: $v, in: 0...6).frame(maxWidth: 340).padding(.horizontal, DesignTokens.Spacing.xl)
            Text("Voltage is the 'push' that drives electrons. More volts → brighter bulb. Above the bulb's rating it burns out.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct BatteryTypesAtlasScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct B: Identifiable { let id: String; let emoji: String; let name: String; let detail: String }
    private let bats: [B] = [
        B(id: "aa", emoji: "🔋", name: "AA / AAA dry cells (1.5V)", detail: "Single-use. Zinc-carbon or alkaline. TV remotes, torches."),
        B(id: "btn", emoji: "💠", name: "Button cells (1.5V or 3V)", detail: "Tiny watches, calculators, hearing aids."),
        B(id: "car", emoji: "🚗", name: "Car lead-acid battery (12V)", detail: "Rechargeable. Heavy, dangerous if cracked open."),
        B(id: "lion", emoji: "📱", name: "Lithium-ion (3.7V/cell)", detail: "Phones, laptops, EVs. Best energy-to-weight ratio.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Battery Types").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(bats) { b in
                Button { tapped.insert(b.id) } label: {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        HStack { Text(b.emoji).font(.title2)
                            Text(b.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText) }
                        if tapped.contains(b.id) {
                            Text(b.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

private struct ConductorInsulatorSorterScene: View {
    let onComplete: () -> Void
    private struct M: Identifiable { let id: String; let name: String; let conducts: Bool }
    private let items: [M] = [
        M(id: "cu", name: "Copper wire", conducts: true),
        M(id: "wood", name: "Wood block", conducts: false),
        M(id: "iron", name: "Iron rod", conducts: true),
        M(id: "rub", name: "Rubber band", conducts: false),
        M(id: "salt", name: "Salt water", conducts: true),
        M(id: "plastic", name: "Plastic ruler", conducts: false)
    ]
    @State private var picks: [String: Bool] = [:]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Conductor or Insulator?").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(items) { i in row(i) }
            if picks.count == items.count {
                let correct = items.reduce(0) { $0 + ((picks[$1.id] == $1.conducts) ? 1 : 0) }
                Text("Score: \(correct) / \(items.count)").font(.headline)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
    @ViewBuilder
    private func row(_ i: M) -> some View {
        let pick = picks[i.id]
        HStack(spacing: 10) {
            Text(i.name).font(.callout.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Spacer(minLength: DesignTokens.Spacing.sm)
            ForEach([true, false], id: \.self) { v in
                ans(v ? "Conductor" : "Insulator", v: v, pick: pick, correct: i.conducts, id: i.id)
            }
        }
        .padding(.horizontal, 14).padding(.vertical, DesignTokens.Spacing.sm)
        .frame(maxWidth: DesignTokens.contentMaxWidth)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, DesignTokens.Spacing.xl)
    }
    private func ans(_ label: String, v: Bool, pick: Bool?, correct: Bool, id: String) -> some View {
        let isPicked = pick == v
        let tint: Color = pick == nil
            ? Color.compatIndigo
            : (isPicked ? (v == correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger) : Color.gray)
        return Button {
            if picks[id] == nil { picks[id] = v }
        } label: {
            Text(label).font(.caption.weight(.semibold))
                .padding(.horizontal, DesignTokens.Spacing.sm).padding(.vertical, 5)
                .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                .foregroundColor(tint)
        }.buttonStyle(.plain).pointingCursor().disabled(pick != nil)
    }
}

private struct MaglevTrainScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Maglev — Magnets Lift the Train").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🚆").font(.system(size: 100))
            Text("Maglev (magnetic levitation) trains float on powerful electromagnets. No wheels, no friction with the track. Japan's L0 hit 603 km/h. China's Shanghai Maglev does 431 km/h on a daily commute. India's Vande Bharat is conventional but Maglev is the future.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct SolenoidRightHandScene: View {
    let onComplete: () -> Void
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Solenoid Right-Hand Rule").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("✋").font(.system(size: 100))
            Text("Wrap your right hand around the coil so fingers curl in the direction of current flow. Your THUMB points to the north pole of the resulting electromagnet. Reverse the current → poles swap.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                .frame(maxWidth: DesignTokens.contentMaxWidth)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct ElectricityBillScene: View {
    let onComplete: () -> Void
    @State private var watts: Double = 1000
    @State private var hours: Double = 8
    private var units: Double { watts * hours / 1000 }
    private var rupees: Double { units * 8 }
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("Electricity Bill Math").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("AC: \(Int(watts)) W on for \(Int(hours)) hrs/day")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("\(String(format: "%.1f", units)) kWh / day")
                .font(.title2.monospacedDigit()).foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("≈ ₹\(String(format: "%.0f", rupees * 30)) / month").font(.title.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.primaryAction)
            Text("Watts").font(.caption).foregroundColor(.secondary)
            Slider(value: $watts, in: 100...3000).frame(maxWidth: 340).padding(.horizontal, DesignTokens.Spacing.xl)
            Text("Hours/day").font(.caption).foregroundColor(.secondary)
            Slider(value: $hours, in: 1...24).frame(maxWidth: 340).padding(.horizontal, DesignTokens.Spacing.xl)
            Text("1 unit (kWh) = ₹6–10 typical Indian residential rate.")
                .font(.caption).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct DCvsACScene: View {
    let onComplete: () -> Void
    @State private var dc: Bool = true
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("DC vs AC").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            HStack(spacing: 14) {
                pickChip("DC", on: dc) { dc = true }
                pickChip("AC", on: !dc) { dc = false }
            }
            Text(dc ? "→→→→→→" : "→←→←→←")
                .font(.system(size: 50, weight: .regular, design: .monospaced))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text(dc
                 ? "Direct Current: electrons flow in ONE direction. From batteries, solar cells, USB. 1.5V dry cell, 3.7V phone battery."
                 : "Alternating Current: electrons swing back and forth 50 times per second (50 Hz in India). From wall sockets. 230V mains.")
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

private struct LiveNeutralEarthScene: View {
    let onComplete: () -> Void
    @State private var pin: String? = nil
    private struct Pin: Identifiable { let id: String; let color: String; let role: String }
    private let pins: [Pin] = [
        Pin(id: "live", color: "Red / Brown", role: "Live — carries 230V AC. Dangerous to touch."),
        Pin(id: "neutral", color: "Black / Blue", role: "Neutral — return path back to source. Near 0V."),
        Pin(id: "earth", color: "Green / Yellow", role: "Earth — connects to the ground. Carries leakage current safely away.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("3-Pin Plug — Live, Neutral, Earth").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("🔌").font(.system(size: 90))
            ForEach(pins) { p in
                Button { pin = p.id } label: {
                    HStack {
                        Text(p.color).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer()
                    }
                    .padding(DesignTokens.Spacing.md).frame(maxWidth: DesignTokens.contentMaxWidth)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(pin == p.id ? Color.compatIndigo.opacity(0.12) : Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                }.buttonStyle(.plain).pointingCursor().padding(.horizontal, DesignTokens.Spacing.xl)
            }
            if let s = pin, let p = pins.first(where: { $0.id == s }) {
                Text(p.role).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
            }
            GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
        }.frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md) }
    }
}

private struct PowerGenerationAtlasScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []
    private struct G: Identifiable { let id: String; let emoji: String; let name: String; let detail: String }
    private let gens: [G] = [
        G(id: "coal", emoji: "🏭", name: "Coal (thermal)", detail: "~50% of India's power. Burns coal → steam → turbine → generator. Lots of CO₂."),
        G(id: "hydro", emoji: "🌊", name: "Hydro (water)", detail: "Falling water spins turbine. Bhakra-Nangal dam was a milestone. Cheap, clean."),
        G(id: "solar", emoji: "☀️", name: "Solar", detail: "India's installed solar capacity is 70+ GW. Rajasthan's Bhadla park is world's largest."),
        G(id: "nuclear", emoji: "⚛️", name: "Nuclear", detail: "~3% of India's power. Tarapur, Kudankulam. Lots of energy from a little fuel.")
    ]
    var body: some View {
        ScrollView { LazyVStack(spacing: 14) {
            Text("How India Makes Electricity").font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            ForEach(gens) { g in
                Button { tapped.insert(g.id) } label: {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                        HStack { Text(g.emoji).font(.title2)
                            Text(g.name).font(.headline).foregroundColor(DesignTokens.BrandColor.canvasText) }
                        if tapped.contains(g.id) {
                            Text(g.detail).font(.callout).foregroundColor(DesignTokens.BrandColor.canvasText)
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

