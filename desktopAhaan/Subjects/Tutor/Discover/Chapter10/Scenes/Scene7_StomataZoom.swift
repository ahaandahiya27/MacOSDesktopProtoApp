import SwiftUI

/// Scene 7 — Plant Stomata Zoom. Slider zooms from full leaf to a single stoma.
struct Scene7_StomataZoom: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var zoom: Double = 0

    private var stage: String {
        switch zoom {
        case ..<0.34: return "Full leaf"
        case ..<0.67: return "Leaf surface"
        default:      return "One stoma"
        }
    }
    private var emoji: String {
        switch zoom {
        case ..<0.34: return "🍃"
        case ..<0.67: return "🌿"
        default:      return "👄"
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Plant Stomata Zoom").font(.largeTitle.bold()).padding(.top, 18)
            Text("Zoom in. Find the tiny mouths leaves use to breathe.")
                .font(.callout).foregroundColor(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(Color.green.opacity(0.18))
                    .frame(width: 320, height: 280)
                VStack(spacing: 8) {
                    Text(emoji).font(.system(size: 100 + CGFloat(zoom * 50)))
                    Text(stage).font(.headline).foregroundColor(Color.compatIndigo)
                }
            }

            Slider(value: $zoom, in: 0...1).frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Stomata: tiny breathing pores", systemImage: "leaf.fill")
                        .font(.title2.bold())
                    Text("The underside of a leaf has thousands of stomata. Each is a kidney-shaped opening guarded by two cells. CO₂ enters, O₂ and water vapour leave. Plants close them when they need to save water.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
