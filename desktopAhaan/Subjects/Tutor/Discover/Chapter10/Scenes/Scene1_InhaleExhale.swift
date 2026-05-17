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
                    Label("Ribs up, diaphragm down", systemImage: "lungs.fill")
                        .font(.title2.bold())
                    Text("When you inhale, your ribs lift up and your diaphragm pushes down — chest cavity expands, air flows in. When you exhale, the opposite: chest shrinks, air leaves. Oxygen enters the blood, CO₂ leaves it.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
