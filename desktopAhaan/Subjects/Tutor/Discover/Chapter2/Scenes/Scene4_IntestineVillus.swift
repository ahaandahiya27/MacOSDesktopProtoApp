import SwiftUI

/// Scene 4 — The Intestine Villus Tour.
///
/// A coiled small intestine drawn with a curving Path. A "Zoom" button enters
/// into one segment revealing villi. A second zoom shows microvilli. Glucose
/// particles animate from lumen → villus → blood vessel. Text from
/// ch02_t01_c05 and ch02_t01_c11.
@available(macOS 12, *)
struct Scene4_IntestineVillus: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var zoomLevel: Int = 0 // 0: full intestine, 1: villi, 2: microvilli
    @State private var glucoseParticles: [GlucoseParticle] = []
    @State private var sceneActive = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var villusExplanation: String {
        pack.conceptIndex["ch02_t01_c05"]?.explanation(at: .kidFriendly)
            ?? "The small intestine has millions of villi (tiny finger-like bumps) that absorb nutrients into your blood."
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 16) {
                Text(zoomLevel == 0 ? "The Intestine Villus Tour" : zoomLevel == 1 ? "Inside the Villus" : "Microvilli Detail")
                    .font(.title.bold())
                    .foregroundColor(.blue)

                ZStack {
                    if zoomLevel == 0 {
                        FullIntestineView()
                    } else if zoomLevel == 1 {
                        VilliView(glucoseParticles: $glucoseParticles)
                    } else {
                        MicrovilliView(glucoseParticles: $glucoseParticles)
                    }
                }
                .frame(height: 240)
                .padding(.horizontal, 24)

                HStack(spacing: 12) {
                    if zoomLevel > 0 {
                        Button(action: { zoomOut() }) {
                            Label("Zoom Out", systemImage: "magnifyingglass.circle.fill")
                        }
                        
                    }

                    if zoomLevel < 2 {
                        Button(action: { zoomIn() }) {
                            Label("Zoom In", systemImage: "magnifyingglass.circle.fill")
                        }
                        
                        .accentColor(.blue)
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)

                Spacer()

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("The Intestine Villus Tour", systemImage: "smallcircle.filled.circle.fill")
                            .font(.title2.bold())
                            .foregroundColor(.blue)
                        Text(villusExplanation)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                    }
                }
                .frame(maxWidth: 640)

                GotItButton { onComplete() }
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                sceneActive = true
                startGlucoseAnimation()
            }
            .onDisappear {
                sceneActive = false
            }
        }
    }

    private func zoomIn() {
        withAnimation(.easeInOut(duration: 0.4)) {
            zoomLevel = min(2, zoomLevel + 1)
        }
    }

    private func zoomOut() {
        withAnimation(.easeInOut(duration: 0.4)) {
            zoomLevel = max(0, zoomLevel - 1)
        }
    }

    private func startGlucoseAnimation() {
        if reduceMotion { return }
        animateGlucose()
    }

    private func animateGlucose() {
        guard sceneActive else { return }
        var particles: [GlucoseParticle] = []
        for i in 0..<4 {
            particles.append(GlucoseParticle(
                id: i,
                x: CGFloat.random(in: 80...120),
                y: 100 + CGFloat(i) * 20
            ))
        }
        glucoseParticles = particles
        let count = particles.count

        Task { @MainActor in
            for i in 0..<count {
                try? await Task.sleep(nanoseconds: 300_000_000)
                guard sceneActive else { return }
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 1.5)) {
                    if i < glucoseParticles.count {
                        glucoseParticles[i].x = 280
                        glucoseParticles[i].y = 180
                    }
                }
            }
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            animateGlucose()
        }
    }
}

// MARK: - Full Intestine View

@available(macOS 12, *)
struct FullIntestineView: View {
    var body: some View {
        Canvas { context, _ in
            var path = Path()
            let center = CGPoint(x: 200, y: 120)

            // Coiled small intestine shape
            for i in 0...3 {
                let angle = CGFloat(i) * .pi / 2
                let x = center.x + 60 * cos(angle)
                let y = center.y + 60 * sin(angle)
                let nextI = i + 1
                let nextAngle = CGFloat(nextI) * .pi / 2
                let nextX = center.x + 60 * cos(nextAngle)
                let nextY = center.y + 60 * sin(nextAngle)

                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                }
                path.addCurve(
                    to: CGPoint(x: nextX, y: nextY),
                    control1: CGPoint(x: x + 20, y: y + 20),
                    control2: CGPoint(x: nextX - 20, y: nextY - 20)
                )
            }

            context.stroke(
                path,
                with: .color(.blue.opacity(0.6)),
                lineWidth: 12
            )
        }
    }
}

