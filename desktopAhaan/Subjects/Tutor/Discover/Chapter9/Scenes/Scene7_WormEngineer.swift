import SwiftUI

/// Scene 7 — Worm the Engineer. Drag the worm down through the soil; tunnels
/// let air and water in, and the worm leaves behind nutrient-rich castings.
struct Scene7_WormEngineer: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var depth: Double = 0   // 0 = surface, 1 = deep
    @State private var tunnels: Int = 0
    /// Persistent random offsets so tunnels don't jump around on every redraw.
    @State private var tunnelOffsets: [CGFloat] = (0..<10).map { _ in CGFloat.random(in: -110...110) }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    VStack(spacing: 14) {
                Text("Worm — the Engineer").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Drag the worm down. Watch it leave tunnels behind.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(red: 0.45, green: 0.30, blue: 0.18))
                        .frame(width: 320, height: 320)

                    ForEach(0..<tunnels, id: \.self) { i in
                        Circle().fill(Color.white.opacity(0.25))
                            .frame(width: 14, height: 14)
                            .offset(x: tunnelOffsets[i % tunnelOffsets.count], y: CGFloat(i * 28 - 140))
                    }

                    Text("🪱")
                        .font(.system(size: 44))
                        .offset(y: CGFloat(depth) * 130 - 130)
                        .accessibilityLabel("Earthworm at depth \(Int(depth * 100)) percent")
                }

                Slider(value: $depth, in: 0...1) { _ in
                    tunnels = min(tunnels + 1, 10)
                }
                .frame(maxWidth: 360)
                Text("Tunnels: \(tunnels)").font(.headline).foregroundColor(Color.compatIndigo)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Tiny workers, huge impact", systemImage: "ant.fill")
                            .font(.title2.bold())
                        Text("Earthworms eat soil and release castings rich in nutrients. Their tunnels let air and water reach deeper roots. Charles Darwin called them \"nature's plough\" — the unsung heroes of fertile farmland.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                // Grouped so the outer VStack stays within Swift 5.5's
                // 10-child ViewBuilder limit (Xcode 13.2.1 / Big Sur target).
                Group {
                    LookingAheadCallout(
                        title: "Class 11/12 Bio → NEET",
                        detail: "Earthworms are studied in detail in Class 11 'Structural Organisation in Animals' — their anatomy, blood vascular system, and nephridial excretion. NEET asks earthworm-specific morphology questions every cycle. Class 12 'Microbes in Human Welfare' covers vermicompost and how earthworm cultures help in soil enrichment."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    TryAtHomeCallout(
                        title: "Worm hunt after rain",
                        detail: "Just after a rain shower, walk through a garden. You'll spot earthworms on the surface — they came up because their tunnels flooded. Note how moist soil feels different from dry soil."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)

                    RelatedConceptsCallout(
                        title: "Related: Ch 17 (Forests), Ch 18 (Wastewater)",
                        detail: "Earthworms decompose leaf litter into humus — Ch 17 shows the same animals at work in forest floors. Modern composting (Ch 18) uses the same biology to recycle home kitchen waste."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                }

                GotItButton { onComplete() }.padding(.bottom, 12)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
