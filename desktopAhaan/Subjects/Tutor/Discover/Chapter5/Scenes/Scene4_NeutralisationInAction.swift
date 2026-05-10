import SwiftUI

/// Scene 4 — Neutralisation in Action.
/// Animated beaker: acid (red) + base (blue) mix to green. H+ and OH- ions combine.
struct Scene4_NeutralisationInAction: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var pourProgress: CGFloat = 0       // 0 = not started, 1 = fully mixed
    @State private var isPouring = false
    @State private var showEquation = false

    private var mixedColor: Color {
        Color(
            red: 1.0 - pourProgress * 0.7,
            green: 0.2 + pourProgress * 0.6,
            blue: pourProgress * 0.6
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 16) {
                    Text("Neutralisation in Action")
                        .font(.title2.bold())
                        .padding(.top, 18)

                    // Beakers row
                    HStack(spacing: 30) {
                        // Acid beaker
                        beaker(label: "Acid (HCl)", color: .red, tiltAngle: isPouring ? -30 : 0)
                            .frame(width: 100, height: 140)

                        // Central mixing beaker
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.gray.opacity(0.08))
                                .frame(width: 120, height: 160)

                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(mixedColor.opacity(0.7))
                                .frame(width: 112, height: 80 + pourProgress * 50)
                                .animation(reduceMotion ? .none : .easeInOut(duration: 1.5), value: pourProgress)

                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .strokeBorder(.gray.opacity(0.4), lineWidth: 2)
                                .frame(width: 120, height: 160)
                        }

                        // Base beaker
                        beaker(label: "Base (NaOH)", color: .blue, tiltAngle: isPouring ? 30 : 0)
                            .frame(width: 100, height: 140)
                    }
                    .padding(.top, 10)

                    // Pour button
                    if !isPouring && pourProgress < 1 {
                        Button {
                            startPouring()
                        } label: {
                            Label("Pour & Mix!", systemImage: "drop.triangle.fill")
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.indigo)
                    }

                    // Ion animation area
                    if isPouring || pourProgress > 0 {
                        ionAnimationView
                            .frame(maxWidth: 500, maxHeight: 120)
                    }

                    // Equation
                    if showEquation {
                        SoftShadowCard(padding: 14) {
                            VStack(spacing: 8) {
                                Text("Acid + Base \u{2192} Salt + Water")
                                    .font(.title3.bold().monospaced())
                                    .foregroundStyle(.indigo)
                                Text("HCl + NaOH \u{2192} NaCl + H\u{2082}O")
                                    .font(.body.monospaced())
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: 500)
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    }

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack(spacing: 14) {
                    Spacer()
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Neutralisation", systemImage: "flask.fill")
                                .font(.title2.bold())
                            Text("When an acid and a base react, they neutralise each other to form a salt and water. The H\u{207A} ions from the acid combine with OH\u{207B} ions from the base.")
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: 640)

                    if pourProgress >= 1 {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Subviews

    private func beaker(label: String, color: Color, tiltAngle: Double) -> some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.gray.opacity(0.08))
                    .frame(width: 60, height: 90)

                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(color.opacity(isPouring ? 0.3 : 0.6))
                    .frame(width: 54, height: isPouring ? 30 : 60)
                    .animation(reduceMotion ? .none : .easeInOut(duration: 1.2), value: isPouring)

                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(.gray.opacity(0.4), lineWidth: 1.5)
                    .frame(width: 60, height: 90)
            }
            .rotationEffect(.degrees(tiltAngle))
            .animation(reduceMotion ? .none : .easeInOut(duration: 0.8), value: tiltAngle)

            Text(label)
                .font(.caption.weight(.medium))
        }
    }

    private var ionAnimationView: some View {
        Group {
            if reduceMotion {
                HStack(spacing: 16) {
                    Text("H\u{207A}")
                        .font(.title2.bold())
                        .foregroundStyle(.red)
                    Text("+")
                        .font(.title2)
                    Text("OH\u{207B}")
                        .font(.title2.bold())
                        .foregroundStyle(.blue)
                    Text("\u{2192}")
                        .font(.title2)
                    Text("H\u{2082}O")
                        .font(.title2.bold())
                        .foregroundStyle(.green)
                }
            } else {
                TimelineView(.animation(minimumInterval: 1.0 / 20)) { ctx in
                    let t = ctx.date.timeIntervalSince1970
                    Canvas { context, size in
                        var gfx = context
                        drawIons(gfx: &gfx, size: size, t: t)
                    }
                }
            }
        }
    }

    private func drawIons(gfx: inout GraphicsContext, size: CGSize, t: TimeInterval) {
        let cx = size.width * 0.5
        let cy = size.height * 0.5

        // H+ ions (red) moving from left
        for i in 0..<4 {
            let phase = (t * 0.8 + Double(i) * 0.6).truncatingRemainder(dividingBy: 3.0) / 3.0
            let x = size.width * 0.1 + phase * (cx - size.width * 0.1)
            let y = cy + sin(t * 2 + Double(i)) * 15
            let rect = CGRect(x: x - 8, y: y - 8, width: 16, height: 16)
            gfx.opacity = 1.0 - phase * 0.5
            gfx.fill(Path(ellipseIn: rect), with: .color(.red))
        }

        // OH- ions (blue) moving from right
        for i in 0..<4 {
            let phase = (t * 0.8 + Double(i) * 0.6).truncatingRemainder(dividingBy: 3.0) / 3.0
            let x = size.width * 0.9 - phase * (size.width * 0.9 - cx)
            let y = cy + cos(t * 2 + Double(i)) * 15
            let rect = CGRect(x: x - 8, y: y - 8, width: 16, height: 16)
            gfx.opacity = 1.0 - phase * 0.5
            gfx.fill(Path(ellipseIn: rect), with: .color(.blue))
        }

        // Water molecules (green) at center
        for i in 0..<3 {
            let spread = sin(t + Double(i) * 2) * 20
            let rect = CGRect(x: cx + spread - 6, y: cy + cos(t + Double(i)) * 10 - 6, width: 12, height: 12)
            gfx.opacity = 0.6
            gfx.fill(Path(ellipseIn: rect), with: .color(.green))
        }
    }

    // MARK: - Actions

    private func startPouring() {
        isPouring = true
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 2.0)) {
            pourProgress = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.4)) {
                showEquation = true
            }
        }
    }
}
