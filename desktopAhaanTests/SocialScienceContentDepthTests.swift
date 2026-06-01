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

    // MARK: - ARTICLES-in-sync ratchet
    //
    // The article HTML is a GENERATED artifact (generate_socialscience_articles.py
    // --write). It once drifted stale: the generator was run in its default
    // dry-run mode, so glossary/deepDive enrichment never reached the bundled
    // reading articles. These tests pin the articles to the pack so that gap
    // can never silently reopen.

    /// Each chapter's Vocabulary Deck article must reflect the CURRENT pack
    /// glossary size — the generator emits "The N terms to know" with N =
    /// glossary count. A stale article (regenerated without --write after the
    /// pack grew) would carry the old N and fail here.
    func testGlossaryArticlesReflectPackTermCount() throws {
        let pack = try loadSocialSciencePack()
        var stale: [String] = []
        for ch in pack.chapters {
            guard let html = loadArticleHTML(chapterId: ch.id, suffix: "_glossary", number: ch.number) else {
                throw XCTSkip("\(ch.id)_glossary.html not in test bundle.")
            }
            let needle = "The \(ch.glossaryList.count) terms to know"
            if !html.contains(needle) {
                stale.append("\(ch.id) (expected \"\(needle)\")")
            }
        }
        XCTAssertTrue(stale.isEmpty,
            "Glossary articles out of sync with the pack (re-run generate_socialscience_articles.py --write): " +
            stale.joined(separator: ", "))
    }

    /// Every chapter carries ≥4 crossChapterRefs, so its Beyond-the-Book
    /// article must render the "Connect across chapters" section that links
    /// them. Pins the cross-strand reading-flow enhancement.
    func testBeyondArticlesCarryConnectSection() throws {
        let pack = try loadSocialSciencePack()
        var missing: [String] = []
        for ch in pack.chapters where !ch.crossChapterRefsList.isEmpty {
            guard let html = loadArticleHTML(chapterId: ch.id, suffix: "_beyond", number: ch.number) else {
                throw XCTSkip("\(ch.id)_beyond.html not in test bundle.")
            }
            if !html.contains("Connect across chapters") {
                missing.append(ch.id)
            }
        }
        XCTAssertTrue(missing.isEmpty,
            "Beyond-the-Book articles missing the cross-chapter links section: " +
            missing.joined(separator: ", "))
    }

    /// The cycle-77 "Challenge Problems" (`_olympiad`) article gathers every
    /// diff≥4 topic question into the reading flow with a worked solution. Pin
    /// the article to the pack: it must render exactly one "Challenge N" section
    /// per diff≥4 question (≥ the Olympiad floor), so a stale regen (no --write)
    /// or an empty page can't silently ship.
    func testOlympiadArticlesCarryEveryChallenge() throws {
        let pack = try loadSocialSciencePack()
        var mismatched: [String] = []
        for ch in pack.chapters {
            let hard = ch.topics.flatMap { $0.questions }.filter { $0.difficulty >= 4 }.count
            guard let html = loadArticleHTML(chapterId: ch.id, suffix: "_olympiad", number: ch.number) else {
                throw XCTSkip("\(ch.id)_olympiad.html not in test bundle.")
            }
            let rendered = html.components(separatedBy: "<h2>Challenge ").count - 1
            if rendered != hard || rendered < Self.minOlympiadTopicQsPerChapter {
                mismatched.append("\(ch.id) rendered=\(rendered) pack=\(hard)")
            }
        }
        XCTAssertTrue(mismatched.isEmpty,
            "Challenge Problems articles out of sync with the pack's diff≥4 questions " +
            "(re-run generate_socialscience_articles.py --write): " + mismatched.joined(separator: ", "))
    }

    private func loadArticleHTML(chapterId: String, suffix: String, number: Int) -> String? {
        let name = "\(chapterId)\(suffix)"
        let url = Bundle.main.url(forResource: name, withExtension: "html",
                                  subdirectory: "Articles/SocialScienceChapter\(number)")
            ?? Bundle.main.url(forResource: name, withExtension: "html")
        guard let url = url, let text = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        return text
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
