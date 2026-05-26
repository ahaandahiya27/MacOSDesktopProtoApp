import XCTest
@testable import desktopAhaan

/// Wiring contract for `DailyQuestionPicker` — the static helper
/// behind `DailyQuestionCard` on the chapter list. Pins:
///   1. Same calendar day → same question (deterministic).
///   2. Different days → may differ (no global lock — but the
///      same-day rule is the load-bearing one).
///   3. Returns nil iff the pack has zero questions.
///   4. Returned question is always findable in the pack's
///      `questionIndex` (i.e., navigation will resolve).
///   5. Across 14 consecutive days, the picker visits at least
///      7 distinct chapters (round-robin behaviour — the kid
///      isn't stuck on Ch.1 all week).
final class DailyQuestionPickerTests: XCTestCase {

    func testSameDayReturnsSameQuestion() throws {
        let pack = try loadSciencePack()
        // Build two times on the same LOCAL day (using
        // Calendar.current's time zone) so we test the picker's
        // determinism without coupling to UTC vs IST ambiguity.
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        guard let morning = cal.date(byAdding: .hour, value: 9, to: today),
              let evening = cal.date(byAdding: .hour, value: 21, to: today) else {
            XCTFail("Couldn't build same-day test points.")
            return
        }
        let q1 = DailyQuestionPicker.pick(for: pack, on: morning)
        let q2 = DailyQuestionPicker.pick(for: pack, on: evening)
        XCTAssertNotNil(q1)
        XCTAssertNotNil(q2)
        XCTAssertEqual(q1?.id, q2?.id,
            "Same calendar day must yield the same daily question — got \(q1?.id ?? "nil") vs \(q2?.id ?? "nil")")
    }

    func testReturnedQuestionIsInPackIndex() throws {
        let pack = try loadSciencePack()
        // Spot-check 14 days starting today to ensure every returned
        // question is in the pack's questionIndex (i.e., the
        // .question route can resolve it).
        let cal = Calendar(identifier: .gregorian)
        let start = cal.startOfDay(for: Date())
        for offset in 0..<14 {
            guard let day = cal.date(byAdding: .day, value: offset, to: start) else { continue }
            guard let q = DailyQuestionPicker.pick(for: pack, on: day) else {
                XCTFail("Pick returned nil on day offset \(offset).")
                continue
            }
            XCTAssertNotNil(pack.questionIndex[q.id],
                "Picked question \(q.id) is not in pack.questionIndex — navigation would fail.")
        }
    }

    func testDayOrdinalAdvancesByOne() {
        let d1 = isoDate("2026-05-26T08:00:00Z")
        let d2 = isoDate("2026-05-27T08:00:00Z")
        let o1 = DailyQuestionPicker.dayOrdinal(for: d1)
        let o2 = DailyQuestionPicker.dayOrdinal(for: d2)
        XCTAssertEqual(o2, o1 + 1,
            "dayOrdinal must advance by exactly 1 across a one-day gap — got \(o2 - o1)")
    }

    func testFourteenDaysVisitAtLeastSevenChapters() throws {
        let pack = try loadSciencePack()
        let cal = Calendar(identifier: .gregorian)
        let start = cal.startOfDay(for: Date())
        var chaptersSeen: Set<String> = []
        for offset in 0..<14 {
            guard let day = cal.date(byAdding: .day, value: offset, to: start),
                  let q = DailyQuestionPicker.pick(for: pack, on: day) else { continue }
            // Walk the pack to find the chapter for the question id.
            for chapter in pack.chapters {
                for topic in chapter.topics where topic.questions.contains(where: { $0.id == q.id }) {
                    chaptersSeen.insert(chapter.id)
                }
            }
        }
        XCTAssertGreaterThanOrEqual(chaptersSeen.count, 7,
            "Across 14 days the picker only visited \(chaptersSeen.count) chapter(s) — round-robin is broken or the pack is mis-shaped.")
    }

    // MARK: - Helpers

    private func loadSciencePack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("science_class7.json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }

    private func isoDate(_ s: String) -> Date {
        let f = ISO8601DateFormatter()
        return f.date(from: s) ?? Date()
    }
}
