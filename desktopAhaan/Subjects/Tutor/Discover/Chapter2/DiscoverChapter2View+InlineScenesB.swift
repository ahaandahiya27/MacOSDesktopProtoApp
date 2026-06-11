import SwiftUI

// Inline scenes 17, 18, 19 + the Window-in-the-Stomach enrichment
// lifted from `DiscoverChapter2View.swift` 2026-05-26 (consolidation
// pass round 5) to bring the parent under the 600-LOC Big Sur
// ceiling. Same shape as the Ch.3/4/5 splits (commits dca042c,
// edfc32c, 2faf80f) but larger — 4 scenes plus the WindowFoodCard
// helper struct.
//
// Scopes change from file-private to module-internal — only the
// Ch.2 dispatcher references these scenes, so the broadened
// visibility is benign.

// MARK: - Inline Scene 17: Cow vs Goat vs Camel (Topic 2)
struct CowGoatCamelScene: View {
    let onComplete: () -> Void

    private struct Animal: Identifiable {
        let id: String; let emoji: String; let name: String; let strategy: String
    }
    private let animals: [Animal] = [
        Animal(id: "cow", emoji: "🐄", name: "Cow",
               strategy: "Four-chambered stomach. Eats fast in the field, ruminates safely in the barn."),
        Animal(id: "goat", emoji: "🐐", name: "Goat",
               strategy: "Same four chambers but smaller. Eats almost anything — leaves, bark, even tin cans (not really nutritious!)."),
        Animal(id: "camel", emoji: "🐪", name: "Camel",
               strategy: "Three-chambered. Stores chewed food + water for days; can drink 100 L in one go.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Three Ruminant Strategies")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                ForEach(animals) { a in
                    HStack(spacing: 14) {
                        Text(a.emoji).font(.system(size: 50))
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                            Text(a.name).font(.headline)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                            Text(a.strategy).font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(DesignTokens.Spacing.md)
                    .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                }
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Inline Scene 18: Food Vacuole Formation (Topic 3)
struct FoodVacuoleFormationScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0

    private let stages = [
        "1. Amoeba spots food. Cytoplasm starts to flow toward it.",
        "2. Two pseudopodia extend outward, wrapping around the food.",
        "3. The two arms meet on the far side — food trapped inside.",
        "4. The trapped pocket pinches off into a food vacuole — digestion begins."
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Amoeba: Food Vacuole Forms")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                amoebaVisual.frame(width: 220, height: 180)
                Text(stages[stage])
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl).frame(maxWidth: DesignTokens.contentMaxWidth)
                Button {
                    withAnimationRespectingReduceMotion(.easeInOut(duration: 0.25)) {
                        stage = (stage + 1) % stages.count
                    }
                } label: {
                    Text(stage == stages.count - 1 ? "Replay" : "Next stage")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var amoebaVisual: some View {
        let pseudoX: CGFloat = 60 - CGFloat(stage * 10)
        return ZStack {
            Circle().fill(DesignTokens.BrandColor.relatedConcepts.opacity(0.35))
                .frame(width: 130, height: 130)
            if stage >= 1 {
                Capsule().fill(DesignTokens.BrandColor.relatedConcepts.opacity(0.35))
                    .frame(width: 40, height: 70)
                    .offset(x: pseudoX, y: -20)
                Capsule().fill(DesignTokens.BrandColor.relatedConcepts.opacity(0.35))
                    .frame(width: 40, height: 70)
                    .offset(x: pseudoX, y: 20)
            }
            // The food
            Circle().fill(DesignTokens.BrandColor.danger.opacity(0.8))
                .frame(width: 22, height: 22)
                .offset(x: stage >= 3 ? 0 : 80)
        }
    }
}

// MARK: - Inline Scene 19: Pseudopod Catch (Topic 3)
//
// Timing mini-game: bits of "food" drift past an amoeba. Tap "Grab" when
// food crosses the catch zone. 5 rounds, score what you caught.
struct PseudopodCatchScene: View {
    let onComplete: (Int) -> Void
    @State private var round: Int = 0
    @State private var caught: Int = 0
    @State private var foodPosition: CGFloat = -120   // x offset
    @State private var roundActive: Bool = false

    private let totalRounds = 5

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Pseudopod Catch")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text("Tap Grab! the moment food drifts over the amoeba. Real amoebas have only one shot per meal — focus on timing.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                catchVisual.frame(width: 280, height: 140)
                HStack(spacing: 14) {
                    Button { startRound() } label: {
                        Text(round >= totalRounds ? "Replay" : "Release food")
                            .font(.body.weight(.semibold))
                            .padding(.horizontal, DesignTokens.Spacing.lg).padding(.vertical, 9)
                            .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                            .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                            .foregroundColor(Color.compatIndigo)
                    }
                    .buttonStyle(.plain).pointingCursor().disabled(roundActive)
                    Button { grab() } label: {
                        Text("Grab!")
                            .font(.body.weight(.bold))
                            .padding(.horizontal, DesignTokens.Spacing.lg).padding(.vertical, 9)
                            .background(Capsule().fill(DesignTokens.BrandColor.primaryAction.opacity(0.18)))
                            .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.primaryAction.opacity(0.5), lineWidth: 1))
                            .foregroundColor(DesignTokens.BrandColor.primaryAction)
                    }
                    .buttonStyle(.plain).pointingCursor().disabled(!roundActive)
                }
                Text("Caught: \(caught) / \(totalRounds) · Round: \(min(round + 1, totalRounds))")
                    .font(.callout.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                GotItButton(action: { onComplete(caught) }).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private var catchVisual: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14).fill(Color.gray.opacity(0.08))
                .frame(width: 280, height: 140)
            Circle().fill(DesignTokens.BrandColor.relatedConcepts.opacity(0.35))
                .frame(width: 80, height: 80)
            if roundActive {
                Circle().fill(DesignTokens.BrandColor.danger.opacity(0.9))
                    .frame(width: 22, height: 22)
                    .offset(x: foodPosition)
            }
            // catch zone hint
            Rectangle().strokeBorder(DesignTokens.BrandColor.primaryAction.opacity(0.35), lineWidth: 1)
                .frame(width: 50, height: 100)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func startRound() {
        if round >= totalRounds { round = 0; caught = 0 }
        roundActive = true
        foodPosition = -120
        Task { @MainActor in
            // Animate food across 280pt in ~1.8s
            withAnimationRespectingReduceMotion(.linear(duration: 1.8)) { foodPosition = 120 }
            try? await Task.sleep(nanoseconds: 1_800_000_000)
            if roundActive {
                roundActive = false
                round += 1
            }
        }
    }

    private func grab() {
        // Catch window: |x| < 25 counts as in the catch zone
        if abs(foodPosition) < 25 { caught += 1 }
        roundActive = false
        round += 1
    }
}

// MARK: - Window in the Stomach (inline Scene 20)
//
// True story enrichment beyond NCERT: in 1822 a fur trader named Alexis
// St Martin was shot in the side. The wound healed but a small hole into
// his stomach refused to close — about the size of a 5-rupee coin. His
// doctor, William Beaumont, dropped food on a string through the hole
// and pulled it back out at intervals to time digestion. That gruesome
// study is where the world's first digestion timetable came from.
//
// Interaction: kid taps food items, sees how long Beaumont measured
// each one to digest. A short "What we owe him" reveal after all five
// foods have been tried. Big Sur compatible.
struct WindowInTheStomachScene: View {
    let onComplete: () -> Void

