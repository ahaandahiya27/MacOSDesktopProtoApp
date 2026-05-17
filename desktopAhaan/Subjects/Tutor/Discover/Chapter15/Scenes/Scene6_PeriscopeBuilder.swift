import SwiftUI

/// Scene 6 — Periscope Builder. Toggle mirrors at 45° — see around the corner.
struct Scene6_PeriscopeBuilder: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var built = false

    var body: some View {
        VStack(spacing: 14) {
            Text("Periscope Builder").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Two mirrors at 45° — and suddenly you can see over walls.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1))
                    .frame(width: 280, height: 280)

                VStack(spacing: 6) {
                    Text(built ? "👀" : "🚧").font(.system(size: 38))
                        .accessibilityLabel(built ? "Looking out through the periscope" : "Periscope not yet assembled")
                    Rectangle().fill(Color.compatIndigo.opacity(built ? 0.8 : 0.3))
                        .frame(width: 8, height: 50)
                        .rotationEffect(.degrees(built ? 45 : 0))
                    Rectangle().fill(Color.gray.opacity(0.5)).frame(width: 60, height: 4)
                    Rectangle().fill(Color.compatIndigo.opacity(built ? 0.8 : 0.3))
                        .frame(width: 8, height: 50)
                        .rotationEffect(.degrees(built ? -45 : 0))
                    Text("🌳").font(.system(size: 38))
                }
            }

            Button(built ? "Disassemble" : "Build periscope") { built.toggle() }
                .accentColor(Color.compatIndigo)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("See around corners", systemImage: "binoculars")
                        .font(.title2.bold())
                    Text("Light from below the wall hits the bottom mirror at 45°, reflects upward, hits the top mirror, reflects out to your eye. Submarines use this trick to see above the water without surfacing.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 12 → JEE Optics",
                detail: "Class 12 'Ray Optics' covers Total Internal Reflection (TIR) — the principle behind modern fibre-optic submarine periscopes and the internet's optical fibres. Critical angle θ_c = sin⁻¹(1/μ). JEE asks TIR problems every year."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
