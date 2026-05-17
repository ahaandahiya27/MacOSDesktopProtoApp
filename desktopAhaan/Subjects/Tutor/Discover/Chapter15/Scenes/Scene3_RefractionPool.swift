import SwiftUI

/// Scene 3 — Refraction Pool. Drop a pencil into water; it appears to bend.
struct Scene3_RefractionPool: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var inWater = false

    var body: some View {
        VStack(spacing: 14) {
            Text("Refraction Pool").font(.largeTitle.bold()).padding(.top, 18)
            Text("Dip a pencil into water. Notice how it appears to break at the surface.")
                .font(.callout).foregroundColor(.secondary)

            ZStack(alignment: .center) {
                VStack(spacing: 0) {
                    Rectangle().fill(Color.white).frame(width: 280, height: 100)
                    Rectangle().fill(Color.blue.opacity(0.35)).frame(width: 280, height: 100)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))

                if inWater {
                    VStack(spacing: -8) {
                        Rectangle().fill(Color.compatBrown).frame(width: 8, height: 80)
                            .rotationEffect(.degrees(15), anchor: .bottom)
                        Rectangle().fill(Color.compatBrown).frame(width: 8, height: 80)
                            .rotationEffect(.degrees(-25), anchor: .top)
                    }
                } else {
                    Rectangle().fill(Color.compatBrown).frame(width: 8, height: 160)
                        .rotationEffect(.degrees(15))
                }
            }

            Button(inWater ? "Pull pencil out" : "Dip pencil in water") { inWater.toggle() }
                .accentColor(Color.compatIndigo)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Light bends when it changes medium", systemImage: "drop.fill")
                        .font(.title2.bold())
                    Text("When light goes from air into water, it slows down and changes direction. Your eye thinks the pencil is where the light SEEMS to come from — so it looks broken. This bending is called refraction.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
