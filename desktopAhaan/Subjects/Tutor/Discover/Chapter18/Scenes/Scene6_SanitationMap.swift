import SwiftUI

/// Scene 6 — Sanitation Map. Pick a toilet type and learn pros/cons.
struct Scene6_SanitationMap: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Toilet: String, CaseIterable, Identifiable {
        case pit = "Pit latrine", septic = "Septic tank", flush = "Flush + sewer", bio = "Bio-toilet"
        var id: String { rawValue }
        var notes: String {
            switch self {
            case .pit:     return "Cheap, used in rural areas. Must be far from drinking wells. Fills up & needs emptying."
            case .septic:  return "Tank stores waste; microbes break it down. Effluent leaches into the soil. Used where there's no sewer."
            case .flush:   return "Water carries waste to a sewer line and on to a treatment plant. The gold standard for cities."
            case .bio:     return "Bacteria digest waste right inside the toilet. No water needed — used in trains and very remote areas."
            }
        }
    }
    @State private var pick: Toilet = .flush

    var body: some View {
        VStack(spacing: 14) {
            Text("Sanitation Map").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("There's no single toilet — choose by water, money and place.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).multilineTextAlignment(.center)

            Picker("", selection: $pick) {
                ForEach(Toilet.allCases) { Text($0.rawValue).tag($0) }
            }.pickerStyle(.segmented).discoverControlChrome().frame(maxWidth: 520).padding(.horizontal, 16)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(pick.rawValue).font(.title3.bold())
                    Text(pick.notes).font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            SoftShadowCard(padding: 14) {
                Text("India's Swachh Bharat Mission has built 100M+ toilets since 2014 — drastically cutting open defecation and water-borne disease.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Civics / Public Health",
                detail: "Class 9 Civics 'Constitutional Design' covers fundamental rights and the Right to Sanitation as derived from Article 21 (Right to Life). India's Swachh Bharat Mission (2014-2019) built 100M+ toilets. Class 10 Civics tests programme evaluation."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Map school toilets",
                detail: "Walk through your school and note toilet types: flush-with-sewer (modern), septic tank (most schools), or pit latrines (some rural). Count the number of toilets vs students. WHO recommendation is 1 per 30."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
