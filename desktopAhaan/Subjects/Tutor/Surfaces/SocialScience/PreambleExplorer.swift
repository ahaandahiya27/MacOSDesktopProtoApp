import SwiftUI

// MARK: - PreambleExplorer
//
// Bespoke interactive for Social Science Ch.10 "The Constitution of India — An
// Introduction" (`socialscience_class7` / ssch10). The chapter's closing topic
// (ssch10_t05) is the Preamble: t05_c02 names the five words that say what kind
// of nation India IS (Sovereign, Socialist, Secular, Democratic, Republic), and
// t05_c03 names the four goals it SECURES for every citizen (Justice, Liberty,
// Equality, Fraternity). This widget shows the real Preamble with those nine
// words highlighted, then lets the learner tap each one to reveal — in the
// chapter's own kid-friendly words — what it actually promises.
//
// The two tappable sections mirror the chapter's own t05_c02 / t05_c03 split, so
// the interaction reinforces the structure of the lesson. A small footnote on
// the words that have a story (Socialist/Secular added by the 42nd Amendment;
// Fraternity's French-Revolution echo) carries the chapter's "beyondTheBook"
// facts. A progress line nudges the learner to explore all nine.
//
// Big Sur compat: self-contained, @State + @SceneStorage (namespaced by
// chapter), Text concatenation for inline emphasis (no flow-layout API), manual
// chip wrapping (no LazyVGrid dependency), Color.compat* + Color(red:green:blue:),
// RM-gated motion, SFSymbolCompat, VoiceOver labels. No macOS 12+ APIs, no
// randomness, no force-unwraps.

struct PreambleExplorer: View {
    let chapterId: String

    @SceneStorage private var selected: Int   // -1 = none
    @State private var explored: Set<Int> = []
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(chapterId: String) {
        self.chapterId = chapterId
        self._selected = SceneStorage(wrappedValue: -1, "ssinteractive.\(chapterId).preamble")
    }

    // MARK: - The nine ideals (grounded in ssch10_t05_c02 / t05_c03)

    private struct Ideal {
        let word: String          // the keyword as it appears in the Preamble
        let isNation: Bool        // true = "what India IS"; false = "what it secures"
        let meaning: String       // chapter's kid-friendly gloss
        let footnote: String?     // optional beyondTheBook story
    }

    private let ideals: [Ideal] = [
        Ideal(word: "Sovereign", isNation: true,
              meaning: "India makes its own decisions on matters at home and abroad — no outside power can dictate to it.",
              footnote: nil),
        Ideal(word: "Socialist", isNation: true,
              meaning: "Wealth is created by society and should be shared; the government works to reduce the gap between the rich and the poor.",
              footnote: "Added to the Preamble by the 42nd Amendment in 1976 — it was not in the original 1950 text."),
        Ideal(word: "Secular", isNation: true,
              meaning: "Citizens are free to follow any religion they choose, and there is no official state religion.",
              footnote: "Added — with 'Socialist' — by the 42nd Amendment in 1976."),
        Ideal(word: "Democratic", isNation: true,
              meaning: "The people elect their leaders and can hold them to account; every adult's vote counts equally.",
              footnote: nil),
        Ideal(word: "Republic", isNation: true,
              meaning: "The head of state — the President — is elected, not a king who inherits the throne.",
              footnote: nil),
        Ideal(word: "Justice", isNation: false,
              meaning: "No one may be discriminated against for caste, religion or gender — social, economic and political inequalities must be reduced.",
              footnote: nil),
        Ideal(word: "Liberty", isNation: false,
              meaning: "There are no unreasonable restrictions on what citizens think, how they express themselves, and how they believe and worship.",
              footnote: nil),
        Ideal(word: "Equality", isNation: false,
              meaning: "All are equal before the law, and the government must ensure equal opportunity for everyone.",
              footnote: nil),
        Ideal(word: "Fraternity", isNation: false,
              meaning: "We should all behave as members of one family, and no one should treat a fellow citizen as inferior.",
              footnote: "Echoes the French Revolution's 'liberty, equality, fraternity' — but India added that it must assure the dignity of the individual and the unity of the nation.")
    ]

    private var nationIndices: [Int] { ideals.indices.filter { ideals[$0].isNation } }
    private var secureIndices: [Int] { ideals.indices.filter { !ideals[$0].isNation } }

    // The actual Preamble of India (one long sentence).
    private let preambleText = "WE, THE PEOPLE OF INDIA, having solemnly resolved to constitute India into a Sovereign Socialist Secular Democratic Republic and to secure to all its citizens: Justice, social, economic and political; Liberty of thought, expression, belief, faith and worship; Equality of status and of opportunity; and to promote among them all Fraternity assuring the dignity of the individual and the unity and integrity of the Nation."

