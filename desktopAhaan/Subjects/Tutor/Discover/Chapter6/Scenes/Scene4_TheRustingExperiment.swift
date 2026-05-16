import SwiftUI

/// Scene 4 — The Rusting Experiment.
/// Three test tubes showing that rusting needs BOTH water AND oxygen.
/// (1) nail in water+air = rust, (2) nail in boiled water (no air) = no rust,
/// (3) nail in dry air (CaCl2) = no rust.
///
/// Big Sur (macOS 11) compatible — rust-particle Canvas + TimelineView are
/// replaced by a Timer.publish + ForEach of RustParticle subviews.
struct Scene4_TheRustingExperiment: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var tubeProgress: [CGFloat] = [0, 0, 0]  // 0..1 per tube
    @State private var fastForwarded: Set<Int> = []
    @State private var tick: TimeInterval = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var allDone: Bool { fastForwarded.count == 3 }

    private struct TubeData {
        let title: String
        let contents: String
        let hasWater: Bool
        let hasAir: Bool
        let rusts: Bool
        let explanation: String
    }

    private let tubes: [TubeData] = [
        TubeData(
            title: "Tube A",
            contents: "Water + Air",
            hasWater: true, hasAir: true, rusts: true,
            explanation: "Both water and oxygen present — the nail rusts."
        ),
        TubeData(
            title: "Tube B",
            contents: "Boiled water\n(no dissolved air)",
            hasWater: true, hasAir: false, rusts: false,
            explanation: "Water but no oxygen — the nail does NOT rust."
        ),
        TubeData(
            title: "Tube C",
            contents: "Dry air + CaCl₂\n(no moisture)",
            hasWater: false, hasAir: true, rusts: false,
            explanation: "Oxygen but no water — the nail does NOT rust."
        ),
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
                    Text("The Rusting Experiment")
                        .font(.largeTitle.bold())
                        .padding(.top, 18)

                    Text("Three test tubes, same iron nail. Tap each to fast-forward 2 weeks.")
                        .font(.callout)
                        .foregroundColor(.secondary)

                    // Three test tubes
                    HStack(spacing: 28) {
                        ForEach(0..<3, id: \.self) { i in
                            testTubeView(index: i, height: min(geo.size.height * 0.4, 280))
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 14) {
                    Spacer()

                    if allDone {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Conclusion", systemImage: "checkmark.seal.fill")
                                    .font(.title2.bold())
                                    .foregroundColor(Color.compatIndigo)
                                Text("Rusting requires BOTH water AND oxygen. Remove either one and the iron nail stays shiny. Rusting is a chemical change: Iron + Water + Oxygen → Iron oxide (rust). This is why we keep iron objects dry and painted.")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    } else {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("What does iron need to rust?", systemImage: SFSymbolCompat.name("flask.fill"))
                                    .font(.title2.bold())
                                Text("Tap each test tube to fast-forward 2 weeks and see what happens to the nail.")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
        .timedScene(idealFPS: 15, tick: $tick)
    }

    @ViewBuilder
    private func testTubeView(index: Int, height: CGFloat) -> some View {
        let tube = tubes[index]
        let progress = tubeProgress[index]
        let done = fastForwarded.contains(index)

        VStack(spacing: 8) {
            Text(tube.title)
                .font(.headline)

            // The test tube
            ZStack(alignment: .bottom) {
                // Tube outline
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.gray.opacity(0.05))
                    .frame(width: 80, height: height)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(.gray.opacity(0.3), lineWidth: 1.5)
                    )

                // Water fill
                if tube.hasWater {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.compatCyan.opacity(0.2))
                        .frame(width: 70, height: height * 0.6)
                        .padding(.bottom, 4)
                }

                // Nail
                VStack(spacing: 0) {
                    Circle()
                        .fill(nailColor(rusts: tube.rusts, progress: progress))
                        .frame(width: 14, height: 14)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(nailColor(rusts: tube.rusts, progress: progress))
                        .frame(width: 6, height: height * 0.35)
                }
                .padding(.bottom, height * 0.15)

                // Rust particles (Timer-driven; Big Sur compatible)
                if tube.rusts && progress > 0.2 && !reduceMotion {
                    GeometryReader { rgeo in
                        ZStack(alignment: .topLeading) {
                            ForEach(0..<Int(progress * 10), id: \.self) { j in
                                RustParticle(index: j, t: tick, progress: Double(progress), size: rgeo.size)
                            }
                        }
                    }
                    .frame(width: 70, height: height)
                    .allowsHitTesting(false)
                }

                // CaCl2 desiccant indicator
                if !tube.hasWater && tube.hasAir {
                    Text("CaCl₂")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.orange)
                        .padding(.bottom, 8)
                }
            }
            .frame(width: 80, height: height)

            // Labels
            Text(tube.contents)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(width: 100)

            if done {
                Text(tube.rusts ? "RUSTED" : "No rust")
                    .font(.caption.bold())
                    .foregroundColor(tube.rusts ? Color.compatBrown : .green)
            }

            // Fast-forward button
            Button("Fast-forward") {
                fastForward(index)
            }
            
            .controlSize(.small)
            .disabled(done)
        }
        .accessibilityLabel("\(tube.title): \(tube.contents). \(done ? (tube.rusts ? "Rusted" : "No rust") : "Tap fast-forward.")")
    }

    private func fastForward(_ index: Int) {
        fastForwarded.insert(index)
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 1.5)) {
            tubeProgress[index] = 1.0
        }
    }

    private func nailColor(rusts: Bool, progress: CGFloat) -> Color {
        guard rusts else { return .gray }
        if progress < 0.1 { return .gray }
        if progress < 0.5 { return .orange }
        return Color.compatBrown
    }
}

// MARK: - Rust particle subview

private struct RustParticle: View {
    let index: Int
    let t: TimeInterval
    let progress: Double
    let size: CGSize

    var body: some View {
        let p = compute()
        return Circle()
            .fill(Color.compatBrown)
            .frame(width: 6, height: 6)
            .opacity(p.opacity)
            .position(x: CGFloat(p.x), y: CGFloat(p.y))
    }

    private struct ParticlePos { let x: Double; let y: Double; let opacity: Double }

    private func compute() -> ParticlePos {
        let seed: Double = Double(index) * 2.71
        let x: Double = (seed * 47.0).truncatingRemainder(dividingBy: 1.0) * Double(size.width) * 0.6 + Double(size.width) * 0.2
        let baseY: Double = Double(size.height) * 0.7 + Double(index) * 3.0
        let wobble: Double = sin(Double(t) * 1.5 + seed) * 2.0
        let y: Double = baseY + wobble
        let opacity: Double = progress * 0.7
        return ParticlePos(x: x, y: y, opacity: opacity)
    }
}
