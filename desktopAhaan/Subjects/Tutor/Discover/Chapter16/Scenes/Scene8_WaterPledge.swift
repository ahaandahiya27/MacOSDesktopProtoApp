import SwiftUI

/// Scene 8 — World Water Day Pledge. Toggle pledges. Counter shows pledge count.
struct Scene8_WaterPledge: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var pledges: [Bool] = Array(repeating: false, count: 6)
    private let texts = [
        "Close the tap while brushing",
        "Bucket bath instead of shower",
        "Fix leaky taps at home",
        "Reuse water from washing veggies for plants",
        "Sweep, don't hose, the driveway",
        "Tell one friend about water conservation",
    ]

    private var count: Int { pledges.filter { $0 }.count }

    var body: some View {
        VStack(spacing: 14) {
            Text("World Water Day Pledge").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Pick the pledges you'll keep this month.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            VStack(spacing: 8) {
                ForEach(0..<pledges.count, id: \.self) { i in
                    Toggle(texts[i], isOn: $pledges[i])
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 560).padding(.horizontal, 24)

            Text("Pledges taken: \(count) / 6")
                .font(.headline)
                .foregroundColor(Color.compatIndigo)

            SoftShadowCard(padding: 14) {
                Text("World Water Day is celebrated on 22 March each year. Small habits, multiplied by billions of people, save billions of litres.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Civics / SDG framework",
                detail: "UN Sustainable Development Goal 6 (Clean Water and Sanitation) is part of CBSE Class 10 syllabus. Targets include universal access to safe water and sanitation by 2030, halving untreated wastewater, and protecting water-related ecosystems."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "30-day habit challenge",
                detail: "Pick three water-saving habits from this scene. Track them for 30 days using a chart on your room wall: 'Closed tap while brushing — ✓, Bucket bath instead of shower — ✓'. After 30 days, the habits stick on their own."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
