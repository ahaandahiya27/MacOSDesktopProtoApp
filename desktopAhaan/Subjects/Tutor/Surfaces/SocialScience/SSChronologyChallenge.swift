import SwiftUI

// MARK: - SSChronologyChallenge
//
// Reusable bespoke interactive for the Social Science History chapters: a
// "put history in order" challenge driven by a chapter's authored timeline
// (`ContentTimeline`). Distinct from the read-only `TimelinesSectionView` —
// here the milestones are SCRAMBLED and the learner must tap them back into
// chronological order, getting immediate feedback. Ordering events is exactly
// the skill History chapters build, so this turns a passive timeline into an
// active recall game.
//
// The events are assumed to be authored in chronological order in the pack;
// the widget scrambles them deterministically (a fixed-seed shuffle, so the
// puzzle is stable within a session and never accidentally starts solved).
//
// Big Sur compat: self-contained, @State only, SwiftUI Shapes + system colours
// via Color(red:green:blue:)/compatIndigo, RM-gated motion, VoiceOver labels.
// No macOS 12+ APIs.

struct SSChronologyChallenge: View {
    let timeline: ContentTimeline

    @State private var placed: [Int] = []          // indices placed so far, in tap order
    @State private var wrongTapIndex: Int? = nil    // briefly flags an out-of-order tap
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Steps in their authored (chronological) order.
    private var steps: [TimelineStep] { timeline.steps }

    /// Deterministic scramble of the step indices for the chip row.
    private let scrambled: [Int]

    init(timeline: ContentTimeline) {
        self.timeline = timeline
        self.scrambled = Self.scramble(count: timeline.steps.count)
    }

    /// Fixed-seed shuffle so the puzzle is stable and never starts in order.
    private static func scramble(count n: Int) -> [Int] {
        guard n > 1 else { return Array(0..<max(0, n)) }
        var order = Array(0..<n)
        var seed: UInt64 = 2654435761
        // Fisher–Yates with a small LCG — deterministic, no Date/random.
        var i = n - 1
        while i > 0 {
            seed = seed &* 6364136223846793005 &+ 1442695040888963407
            let j = Int((seed >> 33) % UInt64(i + 1))
            order.swapAt(i, j)
            i -= 1
        }
        // Guarantee it isn't already sorted (would make the puzzle trivial).
        if order == Array(0..<n) { order.reverse() }
        return order
    }

    private var isSolved: Bool { placed.count == steps.count }
    private var nextExpected: Int { placed.count }   // chronological index we want next

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            if !isSolved { chipRow } else { solvedBanner }
            sequenceColumn
            if !placed.isEmpty && !isSolved {
                Button { reset() } label: {
                    Text("Start over")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Color.compatIndigo)
                }
                .buttonStyle(.plain)
                .pointingCursor()
            }
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
        VStack(alignment: .leading, spacing: 4) {
            Text("Put history in order")
                .font(.headline)
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Text("Tap the events from earliest to latest. \(timeline.title)")
                .font(.caption)
                .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// The scrambled, still-unplaced milestones to choose from.
    private var chipRow: some View {
        VStack(spacing: 8) {
            ForEach(scrambled, id: \.self) { idx in
                if !placed.contains(idx) {
                    Button { tap(idx) } label: {
                        HStack {
                            Text(steps[idx].label)
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(DesignTokens.BrandColor.canvasText)
                                .multilineTextAlignment(.leading)
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 8).fill(chipFill(idx)))
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.compatIndigo.opacity(0.25), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .pointingCursor()
                    .accessibilityLabel("Event: \(steps[idx].label)")
                    .accessibilityHint("Tap if this is the earliest remaining event.")
                }
            }
        }
    }

    private func chipFill(_ idx: Int) -> Color {
        if wrongTapIndex == idx { return Color.red.opacity(0.15) }
        return Color.compatIndigo.opacity(0.06)
    }

    /// The chronological sequence the learner has built so far.
    private var sequenceColumn: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(placed.indices, id: \.self) { pos in
                let idx = placed[pos]
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text("\(pos + 1).")
                            .font(.caption.weight(.bold))
                            .foregroundColor(Color.compatIndigo)
                        Text(steps[idx].label)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                    }
                    Text(steps[idx].body)
                        .font(.caption)
                        .foregroundColor(DesignTokens.BrandColor.canvasTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.12)))
            }
        }
    }

    private var solvedBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: SFSymbolCompat.name("checkmark.seal.fill"))
                .foregroundColor(.green)
                .accessibilityHidden(true)
            Text("Perfect timeline! You ordered all \(steps.count) events correctly.")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(DesignTokens.BrandColor.canvasText)
            Spacer(minLength: 0)
            Button { reset() } label: {
                Text("Again")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Color.compatIndigo)
            }
            .buttonStyle(.plain)
            .pointingCursor()
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.14)))
        .accessibilityElement(children: .combine)
    }

    private func tap(_ idx: Int) {
        if idx == nextExpected {
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                placed.append(idx)
                wrongTapIndex = nil
            }
        } else {
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.15)) {
                wrongTapIndex = idx
            }
        }
    }

    private func reset() {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            placed = []
            wrongTapIndex = nil
        }
    }
}
