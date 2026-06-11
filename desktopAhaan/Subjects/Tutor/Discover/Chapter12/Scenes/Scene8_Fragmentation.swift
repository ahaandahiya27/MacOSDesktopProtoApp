import SwiftUI

/// Scene 8 — Fragmentation. Drag a slider to "break" the Spirogyra filament;
/// each fragment becomes a new individual.
struct Scene8_Fragmentation: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var fragments: Double = 1

    /// Width of one fragment capsule. Pulled out of the `body` ViewBuilder with
    /// fully-explicit `Double` literals + a single `CGFloat` conversion so the
    /// Swift 5.5 type-checker on the Big-Sur iMac (Xcode 13.2.1) has no Int/
    /// Double/CGFloat operator-overload tree to explore — the inline form
    /// `CGFloat((280 - 8 * (fragments - 1)) / fragments)` is a classic
    /// `Segmentation fault: 11` trigger on that older compiler.
    private func fragmentWidth(count n: Double) -> CGFloat {
        let totalWidth = 280.0
        let gap = 8.0
        let usable = totalWidth - gap * (n - 1.0)
        return CGFloat(usable / n)
    }

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Fragmentation").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Slide to break the algae filament. Each piece grows into a new one.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                // Fragment width scales down with count and leaves visible gaps.
                HStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(0..<Int(fragments), id: \.self) { _ in
                        Capsule().fill(Color.green.opacity(0.8))
                            .frame(width: fragmentWidth(count: fragments), height: 16)
                    }
                }
                .frame(width: 300, alignment: .leading)
                .padding(.vertical, 20)

                Slider(value: $fragments, in: 1...6, step: 1).frame(maxWidth: 460).padding(.horizontal, DesignTokens.Spacing.xl)
                Text("Fragments: \(Int(fragments))").font(.headline).foregroundColor(Color.compatIndigo)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Label("Break, then grow", systemImage: "scissors")
                            .font(.title2.bold())
                        Text("Spirogyra is a green algae that lives in ponds. Its long filament can break into pieces — accidentally or in storms — and each fragment grows into a brand-new filament. Simple, fast, and asexual.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                LookingAheadCallout(
                    title: "Class 12 Bio → NEET",
                    detail: "Class 12 'Reproduction in Organisms' calls fragmentation an asexual mode. The parent breaks into two or more pieces, and each piece grows into a full organism. It is common in Spirogyra, Planaria and sea anemones. NEET asks how fragmentation differs from regeneration."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                TryAtHomeCallout(
                    title: "Pond-water peek",
                    detail: "A spoonful of pond water under a magnifying glass usually contains green threads of Spirogyra. Each thread can break into pieces and each piece grows into a new thread — fragmentation in action."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, DesignTokens.Spacing.xl)

                GotItButton { onComplete() }.padding(.bottom, DesignTokens.Spacing.md)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
