import SwiftUI

/// Scene 2 — Series vs Parallel. Remove one bulb; series goes dark, parallel does not.
struct Scene2_SeriesVsParallel: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Wiring: String, CaseIterable, Identifiable { case series = "Series", parallel = "Parallel"; var id: String { rawValue } }
    @State private var wiring: Wiring = .series
    @State private var bulb1On = true
    @State private var bulb2On = true

    private var bulb1Glow: Bool { bulb1On && (wiring == .parallel || bulb2On) }
    private var bulb2Glow: Bool { bulb2On && (wiring == .parallel || bulb1On) }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Series vs Parallel").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("In series, removing one bulb kills the rest. In parallel, others stay lit.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).multilineTextAlignment(.center)

                Picker("", selection: $wiring) {
                    ForEach(Wiring.allCases) { Text($0.rawValue).tag($0) }
                }.pickerStyle(.segmented).discoverControlChrome().frame(maxWidth: 280)

                HStack(spacing: 40) {
                    VStack {
                        Text("💡").font(.system(size: 56)).opacity(bulb1Glow ? 1 : 0.25)
                        Toggle("Bulb 1 OK", isOn: $bulb1On)
                    }
                    VStack {
                        Text("💡").font(.system(size: 56)).opacity(bulb2Glow ? 1 : 0.25)
                        Toggle("Bulb 2 OK", isOn: $bulb2On)
                    }
                }
                .padding(.horizontal, 24)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Two ways to wire bulbs", systemImage: "bolt.horizontal")
                            .font(.title2.bold())
                        Text("In a series circuit, the current passes through every device. One break and everything stops — like old Christmas lights. In parallel, each device has its own loop, so they're independent. House wiring is parallel.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 10 → JEE",
                    detail: "Class 10 introduces R_series = ΣR and 1/R_parallel = Σ1/R. JEE / Class 12 'Current Electricity' adds combination problems with cells in series/parallel, terminal voltage V = EMF − Ir, and the Wheatstone bridge condition."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Two-bulb brightness test",
                    detail: "Take two identical small bulbs and a battery. Wire them in series and switch on — both dim. Re-wire the same two in parallel — both bright. Same battery, very different brightness."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
