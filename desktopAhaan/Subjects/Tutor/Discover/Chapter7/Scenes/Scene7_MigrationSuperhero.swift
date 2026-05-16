import SwiftUI

/// Scene 7 — Migration Superhero.
/// Animated bird migration story. Arctic tern flies from Arctic to Antarctic.
/// Canvas animation of bird path over simplified globe. Also mentions bar-headed geese and Siberian cranes.
@available(macOS 12, *)
struct Scene7_MigrationSuperhero: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var animationPhase: Double = 0
    @State private var selectedFact: Int? = nil
    @State private var exploredFacts: Set<Int> = []
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
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 14) {
                    Text("Migration Superhero")
                        .font(.title2.bold())
                        .padding(.top, 14)

                    // Animated globe with flight path
                    ZStack {
                        if reduceMotion {
                            staticGlobe
                        } else {
                            animatedGlobe
                        }
                    }
                    .frame(maxWidth: 500, maxHeight: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(.gray.opacity(0.3), lineWidth: 1)
                    )

                    // Bird fact buttons
                    HStack(spacing: 12) {
                        ForEach(facts) { fact in
                            let isSelected = selectedFact == fact.id
                            let isExplored = exploredFacts.contains(fact.id)

                            Button {
                                withAnimation(reduceMotion ? .none : .spring()) {
                                    selectedFact = fact.id
                                    exploredFacts.insert(fact.id)
                                }
                            } label: {
                                VStack(spacing: 4) {
                                    Image(systemName: "bird.fill")
                                        .font(.title3)
                                        .foregroundColor(isSelected ? .white : Color.compatIndigo)
                                    Text(fact.bird)
                                        .font(.caption.weight(.semibold))
                                        .foregroundColor(isSelected ? .white : .primary)
                                    Text(fact.stat)
                                        .font(.caption2)
                                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                                }
                                .frame(width: 140, height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(isSelected ? Color.compatIndigo : isExplored ? Color.green.opacity(0.12) : Color(NSColor.windowBackgroundColor))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(isExplored ? .green.opacity(0.4) : .gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(fact.bird). \(fact.stat). \(isExplored ? "Explored" : "Tap to learn more")")
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

                VStack(spacing: 14) {
                    Spacer()

                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let idx = selectedFact, let fact = facts.first(where: { $0.id == idx }) {
                                Label("\(fact.bird)", systemImage: "bird.fill")
                                    .font(.title2.bold())
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(Color.compatIndigo)
                                    Text(fact.route)
                                        .font(.callout.italic())
                                        .foregroundColor(.secondary)
                                }
                                Text(fact.detail)
                                    .font(.body)
                                    .lineSpacing(4)
                            } else {
                                Label("Bird Migration", systemImage: "bird.fill")
                                    .font(.title2.bold())
                                Text("Many birds migrate thousands of kilometres to escape harsh winters and find food. Tap each bird below to learn about the world's most incredible migrations!")
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                    }
                    .frame(maxWidth: 640)

                    if allExplored {
                        GotItButton { onComplete() }
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal, 24)
            }
        }
    }

    // MARK: - Animated globe

    private var animatedGlobe: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30)) { timeline in
            Canvas { context, size in
                var ctx = context
                let t = timeline.date.timeIntervalSince1970

                // Background — ocean
                ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.blue.opacity(0.15)))

                // Simplified continents
                drawContinents(&ctx, size: size)

                // Arctic label
                let arcticText = Text("Arctic").font(.caption2.bold()).foregroundColor(Color.compatCyan)
                ctx.draw(ctx.resolve(arcticText), at: CGPoint(x: size.width * 0.5, y: 18))

                // Antarctic label
                let antText = Text("Antarctic").font(.caption2.bold()).foregroundColor(Color.compatCyan)
                ctx.draw(ctx.resolve(antText), at: CGPoint(x: size.width * 0.5, y: size.height - 14))

                // Flight path — sine wave from top to bottom
                var flightPath = Path()
                let steps = 60
                for i in 0...steps {
                    let frac = CGFloat(i) / CGFloat(steps)
                    let x = size.width * 0.5 + sin(frac * .pi * 3) * size.width * 0.2
                    let y = frac * size.height
                    if i == 0 { flightPath.move(to: CGPoint(x: x, y: y)) }
                    else { flightPath.addLine(to: CGPoint(x: x, y: y)) }
                }
                ctx.stroke(flightPath, with: .color(.orange.opacity(0.4)), style: StrokeStyle(lineWidth: 2, dash: [4, 4]))

                // Bird position
                let phase = (t * 0.3).truncatingRemainder(dividingBy: 1.0)
                let birdFrac = CGFloat(phase)
                let birdX = size.width * 0.5 + sin(birdFrac * .pi * 3) * size.width * 0.2
                let birdY = birdFrac * size.height

                let birdText = Text("V").font(.title3.bold()).foregroundColor(.orange)
                ctx.draw(ctx.resolve(birdText), at: CGPoint(x: birdX, y: birdY))
            }
        }
        .accessibilityLabel("Animated Arctic tern migration path from Arctic to Antarctic")
    }

    private var staticGlobe: some View {
        Canvas { context, size in
            var ctx = context
            ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.blue.opacity(0.15)))
            drawContinents(&ctx, size: size)

            // Static flight path
            var flightPath = Path()
            let steps = 60
            for i in 0...steps {
                let frac = CGFloat(i) / CGFloat(steps)
                let x = size.width * 0.5 + sin(frac * .pi * 3) * size.width * 0.2
                let y = frac * size.height
                if i == 0 { flightPath.move(to: CGPoint(x: x, y: y)) }
                else { flightPath.addLine(to: CGPoint(x: x, y: y)) }
            }
            ctx.stroke(flightPath, with: .color(.orange.opacity(0.5)), style: StrokeStyle(lineWidth: 2, dash: [4, 4]))

            let arcticLabel = Text("Arctic").font(.caption2.bold()).foregroundColor(Color.compatCyan)
            ctx.draw(ctx.resolve(arcticLabel), at: CGPoint(x: size.width * 0.5, y: 18))
            let antLabel = Text("Antarctic").font(.caption2.bold()).foregroundColor(Color.compatCyan)
            ctx.draw(ctx.resolve(antLabel), at: CGPoint(x: size.width * 0.5, y: size.height - 14))
        }
        .accessibilityLabel("Static Arctic tern migration path from Arctic to Antarctic")
    }

    private func drawContinents(_ ctx: inout GraphicsContext, size: CGSize) {
        // Simplified land masses
        let landColor: Color = .green.opacity(0.25)

        // North America
        let na = Path(ellipseIn: CGRect(x: size.width * 0.1, y: size.height * 0.1, width: size.width * 0.25, height: size.height * 0.25))
        ctx.fill(na, with: .color(landColor))

        // Europe/Africa
        let eu = Path(ellipseIn: CGRect(x: size.width * 0.5, y: size.height * 0.05, width: size.width * 0.15, height: size.height * 0.2))
        ctx.fill(eu, with: .color(landColor))
        let af = Path(ellipseIn: CGRect(x: size.width * 0.5, y: size.height * 0.3, width: size.width * 0.18, height: size.height * 0.35))
        ctx.fill(af, with: .color(landColor))

        // South America
        let sa = Path(ellipseIn: CGRect(x: size.width * 0.2, y: size.height * 0.45, width: size.width * 0.15, height: size.height * 0.3))
        ctx.fill(sa, with: .color(landColor))

        // Asia
        let asia = Path(ellipseIn: CGRect(x: size.width * 0.65, y: size.height * 0.1, width: size.width * 0.25, height: size.height * 0.3))
        ctx.fill(asia, with: .color(landColor))
    }
}
