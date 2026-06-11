import SwiftUI

// MARK: - ShabdaArthaMatchChallenge  (शब्द–अर्थ — "word ↔ meaning")
//
// Bespoke Discover interactive for the NEP Sanskrit chapters (sch01–sch15).
// Sanskrit is a vocabulary- and verse-driven subject: the single most useful
// active recall a Class-7 learner can do is link a Devanagari शब्द (word) to
// its अर्थ (meaning). This widget turns the chapter's OWN authored glossary
// into that game — tap a Devanagari word, then tap the meaning that fits.
// Correct pairs lock green; a wrong tap flashes red.
//
// It is the Sanskrit sibling of `SSGlossaryMatchChallenge`, but deliberately
// SEPARATE and Devanagari-forward:
//   • the word column renders the शब्द large (Devanagari matras are tall),
//     with generous vertical room and `fixedSize` so no glyph is clipped;
//   • the framing is bilingual (शब्द–अर्थ / "Match the word to its meaning");
//   • the solved banner congratulates in Sanskrit (अति उत्तमम्!).
//
// Faithful by construction: every prompt + answer is the chapter's own
// glossary entry (`term` → `definition`), so it cannot drift from content.
//
// Big Sur compat: self-contained, @State only, SwiftUI Shapes + system colours
// via Color.compatIndigo / DesignTokens, reduce-motion-gated motion, VoiceOver
// labels. No macOS 12+ APIs, no force-unwrap, no randomness (fixed-seed
// shuffle of the meaning order — identical to the SS challenge's approach so
// the layout is deterministic and testable).

struct ShabdaArthaMatchChallenge: View {
    let chapterTitle: String
    private let terms: [GlossaryTerm]
    private let meaningOrder: [Int]   // shuffled term-indices → meaning display order

    @State private var selectedTerm: Int? = nil
    @State private var matched: Set<Int> = []
    @State private var wrongMeaning: Int? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Takes a chapter's glossary; uses the first `cap` terms (authors
    /// front-load the key vocabulary). `cap` clamps so the widget stays
    /// compact — 5 fits comfortably because Sanskrit headwords are short.
    init(chapterTitle: String, glossary: [GlossaryTerm], cap: Int = 5) {
        self.chapterTitle = chapterTitle
        let chosen = Array(glossary.prefix(cap))
        self.terms = chosen
        self.meaningOrder = Self.shuffle(count: chosen.count)
    }

    private static func shuffle(count n: Int) -> [Int] {
        guard n > 1 else { return Array(0..<max(0, n)) }
        var order = Array(0..<n)
        var seed: UInt64 = 0x9E3779B97F4A7C15
        var i = n - 1
        while i > 0 {
            seed = seed &* 6364136223846793005 &+ 1442695040888963407
            let j = Int((seed >> 33) % UInt64(i + 1))
            order.swapAt(i, j)
            i -= 1
        }
        if order == Array(0..<n) { order.reverse() }
        return order
    }

    private var isSolved: Bool { matched.count == terms.count && !terms.isEmpty }

    private var promptText: String {
        guard let sel = selectedTerm, terms.indices.contains(sel) else {
            return "Tap a word, then tap its meaning. \(chapterTitle)"
        }
        return "Now tap the meaning of “\(terms[sel].term)”."
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            if isSolved { solvedBanner } else { Group { wordColumn; meaningColumn } }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                    .strokeBorder(Color.compatIndigo.opacity(0.25), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("शब्द–अर्थ — Match the word to its meaning")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            Text(promptText)
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var wordColumn: some View {
        VStack(spacing: 6) {
            ForEach(terms.indices, id: \.self) { i in
                let done = matched.contains(i)
                Button { selectTerm(i) } label: {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        if done {
                            Image(systemName: SFSymbolCompat.name("checkmark.circle.fill"))
                                .foregroundColor(.green).accessibilityHidden(true)
                        }
                        Text(terms[i].term)
                            // Devanagari matras sit above and below the baseline —
                            // a generous size + vertical fixedSize keeps them clear.
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .lineSpacing(3)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 11)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(wordFill(i)))
                    .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                        .strokeBorder(selectedTerm == i ? Color.compatIndigo : Color.compatIndigo.opacity(0.22),
                                      lineWidth: selectedTerm == i ? 2 : 1))
                }
                .buttonStyle(.plain).pointingCursor()
                .disabled(done)
                .accessibilityLabel("Word: \(terms[i].term)\(done ? ", matched" : "")")
            }
        }
    }

    private func wordFill(_ i: Int) -> Color {
        if matched.contains(i) { return Color.green.opacity(0.14) }
        if selectedTerm == i { return Color.compatIndigo.opacity(0.14) }
        return Color.compatIndigo.opacity(0.05)
    }

    private var meaningColumn: some View {
        VStack(spacing: 6) {
            ForEach(meaningOrder.indices, id: \.self) { pos in
                let termIdx = meaningOrder[pos]
                if !matched.contains(termIdx) {
                    Button { tapMeaning(termIdx) } label: {
                        Text(terms[termIdx].definition)
                            .font(.caption)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 9)
                            .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(meaningFill(termIdx)))
                            .overlay(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                                .strokeBorder(Color.compatIndigo.opacity(0.18), lineWidth: 1))
                    }
                    .buttonStyle(.plain).pointingCursor()
                    .accessibilityLabel("Meaning: \(terms[termIdx].definition)")
                    .accessibilityHint(selectedTerm == nil ? "Pick a word first." : "Tap if this matches the selected word.")
                }
            }
        }
    }

    private func meaningFill(_ termIdx: Int) -> Color {
        if wrongMeaning == termIdx { return Color.red.opacity(0.15) }
        return Color.compatIndigo.opacity(0.04)
    }

    private var solvedBanner: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: SFSymbolCompat.name("checkmark.seal.fill"))
                .foregroundColor(.green).accessibilityHidden(true)
            Text("अति उत्तमम्! You linked every word to its meaning.")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            Button { reset() } label: {
                Text("पुनः (Again)").font(.caption.weight(.semibold)).foregroundColor(Color.compatIndigo)
            }
            .buttonStyle(.plain).pointingCursor()
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(Color.green.opacity(0.14)))
        .accessibilityElement(children: .combine)
    }

    // MARK: - Actions

    private func selectTerm(_ i: Int) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.15)) {
            selectedTerm = i
            wrongMeaning = nil
        }
    }

    private func tapMeaning(_ termIdx: Int) {
        guard let sel = selectedTerm else {
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.15)) { wrongMeaning = termIdx }
            return
        }
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            if termIdx == sel {
                matched.insert(sel)
                selectedTerm = nil
                wrongMeaning = nil
            } else {
                wrongMeaning = termIdx
            }
        }
    }

    private func reset() {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            matched = []
            selectedTerm = nil
            wrongMeaning = nil
        }
    }
}
