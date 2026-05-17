import SwiftUI

/// Scene 5 — Soil Erosion Story. Toggle between "with trees" and "without
/// trees"; the muddy run-off after rain doubles when forest is gone.
struct Scene5_SoilErosionStory: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var deforested = false

    var body: some View {
        VStack(spacing: 14) {
            Text("Soil Erosion Story").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Toggle the forest. See how much muddy water washes away after rain.")
                .font(.callout).foregroundColor(.secondary).multilineTextAlignment(.center)

            Picker("", selection: $deforested) {
                Text("🌳 With trees").tag(false)
                Text("🪓 Deforested").tag(true)
            }
            .pickerStyle(.segmented).frame(maxWidth: 360)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.green.opacity(0.15))
                    .frame(width: 420, height: 260)
                VStack(spacing: 12) {
                    Text(deforested ? "☁️🌧" : "☁️🌧🌳🌳🌳").font(.system(size: 36))
                    Spacer()
                    HStack {
                        Spacer()
                        Text(deforested ? "💧💧💧💧💧" : "💧").font(.system(size: 24))
                            .foregroundColor(Color.compatBrown)
                    }
                }
                .frame(width: 420, height: 260)
                .padding(12)
            }

            Text(deforested ? "Heavy erosion — topsoil lost!" : "Roots hold soil — minimal erosion")
                .font(.title3.weight(.semibold))
                .foregroundColor(deforested ? .red : .green)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Roots are nature's net", systemImage: "leaf.fill")
                        .font(.title2.bold())
                    Text("Tree roots hold soil in place. When forests are cut, rain washes away the fertile topsoil — this is soil erosion. It can take centuries to form even an inch of new soil.")
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
