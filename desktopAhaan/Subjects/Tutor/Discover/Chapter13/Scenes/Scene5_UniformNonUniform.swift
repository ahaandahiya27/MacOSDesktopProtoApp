import SwiftUI

/// Scene 5 — Uniform vs Non-Uniform Motion. Classify 4 scenarios.
struct Scene5_UniformNonUniform: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Item: Identifiable { let id = UUID(); let text: String; let isUniform: Bool }
    private let items: [Item] = [
        Item(text: "🚂 Train at a steady 80 km/h on straight tracks",       isUniform: true),
        Item(text: "🚦 Car accelerating from a red light",                   isUniform: false),
        Item(text: "🌑 The Moon orbiting Earth (approximately constant speed)", isUniform: true),
        Item(text: "🍎 Apple falling from a tree",                            isUniform: false),
    ]
    @State private var picks: [UUID: Bool] = [:]

    private var done: Bool { picks.count == items.count }
    private var score: Int { items.reduce(0) { $0 + ((picks[$1.id] == $1.isUniform) ? 1 : 0) } }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 12) {
                Text("Uniform vs Non-Uniform").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Same speed throughout, or changing speed?")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: 10) {
                    ForEach(items) { item in
                        HStack {
                            Text(item.text).frame(maxWidth: .infinity, alignment: .leading)
                            Button("Uniform")    { picks[item.id] = true  }.accentColor(picks[item.id] == true ? .green : .gray)
                            Button("Non-Uniform"){ picks[item.id] = false }.accentColor(picks[item.id] == false ? .orange : .gray)
                            if let p = picks[item.id] {
                                Image(systemName: p == item.isUniform ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(p == item.isUniform ? .green : .red)
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 680).padding(.horizontal, 24)

                if done {
                    Text("Score: \(score) / \(items.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
                }

                SoftShadowCard(padding: 14) {
                    Text("Uniform motion = constant speed in a straight line. Non-uniform = speed changes (acceleration). A falling apple speeds up because gravity keeps pulling it.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 11 Physics → JEE",
                    detail: "Class 11 Kinematics introduces ACCELERATION (a = dv/dt) as the rate of change of velocity. Three equations of motion: v = u + at, s = ut + ½at², v² = u² + 2as. The d-t and v-t graph slopes are heavily JEE-tested, including motion-under-gravity (g = 9.8 m/s²) and projectile problems."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Marble race",
                    detail: "Roll a marble on a smooth flat floor — almost uniform speed (it slows only slightly from friction). Now roll the same marble down a slope — clearly non-uniform, it speeds up. You've felt the difference between zero acceleration and gravity-driven acceleration."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}
