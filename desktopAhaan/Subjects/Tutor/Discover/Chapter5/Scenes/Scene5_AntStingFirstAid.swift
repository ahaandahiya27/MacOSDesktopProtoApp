import SwiftUI

/// Scene 5 — Ant Sting First Aid.
/// Story: ant stings, user picks correct remedy (baking soda) from options.

struct Scene5_AntStingFirstAid: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct Remedy: Identifiable {
        let id = UUID()
        let name: String
        let emoji: String
        let isCorrect: Bool
        let explanation: String
    }

    private let remedies: [Remedy] = [
        Remedy(name: "Baking soda paste", emoji: "\u{1F9C2}", isCorrect: true,
               explanation: "Baking soda is a mild base. It neutralises the formic acid from the ant sting, reducing pain and swelling."),
        Remedy(name: "Lemon juice", emoji: "\u{1F34B}", isCorrect: false,
               explanation: "Lemon juice is acidic. Adding acid to an acid sting would make it worse!"),
        Remedy(name: "Vinegar", emoji: "\u{1FAD9}", isCorrect: false,
               explanation: "Vinegar is also an acid \u{2014} it would not help neutralise the formic acid."),
        Remedy(name: "Table salt", emoji: "\u{1F9C2}", isCorrect: false,
               explanation: "Salt is neutral. It won\u{2019}t neutralise the acid from the sting."),
    ]

    @State private var selectedRemedy: UUID? = nil
    @State private var showResult = false
    @State private var shakeOffset: CGFloat = 0

    private var chosenRemedy: Remedy? {
        remedies.first { $0.id == selectedRemedy }
    }

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack so
        // explanation cards don't cover the interactive content.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: 16) {
                    // Story header
                    Text("Ant Sting First Aid")
                        .font(.title2.bold())
                        .padding(.top, 18)

                    // Story illustration
                    SoftShadowCard(padding: 20) {
                        VStack(spacing: 12) {
                            Text("\u{1F41C}")
                                .font(.system(size: 56))
                            Text("Ouch! An ant just stung your hand!")
                                .font(.title3.bold())
                                .multilineTextAlignment(.center)
                            Text("The ant injected formic acid into your skin. It stings and burns. What should you apply to feel better?")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: 520)

                    // Remedy choices
                    if !showResult {
                        VStack(spacing: 10) {
                            ForEach(remedies) { remedy in
                                Button {
                                    chooseRemedy(remedy)
                                } label: {
                                    HStack(spacing: 12) {
                                        Text(remedy.emoji)
                                            .font(.title2)
                                        Text(remedy.name)
                                            .font(.body.weight(.medium))
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .buttonStyle(.plain)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(.gray.opacity(0.25), lineWidth: 1.5)
                                )
                            }
                        }
                        .frame(maxWidth: 440)
                        .offset(x: shakeOffset)
                    }

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Result + GotIt
                Group {
                    if showResult, let remedy = chosenRemedy {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label(
                                    remedy.isCorrect ? "Correct!" : "Not quite!",
                                    systemImage: remedy.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill"
                                )
                                .font(.title2.bold())
                                .foregroundColor(remedy.isCorrect ? .green : .red)

                                Text(remedy.explanation)
                                    .font(.body)
                                    .lineSpacing(4)

                                if !remedy.isCorrect {
                                    Text("The correct answer is baking soda paste \u{2014} a base that neutralises formic acid.")
                                        .font(.callout)
                                        .foregroundColor(Color.compatIndigo)
                                        .padding(.top, 4)
                                }
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        LookingAheadCallout(
                            title: "Class 12 Biology → NEET (Sting Pharmacology)",
                            detail: "Ant + bee venom = mostly *formic acid* (acidic) → neutralise with baking soda paste. Wasp venom = mostly *alkaline* peptides → neutralise with vinegar. Snake venom = a protein cocktail (more complex). NEET tests venom chemistry alongside antivenom (passive immunisation by injecting horse antibodies). Knowing 'acid vs base' first-aid is real medicine the kid can do."
                        )
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        TryAtHomeCallout(
                            title: "Test the first-aid logic",
                            detail: "If anyone gets a *bee* sting (acidic): apply baking soda + water paste. If a *wasp* sting (alkaline): apply vinegar. Watch the pain ease within a minute. You're doing literal chemistry as medicine — same molecules NCERT teaches you in Class 7, applied at the right pH."
                        )
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                
                }
                .padding(.horizontal, 24)
            
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
    }

    // MARK: - Actions

    private func chooseRemedy(_ remedy: Remedy) {
        selectedRemedy = remedy.id

        if remedy.isCorrect {
            withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                showResult = true
            }
        } else {
            // Shake then show
            if !reduceMotion {
                withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { shakeOffset = 12 }
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 150_000_000)
                    withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { shakeOffset = -10 }
                    try? await Task.sleep(nanoseconds: 150_000_000)
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) { shakeOffset = 0 }
                }
            }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 500_000_000)
                withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                    showResult = true
                }
            }
        }
    }
}
