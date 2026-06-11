import SwiftUI

// Bespoke gated Discover-Mode interactives for the Class 7 Social Science pack
// (`socialscience_class7`). Until now Social Science was the only one of the
// four subjects whose Discover *scene flow* carried no gated interactive:
// Science/Maths ship hand-built sandboxes/tours per chapter, and Sanskrit's
// Discover flow slots a शब्द–अर्थ word-match as scene 4. The bespoke Social
// Science widgets (IndiaPhysiographicExplorer, SSChronologyChallenge, …) lived
// only in the chapter *detail* surface. This file gives the Discover flow the
// matching gated scene so all four subjects reach Discover parity:
//
//   • History chapters (date-ordered timelines) → `SSDiscoverChronologyScene`,
//     a "tap the events earliest → latest" challenge. Completion is genuinely
//     gated: every event must be placed in the correct order to continue.
//   • Every other chapter → `SSDiscoverWordMatchScene`, a key-term ↔ meaning
//     match over the chapter's authored glossary (every SS chapter ships ≥16
//     glossary terms, so this is faithful by construction). Completion is gated
//     on matching every pair.
//
// Interaction is tap-to-select / tap-to-place (NOT drag — SwiftUI drag-and-drop
// is unreliable on the Big Sur deploy target). All Big-Sur-safe: plain Buttons,
// no macOS 12+ APIs, SF Symbols via `SFSymbolCompat`, motion through
// `withAnimationRespectingReduceMotion`. Neither scene records SRS — like the
// info scenes they are recognition warm-ups; the chapter Q&A / boss quizzes own
// the SM-2 review path.

// MARK: - Word-match (non-history chapters)

/// One term↔meaning pair the SS match game tests. Its stable id keeps the
/// left/right halves linked after the meaning column is shuffled.
struct SSDiscoverMatchPair: Identifiable, Hashable {
    let id: String
    let term: String        // e.g. "Barter"
    let meaning: String     // its short gloss
}

/// Tap-to-match glossary game for a Social Science chapter's Discover flow.
/// `@MainActor` for parity with the other Discover scenes (reads
/// `accessibilityReduceMotion`, mutates view state on main).
@MainActor
struct SSDiscoverWordMatchScene: View {
    let title: String
    let intro: String
    let pairs: [SSDiscoverMatchPair]
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var selectedTermId: String? = nil
    @State private var matched: Set<String> = []
    @State private var wrongMeaningId: String? = nil
    @State private var shuffledMeanings: [SSDiscoverMatchPair] = []

