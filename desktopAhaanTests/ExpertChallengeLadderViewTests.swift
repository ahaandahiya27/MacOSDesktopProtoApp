import XCTest
import SwiftUI
@testable import desktopAhaan

// MARK: - ExpertChallengeLadderViewTests
//
// v6 Learning Journey · Phase 5 M2. Smoke-renders the Expert Challenges ladder
// so neither an all-locked world nor a mastered one crashes its SwiftUI body
// under Big-Sur layout.
@MainActor
final class ExpertChallengeLadderViewTests: XCTestCase {

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
            .appendingPathComponent("eclv-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    func testLockedWorldRendersWithoutCrash() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        render(ExpertChallengeLadderView()
            .environmentObject(store)
            .environmentObject(registry))
    }

    func testMasteredWorldRendersWithoutCrash() async throws {
        let registry = try await loadedRegistry()
        let store = tempStore()
        let now = Date()

        // Seed a subject to high mastery so a tier becomes playable; rendering
        // the unlocked ladder must still not crash.
        var reviews: [String: QuestionReview] = [:]
        if let pack = registry.pack(withId: "science_class7") {
            var n = 0
            outer: for chapter in pack.chapters {
                for topic in chapter.topics {
                    for q in topic.questions {
                        reviews[q.id] = QuestionReview(
                            questionId: q.id, bucket: 5, ease: 2.6, intervalDays: 30,
                            lastReviewedAt: now, nextDueAt: now.addingTimeInterval(30 * 86_400),
                            totalReviews: 6, lapses: 0, packId: pack.id)
                        n += 1
                        if n >= 6 { break outer }
                    }
                }
            }
        }
        store.questionReviews = reviews
        render(ExpertChallengeLadderView()
            .environmentObject(store)
            .environmentObject(registry))
    }
}
