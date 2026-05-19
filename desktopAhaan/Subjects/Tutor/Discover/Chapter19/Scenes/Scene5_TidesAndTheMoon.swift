import SwiftUI

/// Scene 5 — Tides and the Moon.
/// Shows Earth with tidal bulges and an orbiting Moon. Three info cards to explore:
/// High Tide, Low Tide, Spring & Neap Tides.

struct Scene5_TidesAndTheMoon: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    private struct TideCard: Identifiable {
        let id: String
        let title: String
        let icon: String
        let color: Color
        let explanation: String
    }

    private let cards: [TideCard] = [
        TideCard(id: "high", title: "High Tide", icon: "arrow.up.circle.fill", color: .blue,
                 explanation: "The Moon's gravity pulls ocean water toward it, creating a bulge of high tide on the side nearest the Moon. There is also a bulge on the opposite side of Earth because Earth is pulled toward the Moon slightly more than the far-side water (centrifugal effect). Coastal areas under these bulges experience high tide."),
        TideCard(id: "low", title: "Low Tide", icon: "arrow.down.circle.fill", color: Color.compatTeal,
                 explanation: "At positions 90 degrees from the tidal bulges, water is drawn away toward the bulges, so the water level drops. These areas experience low tide. Most coastlines see two high tides and two low tides every day as Earth rotates beneath the bulges."),
        TideCard(id: "spring_neap", title: "Spring & Neap Tides", icon: "sun.and.horizon.fill", color: .orange,
                 explanation: "During New Moon and Full Moon, the Sun, Moon, and Earth are roughly aligned. The Sun's gravity adds to the Moon's pull, producing extra-high spring tides. During First and Third Quarter Moon, the Sun and Moon are at right angles to Earth, partially cancelling each other out, producing weaker neap tides."),
    ]

    @State private var selectedCard: String? = nil
    @State private var explored: Set<String> = []
    @State private var moonAngle: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var allExplored: Bool { explored.count == cards.count }

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack so
        // explanation cards don't cover the interactive content.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: 14) {
                    Text("Tides and the Moon")
                        .font(.title2.bold())
                        .padding(.top, 14)

                    Text("\(explored.count) / \(cards.count) topics explored")
                        .font(.caption.weight(.medium))
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                    // Tide diagram
                    tideDiagram
                        .frame(maxWidth: 400, maxHeight: 220)
                        .padding(.top, 4)

                    // Info card buttons
                    HStack(spacing: 12) {
                        ForEach(cards) { card in
                            let isSelected = selectedCard == card.id
                            let isExplored = explored.contains(card.id)

                            Button {
                                withAnimation(reduceMotion ? .none : .spring()) {
                                    selectedCard = card.id
                                    explored.insert(card.id)
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: SFSymbolCompat.name(card.icon))
                                        .foregroundColor(card.color)
                                    Text(card.title)
                                        .font(.caption.weight(.semibold))
                                    if isExplored {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.caption2)
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(isSelected ? card.color.opacity(0.12) : Color.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .strokeBorder(isSelected ? card.color : .gray.opacity(0.25), lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let id = selectedCard, let card = cards.first(where: { $0.id == id }) {
                                Label(card.title, systemImage: SFSymbolCompat.name(card.icon))
                                    .font(.title2.bold())
                                    .foregroundColor(card.color)
                                Text(card.explanation)
                                    .font(.body)
                                    .lineSpacing(4)
                            } else {
                                Label("Ocean Tides", systemImage: SFSymbolCompat.name("water.waves"))
                                    .font(.title2.bold())
                                Text("The Moon's gravity is the main cause of ocean tides on Earth. Tap each topic above to learn how tides work!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 Physics → JEE (Gravitation)",
                        detail: "Tides arise from Moon's gravity pulling Earth's near-side water more than its centre, and the centre more than its far-side — a *tidal force* (F ∝ 1/r³, gradient of gravity). JEE-Advanced asks why there are TWO high tides daily, not one. Answer: bulge on Moon-facing side AND opposite-side bulge from inertia. Spring tides (Sun + Moon aligned) vs neap tides (perpendicular)."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Check Mumbai tide tables online",
                        detail: "Google 'Mumbai tide table'. You'll see 2 high tides + 2 low tides each day — separated by ~6 hours. Compare with the moon phase: at full or new moon, the high tides are HIGHER (spring tides) because Sun and Moon pull together. At first/third quarter they're lower (neap tides). The math of gravity, visible at the harbour."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if allExplored {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                
                }
                .padding(.horizontal, 24)
            
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                moonAngle = 360
            }
        }
    }

    // MARK: - Tide Diagram

    private var tideDiagram: some View {
        ZStack {
            // Water bulges (ellipse stretched horizontally)
            Ellipse()
                .fill(Color.blue.opacity(0.18))
                .frame(width: 180, height: 110)
                .rotationEffect(.degrees(moonAngle))

            // Earth
            Circle()
                .fill(Color.blue)
                .frame(width: 80, height: 80)

            Text("Earth")
                .font(.caption2.weight(.bold))
                .foregroundColor(.white)

            // "High Tide" labels on bulge ends
            Text("High")
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.blue)
                .offset(
                    x: 95 * cos(moonAngle * .pi / 180),
                    y: 95 * sin(moonAngle * .pi / 180)
                )

            Text("High")
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.blue)
                .offset(
                    x: -95 * cos(moonAngle * .pi / 180),
                    y: -95 * sin(moonAngle * .pi / 180)
                )

            // Moon orbiting
            Circle()
                .fill(Color.gray)
                .frame(width: 28, height: 28)
                .overlay(
                    Text("Moon")
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(.white)
                )
                .shadow(color: .gray.opacity(0.4), radius: 4)
                .offset(
                    x: 130 * cos(moonAngle * .pi / 180),
                    y: 130 * sin(moonAngle * .pi / 180)
                )

            // Orbit path
            Circle()
                .strokeBorder(.gray.opacity(0.15), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                .frame(width: 260, height: 260)
        }
        .accessibilityLabel("Earth with tidal water bulges and the Moon orbiting around it")
    }
}
