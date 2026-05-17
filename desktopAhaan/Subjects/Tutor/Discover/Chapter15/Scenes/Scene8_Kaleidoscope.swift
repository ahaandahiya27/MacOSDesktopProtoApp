import SwiftUI

/// Scene 8 — Kaleidoscope. Tap to "shake" — patterns rotate at random angles.
struct Scene8_Kaleidoscope: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var seed: Int = 1

    var body: some View {
        VStack(spacing: 14) {
            Text("Kaleidoscope").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("Tap the disc to shake the kaleidoscope. Each shake = new pattern.")
                .font(.callout).foregroundColor(.secondary).multilineTextAlignment(.center)

            ZStack {
                Circle().fill(Color.black).frame(width: 240, height: 240)
                ForEach(0..<6, id: \.self) { i in
                    ForEach(0..<3, id: \.self) { j in
                        Image(systemName: ["star.fill", "diamond.fill", "circle.fill", "triangle.fill"][((seed * (i + 1) * (j + 1)) % 4)])
                            .foregroundColor([.red, .yellow, .green, .blue, .purple, .orange][((seed * i + j) % 6 + 6) % 6])
                            .font(.system(size: 24))
                            .offset(x: CGFloat(Double((seed * (j + 1)) % 70 - 35)),
                                    y: CGFloat(Double((seed * (i + 1)) % 70 - 35) - 60))
                            .rotationEffect(.degrees(Double(i) * 60))
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

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
