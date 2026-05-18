import SwiftUI

/// Scene 5 — Galvanisation Shield.
/// Iron pipe exposed to rain rusts. Then zinc coating applied (galvanisation).
/// Rain hits but no rust. Shows zinc protecting iron. Also mentions painting, oiling, alloying.
///
/// Big Sur (macOS 11) compatible — rain Canvas + TimelineView replaced with
/// a Timer.publish + ForEach of GalvRainDrop subviews.
struct Scene5_GalvanisationShield: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var step: GalvStep = .exposed
    @State private var rustLevel: CGFloat = 0
    @State private var rainActive = false
    @State private var tick: TimeInterval = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private enum GalvStep: Int, CaseIterable {
        case exposed    // iron pipe + rain = rust
        case coating    // applying zinc layer
        case protected  // galvanised pipe + rain = no rust
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
                    Text("Galvanisation Shield")
                        .font(.largeTitle.bold())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .padding(.top, 18)

                    Text("How do we stop iron from rusting?")
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                    Spacer()

                    // Pipe visual
                    ZStack {
                        // Rain (Timer-driven; Big Sur compatible)
                        if rainActive && !reduceMotion {
                            GeometryReader { rgeo in
                                ZStack(alignment: .topLeading) {
                                    ForEach(0..<15, id: \.self) { i in
                                        GalvRainDrop(index: i, t: tick, size: rgeo.size)
                                    }
                                }
                            }
                            .frame(width: 300, height: 250)
                            .allowsHitTesting(false)
                        }

                        // The pipe
                        VStack(spacing: 0) {
                            // Top cap
                            RoundedRectangle(cornerRadius: 4)
                                .fill(pipeColor)
                                .frame(width: 60, height: 10)

                            // Body
                            RoundedRectangle(cornerRadius: 6)
                                .fill(pipeColor)
                                .frame(width: 50, height: 160)
                                .overlay(
                                    // Zinc coating layer
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(
                                            step == .protected ? Color.compatMint.opacity(0.8) : .clear,
                                            lineWidth: step == .protected ? 5 : 0
                                        )
                                )

                            // Bottom cap
                            RoundedRectangle(cornerRadius: 4)
                                .fill(pipeColor)
                                .frame(width: 60, height: 10)
                        }

                        // Zinc label
                        if step == .coating || step == .protected {
                            Text("Zn")
                                .font(.title3.bold())
                                .foregroundColor(Color.compatMint)
                                .offset(x: 50)
                                .transition(.opacity)
                        }

                        // Rust spots
                        if step == .exposed && rustLevel > 0.3 {
                            ForEach(0..<Int(rustLevel * 6), id: \.self) { i in
                                Circle()
                                    .fill(Color.compatBrown.opacity(0.7))
                                    .frame(width: CGFloat.random(in: 5...12))
                                    .offset(
                                        x: CGFloat([-18, -8, 5, 15, -12, 10][i % 6]),
                                        y: CGFloat([-50, -20, 10, 40, 60, -35][i % 6])
                                    )
                            }
                        }
                    }
                    .frame(width: 300, height: 250)
                    .accessibilityLabel(stepDescription)

                    // Step controls
                    HStack(spacing: 16) {
                        Button("Expose to rain") {
                            step = .exposed
                            rainActive = true
                            withAnimation(reduceMotion ? .none : .easeInOut(duration: 2.0)) {
                                rustLevel = 1.0
                            }
                        }
                        
                        .accentColor(Color.compatCyan)
                        .disabled(step != .exposed || rainActive)

                        Button("Apply zinc coating") {
                            withAnimation(reduceMotion ? .none : .spring()) {
                                step = .coating
                                rainActive = false
                                rustLevel = 0
                            }
                            Task { @MainActor in
                                try? await Task.sleep(nanoseconds: 1_000_000_000)
                                withAnimation {
                                    step = .protected
                                    rainActive = true
                                }
                            }
                        }
                        
                        .accentColor(Color.compatMint)
                        .disabled(step != .exposed || !rainActive)
                    }

                    Text(stepLabel)
                        .font(.headline)
                        .foregroundColor(step == .protected ? .green : (step == .exposed && rustLevel > 0 ? Color.compatBrown : .secondary))

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Preventing rust", systemImage: SFSymbolCompat.name("shield.lefthalf.filled"))
                                .font(.title2.bold())
                            Text("Galvanisation coats iron with a layer of zinc. Even if scratched, zinc reacts first, protecting the iron underneath. Other methods include:")
                                .font(.body)
                                .lineSpacing(4)
                            HStack(spacing: 20) {
                                methodBadge(icon: "paintbrush.fill", label: "Painting", color: .blue)
                                methodBadge(icon: "drop.fill", label: "Oiling / greasing", color: .yellow)
                                methodBadge(icon: "circle.grid.cross.fill", label: "Alloying\n(stainless steel)", color: .gray)
                            }
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 12 Chemistry → JEE (Sacrificial Anode)",
                        detail: "Galvanisation = coating iron with zinc. Zinc is MORE reactive than iron, so it corrodes first (sacrificially), keeping iron intact. JEE asks the reactivity series — K > Na > Ca > Mg > Al > Zn > Fe > Cu > Ag > Au. Ships use giant zinc blocks bolted to the hull (called sacrificial anodes) — they get eaten so the steel hull doesn't. Same trick: 5 km long bridges, 5 kg blocks."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Spot a sacrificial anode",
                        detail: "Next to any boat at a marina, look for chunky grey-white metal blocks bolted to the hull below the waterline — those are zinc or aluminium sacrificial anodes. You can also spot them on home water heater tanks (a rod called the 'anode rod' lasts ~5 years, then replaced). Cheaper to replace a sacrificial rod than rebuild a tank."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
        .timedScene(idealFPS: 20, tick: $tick)
    }

    private var pipeColor: Color {
        if step == .exposed && rustLevel > 0.3 {
            return Color.compatBrown.opacity(0.6 + Double(rustLevel) * 0.4)
        }
        if step == .protected { return .gray }
        return .gray
    }

    private var stepLabel: String {
        switch step {
        case .exposed:
            return rustLevel > 0 ? "Iron rusts in rain!" : "Tap to expose to rain"
        case .coating:
            return "Applying zinc coating..."
        case .protected:
            return "Protected! No rust even in rain."
        }
    }

    private var stepDescription: String {
        switch step {
        case .exposed: return "Bare iron pipe exposed to rain, developing rust"
        case .coating: return "Zinc coating being applied to the iron pipe"
        case .protected: return "Galvanised pipe in rain, no rust forming"
        }
    }

    private func methodBadge(icon: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
}

// MARK: - Rain drop subview

private struct GalvRainDrop: View {
    let index: Int
    let t: TimeInterval
    let size: CGSize

    var body: some View {
        let p = compute()
        return Path { path in
            path.move(to: CGPoint(x: CGFloat(p.x), y: CGFloat(p.y)))
            path.addLine(to: CGPoint(x: CGFloat(p.x), y: CGFloat(p.y + 10)))
        }
        .stroke(Color.compatCyan, lineWidth: 1.5)
        .opacity(0.4)
    }

    private struct DropPos { let x: Double; let y: Double }

    private func compute() -> DropPos {
        let seed: Double = Double(index) * 3.14
        let x: Double = (seed * 53.0).truncatingRemainder(dividingBy: 1.0) * Double(size.width)
        let raw: Double = Double(t) * 120.0 + seed * 40.0
        let y: Double = raw.truncatingRemainder(dividingBy: Double(size.height))
        return DropPos(x: x, y: y)
    }
}
