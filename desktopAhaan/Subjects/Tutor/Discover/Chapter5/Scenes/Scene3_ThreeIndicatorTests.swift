import SwiftUI

/// Scene 3 — Three Indicator Tests.
/// Three test tubes with Litmus, Turmeric, Phenolphthalein. User adds acid or base to see color changes.

struct Scene3_ThreeIndicatorTests: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private enum Solution: String, CaseIterable { case acid = "Acid", base = "Base" }

    private struct Indicator: Identifiable {
        let id = UUID()
        let name: String
        let icon: String
        let neutralColor: Color
        let acidColor: Color
        let baseColor: Color
        let acidNote: String
        let baseNote: String
    }

    private let indicators: [Indicator] = [
        Indicator(
            name: "Litmus",
            icon: "drop.fill",
            neutralColor: .purple,
            acidColor: .red,
            baseColor: .blue,
            acidNote: "Litmus turns red in acid.",
            baseNote: "Litmus turns blue in base."
        ),
        Indicator(
            name: "Turmeric",
            icon: "leaf.fill",
            neutralColor: .yellow,
            acidColor: .yellow,
            baseColor: .red,
            acidNote: "Turmeric stays yellow in acid \u{2014} no change.",
            baseNote: "Turmeric turns red/brown in base."
        ),
        Indicator(
            name: "Phenolphthalein",
            icon: "flask.fill",
            neutralColor: Color(NSColor.windowBackgroundColor),
            acidColor: Color(NSColor.windowBackgroundColor),
            baseColor: .pink,
            acidNote: "Phenolphthalein stays colourless in acid.",
            baseNote: "Phenolphthalein turns pink in base."
        ),
    ]

    @State private var tested: [[Solution]] = [[], [], []]   // which solutions tested per indicator
    @State private var activeIndicator: Int? = nil
    @State private var activeSolution: Solution? = nil

    private var allTested: Bool {
        tested.allSatisfy { $0.contains(.acid) && $0.contains(.base) }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack(spacing: 20) {
                    ForEach(Array(indicators.enumerated()), id: \.offset) { idx, ind in
                        testTubeView(index: idx, indicator: ind, height: geo.size.height * 0.42)
                    }
                }
                .frame(maxWidth: 720, maxHeight: .infinity, alignment: .top)
                .padding(.top, 20)
                .frame(maxWidth: .infinity)

                VStack(spacing: 14) {
                    Spacer()

                    // Explanation card
                    if let ai = activeIndicator, let sol = activeSolution {
                        let ind = indicators[ai]
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label(ind.name, systemImage: ind.icon)
                                    .font(.title2.bold())
                                    .foregroundColor(sol == .acid ? ind.acidColor : ind.baseColor)
                                Text(sol == .acid ? ind.acidNote : ind.baseNote)
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                        .transition(.opacity)
                    } else {
                        SoftShadowCard(padding: 18) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Three Indicator Tests", systemImage: SFSymbolCompat.name("testtube.2"))
                                    .font(.title2.bold())
                                Text("Indicators change colour in acids and bases. Tap the acid or base button on each test tube to see what happens!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        .frame(maxWidth: DesignTokens.contentMaxWidth)
                    }

                    LookingAheadCallout(
                        title: "Class 11 Chemistry → JEE (Acid-Base Titrations)",
                        detail: "Indicators are weak acids/bases whose protonated and deprotonated forms have different colours. Phenolphthalein is colourless below pH 8.3 and pink above. JEE asks: 'Which indicator should I use for HCl + NaOH titration?' Phenolphthalein (works at strong-acid + strong-base endpoint pH ≈ 7). But for weak-acid + strong-base, the endpoint is pH 9 — methyl orange would mislead you. Choose the indicator to match the equivalence point."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Turmeric is an acid-base indicator",
                        detail: "Mix a pinch of turmeric powder in water — yellow solution. Add baking soda — turns reddish-brown. Add lemon juice — back to yellow. That's why old stains from turmeric get worse when you wipe with soap (basic) but lift with lemon (acidic). Same chemistry NCERT writes formally as phenolphthalein."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if allTested {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    } else {
                        Text("Test all 3 indicators with both acid and base")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Test tube view

    @ViewBuilder
    private func testTubeView(index: Int, indicator: Indicator, height: CGFloat) -> some View {
        let testedSolutions = tested[index]
        let currentColor: Color = {
            if testedSolutions.last == .acid { return indicator.acidColor }
            if testedSolutions.last == .base { return indicator.baseColor }
            return indicator.neutralColor
        }()

        VStack(spacing: 10) {
            Text(indicator.name)
                .font(.headline)

            // Test tube shape
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.gray.opacity(0.08))
                    .frame(width: 60, height: height * 0.6)

                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(currentColor.opacity(0.6))
                    .frame(width: 52, height: height * 0.4)
                    .animation(reduceMotion ? .none : .easeInOut(duration: 0.5))

                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 60, height: height * 0.6)
            }

            // Buttons
            HStack(spacing: 8) {
                Button("+ Acid") {
                    addSolution(.acid, to: index)
                }
                
                .accentColor(.red)
                .controlSize(.small)

                Button("+ Base") {
                    addSolution(.base, to: index)
                }
                
                .accentColor(.blue)
                .controlSize(.small)
            }

            // Checkmarks
            HStack(spacing: 4) {
                if testedSolutions.contains(.acid) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                if testedSolutions.contains(.base) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(NSColor.windowBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(activeIndicator == index ? Color.compatIndigo : .gray.opacity(0.2), lineWidth: 2)
        )
        .accessibilityLabel("\(indicator.name) test tube")
    }

    private func addSolution(_ sol: Solution, to index: Int) {
        if !tested[index].contains(sol) {
            tested[index].append(sol)
        }
        withAnimation(reduceMotion ? .none : .easeInOut(duration: 0.3)) {
            activeIndicator = index
            activeSolution = sol
        }
    }
}
