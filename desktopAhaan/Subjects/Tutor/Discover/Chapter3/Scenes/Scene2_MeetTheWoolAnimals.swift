import SwiftUI

/// Scene 2 — Meet the Wool Animals.
///
/// Horizontal carousel of 6 FlipCards with wool animals.
/// Front: emoji + breed name. Back: 3 facts about that animal's wool.
@available(macOS 12, *)
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
