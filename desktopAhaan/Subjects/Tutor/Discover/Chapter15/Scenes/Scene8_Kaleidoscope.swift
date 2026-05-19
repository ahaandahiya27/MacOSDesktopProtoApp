import SwiftUI

/// Scene 8 — Kaleidoscope. Tap to "shake" — patterns rotate at random angles.
struct Scene8_Kaleidoscope: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var seed: Int = 1

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Kaleidoscope").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Tap the disc to shake the kaleidoscope. Each shake = new pattern.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).multilineTextAlignment(.center)

                ZStack {
                    Circle().fill(Color.black).frame(width: 240, height: 240)
                    ForEach(0..<6, id: \.self) { i in
                        ForEach(0..<3, id: \.self) { j in
                            KaleidoscopeTile(seed: seed, i: i, j: j)
                        }
                    }
                }
                .onTapGesture { seed = Int.random(in: 1...100) }

                Button("Shake!") { seed = Int.random(in: 1...100) }
                    .accentColor(Color.compatIndigo)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Symmetry from mirrors", systemImage: "sparkles")
                            .font(.title2.bold())
                        Text("Inside a kaleidoscope, 2 or 3 mirrors are arranged at angles. A few coloured beads at the bottom reflect across all the mirrors — creating a stunning symmetric pattern that changes with every twist.")
                            .font(.body).lineSpacing(4)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

                LookingAheadCallout(
                    title: "Class 9/10 Maths + JEE",
                    detail: "Class 9/10 Maths formalises this as 'Symmetry' — rotational order, lines of symmetry, reflection groups. Class 12 / JEE Chemistry covers molecular symmetry (point groups C₂, C₃, σ planes) using the same mathematical framework that makes a kaleidoscope work."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Pringles-tube kaleidoscope",
                    detail: "Three strips of mirror foil + an empty Pringles tube. Tape them inside in a triangular prism shape, mirror-side inward. At one end, put a transparent disc; sprinkle a few colourful beads or sequins; cover loosely with a frosted paper. Look through the other end and twist."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                GotItButton { onComplete() }.padding(.bottom, 12)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Extracted tile so Swift 5.5 (Xcode 13.2.1 / Big Sur target) can
/// type-check the body in reasonable time. Inlined, the array-literal
/// subscripting + Int/Double/CGFloat mixing inside two nested ForEach
/// closures pushes type inference into a timeout.
private struct KaleidoscopeTile: View {
    let seed: Int
    let i: Int
    let j: Int

    private static let symbols: [String] = ["star.fill", "diamond.fill", "circle.fill", "triangle.fill"]
    private static let palette: [Color] = [.red, .yellow, .green, .blue, .purple, .orange]

    var body: some View {
        let symbolIndex: Int = (seed * (i + 1) * (j + 1)) % Self.symbols.count
        let colorIndex: Int = (seed * i + j) % Self.palette.count
        let dx: CGFloat = CGFloat((seed * (j + 1)) % 70 - 35)
        let dy: CGFloat = CGFloat((seed * (i + 1)) % 70 - 35 - 60)
        let rotation: Double = Double(i) * 60

        return Image(systemName: Self.symbols[symbolIndex])
            .foregroundColor(Self.palette[colorIndex])
            .font(.system(size: 24))
            .offset(x: dx, y: dy)
            .rotationEffect(.degrees(rotation))
    }
}
