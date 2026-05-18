import SwiftUI

/// Scene 1 — Soil Profile Dig. Tap each horizon to learn what's there.
struct Scene1_SoilProfileDig: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    struct Horizon: Identifiable {
        let id = UUID()
        let code: String
        let name: String
        let color: Color
        let blurb: String
    }

    private let horizons: [Horizon] = [
        Horizon(code: "O", name: "Organic layer", color: Color(red: 0.30, green: 0.20, blue: 0.10),
                blurb: "Top layer: dead leaves, twigs and humus. Rich in nutrients."),
        Horizon(code: "A", name: "Topsoil", color: Color(red: 0.45, green: 0.30, blue: 0.15),
                blurb: "Dark, soft, full of roots and worms. Where most plants grow."),
        Horizon(code: "B", name: "Subsoil", color: Color(red: 0.60, green: 0.42, blue: 0.20),
                blurb: "Lighter brown. Stores minerals washed down by water."),
        Horizon(code: "C", name: "Weathered rock", color: Color(red: 0.55, green: 0.45, blue: 0.40),
                blurb: "Broken rocks slowly turning into soil over centuries."),
        Horizon(code: "R", name: "Bedrock", color: Color(red: 0.35, green: 0.35, blue: 0.35),
                blurb: "Solid rock underneath everything."),
    ]
    @State private var selected: UUID?

    var body: some View {
        VStack(spacing: 12) {
            Text("Soil Profile Dig").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
            Text("Tap a layer to learn what lives there.").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            HStack(alignment: .top, spacing: 24) {
                VStack(spacing: 0) {
                    ForEach(horizons) { h in
                        Button { selected = h.id } label: {
                            HStack {
                                Text(h.code).font(.title.bold()).frame(width: 36)
                                Text(h.name).font(.headline)
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 56)
                            .background(h.color.opacity(0.85))
                            .foregroundColor(.white)
                            .overlay(Rectangle().strokeBorder(selected == h.id ? Color.compatIndigo : .clear, lineWidth: 3))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(width: 280)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                if let s = horizons.first(where: { $0.id == selected }) {
                    SoftShadowCard(padding: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(s.code) — \(s.name)").font(.title3.bold())
                            Text(s.blurb).font(.body).lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: 320)
                } else {
                    Text("← Tap a horizon").font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).padding(.top, 20)
                }
            }

            LookingAheadCallout(
                title: "Class 9 Geography",
                detail: "Class 9 Geography studies Indian soil types in detail: alluvial (Indo-Gangetic plain), black (Deccan plateau — perfect for cotton), red (Tamil Nadu, Karnataka), laterite (Western Ghats), and arid (Rajasthan). Each one is the end of a different combination of parent rock, climate and biology working over thousands of years."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            TryAtHomeCallout(
                title: "Dig a shoebox-deep pit",
                detail: "With permission, dig a foot-deep hole in a garden. Notice the colours change with depth — dark on top, lighter below, then small stones. You've just seen O → A → B horizons."
            )
            .frame(maxWidth: DesignTokens.contentMaxWidth)
            .padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.top, 8).padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
