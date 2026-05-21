import SwiftUI

/// Scene 9 — Boss Quiz Ch12. Five MCQs on plant reproduction.
struct Scene9_BossQuiz_Ch12: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    struct Q { let prompt: String; let options: [String]; let answer: String; let explain: String }

    private let qs: [Q] = [
        Q(prompt: "The male reproductive part of a flower is the:",
          options: ["Pistil", "Stamen", "Sepal", "Petal"],
          answer: "Stamen",
          explain: "Stamen = anther + filament. The anther makes pollen."),
        Q(prompt: "Pollen lands on the stigma — this is called:",
          options: ["Fertilisation", "Pollination", "Germination", "Dispersal"],
          answer: "Pollination",
          explain: "Pollination is just delivery. Fertilisation happens later inside the ovary."),
        Q(prompt: "A coconut is mainly dispersed by:",
          options: ["Wind", "Water", "Animals", "Explosion"],
          answer: "Water",
          explain: "Coconuts float and can drift across oceans to new shores."),
        Q(prompt: "Yeast reproduces by:",
          options: ["Seeds", "Spores", "Budding", "Pollination"],
          answer: "Budding",
          explain: "A small bud grows on the parent and breaks off as a new cell."),
        Q(prompt: "Potato plants reproduce vegetatively from their:",
          options: ["Roots", "Leaves", "Stem (tuber)", "Flowers"],
          answer: "Stem (tuber)",
          explain: "Potatoes are underground stems. The 'eyes' sprout into new plants."),
        Q(prompt: "Bryophyllum plants reproduce vegetatively from:",
          options: ["Stems", "Roots", "Buds on the leaf edges", "Seeds only"],
          answer: "Buds on the leaf edges",
          explain: "Tiny plantlets grow on Bryophyllum leaf margins, fall off and root into new plants."),
        Q(prompt: "The part of the stamen that produces pollen is the:",
          options: ["Filament", "Anther", "Stigma", "Ovary"],
          answer: "Anther",
          explain: "The filament holds the anther up; the anther's sacs burst open and release pollen grains."),
        Q(prompt: "Spirogyra (a green alga) reproduces mainly by:",
          options: ["Seeds", "Spores", "Fragmentation", "Pollination"],
          answer: "Fragmentation",
          explain: "The filament breaks into pieces and each piece grows into a new individual."),
        Q(prompt: "Maple and drumstick seeds are dispersed mainly by:",
          options: ["Animals", "Water", "Wind", "Explosion"],
          answer: "Wind",
          explain: "These seeds have papery wings that let them spin and drift on the breeze."),
        Q(prompt: "After fertilisation in a flower, the ovule becomes the:",
          options: ["Fruit", "Petal", "Seed", "Pollen"],
          answer: "Seed",
          explain: "The ovule ripens into a seed and the ovary around it ripens into the fruit."),
    ]

    @State private var i = 0
    @State private var picked: String? = nil
    @State private var revealed = false
    @State private var score = 0
    @State private var done = false
    @State private var celebrate = false
    @State private var shuffled: [String] = []

    var body: some View {
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        // Confetti emitter sits in an .overlay on the ScrollView so it
        // covers the whole viewport during the celebration, not just the
        // VStack region.
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
                            else { done = true; celebrate = true }
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
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
        .overlay(
            Group {
                if celebrate {
                    ParticleEmitter(isActive: true, particleCount: 100, duration: 3.0)
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { if shuffled.isEmpty { shuffled = qs[i].options.shuffled() } }
        .onChange(of: i) { newI in shuffled = qs[newI].options.shuffled() }
    }
}
