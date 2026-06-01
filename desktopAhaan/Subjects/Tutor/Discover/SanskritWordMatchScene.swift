import SwiftUI

// Bespoke Discover-Mode interactive for the Class 7 Sanskrit pack
// (`sanskrit_class7`, P1-E build-out, v6 Learning Journey). This is the
// "gated bespoke interactive" each NEP chapter (`sch01`–`sch15`) carries:
// a Devanagari shabda-artha (शब्द–अर्थ, word–meaning) matching game built
// live from the chapter's `glossary`. Unlike a tap-an-option MCQ, the scene
// only completes once EVERY pair is matched — the learner cannot skip past
// it with a single tap, so chapter-completion credit is genuinely gated on
// doing the recall work.
//
// Interaction (tap-to-match, NOT drag — SwiftUI drag-and-drop is unreliable
// on Big Sur): tap a Sanskrit term to select it, then tap its English
// meaning. A correct pair locks green; a wrong tap flashes red and clears.
// All Big-Sur-safe: plain Buttons, no macOS 12+ APIs, SF Symbols via
// SFSymbolCompat, motion through `withAnimationRespectingReduceMotion`.

/// One term↔meaning pair the match game tests. Built by the chapter view from
/// a `GlossaryTerm` (its stable id keeps the left/right halves linked even
/// after the meaning column is shuffled).
struct SanskritMatchPair: Identifiable, Hashable {
    let id: String
    let term: String       // Devanagari headword, e.g. "जिज्ञासा"
    let meaning: String     // English gloss, e.g. "Curiosity"
}

/// The shabda-artha matching game. `@MainActor` for parity with the other
/// Discover scenes (it reads `accessibilityReduceMotion` and mutates view
/// state on main); it records no SRS — it is a recognition warm-up, like the
/// info scenes, and chapter Q&A / boss quizzes own the SM-2 review path.
@MainActor
struct SanskritWordMatchScene: View {
    let title: String
    let intro: String
    let pairs: [SanskritMatchPair]
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// The term currently picked (its pair id), awaiting a meaning tap.
    @State private var selectedTermId: String? = nil
    /// Pair ids already matched correctly — locked + green on both columns.
    @State private var matched: Set<String> = []
    /// The meaning chip flashing red after a wrong tap (cleared shortly after).
    @State private var wrongMeaningId: String? = nil
    /// Meanings column, shuffled once on appear so the answer order doesn't
    /// line up with the term order.
    @State private var shuffledMeanings: [SanskritMatchPair] = []

    private var solved: Bool { matched.count == pairs.count && !pairs.isEmpty }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 18)
                    .padding(.horizontal, 24)
                Text(intro)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, 24)
                progressCounter
                matchGrid
                if solved {
                    completionBlock
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 16)
        }
        .onAppear {
            if shuffledMeanings.isEmpty { shuffledMeanings = pairs.shuffled() }
        }
    }

    // MARK: - Pieces

    private var progressCounter: some View {
        Text("Matched \(matched.count) of \(pairs.count)")
            .font(.monoDigitCaption)
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.85))
                    .overlay(Capsule().strokeBorder(Color.black.opacity(0.12), lineWidth: 0.5))
            )
            .accessibilityLabel("Matched \(matched.count) of \(pairs.count) pairs")
    }

    /// Two columns: Sanskrit terms (left, original order) and English meanings
    /// (right, shuffled). Kept inside a single SoftShadowCard so the game reads
    /// as one panel against the Discover canvas.
    private var matchGrid: some View {
        SoftShadowCard(padding: 16) {
            HStack(alignment: .top, spacing: 14) {
                VStack(spacing: 10) {
                    columnHeader("शब्द (Word)")
                    ForEach(pairs) { pair in
                        termButton(pair)
                    }
                }
                VStack(spacing: 10) {
                    columnHeader("अर्थ (Meaning)")
                    ForEach(shuffledMeanings) { pair in
                        meaningButton(pair)
                    }
                }
            }
        }
        .frame(maxWidth: 560)
        .padding(.horizontal, 16)
    }

    private func columnHeader(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.bold))
            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            .frame(maxWidth: .infinity)
    }

    private func termButton(_ pair: SanskritMatchPair) -> some View {
        let isMatched = matched.contains(pair.id)
        let isSelected = selectedTermId == pair.id
        return Button {
            guard !isMatched else { return }
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.15)) {
                selectedTermId = isSelected ? nil : pair.id
            }
        } label: {
            HStack(spacing: 6) {
                Text(pair.term)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                if isMatched {
                    Image(systemName: SFSymbolCompat.name("checkmark.circle.fill"))
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).fill(termFill(isMatched: isMatched, isSelected: isSelected)))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? Color.orange : Color.orange.opacity(0.30),
                                  lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .disabled(isMatched)
        .accessibilityLabel("Word \(pair.term)")
        .accessibilityHint(isMatched ? "Already matched" : (isSelected ? "Selected. Now pick its meaning." : "Tap to select, then pick its meaning."))
    }

    private func meaningButton(_ pair: SanskritMatchPair) -> some View {
        let isMatched = matched.contains(pair.id)
        let isWrong = wrongMeaningId == pair.id
        return Button {
            tapMeaning(pair)
        } label: {
            Text(pair.meaning)
                .font(.body.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12).padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).fill(meaningFill(isMatched: isMatched, isWrong: isWrong)))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(isWrong ? Color.red.opacity(0.6) : Color.orange.opacity(0.30), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .disabled(isMatched)
        .accessibilityLabel("Meaning \(pair.meaning)")
        .accessibilityHint(isMatched ? "Already matched" : "Tap to match it with the selected word.")
    }

    private var completionBlock: some View {
        VStack(spacing: 12) {
            Image(systemName: SFSymbolCompat.name("checkmark.seal.fill"))
                .font(.system(size: 44))
                .foregroundColor(.green)
                .accessibilityHidden(true)
            Text("शाबाश! All words matched.")
                .font(.title3.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center)
            GotItButton(label: "Continue", action: onComplete)
        }
        .padding(.top, 8)
    }

    // MARK: - Logic

    private func tapMeaning(_ pair: SanskritMatchPair) {
        guard !matched.contains(pair.id) else { return }
        guard let term = selectedTermId else { return }
        if term == pair.id {
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) {
                matched.insert(pair.id)
                selectedTermId = nil
            }
        } else {
            // Wrong meaning for the selected term — flash it red briefly,
            // then clear the selection so the learner tries again.
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.15)) {
                wrongMeaningId = pair.id
                selectedTermId = nil
            }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 500_000_000)
                withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) {
                    wrongMeaningId = nil
                }
            }
        }
    }

    private func termFill(isMatched: Bool, isSelected: Bool) -> Color {
        if isMatched { return Color.green.opacity(0.18) }
        if isSelected { return Color.orange.opacity(0.18) }
        return Color.orange.opacity(0.06)
    }

    private func meaningFill(isMatched: Bool, isWrong: Bool) -> Color {
        if isMatched { return Color.green.opacity(0.18) }
        if isWrong { return Color.red.opacity(0.15) }
        return Color.orange.opacity(0.06)
    }
}
