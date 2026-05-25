import SwiftUI

/// Scene 4 — Which Crop, Which Soil? Match 4 crops to their soil.
struct Scene4_WhichCropWhichSoil: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Pair: Identifiable { let id = UUID(); let crop: String; let soil: String }
    private let pairs: [Pair] = [
        Pair(crop: "🌾 Paddy (rice)",     soil: "Clayey"),
        Pair(crop: "🌶 Chilli / Vegetables", soil: "Loamy"),
        Pair(crop: "🥜 Groundnut",          soil: "Sandy"),
        Pair(crop: "🌿 Cotton",              soil: "Black soil"),
    ]
    private let options = ["Sandy", "Loamy", "Clayey", "Black soil"]
    @State private var picks: [UUID: String] = [:]

    private var done: Bool { picks.count == pairs.count }
    private var score: Int { pairs.reduce(0) { $0 + ((picks[$1.id] == $1.soil) ? 1 : 0) } }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 12) {
                Text("Which Crop, Which Soil?").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Pick the best soil for each crop.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: 10) {
                    ForEach(pairs) { p in
                        HStack {
                            Text(p.crop).font(.headline).frame(width: 200, alignment: .leading)
                            Picker("", selection: Binding(
                                get: { picks[p.id] ?? "" },
                                set: { picks[p.id] = $0 }
                            )) {
                                Text("— pick —").tag("")
                                ForEach(options, id: \.self) { Text($0).tag($0) }
                            }
                            .pickerStyle(.menu).frame(width: 180)
                            if let v = picks[p.id], !v.isEmpty {
                                Image(systemName: v == p.soil ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(v == p.soil ? .green : .red)
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 560)

                if done {
                    Text("Score: \(score) / \(pairs.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
                }

                SoftShadowCard(padding: 14) {
                    Text("Paddy needs standing water → clayey. Cotton thrives on mineral-rich black soil. Groundnut loves loose sandy soil. Most vegetables do best on balanced loam.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 9 Geography → NCERT",
                    detail: "Class 9 Geography covers India's major crops and the soil types that suit them — paddy on alluvial, wheat on loamy black, cotton on Deccan black, sugarcane on alluvial. CBSE Class 10 Economics tests cropping patterns and irrigation needs."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Three-pot seed race",
                    detail: "Plant the same seed (mustard, moong, methi) in three pots: one with sand, one with garden soil, one with potter's clay. Water all three equally and watch over 2 weeks. The garden soil (loamy) wins."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
