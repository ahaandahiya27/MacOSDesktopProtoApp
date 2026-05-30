import XCTest
@testable import desktopAhaan

/// Exercises the pure `WorksheetSampler` selection: deterministic count,
/// seed-stable sampling, and seed-sensitivity. No printing / AppKit.
final class PrintableWorksheetSelectionTests: XCTestCase {

    private func mcq(_ i: Int) -> Question {
        Question(id: "q\(i)", prompt: "Question \(i)?", questionType: .mcq,
                 options: ["A\(i)", "B\(i)", "C\(i)", "D\(i)"], answer: "B\(i)",
                 solutionSteps: [], commonMistakes: [], variations: [],
                 difficulty: 2, pageRefs: [], needsHumanReview: false)
    }

    private func pool(_ n: Int) -> [Question] { (0..<n).map(mcq) }

    func testSampleCountIsCappedAtRequested() {
        let picked = WorksheetSampler.sample(pool(30), count: 10, seed: 1)
        XCTAssertEqual(picked.count, 10)
    }

    func testSampleCountCapsAtPoolSize() {
        let picked = WorksheetSampler.sample(pool(7), count: 10, seed: 1)
        XCTAssertEqual(picked.count, 7, "Can't sample more than the pool holds.")
    }

    func testSampleIsDeterministicForSameSeed() {
        let a = WorksheetSampler.sample(pool(30), count: 10, seed: 42)
        let b = WorksheetSampler.sample(pool(30), count: 10, seed: 42)
        XCTAssertEqual(a.map { $0.id }, b.map { $0.id },
                       "Same pool + count + seed → identical sample.")
    }

    func testDifferentSeedsGiveDifferentSample() {
        let a = WorksheetSampler.sample(pool(30), count: 10, seed: 1)
        let b = WorksheetSampler.sample(pool(30), count: 10, seed: 999)
        XCTAssertNotEqual(a.map { $0.id }, b.map { $0.id },
                          "Different seeds should reshuffle (reprints differ).")
    }

    func testSeedFromStringIsStableAndVaries() {
        XCTAssertEqual(WorksheetSampler.seed(from: "2026-05-30 07:00:00"),
                       WorksheetSampler.seed(from: "2026-05-30 07:00:00"))
        XCTAssertNotEqual(WorksheetSampler.seed(from: "2026-05-30 07:00:00"),
                          WorksheetSampler.seed(from: "2026-05-30 07:00:01"))
    }

    func testEmptyPoolOrZeroCountReturnsEmpty() {
        XCTAssertTrue(WorksheetSampler.sample([], count: 10, seed: 1).isEmpty)
        XCTAssertTrue(WorksheetSampler.sample(pool(10), count: 0, seed: 1).isEmpty)
    }

    func testSampleDrawsOnlyFromPool() {
        let poolIds = Set(pool(20).map { $0.id })
        let picked = WorksheetSampler.sample(pool(20), count: 10, seed: 7)
        XCTAssertTrue(picked.allSatisfy { poolIds.contains($0.id) })
        // No duplicates in the sample.
        XCTAssertEqual(Set(picked.map { $0.id }).count, picked.count)
    }

    // MARK: - eligibleMCQs filters non-MCQ + optionless

    /// Build a chapter through the JSON decoder (Topic/Chapter carry custom
    /// decoders / no memberwise init) so the Codable contract is honoured.
    private func decodeChapter(_ json: String) -> Chapter {
        // swiftlint:disable:next force_try — test fixture only.
        try! JSONDecoder().decode(Chapter.self, from: json.data(using: .utf8)!)
    }

    func testEligibleMCQsFiltersNonMcqAndOptionless() {
        let chapter = decodeChapter("""
        {
          "id": "ch01", "number": 1, "title": "C", "summary": "", "pageRefs": [],
          "topics": [{
            "id": "t1", "title": "T", "summary": "", "concepts": [],
            "questions": [
              {"id": "q1", "prompt": "p", "questionType": "mcq",
               "options": ["a","b","c","d"], "answer": "b",
               "solutionSteps": [], "commonMistakes": [], "variations": [],
               "difficulty": 2, "pageRefs": [], "needsHumanReview": false},
              {"id": "q2", "prompt": "p", "questionType": "mcq",
               "answer": "x", "solutionSteps": [], "commonMistakes": [],
               "variations": [], "difficulty": 1, "pageRefs": [], "needsHumanReview": false},
              {"id": "q3", "prompt": "p", "questionType": "shortAnswer",
               "answer": "x", "solutionSteps": [], "commonMistakes": [],
               "variations": [], "difficulty": 1, "pageRefs": [], "needsHumanReview": false}
            ]
          }]
        }
        """)
        XCTAssertEqual(WorksheetSampler.eligibleMCQs(in: chapter).map { $0.id }, ["q1"],
                       "Only the 4-option MCQ is eligible.")
    }
}
