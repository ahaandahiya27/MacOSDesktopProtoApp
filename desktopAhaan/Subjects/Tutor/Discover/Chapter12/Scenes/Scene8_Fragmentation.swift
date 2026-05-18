import SwiftUI

/// Scene 8 — Fragmentation. Drag a slider to "break" the Spirogyra filament;
/// each fragment becomes a new individual.
struct Scene8_Fragmentation: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var fragments: Double = 1

    var body: some View {
        VStack(spacing: 14) {
            Text("Fragmentation").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Slide to break the algae filament. Each piece grows into a new one.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            // Fragment width scales down with count and leaves visible gaps.
            HStack(spacing: 8) {
                ForEach(0..<Int(fragments), id: \.self) { _ in
                    Capsule().fill(Color.green.opacity(0.8))
                        .frame(width: CGFloat((280 - 8 * (fragments - 1)) / fragments), height: 16)
                }
            }
            .frame(width: 300, alignment: .leading)
            .padding(.vertical, 20)

            Slider(value: $fragments, in: 1...6, step: 1).frame(maxWidth: 460).padding(.horizontal, 24)
            Text("Fragments: \(Int(fragments))").font(.headline).foregroundColor(Color.compatIndigo)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Break, then grow", systemImage: "scissors")
                        .font(.title2.bold())
                    Text("Spirogyra is a green algae that lives in ponds. Its long filament can break into pieces — accidentally or in storms — and each fragment grows into a brand-new filament. Simple, fast, and asexual.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 12 Bio → NEET",
                detail: "Class 12 'Reproduction in Organisms' classifies fragmentation as an asexual mode where parent breaks into 2+ pieces, each becoming a complete organism. Common in Spirogyra, Planaria, sea-anemones. NEET asks distinction between fragmentation and regeneration."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Pond-water peek",
                detail: "A spoonful of pond water under a magnifying glass usually contains green threads of Spirogyra. Each thread can break into pieces and each piece grows into a new thread — fragmentation in action."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
