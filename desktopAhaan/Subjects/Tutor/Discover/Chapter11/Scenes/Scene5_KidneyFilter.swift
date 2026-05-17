import SwiftUI

/// Scene 5 — Kidney Filter. Tap to send "dirty blood" through the kidney
/// → clean blood + urine.
struct Scene5_KidneyFilter: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var filtered = false

    var body: some View {
        VStack(spacing: 14) {
            Text("Kidney Filter").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Tap the button to push blood through the kidney.").font(.callout).foregroundColor(.secondary)

            HStack(spacing: 24) {
                VStack {
                    Text(filtered ? "❤️" : "🟤").font(.system(size: 56))
                    Text(filtered ? "Clean blood" : "Dirty blood").font(.caption)
                }
                Text("→").font(.title.bold()).foregroundColor(Color.compatIndigo)
                Text("🫘").font(.system(size: 80))
                    .accessibilityLabel("Kidney filtering blood")
                Text("→").font(.title.bold()).foregroundColor(Color.compatIndigo)
                VStack {
                    Text(filtered ? "💧" : "—").font(.system(size: 56))
                    Text(filtered ? "Urine" : "(waste)").font(.caption)
                }
            }

            Button(filtered ? "Reset" : "Filter blood now") { filtered.toggle() }
                .accentColor(Color.compatIndigo)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Two bean-shaped life-savers", systemImage: "drop.fill")
                        .font(.title2.bold())
                    Text("Your kidneys filter about 180 litres of blood every day. They remove urea (a waste from protein breakdown) and extra water, sending them to the bladder as urine. Useful nutrients are kept and returned to the blood.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Bio → NEET",
                detail: "Class 11 'Excretory Products and their Elimination' covers nephron anatomy in detail, glomerular filtration rate (~125 mL/min), the loop of Henle counter-current multiplier, ADH and aldosterone hormones, and dialysis. The nephron diagram is one of the most-tested NEET visuals year after year."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
