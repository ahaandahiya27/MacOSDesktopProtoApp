import SwiftUI

/// Scene 6 — Solar System Sorter (Scored).
/// 8 planets shown in random order. User taps a planet then taps a slot to place it.
/// Score: 2 points per correct placement = max 16.

struct Scene6_SolarSystemSorter: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: (Int) -> Void

    private static let correctOrder = [
        "Mercury", "Venus", "Earth", "Mars",
        "Jupiter", "Saturn", "Uranus", "Neptune"
    ]

    private static let planetColors: [String: Color] = [
        "Mercury": .gray,
        "Venus": .orange,
        "Earth": .blue,
        "Mars": .red,
        "Jupiter": Color.compatBrown,
        "Saturn": .yellow,
        "Uranus": Color.compatCyan,
        "Neptune": Color.compatIndigo,
    ]

    @State private var shuffledPlanets: [String]
    @State private var slots: [String?] = Array(repeating: nil, count: 8)
    @State private var selectedPlanet: String? = nil
    @State private var score: Int = 0
    @State private var isSubmitted = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(pack: SubjectPack, chapter: Chapter, onComplete: @escaping (Int) -> Void) {
        self.pack = pack
        self.chapter = chapter
        self.onComplete = onComplete
        _shuffledPlanets = State(initialValue: Self.correctOrder.shuffled())
    }

    private var allPlaced: Bool { slots.allSatisfy { $0 != nil } }

    /// Planets that have not been placed in any slot yet
    private var availablePlanets: [String] {
        let placed = Set(slots.compactMap { $0 })
        return shuffledPlanets.filter { !placed.contains($0) }
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack(spacing: 14) {
                    Text("Solar System Sorter")
                        .font(.title2.bold())
                        .padding(.top, 14)

                    if isSubmitted {
                        Text("Score: \(score) / 16")
                            .font(.headline.monospacedDigit())
                            .foregroundColor(Color.compatIndigo)
                    } else {
                        Text("Arrange the 8 planets in order from the Sun")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }

                    // Planet chips (available)
                    if !isSubmitted {
                        HStack(spacing: 8) {
                            ForEach(availablePlanets, id: \.self) { planet in
                                let isSelected = selectedPlanet == planet
                                let color = Self.planetColors[planet] ?? .gray

                                Button {
                                    withAnimation(reduceMotion ? .none : .spring()) {
                                        selectedPlanet = isSelected ? nil : planet
                                    }
                                } label: {
                                    Text(planet)
                                        .font(.body.weight(.medium))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(isSelected ? color.opacity(0.2) : Color(NSColor.windowBackgroundColor))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .strokeBorder(isSelected ? color : .gray.opacity(0.25), lineWidth: isSelected ? 2 : 1)
                                        )
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("\(planet). \(isSelected ? "Selected" : "Tap to select")")
                            }
                        }
                        .padding(.horizontal, 8)
                    }

                    // Numbered slots
                    HStack(spacing: 8) {
                        ForEach(0..<8, id: \.self) { index in
                            slotView(index: index)
                        }
                    }
                    .padding(.horizontal, 12)

                    // Submit button
                    if allPlaced && !isSubmitted {
                        Button {
                            submitAnswer()
                        } label: {
                            Text("Check My Order")
                                .font(.body.weight(.semibold))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.accentColor)
                                )
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 4)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

                VStack(spacing: 14) {
                    Spacer()

                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            if isSubmitted {
                                Label("Results: \(score) / 16", systemImage: "star.fill")
                                    .font(.title2.bold())
                                    .foregroundColor(.orange)

                                Text("Correct order: Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune.")
                                    .font(.body)
                                    .lineSpacing(4)

                                Text("Mnemonic: \"My Very Educated Mother Just Showed Us Neptune\"")
                                    .font(.callout.italic())
                                    .foregroundColor(.secondary)
                                    .padding(.top, 2)
                            } else {
                                Label("Order the Planets", systemImage: SFSymbolCompat.name("globe.americas.fill"))
                                    .font(.title2.bold())
                                Text("Tap a planet chip, then tap a numbered slot to place it. Tap a filled slot to remove it. Arrange all 8 planets from closest to farthest from the Sun, then check your answer!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: 640)

                    if isSubmitted {
                        GotItButton { onComplete(score) }
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Slot View

    private func slotView(index: Int) -> some View {
        let planet = slots[index]
        let color = planet.flatMap { Self.planetColors[$0] } ?? .gray

        let isCorrect: Bool? = isSubmitted ? (planet == Self.correctOrder[index]) : nil

        return Button {
            guard !isSubmitted else { return }
            if let placed = planet {
                // Remove planet from slot
                withAnimation(reduceMotion ? .none : .spring()) {
                    slots[index] = nil
                    if selectedPlanet == nil {
                        selectedPlanet = placed
                    }
                }
            } else if let selected = selectedPlanet {
                // Place selected planet into slot
                withAnimation(reduceMotion ? .none : .spring()) {
                    slots[index] = selected
                    selectedPlanet = nil
                }
            }
        } label: {
            VStack(spacing: 4) {
                Text("\(index + 1)")
                    .font(.caption2.weight(.bold))
                    .foregroundColor(.secondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(planet != nil ? color.opacity(0.15) : Color(NSColor.windowBackgroundColor))
                        .frame(width: 72, height: 52)

                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(
                            isCorrect == true ? .green :
                            isCorrect == false ? .red :
                            .gray.opacity(0.3),
                            style: planet != nil
                                ? StrokeStyle(lineWidth: 1.5)
                                : StrokeStyle(lineWidth: 1.5, dash: [5, 4]),
                            antialiased: true
                        )
                        .frame(width: 72, height: 52)

                    if let planet = planet {
                        Text(planet)
                            .font(.caption.weight(.semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }

                if let correct = isCorrect {
                    Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(correct ? .green : .red)
                } else {
                    Color.clear.frame(height: 14)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Slot \(index + 1). \(planet ?? "Empty"). \(isCorrect == true ? "Correct" : isCorrect == false ? "Incorrect" : "")")
    }

    // MARK: - Submit

    private func submitAnswer() {
        var total = 0
        for i in 0..<8 {
            if slots[i] == Self.correctOrder[i] {
                total += 2
            }
        }
        withAnimation(reduceMotion ? .none : .spring()) {
            score = total
            isSubmitted = true
        }
    }
}
