import SwiftUI

/// Scene 2 — Photosynthesis Lab.
///
/// The kid clicks fuel buttons (Water, Air, Sunlight). Each tap fills its
/// corresponding ingredient tile. When all three are filled, the green "Cook!"
/// button activates. Tapping it animates the tiles compressing into the leaf
/// in the centre, the leaf glowing white-hot, and glucose + oxygen bursting
/// out the other side.

struct Scene2_PhotosynthesisLab: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var hasWater = false
    @State private var hasCO2 = false
    @State private var hasSun = false
    @State private var cooking = false
    @State private var produced = false
    @State private var burstActive = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var canCook: Bool { hasWater && hasCO2 && hasSun && !cooking }

    private var textbookExplanation: String {
        pack.conceptIndex["ch01_t01_c02"]?.explanation(at: .textbook)
            ?? "Photosynthesis is the process by which green plants make their food using carbon dioxide, water, sunlight and chlorophyll, releasing oxygen as a by-product."
    }

    var body: some View {
        VStack(spacing: 18) {
            Text("Photosynthesis Lab")
                .font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .padding(.top, 18)

            // Fuel buttons
            HStack(spacing: 16) {
                FuelButton(label: "Water", emoji: "💧", tint: .blue, on: $hasWater)
                FuelButton(label: "Air",   emoji: "💨", tint: .gray, on: $hasCO2)
                FuelButton(label: "Sunlight", emoji: "☀️", tint: .orange, on: $hasSun)
            }

            // Equation row
            HStack(spacing: 12) {
                IngredientTile(emoji: "💧", label: "6 H₂O", filled: hasWater)
                Text("+").font(.title.bold()).foregroundColor(.secondary)
                IngredientTile(emoji: "☁️", label: "6 CO₂", filled: hasCO2)
                Text("+").font(.title.bold()).foregroundColor(.secondary)
                IngredientTile(emoji: "☀️", label: "Light", filled: hasSun)
                Text("→").font(.title.bold()).foregroundColor(.secondary)
                IngredientTile(emoji: "🍇", label: "C₆H₁₂O₆", filled: produced, color: .purple)
                Text("+").font(.title.bold()).foregroundColor(.secondary)
                IngredientTile(emoji: "💨", label: "6 O₂", filled: produced, color: Color.compatTeal)
            }
            .padding(.horizontal, 12)

            // The reactor: the leaf in the middle
            ZStack {
                if cooking && !reduceMotion {
                    Circle()
                        .fill(.white.opacity(0.85))
                        .frame(width: 200, height: 200)
                        .blur(radius: 40)
                }
                DrawnLeaf(pulse: cooking ? 1 : 0)
                    .frame(width: 180, height: 220)
                    .scaleEffect(cooking ? 1.08 : 1)

                if burstActive {
                    ParticleEmitter(
                        isActive: burstActive,
                        particleCount: 50,
                        duration: 1.2,
                        palette: [.purple, .pink, Color.compatTeal, .green]
                    )
                    .frame(width: 360, height: 200)
                    .allowsHitTesting(false)
                }
            }
            .frame(height: 220)

            // Cook button
            Button {
                cookSequence()
            } label: {
                Label(cooking ? "Cooking…" : (produced ? "Made it!" : "Cook!"),
                      systemImage: produced ? "sparkles" : "flame.fill")
                    .font(.title3.bold())
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
            
            .accentColor(canCook ? .green : .gray)
            .disabled(!canCook && !produced)

            if produced {
                SoftShadowCard(padding: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("What I learned", systemImage: "book.fill")
                            .font(.headline)
                            .foregroundColor(Color.compatIndigo)
                        Text(textbookExplanation)
                            .font(.callout)
                    }
                }
                .frame(maxWidth: 720)
            }

            LookingAheadCallout(
                title: "Class 12 Biology → NEET",
                detail: "You'll meet TWO photosynthesis pathways in NEET: C3 plants (rice, wheat) and C4 plants (sugarcane, maize, the speed champions). The reactant ratio you just balanced is the same; the trick C4 plants pull is concentrating CO₂ near the chlorophyll so the enzyme RuBisCO doesn't waste energy on photorespiration. Tropical heat = C4 advantage."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Count the bubbles",
                detail: "Take a small sprig of pondweed (Hydrilla / Elodea — pet shops sell it). Drop it into a glass of water with a pinch of baking soda dissolved (CO₂ source). Cover the sprig with a funnel; balance a test tube on top. Shine a desk lamp on it. Count bubbles of O₂ escaping for 1 minute. Move the lamp closer — count again. You just measured the rate of photosynthesis."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            HStack(spacing: 12) {
                Button("🔁 Try again") { resetEverything() }
                    .buttonStyle(.bordered)
                    .disabled(!produced)
                VStack(spacing: 4) {
                    GotItButton(action: onComplete)
                        .disabled(!produced)
                        .opacity(produced ? 1 : 0.5)
                    if !produced {
                        Text("Complete the experiment to continue")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.bottom, 12)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func cookSequence() {
        guard canCook else { return }
        cooking = true
        withAnimation(reduceMotion ? .none : .easeIn(duration: 0.8)) {
            // Just shows the cooking visual; nothing else to set here.
        }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.7)) {
                produced = true
                burstActive = true
            }
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            burstActive = false
            cooking = false
        }
    }

    private func resetEverything() {
        withAnimation(.easeInOut) {
            hasWater = false
            hasCO2 = false
            hasSun = false
            produced = false
            cooking = false
            burstActive = false
        }
    }
}

private struct FuelButton: View {
    let label: String
    let emoji: String
    let tint: Color
    @Binding var on: Bool

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { on = true }
        } label: {
            VStack(spacing: 4) {
                Text(emoji).font(.system(size: 28))
                Text(label).font(.callout.weight(.medium))
            }
            .frame(width: 96, height: 80)
        }
        
        .accentColor(tint)
        .opacity(on ? 0.5 : 1)
        .accessibilityLabel("Add \(label)")
    }
}

private struct IngredientTile: View {
    let emoji: String
    let label: String
    let filled: Bool
    var color: Color = .blue

    var body: some View {
        VStack(spacing: 4) {
            Text(emoji)
                .font(.system(size: 28))
                .opacity(filled ? 1 : 0.25)
            Text(label)
                .font(.caption.weight(.medium))
        }
        .frame(width: 78, height: 70)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(filled ? color.opacity(0.18) : Color.gray.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(filled ? color.opacity(0.5) : Color.gray.opacity(0.25),
                              lineWidth: 1.2)
        )
    }
}
