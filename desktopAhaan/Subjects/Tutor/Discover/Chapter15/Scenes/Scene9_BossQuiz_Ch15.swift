import SwiftUI

/// Scene 9 — Boss Quiz Ch15. Five MCQs on light.
struct Scene9_BossQuiz_Ch15: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Q { let prompt: String; let options: [String]; let answer: String; let explain: String }

    private let qs: [Q] = [
        Q(prompt: "Law of reflection: angle of incidence equals angle of:",
          options: ["Refraction", "Reflection", "Deviation", "Dispersion"],
          answer: "Reflection",
          explain: "Both angles are measured from the normal (perpendicular to the mirror)."),
        Q(prompt: "A car side mirror is usually a:",
          options: ["Plane mirror", "Concave mirror", "Convex mirror", "Spherical lens"],
          answer: "Convex mirror",
          explain: "Convex mirrors give a smaller, upright image with a wider field of view."),
        Q(prompt: "When light goes from air to water, it:",
          options: ["Speeds up", "Slows down", "Stops", "Vanishes"],
          answer: "Slows down",
          explain: "Light slows in denser media — that's why it bends (refracts)."),
        Q(prompt: "A glass prism splits white light into:",
          options: ["Two colours", "Three colours", "Seven colours (VIBGYOR)", "Black & white"],
          answer: "Seven colours (VIBGYOR)",
          explain: "Violet to Red — each colour bends a different amount."),
        Q(prompt: "A magnifying glass is a:",
          options: ["Plane mirror", "Convex lens", "Concave lens", "Concave mirror"],
          answer: "Convex lens",
          explain: "Convex lenses converge light and can produce a magnified, upright virtual image."),
        Q(prompt: "The image in a plane mirror is:",
          options: ["Upside-down", "Laterally inverted (left becomes right)", "Smaller", "Coloured differently"],
          answer: "Laterally inverted (left becomes right)",
          explain: "Raise your right hand — your mirror image raises its left. That's lateral inversion."),
        Q(prompt: "The lens inside the human eye is a:",
          options: ["Concave lens", "Convex lens", "Plane lens", "Prism"],
          answer: "Convex lens",
          explain: "The eye lens focuses light onto the retina by converging it like any convex lens does."),
        Q(prompt: "A concave mirror is used in a torch because it:",
          options: ["Spreads light in all directions", "Forms a parallel beam from the bulb", "Inverts the light", "Blocks the light"],
          answer: "Forms a parallel beam from the bulb",
          explain: "Placed correctly at the focus, the bulb's light reflects off the concave surface as a narrow beam."),
        Q(prompt: "When Newton's disc (with the seven rainbow colours) spins fast, we see:",
          options: ["Black", "Each colour in turn", "White (roughly)", "Only red"],
          answer: "White (roughly)",
          explain: "Our eyes blend the seven colours into white — the reverse of a prism's splitting."),
        Q(prompt: "An image in a plane mirror is at:",
          options: ["The mirror surface", "Half the distance behind", "The same distance behind as the object is in front", "Twice the distance behind"],
          answer: "The same distance behind as the object is in front",
          explain: "Stand 50 cm from a mirror — your image is 50 cm 'inside' the mirror, same size, virtual."),
    ]

    @State private var i = 0
    @State private var picked: String? = nil
    @State private var revealed = false
    @State private var score = 0
    @State private var done = false
    @State private var shuffled: [String] = []

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
    LazyVStack(alignment: .center, spacing: 14) {
                Text("Boss Quiz").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ProgressView(value: Double(i), total: Double(qs.count)).frame(maxWidth: 520)

                if !done {
                    let q = qs[i]
                    Text("Question \(i + 1) of \(qs.count)").font(.subheadline).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    SoftShadowCard(padding: 18) {
                        Text(q.prompt).font(.title3.bold()).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: 600)

                    VStack(spacing: 10) {
                        ForEach(shuffled, id: \.self) { opt in
                            Button {
                                guard !revealed else { return }
                                picked = opt
                                revealed = true
                                if opt == q.answer { score += 1 }
                            } label: {
                                HStack {
                                    Text(opt).frame(maxWidth: .infinity, alignment: .leading)
                                    if revealed && opt == q.answer {
                                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                    } else if revealed && opt == picked {
                                        Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                                    }
                                }
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.95)))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: 600)

                    if revealed {
                        SoftShadowCard(padding: 12) {
                            Label(q.explain, systemImage: "lightbulb.fill").font(.callout)
                        }
                        .frame(maxWidth: 600)
                        Button(i + 1 < qs.count ? "Next question" : "See score") {
                            if i + 1 < qs.count { i += 1; picked = nil; revealed = false }
                            else { done = true }
                        }
                        .accentColor(Color.compatIndigo)
                    }
                } else {
                    VStack(spacing: 12) {
                        if score >= 4 {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 56))
                                .foregroundColor(.green)
                                .accessibilityHidden(true)
                            Text("Great job!").font(.title2.bold()).foregroundColor(.green)
                        }
                        Text("Score: \(score) / \(qs.count)").font(.system(size: 36, weight: .bold))
                        GotItButton(label: "Finish chapter") { onComplete(score) }
                    }
                    .padding(.top, 8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
        .onAppear { if shuffled.isEmpty { shuffled = qs[i].options.shuffled() } }
        .onChange(of: i) { newI in shuffled = qs[newI].options.shuffled() }
    }
}
