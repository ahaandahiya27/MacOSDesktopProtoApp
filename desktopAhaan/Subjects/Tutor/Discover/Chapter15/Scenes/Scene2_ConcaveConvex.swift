import SwiftUI

/// Scene 2 — Concave vs Convex Mirrors. Toggle which mirror; image flips and resizes.
struct Scene2_ConcaveConvex: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Mirror: String, CaseIterable, Identifiable {
        case plane = "Plane", concave = "Concave", convex = "Convex"
        var id: String { rawValue }
    }
    @State private var m: Mirror = .plane
    @State private var distance: Double = 30

    private var imageDescription: String {
        switch m {
        case .plane:   return "Same size, upright, virtual"
        case .concave: return distance < 25 ? "Larger, upright (close-up)" : "Smaller, upside-down (far away)"
        case .convex:  return "Smaller, upright, always virtual"
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Concave & Convex Mirrors").font(.largeTitle.bold()).padding(.top, 18)
            Text("Curved mirrors stretch, shrink and even flip the image.")
                .font(.callout).foregroundColor(.secondary)

            Picker("", selection: $m) {
                ForEach(Mirror.allCases) { Text($0.rawValue).tag($0) }
            }.pickerStyle(.segmented).frame(maxWidth: 320)

            HStack(spacing: 30) {
                Text("🙂").font(.system(size: 64))
                Text("│").font(.system(size: 64)).foregroundColor(.compatIndigo)
                Text(m == .concave && distance >= 25 ? "🙃" : "🙂")
                    .font(.system(size: m == .convex ? 36 : (m == .concave && distance < 25 ? 90 : 56)))
            }

            Text("Object distance: \(Int(distance)) cm")
                .font(.headline).foregroundColor(.secondary)
            Slider(value: $distance, in: 5...60, step: 1).frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(m.rawValue + " mirror").font(.title3.bold())
                    Text("Image: \(imageDescription)").font(.body)
                    Text(m == .convex
                         ? "Used in vehicle side-mirrors (wider view) and shop security."
                         : m == .concave
                            ? "Used in shaving mirrors (close-up, magnified) and torches/headlights (focus the beam)."
                            : "Everyday flat mirrors — equal size, equal distance behind.")
                        .font(.callout).foregroundColor(.secondary).lineSpacing(3)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
