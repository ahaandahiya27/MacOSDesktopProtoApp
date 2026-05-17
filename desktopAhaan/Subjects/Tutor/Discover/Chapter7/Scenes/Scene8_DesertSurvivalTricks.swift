import SwiftUI

/// Scene 8 — Desert Survival Tricks.
/// Three desert animals side by side. Tap each for adaptations.
/// Big Sur (macOS 11) compatible — sand dunes drawn via DesertDunesShape
/// instead of a SwiftUI Canvas. .brown swapped for Color.compatBrown.
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
        DesertAnimal(id: 0, name: "Camel", symbol: SFSymbolCompat.name("hare.fill"), color: Color.compatBrown,
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
                            colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.2), Color.compatBrown.opacity(0.15)],
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        // Sun
                        Circle()
                            .fill(Color.yellow.opacity(0.5))
                            .frame(width: 50, height: 50)
                            .offset(x: 180, y: -60)

                        // Sand dunes (Shape, was Canvas)
                        DesertDunesShape()
                            .fill(Color.compatBrown.opacity(0.25))
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
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    LookingAheadCallout(
                        title: "Class 12 Biology → NEET (Xerophytic Adaptations)",
                        detail: "Desert organisms each solve one problem: water loss. Camel hump = fat storage (NOT water — common misconception NEET loves). Cactus = reduced leaves (no transpiration) + thick water-storing stem + waxy cuticle (reflects light). Kangaroo rat = metabolises hydrogen in its food into water (literally manufactures H₂O from its diet, the way bears manufacture vitamins). Three engineering solutions to one constraint."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

                    TryAtHomeCallout(
                        title: "Build a solar still — desert water-maker",
                        detail: "Dig a small pit. Place a glass at the centre. Drop fresh green leaves around it (NOT IN the glass). Cover the pit with cling film. Put a small stone on top of the cling film, directly above the glass. Leave in sunlight for 2 hours. Water evaporates from the leaves, condenses on the cling film, runs down to the dip, drips into the glass. You've extracted water from leaves — a survival technique used in actual deserts."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)

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

/// Sand-dune silhouette across the bottom of the desert backdrop.
/// Pulled out of the old `Canvas { ... }` so it renders on macOS 11.
struct DesertDunesShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var p = Path()
        p.move(to: CGPoint(x: 0, y: h * 0.7))
        p.addQuadCurve(
            to: CGPoint(x: w * 0.4, y: h * 0.6),
            control: CGPoint(x: w * 0.2, y: h * 0.5)
        )
        p.addQuadCurve(
            to: CGPoint(x: w * 0.8, y: h * 0.65),
            control: CGPoint(x: w * 0.6, y: h * 0.75)
        )
        p.addQuadCurve(
            to: CGPoint(x: w, y: h * 0.6),
            control: CGPoint(x: w * 0.9, y: h * 0.55)
        )
        p.addLine(to: CGPoint(x: w, y: h))
        p.addLine(to: CGPoint(x: 0, y: h))
        p.closeSubpath()
        return p
    }
}
