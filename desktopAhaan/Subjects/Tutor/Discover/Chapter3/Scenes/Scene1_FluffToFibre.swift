import SwiftUI

/// Scene 1 — From Fluff to Fibre.
///
/// Three glowing icons (🐑 sheep, 🐛 silkworm, 🌿 cotton) drift in from the edges.
/// Tapping each makes a thread emerge and weave into a small piece of fabric on the right.
/// Caption explains these sources give us most fabrics.
///
/// Big Sur (macOS 11) compatible — the drifting-icon TimelineView is
/// replaced with a Timer.publish + a small DriftingIcon view per icon;
/// the fabric Canvas becomes a Shape (FabricWeaveShape) drawn behind the
/// fabric panel.
struct Scene1_FluffToFibre: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var showSheep = false
    @State private var showSilkworm = false
    @State private var showCotton = false
    @State private var threadsWoven = 0
    @State private var tick: TimeInterval = 0
    @State private var fibreLengthMM: Double = 22       // free-play slider: cotton staple length
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var kidFriendlyExplanation: String {
        pack.conceptIndex["ch03_t01_c01"]?.explanation(at: .kidFriendly)
            ?? "These three living things give us most of the world's fabrics."
    }

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack so
        // explanation cards don't cover the interactive content. The
        // drifting-icon animation needs a GeometryReader for its
        // size-relative positioning; that lives in a fixed-height
        // wrapper at the top.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                // 2026-05-22 fix: same layout-recursion class as Scene1
                // (Plant Kitchen). GeometryReader inside LazyVStack inside
                // ScrollView with only height constrained → Big Sur
                // _NSDetectedLayoutRecursion. Capping max-width forces a
                // determinate proposal to GeometryReader, matching the
                // safe pattern used by Scene8_NitrogenCycle.
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        // Drifting icons
                        DriftingIcon(emoji: "🐑", baseX: 0.15, baseY: 0.3,
                                     phaseOffset: 0.0, t: tick, size: geo.size,
                                     onTap: { tapIcon("🐑") })
                        DriftingIcon(emoji: "🐛", baseX: 0.15, baseY: 0.5,
                                     phaseOffset: 1.0, t: tick, size: geo.size,
                                     onTap: { tapIcon("🐛") })
                        DriftingIcon(emoji: "🌿", baseX: 0.15, baseY: 0.7,
                                     phaseOffset: 2.0, t: tick, size: geo.size,
                                     onTap: { tapIcon("🌿") })

                        // Fabric weaving on the right
                        fabricPanel(geoSize: geo.size)
                    }
                }
                .frame(maxWidth: 600)
                .frame(height: 280)

                // Caption + button
                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Label("From Fluff to Fibre", systemImage: "sparkles")
                                .font(.title2.bold())
                                .foregroundColor(Color.compatIndigo)
                            Text(kidFriendlyExplanation)
                                .font(.body)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    DiscoveryWidget(
                        title: "Discovery — pick a fibre length",
                        subtitle: "Cotton, wool, jute and silk are graded by fibre length (called 'staple'). Drag to see what each length is good for.",
                        value: $fibreLengthMM,
                        range: 5...50,
                        step: 1,
                        valueLabel: { v in String(format: "Length: %.0f mm", v) },
                        output: fibreGradeExplanation
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 12 Chemistry → JEE",
                        detail: "Cotton, jute, silk, wool — all polymers. Cotton + jute are cellulose (β-1,4 glucose chain, plant-made). Silk + wool are proteins (amino-acid chains, animal-made). JEE Organic Chem asks 'why does silk burn smelling of hair?' — because silk fibroin and your hair are both protein. Polymer chemistry is the through-line from this fluff to industrial synthesis."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    TryAtHomeCallout(
                        title: "Burn-test cotton vs polyester",
                        detail: "Snip one thread of cotton and one of polyester (read garment labels first). Hold each with tweezers and touch a candle flame (with adult). Cotton burns fast, smells like burning paper, leaves grey ash. Polyester melts into a shrinking ball, smells chemical, leaves a hard bead. Same test forensic scientists use on fibre evidence."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    GotItButton {
                        onComplete()
                    }
                    .padding(.bottom, DesignTokens.Spacing.md)
                
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)
            
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
        .timedScene(idealFPS: 30, tick: $tick)
    }

    private func fabricPanel(geoSize: CGSize) -> some View {
        let panelX: CGFloat = geoSize.width * 0.8
        let panelY: CGFloat = geoSize.height * 0.35
        return VStack {
            Text("Fabric Woven")
                .font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 140, height: 100)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 140, height: 100)
                FabricWeaveShape(threads: threadsWoven)
                    .stroke(Color.compatIndigo.opacity(0.7), lineWidth: 2)
                    .frame(width: 140, height: 100)
            }
            .frame(width: 180, height: 150)
        }
        .padding(DesignTokens.Spacing.lg)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .position(x: panelX, y: panelY)
    }

    private func fibreGradeExplanation(_ mm: Double) -> String {
        switch mm {
        case ..<10:
            return "Short staple — coarse fibres like jute or coir. Used for ropes, gunny sacks, doormats."
        case ..<25:
            return "Medium staple — most everyday cotton. Used for kurta, t-shirts, bedsheets."
        case ..<35:
            return "Long staple — fine textiles. Egyptian cotton, Pima cotton — luxury shirts and Pochampally sarees."
        default:
            return "Extra-long staple or silk — premium grade. Smooth, lustrous fabrics like silk sarees, fine suits."
        }
    }

    private func tapIcon(_ emoji: String) {
        withAnimationRespectingReduceMotion(reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.6)) {
            switch emoji {
            case "🐑": showSheep = true
            case "🐛": showSilkworm = true
            case "🌿": showCotton = true
            default: break
            }
            if threadsWoven < 12 {
                threadsWoven += 1
            }
        }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 600_000_000)
            withAnimationRespectingReduceMotion(.easeOut(duration: 0.4)) {
                switch emoji {
                case "🐑": showSheep = false
                case "🐛": showSilkworm = false
                case "🌿": showCotton = false
                default: break
                }
            }
        }
    }
}

