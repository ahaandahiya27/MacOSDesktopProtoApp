import SwiftUI

/// Scene 4 — The Intestine Villus Tour.
///
/// A coiled small intestine drawn with a curving Path. A "Zoom" button enters
/// into one segment revealing villi. A second zoom shows microvilli. Glucose
/// particles animate from lumen → villus → blood vessel. Text from
/// ch02_t01_c05 and ch02_t01_c11.
///
/// Big Sur (macOS 11) compatible — Full intestine coil, villi, and
/// microvilli diagrams use custom Shapes / standard Ellipses instead of
/// Canvas blocks.
struct Scene4_IntestineVillus: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var zoomLevel: Int = 0 // 0: full intestine, 1: villi, 2: microvilli
    @State private var glucoseParticles: [GlucoseParticle] = []
    @State private var sceneActive = false
    @State private var intestineMetres: Double = 7   // free-play slider: intestine length
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
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth)

                DiscoveryWidget(
                    title: "Discovery — try a different intestine length",
                    subtitle: "Human small intestine is ~7 m long, with villi multiplying surface area ~600×. Drag to see absorption surface in tennis-court equivalents.",
                    value: $intestineMetres,
                    range: 1...12,
                    step: 0.5,
                    valueLabel: { v in String(format: "Length: %.1f m", v) },
                    output: intestineSurfaceExplanation
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)

                LookingAheadCallout(
                    title: "Class 11 → NEET (surface-area + diffusion)",
                    detail: "Villi multiply the intestinal surface area ~30× and micro-villi multiply it another 600×. Total absorptive surface: ~250 m² — a tennis court folded into your belly. NEET pairs this with diffusion math (Fick's law: rate ∝ area × concentration gradient ÷ thickness) — every term is solved by villus + capillary anatomy."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Folding for area — the towel trick",
                    detail: "Take a hand towel. Spread it flat — that's how much surface a smooth gut would have. Now scrunch it into hundreds of tiny folds (villi). Spread it back — way more surface fit inside the same outer length! Now imagine each fold has tinier folds on it (micro-villi). That's how 7 metres of intestine fits a tennis-court of absorbing area inside your tummy."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

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

    private func intestineSurfaceExplanation(_ metres: Double) -> String {
        // Bare intestine inner surface ≈ (length m) × (circumference 0.08 m) → m²
        // Villi & microvilli multiply this ~600×.
        let bareArea = metres * 0.08
        let amplifiedArea = bareArea * 600    // m²
        // Tennis singles court ≈ 195 m². Convert.
        let courts = amplifiedArea / 195
        let label: String
        switch metres {
        case ..<2:
            label = "Too short — a baby's intestine, not enough surface to absorb a full meal."
        case ..<5:
            label = "Child-sized intestine. Less absorption headroom, smaller meals."
        case 5...8:
            label = "Adult-typical (7 m). Villi + microvilli make this the gold standard."
        default:
            label = "Above-average length. Some herbivores (cows, sheep) have far longer intestines to digest cellulose."
        }
        let header = String(format: "Absorbing surface ≈ %.0f m² ≈ %.1f tennis courts.", amplifiedArea, courts)
        return "\(header) \(label)"
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

/// Coiled small intestine outline. Was Canvas; now a custom Shape so it
/// renders on Big Sur.
struct FullIntestineView: View {
    var body: some View {
        IntestineCoilShape()
            .stroke(Color.blue.opacity(0.6), lineWidth: 12)
    }
}

struct IntestineCoilShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: 200, y: 120)
        for i in 0...3 {
            let angle = CGFloat(i) * .pi / 2
            let x = center.x + 60 * cos(angle)
            let y = center.y + 60 * sin(angle)
            let nextI = i + 1
            let nextAngle = CGFloat(nextI) * .pi / 2
            let nextX = center.x + 60 * cos(nextAngle)
            let nextY = center.y + 60 * sin(nextAngle)
            if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
            path.addCurve(
                to: CGPoint(x: nextX, y: nextY),
                control1: CGPoint(x: x + 20, y: y + 20),
                control2: CGPoint(x: nextX - 20, y: nextY - 20)
            )
        }
        return path
    }
}

// MARK: - Villi View

/// Villi zoom level. Rebuilt as a ZStack of RoundedRectangle (lumen +
/// blood vessel) + a VilliFingersShape for the finger-like villi, with
/// the glucose particles rendered as positioned circles.
struct VilliView: View {
    @Binding var glucoseParticles: [GlucoseParticle]

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Lumen (top)
            ZStack {
                RoundedRectangle(cornerRadius: 4).fill(Color.yellow.opacity(0.3))
                RoundedRectangle(cornerRadius: 4).stroke(Color.orange.opacity(0.5), lineWidth: 1)
            }
            .frame(width: 240, height: 30)
            .offset(x: 80, y: 40)

            // Villi finger curves
            VilliFingersShape(count: 6, startX: 110, stepX: 35, topY: 60, bottomY: 180)
                .stroke(Color.pink.opacity(0.7), lineWidth: 3)

            // Blood vessel (bottom)
            ZStack {
                RoundedRectangle(cornerRadius: 4).fill(Color.red.opacity(0.2))
                RoundedRectangle(cornerRadius: 4).stroke(Color.red.opacity(0.5), lineWidth: 1)
            }
            .frame(width: 240, height: 25)
            .offset(x: 80, y: 200)

            // Glucose particles
            ForEach(glucoseParticles) { particle in
                Circle()
                    .fill(Color.green.opacity(0.8))
                    .frame(width: 8, height: 8)
                    .position(x: particle.x, y: particle.y)
            }
        }
    }
}

/// `count` finger-like quadratic curves used by both VilliView (6
/// fingers, larger control offset) and MicrovilliView (12 fingers,
/// smaller offset).
struct VilliFingersShape: Shape {
    let count: Int
    let startX: CGFloat
    let stepX: CGFloat
    let topY: CGFloat
    let bottomY: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        // The original offset was -8 for villi, -4 for microvilli. Derive
        // proportional to stepX so the helper works for both.
        let controlOffset: CGFloat = stepX > 20 ? -8 : -4
        for i in 0..<count {
            let x = startX + CGFloat(i) * stepX
            p.move(to: CGPoint(x: x, y: topY))
            p.addCurve(
                to: CGPoint(x: x, y: bottomY - 20),
                control1: CGPoint(x: x + controlOffset, y: topY + 40),
                control2: CGPoint(x: x + controlOffset, y: bottomY - 40)
            )
        }
        return p
    }
}

// MARK: - Microvilli View

struct MicrovilliView: View {
    @Binding var glucoseParticles: [GlucoseParticle]

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Villus tip surface
            Ellipse()
                .fill(Color.pink.opacity(0.2))
                .frame(width: 200, height: 30)
                .offset(x: 100, y: 65)

            // Microvilli finger curves (12 thinner fingers)
            VilliFingersShape(count: 12, startX: 110, stepX: 17, topY: 80, bottomY: 180)
                .stroke(Color.purple.opacity(0.6), lineWidth: 2)

            // Nutrient absorption zone
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue.opacity(0.15))
                .frame(width: 240, height: 35)
                .offset(x: 80, y: 180)

            // Glucose particles (smaller, cyan)
            ForEach(glucoseParticles) { particle in
                Circle()
                    .fill(Color.compatCyan.opacity(0.8))
                    .frame(width: 6, height: 6)
                    .position(x: particle.x, y: particle.y)
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
