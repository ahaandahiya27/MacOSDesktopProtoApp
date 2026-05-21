import SwiftUI

/// Scene 1 — Inhale/Exhale. Tap to breathe in; ribs lift, diaphragm flattens.
struct Scene1_InhaleExhale: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var inhaling = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Inhale, Exhale").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap the chest to breathe in. Tap again to breathe out.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(Color.pink.opacity(0.10))
                        .frame(width: 280, height: 320)
                    VStack(spacing: 8) {
                        Text("🫁").font(.system(size: inhaling ? 120 : 70))
                            .animation(reduceMotion ? .none : .easeInOut(duration: 0.7))
                            .accessibilityLabel(inhaling ? "Lungs expanded, breathing in" : "Lungs relaxed, breathing out")
                        Text(inhaling ? "Lungs expand — air rushes IN" : "Lungs shrink — air pushes OUT")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 18)
                    }
                }
                .onTapGesture { inhaling.toggle() }

                Button(inhaling ? "Exhale" : "Inhale") { inhaling.toggle() }
                    .accentColor(Color.compatIndigo)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Ribs up, diaphragm down", systemImage: SFSymbolCompat.name("lungs.fill"))
                            .font(.title2.bold())
                        Text("When you inhale, your ribs lift up and your diaphragm pushes down — chest cavity expands, air flows in. When you exhale, the opposite: chest shrinks, air leaves. Oxygen enters the blood, CO₂ leaves it.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                HotspotDiagram(
                    title: "Parts of the lung",
                    baseSymbol: "lungs.fill",
                    baseColor: .pink,
                    hotspots: [
                        .init(x: 0.50, y: 0.10, label: "Trachea (windpipe)",
                              detail: "The tube air travels down. Reinforced by C-shaped cartilage rings so it doesn't collapse when you turn your head."),
                        .init(x: 0.30, y: 0.30, label: "Left bronchus",
                              detail: "Trachea splits into two bronchi — one to each lung. Left bronchus is narrower (the heart sits on the left)."),
                        .init(x: 0.70, y: 0.30, label: "Right bronchus",
                              detail: "Wider and more vertical. That's why inhaled objects more often get stuck on the right side."),
                        .init(x: 0.25, y: 0.65, label: "Bronchioles",
                              detail: "Each bronchus branches into thousands of tiny bronchioles — like an upside-down tree of air pipes."),
                        .init(x: 0.75, y: 0.65, label: "Alveoli",
                              detail: "Each bronchiole ends in clusters of grape-like air sacs. ~300 million in each lung. Oxygen passes into the blood here."),
                        .init(x: 0.50, y: 0.90, label: "Diaphragm",
                              detail: "Dome-shaped muscle below the lungs. Flattens when you inhale (pulling air in), domes up when you exhale (pushing air out).")
                    ]
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 11 Biology → NEET",
                    detail: "In Class 11 you'll meet \"Breathing and Exchange of Gases\" — alveoli, partial pressure of oxygen, haemoglobin transport, and the Bohr effect. This is one of the most-asked chapters in NEET every year."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Count breaths at rest",
                    detail: "Sit still for a minute, then count your breaths for 30 seconds. Multiply by 2 — that's your resting breath rate (usually 12-20 per minute for kids)."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                RelatedConceptsCallout(
                    title: "Related: Ch 11 (Transportation), Ch 17 (Forests)",
                    detail: "Your lungs put O₂ into the blood — Chapter 11 takes over from there, showing how the heart pumps that blood to every cell. And every breath of O₂ you take was once exhaled by a plant — Chapter 17 covers how forests keep that supply going."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }
}