/// One emoji icon that gently bobs up and down using a sine wave fed by
/// the parent's tick. Extracted so the position math doesn't appear inline
/// inside a @ViewBuilder.
private struct DriftingIcon: View {
    let emoji: String
    let baseX: CGFloat
    let baseY: CGFloat
    let phaseOffset: TimeInterval
    let t: TimeInterval
    let size: CGSize
    let onTap: () -> Void

    var body: some View {
        let bob: Double = sin(Double(t + phaseOffset) * 1.5) * 0.1
        let y: CGFloat = size.height * (baseY + CGFloat(bob))
        let x: CGFloat = size.width * baseX
        return Text(emoji)
            .font(.system(size: 64))
            .position(x: x, y: y)
            .onTapGesture { onTap() }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Tap \(emoji) to weave a fibre")
    }
}

/// The fabric's vertical thread pattern. `threads` controls how many of
/// the available 12 thread positions are drawn. Used to be a Canvas loop
/// inside the fabric panel; rebuilt as a Shape so it renders on macOS 11.
private struct FabricWeaveShape: Shape {
    let threads: Int

    func path(in rect: CGRect) -> Path {
        var p = Path()
        // Position threads inside an inner rectangle, matching the old
        // Canvas geometry: 20-pt inset horizontally, 15-pt inset vertically,
        // 10-pt thread spacing.
        let innerX0 = rect.minX + 20
        let innerY0 = rect.minY + 15
        let innerY1 = rect.maxY - 15
        let maxX = rect.maxX - 20
        let spacing: CGFloat = 10
        for i in 0...threads {
            let x = innerX0 + CGFloat(i) * spacing
            if x > maxX { break }
            p.move(to: CGPoint(x: x, y: innerY0))
            p.addLine(to: CGPoint(x: x, y: innerY1))
        }
        return p
    }
}
