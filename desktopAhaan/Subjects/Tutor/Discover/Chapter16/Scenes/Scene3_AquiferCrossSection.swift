import SwiftUI

/// Scene 3 — Aquifer Cross-Section. Tap each layer to learn its role.
struct Scene3_AquiferCrossSection: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Layer: String, CaseIterable, Identifiable {
        case surface = "Surface", aerated = "Aerated zone", saturated = "Saturated zone (Aquifer)", rock = "Bedrock"
        var id: String { rawValue }
        var color: Color {
            switch self { case .surface: return .green; case .aerated: return Color.compatBrown; case .saturated: return .blue; case .rock: return .gray }
        }
        var blurb: String {
            switch self {
            case .surface:   return "Plants, soil and surface streams. Rain lands here."
            case .aerated:   return "Loose soil with air gaps. Water moves down through it."
            case .saturated: return "All pores are full of water. This is the aquifer — what wells tap."
            case .rock:      return "Solid rock below — water can't pass through it."
            }
        }
    }

    @State private var pick: Layer = .saturated

    var body: some View {
        VStack(spacing: 14) {
            Text("Aquifer Cross-Section").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Tap a layer to learn what's underground.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            VStack(spacing: 2) {
                ForEach(Layer.allCases) { l in
                    Button { pick = l } label: {
                        HStack { Text(l.rawValue).foregroundColor(.white); Spacer() }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(l.color.opacity(0.85))
                            .overlay(Rectangle().strokeBorder(pick == l ? Color.compatIndigo : .clear, lineWidth: 3))
                    }
                    .buttonStyle(.plain)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))

            SoftShadowCard(padding: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(pick.rawValue).font(.title3.bold())
                    Text(pick.blurb).font(.body)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            LookingAheadCallout(
                title: "Class 11 Geography",
                detail: "Class 11 Geography 'Water in the Atmosphere and Hydrosphere' covers aquifer types (confined, unconfined, perched), recharge zones, and the world's major aquifer systems (Ganga-Brahmaputra, Ogallala). Connects to environmental science in Class 12."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Layered jar aquifer",
                detail: "Fill a clear jar with alternating layers: pebbles, sand, soil, more pebbles. Slowly pour water on top. Watch it travel down through each layer at different speeds — you've just modeled how groundwater seeps through an aquifer."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
