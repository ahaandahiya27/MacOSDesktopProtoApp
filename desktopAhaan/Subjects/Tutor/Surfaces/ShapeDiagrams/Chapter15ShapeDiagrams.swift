import SwiftUI

// MARK: - Chapter 15 shape diagrams  (Light)
//
// Pure-SwiftUI schematic diagrams for the four ch15 `shapeDiagram`
// MediaAssets. Big Sur / legacy-GPU rules honoured.

// MARK: - ch15_reflection_law

/// The law of reflection at a plane mirror: the angle the incoming ray makes
/// with the normal equals the angle the reflected ray makes with it
/// (angle i = angle r).
struct ReflectionLawDiagram: View {
    // Split into small typed helpers so Swift 5.5's type-checker doesn't
    // overflow its stack on one deep @ViewBuilder closure. No visual change.
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            rays(w: w, h: h)
            labels(w: w, h: h)
        }
    }

    private func rays(w: CGFloat, h: CGFloat) -> some View {
        let hit = CGPoint(x: w / 2, y: h * 0.7)
        let mirrorW: CGFloat = w * 0.8
        let mirrorX: CGFloat = w / 2
        let mirrorY: CGFloat = h * 0.7
        let normalTopY: CGFloat = h * 0.3
        let incidentX: CGFloat = w * 0.25
        let incidentY: CGFloat = h * 0.32
        let reflectedX: CGFloat = w * 0.75
        let reflectedY: CGFloat = h * 0.32
        return Group {
            // Mirror surface
            Rectangle().fill(DesignTokens.BrandColor.canvasText.opacity(0.5))
                .frame(width: mirrorW, height: 4).position(x: mirrorX, y: mirrorY)
            // Normal (dashed vertical)
            Path { p in
                p.move(to: CGPoint(x: hit.x, y: normalTopY))
                p.addLine(to: hit)
            }.stroke(DesignTokens.BrandColor.canvasTextSecondary.opacity(0.6),
                     style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
            // Incident + reflected rays
            ray(from: CGPoint(x: incidentX, y: incidentY), to: hit, color: .orange)
            ray(from: hit, to: CGPoint(x: reflectedX, y: reflectedY), color: .red)
        }
    }

    private func labels(w: CGFloat, h: CGFloat) -> some View {
        let hit = CGPoint(x: w / 2, y: h * 0.7)
        let normalLabelX: CGFloat = hit.x + 28
        let normalLabelY: CGFloat = h * 0.34
        let incidentLabelX: CGFloat = w * 0.22
        let incidentLabelY: CGFloat = h * 0.28
        let reflectedLabelX: CGFloat = w * 0.78
        let reflectedLabelY: CGFloat = h * 0.28
        let angleLabelX: CGFloat = w / 2
        let angleLabelY: CGFloat = h * 0.92
        return Group {
            SDLabel(text: "Normal").position(x: normalLabelX, y: normalLabelY)
            SDLabel(text: "Incident", color: .orange).position(x: incidentLabelX, y: incidentLabelY)
            SDLabel(text: "Reflected", color: .red).position(x: reflectedLabelX, y: reflectedLabelY)
            SDLabel(text: "angle i = angle r", color: Color.compatBlue).position(x: angleLabelX, y: angleLabelY)
        }
    }

    private func ray(from: CGPoint, to: CGPoint, color: Color) -> some View {
        Path { p in p.move(to: from); p.addLine(to: to) }
            .stroke(color.opacity(0.8), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
    }
}

// MARK: - ch15_prism

/// A glass prism splits white light into the colours of the rainbow —
/// dispersion — because each colour bends by a slightly different amount.
struct PrismDiagram: View {
    private let spectrum: [Color] = [.red, .orange, .yellow, .green, .blue, Color.compatPurple]
    // Split into small typed helpers so Swift 5.5's type-checker doesn't
    // overflow its stack on one deep @ViewBuilder closure. No visual change.
    var body: some View {
        SDFigure(tint: Color.compatPurple) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            prism(w: w, h: h)
            spectrumOut(w: w, h: h)
        }
    }

    private func prism(w: CGFloat, h: CGFloat) -> some View {
        let lightStartX: CGFloat = w * 0.06
        let lightStartY: CGFloat = h * 0.42
        let lightEndX: CGFloat = w * 0.4
        let lightEndY: CGFloat = h * 0.5
        let prismW: CGFloat = w * 0.26
        let prismH: CGFloat = h * 0.5
        let prismX: CGFloat = w * 0.46
        let prismY: CGFloat = h * 0.5
        return Group {
            // White light in
            Path { p in
                p.move(to: CGPoint(x: lightStartX, y: lightStartY))
                p.addLine(to: CGPoint(x: lightEndX, y: lightEndY))
            }.stroke(DesignTokens.BrandColor.canvasText.opacity(0.7),
                     style: StrokeStyle(lineWidth: 3, lineCap: .round))
            // Prism triangle
            TriangleShape().fill(Color.compatBlue.opacity(0.18))
                .overlay(TriangleShape().stroke(Color.compatBlue.opacity(0.6), lineWidth: 2))
                .frame(width: prismW, height: prismH).position(x: prismX, y: prismY)
        }
    }

    private func spectrumOut(w: CGFloat, h: CGFloat) -> some View {
        let whiteLabelX: CGFloat = w * 0.16
        let whiteLabelY: CGFloat = h * 0.3
        let spectrumLabelX: CGFloat = w * 0.82
        let spectrumLabelY: CGFloat = h * 0.9
        return Group {
            // Dispersed spectrum out
            ForEach(0..<spectrum.count, id: \.self) { i in
                spectrumRay(i: i, w: w, h: h)
            }
            SDLabel(text: "White light").position(x: whiteLabelX, y: whiteLabelY)
            SDLabel(text: "Spectrum", color: Color.compatPurple).position(x: spectrumLabelX, y: spectrumLabelY)
        }
    }

    private func spectrumRay(i: Int, w: CGFloat, h: CGFloat) -> some View {
        let startX: CGFloat = w * 0.58
        let startY: CGFloat = h * 0.52
        let endX: CGFloat = w * 0.95
        let endY: CGFloat = h * (0.34 + Double(i) * 0.07)
        return Path { p in
            p.move(to: CGPoint(x: startX, y: startY))
            p.addLine(to: CGPoint(x: endX, y: endY))
        }.stroke(spectrum[i].opacity(0.85), lineWidth: 2.5)
    }
}

