import SwiftUI

/// Scene 2 — Sand, Clay or Loam. 3 samples shown; identify each.
struct Scene2_SandClayLoam: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Sample: Identifiable {
        let id = UUID()
        let clue: String
        let kind: String
    }

    private let samples: [Sample] = [
        Sample(clue: "Feels gritty, water drains right through", kind: "Sandy"),
        Sample(clue: "Sticks when wet, cracks when dry, holds water", kind: "Clayey"),
        Sample(clue: "Crumbly, holds some water but drains the rest — perfect for crops", kind: "Loamy"),
    ]
    private let options = ["Sandy", "Clayey", "Loamy"]
    @State private var picks: [UUID: String] = [:]

    private var done: Bool { picks.count == samples.count }
    private var score: Int { samples.reduce(0) { $0 + ((picks[$1.id] == $1.kind) ? 1 : 0) } }

    var body: some View {
        VStack(spacing: 14) {
            Text("Sand, Clay or Loam?").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Read each clue, then label the soil type.").font(.callout).foregroundColor(.secondary)

            VStack(spacing: 12) {
                ForEach(samples) { s in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(s.clue).font(.body)
                        HStack(spacing: 8) {
                            ForEach(options, id: \.self) { opt in
                                Button(opt) { picks[s.id] = opt }
                                    .accentColor(picks[s.id] == opt ? Color.compatIndigo : .gray)
                            }
                            if let p = picks[s.id] {
                                Image(systemName: p == s.kind ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(p == s.kind ? .green : .red)
                            }
                        }
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.06)))
                }
            }
            .frame(maxWidth: 620)
            .padding(.horizontal, 24)

            if done {
                Text("Score: \(score) / \(samples.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
            }

            SoftShadowCard(padding: 14) {
                Text("Soil is classified by the size of its particles. Sand has the biggest grains (water drains fast), clay has the smallest (water gets trapped), loam is a mix — the goldilocks soil for farming.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            if done { GotItButton { onComplete(score) }.padding(.bottom, 12) }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
