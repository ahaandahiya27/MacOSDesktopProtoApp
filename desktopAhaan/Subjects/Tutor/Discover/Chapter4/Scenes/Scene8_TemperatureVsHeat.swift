import SwiftUI

/// Scene 8 — Temperature vs Heat.
/// Two glasses at the same temperature but different volumes. Pour into a bathtub to see the difference.

struct Scene8_TemperatureVsHeat: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var poured = false
    @State private var pourProgress: CGFloat = 0
    @State private var tubColorA: Color = Color.compatCyan.opacity(0.3)
    @State private var tubColorB: Color = Color.compatCyan.opacity(0.3)
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 20) {
                    Spacer()

                    // Both glasses and thermometers
                    HStack(spacing: 60) {
                        // Glass A — small
                        VStack(spacing: 8) {
                            Text("Glass A").font(.headline)
                            Text("50 ml  ·  80°C").font(.caption.weight(.medium)).foregroundColor(.orange)

                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 40, height: 60)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(LinearGradient(colors: [.orange.opacity(0.7), .red.opacity(0.5)], startPoint: .bottom, endPoint: .top))
                                    .frame(width: 36, height: poured ? 10 : 50)
                                    .offset(y: poured ? 22 : 2)
                            }
                            .frame(width: 50, height: 70)
                            .accessibilityLabel("Small glass, 50 millilitres at 80 degrees")

                            Image(systemName: SFSymbolCompat.name("thermometer.high"))
                                .font(.title2)
                                .foregroundColor(.red)
                            Text("80°C")
                                .font(.caption.bold().monospacedDigit())
                                .foregroundColor(.red)
                        }

                        Text("vs")
                            .font(.title.bold())
                            .foregroundColor(.secondary)

                        // Glass B — large
                        VStack(spacing: 8) {
                            Text("Glass B").font(.headline)
                            Text("500 ml  ·  80°C").font(.caption.weight(.medium)).foregroundColor(.orange)

                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 80, height: 110)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(LinearGradient(colors: [.orange.opacity(0.7), .red.opacity(0.5)], startPoint: .bottom, endPoint: .top))
                                    .frame(width: 74, height: poured ? 20 : 95)
                                    .offset(y: poured ? 40 : 4)
                            }
                            .frame(width: 90, height: 120)
                            .accessibilityLabel("Large glass, 500 millilitres at 80 degrees")

                            Image(systemName: SFSymbolCompat.name("thermometer.high"))
                                .font(.title2)
                                .foregroundColor(.red)
                            Text("80°C")
                                .font(.caption.bold().monospacedDigit())
                                .foregroundColor(.red)
                        }
                    }

                    // Bathtubs
                    if poured {
                        HStack(spacing: 50) {
                            bathtubView(label: "Tub A", color: tubColorA, tempLabel: "~21°C")
                            bathtubView(label: "Tub B", color: tubColorB, tempLabel: "~28°C")
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    if !poured {
                        Button("Pour both into bathtubs!") {
                            pourWater()
                        }
                        
                        .accentColor(.orange)
                        .font(.title3.weight(.semibold))
                    }

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Temperature vs Heat", systemImage: "flame.fill")
                                .font(.title2.bold())
                            Text(poured
                                 ? "Both glasses were at 80°C (same temperature), but Glass B had 10 times more water — so it carried 10 times more heat energy! Temperature tells how hot; heat tells how much energy."
                                 : "Both glasses are at 80°C. Same temperature. But is the amount of heat the same? Press the button to find out!")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    if poured {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    private func bathtubView(label: String, color: Color, tempLabel: String) -> some View {
        VStack(spacing: 6) {
            Text(label).font(.caption.bold())
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    .frame(width: 120, height: 60)
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.gray.opacity(0.4), lineWidth: 2)
                    .frame(width: 120, height: 60)
                Text(tempLabel)
                    .font(.headline.monospacedDigit())
                    .foregroundColor(.primary)
            }
            .accessibilityLabel("\(label) water temperature \(tempLabel)")
        }
    }

    private func pourWater() {
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 1.0)) {
            poured = true
        }
        // Animate tub colors
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000)
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 1.0)) {
                tubColorA = Color.compatCyan.opacity(0.35) // barely warmer
                tubColorB = .orange.opacity(0.4) // noticeably warmer
            }
        }
    }
}
