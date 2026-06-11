import SwiftUI

/// Scene 1 — Sour or Bitter? Taste-sorting game.
/// 6 items: user classifies each as Sour (Acid) or Bitter (Base).

struct Scene1_SourOrBitter: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct TasteItem: Identifiable {
        let id = UUID()
        let name: String
        let emoji: String
        let isSour: Bool // true = acid (sour), false = base (bitter)
    }

    private static let allItems: [TasteItem] = [
        TasteItem(name: "Lemon", emoji: "\u{1F34B}", isSour: true),
        TasteItem(name: "Soap", emoji: "\u{1F9FC}", isSour: false),
        TasteItem(name: "Vinegar", emoji: "\u{1FAD9}", isSour: true),
        TasteItem(name: "Baking soda", emoji: "\u{1F9C2}", isSour: false),
        TasteItem(name: "Orange", emoji: "\u{1F34A}", isSour: true),
        TasteItem(name: "Milk of magnesia", emoji: "\u{1F95B}", isSour: false),
    ]

    @State private var items = Scene1_SourOrBitter.allItems
    @State private var currentIndex: Int = 0
    @State private var results: [Bool] = []          // true = correct
    @State private var flashColor: Color? = nil
    @State private var shakeOffset: CGFloat = 0
    @State private var allDone = false

    private var currentItem: TasteItem? {
        currentIndex < items.count ? items[currentIndex] : nil
    }

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack so
        // explanation cards don't cover the interactive content.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    Text("Classify each item")
                        .font(.title2.bold())
                        .padding(.top, 18)

                    // Progress pills
                    HStack(spacing: 6) {
                        ForEach(0..<items.count, id: \.self) { i in
                            Capsule()
                                .fill(pillColor(for: i))
                                .frame(width: 36, height: 8)
                        }
                    }

                    if let item = currentItem {
                        // Current item card
                        SoftShadowCard(padding: 24) {
                            VStack(spacing: DesignTokens.Spacing.md) {
                                Text(item.emoji)
                                    .font(.system(size: 64))
                                Text(item.name)
                                    .font(.title.bold())
                            }
                        }
                        .frame(maxWidth: 340)
                        .offset(x: shakeOffset)
                        .background(
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                                .fill((flashColor ?? .clear).opacity(0.2))
                        )

                        // Two choice buttons
                        HStack(spacing: 20) {
                            choiceButton(label: "Sour (Acid)", color: .red, isSourChoice: true)
                            choiceButton(label: "Bitter (Base)", color: .blue, isSourChoice: false)
                        }
                        .frame(maxWidth: 500)
                    }

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Bottom card + GotIt
                Group {
                    if allDone {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                                Label("Well done!", systemImage: "star.fill")
                                    .font(.title2.bold())
                                    .foregroundColor(.orange)
                                Text("Acids taste sour (like lemon and vinegar). Bases taste bitter and feel soapy (like baking soda and soap). Never taste unknown chemicals \u{2014} scientists use indicators instead!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        LookingAheadCallout(
                            title: "Class 11 Chemistry → JEE / NEET",
                            detail: "Sour-and-bitter is your tongue measuring H⁺ vs OH⁻ — JEE's Arrhenius definition. By Class 11 you learn three definitions (Arrhenius, Brønsted-Lowry, Lewis), each catching cases the previous misses. NEET asks 'why does NH₃ act as a base?' — it accepts H⁺ (Brønsted) and donates electron pair (Lewis), even though it has no OH⁻ (fails Arrhenius)."
                        )
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        TryAtHomeCallout(
                            title: "Red-cabbage indicator at home",
                            detail: "Boil chopped red cabbage in water for 10 minutes. Strain — you have purple cabbage juice. Drop it into vinegar (red/pink), lemon juice (pink), water (purple), baking soda (blue), soap solution (green). One natural indicator, six colours across the pH range. Cheaper than litmus and just as scientific."
                        )
                        .frame(maxWidth: DesignTokens.contentMaxWidth)

                        GotItButton { onComplete() }
                            .padding(.bottom, DesignTokens.Spacing.md)
                    } else {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                                Label("Sour or Bitter?", systemImage: SFSymbolCompat.name("mouth.fill"))
                                    .font(.title2.bold())
                                Text("Acids taste sour, bases taste bitter. Tap the correct category for each item!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .padding(.bottom, DesignTokens.Spacing.md)
                    }
                
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)
            
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    // MARK: - Subviews

    private func choiceButton(label: String, color: Color, isSourChoice: Bool) -> some View {
        Button {
            guard let item = currentItem else { return }
            let correct = item.isSour == isSourChoice
            results.append(correct)

            if correct {
                flashColor = .green
                withAnimation(reduceMotion ? .none : .easeOut(duration: 0.3)) {
                    flashColor = .green
                }
            } else {
                flashColor = .red
                if !reduceMotion {
                    withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { shakeOffset = 12 }
                    Task { @MainActor in
                        try? await Task.sleep(nanoseconds: 150_000_000)
                        withAnimation(.spring(response: 0.15, dampingFraction: 0.3)) { shakeOffset = -10 }
                        try? await Task.sleep(nanoseconds: 150_000_000)
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) { shakeOffset = 0 }
                    }
                }
            }

            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 600_000_000)
                flashColor = nil
                shakeOffset = 0
                if currentIndex < items.count - 1 {
                    withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.25)) {
                        currentIndex += 1
                    }
                } else {
                    withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
                        allDone = true
                    }
                }
            }
        } label: {
            Text(label)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        
        .accentColor(color)
        .accessibilityLabel("Classify as \(label)")
    }

    private func pillColor(for index: Int) -> Color {
        if index < results.count {
            return results[index] ? .green : .red
        }
        if index == currentIndex { return Color.compatIndigo }
        return .gray.opacity(0.25)
    }
}
