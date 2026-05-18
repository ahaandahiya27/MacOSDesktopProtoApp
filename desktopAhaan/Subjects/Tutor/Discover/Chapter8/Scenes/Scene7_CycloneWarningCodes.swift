import SwiftUI

/// Scene 7 — Cyclone Warning Codes. 4 IMD signal cards to match to meanings.
struct Scene7_CycloneWarningCodes: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Item: Identifiable {
        let id = UUID()
        let code: String
        let meaning: String
    }

    private let codes: [Item] = [
        Item(code: "Stage 1 — Pre-cyclone watch", meaning: "Possible cyclone in 72 hours"),
        Item(code: "Stage 2 — Cyclone alert",     meaning: "Threat in 48 hours"),
        Item(code: "Stage 3 — Cyclone warning",   meaning: "Threat in 24 hours"),
        Item(code: "Stage 4 — Post-landfall",     meaning: "After cyclone has hit coast"),
    ]

    @State private var shuffled: [String] = []
    @State private var picks: [UUID: String] = [:]

    private var done: Bool { picks.count == codes.count }
    private var score: Int { codes.reduce(0) { $0 + ((picks[$1.id] == $1.meaning) ? 1 : 0) } }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    VStack(spacing: 12) {
                Text("Cyclone Warning Codes").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Match each IMD warning stage to what it means.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: 10) {
                    ForEach(codes) { item in
                        HStack {
                            Text(item.code).font(.headline).frame(width: 240, alignment: .leading)
                            Picker("", selection: Binding(
                                get: { picks[item.id] ?? "" },
                                set: { picks[item.id] = $0 }
                            )) {
                                Text("— pick —").tag("")
                                ForEach(shuffled, id: \.self) { Text($0).tag($0) }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 280)
                            if let p = picks[item.id], !p.isEmpty {
                                Image(systemName: p == item.meaning ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(p == item.meaning ? .green : .red)
                            }
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 620)
                .padding(.horizontal, 24)
                .onAppear { shuffled = codes.map { $0.meaning }.shuffled() }

                if done {
                    Text("Score: \(score) / \(codes.count)")
                        .font(.title3.bold())
                        .foregroundColor(Color.compatIndigo)
                }

                SoftShadowCard(padding: 14) {
                    Text("India's Meteorological Department (IMD) raises warnings in 4 stages so coastal towns can prepare, evacuate, and avoid casualties.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                if done {
                LookingAheadCallout(
                    title: "Class 10 Disaster Management",
                    detail: "Class 10 Geography covers disaster-preparedness — cyclone shelters, the IMD warning chain, early-warning satellite systems (INSAT). Aligns directly to NCERT Disaster Management curriculum."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "IMD app or website",
                    detail: "Search 'IMD' or download the Mausam app (free). Live cyclone warnings, satellite images, and the same colour-coded warning levels shown here. Try it before the next monsoon."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                    GotItButton { onComplete(score) }.padding(.bottom, 12)
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
