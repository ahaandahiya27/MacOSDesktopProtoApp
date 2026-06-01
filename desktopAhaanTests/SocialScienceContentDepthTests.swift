import XCTest
@testable import desktopAhaan

/// Ratchet for the Social Science (`socialscience_class7`) DEEPENING pass.
///
/// The original build shipped the subject at `DONE`; a long additive
/// deepening pass then completed three content tracks subject-wide:
///   • OLYMPIAD_QUESTIONS — a uniform difficulty-4/5 layer plus boss + quick
///     questions on every chapter (every chapter was diff-3-capped before);
///   • GLOSSARY_ETYMOLOGY — etymology-rich glossary terms, misconception
///     busters and real-world examples on every chapter;
///   • DEEPDIVE — four `StretchTopic` deep-dives + cross-chapter refs weaving
///     the four strands (geography ↔ history ↔ civics ↔ economics) together.
///
/// These tests pin the FLOORS that work reached so a future edit can't quietly
/// regress the depth. They are deliberately lower bounds (`≥`), so continuing
/// to ADD content keeps them green — only deletion / regression turns them red.
/// Floors were measured against the pack at the completion of the DEEPDIVE
/// milestone (2026-06-01): glossary 16–20, deepDive == 4, crossChapterRefs 4–5,
/// misconceptions == 5, realWorldExamples == 5, boss == 13, quick == 5,
/// topic-Q diff≥4 ≥ 4 per chapter, 371 topic questions total.
final class SocialScienceContentDepthTests: XCTestCase {

    // Floors — the minimum the completed tracks reached. Additive work only
    // grows past these; never below.
    private static let minGlossaryPerChapter = 16
    private static let minDeepDivePerChapter = 4
    private static let minCrossChapterRefsPerChapter = 4
    private static let minMisconceptionsPerChapter = 5
    private static let minRealWorldExamplesPerChapter = 5
    private static let minBossQuestionsPerChapter = 13
    private static let minQuickCheckPerChapter = 5
    private static let minOlympiadTopicQsPerChapter = 4   // difficulty ≥ 4
    private static let minTotalTopicQuestions = 371

    // MARK: - GLOSSARY_ETYMOLOGY floor

    func testEveryChapterHasDeepGlossary() throws {
        let pack = try loadSocialSciencePack()
        var thin: [String] = []
        for ch in pack.chapters where ch.glossaryList.count < Self.minGlossaryPerChapter {
            thin.append("\(ch.id)=\(ch.glossaryList.count)")
        }
        XCTAssertTrue(thin.isEmpty,
            "Chapters below the glossary floor (\(Self.minGlossaryPerChapter)): \(thin.joined(separator: ", "))")
    }

    func testEveryGlossaryTermHasTermAndDefinition() throws {
        let pack = try loadSocialSciencePack()
        var offenders: [String] = []
        for ch in pack.chapters {
            for term in ch.glossaryList {
                if term.term.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    || term.definition.trimmingCharacters(in: .whitespacesAndNewlines).count < 10 {
                    offenders.append("\(ch.id):\(term.term)")
                }
            }
        }
        XCTAssertTrue(offenders.isEmpty,
            "Glossary terms with empty term / thin (<10 char) definition: " +
            offenders.prefix(8).joined(separator: ", "))
    }

    func testEveryChapterHasMisconceptionsAndRealWorldExamples() throws {
        let pack = try loadSocialSciencePack()
        var offenders: [String] = []
        for ch in pack.chapters {
            if ch.misconceptionsList.count < Self.minMisconceptionsPerChapter {
                offenders.append("\(ch.id) misconceptions=\(ch.misconceptionsList.count)")
            }
            if ch.realWorldExamplesList.count < Self.minRealWorldExamplesPerChapter {
                offenders.append("\(ch.id) realWorld=\(ch.realWorldExamplesList.count)")
            }
        }
        XCTAssertTrue(offenders.isEmpty,
            "Below misconception/real-world floor: " + offenders.joined(separator: ", "))
    }

    // MARK: - DEEPDIVE floor

    func testEveryChapterHasFourDeepDives() throws {
        let pack = try loadSocialSciencePack()
        var thin: [String] = []
        for ch in pack.chapters where ch.deepDiveList.count < Self.minDeepDivePerChapter {
            thin.append("\(ch.id)=\(ch.deepDiveList.count)")
        }
        XCTAssertTrue(thin.isEmpty,
            "Chapters below the deep-dive floor (\(Self.minDeepDivePerChapter)): \(thin.joined(separator: ", "))")
    }

    func testEveryChapterHasCrossStrandRefs() throws {
        let pack = try loadSocialSciencePack()
        var thin: [String] = []
        for ch in pack.chapters where ch.crossChapterRefsList.count < Self.minCrossChapterRefsPerChapter {
            thin.append("\(ch.id)=\(ch.crossChapterRefsList.count)")
        }
        XCTAssertTrue(thin.isEmpty,
            "Chapters below the cross-chapter-ref floor (\(Self.minCrossChapterRefsPerChapter)): \(thin.joined(separator: ", "))")
    }

    // MARK: - OLYMPIAD_QUESTIONS floor

    func testEveryChapterHasOlympiadDifficultyTopicQuestions() throws {
        let pack = try loadSocialSciencePack()
        var thin: [String] = []
        for ch in pack.chapters {
            let hard = ch.topics.flatMap { $0.questions }.filter { $0.difficulty >= 4 }.count
            if hard < Self.minOlympiadTopicQsPerChapter {
                thin.append("\(ch.id)=\(hard)")
            }
        }
        XCTAssertTrue(thin.isEmpty,
            "Chapters below the Olympiad (diff≥4) topic-Q floor (\(Self.minOlympiadTopicQsPerChapter)): " +
            thin.joined(separator: ", "))
    }

    func testEveryChapterHasBossAndQuickCheckQuestions() throws {
        let pack = try loadSocialSciencePack()
        var offenders: [String] = []
        for ch in pack.chapters {
            if ch.bossQuestionsList.count < Self.minBossQuestionsPerChapter {
                offenders.append("\(ch.id) boss=\(ch.bossQuestionsList.count)")
            }
            if ch.quickCheckQuestionsList.count < Self.minQuickCheckPerChapter {
                offenders.append("\(ch.id) quick=\(ch.quickCheckQuestionsList.count)")
            }
        }
        XCTAssertTrue(offenders.isEmpty,
            "Below boss/quick floor: " + offenders.joined(separator: ", "))
    }

    func testTotalTopicQuestionFloor() throws {
        let pack = try loadSocialSciencePack()
        let total = pack.chapters.flatMap { $0.topics }.flatMap { $0.questions }.count
        XCTAssertGreaterThanOrEqual(total, Self.minTotalTopicQuestions,
            "Total Social Science topic questions \(total) fell below the \(Self.minTotalTopicQuestions) floor.")
    }

    // MARK: - Helper

    private func loadSocialSciencePack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "socialscience_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("socialscience_class7.json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
