import SwiftUI

/// Scene 5 — Soil Erosion Story. Toggle between "with trees" and "without
/// trees"; the muddy run-off after rain doubles when forest is gone.
struct Scene5_SoilErosionStory: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var deforested = false

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Soil Erosion Story").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Toggle the forest. See how much muddy water washes away after rain.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).multilineTextAlignment(.center)

                Picker("", selection: $deforested) {
                    Text("🌳 With trees").tag(false)
                    Text("🪓 Deforested").tag(true)
                }
                .pickerStyle(.segmented).discoverControlChrome().frame(maxWidth: 360)

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

                LookingAheadCallout(
                    title: "Class 9 Geography",
                    detail: "Class 9 'Natural Vegetation and Wildlife' covers soil erosion as a deforestation consequence — gully erosion, sheet erosion, ravines (badlands of Chambal). Conservation is in Class 10 'Resources and Development' — terraces, contour ploughing, shelter-belts."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Tilt-plate rainstorm",
                    detail: "Get two plates, fill one with bare soil and the other with the same soil covered in grass clippings. Tilt both at the same angle and sprinkle water from a height. Watch which one washes away."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
