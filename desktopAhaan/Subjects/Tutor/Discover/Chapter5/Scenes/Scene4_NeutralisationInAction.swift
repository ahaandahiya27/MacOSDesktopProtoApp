import SwiftUI

/// Scene 4 — Neutralisation in Action.
/// Animated beaker: acid (red) + base (blue) mix to green. H+ and OH- ions combine.
///
/// Big Sur (macOS 11) compatible — the ion animation Canvas is replaced
/// with a Timer.publish + ForEach of small Hion / OHion / WaterMolecule
/// subviews.
struct Scene4_NeutralisationInAction: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var pourProgress: CGFloat = 0       // 0 = not started, 1 = fully mixed
    @State private var isPouring = false
    @State private var showEquation = false
    @State private var tick: TimeInterval = 0
    @State private var basemL: Double = 0               // free-play slider — ml of NaOH added

    private var mixedColor: Color {
        Color(
            red: 1.0 - pourProgress * 0.7,
            green: 0.2 + pourProgress * 0.6,
            blue: pourProgress * 0.6
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
                    Text("Neutralisation in Action")
                        .font(.title2.bold())
                        .padding(.top, 18)

                    // Beakers row
                    HStack(spacing: 30) {
                        // Acid beaker
                        beaker(label: "Acid (HCl)", color: .red, tiltAngle: isPouring ? -30 : 0)
                            .frame(width: 100, height: 140)

                        // Central mixing beaker
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.gray.opacity(0.08))
                                .frame(width: 120, height: 160)

                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(mixedColor.opacity(0.7))
                                .frame(width: 112, height: 80 + pourProgress * 50)
                                .animation(reduceMotion ? .none : .easeInOut(duration: 1.5))

                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .strokeBorder(.gray.opacity(0.4), lineWidth: 2)
                                .frame(width: 120, height: 160)
                        }

                        // Base beaker
                        beaker(label: "Base (NaOH)", color: .blue, tiltAngle: isPouring ? 30 : 0)
                            .frame(width: 100, height: 140)
                    }
                    .padding(.top, 10)

                    // Pour button
                    if !isPouring && pourProgress < 1 {
                        Button {
                            startPouring()
                        } label: {
                            Label("Pour & Mix!", systemImage: "drop.triangle.fill")
                                .font(.headline)
                        }
                        
                        .accentColor(Color.compatIndigo)
                    }

                    // Ion animation area
                    if isPouring || pourProgress > 0 {
                        ionAnimationView
                            .frame(maxWidth: 500, maxHeight: 120)
                    }

                    // Equation
                    if showEquation {
                        SoftShadowCard(padding: 14) {
                            VStack(spacing: 8) {
                                Text("Acid + Base \u{2192} Salt + Water")
                                    .font(.system(.title3, design: .monospaced).bold())
                                    .foregroundColor(Color.compatIndigo)
                                Text("HCl + NaOH \u{2192} NaCl + H\u{2082}O")
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: 500)
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    }

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Neutralisation", systemImage: SFSymbolCompat.name("flask.fill"))
                                .font(.title2.bold())
                            Text("When an acid and a base react, they neutralise each other to form a salt and water. The H\u{207A} ions from the acid combine with OH\u{207B} ions from the base.")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    DiscoveryWidget(
                        title: "Discovery — add base drop by drop",
                        subtitle: "Imagine adding NaOH base to 10 mL of HCl acid. Drag the slider to see the pH change.",
                        value: $basemL,
                        range: 0...10,
                        step: 0.5,
                        valueLabel: { v in String(format: "Added: %.1f mL", v) },
                        output: pHExplanation
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if pourProgress >= 1 {
            RelatedConceptsCallout(
                title: "Related: Ch 6 (Phys/Chem Changes), Ch 9 (Soil), Ch 18 (Wastewater)",
                detail: "Neutralisation is one of Chapter 6's classic chemical changes (new substance formed). Farmers use it on acidic soil (Ch 9 — add lime). Treatment plants use it on acidic industrial effluent (Ch 18 — neutralise before release)."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 / 12 Chemistry → JEE (Thermochemistry)",
                detail: "Neutralisation releases heat: ΔH = -57.1 kJ/mol for any strong-acid + strong-base in water — surprisingly constant. JEE asks why: because the underlying reaction is always H⁺(aq) + OH⁻(aq) → H₂O(l), regardless of what salt ions hang around. The constant heat of neutralisation is itself proof of the ionic theory."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Feel neutralisation warming",
                detail: "Pour 50 ml of vinegar in a glass. Touch the outside — room temperature. Add a teaspoon of baking soda. Fizzing starts (CO₂). Touch again after 30 seconds — slightly warmer. That tiny temperature rise is the heat of neutralisation, demonstrable with a kitchen thermometer to ±1°C accuracy."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Subviews

    private func beaker(label: String, color: Color, tiltAngle: Double) -> some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.gray.opacity(0.08))
                    .frame(width: 60, height: 90)

                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(color.opacity(isPouring ? 0.3 : 0.6))
                    .frame(width: 54, height: isPouring ? 30 : 60)
                    .animation(reduceMotion ? .none : .easeInOut(duration: 1.2))

                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(.gray.opacity(0.4), lineWidth: 1.5)
                    .frame(width: 60, height: 90)
            }
            .rotationEffect(.degrees(tiltAngle))
            .animation(reduceMotion ? .none : .easeInOut(duration: 0.8))

            Text(label)
                .font(.caption.weight(.medium))
        }
    }

    private var ionAnimationView: some View {
        Group {
            if reduceMotion {
                HStack(spacing: 16) {
                    Text("H\u{207A}")
                        .font(.title2.bold())
                        .foregroundColor(.red)
                    Text("+")
                        .font(.title2)
                    Text("OH\u{207B}")
                        .font(.title2.bold())
                        .foregroundColor(.blue)
                    Text("\u{2192}")
                        .font(.title2)
                    Text("H\u{2082}O")
                        .font(.title2.bold())
                        .foregroundColor(.green)
                }
            } else {
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        ForEach(0..<4, id: \.self) { i in
                            HIon(index: i, t: tick, size: geo.size)
                        }
                        ForEach(0..<4, id: \.self) { i in
                            OHIon(index: i, t: tick, size: geo.size)
                        }
                        ForEach(0..<3, id: \.self) { i in
                            WaterMolecule(index: i, t: tick, size: geo.size)
                        }
                    }
                }
                .timedScene(idealFPS: 20, tick: $tick)
            }
        }
    }

    // MARK: - Actions

    private func pHExplanation(_ ml: Double) -> String {
        // Simple acid-base model: 10 mL of strong acid + ml mL of equally strong base.
        // pH ~ 1 at start, ~7 at 5 mL (halfway), basic >5 mL.
        let approxPH: Double
        switch ml {
        case 0: approxPH = 1
        case ..<2: approxPH = 1 + ml
        case ..<4.5: approxPH = 3 + (ml - 2) * 1.2
        case 4.5..<5.5: approxPH = 7   // neutral plateau
        case ..<7: approxPH = 7 + (ml - 5.5) * 1.6
        default: approxPH = 11 + min(2, (ml - 7) * 0.6)
        }
        let phStr = String(format: "pH ≈ %.1f", approxPH)
        let label: String
        switch approxPH {
        case ..<3: label = "Strongly acidic — sour, dissolves marble."
        case ..<6: label = "Mildly acidic — turns blue litmus red."
        case 6...8: label = "Neutral — salt + water formed. Reaction complete!"
        case ..<11: label = "Mildly basic — turns red litmus blue."
        default: label = "Strongly basic — soapy, dissolves grease."
        }
        return "\(phStr). \(label)"
    }

    private func startPouring() {
        isPouring = true
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 2.0)) {
            pourProgress = 1.0
        }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_200_000_000)
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.4)) {
                showEquation = true
            }
        }
    }
}

