import SwiftUI

// MARK: - DiscoverChapter2View inline scenes (group C)
//
// VilliSurfaceAreaScene + RuminationCycleScene, lifted out of
// DiscoverChapter2View.swift to keep the parent under the 600-LOC Big Sur
// (Swift 5.5) type-checker ceiling — same pattern as +InlineScenesB.swift.
// Standalone closure-driven scenes; `private` dropped to internal so the
// dispatcher can still reference them.

// MARK: - Inline Scene 15: Villi Surface-Area Zoom (Topic 1)
struct VilliSurfaceAreaScene: View {
    let onComplete: () -> Void
    @State private var zoom: Int = 0  // 0 = flat tube, 1 = folds, 2 = villi, 3 = microvilli

    private let captions = [
        "A 6-metre intestine looks like a smooth tube — until you zoom in.",
        "1st zoom: the wall has wide folds, multiplying surface ×3.",
        "2nd zoom: every fold is covered in finger-like villi, ×30.",
        "3rd zoom: every villus has thousands of microvilli, ×600. Total surface ≈ a tennis court."
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Why the Small Intestine Is So Long")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                zoomVisual.frame(width: 280, height: 160)
                Button {
                    withAnimationRespectingReduceMotion(.easeInOut(duration: 0.25)) {
                        zoom = zoom >= 3 ? 0 : zoom + 1
                    }
                } label: {
                    Text(zoom >= 3 ? "Reset" : "Zoom in")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                Text(captions[zoom])
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl).frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    @ViewBuilder
    private var zoomVisual: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14).fill(Color.pink.opacity(0.18))
                .frame(width: 280, height: 160)
            if zoom == 0 {
                Capsule().fill(Color.pink.opacity(0.45)).frame(width: 220, height: 30)
            } else if zoom == 1 {
                HStack(spacing: 6) {
                    ForEach(0..<5, id: \.self) { _ in
                        Capsule().fill(Color.pink.opacity(0.55)).frame(width: 30, height: 60)
                    }
                }
            } else if zoom == 2 {
                HStack(spacing: 3) {
                    ForEach(0..<14, id: \.self) { _ in
                        Capsule().fill(Color.pink.opacity(0.65)).frame(width: 10, height: 80)
                    }
                }
            } else {
                HStack(spacing: 1) {
                    ForEach(0..<40, id: \.self) { _ in
                        Capsule().fill(Color.pink.opacity(0.85)).frame(width: 3, height: 100)
                    }
                }
            }
        }
    }
}

// MARK: - Inline Scene 16: Rumination Cycle (Topic 2)
struct RuminationCycleScene: View {
    let onComplete: () -> Void
    @State private var stage: Int = 0

    private let stages = [
        ("🌿", "1. Cow swallows grass quickly into the rumen — first chamber."),
        ("🫧", "2. Bacteria + rumen churning soften the grass into 'cud'."),
        ("⬆️", "3. Cow brings cud back up to the mouth — chews thoroughly."),
        ("🍽", "4. Re-swallowed; passes through the next 3 chambers for true digestion.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("The Rumination Cycle")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .padding(.top, 18)
                Text(stages[stage].0).font(.system(size: 90))
                Text(stages[stage].1).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignTokens.Spacing.xl).frame(maxWidth: DesignTokens.contentMaxWidth)
                Button {
                    withAnimationRespectingReduceMotion(.easeInOut(duration: 0.25)) {
                        stage = (stage + 1) % stages.count
                    }
                } label: {
                    Text("Next stage")
                        .font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(Color.compatIndigo.opacity(0.15)))
                        .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain).pointingCursor()
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}