    // Uppercased cores of the nine keywords, for inline emphasis detection.
    private var keywordCores: Set<String> {
        Set(ideals.map { $0.word.uppercased() })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            preambleCard
            section(title: "What kind of nation India is", indices: nationIndices)
            section(title: "What it secures for every citizen", indices: secureIndices)
            if selected >= 0, selected < ideals.count { detailPanel(ideals[selected]) }
            progressFooter
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                .fill(Color.white.opacity(0.92))
                .overlay(RoundedRectangle(cornerRadius: DesignTokens.cornerRadiusLarge)
                    .strokeBorder(Color.compatBlue.opacity(0.25), lineWidth: 1))
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            Text("Explore the Preamble")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Tap a highlighted word to discover what the Constitution promises in it.")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // The Preamble rendered with the nine keywords bold + tinted inline.
    private var preambleCard: some View {
        styledPreamble
            .font(.callout)
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .fixedSize(horizontal: false, vertical: true)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.compatBlue.opacity(0.06)))
            .accessibilityLabel("The Preamble of India: \(preambleText)")
    }

    // Concatenate Text segments so the nine keywords stand out without a
    // macOS 12+ flow-layout API. Punctuation is stripped only for matching.
    private var styledPreamble: Text {
        let cores = keywordCores
        var result = Text("")
        let tokens = preambleText.split(separator: " ", omittingEmptySubsequences: true)
        for (i, token) in tokens.enumerated() {
            let word = String(token)
            let core = word.uppercased().filter { $0.isLetter }
            let piece: Text
            if cores.contains(core) {
                piece = Text(word).font(.callout.weight(.bold)).foregroundColor(Color.compatBlue)
            } else {
                piece = Text(word)
            }
            result = i == 0 ? piece : result + Text(" ") + piece
        }
        return result
    }

    // MARK: - Tappable sections (mirror t05_c02 / t05_c03)

    private func section(title: String, indices: [Int]) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            chipWrap(indices)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // Manual wrapping into rows of up to 3 — avoids LazyVGrid so the layout is
    // identical on Big Sur. `indices` index into `ideals`.
    private func chipWrap(_ indices: [Int]) -> some View {
        let rows = stride(from: 0, to: indices.count, by: 3).map { start -> [Int] in
            Array(indices[start..<min(start + 3, indices.count)])
        }
        return VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            ForEach(rows.indices, id: \.self) { r in
                HStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(rows[r], id: \.self) { idx in chip(idx) }
                    Spacer(minLength: 0)
                }
            }
        }
    }

    private func chip(_ idx: Int) -> some View {
        let ideal = ideals[idx]
        let isOn = selected == idx
        let done = explored.contains(idx)
        return Button { selectIdeal(idx) } label: {
            HStack(spacing: 5) {
                if done {
                    Image(systemName: SFSymbolCompat.name("checkmark"))
                        .font(.caption2.weight(.bold))
                        .accessibilityHidden(true)
                }
                Text(ideal.word)
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(isOn ? .white : DesignTokens.BrandColor.canvasText)
            .padding(.horizontal, 13).padding(.vertical, 7)
            .background(Capsule().fill(isOn ? Color.compatBlue : Color.compatBlue.opacity(0.10)))
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("\(ideal.word)\(done ? ", explored" : "")\(isOn ? ", selected" : "")")
        .accessibilityHint("Tap to read what \(ideal.word) means in the Preamble.")
    }

    // MARK: - Detail + progress

    private func detailPanel(_ ideal: Ideal) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 7) {
                Image(systemName: SFSymbolCompat.name("building.columns.fill"))
                    .foregroundColor(Color.compatBlue)
                    .accessibilityHidden(true)
                Text(ideal.word)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
            }
            Text(ideal.meaning)
                .font(.callout)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .fixedSize(horizontal: false, vertical: true)
            if let note = ideal.footnote {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: SFSymbolCompat.name("sparkles"))
                        .font(.caption2)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .accessibilityHidden(true)
                    Text(note)
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.compatBlue.opacity(0.12)))
        .accessibilityElement(children: .combine)
    }

    private var progressFooter: some View {
        let n = explored.count
        let total = ideals.count
        return HStack(spacing: 6) {
            Image(systemName: SFSymbolCompat.name(n >= total ? "checkmark.seal.fill" : "scope"))
                .foregroundColor(n >= total ? .green : DesignTokens.BrandColor.canvasTextSecondary)
                .accessibilityHidden(true)
            Text(n >= total
                 ? "You've explored all \(total) ideals of the Preamble!"
                 : "Explored \(n) of \(total) ideals — keep tapping to find them all.")
                .font(.caption.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }

    // MARK: - Action

    private func selectIdeal(_ idx: Int) {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            selected = idx
            explored.insert(idx)
        }
    }
}
