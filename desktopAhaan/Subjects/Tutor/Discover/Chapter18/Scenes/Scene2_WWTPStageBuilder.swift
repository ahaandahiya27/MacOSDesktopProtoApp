import SwiftUI

/// Scene 2 — WWTP Stage Builder. Tap each stage to learn what it removes.
struct Scene2_WWTPStageBuilder: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Stage: String, CaseIterable, Identifiable {
        case barScreen = "Bar screen", grit = "Grit chamber", aeration = "Aeration tank", clarifier = "Clarifier", sludge = "Sludge digester"
        var id: String { rawValue }
        var role: String {
            switch self {
            case .barScreen: return "Metal bars catch rags, plastics and large solids before pumps."
            case .grit:      return "Slow tank lets sand, pebbles and coffee grounds sink to the bottom."
            case .aeration:  return "Air is bubbled in; helpful microbes eat dissolved organic waste."
            case .clarifier: return "Calm tank where dead microbes settle into a thick sludge at the bottom."
            case .sludge:    return "Sludge is dried; microbes here produce biogas (methane) from it."
            }
        }
    }
    @State private var pick: Stage = .barScreen

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("WWTP Stage Builder").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap each stage. See what it cleans out.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                HStack(spacing: 6) {
                    ForEach(Stage.allCases) { s in
                        Button { pick = s } label: {
                            VStack {
                                Text(stageEmoji(s)).font(.system(size: 36))
                                Text(s.rawValue).font(.caption2)
                            }
                            .padding(6)
                            .frame(width: 90)
                            .background(RoundedRectangle(cornerRadius: 8).fill(pick == s ? Color.compatIndigo.opacity(0.15) : Color.white.opacity(0.95)))
                        }
                        .buttonStyle(.plain)
                    }
                }

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Text(pick.rawValue).font(.title3.bold())
                        Text(pick.role).font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                ProcessTimeline(
                    title: "How a sewage-treatment plant works — start to finish",
                    steps: [
                        .init(title: "1. Bar screens",
                              detail: "Wastewater enters and runs through a row of metal bars. Plastic bags, sticks, sanitary products, and large rags are caught and removed."),
                        .init(title: "2. Grit chamber",
                              detail: "Flow slows so heavier particles — sand, pebbles, broken glass — settle to the bottom and are scraped out."),
                        .init(title: "3. Primary clarifier",
                              detail: "Water moves into a calm tank. Lighter sludge (suspended solids) settles to the floor; oils and grease float to the top and are skimmed off."),
                        .init(title: "4. Aeration tank",
                              detail: "Air is pumped in. Aerobic bacteria multiply rapidly, eating the dissolved organic pollution. This is the biological heart of the plant."),
                        .init(title: "5. Secondary clarifier",
                              detail: "The bacteria-rich sludge settles. Clear water leaves the top; some of the settled sludge is pumped back to keep the aeration tank stocked with microbes."),
                        .init(title: "6. Chlorination + discharge",
                              detail: "A small dose of chlorine (or UV light) kills the remaining pathogens. The cleaned water is released back into a river or reused for irrigation. Removed sludge becomes biogas or fertiliser.")
                    ],
                    accent: Color.compatTeal
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 Biology 'Environmental Issues' covers these same stages. It adds BOD (Biological Oxygen Demand) and COD (Chemical Oxygen Demand), two number measures of water pollution that NEET tests every year. The aeration tank is where the microbes you saw do the hard work."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Bottle filter",
                    detail: "Cut a 1-litre bottle in half. Invert the top into the bottom. Layer the top with cotton, then sand, then fine gravel, then coarse gravel. Pour muddy water from the top. Clear (but not safe to drink) water drips out. That's a primary-treatment filter."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                GotItButton { onComplete() }.padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private func stageEmoji(_ s: Stage) -> String {
        switch s {
        case .barScreen: return "▮▮▮"
        case .grit:      return "🪨"
        case .aeration:  return "🫧"
        case .clarifier: return "🧪"
        case .sludge:    return "🟤"
        }
    }
}
