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
        // Wrapped in ScrollView so the scene scrolls on
        // shorter windows and overflowing content remains accessible.
        ScrollView {
            LazyVStack(alignment: .center, spacing: 14) {
                Text("Concave & Convex Mirrors").font(.largeTitle.bold()).foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Curved mirrors stretch, shrink and even flip the image.")
                    .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

                Picker("", selection: $m) {
                    ForEach(Mirror.allCases) { Text($0.rawValue).tag($0) }
                }.pickerStyle(.segmented).discoverControlChrome().frame(maxWidth: 320)

                HStack(spacing: 30) {
                    Text("🙂").font(.system(size: 64))
                    Text("│").font(.system(size: 64)).foregroundColor(.compatIndigo)
                    Text(m == .concave && distance >= 25 ? "🙃" : "🙂")
                        .font(.system(size: m == .convex ? 36 : (m == .concave && distance < 25 ? 90 : 56)))
                }

                Text("Object distance: \(Int(distance)) cm")
                    .font(.headline).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                Slider(value: $distance, in: 5...60, step: 1).frame(maxWidth: 460).padding(.horizontal, DesignTokens.Spacing.xl)

                SoftShadowCard(padding: 18) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        Text(m.rawValue + " mirror").font(.title3.bold())
                        Text("Image: \(imageDescription)").font(.body)
                        Text(m == .convex
                             ? "Used in vehicle side-mirrors (wider view) and shop security."
                             : m == .concave
                                ? "Used in shaving mirrors (close-up, magnified) and torches/headlights (focus the beam)."
                                : "Everyday flat mirrors — equal size, equal distance behind.")
                            .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary).lineSpacing(3)
                    }
                }
                .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, DesignTokens.Spacing.xl)

                // Grouped so the outer VStack stays within Swift 5.5's
                // 10-child ViewBuilder limit (Xcode 13.2.1 / Big Sur target).
                Group {
                    TryAtHomeCallout(
                        title: "The polished spoon test",
                        detail: "Look at your face in the inside (concave) of a polished steel spoon held close — you look magnified, upright. Now slowly move it away — your reflection shrinks, blurs, then flips upside down. You just crossed the focal point. Flip the spoon: the back (convex) always shows you smaller and upright, no matter the distance."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)

                    LookingAheadCallout(
                        title: "Class 10 / JEE Optics",
                        detail: "Class 10 formalises this with the mirror formula 1/v + 1/u = 1/f (sign convention matters!) and magnification m = -v/u. JEE adds image construction with 3 principal rays, sign-convention problems on combined mirror-lens systems, and ray-tracing in spherical concave mirrors used inside telescopes."
                    )
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                }

                GotItButton { onComplete() }.padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
