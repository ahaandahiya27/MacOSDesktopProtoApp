import SwiftUI

/// Scene 2 — Decomposer Cycle. Slider for time: leaf → litter → humus → soil.
struct Scene2_DecomposerCycle: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var stage: Double = 0   // 0 leaf, 1 litter, 2 humus, 3 soil

    private var info: (emoji: String, label: String) {
        switch Int(stage) {
        case 0: return ("🍃", "Fresh leaf falls")
        case 1: return ("🍂", "Crispy litter — fungi & worms move in")
        case 2: return ("🌑", "Dark humus — partially broken down")
        default: return ("🟫", "Rich soil — ready for new plants")
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Decomposer Cycle").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Slide forward in time. Watch a leaf become new soil.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.green.opacity(0.10))
                    .frame(width: 280, height: 220)
                VStack(spacing: 6) {
                    Text(info.emoji).font(.system(size: 96))
                    Text(info.label).font(.headline).foregroundColor(Color.compatIndigo)
                }
            }

            Slider(value: $stage, in: 0...3, step: 1).frame(maxWidth: 460).padding(.horizontal, 24)
            HStack {
                Text("Day 1").font(.caption); Spacer()
                Text("Month 1").font(.caption); Spacer()
                Text("Month 6").font(.caption); Spacer()
                Text("Year 1").font(.caption)
            }.frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Nothing is wasted", systemImage: "arrow.triangle.2.circlepath")
                        .font(.title2.bold())
                    Text("Fungi, bacteria, worms and termites break down dead leaves into humus — a dark, spongy material rich in nutrients. The nutrients return to the soil and feed the next generation of plants.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 12 Bio → NEET",
                detail: "Class 12 'Ecosystem' formalises this as nutrient cycling — the carbon, nitrogen, phosphorus, sulphur cycles. Decomposers (bacteria, fungi) drive all of them. NEET asks ecological cycle questions every year."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Compost-jar diary",
                detail: "Put fruit and vegetable peels in a glass jar, cover loosely, add a teaspoon of garden soil. Leave on a balcony. Note over 2 weeks: peels darken, lose volume, smell musty. After 4 weeks you'll see crumbly humus forming. That's decomposition you can watch."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
