import SwiftUI

/// Scene 7 — Soak-Pit Design. Adjust depth + gravel; success bar fills.
struct Scene7_SoakPitDesign: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    @State private var depth: Double = 1.5
    @State private var gravel: Bool = false
    @State private var distance: Double = 10

    private var quality: Double {
        var q = (depth - 1) / 2 * 0.5
        if gravel { q += 0.3 }
        q += (distance - 5) / 25 * 0.2
        return min(max(q, 0), 1)
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Soak-Pit Design").font(.largeTitle.bold()).padding(.top, 18)
            Text("Design a soak-pit. Get the quality bar to green.")
                .font(.callout).foregroundColor(.secondary)

            ProgressView(value: quality).progressViewStyle(.linear).accentColor(.green)
                .frame(width: 320)
            Text("Design score: \(Int(quality * 100))%").font(.headline).foregroundColor(.green)

            VStack {
                HStack { Text("Depth: \(String(format: "%.1f", depth)) m"); Spacer(); Slider(value: $depth, in: 1...3, step: 0.1).frame(width: 200) }
                Toggle("Layer with gravel & sand", isOn: $gravel)
                HStack { Text("Distance from well: \(Int(distance)) m"); Spacer(); Slider(value: $distance, in: 5...30, step: 1).frame(width: 200) }
            }
            .frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 14) {
                Text("A soak-pit lets greywater (bath/wash water) seep through gravel and sand into the ground, where soil filters it. Keep it at least 15 m from drinking wells to avoid contamination.")
                    .font(.callout).lineSpacing(4)
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
