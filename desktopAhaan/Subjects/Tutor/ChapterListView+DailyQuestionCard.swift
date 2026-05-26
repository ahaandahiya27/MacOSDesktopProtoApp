import SwiftUI
import AppKit

/// "Today's question" card surfaced on `ChapterListView` between the
/// "Continue where you left off" section and the "All chapters" list.
/// Picks one question from the science pack deterministically by the
/// current date so the same question shows all day, and a different
/// one shows tomorrow. Tapping the card opens the question in the
/// usual `QuestionDetailView` route, which means the kid can use
/// the existing hint ladder / mastery-tracking flow on it.
///
/// Auto-hides when the pack has no questions (defensive — every
/// science chapter has 25+ as of 2026-05-26, but the gate keeps
/// the card from showing as an empty box if a future content prune
/// strips them).
///
/// Lives in a sister file so `ChapterListView.swift` stays well
/// under the 600-LOC Big Sur ceiling. Mirrors the sister-file
/// pattern used by `ChapterDetailView+ExtraReadingRow.swift`.
struct DailyQuestionCard: View {
    let pack: SubjectPack
    /// Optional override so unit tests can pin the date. In normal
    /// use, defaults to today.
    var date: Date = Date()

    @EnvironmentObject private var nav: TutorNavigationState

    var body: some View {
        if let question = DailyQuestionPicker.pick(for: pack, on: date) {
            Button {
                nav.push(.question(packId: pack.id, questionId: question.id))
            } label: {
                HStack(alignment: .top, spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.compatPurple.opacity(0.18))
                            .frame(width: 44, height: 44)
                        Image(systemName: SFSymbolCompat.name("sparkles"))
                            .font(.title3)
                            .foregroundColor(Color.compatPurple)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today's question")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                        Text(question.prompt)
                            .font(.headline)
                            .foregroundColor(DesignTokens.BrandColor.canvasText)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("Tap to try it — uses the same hint ladder you already know.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: SFSymbolCompat.name("chevron.right"))
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary.opacity(0.6))
                        .accessibilityHidden(true)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(NSColor.controlBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color.compatPurple.opacity(0.25), lineWidth: 1)
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .pointingCursor()
            .accessibilityLabel("Today's question: \(question.prompt)")
            .accessibilityHint("Opens this question in the usual question detail view.")
        }
    }
}

/// Pure picker — exposed as a static helper so the routing test
/// can call it without spinning up SwiftUI. Determinism rules:
///   1. Returns `nil` iff the pack has zero questions.
///   2. For the same `date.startOfDay`, returns the same question.
///   3. For consecutive days, walks the question pool round-robin
///      ordered by chapter → topic → question, so the kid sees
///      varied chapters across the week (vs. always Ch.1).
enum DailyQuestionPicker {
    /// Round-robin walk: day N picks chapter (N mod numChapters),
    /// question (N div numChapters mod numQuestionsInThatChapter).
    /// So 19 consecutive days cycle through all 19 chapters,
    /// surfacing one question per chapter — the kid sees variety
    /// across the week instead of being stuck on Ch.1 questions
    /// for 35 days straight.
    static func pick(for pack: SubjectPack, on date: Date) -> Question? {
        let chapters = pack.chapters.filter { ch in
            !ch.topics.flatMap { $0.questions }.isEmpty
        }
        guard !chapters.isEmpty else { return nil }
        let dayIndex = dayOrdinal(for: date)
        let chapter = chapters[dayIndex % chapters.count]
        let qs = chapter.topics.flatMap { $0.questions }
        let qIdx = (dayIndex / chapters.count) % qs.count
        return qs[qIdx]
    }

    /// Days since the Unix epoch in the user's calendar — robust
    /// against daylight-saving transitions because we anchor to
    /// the calendar's start-of-day, not raw seconds. Returns the
    /// same integer for every clock-tick within a single local
    /// day, which is what the picker needs to keep the same
    /// question visible all day.
    static func dayOrdinal(for date: Date) -> Int {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone.current
        let start = cal.startOfDay(for: date)
        let epoch = Date(timeIntervalSince1970: 0)
        let components = cal.dateComponents([.day], from: cal.startOfDay(for: epoch),
                                            to: start)
        return components.day ?? 0
    }
}
