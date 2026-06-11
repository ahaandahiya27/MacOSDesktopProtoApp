import SwiftUI

// Inline scenes 18 + 19 lifted from `DiscoverChapter3View.swift`
// 2026-05-26 (final consolidation pass round 3) to bring the
// parent under the 600-LOC Big Sur ceiling. Same shape as the
// Ch.4 + Ch.5 splits (commits edfc32c, 2faf80f). Scopes change
// from file-private to module-internal — only the Ch.3
// dispatcher references these scenes.

// MARK: - Inline Scene 18: Fabric Care Symbols Quiz (image quiz)
struct FabricCareSymbolsQuizScene: View {
    let onComplete: (Int) -> Void

    private struct Q: Identifiable {
        let id: String; let symbol: String; let prompt: String; let opts: [String]; let correct: Int
    }
    private let questions: [Q] = [
        Q(id: "q1", symbol: "♨️", prompt: "What does the wash-tub symbol with a number inside mean?",
          opts: ["Dry clean only", "Wash up to that temperature", "Cannot wash"], correct: 1),
        Q(id: "q2", symbol: "🚫", prompt: "Triangle crossed out — what's banned?",
          opts: ["Bleach", "Ironing", "Tumble dry"], correct: 0),
        Q(id: "q3", symbol: "🌀", prompt: "Circle inside a square — what does it mean?",
          opts: ["Hand wash", "Tumble dry", "Dry clean"], correct: 1),
        Q(id: "q4", symbol: "🟦", prompt: "An iron with dots — what do the dots indicate?",
          opts: ["How many shirts to do", "Iron heat level", "How wet it should be"], correct: 1)
    ]
    @State private var picks: [String: Int] = [:]
    private var score: Int { questions.reduce(0) { $0 + ((picks[$1.id] == $1.correct) ? 1 : 0) } }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Fabric Care Symbols")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                ForEach(questions) { q in qCard(q) }
                if picks.count == questions.count {
                    Text("Score: \(score) / \(questions.count)")
                        .font(.headline)
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                }
                GotItButton(action: { onComplete(score) }).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }

    @ViewBuilder
    private func qCard(_ q: Q) -> some View {
        let pick = picks[q.id]
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            HStack { Text(q.symbol).font(.title); Text(q.prompt).font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true) }
            HStack(spacing: 6) {
                ForEach(0..<q.opts.count, id: \.self) { i in
                    let isPicked = pick == i
                    let tint: Color = pick == nil
                        ? Color.compatIndigo
                        : (isPicked ? (i == q.correct ? DesignTokens.BrandColor.primaryAction : DesignTokens.BrandColor.danger) : Color.gray)
                    Button {
                        if picks[q.id] == nil { picks[q.id] = i }
                    } label: {
                        Text(q.opts[i]).font(.caption.weight(.semibold))
                            .padding(.horizontal, DesignTokens.Spacing.sm).padding(.vertical, 5)
                            .background(Capsule().fill(tint.opacity(isPicked ? 0.22 : 0.10)))
                            .overlay(Capsule().strokeBorder(tint.opacity(0.5), lineWidth: 1))
                            .foregroundColor(tint)
                    }
                    .buttonStyle(.plain).pointingCursor().disabled(pick != nil)
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
        .padding(.horizontal, DesignTokens.Spacing.xl)
    }
}

// MARK: - Inline Scene 19: Indian Textile Map (tap-to-reveal)
struct IndianTextileMapScene: View {
    let onComplete: () -> Void
    @State private var tapped: Set<String> = []

    private struct Region: Identifiable {
        let id: String; let emoji: String; let name: String; let famous: String
    }
    private let regions: [Region] = [
        Region(id: "punjab", emoji: "🧣", name: "Punjab / Kashmir", famous: "Phulkari embroidery, Pashmina shawls."),
        Region(id: "gujarat", emoji: "🪢", name: "Gujarat", famous: "Bandhani (tie-dye), Patola double-ikat."),
        Region(id: "rajasthan", emoji: "🧵", name: "Rajasthan", famous: "Block print (Bagru, Sanganer)."),
        Region(id: "bengal", emoji: "👘", name: "West Bengal", famous: "Jamdani, Baluchari, Kantha embroidery."),
        Region(id: "tamilnadu", emoji: "🎀", name: "Tamil Nadu", famous: "Kanchipuram silk sarees."),
        Region(id: "karnataka", emoji: "🧶", name: "Karnataka", famous: "Mysore silk; ~70% of India's mulberry silk.")
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                Text("Indian Textile Map")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText).padding(.top, 18)
                Text("India's textile traditions are region-specific. Tap each to learn what they're famous for.")
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal, DesignTokens.Spacing.xl)
                ForEach(regions) { r in
                    Button { tapped.insert(r.id) } label: {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                            HStack {
                                Text(r.emoji).font(.title3)
                                Text(r.name).font(.headline)
                                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                            }
                            if tapped.contains(r.id) {
                                Text(r.famous).font(.callout)
                                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                                    .fixedSize(horizontal: false, vertical: true)
                            } else {
                                Text("Tap to reveal").font(.caption.italic())
                                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                            }
                        }
                        .padding(DesignTokens.Spacing.md)
                        .frame(maxWidth: DesignTokens.contentMaxWidth, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.85)))
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.gray.opacity(0.18), lineWidth: 1))
                    }
                    .buttonStyle(.plain).pointingCursor()
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                }
                GotItButton(action: onComplete).padding(.bottom, DesignTokens.Spacing.md)
            }
            .frame(maxWidth: .infinity).padding(.bottom, DesignTokens.Spacing.md)
        }
    }
}
