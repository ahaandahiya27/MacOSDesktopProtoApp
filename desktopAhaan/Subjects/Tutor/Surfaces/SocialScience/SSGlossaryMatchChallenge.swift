import SwiftUI

// MARK: - SSGlossaryMatchChallenge
//
// Reusable bespoke interactive for the vocabulary-heavy Social Science chapters
// (Civics, Economics, Society, and the remaining Geography chapters). Each
// chapter ships a 10–12 term glossary; this turns the first few key terms into
// an active "match the term to its meaning" game. Tap a term to select it, then
// tap the meaning you think fits — correct pairs lock green, wrong taps flash.
//
// The content is the chapter's own authored glossary, so it's faithful by
// construction; only the mechanic is shared (like SSChronologyChallenge across
// History chapters). Strong vocabulary recall is exactly what these strands
// reward in exams and Olympiads.
//
// Big Sur compat: self-contained, @State only, SwiftUI Shapes + system colours
// via Color(red:green:blue:)/compatIndigo, RM-gated motion, VoiceOver labels.
// No macOS 12+ APIs, no randomness (fixed-seed shuffle of the meanings).

struct SSGlossaryMatchChallenge: View {
    let title: String
    private let terms: [GlossaryTerm]
    private let meaningOrder: [Int]   // shuffled term-indices → meaning display order

    @State private var selectedTerm: Int? = nil
    @State private var matched: Set<Int> = []
    @State private var wrongMeaning: Int? = nil
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Takes a chapter's glossary; uses the first `cap` terms (authors front-load
    /// the key vocabulary). `cap` clamps so the widget stays compact.
    init(title: String, glossary: [GlossaryTerm], cap: Int = 4) {
        self.title = title
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

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            if isSolved { solvedBanner } else { Group { termColumn; meaningColumn } }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                    .strokeBorder(Color.compatIndigo.opacity(0.25), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Match the key words")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text(selectedTerm == nil
                 ? "Tap a word, then tap its meaning. \(title)"
                 : "Now tap the meaning of “\(terms[selectedTerm!].term)”.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var termColumn: some View {
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
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 9)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 8).fill(termFill(i)))
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(selectedTerm == i ? Color.compatIndigo : Color.compatIndigo.opacity(0.22),
                                      lineWidth: selectedTerm == i ? 2 : 1))
                }
                .buttonStyle(.plain).pointingCursor()
                .disabled(done)
                .accessibilityLabel("Word: \(terms[i].term)\(done ? ", matched" : "")")
            }
        }
    }

    private func termFill(_ i: Int) -> Color {
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 9)
                            .background(RoundedRectangle(cornerRadius: 8).fill(meaningFill(termIdx)))
                            .overlay(RoundedRectangle(cornerRadius: 8)
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
            Text("All matched! You linked every key word to its meaning.")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Spacer(minLength: 0)
            Button { reset() } label: {
                Text("Again").font(.caption.weight(.semibold)).foregroundColor(Color.compatIndigo)
            }
            .buttonStyle(.plain).pointingCursor()
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.14)))
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
