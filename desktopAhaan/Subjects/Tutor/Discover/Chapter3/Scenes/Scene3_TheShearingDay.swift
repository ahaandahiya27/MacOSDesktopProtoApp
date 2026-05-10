import SwiftUI

/// Scene 3 — The Shearing Day.
///
/// A drawn sheep. Tap "Start shearing!" — animated clipper runs across the sheep,
/// fleece falls off. Counter: "12 kg fleece harvested."
struct Scene3_TheShearingDay: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var isShearing = false
    @State private var clipperPosition: CGFloat = 0
    @State private var fleecePiles: [FleecePuff] = []
    @State private var harvestedKg: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text("The Shearing Day")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.indigo)
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Harvested")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text("\(Int(harvestedKg)) kg")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.green)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            ZStack {
                // Drawn sheep
                Canvas { context, _ in
                    // Body (oval)
                    let bodyRect = CGRect(x: 80, y: 100, width: 140, height: 100)
                    context.fill(
                        Path(ellipseIn: bodyRect),
                        with: .color(.white)
                    )
                    context.stroke(
                        Path(ellipseIn: bodyRect),
                        with: .color(.gray.opacity(0.5)),
                        lineWidth: 2
                    )

                    // Head
                    let headRect = CGRect(x: 140, y: 40, width: 60, height: 60)
                    context.fill(
                        Path(ellipseIn: headRect),
                        with: .color(.white)
                    )
                    context.stroke(
                        Path(ellipseIn: headRect),
                        with: .color(.gray.opacity(0.5)),
                        lineWidth: 2
                    )

                    // Eyes
                    context.fill(
                        Path(ellipseIn: CGRect(x: 150, y: 55, width: 6, height: 8)),
                        with: .color(.black)
                    )
                    context.fill(
                        Path(ellipseIn: CGRect(x: 175, y: 55, width: 6, height: 8)),
                        with: .color(.black)
                    )

                    // Legs
                    for legX in [100.0, 130.0, 180.0, 210.0] {
                        context.stroke(
                            Path { p in
                                p.move(to: CGPoint(x: legX, y: 200))
                                p.addLine(to: CGPoint(x: legX, y: 250))
                            },
                            with: .color(.gray),
                            lineWidth: 3
                        )
                    }
                }
                .frame(height: 280)

                // Fleece falling animation
                ForEach(fleecePiles) { puff in
                    Text("💨")
                        .font(.system(size: 32))
                        .position(x: puff.x, y: puff.y)
                        .opacity(puff.opacity)
                }

                // Clipper animation
                if isShearing {
                    Canvas { context, _ in
                        let clipX = 80 + clipperPosition * 140
                        let clipY = 120.0
                        context.fill(
                            Path(ellipseIn: CGRect(x: clipX - 12, y: clipY - 8, width: 24, height: 16)),
                            with: .color(.yellow.opacity(0.7))
                        )
                    }
                    .frame(height: 280)
                }
            }
            .frame(height: 280)
            .padding(.horizontal, 24)

            HStack(spacing: 12) {
                Button {
                    performShearing()
                } label: {
                    Label(isShearing ? "Shearing..." : "Start Shearing!", systemImage: "scissors")
                }
                .buttonStyle(.borderedProminent)
                .disabled(isShearing)

                if harvestedKg >= 12 {
                    Button {
                        resetShearing()
                    } label: {
                        Label("Watch Again", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            SoftShadowCard(padding: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Don't worry, it doesn't hurt!", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Sheep are sheared once a year in spring. The fleece grows back quickly and the sheep feels cooler in summer.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: 600)
            .padding(.horizontal, 24)

            GotItButton {
                onComplete()
            }
            .padding(.bottom, 20)
        }
    }

    private func performShearing() {
        withAnimation(reduceMotion ? .none : .linear(duration: 2)) {
            isShearing = true
            clipperPosition = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            for _ in 0..<8 {
                let puff = FleecePuff(
                    x: CGFloat.random(in: 100...220),
                    y: CGFloat.random(in: 150...200),
                    opacity: 1.0
                )
                withAnimation(.easeOut(duration: 1.2)) {
                    fleecePiles.append(puff)
                    harvestedKg += 1.5
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation(.easeOut(duration: 1)) {
                for i in fleecePiles.indices {
                    fleecePiles[i].opacity = 0
                }
            }
            isShearing = false
            clipperPosition = 0
        }
    }

    private func resetShearing() {
        fleecePiles.removeAll()
        harvestedKg = 0
        isShearing = false
        clipperPosition = 0
    }
}

private struct FleecePuff: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var opacity: Double
}