    private var solved: Bool { matched.count == pairs.count && !pairs.isEmpty }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: DesignTokens.Spacing.lg) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 18)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                Text(intro)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                progressCounter
                matchGrid
                if solved { completionBlock }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.lg)
        }
        .onAppear {
            if shuffledMeanings.isEmpty { shuffledMeanings = pairs.shuffled() }
        }
    }

    private var progressCounter: some View {
        Text("Matched \(matched.count) of \(pairs.count)")
            .font(.monoDigitCaption)
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .padding(.horizontal, 10)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.85))
                    .overlay(Capsule().strokeBorder(Color.black.opacity(0.12), lineWidth: 0.5))
            )
            .accessibilityLabel("Matched \(matched.count) of \(pairs.count) pairs")
    }

    private var matchGrid: some View {
        SoftShadowCard(padding: 16) {
            HStack(alignment: .top, spacing: 14) {
                VStack(spacing: 10) {
                    columnHeader("Key word")
                    ForEach(pairs) { pair in termButton(pair) }
                }
                VStack(spacing: 10) {
                    columnHeader("Meaning")
                    ForEach(shuffledMeanings) { pair in meaningButton(pair) }
                }
            }
        }
        .frame(maxWidth: 560)
        .padding(.horizontal, DesignTokens.Spacing.lg)
    }

    private func columnHeader(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.bold))
            .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            .frame(maxWidth: .infinity)
    }

    private func termButton(_ pair: SSDiscoverMatchPair) -> some View {
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
                    .font(.body.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                if isMatched {
                    Image(systemName: SFSymbolCompat.name("checkmark.circle.fill"))
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).fill(termFill(isMatched: isMatched, isSelected: isSelected)))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isSelected ? ssAccent : ssAccent.opacity(0.30),
                                  lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .disabled(isMatched)
        .accessibilityLabel("Key word \(pair.term)")
        .accessibilityHint(isMatched ? "Already matched" : (isSelected ? "Selected. Now pick its meaning." : "Tap to select, then pick its meaning."))
    }

    private func meaningButton(_ pair: SSDiscoverMatchPair) -> some View {
        let isMatched = matched.contains(pair.id)
        let isWrong = wrongMeaningId == pair.id
        return Button {
            tapMeaning(pair)
        } label: {
            Text(pair.meaning)
                .font(.subheadline.weight(.medium))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, DesignTokens.Spacing.md).padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).fill(meaningFill(isMatched: isMatched, isWrong: isWrong)))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(isWrong ? Color.red.opacity(0.6) : ssAccent.opacity(0.30), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .disabled(isMatched)
        .accessibilityLabel("Meaning \(pair.meaning)")
        .accessibilityHint(isMatched ? "Already matched" : "Tap to match it with the selected key word.")
    }

    private var completionBlock: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Image(systemName: SFSymbolCompat.name("checkmark.seal.fill"))
                .font(.system(size: 44))
                .foregroundColor(.green)
                .accessibilityHidden(true)
            Text("Great work — every key word matched!")
                .font(.title3.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center)
            GotItButton(label: "Continue", action: onComplete)
        }
        .padding(.top, DesignTokens.Spacing.sm)
    }

    private func tapMeaning(_ pair: SSDiscoverMatchPair) {
        guard !matched.contains(pair.id) else { return }
        guard let term = selectedTermId else { return }
        if term == pair.id {
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) {
                matched.insert(pair.id)
                selectedTermId = nil
            }
        } else {
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

    private var ssAccent: Color { Color(red: 0.18, green: 0.45, blue: 0.55) }

    private func termFill(isMatched: Bool, isSelected: Bool) -> Color {
        if isMatched { return Color.green.opacity(0.18) }
        if isSelected { return ssAccent.opacity(0.18) }
        return ssAccent.opacity(0.06)
    }

    private func meaningFill(isMatched: Bool, isWrong: Bool) -> Color {
        if isMatched { return Color.green.opacity(0.18) }
        if isWrong { return Color.red.opacity(0.15) }
        return ssAccent.opacity(0.06)
    }
}

// MARK: - Chronology (history chapters)

/// "Tap the events earliest → latest" gated challenge over a chapter's authored
/// timeline. The learner builds the sequence one tap at a time; the next event
/// must be the chronologically-correct one or the tap flashes red. Completion
/// is gated on placing every event in order. `@MainActor` for the same reasons
/// as the word-match scene above.
@MainActor
struct SSDiscoverChronologyScene: View {
    let title: String
    let intro: String
    /// Events in canonical (authored, chronological) order — index = correct slot.
    let steps: [TimelineStep]
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Canonical indices in scrambled display order (deterministic, no RNG).
    @State private var scrambled: [Int] = []
    /// Canonical indices placed so far, in the order the learner tapped them.
    @State private var placed: [Int] = []
    /// The chip flashing red after an out-of-order tap.
    @State private var wrongIdx: Int? = nil