// MARK: - Villi View

@available(macOS 12, *)
struct VilliView: View {
    @Binding var glucoseParticles: [GlucoseParticle]

    var body: some View {
        Canvas { context, _ in
            let lumenY: CGFloat = 60
            let bloodVesselY: CGFloat = 200

            // Intestinal lumen (top)
            context.fill(
                Path(roundedRect: CGRect(x: 80, y: lumenY - 20, width: 240, height: 30), cornerRadius: 4),
                with: .color(.yellow.opacity(0.3))
            )
            context.stroke(
                Path(roundedRect: CGRect(x: 80, y: lumenY - 20, width: 240, height: 30), cornerRadius: 4),
                with: .color(.orange.opacity(0.5)),
                lineWidth: 1
            )

            // Draw 6 villi as finger-like structures
            for i in 0..<6 {
                let x = 110 + CGFloat(i) * 35
                let villPath = Path()
                var villPath2 = villPath
                villPath2.move(to: CGPoint(x: x, y: lumenY))
                villPath2.addCurve(
                    to: CGPoint(x: x, y: bloodVesselY - 20),
                    control1: CGPoint(x: x - 8, y: lumenY + 40),
                    control2: CGPoint(x: x - 8, y: bloodVesselY - 40)
                )
                context.stroke(
                    villPath2,
                    with: .color(.pink.opacity(0.7)),
                    lineWidth: 3
                )
            }

            // Blood vessel (bottom)
            context.fill(
                Path(roundedRect: CGRect(x: 80, y: bloodVesselY, width: 240, height: 25), cornerRadius: 4),
                with: .color(.red.opacity(0.2))
            )
            context.stroke(
                Path(roundedRect: CGRect(x: 80, y: bloodVesselY, width: 240, height: 25), cornerRadius: 4),
                with: .color(.red.opacity(0.5)),
                lineWidth: 1
            )

            // Draw glucose particles
            for particle in glucoseParticles {
                context.fill(
                    Circle().path(in: CGRect(x: particle.x - 4, y: particle.y - 4, width: 8, height: 8)),
                    with: .color(.green.opacity(0.8))
                )
            }
        }
    }
}

// MARK: - Microvilli View

@available(macOS 12, *)
struct MicrovilliView: View {
    @Binding var glucoseParticles: [GlucoseParticle]

    var body: some View {
        Canvas { context, _ in
            let tipY: CGFloat = 80
            let baseY: CGFloat = 180

            // Villus tip surface
            context.fill(
                Path(ellipseIn: CGRect(x: 100, y: tipY - 15, width: 200, height: 30)),
                with: .color(.pink.opacity(0.2))
            )

            // Draw 12 microvilli as tiny finger-like projections
            for i in 0..<12 {
                let x = 110 + CGFloat(i) * 17
                var microPath = Path()
                microPath.move(to: CGPoint(x: x, y: tipY))
                microPath.addCurve(
                    to: CGPoint(x: x, y: baseY - 20),
                    control1: CGPoint(x: x - 4, y: tipY + 30),
                    control2: CGPoint(x: x - 4, y: baseY - 30)
                )
                context.stroke(
                    microPath,
                    with: .color(.purple.opacity(0.6)),
                    lineWidth: 2
                )
            }

            // Nutrient absorption zone
            context.fill(
                Path(roundedRect: CGRect(x: 80, y: baseY, width: 240, height: 35), cornerRadius: 4),
                with: .color(.blue.opacity(0.15))
            )

            // Draw glucose particles
            for particle in glucoseParticles {
                context.fill(
                    Circle().path(in: CGRect(x: particle.x - 3, y: particle.y - 3, width: 6, height: 6)),
                    with: .color(Color.compatCyan.opacity(0.8))
                )
            }
        }
    }
}

// MARK: - Model

struct GlucoseParticle: Identifiable {
    let id: Int
    var x: CGFloat
    var y: CGFloat
}
