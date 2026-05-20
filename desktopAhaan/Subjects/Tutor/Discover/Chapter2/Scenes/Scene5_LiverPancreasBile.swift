import SwiftUI

/// Scene 5 — Liver, Pancreas & Bile.
///
/// Three organs side by side. Tap each to animate its juice flow:
/// - Liver → green bile drips into gallbladder
/// - Pancreas → orange juice flows
/// - Both mix into small intestine as digestive juice
/// Must tap each organ once before "I get it!". Text from ch02_t01_c08 and ch02_t01_c09.

struct Scene5_LiverPancreasBile: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var liverTapped = false
    @State private var pancreasTapped = false
    @State private var bileFlowing = false
    @State private var juiceFlowing = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var organExplanation: String {
        pack.conceptIndex["ch02_t01_c08"]?.explanation(at: .kidFriendly)
            ?? "The liver makes bile to digest fats. The pancreas makes enzymes for all foods. Together they create the perfect digestive juice."
    }

    private var allTapped: Bool {
        liverTapped && pancreasTapped
    }

    var body: some View {

        ScrollView {

            VStack(spacing: 14) {
                Text("Liver, Pancreas & Bile")
                    .font(.title.bold())
                    .foregroundColor(.green)

                ZStack {
                    // Liver
                    VStack(spacing: 12) {
                        Button(action: { tapLiver() }) {
                            VStack(spacing: 4) {
                                Image(systemName: "hexagon.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.green)
                                Text("Liver")
                                    .font(.caption.weight(.semibold))
                            }
                            .padding(12)
                            .background(Color.green.opacity(liverTapped ? 0.3 : 0.1))
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Liver — produces bile")

                        if bileFlowing {
                            VStack(spacing: 2) {
                                ForEach(0..<3, id: \.self) { _ in
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 4, height: 4)
                                }
                            }
                        }
                    }
                    .position(x: 100, y: 100)

                    // Pancreas
                    VStack(spacing: 12) {
                        Button(action: { tapPancreas() }) {
                            VStack(spacing: 4) {
                                Image(systemName: "waveform.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.orange)
                                Text("Pancreas")
                                    .font(.caption.weight(.semibold))
                            }
                            .padding(12)
                            .background(Color.orange.opacity(pancreasTapped ? 0.3 : 0.1))
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Pancreas — makes enzymes")

                        if juiceFlowing {
                            VStack(spacing: 2) {
                                ForEach(0..<3, id: \.self) { _ in
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 4, height: 4)
                                }
                            }
                        }
                    }
                    .position(x: 300, y: 100)

                    // Gallbladder (small pouch under liver)
                    ZStack {
                        ZStack {
                            Circle()
                                .foregroundColor(Color.yellow.opacity(0.3))
                            Circle()
                                .stroke(lineWidth: 1)
                                .foregroundColor(Color.green.opacity(0.5))
                        }
                        Text("GB")
                            .font(.caption2.bold())
                            .foregroundColor(.green)
                    }
                    .frame(width: 30, height: 30)
                    .position(x: 130, y: 160)

                    // Small intestine (bottom)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color.blue.opacity(0.5))
                        .frame(width: 180, height: 40)
                        .position(x: 200, y: 220)

                    Text("Small Intestine")
                        .font(.caption)
                        .position(x: 200, y: 250)
                }
                .frame(height: 280)
                .padding(.horizontal, 24)

                HStack {
                    Text("Tap each organ to see its juice flow")
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    if allTapped {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal, 24)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Liver, Pancreas & Bile", systemImage: "drop.fill")
                            .font(.title2.bold())
                            .foregroundColor(.green)
                        Text(organExplanation)
                            .font(.body)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)

                LookingAheadCallout(
                    title: "Class 12 Biology → NEET",
                    detail: "Bile from liver, pancreatic juice from pancreas — they meet in the duodenum and finish the job stomach acid started. NEET asks 'list 5 enzymes secreted by the pancreas' (trypsin / chymotrypsin / lipase / amylase / nucleases) and 'why does jaundice colour eyes yellow?' (bilirubin from broken-down RBCs can't drain into bile, builds up in blood)."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "See bile emulsify oil",
                    detail: "Mix a tablespoon of cooking oil into a glass of water. Watch the oil sit on top in big globs. Now add a few drops of dish-soap (a surfactant — same job as bile). Stir. The oil breaks into tiny droplets that mix into the water. That's exactly what bile does to dietary fat: breaks it into droplets so the water-loving enzyme lipase can attack."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                if allTapped {
                    GotItButton { onComplete() }
                        .padding(.bottom, 12)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text("Complete all organs first!")
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                        .padding(.bottom, 12)
                }
            

            }

            .frame(maxWidth: .infinity)

            .padding(.bottom, 12)

        }
    }

    private func tapLiver() {
        if !liverTapped {
            liverTapped = true
            bileFlowing = true

            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                bileFlowing = false
            }
        }
    }

    private func tapPancreas() {
        if !pancreasTapped {
            pancreasTapped = true
            juiceFlowing = true

            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                juiceFlowing = false
            }
        }
    }
}
