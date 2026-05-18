import SwiftUI

/// Scene 5 — Lens Workshop. Convex magnifies, concave shrinks.
struct Scene5_LensWorkshop: View {
    let pack: SubjectPack
    let chapter: Chapter
    let onComplete: () -> Void

    enum Lens: String, CaseIterable, Identifiable {
        case convex = "Convex (converging)", concave = "Concave (diverging)"
        var id: String { rawValue }
    }
    @State private var lens: Lens = .convex
    @State private var distance: Double = 20

    private var imageType: String {
        if lens == .concave { return "Smaller, upright, virtual" }
        return distance < 12 ? "Magnified, upright (magnifying glass!)"
                              : "Smaller, inverted, real (camera/projector)"
    }

    var body: some View {
        VStack(spacing: 14) {
            Text("Lens Workshop").font(.largeTitle.bold()).foregroundColor(ChapterTheme.accent(for: chapter.id)).padding(.top, 18)
            Text("A lens bends light to form an image. Pick a lens, move the object.")
                .font(.callout).foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)

            Picker("", selection: $lens) {
                ForEach(Lens.allCases) { Text($0.rawValue).tag($0) }
            }.pickerStyle(.segmented).frame(maxWidth: 420)

            HStack(spacing: 12) {
                Text("📕").font(.system(size: 40))
                Text(lens == .convex ? "🔍" : "🔎").font(.system(size: 56))
                Text(imageType.contains("inverted") ? "📕"  : "📕")
                    .font(.system(size: imageType.contains("Magnified") ? 80 : 28))
                    .rotationEffect(.degrees(imageType.contains("inverted") ? 180 : 0))
            }

            Text("Object distance: \(Int(distance)) cm").font(.headline)
            Slider(value: $distance, in: 4...40, step: 1).frame(maxWidth: 460).padding(.horizontal, 24)

            SoftShadowCard(padding: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Image: \(imageType)").font(.title3.bold())
                    Text(lens == .convex
                         ? "A convex lens converges parallel rays to a focus. Camera, microscope, magnifying glass, even the lens in your eye — all convex."
                         : "A concave lens spreads rays apart. Used in spectacles for short-sightedness and in peepholes.")
                        .font(.body).lineSpacing(4)
                }
            }
            .frame(maxWidth: DesignTokens.contentMaxWidth).padding(.horizontal, 24)

            // Grouped so the outer VStack stays within Swift 5.5's
            // 10-child ViewBuilder limit (Xcode 13.2.1 / Big Sur target).
            Group {
                LookingAheadCallout(
                    title: "Class 10 / JEE / NEET Optics",
                    detail: "Lenses get the same formula treatment: 1/v - 1/u = 1/f (sign convention matters!), plus power P = 1/f (dioptres) in Class 10. JEE adds lensmaker's equation; NEET tests the eye + corrective lenses (myopia, hypermetropia)."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)

                TryAtHomeCallout(
                    title: "Magnifying-glass eyeglass",
                    detail: "If you wear reading glasses (or borrow), hold one lens between a bright window and a piece of paper. Slide it until you see a TINY, inverted image of the window on the paper — a real image. Move the same lens close to text and see the magnified, upright (virtual) image."
                )
                .frame(maxWidth: DesignTokens.contentMaxWidth)
                .padding(.horizontal, 24)
            }

            GotItButton { onComplete() }.padding(.bottom, 12)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
