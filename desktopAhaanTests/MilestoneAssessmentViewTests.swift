import XCTest
import SwiftUI
@testable import desktopAhaan

// MARK: - MilestoneAssessmentViewTests
//
// v6 Learning Journey · Phase 4 M2. Pins the builder's MCQ-gradability filter
// and smoke-renders the Milestone Checkpoint window so neither an empty world
// nor a seeded one crashes its SwiftUI body under Big-Sur layout.
@MainActor
final class MilestoneAssessmentViewTests: XCTestCase {

    // MARK: - isAssessableMCQ filter

    private func mcq(_ id: String, options: [String]?, answer: String,
                     type: QuestionType = .mcq) -> Question {
        Question(id: id, prompt: "p", questionType: type, options: options,
                 answer: answer, solutionSteps: [], commonMistakes: [],
                 variations: [], difficulty: 2, pageRefs: [],
                 needsHumanReview: false)
    }

    func testIsAssessableMCQAcceptsGradableMCQ() {
        XCTAssertTrue(DataStore.isAssessableMCQ(
            mcq("q1", options: ["Delhi", "Mumbai", "Chennai"], answer: "Mumbai")),
            "An MCQ whose options include its answer is gradable.")
        // AnswerValidator normalises case/whitespace, so a formatting-only
        // mismatch still counts as gradable.
        XCTAssertTrue(DataStore.isAssessableMCQ(
            mcq("q2", options: [" mumbai ", "Delhi"], answer: "Mumbai")))
    }

    func testIsAssessableMCQRejectsUngradable() {
        XCTAssertFalse(DataStore.isAssessableMCQ(
            mcq("q3", options: ["Delhi", "Chennai"], answer: "Mumbai")),
            "No option matches the answer → not single-tap gradable.")
        XCTAssertFalse(DataStore.isAssessableMCQ(
            mcq("q4", options: [], answer: "Mumbai")), "Empty options → rejected.")
        XCTAssertFalse(DataStore.isAssessableMCQ(
            mcq("q5", options: nil, answer: "Mumbai")), "Nil options → rejected.")
        XCTAssertFalse(DataStore.isAssessableMCQ(
            mcq("q6", options: ["Mumbai"], answer: "Mumbai", type: .shortAnswer)),
            "A non-MCQ type is never assessable here, even with matching options.")
    }

    // MARK: - Render smoke

    private func render<V: View>(_ view: V) {
        let host = NSHostingView(rootView: view)
        host.frame = NSRect(x: 0, y: 0, width: 680, height: 740)
        host.layoutSubtreeIfNeeded()
        XCTAssertNotNil(host)
    }

    private func loadedRegistry() async throws -> SubjectRegistry {
        let registry = SubjectRegistry()
        for _ in 0..<50 {
            if !registry.isLoading && !registry.packs.isEmpty { break }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        guard !registry.packs.isEmpty else { throw XCTSkip("No packs loaded in 2.5 s.") }
        return registry
    }

    private func tempStore() -> DataStore {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("mav-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    func testEmptyWorldRendersWithoutCrash() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        render(MilestoneAssessmentView()
            .environmentObject(store)
            .environmentObject(registry))
    }

    func testSeededWorldRendersWithoutCrash() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let now = Date()

        // Seed a handful of assessable-MCQ reviews so a non-empty checkpoint can
        // be built; rendering must still not crash.
        var reviews: [String: QuestionReview] = [:]
        if let pack = registry.pack(withId: "science_class7") {
            var n = 0
            outer: for chapter in pack.chapters {
                for topic in chapter.topics {
                    for q in topic.questions where DataStore.isAssessableMCQ(q) {
                        reviews[q.id] = QuestionReview(
                            questionId: q.id, bucket: 1, ease: 2.2, intervalDays: 1,
                            lastReviewedAt: now, nextDueAt: now,
                            totalReviews: 1, lapses: 0, packId: pack.id)
                        n += 1
                        if n >= 6 { break outer }
                    }
                }
            }
        }
        store.questionReviews = reviews
        render(MilestoneAssessmentView()
            .environmentObject(store)
            .environmentObject(registry))
    }
}
