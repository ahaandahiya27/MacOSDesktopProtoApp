import XCTest
@testable import desktopAhaan

// MARK: - ExpertChallengePlannerTests
//
// v6 Learning Journey · Phase 5. Pure unit tests over the FS-free expert-tier
// classification + unlock logic. No registry, no DataStore.
final class ExpertChallengePlannerTests: XCTestCase {

    private func aq(_ id: String) -> AssessmentQuestion {
        AssessmentQuestion(
            packId: "p1", subjectTitle: "One", chapterTitle: "Ch",
            question: Question(id: id, prompt: "p", questionType: .mcq,
                               options: ["a", "b"], answer: "a", solutionSteps: [],
                               commonMistakes: [], variations: [], difficulty: 4,
                               pageRefs: [], needsHumanReview: false))
    }

    // MARK: - classify

    func testClassifyByBand() {
        XCTAssertEqual(ExpertTier.classify(band: .stretch, isDeepDive: false), .stretch)
        XCTAssertEqual(ExpertTier.classify(band: .challenge, isDeepDive: false), .challenge)
        XCTAssertNil(ExpertTier.classify(band: .easy, isDeepDive: false),
            "Easy questions are not expert-grade.")
        XCTAssertNil(ExpertTier.classify(band: .core, isDeepDive: false),
            "Core questions are not expert-grade.")
    }

    func testClassifyDeepDiveAlwaysOlympiad() {
        XCTAssertEqual(ExpertTier.classify(band: .easy, isDeepDive: true), .olympiad,
            "A deepDive bonus question is always Olympiad, whatever its band.")
        XCTAssertEqual(ExpertTier.classify(band: .challenge, isDeepDive: true), .olympiad)
    }

    func testUnlockThresholdsEscalate() {
        XCTAssertLessThan(ExpertTier.stretch.unlockMastery, ExpertTier.challenge.unlockMastery)
        XCTAssertLessThan(ExpertTier.challenge.unlockMastery, ExpertTier.olympiad.unlockMastery)
        XCTAssertEqual(ExpertTier.stretch.unlockMastery, 0.20, accuracy: 1e-9)
        XCTAssertEqual(ExpertTier.challenge.unlockMastery, 0.50, accuracy: 1e-9)
        XCTAssertEqual(ExpertTier.olympiad.unlockMastery, 0.80, accuracy: 1e-9)
    }

    // MARK: - tierSets

    func testTierSetsAlwaysThreeTiersInOrder() {
        let sets = ExpertChallengePlanner.tierSets(questionsByTier: [:], masteryFraction: 0)
        XCTAssertEqual(sets.map { $0.tier }, [.stretch, .challenge, .olympiad])
        XCTAssertTrue(sets.allSatisfy { $0.questions.isEmpty },
            "No input questions → all tiers present but empty.")
    }

    func testTierSetsUnlockByMastery() {
        let byTier: [ExpertTier: [AssessmentQuestion]] = [
            .stretch: [aq("s1"), aq("s2")],
            .challenge: [aq("c1")],
            .olympiad: [aq("o1")]]

        // Confident (0.55): Stretch + Challenge unlocked, Olympiad still locked.
        let mid = ExpertChallengePlanner.tierSets(questionsByTier: byTier, masteryFraction: 0.55)
        XCTAssertTrue(mid[0].isUnlocked, "Stretch unlocks at 0.20.")
        XCTAssertTrue(mid[1].isUnlocked, "Challenge unlocks at 0.50.")
        XCTAssertFalse(mid[2].isUnlocked, "Olympiad needs 0.80.")
        XCTAssertEqual(mid[0].questions.count, 2)
        XCTAssertTrue(mid[0].isPlayable)
        XCTAssertFalse(mid[2].isPlayable, "Locked tier isn't playable even with questions.")

        // Nothing started: all locked.
        let zero = ExpertChallengePlanner.tierSets(questionsByTier: byTier, masteryFraction: 0)
        XCTAssertTrue(zero.allSatisfy { !$0.isUnlocked })

        // Mastered: everything unlocked.
        let full = ExpertChallengePlanner.tierSets(questionsByTier: byTier, masteryFraction: 1.0)
        XCTAssertTrue(full.allSatisfy { $0.isUnlocked })
        XCTAssertTrue(full[2].isPlayable, "Olympiad with a question is playable once unlocked.")
    }
}
