import SwiftUI

/// Scene 7 — Crystal Garden.
/// Supersaturated solution simulation: heat water, add salt, cool slowly, watch crystals grow.
/// Tap stages to advance. Shows seed crystal triggering rapid growth.

struct Scene7_CrystalGarden: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var stage: CrystalStage = .water
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private enum CrystalStage: Int, CaseIterable {
        case water       // plain water in beaker
        case heating     // boiling, dissolving salt
        case saturated   // clear hot solution
        case cooling     // slow cool, seed crystal dropped
        case grown       // beautiful crystals formed
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Crystal Garden")
                .font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .padding(.top, 18)

            Text("Grow crystals from a supersaturated solution")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            Spacer()

            // Beaker visual
            ZStack {
                // Beaker outline
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(.gray.opacity(0.5), lineWidth: 2)
                    .frame(width: 160, height: 200)

                // Liquid
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(liquidColor)
                        .frame(width: 156, height: liquidHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .frame(width: 160, height: 200)

                // Bubbles when heating
                if stage == .heating && !reduceMotion {
                    ForEach(0..<6, id: \.self) { i in
                        Circle()
                            .fill(.white.opacity(0.6))
                            .frame(width: CGFloat([5, 7, 4, 6, 5, 8][i]))
                            .offset(
                                x: CGFloat([-30, -10, 15, 25, -20, 5][i]),
                                y: CGFloat([40, 50, 55, 45, 60, 35][i])
                            )
                            .opacity(stage == .heating ? 1 : 0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(Double(i) * 0.15))
                    }
                }

                // Salt grains dissolving
                if stage == .heating {
                    ForEach(0..<4, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 1)
                            .fill(.white.opacity(0.5))
                            .frame(width: 4, height: 4)
                            .offset(
                                x: CGFloat([-20, 10, -5, 22][i]),
                                y: CGFloat([10, 25, -5, 15][i])
                            )
                    }
                }

                // Seed crystal
                if stage == .cooling || stage == .grown {
                    Text("*")
                        .font(.title3.bold())
                        .foregroundColor(.purple)
                        .offset(y: 20)
                }

                // Grown crystals
                if stage == .grown {
                    ForEach(0..<7, id: \.self) { i in
                        crystalShape(index: i)
                    }
                }

                // Flame under beaker
                if stage == .heating {
                    VStack {
                        Spacer()
                        HStack(spacing: 4) {
                            Text("\u{1F525}")
                            Text("\u{1F525}")
                            Text("\u{1F525}")
                        }
                        .font(.title3)
                    }
                    .frame(width: 160, height: 230)
                }
            }
            .frame(width: 200, height: 250)
            .accessibilityLabel(stageDescription)

            // Stage buttons
            HStack(spacing: 12) {
                ForEach(CrystalStage.allCases, id: \.rawValue) { s in
                    Button(stageLabel(s)) {
                        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.5)) {
                            stage = s
                        }
                    }
                    .buttonStyle(.bordered)
                    .accentColor(stage == s ? .purple : .secondary)
                    .disabled(s.rawValue > stage.rawValue + 1)
                }
            }

            Text(stageCaption)
                .font(.headline)
                .foregroundColor(.purple)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 500)
                .padding(.horizontal)

            Spacer()

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Crystallisation", systemImage: "diamond.fill")
                        .font(.title2.bold())
                    Text("When a hot, saturated solution cools slowly, dissolved particles arrange themselves into a regular pattern \u{2014} a crystal. A tiny seed crystal gives molecules a template to latch onto, and the crystal grows layer by layer. This is a physical change because no new substance is formed.")
                        .font(.body)
                        .lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            // Group { } collapses the 2 pedagogical callouts to a single
            // ViewBuilder child so the outer VStack stays under Swift 5.5's
            // 10-child cap (Xcode 13.2.1 enforces strictly; newer Xcode
            // accepts 11 silently).
            Group {
                LookingAheadCallout(
                    title: "Class 12 Chemistry → JEE (Crystal Lattices)",
                    detail: "Crystals = atoms arranged in regular repeating 3D patterns. JEE Solid State chapter covers 7 crystal systems (cubic, tetragonal, orthorhombic, hexagonal, …) and 4 Bravais centerings. NaCl, sucrose, copper sulphate — all classifiable. Same chemistry idea that lets a kid grow crystal candy lets industrial chemists design transistors and gemstones."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Grow your own crystal in 3 days",
                    detail: "Dissolve a heaped half-cup of sugar in a half-cup of hot water until it stops dissolving. Pour into a clean jar. Hang a wooden stick (skewer) from a pencil across the rim so it dangles in the syrup. Place somewhere undisturbed. By day 3 you'll see geometric crystals on the stick — rock candy. The 'unit cell' is repeating itself thousands of times to make your snack."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)
            }

            GotItButton { onComplete() }
                .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Visuals

    private var liquidColor: Color {
        switch stage {
        case .water: return Color.compatCyan.opacity(0.3)
        case .heating: return Color.compatCyan.opacity(0.5)
        case .saturated: return Color.compatCyan.opacity(0.6)
        case .cooling: return Color.compatCyan.opacity(0.4)
        case .grown: return Color.compatCyan.opacity(0.25)
        }
    }

    private var liquidHeight: CGFloat {
        switch stage {
        case .water: return 120
        case .heating: return 130
        case .saturated: return 125
        case .cooling: return 120
        case .grown: return 100
        }
    }

    private func crystalShape(index: Int) -> some View {
        let offsets: [(CGFloat, CGFloat)] = [
            (-25, 50), (-10, 40), (5, 55), (20, 45),
            (-15, 60), (10, 65), (0, 35)
        ]
        let sizes: [CGFloat] = [12, 16, 10, 14, 11, 13, 18]
        let rotations: [Double] = [15, -20, 30, -10, 45, -30, 0]

        return Diamond()
            .fill(.purple.opacity(0.7))
            .frame(width: sizes[index], height: sizes[index] * 1.4)
            .rotationEffect(.degrees(rotations[index]))
            .offset(x: offsets[index].0, y: offsets[index].1)
    }

    private func stageLabel(_ s: CrystalStage) -> String {
        switch s {
        case .water: return "Water"
        case .heating: return "Heat + Salt"
        case .saturated: return "Saturated"
        case .cooling: return "Cool + Seed"
        case .grown: return "Crystals!"
        }
    }

    private var stageCaption: String {
        switch stage {
        case .water: return "Start with plain water in a beaker."
        case .heating: return "Heat the water and dissolve lots of salt until no more dissolves."
        case .saturated: return "The solution is now saturated \u{2014} it holds maximum dissolved salt."
        case .cooling: return "Cool slowly and drop in a tiny seed crystal..."
        case .grown: return "Beautiful crystals have grown on the seed! \u{2728}"
        }
    }

    private var stageDescription: String {
        switch stage {
        case .water: return "Beaker with plain water"
        case .heating: return "Water being heated with salt dissolving"
        case .saturated: return "Clear saturated solution"
        case .cooling: return "Solution cooling with seed crystal added"
        case .grown: return "Purple crystals grown in the beaker"
        }
    }
}

/// Simple diamond shape for crystal visuals.
private struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        p.closeSubpath()
        return p
    }
}
