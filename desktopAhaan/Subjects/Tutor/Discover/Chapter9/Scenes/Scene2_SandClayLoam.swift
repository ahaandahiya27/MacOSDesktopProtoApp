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
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Sand, Clay or Loam?").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Read each clue, then label the soil type.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                VStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(samples) { s in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(s.clue).font(.body)
                            HStack(spacing: DesignTokens.Spacing.sm) {
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
                        .padding(DesignTokens.Spacing.md)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                    }
                }
                .frame(maxWidth: 620)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                if done {
                    Text("Score: \(score) / \(samples.count)").font(.title3.bold()).foregroundColor(Color.compatIndigo)
                }

                SoftShadowCard(padding: 14) {
                    Text("Soil is classified by the size of its particles. Sand has the biggest grains (water drains fast), clay has the smallest (water gets trapped), loam is a mix — the goldilocks soil for farming.")
                        .font(.callout).lineSpacing(4)
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Squeeze test",
                    detail: "Take a fist-sized handful of moist soil. Sandy soil falls apart immediately. Clayey soil holds its shape and feels sticky. Loamy soil holds a loose ball that crumbles when poked. Try this with three different garden samples to feel the difference."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                if done { GotItButton { onComplete(score) }.padding(.bottom, DesignTokens.Spacing.md) }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
