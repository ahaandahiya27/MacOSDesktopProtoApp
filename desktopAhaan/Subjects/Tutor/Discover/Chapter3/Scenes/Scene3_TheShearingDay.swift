import SwiftUI

/// Scene 3 — The Shearing Day.
///
/// A drawn sheep. Tap "Start shearing!" — animated clipper runs across the sheep,
/// fleece falls off. Counter: "12 kg fleece harvested."
/// Big Sur (macOS 11) compatible — sheep diagram and clipper marker
/// use Ellipse / Path shapes instead of Canvas blocks.
struct Scene3_TheShearingDay: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var isShearing = false
    @State private var clipperPosition: CGFloat = 0
    @State private var fleecePiles: [FleecePuff] = []
    @State private var harvestedKg: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 18) {
                HStack {
                    Text("The Shearing Day")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color.compatIndigo)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Harvested")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        Text("\(Int(harvestedKg)) kg")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                shearingDiagram

                shearingControls

                Group {
                    SoftShadowCard(padding: 14) {
                        VStack(alignment: .leading, spacing: 6) {
                            Label("Don't worry, it doesn't hurt!", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Sheep are sheared once a year in spring. The fleece grows back quickly and the sheep feels cooler in summer.")
                                .font(.caption)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }
                    .frame(maxWidth: 600)
                    .padding(.horizontal, 24)

                    LookingAheadCallout(
                        title: "Class 12 Economics + NEET ethics",
                        detail: "Shearing season + 'sustainable wool' raise NEET / Class-12 ethics-style questions: cruelty-free certification (RWS standard), carbon cost (sheep methane vs synthetic-fibre fossil CO₂), and animal-welfare law. Whether wool is 'ethical' isn't a yes/no — it's a chain of choices from pasture to label."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    TryAtHomeCallout(
                        title: "Read a wool label",
                        detail: "Find a wool product (shawl, sweater, blanket). Look for these tags: 'RWS' (Responsible Wool Standard — cruelty-free), 'Merino' (breed name = fine wool), 'Pashmina / Cashmere' (goat undercoat from Ladakh / Mongolia). The label is a supply-chain map — country, breed, ethics certification, microns of fineness."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    GotItButton {
                        onComplete()
                    }
                    .padding(.bottom, 12)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    @ViewBuilder
    private var shearingDiagram: some View {
        ZStack(alignment: .topLeading) {
                // Drawn sheep (Shapes, was Canvas) — wrapped in a sized
                // container so the inner .offset coordinates line up with
                // the old Canvas (x, y) values.
                ZStack(alignment: .topLeading) {
                    // Body
                    ZStack {
                        Ellipse().fill(Color(NSColor.controlBackgroundColor))
                        Ellipse().stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    }
                    .frame(width: 140, height: 100)
                    .offset(x: 80, y: 100)

                    // Head
                    ZStack {
                        Ellipse().fill(Color(NSColor.controlBackgroundColor))
                        Ellipse().stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    }
                    .frame(width: 60, height: 60)
                    .offset(x: 140, y: 40)

                    // Eyes
                    Ellipse().fill(Color.primary).frame(width: 6, height: 8).offset(x: 150, y: 55)
                    Ellipse().fill(Color.primary).frame(width: 6, height: 8).offset(x: 175, y: 55)

                    // Legs (4 vertical strokes)
                    Path { p in
                        for legX in [100.0, 130.0, 180.0, 210.0] {
                            p.move(to: CGPoint(x: legX, y: 200))
                            p.addLine(to: CGPoint(x: legX, y: 250))
                        }
                    }
                    .stroke(Color.gray, lineWidth: 3)
                }
                .frame(height: 280)

                // Fleece falling animation
                ForEach(fleecePiles) { puff in
                    Text("💨")
                        .font(.system(size: 32))
                        .position(x: puff.x, y: puff.y)
                        .opacity(puff.opacity)
                }

                // Clipper animation (was a single-ellipse Canvas)
                if isShearing {
                    let clipperX: CGFloat = 80 + clipperPosition * 140
                    Ellipse()
                        .fill(Color.yellow.opacity(0.7))
                        .frame(width: 24, height: 16)
                        .position(x: clipperX, y: 120)
                        .frame(height: 280, alignment: .topLeading)
                }
        }
        .frame(height: 280)
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var shearingControls: some View {
        HStack(spacing: 12) {
            Button {
                performShearing()
            } label: {
                Label(isShearing ? "Shearing..." : "Start Shearing!", systemImage: "scissors")
            }

            .disabled(isShearing)

            if harvestedKg >= 12 {
                Button {
                    resetShearing()
                } label: {
                    Label("Watch Again", systemImage: "arrow.clockwise")
                }

            }
        }
        .padding(.horizontal, 24)
    }

    private func performShearing() {
        withAnimationRespectingReduceMotion(reduceMotion ? .none : .linear(duration: 2)) {
            isShearing = true
            clipperPosition = 1
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000)
            for _ in 0..<8 {
                let puff = FleecePuff(
                    x: CGFloat.random(in: 100...220),
                    y: CGFloat.random(in: 150...200),
                    opacity: 1.0
                )
                withAnimationRespectingReduceMotion(.easeOut(duration: 1.2)) {
                    fleecePiles.append(puff)
                    harvestedKg += 1.5
                }
            }
            try? await Task.sleep(nanoseconds: 1_900_000_000)
            withAnimationRespectingReduceMotion(.easeOut(duration: 1)) {
                for i in fleecePiles.indices {
                    fleecePiles[i].opacity = 0
                }
            }
            isShearing = false
            clipperPosition = 0
        }
    }

    private func resetShearing() {
        fleecePiles.removeAll()
        harvestedKg = 0
        isShearing = false
        clipperPosition = 0
    }
}

private struct FleecePuff: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var opacity: Double
}