    private var solved: Bool { placed.count == steps.count && !steps.isEmpty }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: DesignTokens.Spacing.lg) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 18)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                Text(intro)
                    .font(.callout)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: DesignTokens.contentMaxWidth)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                progressCounter
                placedColumn
                poolColumn
                if solved { completionBlock }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, DesignTokens.Spacing.lg)
        }
        .onAppear {
            if scrambled.isEmpty { scrambled = Self.scramble(count: steps.count) }
        }
    }

    private var progressCounter: some View {
        Text("Placed \(placed.count) of \(steps.count)")
            .font(.monoDigitCaption)
            .foregroundColor(DesignTokens.BrandColor.canvasText)
            .padding(.horizontal, 10)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.85))
                    .overlay(Capsule().strokeBorder(Color.black.opacity(0.12), lineWidth: 0.5))
            )
            .accessibilityLabel("Placed \(placed.count) of \(steps.count) events in order")
    }

    /// The ordered timeline the learner has built so far.
    private var placedColumn: some View {
        SoftShadowCard(padding: 14) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text("Your timeline")
                    .font(.caption.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                if placed.isEmpty {
                    Text("Tap the earliest event below to begin.")
                        .font(.footnote)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                } else {
                    ForEach(placed.indices, id: \.self) { slot in
                        placedRow(slot: slot, step: steps[placed[slot]])
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: 560)
        .padding(.horizontal, DesignTokens.Spacing.lg)
    }

    private func placedRow(slot: Int, step: TimelineStep) -> some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
            Text("\(slot + 1)")
                .font(.monoDigitCaption.weight(.bold))
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
                .background(Circle().fill(ssAccent))
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text(step.label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(DesignTokens.BrandColor.canvasText)
                Text(step.body)
                    .font(.caption)
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10).padding(.vertical, DesignTokens.Spacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.12)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Position \(slot + 1): \(step.label)")
    }

    /// The remaining, not-yet-placed events (scrambled), tappable.
    private var poolColumn: some View {
        let remaining = scrambled.filter { !placed.contains($0) }
        return SoftShadowCard(padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Events to place")
                    .font(.caption.weight(.bold))
                    .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                ForEach(remaining, id: \.self) { idx in
                    poolButton(idx)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: 560)
        .padding(.horizontal, DesignTokens.Spacing.lg)
    }

    private func poolButton(_ idx: Int) -> some View {
        let isWrong = wrongIdx == idx
        let step = steps[idx]
        return Button {
            tapEvent(idx)
        } label: {
            HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
                Image(systemName: SFSymbolCompat.name("hand.tap.fill"))
                    .font(.caption)
                    .foregroundColor(ssAccent)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    Text(step.label)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(DesignTokens.BrandColor.canvasText)
                        .multilineTextAlignment(.leading)
                    Text(step.body)
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 10).padding(.vertical, 9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).fill(isWrong ? Color.red.opacity(0.15) : ssAccent.opacity(0.06)))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isWrong ? Color.red.opacity(0.6) : ssAccent.opacity(0.30), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .pointingCursor()
        .accessibilityLabel("Event: \(step.label)")
        .accessibilityHint("Tap if this is the next-earliest event in the timeline.")
    }

    private var completionBlock: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Image(systemName: SFSymbolCompat.name("checkmark.seal.fill"))
                .font(.system(size: 44))
                .foregroundColor(.green)
                .accessibilityHidden(true)
            Text("Perfect timeline — every event in order!")
                .font(.title3.bold())
                .foregroundColor(DesignTokens.BrandColor.canvasText)
                .multilineTextAlignment(.center)
            GotItButton(label: "Continue", action: onComplete)
        }
        .padding(.top, DesignTokens.Spacing.sm)
    }

    private func tapEvent(_ idx: Int) {
        guard !placed.contains(idx) else { return }
        // Correct iff this event is the next one in canonical order.
        if idx == placed.count {
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) {
                placed.append(idx)
            }
        } else {
            withAnimationRespectingReduceMotion(.easeInOut(duration: 0.15)) {
                wrongIdx = idx
            }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 500_000_000)
                withAnimationRespectingReduceMotion(.easeInOut(duration: 0.2)) {
                    wrongIdx = nil
                }
            }
        }
    }

    /// Deterministic Fisher-Yates over a fixed seed — no `Math.random`, so the
    /// scramble is stable across redraws (and reproducible for the unit test).
    /// Falls back to the identity order if that would leave the list unscrambled
    /// for a short timeline.
    static func scramble(count: Int) -> [Int] {
        guard count > 1 else { return Array(0..<max(0, count)) }
        var order = Array(0..<count)
        var seed: UInt64 = 0x2545F4914F6CDD1D
        var i = count - 1
        while i > 0 {
            seed = seed &* 6364136223846793005 &+ 1442695040888963407
            let j = Int((seed >> 33) % UInt64(i + 1))
            order.swapAt(i, j)
            i -= 1
        }
        // Guarantee it isn't already the canonical order (which would make the
        // game trivial): if it is, rotate by one.
        if order == Array(0..<count) {
            order = Array(order[1...]) + [order[0]]
        }
        return order
    }

    private var ssAccent: Color { Color(red: 0.18, green: 0.45, blue: 0.55) }
}
