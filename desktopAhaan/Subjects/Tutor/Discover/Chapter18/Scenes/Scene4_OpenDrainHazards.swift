import SwiftUI

/// Scene 4 — Open Drain Hazards. Step through the consequences.
struct Scene4_OpenDrainHazards: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var revealed = 0
    private let hazards = [
        "🦟 Mosquitoes breed in stagnant water",
        "🤢 Disease spreads — cholera, dysentery, typhoid",
        "👃 Foul smell affects nearby homes",
        "🌧 Heavy rain causes overflow & flooding",
    ]

    var body: some View {
        VStack(spacing: 14) {
            Text("Open Drain Hazards").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Tap Next to uncover each hazard of open drains.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            VStack(spacing: 8) {
                ForEach(0..<hazards.count, id: \.self) { i in
                    HStack {
                        Text(i < revealed ? hazards[i] : "?? ??").font(.headline)
                        Spacer()
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                    .foregroundColor(i < revealed ? .red : .secondary)
                }
            }
            .frame(maxWidth: 480)

            Button(revealed < hazards.count ? "Next hazard" : "Reset") {
                if revealed < hazards.count { revealed += 1 } else { revealed = 0 }
            }
            .accentColor(Color.compatIndigo)

            SoftShadowCard(padding: 14) {
                Text("Closed sewer systems, sealed manholes and good drainage keep neighborhoods healthy. Most monsoon-illness outbreaks in India start at open drains.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 12 Bio → NEET",
                detail: "Class 12 'Human Health and Disease' covers water-borne diseases — cholera (Vibrio cholerae), typhoid (Salmonella typhi), dysentery (Entamoeba histolytica), hepatitis A. Their transmission and prevention is asked in NEET every year."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Open-drain audit",
                detail: "Walk around your colony or street with an adult. Count: open drains, closed drains, broken manholes, areas with stagnant water near drains. Note which days the corporation cleans them. This is your immediate sanitation environment."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
