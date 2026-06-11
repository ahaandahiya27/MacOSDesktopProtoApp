import SwiftUI

/// Scene 4 — Artery / Vein / Capillary. Classify 3 statements.
struct Scene4_ArteryVeinCapillary: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Item: Identifiable { let id = UUID(); let text: String; let answer: String }
    private let items: [Item] = [
        Item(text: "Carries oxygen-rich blood away from the heart, thick walls",         answer: "Artery"),
        Item(text: "Carries blood back to the heart, has one-way valves",                 answer: "Vein"),
        Item(text: "Thin, one-cell-thick walls where O₂ and nutrients reach tissues",     answer: "Capillary"),
    ]
    private let options = ["Artery", "Vein", "Capillary"]
    @State private var picks: [UUID: String] = [:]

    private var done: Bool { picks.count == items.count }
    private var score: Int { items.reduce(0) { $0 + ((picks[$1.id] == $1.answer) ? 1 : 0) } }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: DesignTokens.Spacing.md) {
                Text("Artery / Vein / Capillary").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Three kinds of blood vessels — pick the right one.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: 10) {
                    ForEach(items) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.text).font(.body)
                            HStack(spacing: DesignTokens.Spacing.sm) {
                                ForEach(options, id: \.self) { opt in
                                    Button(opt) { picks[item.id] = opt }
                                        .accentColor(picks[item.id] == opt ? Color.compatIndigo : .gray)
                                }
                                if let p = picks[item.id] {
                                    Image(systemName: p == item.answer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(p == item.answer ? .green : .red)
                                }
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.md).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 640).padding(.horizontal, DesignTokens.Spacing.xl)

                if done {
                    Text("Score: \(score) / \(items.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
                }

                SoftShadowCard(padding: 14) {
                    Text("Arteries push blood out under high pressure, so their walls are thick & elastic. Veins return it at low pressure, with valves to stop backflow. Capillaries are the tiny exchange networks.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Find pulse points",
                    detail: "Try feeling your pulse at four spots: inside the wrist (radial), side of the neck (carotid), back of the knee (popliteal), top of the foot (dorsalis pedis). All of them carry blood from the heart — that's why they pulse with each beat."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                LookingAheadCallout(
                    title: "Class 11 Bio → NEET",
                    detail: "Class 11 'Body Fluids and Circulation' studies the three vessel types up close: the tunica intima, media and externa, how valves work, and how blood pressure is measured (systolic and diastolic). These are near-guaranteed NEET questions every cycle."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                if done { GotItButton { onComplete(score) }.padding(.bottom, DesignTokens.Spacing.md) }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
