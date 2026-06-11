import SwiftUI

// Inline scenes 18 + 19 lifted from `DiscoverChapter4View.swift`
// 2026-05-26 to bring the parent under the 600-LOC Big Sur
// ceiling. Same private-internal-to-Ch.4 scope as the other
// scene structs in the parent — they're only referenced from
// `DiscoverChapter4View`'s inline dispatcher.
//
// (Naming convention: "+InlineScenesB" mirrors the "+InlineScenes"
//  seam already used by DiscoverChapter1View. If a future split
//  lifts scenes 17 or 16, name them "+InlineScenesA" / "+InlineScenesC"
//  to preserve the implicit ordering.)

// MARK: - Inline Scene 18: States of Matter Heat Ladder (slider)
struct StatesOfMatterHeatLadderScene: View {
    let onComplete: () -> Void
    @State private var temp: Double = 25

    private var state: String {
        if temp < 0 { return "Ice (solid) — molecules vibrate in fixed places." }
        if temp < 100 { return "Water (liquid) — molecules slide past each other." }
        return "Steam (gas) — molecules fly apart freely."
    }
    private var emoji: String {
        if temp < 0 { return "🧊" }; if temp < 100 { return "💧" }; return "💨"
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Add Heat → Change State").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text(emoji).font(.system(size: 100))
                Text("\(Int(temp)) °C").font(.title2.monospacedDigit())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Slider(value: $temp, in: -20...130).frame(maxWidth: 340).padding(.horizontal, DesignTokens.Spacing.xl)
                Text(state).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}

// MARK: - Inline Scene 19: Specific Heat Race (timing comparison)
struct SpecificHeatRaceScene: View {
    let onComplete: () -> Void
    @State private var running: Bool = false
    @State private var waterTemp: Double = 20
    @State private var sandTemp: Double = 20

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Water vs Sand — Race to Hot").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("Heat the same mass of water and sand with the same flame. Watch them race.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                HStack(spacing: 30) {
                    barReadout(label: "Water", temp: waterTemp, color: DesignTokens.BrandColor.relatedConcepts)
                    barReadout(label: "Sand", temp: sandTemp, color: DesignTokens.BrandColor.mnemonicAccent)
                }
                Button { startRace() } label: {
                    Text(running ? "Racing…" : "Start race").font(.body.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 9)
                        .background(Capsule().fill(DesignTokens.BrandColor.danger.opacity(0.18)))
                        .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                        .foregroundColor(DesignTokens.BrandColor.danger)
                }
                .buttonStyle(.plain).pointingCursor().disabled(running)
                Text("Sand heats up about 5× faster than water for the same energy. That's why beach sand is scorching while the sea stays cool.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    private func barReadout(label: String, temp: Double, color: Color) -> some View {
        let fillH: CGFloat = CGFloat((temp - 20) / 80) * 120
        return VStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(Color.gray.opacity(0.1))
                    .frame(width: 60, height: 120)
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(color.opacity(0.7))
                    .frame(width: 60, height: fillH)
            }
            Text(label).font(.caption.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("\(Int(temp)) °C").font(.caption2.monospacedDigit())
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
    }

    private func startRace() {
        waterTemp = 20; sandTemp = 20
        running = true
        Task { @MainActor in
            withAnimationRespectingReduceMotion(.linear(duration: 3.0)) {
                sandTemp = 90
                waterTemp = 35
            }
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            running = false
        }
    }
}
