import SwiftUI

/// Scene 3 — Climate Zones Map.
/// Canvas-drawn simplified map with climate zones. Tap each zone for description + example animals.
@available(macOS 12, *)
struct Scene3_ClimateZonesMap: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedZone: Int? = nil
    @State private var exploredZones: Set<Int> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct ClimateZone: Identifiable {
        let id: Int
        let name: String
        let color: Color
        let yRange: ClosedRange<CGFloat>  // fraction of canvas height
        let description: String
        let animals: String
    }

    private let zones: [ClimateZone] = [
        ClimateZone(id: 0, name: "Polar", color: Color.compatCyan.opacity(0.7),
                    yRange: 0.0...0.15,
                    description: "Extremely cold all year. Temperatures drop below -30 C in winter. Snow and ice cover the ground for most of the year.",
                    animals: "Polar bears, Arctic foxes, penguins, snowy owls"),
        ClimateZone(id: 1, name: "Temperate", color: .green.opacity(0.6),
                    yRange: 0.15...0.35,
                    description: "Moderate temperatures with distinct seasons — warm summers and cool winters. Rainfall is spread throughout the year.",
                    animals: "Deer, squirrels, bears, foxes, migratory birds"),
        ClimateZone(id: 2, name: "Desert", color: .yellow.opacity(0.7),
                    yRange: 0.35...0.45,
                    description: "Very hot days, cold nights. Extremely low rainfall — less than 250 mm per year. Sparse vegetation.",
                    animals: "Camels, fennec foxes, kangaroo rats, scorpions"),
        ClimateZone(id: 3, name: "Tropical", color: .orange.opacity(0.6),
                    yRange: 0.45...0.65,
                    description: "Hot and humid all year. Heavy rainfall. Home to the densest forests on Earth — tropical rainforests.",
                    animals: "Toucans, monkeys, tree frogs, lion-tailed macaques"),
        ClimateZone(id: 4, name: "Mediterranean", color: .compatMint.opacity(0.6),
                    yRange: 0.65...0.78,
                    description: "Hot dry summers and mild wet winters. Found near coastlines. Good for growing olives, grapes, and citrus.",
                    animals: "Chameleons, rabbits, hawks, Mediterranean monk seals"),
    ]

    private var allExplored: Bool { exploredZones.count == zones.count }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 12) {
                    Text("Climate Zones of the World")
                        .font(.title2.bold())
                        .padding(.top, 14)

                    HStack(spacing: 8) {
                        ForEach(zones) { zone in
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(zone.color)
                                    .frame(width: 10, height: 10)
                                Text(zone.name)
                                    .font(.caption2.weight(.medium))
                                    .foregroundColor(exploredZones.contains(zone.id) ? .primary : .secondary)
                            }
                        }
                    }

                    // Canvas map
                    Canvas { ctx, size in
                        for zone in zones {
                            let y0 = size.height * zone.yRange.lowerBound
                            let y1 = size.height * zone.yRange.upperBound
                            let rect = CGRect(x: 0, y: y0, width: size.width, height: y1 - y0)
                            let isSelected = selectedZone == zone.id

                            ctx.fill(
                                Path(roundedRect: rect, cornerRadius: 0),
                                with: .color(isSelected ? zone.color.opacity(0.9) : zone.color.opacity(0.5))
                            )

                            // Zone label
                            let text = Text(zone.name)
                                .font(.caption.bold())
                                .foregroundColor(.white)
                            let resolved = ctx.resolve(text)
                            ctx.draw(resolved, at: CGPoint(x: size.width * 0.5, y: (y0 + y1) / 2))
                        }

                        // Equator line
                        let eqY = size.height * 0.55
                        var eqPath = Path()
                        eqPath.move(to: CGPoint(x: 0, y: eqY))
                        eqPath.addLine(to: CGPoint(x: size.width, y: eqY))
                        ctx.stroke(eqPath, with: .color(.red.opacity(0.6)), style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
                    }
                    .frame(maxWidth: 600, maxHeight: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                    )
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                handleTap(at: value.location, canvasHeight: 260)
                            }
                    )

                    // Explored count
                    Text("\(exploredZones.count) / \(zones.count) zones explored")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.secondary)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)

                VStack(spacing: 14) {
                    Spacer()

                    SoftShadowCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            if let idx = selectedZone, let zone = zones.first(where: { $0.id == idx }) {
                                Label(zone.name, systemImage: "globe.americas.fill")
                                    .font(.title2.bold())
                                    .foregroundColor(zone.color)
                                Text(zone.description)
                                    .font(.body)
                                    .lineSpacing(4)
                                Text("Animals: \(zone.animals)")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            } else {
                                Label("Tap a Zone", systemImage: "hand.tap.fill")
                                    .font(.title2.bold())
                                Text("The Earth has different climate zones based on temperature and rainfall. Tap each coloured band on the map to explore!")
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

    private func handleTap(at location: CGPoint, canvasHeight: CGFloat) {
        let fraction = location.y / canvasHeight
        for zone in zones {
            if zone.yRange.contains(fraction) {
                withAnimation(reduceMotion ? .none : .spring()) {
                    selectedZone = zone.id
                    exploredZones.insert(zone.id)
                }
                return
            }
        }
    }
}
