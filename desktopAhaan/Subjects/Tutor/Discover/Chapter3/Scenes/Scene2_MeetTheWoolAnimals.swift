import SwiftUI

/// Scene 2 — Meet the Wool Animals.
///
/// Horizontal carousel of 6 FlipCards with wool animals.
/// Front: emoji + breed name. Back: 3 facts about that animal's wool.

struct Scene2_MeetTheWoolAnimals: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var scrollOffset: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let animals = [
        WoolAnimal(
            emoji: "🐑",
            name: "Merino Sheep",
            facts: ["Produces the finest wool", "Fibres are 17-20 microns", "Soft as silk"]
        ),
        WoolAnimal(
            emoji: "🐐",
            name: "Cashmere Goat",
            facts: ["Produces luxurious cashmere", "Wool is warmer than sheep", "Extremely rare and expensive"]
        ),
        WoolAnimal(
            emoji: "🐃",
            name: "Yak",
            facts: ["Lives in high mountains", "Wool is water-resistant", "Perfect for Himalayan cold"]
        ),
        WoolAnimal(
            emoji: "🐪",
            name: "Camel",
            facts: ["Produces camel hair", "Light but warm fabric", "Used in desert clothing"]
        ),
        WoolAnimal(
            emoji: "🦙",
            name: "Llama",
            facts: ["Fibre is silky and strong", "Hypoallergenic wool", "From South American mountains"]
        ),
        WoolAnimal(
            emoji: "🐰",
            name: "Angora Rabbit",
            facts: ["Produces fluffy angora wool", "Finest animal fibre", "One rabbit yields 200g yearly"]
        )
    ]

    var body: some View {
        VStack(spacing: 18) {
            Text("Meet the Wool Animals")
                .font(.largeTitle.bold())
                .foregroundColor(Color.compatIndigo)
                .padding(.top, 20)

            Text("Tap any card to flip and learn!")
                .font(.callout)
                .foregroundColor(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(animals, id: \.name) { animal in
                        FlipCard(
                            frontEmoji: animal.emoji,
                            frontTitle: animal.name,
                            frontSubtitle: "Wool Source",
                            back: {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(animal.facts, id: \.self) { fact in
                                        HStack(spacing: 8) {
                                            Circle()
                                                .fill(Color.compatIndigo)
                                                .frame(width: 6, height: 6)
                                            Text(fact)
                                                .font(.caption)
                                                .lineLimit(2)
                                        }
                                    }
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .background(LinearGradient(
                                    colors: [.yellow.opacity(0.15), .orange.opacity(0.15)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                ))
                                .cornerRadius(12)
                            }
                        )
                        .frame(width: 200, height: 220)
                    }
                }
                .padding(.horizontal, 24)
            }

            Spacer()

            SoftShadowCard(padding: 14) {
                Label("Tap any animal to learn its wool secrets", systemImage: "info.circle.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: 600)
            .padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Biology → NEET",
                detail: "Different climates produced different wool textures — sheep at altitude grow thicker undercoats. NEET tests this as 'adaptive radiation' in Class 11 Evolution: same ancestor, multiple niches, multiple morphologies. The Pashmina goat (Chyangra) in Ladakh has the finest wool because cold + thin air = densest insulation needed."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Feel the difference",
                detail: "Find a Pashmina shawl, a Merino sweater, and a generic acrylic sweater (or compare labels at a clothing store). Pashmina feels almost weightless and warm; Merino feels soft and slightly springy; acrylic feels plasticky and conducts cold faster. Same job (insulation), three engineering grades — your fingers can tell the polymer apart."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton {
                onComplete()
            }
            .padding(.bottom, 20)
        }
    }
}

private struct WoolAnimal {
    let emoji: String
    let name: String
    let facts: [String]
}
