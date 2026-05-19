import SwiftUI

/// Scene 7 — Constellation Connect.
/// Four constellation cards in a grid. Tap each to explore its details.
/// After all 4 explored, show GotIt.

struct Scene7_ConstellationConnect: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedConstellation: Int? = nil
    @State private var explored: Set<Int> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct Constellation: Identifiable {
        let id: Int
        let name: String
        let indianName: String
        let symbol: String
        let color: Color
        let shape: String
        let facts: [String]
    }

    private let constellations: [Constellation] = [
        Constellation(
            id: 0,
            name: "Ursa Major",
            indianName: "Saptarishi",
            symbol: "star.fill",
            color: Color.compatIndigo,
            shape: "Ladle / Plough",
            facts: [
                "Seven bright stars form a ladle or plough shape in the sky.",
                "Used to locate the Pole Star \u{2014} extend the line from the two pointer stars about five times.",
                "Visible throughout the year in the northern hemisphere."
            ]
        ),
        Constellation(
            id: 1,
            name: "Orion",
            indianName: "Mriga / The Hunter",
            symbol: "sparkles",
            color: Color.compatCyan,
            shape: "Hunter with belt",
            facts: [
                "Three stars in a straight line form Orion's Belt \u{2014} one of the easiest patterns to spot.",
                "Best visible during winter evenings (November to February).",
                "Sirius, the brightest star in the night sky, lies near Orion."
            ]
        ),
        Constellation(
            id: 2,
            name: "Cassiopeia",
            indianName: "Sharmishtha",
            symbol: "wand.and.stars",
            color: .purple,
            shape: "W-shape",
            facts: [
                "Five bright stars form a distinctive W or M shape in the sky.",
                "Visible in the northern sky throughout the year.",
                "Rotates around the Pole Star, so its orientation changes with the seasons."
            ]
        ),
        Constellation(
            id: 3,
            name: "Leo",
            indianName: "Simha",
            symbol: "shield.fill",
            color: .orange,
            shape: "Crouching lion",
            facts: [
                "Looks like a crouching lion with a curved head and long body.",
                "Best visible in the spring sky (March to May).",
                "Regulus, its brightest star, marks the heart of the lion."
            ]
        )
    ]

    private var allExplored: Bool { explored.count == constellations.count }

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack so
        // explanation cards don't cover the interactive content.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                VStack(spacing: 14) {
                    Text("Constellation Connect")
                        .font(.title2.bold())
                        .padding(.top, 14)

                    Text("\(explored.count) / \(constellations.count) constellations explored")
                        .font(.caption.weight(.medium))
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                    // Starry sky backdrop
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color(red: 0.05, green: 0.05, blue: 0.2),
                                Color(red: 0.02, green: 0.02, blue: 0.12)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        // Scattered stars
                        ForEach(0..<30, id: \.self) { i in
                            Circle()
                                .fill(.white.opacity(Double.random(in: 0.3...0.9)))
                                .frame(width: CGFloat.random(in: 1.5...3.5))
                                .offset(
                                    x: CGFloat.random(in: -220...220),
                                    y: CGFloat.random(in: -55...55)
                                )
                        }
                    }
                    .frame(maxWidth: 500, maxHeight: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(.gray.opacity(0.2), lineWidth: 1)
                    )

                    // Constellation cards in 2x2 grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(constellations) { constellation in
                            let isSelected = selectedConstellation == constellation.id
                            let isExplored = explored.contains(constellation.id)

                            Button {
                                withAnimation(reduceMotion ? .none : .spring()) {
                                    selectedConstellation = constellation.id
                                    explored.insert(constellation.id)
                                }
                            } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: constellation.symbol)
                                        .font(.title2)
                                        .foregroundColor(isSelected ? .white : constellation.color)
                                    Text(constellation.name)
                                        .font(.body.weight(.semibold))
                                        .foregroundColor(isSelected ? .white : .primary)
                                    Text(constellation.indianName)
                                        .font(.caption)
                                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                                    if isExplored {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.caption)
                                            .foregroundColor(isSelected ? .white : .green)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(isSelected ? constellation.color : Color.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .strokeBorder(isExplored ? .green.opacity(0.4) : .gray.opacity(0.2), lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(constellation.name). \(isExplored ? "Explored" : "Tap to explore")")
                        }
                    }
                    .frame(maxWidth: 440)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let idx = selectedConstellation,
                               let constellation = constellations.first(where: { $0.id == idx }) {
                                Label("\(constellation.name) (\(constellation.indianName))", systemImage: constellation.symbol)
                                    .font(.title2.bold())
                                    .foregroundColor(constellation.color)

                                Text("Shape: \(constellation.shape)")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                                ForEach(constellation.facts, id: \.self) { fact in
                                    HStack(alignment: .top, spacing: 6) {
                                        Image(systemName: "star.fill")
                                            .font(.caption2)
                                            .foregroundColor(constellation.color.opacity(0.7))
                                            .padding(.top, 3)
                                        Text(fact)
                                            .font(.callout)
                                            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                                            .lineSpacing(3)
                                    }
                                }

                                if allExplored {
                                    Divider().padding(.vertical, 4)
                                    HStack(alignment: .top, spacing: 6) {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundColor(.yellow)
                                        Text("Constellations are patterns of stars as seen from Earth. Stars in a constellation may actually be at very different distances from us. The Pole Star (Dhruv Tara) appears stationary because it is aligned with Earth\u{2019}s rotational axis.")
                                            .font(.callout)
                                            .lineSpacing(3)
                                    }
                                }
                            } else {
                                Label("Constellations", systemImage: "star.fill")
                                    .font(.title2.bold())
                                    .foregroundColor(Color.compatIndigo)
                                Text("Stars form patterns in the night sky called constellations. Ancient people named them and used them for navigation. Tap each constellation card to learn about it!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11 Physics → JEE / Astrophysics",
                        detail: "Constellations are *line-of-sight patterns* — the stars in Orion's Belt are at very different distances from Earth, only looking aligned from here. JEE Astrophysics covers stellar magnitudes (apparent vs absolute brightness), parallax (distance measurement), and Doppler shift (red/blue indicates motion). Hindu astronomy mapped 27 *nakshatras* (lunar mansions) — a different parsing of the same sky."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Stargaze with the Stellarium app",
                        detail: "Install the free Stellarium Mobile app (or Sky Map on Android). Open it on a clear night, point at the sky. The app overlays constellation lines on what you actually see. Find Orion (Dec-Feb, easiest in winter), Saptarishi (Big Dipper, Mar-Aug), and the Pole Star (Polaris — always due North). Free astronomy lesson with your phone as a telescope."
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
    }
}
