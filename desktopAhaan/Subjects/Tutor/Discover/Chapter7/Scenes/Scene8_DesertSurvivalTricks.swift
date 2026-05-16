import SwiftUI

/// Scene 8 — Desert Survival Tricks.
/// Three desert animals side by side. Tap each for adaptations.
@available(macOS 12, *)
struct Scene8_DesertSurvivalTricks: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var selectedAnimal: Int? = nil
    @State private var exploredAnimals: Set<Int> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct DesertAnimal: Identifiable {
        let id: Int
        let name: String
        let symbol: String
        let color: Color
        let adaptations: [(title: String, detail: String)]
    }

    private let animals: [DesertAnimal] = [
        DesertAnimal(id: 0, name: "Camel", symbol: "hare.fill", color: .brown,
                     adaptations: [
                        (title: "Hump", detail: "The hump stores fat (not water!) which is broken down for energy and metabolic water when food is scarce."),
                        (title: "Minimal Sweating", detail: "Camels can tolerate body temperature rising to 42 C before sweating, conserving precious water."),
                        (title: "Drinks 100 Litres", detail: "When water is available, a camel can drink up to 100 litres in just 10 minutes and store it for days."),
                     ]),
        DesertAnimal(id: 1, name: "Fennec Fox", symbol: "pawprint.fill", color: .orange,
                     adaptations: [
                        (title: "Huge Ears", detail: "Enormous ears act as radiators — blood flowing through thin ear skin releases heat to the air, keeping the fox cool."),
                        (title: "Nocturnal", detail: "Fennec foxes are active at night when the desert is cool and rest in underground burrows during the scorching day."),
                        (title: "Fur-covered Paws", detail: "Thick fur on the soles of their feet protects against hot sand and provides traction on loose dunes."),
                     ]),
        DesertAnimal(id: 2, name: "Kangaroo Rat", symbol: "leaf.fill", color: Color.compatTeal,
                     adaptations: [
                        (title: "No Water Needed", detail: "Kangaroo rats never need to drink water! They get all moisture from metabolic water produced when digesting dry seeds."),
                        (title: "Nocturnal", detail: "They stay in cool underground burrows all day and only come out at night to forage, avoiding the blazing sun."),
                        (title: "Concentrated Urine", detail: "Their kidneys are super-efficient, producing extremely concentrated urine to lose as little water as possible."),
                     ]),
    ]

    private var allExplored: Bool { exploredAnimals.count == animals.count }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack(spacing: 14) {
                    Text("Desert Survival Tricks")
                        .font(.title2.bold())
                        .padding(.top, 14)

                    Text("\(exploredAnimals.count) / \(animals.count) animals explored")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.secondary)

                    // Desert background with animals
                    ZStack {
                        // Desert gradient
                        LinearGradient(
                            colors: [.yellow.opacity(0.3), .orange.opacity(0.2), .brown.opacity(0.15)],
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        // Sun
                        Circle()
                            .fill(.yellow.opacity(0.5))
                            .frame(width: 50, height: 50)
                            .offset(x: 180, y: -60)

                        // Sand dunes (simplified)
                        Canvas { ctx, size in
                            var dunePath = Path()
                            dunePath.move(to: CGPoint(x: 0, y: size.height * 0.7))
                            dunePath.addQuadCurve(
                                to: CGPoint(x: size.width * 0.4, y: size.height * 0.6),
                                control: CGPoint(x: size.width * 0.2, y: size.height * 0.5)
                            )
                            dunePath.addQuadCurve(
                                to: CGPoint(x: size.width * 0.8, y: size.height * 0.65),
                                control: CGPoint(x: size.width * 0.6, y: size.height * 0.75)
                            )
                            dunePath.addQuadCurve(
                                to: CGPoint(x: size.width, y: size.height * 0.6),
                                control: CGPoint(x: size.width * 0.9, y: size.height * 0.55)
                            )
                            dunePath.addLine(to: CGPoint(x: size.width, y: size.height))
                            dunePath.addLine(to: CGPoint(x: 0, y: size.height))
                            dunePath.closeSubpath()
                            ctx.fill(dunePath, with: .color(.brown.opacity(0.25)))
                        }
                        .allowsHitTesting(false)
                    }
                    .frame(maxWidth: 500, maxHeight: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(.gray.opacity(0.2), lineWidth: 1)
                    )

                    // Animal cards
                    HStack(spacing: 16) {
                        ForEach(animals) { animal in
                            let isSelected = selectedAnimal == animal.id
                            let isExplored = exploredAnimals.contains(animal.id)

                            Button {
                                withAnimation(reduceMotion ? .none : .spring()) {
                                    selectedAnimal = animal.id
                                    exploredAnimals.insert(animal.id)
                                }
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: animal.symbol)
                                        .font(.title)
                                        .foregroundColor(isSelected ? .white : animal.color)
                                    Text(animal.name)
                                        .font(.body.weight(.semibold))
                                        .foregroundColor(isSelected ? .white : .primary)
                                    if isExplored {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.caption)
                                            .foregroundColor(isSelected ? .white : .green)
                                    }
                                }
                                .frame(width: 130, height: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(isSelected ? animal.color : Color(NSColor.windowBackgroundColor))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .strokeBorder(isExplored ? .green.opacity(0.4) : .gray.opacity(0.2), lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(animal.name). \(isExplored ? "Explored" : "Tap to explore")")
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
                            if let idx = selectedAnimal, let animal = animals.first(where: { $0.id == idx }) {
                                Label(animal.name, systemImage: animal.symbol)
                                    .font(.title2.bold())
                                    .foregroundColor(animal.color)

                                ForEach(animal.adaptations, id: \.title) { adapt in
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(adapt.title)
                                            .font(.body.bold())
                                        Text(adapt.detail)
                                            .font(.callout)
                                            .foregroundColor(.secondary)
                                            .lineSpacing(3)
                                    }
                                    .padding(.top, 2)
                                }
                            } else {
                                Label("Desert Survival", systemImage: "sun.max.fill")
                                    .font(.title2.bold())
                                    .foregroundColor(.orange)
                                Text("Deserts are harsh — scorching days, freezing nights, almost no water. Yet amazing animals thrive here using clever adaptations. Tap each animal to discover their survival tricks!")
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
}
