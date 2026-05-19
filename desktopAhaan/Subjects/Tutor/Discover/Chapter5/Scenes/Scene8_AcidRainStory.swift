import SwiftUI

/// Scene 8 — Acid Rain Story.
/// Illustrated scrollable panels: factory -> clouds -> acidic rain -> damage.
/// Rain animation now uses Timer.publish + RainStreak shapes (Big Sur compatible).
struct Scene8_AcidRainStory: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var currentPanel: Int = 0
    @State private var viewedPanels: Set<Int> = [0]
    @State private var tick: TimeInterval = 0

    private let panels: [(title: String, emoji: String, text: String)] = [
        ("Factory Emissions",
         "\u{1F3ED}",
         "Factories and vehicles burn fossil fuels, releasing sulphur dioxide (SO\u{2082}) and nitrogen oxides (NOx) into the air."),
        ("Clouds Absorb Gases",
         "\u{2601}\u{FE0F}",
         "These gases rise into the atmosphere and dissolve in water droplets inside clouds, forming sulphuric acid and nitric acid."),
        ("Rain Becomes Acidic",
         "\u{1F327}\u{FE0F}",
         "When it rains, the water is no longer pure \u{2014} it carries these acids down to Earth. This is called acid rain (pH below 5.6)."),
        ("Damage to Buildings",
         "\u{1F3DB}\u{FE0F}",
         "Acid rain corrodes marble and limestone. The Taj Mahal in Agra has been damaged by acid rain from nearby industries \u{2014} a phenomenon called 'marble cancer'."),
        ("Harm to Nature",
         "\u{1F41F}",
         "Acid rain makes lakes and rivers too acidic for fish and other aquatic life. It also damages leaves and roots of trees, weakening forests."),
    ]

    private var allViewed: Bool { viewedPanels.count >= panels.count }

    var body: some View {
        // ScrollView + LazyVStack: GeometryReader-collapse bug fixed by
        // removing the unused outer GeometryReader; panel + rain animation
        // now flow naturally and rainView's own GeometryReader has a real
        // bounded canvas via its fixed-height frame.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: 14) {
                    Text("Acid Rain Story")
                        .font(.title2.bold())
                        .padding(.top, 18)

                    // Progress dots
                    HStack(spacing: 6) {
                        ForEach(0..<panels.count, id: \.self) { i in
                            Circle()
                                .fill(i == currentPanel ? Color.compatIndigo : (viewedPanels.contains(i) ? Color.green : Color.gray.opacity(0.25)))
                                .frame(width: 10, height: 10)
                        }
                    }

                    // Panel display
                    let panel = panels[currentPanel]
                    SoftShadowCard(padding: 24) {
                        VStack(spacing: 14) {
                            Text(panel.emoji)
                                .font(.system(size: 56))

                            Text(panel.title)
                                .font(.title3.bold())

                            Text(panel.text)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }
                    .frame(maxWidth: 560)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id(currentPanel)

                    // Rain animation (only on rain panel)
                    if currentPanel == 2 {
                        rainView
                            .frame(maxWidth: 400, maxHeight: 80)
                    }

                    // Navigation buttons
                    HStack(spacing: 16) {
                        Button {
                            goPanel(-1)
                        } label: {
                            Label("Back", systemImage: "chevron.left")
                        }

                        .disabled(currentPanel == 0)

                        Spacer()

                        Text("\(currentPanel + 1) / \(panels.count)")
                            .font(.caption.monospacedDigit())
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                        Spacer()

                        Button {
                            goPanel(1)
                        } label: {
                            Label("Next", systemImage: "chevron.right")
                        }

                        .accentColor(Color.compatIndigo)
                        .disabled(currentPanel == panels.count - 1)
                    }
                    .frame(maxWidth: 500)
                }
                .frame(maxWidth: .infinity)

                Group {
                    if allViewed {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Acid Rain", systemImage: "cloud.rain.fill")
                                    .font(.title2.bold())
                                Text("Acid rain is caused by pollution. We can reduce it by using cleaner fuels, reducing emissions, and using catalytic converters in vehicles.")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        LookingAheadCallout(
                            title: "Class 12 Chemistry → JEE (Atmospheric Chem)",
                            detail: "Acid rain mechanism: SO₂ + ½O₂ → SO₃; SO₃ + H₂O → H₂SO₄. And: NO₂ + H₂O → HNO₃ + HNO₂. Coal combustion + car exhaust supplies SO₂ and NOₓ. JEE asks the catalytic-converter chemistry that fixes it: noble-metal beads (Pt/Pd/Rh) oxidise CO + unburnt fuel and reduce NOₓ back to N₂ — three-way catalysis."
                        )
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        TryAtHomeCallout(
                            title: "Lemon-juice mini acid rain",
                            detail: "Sprinkle a few drops of fresh lemon juice on a piece of limestone or chalk. Watch fizzing — CO₂ released as the acid dissolves the carbonate. That's exactly what acid rain does to the Taj Mahal's marble (calcium carbonate) over decades. The damage you see in 5 seconds in your kitchen is what 200 years of pollution does to monuments."
                        )
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                

                }

                .padding(.horizontal, 24)
            

            }

            .frame(maxWidth: .infinity)

            .padding(.bottom, 12)

        }
    }

    // MARK: - Rain animation

    private var rainView: some View {
        Group {
            if reduceMotion {
                HStack(spacing: 8) {
                    ForEach(0..<6, id: \.self) { _ in
                        Image(systemName: "drop.fill")
                            .foregroundColor(Color.blue.opacity(0.5))
                    }
                }
            } else {
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        ForEach(0..<20, id: \.self) { i in
                            RainStreak(index: i, t: tick, size: geo.size)
                        }
                    }
                }
                .timedScene(idealFPS: 20, tick: $tick)
            }
        }
    }

    private func goPanel(_ delta: Int) {
        let next = currentPanel + delta
        guard next >= 0 && next < panels.count else { return }
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
            currentPanel = next
        }
        viewedPanels.insert(next)
    }
}

private struct RainStreak: View {
    let index: Int; let t: TimeInterval; let size: CGSize
    var body: some View {
        let p = compute()
        return Path { path in
            path.move(to: CGPoint(x: CGFloat(p.x), y: CGFloat(p.y)))
            path.addLine(to: CGPoint(x: CGFloat(p.x), y: CGFloat(p.y + 8.0)))
        }
        .stroke(Color.blue, lineWidth: 1.5)
        .opacity(0.5)
    }
    private struct Pos { let x: Double; let y: Double }
    private func compute() -> Pos {
        let seed: Double = Double(index) * 1.7
        let x: Double = (seed * 37.0).truncatingRemainder(dividingBy: Double(size.width))
        let speed: Double = 1.5 + (seed * 0.3).truncatingRemainder(dividingBy: 1.0)
        let yPhase: Double = ((Double(t) * speed + seed).truncatingRemainder(dividingBy: 2.0)) / 2.0
        let y: Double = yPhase * Double(size.height)
        return Pos(x: x, y: y)
    }
}
