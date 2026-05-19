import SwiftUI

/// Scene 1 — Spinning Earth.
/// Interactive day/night demonstration. A circle representing Earth with a vertical
/// dividing line between day (yellow) and night (dark blue). Tap "Spin" to rotate.
/// After 3 spins the Got It button appears.

struct Scene1_SpinningEarth: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var rotationAngle: Double = 0
    @State private var spinCount: Int = 0
    @State private var isSpinning = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var allDone: Bool { spinCount >= 3 }

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack so
        // explanation cards don't cover the interactive content.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: 16) {
                    Text("Spinning Earth")
                        .font(.largeTitle.bold())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .padding(.top, 18)

                    Text("Tap Spin to watch Earth rotate and create day & night.")
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                    Spacer()

                    // Earth + Sun scene
                    HStack(spacing: 60) {
                        // Sun
                        VStack(spacing: 6) {
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 54))
                                .foregroundColor(.yellow)
                                .shadow(color: .yellow.opacity(0.5), radius: 12)
                            Text("Sun")
                                .font(.caption.weight(.medium))
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }

                        // Earth
                        ZStack {
                            // Night side (dark blue)
                            Circle()
                                .fill(Color(red: 0.08, green: 0.08, blue: 0.3))
                                .frame(width: 160, height: 160)

                            // Day side (clipped half)
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.green.opacity(0.7), Color.compatCyan.opacity(0.5)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 160, height: 160)
                                .clipShape(
                                    DayHalfShape()
                                )
                                .rotationEffect(.degrees(rotationAngle))

                            // Axis line
                            Capsule()
                                .fill(.white.opacity(0.6))
                                .frame(width: 2, height: 180)
                                .rotationEffect(.degrees(rotationAngle))

                            // North pole label
                            Text("N")
                                .font(.caption2.bold())
                                .foregroundColor(.white)
                                .offset(y: -88)
                                .rotationEffect(.degrees(rotationAngle))

                            Circle()
                                .strokeBorder(.white.opacity(0.3), lineWidth: 1.5)
                                .frame(width: 160, height: 160)
                        }
                        .accessibilityLabel("Earth with day and night sides, rotated \(spinCount) times")
                    }

                    // Spin button + counter
                    VStack(spacing: 8) {
                        Button {
                            guard !isSpinning else { return }
                            performSpin()
                        } label: {
                            Label("Spin", systemImage: "arrow.triangle.2.circlepath")
                                .font(.title3.weight(.semibold))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                        }
                        
                        .accentColor(Color.compatIndigo)
                        .disabled(isSpinning)

                        Text("\(spinCount) / 3 rotations")
                            .font(.caption.weight(.medium))
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                    .padding(.top, 8)

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Day & Night", systemImage: SFSymbolCompat.name("globe.americas.fill"))
                                .font(.title2.bold())
                            Text(explanationText)
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 Physics → JEE (Rotational Mechanics)",
                        detail: "Earth spins at 1670 km/h at the equator yet you can't feel it — because YOU spin with it. JEE asks 'why do hurricanes spin opposite ways in the two hemispheres?' Answer: Coriolis effect — a consequence of the rotating frame. NEET asks 'why does the Sun rise in the East?' — because Earth rotates West → East; the Sun appears to move East → West relative to the ground."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Coriolis-effect water-drain myth",
                        detail: "The popular claim that water spirals opposite ways in north/south hemispheres is mostly wrong at sink scale (the effect is too weak — basin geometry dominates). But on hurricane scale it's real. Watch a satellite image of any big storm: northern hemisphere storms spin counter-clockwise, southern clockwise. Earth's rotation is steering the wind."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if allDone {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                
                }
                .padding(.horizontal, 24)
            
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    // MARK: - Helpers

    private var explanationText: String {
        if spinCount == 0 {
            return "Earth rotates on its axis from west to east, completing one full turn every 24 hours. The side facing the Sun has day; the opposite side has night. Tap Spin to see it in action!"
        } else if spinCount < 3 {
            return "Each full spin = one day (24 hours). The half facing the Sun is lit up (day) while the other half stays dark (night). Keep spinning!"
        } else {
            return "Earth spins west to east, so the eastern part of India (like Arunachal Pradesh) sees sunrise before the western part (like Gujarat). One full rotation = one day = 24 hours."
        }
    }

    private func performSpin() {
        isSpinning = true
        let target = rotationAngle + 360
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 1.5)) {
            rotationAngle = target
        }
        let delay = UInt64((reduceMotion ? 0.1 : 1.6) * 1_000_000_000)
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: delay)
            spinCount += 1
            isSpinning = false
        }
    }
}

// MARK: - Day Half Shape

/// Clips to the left half of the bounding rect (the Sun-facing side).
private struct DayHalfShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path(CGRect(x: rect.minX, y: rect.minY,
                    width: rect.width / 2, height: rect.height))
    }
}
