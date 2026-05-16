import SwiftUI

/// Scene 6 — Meet the Special Plants. A horizontal row of FlipCards with the
/// four special-nutrition plants (Cuscuta / Pitcher / Bread mould / Lichen).

struct Scene6_MeetTheSpecialPlants: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Text("Meet the Special Plants")
                .font(.largeTitle.bold())
                .padding(.top, 18)
            Text("Some plants don't make their own food. Tap each card to flip and meet them.")
                .font(.callout)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    FlipCard(
                        frontEmoji: "🌿",
                        frontTitle: "Cuscuta",
                        frontSubtitle: "the orange thread parasite"
                    ) {
                        bulletList(for: "ch01_t02_c01", fallback: [
                            "A leafless yellow-orange vine that wraps around host plants.",
                            "Has no chlorophyll, so it can't make its own food.",
                            "Sucks sap from the host using haustoria — a parasite."
                        ])
                    }

                    FlipCard(
                        frontEmoji: "🍶",
                        frontTitle: "Pitcher Plant",
                        frontSubtitle: "the bug-eating cup"
                    ) {
                        bulletList(for: "ch01_t02_c02", fallback: [
                            "Grows in nitrogen-poor soil, so it traps insects to get N.",
                            "Modified leaves form a slippery jug filled with digestive juice.",
                            "An insectivorous plant — still does photosynthesis too."
                        ])
                    }

                    FlipCard(
                        frontEmoji: "🍄",
                        frontTitle: "Bread Mould",
                        frontSubtitle: "the dead-leaf eater"
                    ) {
                        bulletList(for: "ch01_t02_c03", fallback: [
                            "A fungus that grows on stale bread, fruit, or rotting matter.",
                            "Releases enzymes onto food, then absorbs the digested goo.",
                            "A saprotroph — feeds on dead organic matter."
                        ])
                    }

                    FlipCard(
                        frontEmoji: "🌳",
                        frontTitle: "Lichen",
                        frontSubtitle: "the partnership"
                    ) {
                        bulletList(for: "ch01_t02_c04", fallback: [
                            "An alga + a fungus living together as one body.",
                            "The alga makes food via photosynthesis; the fungus gives shelter and water.",
                            "A symbiotic relationship — both partners benefit."
                        ])
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
            }
            .frame(maxWidth: .infinity)

            GotItButton(action: onComplete)
                .padding(.bottom, 12)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Renders 3 bullet points for a concept. Tries kidFriendly first; if it's
    /// a single sentence, splits on full stops to create 3 bullets. If the
    /// concept isn't found, falls back to the supplied static list.
    @ViewBuilder
    private func bulletList(for conceptId: String, fallback: [String]) -> some View {
        let bullets: [String] = {
            if let concept = pack.conceptIndex[conceptId] {
                let kid = concept.explanation(at: .kidFriendly)
                let pieces = kid.components(separatedBy: ". ")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                if pieces.count >= 3 { return Array(pieces.prefix(3)).map { "\($0)." } }
                if pieces.count >= 1 {
                    var out = pieces.map { "\($0)." }
                    while out.count < 3 { out.append(fallback[out.count]) }
                    return out
                }
            }
            return fallback
        }()

        VStack(alignment: .leading, spacing: 8) {
            ForEach(bullets, id: \.self) { b in
                HStack(alignment: .top, spacing: 6) {
                    Text("•").foregroundColor(.green)
                    Text(b).fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
