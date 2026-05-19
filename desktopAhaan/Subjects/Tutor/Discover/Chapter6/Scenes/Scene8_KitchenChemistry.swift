import SwiftUI

/// Scene 8 — Kitchen Chemistry.
/// Three kitchen experiments: baking soda + vinegar volcano, lemon juice on baking soda,
/// and turmeric milk turning red with soap. Tap each to see the reaction.

struct Scene8_KitchenChemistry: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedExperiment: Int? = nil
    @State private var reacted: Set<Int> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct Experiment: Identifiable {
        let id: Int
        let title: String
        let emoji: String
        let ingredients: String
        let reaction: String
        let type: String // "Chemical" or "Physical"
        let explanation: String
    }

    private let experiments: [Experiment] = [
        Experiment(
            id: 0,
            title: "Baking Soda + Vinegar",
            emoji: "\u{1F30B}",
            ingredients: "NaHCO\u{2083} + CH\u{2083}COOH",
            reaction: "Fizz! CO\u{2082} gas erupts upward!",
            type: "Chemical",
            explanation: "Acetic acid reacts with sodium bicarbonate to produce carbon dioxide gas, water, and sodium acetate. The bubbling is a sign of a chemical change \u{2014} new substances are formed."
        ),
        Experiment(
            id: 1,
            title: "Lemon on Baking Soda",
            emoji: "\u{1F34B}",
            ingredients: "Citric acid + NaHCO\u{2083}",
            reaction: "Bubbles and fizzing!",
            type: "Chemical",
            explanation: "Citric acid from lemon juice reacts with baking soda just like vinegar does. The fizz is CO\u{2082} gas escaping \u{2014} a new substance that was not there before."
        ),
        Experiment(
            id: 2,
            title: "Turmeric Milk + Soap",
            emoji: "\u{1F6BF}",
            ingredients: "Turmeric (indicator) + soap (base)",
            reaction: "Yellow turns red-brown!",
            type: "Chemical",
            explanation: "Turmeric contains curcumin, a natural indicator. In the presence of a base (soap), curcumin changes structure and shifts from yellow to red-brown. This colour change signals a chemical reaction."
        ),
    ]

    var body: some View {
        // ScrollView + LazyVStack: prevents greedy Spacer()s from
        // pushing the callouts and GotItButton off-screen on the 5K
        // canvas. Original Spacer()s dropped.
        ScrollView {
            LazyVStack(spacing: 14) {
            Text("Kitchen Chemistry")
                .font(.largeTitle.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .padding(.top, 18)

            Text("Tap an experiment to trigger the reaction")
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            HStack(spacing: 20) {
                ForEach(experiments) { exp in
                    experimentCard(exp)
                }
            }
            .padding(.horizontal, 24)

            if let sel = selectedExperiment, let exp = experiments.first(where: { $0.id == sel }) {
                VStack(spacing: 8) {
                    HStack {
                        Text(exp.emoji)
                            .font(.system(size: 44))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exp.title)
                                .font(.title3.bold())
                            Text(exp.ingredients)
                                .font(.caption)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    }

                    if reacted.contains(exp.id) {
                        Text(exp.reaction)
                            .font(.title2.bold())
                            .foregroundColor(.orange)
                            .transition(.scale.combined(with: .opacity))

                        HStack(spacing: 6) {
                            Image(systemName: SFSymbolCompat.name("flask.fill"))
                                .foregroundColor(.purple)
                            Text(exp.type)
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("Change")
                                .font(.headline)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }
                    } else {
                        Button("Mix them!") {
                            withAnimation(reduceMotion ? .none : .spring()) {
                                _ = reacted.insert(exp.id)
                            }
                        }
                        
                        .accentColor(.orange)
                    }
                }
                .padding()
                .frame(maxWidth: 500)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                )
            }

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Chemistry in your kitchen", systemImage: SFSymbolCompat.name("frying.pan.fill"))
                        .font(.title2.bold())
                    if let sel = selectedExperiment, let exp = experiments.first(where: { $0.id == sel }), reacted.contains(exp.id) {
                        Text(exp.explanation)
                            .font(.body)
                            .lineSpacing(4)
                    } else {
                        Text("Your kitchen is full of chemical reactions! Baking, cleaning, and even making turmeric milk all involve acids, bases, and new substances forming. Select an experiment above to see chemistry in action.")
                            .font(.body)
                            .lineSpacing(4)
                    }
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Chemistry → JEE / NEET",
                detail: "Baking-soda + vinegar: NaHCO₃ + CH₃COOH → CH₃COONa + H₂O + CO₂↑. That's an acid-base neutralisation AND a gas evolution AND a salt formation in one step — three of the 5 signs of chemical change you've already learned. JEE asks the stoichiometry: 1 mol of each makes 1 mol CO₂, so 84 g baking soda + 60 g vinegar (acetic acid) → 22.4 L of CO₂ at STP."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Pop a balloon with chemistry (no needle)",
                detail: "Pour 2 tablespoons vinegar into an empty plastic bottle. Spoon 2 teaspoons baking soda into a balloon. Stretch the balloon over the bottle mouth WITHOUT spilling. Lift the balloon — the soda falls into the vinegar. Fizz starts, balloon inflates from the CO₂. You just turned a chemical reaction's gas product into mechanical work — the principle behind every airbag in a car."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    private func experimentCard(_ exp: Experiment) -> some View {
        let isSelected = selectedExperiment == exp.id
        let isDone = reacted.contains(exp.id)

        return Button {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.25)) {
                selectedExperiment = exp.id
            }
        } label: {
            VStack(spacing: 8) {
                Text(exp.emoji)
                    .font(.system(size: 36))
                Text(exp.title)
                    .font(.caption.bold())
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                if isDone {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            .frame(width: 130, height: 110)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? Color.orange.opacity(0.12) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(isSelected ? .orange : .gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(exp.title). \(isDone ? "Completed" : "Not yet done")")
    }
}
