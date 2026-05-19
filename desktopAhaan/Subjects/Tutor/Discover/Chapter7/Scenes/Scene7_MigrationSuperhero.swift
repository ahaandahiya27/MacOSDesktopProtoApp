import SwiftUI

/// Scene 7 — Migration Superhero.
/// Animated bird migration story. Arctic tern flies from Arctic to Antarctic.
/// Simplified globe with flight path. Also mentions bar-headed geese and Siberian cranes.
///
/// Big Sur (macOS 11) compatible — the Canvas + TimelineView based globe is
/// replaced by SwiftUI Shapes (continents + flight path) plus a Timer-driven
/// bird marker.
struct Scene7_MigrationSuperhero: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedFact: Int? = nil
    @State private var exploredFacts: Set<Int> = []
    @State private var tick: TimeInterval = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct MigrationFact: Identifiable {
        let id: Int
        let bird: String
        let route: String
        let stat: String
        let detail: String
    }

    private let facts: [MigrationFact] = [
        MigrationFact(id: 0, bird: "Arctic Tern", route: "Arctic to Antarctic",
                      stat: "70,000 km / year",
                      detail: "The Arctic tern makes the longest migration of any animal — pole to pole and back every year. Over its lifetime it flies the equivalent of three trips to the Moon!"),
        MigrationFact(id: 1, bird: "Bar-headed Goose", route: "Central Asia over Himalayas to India",
                      stat: "Flies at 9,000 m altitude",
                      detail: "Bar-headed geese fly over Mount Everest during migration! Their blood has a special haemoglobin that grabs oxygen efficiently in thin air."),
        MigrationFact(id: 2, bird: "Siberian Crane", route: "Siberia to India",
                      stat: "5,000 km journey",
                      detail: "Siberian cranes travel from frozen Siberia to warm wetlands in India (like Bharatpur) every winter. They are critically endangered with fewer than 4,000 left."),
    ]

    private var allExplored: Bool { exploredFacts.count == facts.count }

    var body: some View {
        // Refactored ZStack-overlap pattern to ScrollView+VStack.

        // Inner GeometryReader is preserved for size-relative

        // interactive content; cards now sit as siblings below it.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                GeometryReader { geo in

                    ZStack {
                VStack(spacing: 14) {
                    Text("Migration Superhero")
                        .font(.title2.bold())
                        .padding(.top, 14)

                    // Globe with flight path
                    globeView
                        .frame(maxWidth: 500, maxHeight: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    // Bird fact buttons
                    HStack(spacing: 12) {
                        ForEach(facts) { fact in
                            factButton(fact: fact)
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

                

                    }

                }

                .frame(height: 320)

                Group {
                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let idx = selectedFact, let fact = facts.first(where: { $0.id == idx }) {
                                Label("\(fact.bird)", systemImage: SFSymbolCompat.name("bird.fill"))
                                    .font(.title2.bold())
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(Color.compatIndigo)
                                    Text(fact.route)
                                        .font(.callout.italic())
                                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                                }
                                Text(fact.detail)
                                    .font(.body)
                                    .lineSpacing(4)
                            } else {
                                Label("Bird Migration", systemImage: SFSymbolCompat.name("bird.fill"))
                                    .font(.title2.bold())
                                Text("Many birds migrate thousands of kilometres to escape harsh winters and find food. Tap each bird below to learn about the world's most incredible migrations!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 11/12 Biology + Physics → NEET / JEE",
                        detail: "Birds navigate using: (1) the Sun's position by day, (2) star patterns by night, (3) Earth's magnetic field via cryptochrome proteins in their eyes. NEET asks the magnetic-sense mechanism — quantum biology, an active research area. Arctic terns fly 70,000 km/year (pole-to-pole-and-back) — the longest migration on Earth. JEE Physics: that's an average speed of ~190 km/day, sustained for months."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Spot a migrant bird in your city",
                        detail: "Indian winter (Nov-Feb) brings migratory birds from Central Asia to wetlands across India. Local hotspots: Bharatpur (Rajasthan), Chilika Lake (Odisha), Sultanpur (Haryana). Even your city's park lake hosts visitors. Look for: bar-headed geese, painted storks, ducks. Each has flown ~3000 km to be there. Same bird returns to same lake every winter — that's genetic GPS in action."
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
        .timedScene(idealFPS: 30, tick: $tick)
    }

    // MARK: - Subviews

    private func factButton(fact: MigrationFact) -> some View {
        let isSelected = selectedFact == fact.id
        let isExplored = exploredFacts.contains(fact.id)
        return Button {
            withAnimation(reduceMotion ? .none : .spring()) {
                selectedFact = fact.id
                exploredFacts.insert(fact.id)
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: SFSymbolCompat.name("bird.fill"))
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : Color.compatIndigo)
                Text(fact.bird)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(isSelected ? .white : .primary)
                Text(fact.stat)
                    .font(.caption2)
                    .foregroundColor(isSelected ? Color.white.opacity(0.8) : .secondary)
            }
            .frame(width: 140, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color.compatIndigo : (isExplored ? Color.green.opacity(0.12) : Color.white))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(isExplored ? Color.green.opacity(0.4) : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(fact.bird). \(fact.stat). \(isExplored ? "Explored" : "Tap to learn more")")
    }

    // MARK: - Globe (Shape-based; Big Sur compatible)

    private var globeView: some View {
        GeometryReader { geo in
            ZStack {
                // Ocean background
                Rectangle()
                    .fill(Color.blue.opacity(0.15))

                // Continents
                ContinentsShape()
                    .fill(Color.green.opacity(0.25))

                // Flight path (dashed)
                FlightPathShape()
                    .stroke(Color.orange.opacity(reduceMotion ? 0.5 : 0.4),
                            style: StrokeStyle(lineWidth: 2, dash: [4, 4]))

                // Pole labels
                Text("Arctic")
                    .font(.caption2.bold())
                    .foregroundColor(Color.compatCyan)
                    .position(x: geo.size.width * 0.5, y: 18)

                Text("Antarctic")
                    .font(.caption2.bold())
                    .foregroundColor(Color.compatCyan)
                    .position(x: geo.size.width * 0.5, y: geo.size.height - 14)

                // Bird marker (Timer-driven; static when reduceMotion)
                BirdMarker(t: tick, reduceMotion: reduceMotion, size: geo.size)
            }
        }
        .accessibilityLabel(reduceMotion
                            ? "Static Arctic tern migration path from Arctic to Antarctic"
                            : "Animated Arctic tern migration path from Arctic to Antarctic")
    }

    // MARK: - Animation lifecycle
}

// MARK: - Shapes

private struct FlightPathShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let steps = 60
        for i in 0...steps {
            let frac = CGFloat(i) / CGFloat(steps)
            let x = rect.width * 0.5 + sin(Double(frac) * .pi * 3) * Double(rect.width) * 0.2
            let y = Double(frac) * Double(rect.height)
            let p = CGPoint(x: CGFloat(x), y: CGFloat(y))
            if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        return path
    }
}

private struct ContinentsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // North America
        path.addEllipse(in: CGRect(x: rect.width * 0.1, y: rect.height * 0.1,
                                   width: rect.width * 0.25, height: rect.height * 0.25))
        // Europe
        path.addEllipse(in: CGRect(x: rect.width * 0.5, y: rect.height * 0.05,
                                   width: rect.width * 0.15, height: rect.height * 0.2))
        // Africa
        path.addEllipse(in: CGRect(x: rect.width * 0.5, y: rect.height * 0.3,
                                   width: rect.width * 0.18, height: rect.height * 0.35))
        // South America
        path.addEllipse(in: CGRect(x: rect.width * 0.2, y: rect.height * 0.45,
                                   width: rect.width * 0.15, height: rect.height * 0.3))
        // Asia
        path.addEllipse(in: CGRect(x: rect.width * 0.65, y: rect.height * 0.1,
                                   width: rect.width * 0.25, height: rect.height * 0.3))
        return path
    }
}

// MARK: - Bird marker subview

private struct BirdMarker: View {
    let t: TimeInterval
    let reduceMotion: Bool
    let size: CGSize

    var body: some View {
        let p = compute()
        return Text("V")
            .font(.title3.bold())
            .foregroundColor(.orange)
            .position(x: CGFloat(p.x), y: CGFloat(p.y))
    }

    private struct MarkerPos { let x: Double; let y: Double }

    private func compute() -> MarkerPos {
        // When reduceMotion, anchor the bird at the start of the path (top pole).
        let frac: Double
        if reduceMotion {
            frac = 0.0
        } else {
            frac = (Double(t) * 0.3).truncatingRemainder(dividingBy: 1.0)
        }
        let x = Double(size.width) * 0.5 + sin(frac * .pi * 3) * Double(size.width) * 0.2
        let y = frac * Double(size.height)
        return MarkerPos(x: x, y: y)
    }
}
