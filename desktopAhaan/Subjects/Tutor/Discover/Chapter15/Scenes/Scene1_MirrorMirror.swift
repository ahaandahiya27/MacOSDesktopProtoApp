import SwiftUI

/// Scene 1 — Mirror Mirror. Slider for angle of incidence; angle of reflection
/// is drawn correctly so both rays meet on the mirror surface at the SAME
/// point, with the normal drawn vertically from that point.
struct Scene1_MirrorMirror: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var angle: Double = 30   // degrees from normal

    var body: some View {
        VStack(spacing: 14) {
            Text("Mirror Mirror").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Slide the incoming ray. The reflected ray follows the law.")
                .font(.callout).foregroundColor(.secondary)

            // Diagram canvas. Mirror is the horizontal line at the bottom;
            // hit point is the centre of that line. Normal goes straight up.
            ZStack {
                RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.06))
                    .frame(width: 360, height: 240)

                MirrorDiagram(angle: angle)
                    .frame(width: 360, height: 240)
            }

            Text("∠ incidence = ∠ reflection = \(Int(angle))°")
                .font(.title3.weight(.semibold))
                .foregroundColor(Color.compatIndigo)

            Slider(value: $angle, in: 5...75, step: 1).frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Law of Reflection", systemImage: "arrow.turn.up.right")
                        .font(.title2.bold())
                    Text("Light bounces off a mirror at the same angle it hit. Both angles are measured from the normal (an imaginary line at 90° to the mirror). This single rule explains everything you see in a mirror.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 10 / JEE Optics",
                detail: "In Class 10 the same law of reflection extends to the mirror formula 1/v + 1/u = 1/f and the magnification rule m = -v/u. JEE Physics adds total internal reflection and combined mirror-lens systems."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Hand-drawn ray diagram. Mirror is a thick line at y = mirrorY. Hit point
/// is at (centerX, mirrorY). Normal is vertical up from hit point. Incoming
/// ray comes from upper-left at `angle` from the normal; reflected ray exits
/// to upper-right at the same angle.
private struct MirrorDiagram: View {
    let angle: Double   // degrees from normal

    var body: some View {
        GeometryReader { geo in
            let centerX = geo.size.width / 2
            let mirrorY = geo.size.height - 30
            let rayLength: Double = 170

            let rad = angle * .pi / 180
            // Incoming ray STARTS at upper-left, ENDS at hit point.
            let inStartX = Double(centerX) - sin(rad) * rayLength
            let inStartY = Double(mirrorY) - cos(rad) * rayLength
            // Reflected ray STARTS at hit point, ENDS at upper-right.
            let outEndX = Double(centerX) + sin(rad) * rayLength
            let outEndY = Double(mirrorY) - cos(rad) * rayLength

            ZStack {
                // Mirror surface (with hatching feel via thick line)
                Path { p in
                    p.move(to: CGPoint(x: 30, y: mirrorY))
                    p.addLine(to: CGPoint(x: geo.size.width - 30, y: mirrorY))
                }
                .stroke(Color.compatIndigo, lineWidth: 4)

                // Normal (dashed vertical from hit point)
                Path { p in
                    p.move(to: CGPoint(x: centerX, y: mirrorY))
                    p.addLine(to: CGPoint(x: centerX, y: mirrorY - 180))
                }
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 1.5, dash: [4, 4]))

                // Incoming ray (orange)
                Path { p in
                    p.move(to: CGPoint(x: inStartX, y: inStartY))
                    p.addLine(to: CGPoint(x: centerX, y: mirrorY))
                }
                .stroke(Color.orange, lineWidth: 2.5)

                // Reflected ray (red)
                Path { p in
                    p.move(to: CGPoint(x: centerX, y: mirrorY))
                    p.addLine(to: CGPoint(x: outEndX, y: outEndY))
                }
                .stroke(Color.red, lineWidth: 2.5)

                // Labels
                Text("incident")
                    .font(.caption.bold())
                    .foregroundColor(.orange)
                    .position(x: CGFloat(inStartX) + 18, y: CGFloat(inStartY) + 10)
                Text("reflected")
                    .font(.caption.bold())
                    .foregroundColor(.red)
                    .position(x: CGFloat(outEndX) - 22, y: CGFloat(outEndY) + 10)
                Text("normal")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .position(x: centerX + 30, y: mirrorY - 175)
            }
        }
    }
}
