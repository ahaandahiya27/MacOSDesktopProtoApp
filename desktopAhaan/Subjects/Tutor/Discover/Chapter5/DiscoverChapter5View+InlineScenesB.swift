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
struct AcidRainQuizScene: View {
    let onComplete: (Int) -> Void
    private struct Q: Identifiable {
        let id: String; let prompt: String; let opts: [String]; let correct: Int
    }
    private let qs: [Q] = [
        Q(id: "q1", prompt: "Which gases mix with rainwater to make acid rain?",
          opts: ["O₂ and N₂", "SO₂ and NO₂", "CO₂ and CH₄"], correct: 1),
        Q(id: "q2", prompt: "What pH does normal rain have, and acid rain?",
          opts: ["~5.6 → drops below 5", "~7 → stays 7", "~9 → drops to 6"], correct: 0),
        Q(id: "q3", prompt: "What's the biggest source of SO₂ in the atmosphere?",
          opts: ["Cars", "Burning coal in power plants", "Cooking with LPG"], correct: 1),
        Q(id: "q4", prompt: "Acid rain damages limestone monuments because…",
          opts: ["limestone is base; acid eats it", "limestone is acid", "limestone reflects sunlight"], correct: 0)
    ]
    @State private var picks: [String: Int] = [:]
    private var score: Int { qs.reduce(0) { $0 + ((picks[$1.id] == $1.correct) ? 1 : 0) } }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Acid Rain Survivor Quiz").font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ForEach(qs) { q in qCard(q) }
                if picks.count == qs.count {
                    Text("Score: \(score) / \(qs.count)").font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                }
                GotItButton(action: { onComplete(score) }).padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity).padding(.bottom, 12)
        }
    }

    @ViewBuilder
    private func qCard(_ q: Q) -> some View {
        let pick = picks[q.id]
        VStack(alignment: .leading, spacing: 8) {
            Text(q.prompt).font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            ForEach(0..<q.opts.count, id: \.self) { i in
                let isPicked = pick == i
                let tint: Color = pick == nil
                    ? Color.compatIndigo
                    : (isPicked ? (i == q.correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger) : Color.gray)
                Button {
                    if picks[q.id] == nil { picks[q.id] = i }
                } label: {
                    Text(q.opts[i]).font(.caption.weight(.semibold))
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                        .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                        .foregroundColor(tint)
                }
                .buttonStyle(.plain).pointingCursor().disabled(pick != nil)
            }
        }
        .padding(12)
        .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, 24)
    }
}
