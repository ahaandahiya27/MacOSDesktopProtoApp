import SwiftUI

/// Scene 1 — Inhale/Exhale. Tap to breathe in; ribs lift, diaphragm flattens.
struct Scene1_InhaleExhale: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var inhaling = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 14) {
            Text("Inhale, Exhale").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Tap the chest to breathe in. Tap again to breathe out.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.pink.opacity(0.10))
                    .frame(width: 280, height: 320)
                VStack(spacing: 8) {
                    Text("🫁").font(.system(size: inhaling ? 120 : 70))
                        .animation(reduceMotion ? .none : .easeInOut(duration: 0.7), value: inhaling)
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
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