// MARK: - Ion / molecule subviews

private struct HIon: View {
    let index: Int; let t: TimeInterval; let size: CGSize
    var body: some View {
        let p = compute()
        return Circle()
            .fill(Color.red)
            .frame(width: 16, height: 16)
            .opacity(p.opacity)
            .position(x: CGFloat(p.x), y: CGFloat(p.y))
    }
    private struct DotPos { let x: Double; let y: Double; let opacity: Double }
    private func compute() -> DotPos {
        let cx: Double = Double(size.width) * 0.5
        let cy: Double = Double(size.height) * 0.5
        let phase: Double = ((Double(t) * 0.8 + Double(index) * 0.6).truncatingRemainder(dividingBy: 3.0)) / 3.0
        let x: Double = Double(size.width) * 0.1 + phase * (cx - Double(size.width) * 0.1)
        let y: Double = cy + sin(Double(t) * 2.0 + Double(index)) * 15.0
        let opacity: Double = 1.0 - phase * 0.5
        return DotPos(x: x, y: y, opacity: opacity)
    }
}

private struct OHIon: View {
    let index: Int; let t: TimeInterval; let size: CGSize
    var body: some View {
        let p = compute()
        return Circle()
            .fill(Color.blue)
            .frame(width: 16, height: 16)
            .opacity(p.opacity)
            .position(x: CGFloat(p.x), y: CGFloat(p.y))
    }
    private struct DotPos { let x: Double; let y: Double; let opacity: Double }
    private func compute() -> DotPos {
        let cx: Double = Double(size.width) * 0.5
        let cy: Double = Double(size.height) * 0.5
        let phase: Double = ((Double(t) * 0.8 + Double(index) * 0.6).truncatingRemainder(dividingBy: 3.0)) / 3.0
        let x: Double = Double(size.width) * 0.9 - phase * (Double(size.width) * 0.9 - cx)
        let y: Double = cy + cos(Double(t) * 2.0 + Double(index)) * 15.0
        let opacity: Double = 1.0 - phase * 0.5
        return DotPos(x: x, y: y, opacity: opacity)
    }
}

private struct WaterMolecule: View {
    let index: Int; let t: TimeInterval; let size: CGSize
    var body: some View {
        let p = compute()
        return Circle()
            .fill(Color.green)
            .frame(width: 12, height: 12)
            .opacity(0.6)
            .position(x: CGFloat(p.x), y: CGFloat(p.y))
    }
    private struct DotPos { let x: Double; let y: Double }
    private func compute() -> DotPos {
        let cx: Double = Double(size.width) * 0.5
        let cy: Double = Double(size.height) * 0.5
        let spread: Double = sin(Double(t) + Double(index) * 2.0) * 20.0
        let x: Double = cx + spread
        let y: Double = cy + cos(Double(t) + Double(index)) * 10.0
        return DotPos(x: x, y: y)
    }
}
