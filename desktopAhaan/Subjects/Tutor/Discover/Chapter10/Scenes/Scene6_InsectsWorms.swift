import SwiftUI

/// Scene 6 — How Insects & Worms Breathe. Tap each creature to learn its trick.
struct Scene6_InsectsWorms: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Creature: String, CaseIterable, Identifiable {
        case cockroach = "Cockroach"
        case earthworm = "Earthworm"
        case frog = "Frog"
        var id: String { rawValue }
        var emoji: String {
            switch self { case .cockroach: return "🪳"; case .earthworm: return "🪱"; case .frog: return "🐸" }
        }
        var organ: String {
            switch self {
            case .cockroach: return "Tracheae through spiracles — tiny tubes carry air directly to cells."
            case .earthworm: return "Moist skin — oxygen dissolves and diffuses straight into the blood."
            case .frog:      return "Lungs on land, moist skin in water — switches between both!"
            }
        }
    }

    @State private var pick: Creature = .cockroach

    var body: some View {
        VStack(spacing: 14) {
            Text("How Insects & Worms Breathe").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Each species solved \"how to get oxygen\" differently.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            Picker("", selection: $pick) {
                ForEach(Creature.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented).discoverControlChrome().frame(maxWidth: 380)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.green.opacity(0.10))
                    .frame(width: 320, height: 220)
                VStack(spacing: 6) {
                    Text(pick.emoji).font(.system(size: 80))
                    Text(pick.rawValue).font(.title3.bold())
                }
            }

            SoftShadowCard(padding: 18) {
                Text(pick.organ).font(.body).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Bio → NEET",
                detail: "Class 11 'Structural Organisation in Animals' covers respiration across taxa in detail — book-lungs of arachnids, tracheal tubes of insects, gills of fish, lungs of amphibians/reptiles/mammals. Comparison-of-respiration questions are a NEET staple."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Ant-trail observation",
                detail: "Find an ant trail near your kitchen or garden. Ants don't have lungs — they breathe through tracheal tubes opening at spiracles along their bodies. The little hairy bumps on their sides are those openings."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
