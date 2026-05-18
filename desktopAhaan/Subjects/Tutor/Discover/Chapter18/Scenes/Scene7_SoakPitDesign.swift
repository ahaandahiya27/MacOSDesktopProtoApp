import SwiftUI

/// Scene 7 — Soak-Pit Design. Adjust depth + gravel; success bar fills.
struct Scene7_SoakPitDesign: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var depth: Double = 1.5
    @State private var gravel: Bool = false
    @State private var distance: Double = 10
    @State private var greywaterLPD: Double = 150   // free-play: daily greywater volume

    private var quality: Double {
        var q = (depth - 1) / 2 * 0.5
        if gravel { q += 0.3 }
        q += (distance - 5) / 25 * 0.2
        return min(max(q, 0), 1)
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Soak-Pit Design").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Design a soak-pit. Get the quality bar to green.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            ProgressView(value: quality).progressViewStyle(.linear).accentColor(.green)
                .frame(width: 320)
            Text("Design score: \(Int(quality * 100))%").font(.headline).foregroundColor(.green)

            VStack {
                HStack { Text("Depth: \(String(format: "%.1f", depth)) m"); Spacer(); Slider(value: $depth, in: 1...3, step: 0.1).frame(width: 200) }
                Toggle("Layer with gravel & sand", isOn: $gravel)
                HStack { Text("Distance from well: \(Int(distance)) m"); Spacer(); Slider(value: $distance, in: 5...30, step: 1).frame(width: 200) }
            }
            .frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 14) {
                Text("A soak-pit lets greywater (bath/wash water) seep through gravel and sand into the ground, where soil filters it. Keep it at least 15 m from drinking wells to avoid contamination.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            // Grouped to stay within Swift 5.5's 10-child ViewBuilder limit
            // (scene already has 2 sliders + 1 toggle inside the design block).
            Group {
                LookingAheadCallout(
                    title: "Class 12 Bio + Engineering",
                    detail: "Class 12 'Microbes in Human Welfare' covers biological filtration in soak-pits — the soil's natural microbial community digests organic matter before it reaches the groundwater. Polytechnic / ITI civil-engineering courses dive into design specs."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Bottle soak-pit",
                    detail: "Fill a clear 1-litre bottle with layers: 10 cm coarse gravel at bottom, 5 cm fine sand on top, 5 cm garden soil on the very top. Pour grey water (used dishwashing water) into the top. It seeps out the bottom much cleaner than it went in."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)
            }

            DiscoveryWidget(
                title: "Discovery — greywater load vs clog interval",
                subtitle: "Heavier daily greywater fills the pit faster. Drag to see how often it needs digging out / re-layering.",
                value: $greywaterLPD,
                range: 50...500,
                step: 25,
                valueLabel: { v in String(format: "Greywater: %.0f L/day", v) },
                output: clogIntervalExplanation
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func clogIntervalExplanation(_ lpd: Double) -> String {
        // Rough rule-of-thumb: 1.5 m × 1.5 m pit (~3 m³ effective volume)
        // clogs when ~3000 L of sediment-bearing greywater has passed.
        let years = 3000.0 / max(50, lpd) / 365
        let label: String
        switch lpd {
        case ..<100:
            label = "Small household. Pit lasts ages — minimal maintenance."
        case ..<200:
            label = "Average family. Re-dig once every couple of years."
        case ..<350:
            label = "Larger household / small lodge. Annual checkup advised."
        default:
            label = "Heavy load. Without a settlement tank upstream, the pit will clog FAST."
        }
        return String(format: "Expected lifespan ≈ %.1f years between dig-outs. ", years) + label
    }
}
