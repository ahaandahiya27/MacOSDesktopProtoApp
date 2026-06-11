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
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Mirror Mirror").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Slide the incoming ray. The reflected ray follows the law.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                // Diagram canvas. Mirror is the horizontal line at the bottom;
                // hit point is the centre of that line. Normal goes straight up.
                ZStack {
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.lg).fill(Color.white.opacity(0.95))
                        .frame(width: 360, height: 240)

                    MirrorDiagram(angle: angle)
                        .frame(width: 360, height: 240)
                }

                Text("∠ incidence = ∠ reflection = \(Int(angle))°")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(Color.compatIndigo)

                Slider(value: $angle, in: 5...75, step: 1).frame(maxWidth: 460).padding(.horizontal, DesignTokens.Spacing.xl)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Label("Law of Reflection", systemImage: "arrow.turn.up.right")
                            .font(.title2.bold())
                        Text("Light bounces off a mirror at the same angle it hit. Both angles are measured from the normal (an imaginary line at 90° to the mirror). This single rule explains everything you see in a mirror.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                // Grouped so the outer VStack stays within Swift 5.5's
                // 10-child ViewBuilder limit (Xcode 13.2.1 / Big Sur target).
                Group {
                    LookingAheadCallout(
                        title: "Class 10 / JEE Optics",
                        detail: "In Class 10 the same law of reflection extends to the mirror formula 1/v + 1/u = 1/f and the magnification rule m = -v/u. JEE Physics adds total internal reflection and combined mirror-lens systems."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    TryAtHomeCallout(
                        title: "Mirror + torch on paper",
                        detail: "On a sheet of A4, tape a small mirror at one edge. Shine a torch at the mirror at a slant. Mark the incoming and outgoing rays with pencil. Use a protractor to measure both angles from the perpendicular — they will be exactly equal."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    RelatedConceptsCallout(
                        title: "Related: Ch 8 (Winds, Storms)",
                        detail: "The law of reflection (angle in = angle out) applies to sound just as it applies to light — that's why we hear echoes. Class 8's chapter on sound goes deeper. The same maths governs both."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                }

                GotItButton { onComplete() }.padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
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
            content(w: geo.size.width, h: geo.size.height)
        }
    }

    // Body extracted into a typed helper so Swift 5.5's @ViewBuilder
    // doesn't see the `let ... ; return ZStack { ... }` sequence inside
    // the GeometryReader closure. Swift 5.5 rejects explicit `return`
    // in a multi-statement @ViewBuilder closure body (caught on the
    // 2026-06-05 iMac build).
    private func content(w: CGFloat, h: CGFloat) -> some View {
        let centerX: CGFloat = w / 2
        let mirrorY: CGFloat = h - 30
        let rayLength: Double = 170

        let rad: Double = angle * .pi / 180
        // Incoming ray STARTS at upper-left, ENDS at hit point.
        let inStartX: Double = Double(centerX) - sin(rad) * rayLength
        let inStartY: Double = Double(mirrorY) - cos(rad) * rayLength
        // Reflected ray STARTS at hit point, ENDS at upper-right.
        let outEndX: Double = Double(centerX) + sin(rad) * rayLength
        let outEndY: Double = Double(mirrorY) - cos(rad) * rayLength

        let incidentLabelX: CGFloat = CGFloat(inStartX) + 18
        let incidentLabelY: CGFloat = CGFloat(inStartY) + 10
        let reflectedLabelX: CGFloat = CGFloat(outEndX) - 22
        let reflectedLabelY: CGFloat = CGFloat(outEndY) + 10
        let normalLabelX: CGFloat = centerX + 30
        let normalLabelY: CGFloat = mirrorY - 175
        let mirrorRightX: CGFloat = w - 30
        let normalTopY: CGFloat = mirrorY - 180

        return ZStack {
            // Mirror surface (with hatching feel via thick line)
            Path { p in
                p.move(to: CGPoint(x: 30, y: mirrorY))
                p.addLine(to: CGPoint(x: mirrorRightX, y: mirrorY))
            }
            .stroke(Color.compatIndigo, lineWidth: 4)

            // Normal (dashed vertical from hit point)
            Path { p in
                p.move(to: CGPoint(x: centerX, y: mirrorY))
                p.addLine(to: CGPoint(x: centerX, y: normalTopY))
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
                .foregroundColor(DesignTokens.BrandColor.tryAtHome)
                .position(x: incidentLabelX, y: incidentLabelY)
            Text("reflected")
                .font(.caption.bold())
                .foregroundColor(.red)
                .position(x: reflectedLabelX, y: reflectedLabelY)
            Text("normal")
                .font(.caption2)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .position(x: normalLabelX, y: normalLabelY)
        }
    }
}
