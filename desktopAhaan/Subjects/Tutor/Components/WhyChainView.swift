import SwiftUI
import AppKit

// MARK: - WhyChainView
//
// Reusable three-layer Socratic drill. Lives in Components/ rather
// than Surfaces/ because every chapter can eventually consume it
// once their concepts have a `whyChain` authored — Ch.1 pilot only
// today.
//
// Behaviour:
//   • Mount under a concept body. If `concept.whyChain` is nil/empty,
//     this view renders EmptyView (no pill, no whitespace).
//   • One "Ask why?" pill appears initially. Tap → reveals
//     whyChain[0] in a framed card and the pill relabels to
//     "Why? Layer 2 →". Tap → reveals whyChain[1] and relabels to
//     "Why? Layer 3 →". Tap → reveals whyChain[2] and relabels to
//     "Back to start ↺". Tap → collapses everything.
//   • Layer count is persisted per concept via
//     @SceneStorage("whyChain.<conceptId>") so the kid can resume
//     mid-chain.
//   • Reveal/collapse transitions go through
//     withAnimationRespectingReduceMotion.
//
// Big Sur compat: pure macOS 10.15+. Color.compat* tokens.

struct WhyChainView: View {
    let conceptId: String
    let chain: [String]?

    @SceneStorage private var layerShown: Int  // 0 = none, 1..3 = layers

    init(conceptId: String, chain: [String]?) {
        self.conceptId = conceptId
        self.chain = chain
        self._layerShown = SceneStorage(wrappedValue: 0, "whyChain.\(conceptId)")
    }

    /// Clamp to the actual chain length so a future schema change
    /// (e.g. 4-layer chain) can't out-of-bounds older @SceneStorage
    /// values.
    private var safeLayerShown: Int {
        max(0, min(chain?.count ?? 0, layerShown))
    }

    var body: some View {
        if let chain = chain, !chain.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                pillButton(chain: chain)
                if safeLayerShown > 0 {
                    layersStack(chain: chain)
                }
            }
        }
    }

    private func pillButton(chain: [String]) -> some View {
        Button(action: { advance(chainCount: chain.count) }) {
            HStack(spacing: 6) {
                Image(systemName: SFSymbolCompat.name(safeLayerShown >= chain.count ? "arrow.uturn.backward.circle.fill" : "questionmark.circle.fill"))
                    .font(.callout)
                Text(pillLabel(chainCount: chain.count))
                    .font(.callout.weight(.semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(Color.compatIndigo)
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel(pillA11yLabel(chainCount: chain.count))
        .accessibilityHint(pillA11yHint(chainCount: chain.count))
    }

    private func layersStack(chain: [String]) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            ForEach(0..<safeLayerShown, id: \.self) { idx in
                whyLayerCard(layer: idx + 1, text: chain[idx])
            }
        }
        .transition(.opacity)
    }

    private func whyLayerCard(layer: Int, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Why? Layer \(layer)")
                .font(.caption.weight(.bold))
                .foregroundColor(Color.compatIndigo)
                .textCase(.uppercase)
                .accessibilityAddTraits(.isHeader)
            Text(text)
                .font(.callout)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(Color.compatIndigo.opacity(0.08))
        )
    }

    // MARK: - State transitions

    /// Tap progression: 0 → 1 → 2 → 3 → 0 (loops). Never lands
    /// outside [0, count].
    private func advance(chainCount: Int) {
        withAnimationRespectingReduceMotion(.easeOut(duration: 0.20)) {
            if safeLayerShown >= chainCount {
                layerShown = 0
            } else {
                layerShown = safeLayerShown + 1
            }
        }
    }

    private func pillLabel(chainCount: Int) -> String {
        if safeLayerShown >= chainCount { return "Back to start" }
        if safeLayerShown == 0 { return "Ask why?" }
        return "Why? Layer \(safeLayerShown + 1) →"
    }

    private func pillA11yLabel(chainCount: Int) -> String {
        if safeLayerShown >= chainCount { return "Collapse why-chain" }
        return "Ask why — reveal layer \(safeLayerShown + 1) of \(chainCount)"
    }

    private func pillA11yHint(chainCount: Int) -> String {
        if safeLayerShown >= chainCount {
            return "Collapses all revealed why-chain layers."
        }
        return "Reveals a deeper explanation. Tap again for the next layer; \(chainCount) layers total."
    }
}