    private struct FoodTiming: Identifiable {
        let id: String
        let emoji: String
        let name: String
        let minutes: Int
        let why: String
    }

    private let foods: [FoodTiming] = [
        FoodTiming(id: "apple",   emoji: "🍎", name: "Raw apple cubes",     minutes: 90,
                   why: "Soft fruits digest fast — sugars and water are easy work."),
        FoodTiming(id: "cabbage", emoji: "🥬", name: "Boiled cabbage",      minutes: 150,
                   why: "Cooked vegetables sit in the stomach a bit longer. Fibre slows things down."),
        FoodTiming(id: "beef",    emoji: "🥩", name: "Roast beef",          minutes: 210,
                   why: "Protein and fat take more time. Acid and enzymes attack them slowly."),
        FoodTiming(id: "potato",  emoji: "🍟", name: "Fried potatoes",      minutes: 270,
                   why: "Fat from frying coats the food, blocking acid. Worst offender on Beaumont's list."),
        FoodTiming(id: "milk",    emoji: "🥛", name: "Raw cow's milk",      minutes: 135,
                   why: "Milk fat slows digestion a little; sugars and proteins do the rest of the work."),
    ]

    @State private var revealed: Set<String> = []
    @State private var finishedShown: Bool = false

    private var allRevealed: Bool { revealed.count == foods.count }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Window in the Stomach")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)

                Text("In 1822 a fur trader called Alexis St Martin was shot in the side. The wound healed, but the hole into his stomach never closed. His doctor, William Beaumont, used that tiny opening to time how long different foods take to digest. Tap each food to see what Beaumont measured.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: 600)

                VStack(spacing: 10) {
                    ForEach(foods) { food in
                        WindowFoodCard(emoji: food.emoji,
                                       name: food.name,
                                       minutes: food.minutes,
                                       why: food.why,
                                       revealed: revealed.contains(food.id)) {
                            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) {
                                _ = revealed.insert(food.id)
                            }
                        }
                    }
                }
                .frame(maxWidth: 560)

                if allRevealed {
                    SoftShadowCard(padding: 14) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Text("What the world owes one tiny hole")
                                .font(.headline)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                            Text("Beaumont published his digestion times in 1833. They became the foundation of modern gastric physiology. Alexis St Martin lived to 86 — outliving Beaumont by 27 years — and is buried in a quiet cemetery in Quebec. One messy accident and one curious doctor gave us the first real timetable of how the human stomach works.")
                                .font(.callout)
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .frame(maxWidth: 600)

                    GotItButton { onComplete() }
                        .padding(.bottom, DesignTokens.Spacing.md)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

struct WindowFoodCard: View {
    let emoji: String
    let name: String
    let minutes: Int
    let why: String
    let revealed: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Text(emoji).font(.system(size: 28))
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                    if revealed {
                        Text(formatMinutes(minutes))
                            .font(.subheadline.bold())
                            .foregroundColor(Color.compatIndigo)
                        Text(why)
                            .font(.caption)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("Tap to see digestion time")
                            .font(.caption)
                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    }
                }
                Spacer()
                Image(systemName: revealed ? "checkmark.circle.fill" : "questionmark.circle")
                    .font(.title3)
                    .foregroundColor(revealed ? .green : DesignTokens.BrandColor.canvasTextSecondary)
            }
            .padding(DesignTokens.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(revealed ? Color.compatIndigo.opacity(0.45) : Color.gray.opacity(0.20),
                                  lineWidth: 1.3)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(revealed)
    }

    private func formatMinutes(_ m: Int) -> String {
        let h = m / 60
        let r = m % 60
        if h == 0 { return "\(r) min" }
        if r == 0 { return "\(h) h" }
        return "\(h) h \(r) min"
    }
}