/// An upward-pointing triangle (prism).
private struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

// MARK: - ch15_lens_types

/// Two kinds of lens: a convex lens is thick in the middle and brings rays
/// together (converging); a concave lens is thin in the middle and spreads
/// them out (diverging).
struct LensTypesDiagram: View {
    var body: some View {
        SDFigure(tint: Color.compatBlue) {
            HStack(spacing: 18) {
                lens(convex: true, title: "Convex", note: "converges")
                lens(convex: false, title: "Concave", note: "diverges")
            }
        }
    }

    private func lens(convex: Bool, title: String, note: String) -> some View {
        VStack(spacing: 5) {
            Text(title).font(.system(size: 12, weight: .bold)).foregroundColor(DesignTokens.BrandColor.canvasText)
            ZStack {
                Group {
                    LensShape(convex: convex).fill(Color.compatBlue.opacity(0.25))
                        .overlay(LensShape(convex: convex).stroke(Color.compatBlue.opacity(0.6), lineWidth: 1.5))
                        .frame(width: 26, height: 70)
                }
                // Incoming + outgoing rays
                ForEach(0..<2, id: \.self) { s in
                    rayPair(top: s == 0, convex: convex)
                }
            }
            .frame(width: 110, height: 76)
            SDLabel(text: note, color: Color.compatBlue)
        }
    }

