import SwiftUI

/// Scene 2 — Pollination Match. Match each flower to its pollinator.
struct Scene2_PollinationMatch: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Pair: Identifiable { let id = UUID(); let flower: String; let agent: String }
    private let pairs: [Pair] = [
        Pair(flower: "🌾 Grass — tiny dull flowers, lots of dry pollen", agent: "Wind"),
        Pair(flower: "🌺 Hibiscus — bright, fragrant, sticky pollen",      agent: "Insect"),
        Pair(flower: "💧 Water lily — floats, pollen waterproof",         agent: "Water"),
        Pair(flower: "🌳 Banana flower — large, sturdy, red, lots of nectar", agent: "Bird"),
    ]
    private let options = ["Wind", "Insect", "Water", "Bird"]
    @State private var picks: [UUID: String] = [:]
    @State private var windKMH: Double = 8           // free-play: wind speed for pollen dispersal

    private var done: Bool { picks.count == pairs.count }
    private var score: Int { pairs.reduce(0) { $0 + ((picks[$1.id] == $1.agent) ? 1 : 0) } }

    var body: some View {
        VStack(spacing: 12) {
            Text("Pollination Match").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Who carries the pollen for each flower?").font(.callout).foregroundColor(.secondary)

            VStack(spacing: 10) {
                ForEach(pairs) { p in
                    HStack {
                        Text(p.flower).font(.body).frame(maxWidth: .infinity, alignment: .leading)
                        Picker("", selection: Binding(
                            get: { picks[p.id] ?? "" }, set: { picks[p.id] = $0 }
                        )) {
                            Text("— pick —").tag("")
                            ForEach(options, id: \.self) { Text($0).tag($0) }
                        }.pickerStyle(.menu).frame(width: 150)
                        if let v = picks[p.id], !v.isEmpty {
                            Image(systemName: v == p.agent ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(v == p.agent ? .green : .red)
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 640).padding(.horizontal, 24)

            if done {
                Text("Score: \(score) / \(pairs.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
            }

            SoftShadowCard(padding: 14) {
                Text("Plants can't walk to find a mate, so they hire carriers. Wind & water are free but wasteful. Insects & birds are precise but need a reward — that's what nectar and bright petals are for.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 12 Bio → NEET",
                detail: "Class 12 covers pollination types in detail — autogamy, geitonogamy, xenogamy — plus the floral adaptations for each (cleistogamy, dichogamy, herkogamy). NEET asks these distinction questions every year."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Bee-watching",
                detail: "On a sunny morning, sit near a flowering plant for 10 minutes. Count the visiting insects — bees, butterflies, sometimes hover-flies. Each one is unknowingly carrying pollen between flowers."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            DiscoveryWidget(
                title: "Discovery — wind-pollination range",
                subtitle: "Wind-pollinated plants (grass, pine, maize) make a LOT of light pollen. Drag the breeze to see how far it travels.",
                value: $windKMH,
                range: 0...50,
                step: 1,
                valueLabel: { v in String(format: "Breeze: %.0f km/h", v) },
                output: windPollenExplanation
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func windPollenExplanation(_ kmh: Double) -> String {
        let metres = Int(kmh * 12)        // rough rule of thumb: ~12 m/(km/h) reach
        switch kmh {
        case ..<3:
            return "Still air. Pollen drifts a few metres at most — wind-pollinated species would fail today."
        case ..<10:
            return "Gentle breeze. Pollen carries ~\(metres) m — covers a small field of grass or maize."
        case ..<25:
            return "Moderate wind. Pollen reaches ~\(metres) m — pine, eucalyptus, sal forests do this every spring."
        default:
            return "Strong wind. Pollen blows ~\(metres) m+ — but also blown clean OFF flowers, hurting fertilisation."
        }
    }
}
