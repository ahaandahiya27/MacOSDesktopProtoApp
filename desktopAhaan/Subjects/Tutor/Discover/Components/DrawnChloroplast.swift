import SwiftUI

/// A stylized chlorophyll molecule: a green hexagonal ring with a magnesium
/// atom at the centre. Drawn with Path — no image assets.
///
/// Big Sur (macOS 11) compatible.
struct DrawnChloroplast: View {
    /// 0 = dim, 1 = brightly excited (more glow). Drive from a TimelineView
    /// phase to "absorb" red and blue light beams.
    var excitation: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let r = min(geo.size.width, geo.size.height) * 0.45
            let cx = geo.size.width / 2
            let cy = geo.size.height / 2
            let haloSide: CGFloat = r * 3
            let ringSide: CGFloat = r * 2
            let innerRingSide: CGFloat = r * 1.6
            let mgSide: CGFloat = r * 0.55
            let haloAlpha: Double = 0.4 + 0.4 * Double(excitation)
            let mgGlowAlpha: Double = 0.5 * Double(excitation)

            ZStack {
                // Outer halo
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.green.opacity(haloAlpha), .clear],
                            center: .center, startRadius: 0, endRadius: r * 1.5
                        )
                    )
                    .frame(width: haloSide, height: haloSide)
                    .position(x: cx, y: cy)

                // Hexagonal porphyrin ring
                HexagonShape()
                    .stroke(
                        LinearGradient(
                            colors: [.green.opacity(0.9), .green.opacity(0.55)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 5
                    )
                    .frame(width: ringSide, height: ringSide)
                    .position(x: cx, y: cy)

                // Inner ring for depth
                HexagonShape()
                    .stroke(.white.opacity(0.35), lineWidth: 1.5)
                    .frame(width: innerRingSide, height: innerRingSide)
                    .position(x: cx, y: cy)

                // Central Mg atom
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white, .gray.opacity(0.4)],
                            center: .center, startRadius: 0, endRadius: r * 0.35
                        )
                    )
                    .frame(width: mgSide, height: mgSide)
                    .overlay(
                        mgLabel(r: r)
                    )
                    .position(x: cx, y: cy)
                    .shadow(color: .green.opacity(mgGlowAlpha), radius: 12)
            }
        }
    }

    private func mgLabel(r: CGFloat) -> some View {
        let mgFontSize: CGFloat = r * 0.2
        return Text("Mg")
            .font(.system(size: mgFontSize, weight: .heavy, design: .rounded))
            .foregroundColor(.green)
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX
        let cy = rect.midY
        let r = min(rect.width, rect.height) / 2
        for i in 0..<6 {
            let angle = Double(i) * .pi / 3 - .pi / 2
            let pt = CGPoint(x: cx + r * cos(angle), y: cy + r * sin(angle))
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}