    private func rayPair(top: Bool, convex: Bool) -> some View {
        let y0: CGFloat = top ? 22 : 54
        let yOut: CGFloat = convex ? 38 : (top ? 10 : 66)
        return Path { p in
            p.move(to: CGPoint(x: 6, y: y0))
            p.addLine(to: CGPoint(x: 55, y: y0))
            p.addLine(to: CGPoint(x: 104, y: yOut))
        }.stroke(.orange.opacity(0.7), lineWidth: 1.5)
    }
}

/// A lens cross-section: convex (two outward bows) or concave (two inward bows).
private struct LensShape: Shape {
    let convex: Bool
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let bow = convex ? rect.width * 0.5 : -rect.width * 0.5
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                       control: CGPoint(x: rect.midX + bow, y: rect.midY))
        p.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY),
                       control: CGPoint(x: rect.midX - bow, y: rect.midY))
        p.closeSubpath()
        return p
    }
}

// MARK: - ch15_periscope

/// A periscope uses two mirrors set at 45° to bend light down a tube, so you
/// can see over a wall or out of a submarine.
struct PeriscopeDiagram: View {
    // Split into small typed helpers so Swift 5.5's type-checker doesn't
    // overflow its stack on one deep @ViewBuilder closure. No visual change.
    var body: some View {
        SDFigure(tint: Color.compatTeal) {
            GeometryReader { geo in
                content(w: geo.size.width, h: geo.size.height)
            }
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w / 2
        return ZStack {
            tubeAndMirrors(w: w, h: h, cx: cx)
            lightPath(w: w, h: h, cx: cx)
        }
    }

    private func tubeAndMirrors(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let tubeW: CGFloat = w * 0.36
        let tubeH: CGFloat = h * 0.7
        let tubeY: CGFloat = h * 0.5
        let topMirrorX: CGFloat = cx - w * 0.1
        let topMirrorY: CGFloat = h * 0.22
        let bottomMirrorX: CGFloat = cx + w * 0.1
        let bottomMirrorY: CGFloat = h * 0.78
        return Group {
            // Tube
            RoundedRectangle(cornerRadius: 6).stroke(DesignTokens.BrandColor.canvasText.opacity(0.5), lineWidth: 2)
                .frame(width: tubeW, height: tubeH).position(x: cx, y: tubeY)
            // Two 45° mirrors
            mirror.position(x: topMirrorX, y: topMirrorY)
            mirror.position(x: bottomMirrorX, y: bottomMirrorY)
        }
    }

    private func lightPath(w: CGFloat, h: CGFloat, cx: CGFloat) -> some View {
        let inX: CGFloat = w * 0.06
        let topY: CGFloat = h * 0.22
        let topMirrorX: CGFloat = cx - w * 0.1
        let bottomMirrorX: CGFloat = cx + w * 0.1
        let bottomY: CGFloat = h * 0.78
        let outX: CGFloat = w * 0.94
        let inLabelX: CGFloat = w * 0.12
        let inLabelY: CGFloat = h * 0.12
        let eyeLabelX: CGFloat = w * 0.9
        let eyeLabelY: CGFloat = h * 0.9
        return Group {
            // Light path: in top, down, out bottom
            Path { p in
                p.move(to: CGPoint(x: inX, y: topY))
                p.addLine(to: CGPoint(x: topMirrorX, y: topY))
                p.addLine(to: CGPoint(x: bottomMirrorX, y: bottomY))
                p.addLine(to: CGPoint(x: outX, y: bottomY))
            }.stroke(.orange.opacity(0.8), style: StrokeStyle(lineWidth: 2, lineCap: .round))
            SDLabel(text: "Light in", color: .orange).position(x: inLabelX, y: inLabelY)
            SDLabel(text: "Eye", color: .orange).position(x: eyeLabelX, y: eyeLabelY)
        }
    }

    private var mirror: some View {
        Rectangle().fill(Color.compatTeal.opacity(0.6))
            .frame(width: 26, height: 4).rotationEffect(.degrees(45))
    }
}
