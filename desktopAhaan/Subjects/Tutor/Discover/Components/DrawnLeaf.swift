import SwiftUI

/// A reusable leaf shape drawn entirely with `Path`. No image assets.
/// The leaf has a gentle "pulse" parameter (0…1) so callers can drive a
/// breathing animation by attaching a TimelineView phase.
@available(macOS 12, *)
struct DrawnLeaf: View {
    /// 0 = fully relaxed, 1 = fully pulsed. Drives subtle scale + glow.
    var pulse: CGFloat = 0
    /// Tint of the leaf body (kid-friendly fresh green by default).
    var tint: Color = Color(red: 0.32, green: 0.78, blue: 0.42)

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let scale = 1.0 + 0.04 * pulse

            ZStack {
                // Glow halo behind the leaf — grows with the pulse value.
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                tint.opacity(0.35 * pulse),
                                tint.opacity(0)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: max(w, h) * 0.55
                        )
                    )
                    .frame(width: max(w, h) * 1.1, height: max(w, h) * 1.1)
                    .position(x: w / 2, y: h / 2)

                // The leaf body
                LeafShape()
                    .fill(
                        LinearGradient(
                            colors: [tint.opacity(0.95), tint.opacity(0.65)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        // Central vein
                        Path { p in
                            p.move(to: CGPoint(x: w * 0.5, y: h * 0.12))
                            p.addQuadCurve(
                                to: CGPoint(x: w * 0.52, y: h * 0.88),
                                control: CGPoint(x: w * 0.55, y: h * 0.55)
                            )
                        }
                        .stroke(.white.opacity(0.6), lineWidth: 2)
                    )
                    .overlay(
                        // Side veins
                        ForEach(0..<5, id: \.self) { i in
                            Path { p in
                                let y = h * (0.25 + Double(i) * 0.12)
                                p.move(to: CGPoint(x: w * 0.5, y: y))
                                p.addQuadCurve(
                                    to: CGPoint(x: w * (0.18 + Double(i) * 0.02), y: y + 12),
                                    control: CGPoint(x: w * 0.32, y: y + 6)
                                )
                                p.move(to: CGPoint(x: w * 0.52, y: y))
                                p.addQuadCurve(
                                    to: CGPoint(x: w * (0.82 - Double(i) * 0.02), y: y + 12),
                                    control: CGPoint(x: w * 0.68, y: y + 6)
                                )
                            }
                            .stroke(.white.opacity(0.45), lineWidth: 1.2)
                        }
                    )
                    .scaleEffect(scale)
                    .shadow(color: tint.opacity(0.35), radius: 16, x: 0, y: 8)
            }
        }
    }
}

/// The pure leaf silhouette. Public so callers can use it as a clip shape too.
struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Leaf tip at top, stem at bottom.
        p.move(to: CGPoint(x: w * 0.5, y: h * 0.02))
        p.addCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.98),
            control1: CGPoint(x: w * 1.05, y: h * 0.18),
            control2: CGPoint(x: w * 0.92, y: h * 0.95)
        )
        p.addCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.02),
            control1: CGPoint(x: w * 0.08, y: h * 0.95),
            control2: CGPoint(x: -w * 0.05, y: h * 0.18)
        )
        p.closeSubpath()
        return p
    }
}
