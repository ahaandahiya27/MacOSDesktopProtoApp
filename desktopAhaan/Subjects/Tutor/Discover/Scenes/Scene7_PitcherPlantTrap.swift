import SwiftUI

/// Scene 7 — The Pitcher Plant Trap. A short hand-drawn animation: a fly
/// hovers, lands on the rim, slips, tumbles into the pitcher, and dissolves
/// into a green digestive juice.

struct Scene7_PitcherPlantTrap: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var phase: Int = 0   // 0 idle, 1 hover, 2 slip, 3 fall, 4 dissolve
    @State private var fast = false
    @State private var nitrogenAdded = false
    @State private var showWhy = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var stepDuration: Double { fast ? 0.4 : 1.2 }

    private var expertExplanation: String {
        pack.conceptIndex["ch01_t02_c02"]?.explanation(at: .expert)
            ?? "Pitcher plants thrive in nitrogen-poor soil. Carnivory evolved to supplement nitrogen by digesting trapped insects with proteolytic enzymes."
    }

    var body: some View {
        // ScrollView + LazyVStack: natural bounded height; shell footer
        // stays reachable on shorter windows.
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("The Pitcher Plant Trap")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)

            ZStack {
                // The pitcher body
                PitcherShape()
                    .fill(
                        LinearGradient(
                            colors: [.green.opacity(0.85), .green.opacity(0.55)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .frame(width: 220, height: 320)
                    .shadow(color: .green.opacity(0.4), radius: 12, x: 0, y: 6)

                // Digestive juice fill — grows when fly is digested
                ZStack(alignment: .bottom) {
                    PitcherShape()
                        .fill(.clear)
                        .frame(width: 220, height: 320)
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.green.opacity(0.7), .green.opacity(0.95)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .frame(width: 200, height: phase >= 4 ? 140 : 80)
                        .clipShape(PitcherShape())
                        .frame(width: 220, height: 320, alignment: .bottom)
                        .respectReduceMotion(animation: .easeInOut(duration: stepDuration))
                }

                // Glow at the rim — attracts the fly
                if phase < 3 {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.yellow.opacity(0.7), .clear],
                                startPoint: .center, endPoint: .bottom
                            )
                        )
                        .frame(width: 180, height: 30)
                        .offset(y: -130)
                        .blur(radius: 10)
                        .opacity(phase == 0 || phase == 1 ? 1 : 0.3)
                }

                // The fly
                FlyView()
                    .opacity(phase < 4 ? 1 : 0.001)
                    .scaleEffect(phase >= 3 ? 0.55 : 1)
                    .offset(flyOffset)
                    .rotationEffect(.degrees(flyRotation))
                    .animation(reduceMotion ? .none : .easeInOut(duration: stepDuration))
            }
            .frame(width: 240, height: 340)

            if nitrogenAdded {
                Label("Nitrogen absorbed: +1 🌱", systemImage: SFSymbolCompat.name("leaf.arrow.circlepath"))
                    .font(.headline)
                    .foregroundColor(.green)
                    .transition(.opacity)  // Big Sur: combined-with-.scale can render-loop
            }

            HStack(spacing: 12) {
                Button("🔁 Watch again") { restart() }
                    .buttonStyle(.bordered)
                Toggle("Run faster ⏩", isOn: $fast)
                    .toggleStyle(.switch)
                    .controlSize(.small)
            }

            ExpandableCard(
                isExpanded: $showWhy,
                systemImage: "questionmark.circle.fill",
                title: "Why does it eat insects?",
                tint: Color.compatIndigo,
                background: Color.compatIndigo.opacity(0.06)
            ) {
                Text(expertExplanation)
                    .font(.callout)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: 580)

            LookingAheadCallout(
                title: "Class 11 Biology / NEET",
                detail: "Insectivorous plants are NEET-favourite case studies of convergent evolution: Nepenthes (Asian pitcher), Sarracenia (American pitcher), and Drosera (sundew) all evolved insect-trapping independently from different ancestors — driven by the same problem (low-nitrogen soils) toward the same solution (catch your own nitrogen). Same mathematician, three different proofs."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Spot one for real",
                detail: "Botanical gardens in most Indian cities (Lalbagh in Bangalore, Indian Botanic Garden in Howrah) keep pitcher plants and Venus flytraps in their conservatories. Watch carefully — the pitcher's mouth is slippery, the inside hairs all point downward, and there's a centimetre of digestive fluid waiting at the bottom. Evolution doesn't have a brain, but it engineers."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

                GotItButton(action: onComplete)
                    .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
        .onAppear { startSequenceIfNeeded() }
    }

    // MARK: - Animation script

    private var flyOffset: CGSize {
        switch phase {
        case 0: return CGSize(width: 80, height: -200)
        case 1: return CGSize(width: 30, height: -150)
        case 2: return CGSize(width: 0, height: -110)
        case 3: return CGSize(width: 0, height: 30)
        default: return CGSize(width: 0, height: 80)
        }
    }

    private var flyRotation: Double {
        switch phase {
        case 2: return -25
        case 3: return 90
        case 4: return 140
        default: return 0
        }
    }

    private func startSequenceIfNeeded() {
        guard phase == 0 else { return }
        runStep()
    }

    private func runStep() {
        if reduceMotion {
            // Skip animation entirely.
            phase = 4
            nitrogenAdded = true
            return
        }
        Task { @MainActor in
            let step = stepDuration
            try? await Task.sleep(nanoseconds: UInt64(step * 0.6 * 1_000_000_000))
            withAnimation(.easeInOut(duration: step)) { phase = 1 }
            try? await Task.sleep(nanoseconds: UInt64(step * 1.0 * 1_000_000_000))
            withAnimation(.easeInOut(duration: step)) { phase = 2 }
            try? await Task.sleep(nanoseconds: UInt64(step * 1.0 * 1_000_000_000))
            withAnimation(.easeIn(duration: step)) { phase = 3 }
            try? await Task.sleep(nanoseconds: UInt64(step * 1.4 * 1_000_000_000))
            withAnimation(.easeOut(duration: step)) { phase = 4 }
            withAnimation(.spring().delay(0.2)) { nitrogenAdded = true }
        }
    }

    private func restart() {
        nitrogenAdded = false
        phase = 0
        runStep()
    }
}

private struct FlyView: View {
    var body: some View {
        Text("🪰")
            .font(.system(size: 36))
            .accessibilityHidden(true)
    }
}

private struct PitcherShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Top rim
        p.move(to: CGPoint(x: w * 0.18, y: h * 0.22))
        // Left side curving down to the bulb
        p.addCurve(
            to: CGPoint(x: w * 0.15, y: h * 0.85),
            control1: CGPoint(x: w * -0.05, y: h * 0.45),
            control2: CGPoint(x: w * -0.02, y: h * 0.78)
        )
        // Bottom round
        p.addQuadCurve(
            to: CGPoint(x: w * 0.85, y: h * 0.85),
            control: CGPoint(x: w * 0.5, y: h * 1.05)
        )
        // Right side curving back up
        p.addCurve(
            to: CGPoint(x: w * 0.82, y: h * 0.22),
            control1: CGPoint(x: w * 1.02, y: h * 0.78),
            control2: CGPoint(x: w * 1.05, y: h * 0.45)
        )
        // Top opening
        p.addQuadCurve(
            to: CGPoint(x: w * 0.18, y: h * 0.22),
            control: CGPoint(x: w * 0.5, y: h * 0.18)
        )
        p.closeSubpath()
        return p
    }
}
