import SwiftUI

/// Scene 4 — Lime Water Test. Tap to blow into limewater; it turns milky → CO₂.
struct Scene4_LimeWaterTest: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var milky = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 14) {
            Text("Lime Water Test").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Blow into clear limewater. It turns milky if your breath has CO₂.")
                .font(.callout).foregroundColor(.secondary)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 14).strokeBorder(Color.gray.opacity(0.4), lineWidth: 2)
                    .frame(width: 140, height: 220)
                RoundedRectangle(cornerRadius: 12)
                    .fill(milky ? Color.white.opacity(0.95) : Color.compatCyan.opacity(0.25))
                    .frame(width: 136, height: 180)
                    .animation(reduceMotion ? .none : .easeInOut(duration: 1.4), value: milky)
            }

            Button(milky ? "Reset" : "Blow into the tube") { milky.toggle() }
                .accentColor(Color.compatIndigo)

            Text(milky ? "✅ Limewater turned milky — CO₂ confirmed!"
                       : "Clear limewater — no CO₂ yet")
                .font(.headline)
                .foregroundColor(milky ? .green : .secondary)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("How we test for CO₂", systemImage: SFSymbolCompat.name("testtube.2"))
                        .font(.title2.bold())
                    Text("Calcium hydroxide (limewater) reacts with CO₂ to form solid calcium carbonate (chalk), turning the liquid milky. Your exhaled breath contains around 4% CO₂ — enough to do this in seconds.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Brew your own limewater",
                detail: "Mix slaked lime (chunna, from a paan shop) with water in a jar, let it settle overnight. Pour off the clear top into a glass. Blow through a straw — the liquid turns milky."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
