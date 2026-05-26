import SwiftUI

// Inline scenes 18 + 19 lifted from `DiscoverChapter5View.swift`
// 2026-05-26 (final consolidation pass) to bring the parent under
// the 600-LOC Big Sur ceiling. Same pattern as
// `DiscoverChapter4View+InlineScenesB.swift` (commit edfc32c).
// The scopes change from file-private to module-internal — only
// the Ch.5 dispatcher references these scenes, so the broadened
// visibility is benign.

// MARK: - Inline Scene 18: Strong vs Weak Acid (binary compare)
struct StrongVsWeakAcidScene: View {
    let onComplete: () -> Void
    @State private var strong: Bool = true

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Strong vs Weak Acid").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                HStack(spacing: 14) {
                    Button { strong = true } label: {
                        Text("Strong").font(.body.weight(strong ? .bold : .regular))
                            .padding(.horizontal, 18).padding(.vertical, 9)
                            .background(Capsule().fill(strong ? DesignTokens.BrandColor.danger.opacity(0.2) : Color.gray.opacity(0.08)))
                            .overlay(Capsule().strokeBorder(DesignTokens.BrandColor.danger.opacity(0.5), lineWidth: 1))
                            .foregroundColor(DesignTokens.BrandColor.danger)
                    }
                    .buttonStyle(.plain).pointingCursor()
                    Button { strong = false } label: {
                        Text("Weak").font(.body.weight(!strong ? .bold : .regular))
                            .padding(.horizontal, 18).padding(.vertical, 9)
                            .background(Capsule().fill(!strong ? Color.compatIndigo.opacity(0.18) : Color.gray.opacity(0.08)))
                            .overlay(Capsule().strokeBorder(Color.compatIndigo.opacity(0.45), lineWidth: 1))
                            .foregroundColor(Color.compatIndigo)
                    }
                    .buttonStyle(.plain).pointingCursor()
                }
                let body = strong
                    ? "Strong acids (HCl, H₂SO₄, HNO₃): release ALL their H⁺ in water. Very low pH (0-1). Burn through metal, paper, skin. Lab use only, with goggles + gloves."
                    : "Weak acids (vinegar, citric, lactic): release SOME H⁺ in water. pH around 3-5. Safe enough to eat — lemon, curd, pickles."
                Text(body).font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.leading)
                    .padding(14)
                    .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                    .padding(.horizontal, 24)
                GotItButton(action: onComplete).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }
}

// MARK: - Inline Scene 19: Acid Rain Quiz (4 MCQs)
