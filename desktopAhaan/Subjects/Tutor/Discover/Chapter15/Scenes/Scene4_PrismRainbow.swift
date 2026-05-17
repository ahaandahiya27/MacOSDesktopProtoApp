import SwiftUI

/// Scene 4 — Prism & Rainbow. Tap to send white light through the prism;
/// see the VIBGYOR fan.
struct Scene4_PrismRainbow: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var split = false

    private let vibgyor: [Color] = [
        Color(red: 0.56, green: 0.0, blue: 1.0),  // Violet
        Color(red: 0.29, green: 0.0, blue: 0.51), // Indigo
        Color.blue,
        Color.green,
        Color.yellow,
        Color.orange,
        Color.red,
    ]

    var body: some View {
        VStack(spacing: 14) {
            Text("Prism & Rainbow").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Send white light through a glass prism. Out comes a rainbow.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.black.opacity(0.85))
                    .frame(width: 380, height: 240)

                // White ray in
                Rectangle().fill(Color.white).frame(width: 130, height: 2)
                    .offset(x: -120)

                // Prism
                Triangle()
                    .fill(Color.compatCyan.opacity(0.25))
                    .overlay(Triangle().stroke(Color.compatCyan, lineWidth: 1))
                    .frame(width: 60, height: 60)

                // VIBGYOR
                if split {
                    VStack(spacing: 1) {
                        ForEach(0..<vibgyor.count, id: \.self) { i in
                            Rectangle().fill(vibgyor[i]).frame(width: 140, height: 3)
                        }
                    }
                    .offset(x: 120)
                }
            }

            Button(split ? "White again" : "Split the light") { split.toggle() }
                .accentColor(Color.compatIndigo)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("White light is many colours", systemImage: "rainbow")
                        .font(.title2.bold())
                    Text("White light is a mix of seven colours: VIBGYOR. Each colour bends a different amount in glass, so a prism fans them out. The same thing happens in raindrops — that's a rainbow.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "CD as a prism",
                detail: "Hold an old CD or DVD up to a sunny window so light bounces off the rainbow side. You'll see VIBGYOR — not because of dispersion, but because of diffraction off the tiny tracks. The same seven colours, fanned out by a different physical mechanism. (For real dispersion, put a triangular glass paperweight in the sunlight.)"
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 12 → JEE",
                detail: "Class 12 'Ray Optics' gives you the prism deviation formula δ = (μ − 1)A for small angles, and angular dispersion (μ_v − μ_r)A. JEE Physics asks deviation problems on equilateral prisms every year. Class 12 'Wave Optics' explains the CD rainbow too — diffraction-grating physics."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            p.closeSubpath()
        }
    }
}
