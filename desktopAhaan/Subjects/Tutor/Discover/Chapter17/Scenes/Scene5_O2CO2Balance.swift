import SwiftUI

/// Scene 5 — O₂/CO₂ Balance. Slider for forest area; O₂/CO₂ readings respond.
struct Scene5_O2CO2Balance: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var coverage: Double = 0.6

    private var o2: Int { Int(coverage * 100) }
    private var co2: Int { 100 - o2 }

    var body: some View {
        VStack(spacing: 14) {
            Text("O₂ ⇄ CO₂ Balance").font(.largeTitle.bold()).padding(.top, 18)
            Text("Forest cover ↔ atmospheric oxygen. Slide to see the effect.")
                .font(.callout).foregroundColor(.secondary).multilineTextAlignment(.center)

            HStack(spacing: 24) {
                VStack {
                    Text("O₂").font(.headline).foregroundColor(.green)
                    ProgressView(value: Double(o2) / 100)
                        .progressViewStyle(.linear).frame(width: 100, height: 12)
                        .accentColor(.green)
                    Text("\(o2)%").font(.headline.monospacedDigit())
                }
                VStack {
                    Text("CO₂").font(.headline).foregroundColor(.orange)
                    ProgressView(value: Double(co2) / 100)
                        .progressViewStyle(.linear).frame(width: 100, height: 12)
                        .accentColor(.orange)
                    Text("\(co2)%").font(.headline.monospacedDigit())
                }
            }

            Text("Forest cover: \(Int(coverage * 100))%")
                .font(.headline)
                .foregroundColor(Color.compatIndigo)
            Slider(value: $coverage, in: 0...1).frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Trees are Earth's lungs", systemImage: "leaf.fill")
                        .font(.title2.bold())
                    Text("Forests absorb CO₂ during photosynthesis and release O₂. They also remove airborne dust and pollutants. Cutting forests adds CO₂ to the air — and removes the system that cleans it up.")
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
