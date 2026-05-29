import XCTest
@testable import desktopAhaan

/// Production-grade performance budgets. Unlike
/// `testPackDecodePerformance` in `ChapterContentTests` (which uses
/// XCTest's `measure(_:)` and reports against an Xcode baseline you
/// have to capture in the IDE), these tests assert against
/// **absolute** wall-clock budgets — a fresh CI runner without a
/// stored baseline still catches the regression. They also pin the
/// per-pack chapter / concept / question counts so a content-shrink
/// regression fails CI before it can ship.
///
/// Budgets were chosen from the 2026-05-29 baseline. The Python
/// `scripts/perf_pack_decode.py` benchmark on this machine reports
/// 10–15 ms for the largest pack (science_class7), 2–5 ms for the
/// smaller two. Swift `JSONDecoder` is consistently 2–3× faster
/// than Python `json.load` on the same payload, so the budget
/// (100 ms / pack averaged over 5 decodes) carries ~10× safety
/// margin to absorb CI / iMac slowness. A genuine schema bloat
/// (e.g. doubling the average concept body) shows up here long
/// before the budget is exceeded.
final class PerfBudgetTests: XCTestCase {

    /// Per-pack absolute wall-clock budget for a single JSONDecoder
    /// decode, in milliseconds. Averaged over `decodeIterations`.
    private let perPackDecodeBudgetMs: Double = 100.0
    private let decodeIterations: Int = 5

    func testSciencePackDecodeUnderBudget() throws {
        try assertDecodeWithinBudget("science_class7")
    }

    func testMathsPackDecodeUnderBudget() throws {
        try assertDecodeWithinBudget("maths_class7")
    }

    func testSanskritPackDecodeUnderBudget() throws {
        try assertDecodeWithinBudget("sanskrit_class7")
    }

    /// Pins the per-pack chapter / concept / question counts as of
    /// 2026-05-29. A content-shrink regression (someone removes a
    /// chapter, a topic, or a question) fails here before it can
    /// ship. Future content growth that intentionally raises the
    /// floor must update these constants in the same commit — the
    /// test failure says exactly which counter moved.
    func testPackContentCountsMeetFloor() throws {
        let expected: [(String, Int, Int, Int)] = [
            // (packId, minChapters, minConcepts, minQuestions)
            ("science_class7",   19, 207, 732),
            ("maths_class7",     15,  90, 148),
            ("sanskrit_class7",  16, 121, 122),  // sch-only floors; legacy ch01 vocab adds to runtime totals but is exempt from the per-chapter ratchets
        ]
        for (packId, minChapters, minConcepts, minQuestions) in expected {
            let pack = try loadPack(packId)
            XCTAssertGreaterThanOrEqual(pack.chapters.count, minChapters,
                "[\(packId)] chapter count regressed: \(pack.chapters.count) < \(minChapters)")
            // For sanskrit, scope concept/question floor to NEP sch* chapters
            // — the legacy ch01 vocab deck holds 246 vocab "concepts" that
            // sit outside the NEP curriculum and have their own ratchet
            // elsewhere.
            let scopedChapters = (packId == "sanskrit_class7")
                ? pack.chapters.filter { $0.id.hasPrefix("sch") }
                : pack.chapters
            let conceptCount = scopedChapters.flatMap { $0.topics }
                .flatMap { $0.concepts }.count
            let questionCount = scopedChapters.flatMap { $0.topics }
                .flatMap { $0.questions }.count
            XCTAssertGreaterThanOrEqual(conceptCount, minConcepts,
                "[\(packId)] concept count regressed: \(conceptCount) < \(minConcepts)")
            XCTAssertGreaterThanOrEqual(questionCount, minQuestions,
                "[\(packId)] question count regressed: \(questionCount) < \(minQuestions)")
        }
    }

    // MARK: - Helpers

    private func assertDecodeWithinBudget(_ packId: String) throws {
        guard let url = Bundle.main.url(forResource: packId,
                                        withExtension: "json") else {
            XCTFail("[\(packId)] missing from bundle")
            return
        }
        let data = try Data(contentsOf: url)
        // Warm up the decoder + cache once before timing.
        _ = try? JSONDecoder().decode(SubjectPack.self, from: data)

        var totalSeconds: Double = 0
        for _ in 0..<decodeIterations {
            let t0 = Date()
            _ = try JSONDecoder().decode(SubjectPack.self, from: data)
            totalSeconds += Date().timeIntervalSince(t0)
        }
        let avgMs = (totalSeconds / Double(decodeIterations)) * 1000.0
        XCTAssertLessThanOrEqual(avgMs, perPackDecodeBudgetMs,
            "[\(packId)] decode avg=\(String(format: "%.1f", avgMs))ms over " +
            "\(decodeIterations) iterations — budget is \(perPackDecodeBudgetMs)ms. " +
            "Investigate schema growth or decoder regression."
        )
    }

    private func loadPack(_ id: String) throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: id, withExtension: "json") else {
            throw NSError(domain: "PerfBudgetTests", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "\(id) missing from bundle"])
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
