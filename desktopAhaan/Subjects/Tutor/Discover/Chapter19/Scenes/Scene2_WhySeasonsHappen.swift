import SwiftUI

/// Scene 2 — Why Seasons Happen.
/// Shows Earth at four orbital positions around the Sun. The Earth circle has an
/// axis tilted at 23.5 degrees. Tap each position to see which hemisphere tilts
/// toward the Sun. After all 4 explored, Got It appears.

struct Scene2_WhySeasonsHappen: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedPosition: Int? = nil
    @State private var exploredPositions: Set<Int> = []
    @State private var tiltDegrees: Double = 23.5
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct OrbitalPosition: Identifiable {
        let id: Int
        let label: String
        let month: String
        let angle: Double          // degrees around the Sun (0 = top)
        let northTilted: String    // "toward" or "away"
        let northSeason: String
        let southSeason: String
        let description: String
    }

    private let positions: [OrbitalPosition] = [
        OrbitalPosition(id: 0, label: "June", month: "Jun",
                        angle: 0, northTilted: "toward",
                        northSeason: "Summer", southSeason: "Winter",
                        description: "The Northern Hemisphere tilts toward the Sun. It gets more direct sunlight and longer days -- that is summer in India, Europe, and North America. Meanwhile the Southern Hemisphere has winter."),
        OrbitalPosition(id: 1, label: "September", month: "Sep",
                        angle: 90, northTilted: "neither",
                        northSeason: "Autumn", southSeason: "Spring",
                        description: "Neither hemisphere tilts strongly toward the Sun. Day and night are nearly equal everywhere. This is the autumnal equinox in the north and the spring equinox in the south."),
        OrbitalPosition(id: 2, label: "December", month: "Dec",
                        angle: 180, northTilted: "away",
                        northSeason: "Winter", southSeason: "Summer",
                        description: "The Northern Hemisphere tilts away from the Sun. Less direct sunlight and shorter days mean winter in India. The Southern Hemisphere is tilted toward the Sun, so Australia enjoys summer."),
        OrbitalPosition(id: 3, label: "March", month: "Mar",
                        angle: 270, northTilted: "neither",
                        northSeason: "Spring", southSeason: "Autumn",
                        description: "Again neither hemisphere tilts strongly toward the Sun. This is the spring equinox in the north. Days start getting longer in India as summer approaches."),
    ]

    private var allDone: Bool { exploredPositions.count == positions.count }

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack so
        // explanation cards don't cover the interactive content.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: DesignTokens.Spacing.md) {
                    Text("Why Seasons Happen")
                        .font(.largeTitle.bold())
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .padding(.top, 18)

                    Text("Tap each Earth position to see how the 23.5 degree tilt creates seasons.")
                        .font(.callout)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                    Spacer()

                    // Orbital diagram
                    ZStack {
                        // Orbit ellipse
                        Ellipse()
                            .strokeBorder(.gray.opacity(0.25), style: StrokeStyle(lineWidth: 1.5, dash: [8, 6]))
                            .frame(width: 380, height: 280)

                        // Central Sun
                        VStack(spacing: DesignTokens.Spacing.xs) {
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.yellow)
                                .shadow(color: .yellow.opacity(0.4), radius: 10)
                            Text("Sun")
                                .font(.caption2.weight(.medium))
                                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        }

                        // Four Earth positions
                        ForEach(positions) { pos in
                            earthButton(for: pos)
                                .offset(orbitalOffset(for: pos.angle))
                        }
                    }
                    .frame(width: 440, height: 340)

                    Text("\(exploredPositions.count) / \(positions.count) positions explored")
                        .font(.caption.weight(.medium))
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            if let idx = selectedPosition, let pos = positions.first(where: { $0.id == idx }) {
                                Label("\(pos.label) -- \(pos.northSeason) (North)", systemImage: SFSymbolCompat.name("globe.europe.africa.fill"))
                                    .font(.title2.bold())
                                Text(pos.description)
                                    .font(.body)
                                    .lineSpacing(4)
                            } else {
                                Label("Earth's Tilted Axis", systemImage: SFSymbolCompat.name("hand.tap.fill"))
                                    .font(.title2.bold())
                                Text("Seasons are NOT caused by Earth being closer or farther from the Sun. They happen because Earth's axis is tilted at 23.5 degrees. Tap each position on the orbit to explore!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    DiscoveryWidget(
                        title: "Discovery — try a different tilt",
                        subtitle: "Earth's axis is tilted at 23.5°. Drag the slider to imagine other worlds with different tilts.",
                        value: $tiltDegrees,
                        range: 0...45,
                        step: 0.5,
                        valueLabel: { v in String(format: "Tilt: %.1f°", v) },
                        output: tiltExplanation
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 Geography + Physics → JEE / NEET",
                        detail: "Earth's 23.5° axial tilt is THE reason seasons exist — NOT distance from the Sun (common misconception). NEET / JEE Geography asks: 'When the Northern hemisphere has summer, where is Earth in its orbit?' Counter-intuitive answer: farthest from Sun (aphelion, July 4). Tilt > distance. Class 12 Physics asks the angular-momentum reason the tilt itself doesn't wobble (gyroscope effect)."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Demonstrate the tilt with a flashlight",
                        detail: "Hold a flashlight directly above a tabletop — bright circle, concentrated. Now tilt it 30° — the same light spreads into an oval, less concentrated per cm². That's exactly what happens to sunlight on a hemisphere tilted away from the Sun: same total energy, spread thinner, lower temperature. Winter."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    if allDone {
                        GotItButton { onComplete() }
                            .padding(.bottom, DesignTokens.Spacing.md)
                    }
                
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)
            
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    // MARK: - Sub-views

    private func earthButton(for pos: OrbitalPosition) -> some View {
        let isSelected = selectedPosition == pos.id
        let isExplored = exploredPositions.contains(pos.id)

        return Button {
            withAnimation(reduceMotion ? .none : .spring()) {
                selectedPosition = pos.id
                exploredPositions.insert(pos.id)
            }
        } label: {
            VStack(spacing: DesignTokens.Spacing.xs) {
                ZStack {
                    // Earth circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.compatCyan.opacity(0.6), .green.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .strokeBorder(isSelected ? Color.compatIndigo : (isExplored ? .green : .gray.opacity(0.4)), lineWidth: 2)
                        )

                    // Tilted axis line (23.5 degrees)
                    Capsule()
                        .fill(.white.opacity(0.8))
                        .frame(width: 1.5, height: 52)
                        .rotationEffect(.degrees(23.5))
                }

                Text(pos.month)
                    .font(.caption.bold())
                    .foregroundColor(isSelected ? Color.compatIndigo : .primary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(pos.label) position. \(isExplored ? "Explored" : "Not yet explored"). North hemisphere: \(pos.northSeason)")
        .accessibilityHint("Selects this orbital position to see its season")
    }

    private func tiltExplanation(_ v: Double) -> String {
        switch v {
        case ..<2:
            return "Almost no seasons. Equal daylight all year everywhere — boring for kids who love summer holidays!"
        case ..<12:
            return "Very mild seasons. Tropical-like climate would stretch far north and south."
        case 12..<20:
            return "Gentle seasons — milder than Earth today. Summers and winters would feel less different."
        case 20...25:
            return "Earth-like seasons (Earth is 23.5°). The familiar pattern of warm summers and cold winters in temperate zones."
        case 25..<35:
            return "Stronger seasons. Hotter summers, colder winters, longer polar days and nights."
        default:
            return "Extreme seasons. Polar regions would spend months in total darkness, then months of nonstop sun."
        }
    }

    private func orbitalOffset(for angleDeg: Double) -> CGSize {
        let rad = angleDeg * .pi / 180
        let rx: CGFloat = 190   // half-width of orbit
        let ry: CGFloat = 140   // half-height of orbit
        let x = sin(rad) * rx
        let y = -cos(rad) * ry
        return CGSize(width: x, height: y)
    }
}
