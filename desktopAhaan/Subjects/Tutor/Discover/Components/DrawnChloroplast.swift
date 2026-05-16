import SwiftUI

/// A stylized chlorophyll molecule: a green hexagonal ring with a magnesium
/// atom at the centre. Drawn with Path — no image assets.
@available(macOS 12, *)
struct DrawnChloroplast: View {
    /// 0 = dim, 1 = brightly excited (more glow). Drive from a TimelineView
    /// phase to "absorb" red and blue light beams.
    var excitation: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let r = min(geo.size.width, geo.size.height) * 0.45
            let cx = geo.size.width / 2
            let cy = geo.size.height / 2

            ZStack {
                // Outer halo
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.green.opacity(0.4 + 0.4 * excitation), .clear],
                            center: .center, startRadius: 0, endRadius: r * 1.5
                        )
                    )
                    .frame(width: r * 3, height: r * 3)
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
                    .frame(width: r * 2, height: r * 2)
                    .position(x: cx, y: cy)

                // Inner ring for depth
                HexagonShape()
                    .stroke(.white.opacity(0.35), lineWidth: 1.5)
                    .frame(width: r * 1.6, height: r * 1.6)
                    .position(x: cx, y: cy)

                // Central Mg atom
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white, .gray.opacity(0.4)],
                            center: .center, startRadius: 0, endRadius: r * 0.35
                        )
                    )
                    .frame(width: r * 0.55, height: r * 0.55)
                    .overlay(
                        Text("Mg")
                            .font(.system(size: r * 0.2, weight: .heavy, design: .rounded))
                            .foregroundColor(.green)
                    )
                    .position(x: cx, y: cy)
                    .shadow(color: .green.opacity(0.5 * excitation), radius: 12)
            }
        }
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
