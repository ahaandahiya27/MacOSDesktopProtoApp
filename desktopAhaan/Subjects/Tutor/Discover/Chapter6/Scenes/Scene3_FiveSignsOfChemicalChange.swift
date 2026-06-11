import SwiftUI

/// Scene 3 — Five Signs of Chemical Change.
/// Five interactive cards. Tap each for an animated example + explanation.
/// After all 5 tapped: GotItButton.

struct Scene3_FiveSignsOfChemicalChange: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var tapped: Set<Int> = []
    @State private var activeSign: Int? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var allTapped: Bool { tapped.count >= 5 }

    private struct SignData {
        let title: String
        let icon: String
        let color: Color
        let example: String
        let explanation: String
        let emoji: String
    }

    private let signs: [SignData] = [
        SignData(
            title: "Color change",
            icon: "paintpalette.fill",
            color: .purple,
            example: "Cutting an apple — it turns brown",
            explanation: "When a cut apple browns, iron in the fruit reacts with oxygen in air. The brown color means a new substance (iron oxide) has formed.",
            emoji: "🍎"
        ),
        SignData(
            title: "Gas produced",
            icon: "bubble.left.and.bubble.right.fill",
            color: .blue,
            example: "Baking soda + vinegar — bubbles form",
            explanation: "The fizzing bubbles are CO₂ gas — a brand-new substance that was not there before. Gas production is a strong sign of chemical change.",
            emoji: "🫧"
        ),
        SignData(
            title: "Temperature change",
            icon: "thermometer.medium",
            color: .red,
            example: "Burning magnesium — it gets very hot",
            explanation: "Chemical reactions can release heat (exothermic) or absorb it (endothermic). A sudden temperature change without external heating signals a chemical change.",
            emoji: "🌡️"
        ),
        SignData(
            title: "Precipitate forms",
            icon: "arrow.down.to.line",
            color: .orange,
            example: "Mixing silver nitrate + salt water — white solid appears",
            explanation: "A precipitate is an insoluble solid that forms when two solutions are mixed. It is a brand-new substance — a sign of chemical change.",
            emoji: "🧪"
        ),
        SignData(
            title: "New smell",
            icon: "nose",
            color: .green,
            example: "Milk curdling — sour smell",
            explanation: "When milk goes sour, bacteria convert lactose into lactic acid — a new substance with a distinct sour smell. A new odour means new molecules.",
            emoji: "👃"
        ),
    ]

    var body: some View {
        // ScrollView + LazyVStack: GeometryReader-collapse bug fixed by
        // removing the unused outer GeometryReader; sign cards now lay
        // out at their natural height inside the scrollable column.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    Text("Five Signs of Chemical Change")
                        .font(.largeTitle.bold())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .padding(.top, 18)

                    Text("Tap each card to learn the five clues that a chemical change happened.")
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                    // Five cards in a row
                    HStack(spacing: DesignTokens.Spacing.md) {
                        ForEach(0..<5, id: \.self) { i in
                            signCard(index: i, height: 180)
                        }
                    }
                    .frame(maxWidth: 720)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                }
                .frame(maxWidth: .infinity)

                Group {
                    if let idx = activeSign {
                        let sign = signs[idx]
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                                HStack(spacing: DesignTokens.Spacing.sm) {
                                    Text(sign.emoji)
                                        .font(.title)
                                    Label(sign.title, systemImage: sign.icon)
                                        .font(.title2.bold())
                                        .foregroundColor(sign.color)
                                }
                                Text("Example: \(sign.example)")
                                    .font(.callout.italic())
                                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                                Text(sign.explanation)
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .transition(.opacity)
                    } else {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                                Label("Five clues to spot a chemical change", systemImage: "magnifyingglass")
                                    .font(.title2.bold())
                                Text("Scientists look for these five signs to tell whether a chemical change occurred. Tap each card above to see an example!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                    }

                    LookingAheadCallout(
                        title: "Class 11 Chemistry → JEE (Reaction Signatures)",
                        detail: "The five signs — colour change, gas, precipitate, energy, smell — each map to a JEE reaction type. Redox shows a colour change (Cu²⁺ pale blue → dark blue with NH₃). A gas evolves (HCl + Zn → H₂). A precipitate forms (BaCl₂ + Na₂SO₄ → BaSO₄↓). Exothermic means heat is released. Smell points to a product: rotten eggs are H₂S, sharp is ammonia, sweet is an ester."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Spot 5 signs in 5 different events",
                        detail: "Make a checklist: ① Cut an apple, leave 10 minutes (browning = colour change). ② Soda water in glass (CO₂ gas escaping). ③ Mix milk + lemon (curdling = precipitation). ④ Iron filings on a hot pan (incandescent = energy out). ⑤ Onion slicing (sulphur compound smell = chemical reaction with air). Five different chemical reactions in your kitchen, before lunch."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if allTapped {
                        GotItButton { onComplete() }
                            .padding(.bottom, DesignTokens.Spacing.md)
                    } else {
                        Text("Tap all 5 cards to continue")
                            .font(.caption)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            .padding(.bottom, DesignTokens.Spacing.md)
                    }
                

                }

                .padding(.horizontal, DesignTokens.Spacing.xl)
            

            }

            .frame(maxWidth: .infinity)

            .padding(.bottom, DesignTokens.Spacing.md)

        }
    }

    @ViewBuilder
    private func signCard(index: Int, height: CGFloat) -> some View {
        let sign = signs[index]
        let isTapped = tapped.contains(index)
        let isActive = activeSign == index

        Button {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                tapped.insert(index)
                activeSign = index
            }
        } label: {
            VStack(spacing: 10) {
                Image(systemName: sign.icon)
                    .font(.system(size: 28))
                    .foregroundColor(sign.color)

                Text(sign.emoji)
                    .font(.system(size: 36))

                Text(sign.title)
                    .font(.caption.weight(.semibold))
                    .multilineTextAlignment(.center)

                if isTapped {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.card, style: .continuous)
                    .fill(isTapped ? sign.color.opacity(0.1) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.card, style: .continuous)
                    .strokeBorder(isActive ? sign.color : .gray.opacity(0.2), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(sign.title). \(isTapped ? "Explored." : "Tap to explore.")")
        .accessibilityHint("Shows this sign of chemical change in detail")
    }
}
