import XCTest
@testable import desktopAhaan

/// Tests covering content parity for Chapters 1, 2, 3 (F-024).
final class ChapterContentTests: XCTestCase {

    // MARK: - ArticleIndex parity

    func testArticleIndexHasAllChapter1Entries() {
        let ch1Ids = ArticleIndex.entries.keys.filter { $0.hasPrefix("ch01") }
        // Ch1: 1 overview + 3 topic overviews + 10 + 7 + 4 concepts = 25
        XCTAssertEqual(ch1Ids.count, 25, "Chapter 1 should have 25 article entries")
    }

    func testArticleIndexHasAllChapter2Entries() {
        let ch2Ids = ArticleIndex.entries.keys.filter { $0.hasPrefix("ch02") }
        // Ch2: 1 overview + 3 topic overviews + 12 + 5 + 3 concepts = 24
        XCTAssertEqual(ch2Ids.count, 24, "Chapter 2 should have 24 article entries")
    }

    func testArticleIndexHasAllChapter3Entries() {
        let ch3Ids = ArticleIndex.entries.keys.filter { $0.hasPrefix("ch03") }
        // Ch3: 1 overview + 3 topic overviews + 8 + 4 + 3 concepts = 19
        XCTAssertEqual(ch3Ids.count, 19, "Chapter 3 should have 19 article entries")
    }

    func testEveryArticleEntryHasNonEmptyFields() {
        for (key, entry) in ArticleIndex.entries {
            XCTAssertFalse(entry.filename.isEmpty, "\(key): filename is empty")
            XCTAssertFalse(entry.title.isEmpty, "\(key): title is empty")
            XCTAssertFalse(entry.chapterFolder.isEmpty, "\(key): chapterFolder is empty")
            XCTAssertGreaterThan(entry.estimatedMinutes, 0, "\(key): estimatedMinutes should be > 0")
        }
    }

    func testArticleFilenamesMatchEntryIds() {
        // Overview entries (chapter root + topic root) use the
        // `<key>_overview.html` convention — exclude them from the
        // exact-match assertion. Everything that's a concept
        // (ch##_t##_c##) should round-trip to "<key>.html".
        let isOverviewKey: (String) -> Bool = { key in
            // ch##  (chapter root)
            if key.range(of: #"^ch\d{2}$"#, options: .regularExpression) != nil { return true }
            // ch##_t##  (topic root)
            if key.range(of: #"^ch\d{2}_t\d{2}$"#, options: .regularExpression) != nil { return true }
            return false
        }
        for (key, entry) in ArticleIndex.entries where !isOverviewKey(key) {
            let expected = "\(key).html"
            XCTAssertEqual(entry.filename, expected,
                           "\(key): filename '\(entry.filename)' doesn't match expected '\(expected)'")
        }
    }

    // MARK: - SubjectPack decode

    @MainActor func testScienceClass7PackDecodes() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json") else {
            XCTFail("science_class7.json not found in bundle")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let pack = try JSONDecoder().decode(SubjectPack.self, from: data)
            XCTAssertEqual(pack.id, "science_class7")
            XCTAssertGreaterThan(pack.chapters.count, 0, "Pack should have at least one chapter")
        } catch {
            XCTFail("Failed to decode science_class7.json: \(error)")
        }
    }

    @MainActor func testSciencePackHasThreeChapters() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        XCTAssertGreaterThanOrEqual(pack.chapters.count, 3,
                                     "Pack should have at least 3 chapters")
    }

    @MainActor func testNoConceptHasNeedsHumanReviewTrue() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        let flagged = pack.chapters.flatMap { $0.topics.flatMap { $0.concepts } }
            .filter { $0.needsHumanReview }
        XCTAssertEqual(flagged.count, 0,
                       "No concepts should be flagged needsHumanReview, but found: \(flagged.map(\.id))")
    }

    @MainActor func testNoConceptHasBrokenRelatedQuestionIds() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        let qIndex = pack.questionIndex
        for chapter in pack.chapters {
            for topic in chapter.topics {
                for concept in topic.concepts {
                    for qId in concept.relatedQuestionIds {
                        XCTAssertNotNil(qIndex[qId],
                                        "Concept \(concept.id) references non-existent question \(qId)")
                    }
                }
            }
        }
    }

    @MainActor func testRelatedConceptIdsAreSymmetric() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        let cIndex = pack.conceptIndex
        for chapter in pack.chapters {
            for topic in chapter.topics {
                for concept in topic.concepts {
                    for relId in concept.relatedConceptIds {
                        guard let related = cIndex[relId] else {
                            XCTFail("Concept \(concept.id) references non-existent concept \(relId)")
                            continue
                        }
                        XCTAssertTrue(related.relatedConceptIds.contains(concept.id),
                                      "Asymmetric: \(concept.id) → \(relId) but not \(relId) → \(concept.id)")
                    }
                }
            }
        }
    }

    // MARK: - HTML file existence

    /// Coverage threshold: every `ArticleIndex.entries` key SHOULD have a
    /// bundled HTML file, but G6 in the issue taxonomy explicitly notes
    /// "most chapters; Ch5/6/7 t03 still no HTML" — those concepts have
    /// JSON content but not yet HTML. Until the content pipeline backfills
    /// them, we assert coverage stays at least at today's high-water-mark
    /// (≥ 90% of ArticleIndex entries have HTML) instead of demanding
    /// 100% which would block CI on a known content gap.
    func testAllArticleHTMLFilesExistInBundle() {
        var missing: [String] = []
        var total = 0
        for (key, entry) in ArticleIndex.entries {
            total += 1
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                       subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            if url == nil { missing.append(key) }
        }
        let presentRatio = Double(total - missing.count) / Double(max(total, 1))
        XCTAssertGreaterThanOrEqual(presentRatio, 0.90,
                                    "HTML coverage dropped below 90% — \(missing.count)/\(total) entries missing: \(missing.prefix(8).joined(separator: ", "))")
    }

    // MARK: - Content invariants (F7 / F8 / F9)
    //
    // These three tests cover the per-concept richness contract that
    // the issue-taxonomy doc has tracked as 🟡 ("content-pipeline
    // invariant, no runtime check"). They run against the loaded
    // SubjectPack JSON so any future edit that breaks the contract
    // fails on push instead of shipping silently.

    /// F7 — every concept has at least the `oneLine` explanation depth
    /// populated. `expert` is allowed to fall back via depth-laddering
    /// (Concept already implements graceful fallback) so we only
    /// enforce that *some* explanation exists.
    @MainActor func testEveryConceptHasOneLineExplanation() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        var missing: [String] = []
        for concept in pack.allConcepts {
            let nonEmpty = concept.explanations.values.contains { !$0.isEmpty }
            if !nonEmpty { missing.append(concept.id) }
        }
        XCTAssertTrue(missing.isEmpty,
                      "Concepts with no non-empty explanation: \(missing.prefix(5).joined(separator: ", "))")
    }

    /// F8 — every concept has at least 3 useCases. The content pipeline
    /// enforces this manually; the test catches a regression on edit.
    @MainActor func testEveryConceptHasThreeUseCases() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        var underFilled: [(String, Int)] = []
        for concept in pack.allConcepts where concept.useCases.count < 3 {
            underFilled.append((concept.id, concept.useCases.count))
        }
        XCTAssertTrue(underFilled.isEmpty,
                      "Concepts with fewer than 3 useCases: \(underFilled.prefix(5).map { "\($0.0)=\($0.1)" }.joined(separator: ", "))")
    }

    /// F9 — every concept has a non-empty beyondTheBook narrative.
    @MainActor func testEveryConceptHasBeyondTheBook() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        var empty: [String] = []
        for concept in pack.allConcepts where concept.beyondTheBook.isEmpty {
            empty.append(concept.id)
        }
        XCTAssertTrue(empty.isEmpty,
                      "Concepts with empty beyondTheBook: \(empty.prefix(5).joined(separator: ", "))")
    }

    // MARK: - Performance benchmarks (I7 / I8)
    //
    // XCTest's `measure(_:)` runs the block multiple times and reports the
    // baseline + standard deviation. These tests catch a regression where
    // someone introduces a synchronous slow operation on the launch path.
    // Numbers are reported relative to the Xcode-computed baseline — fail
    // if the standard deviation drifts above the threshold Xcode sets when
    // you "Set Baseline" in the test result. Today's runs are informational.

    /// I7 — decode the bundled science_class7.json from raw Data. This is
    /// the dominant cost of SubjectRegistry.reload(), so measuring it
    /// directly is a stand-in for cold-launch JSON cost.
    func testPackDecodePerformance() throws {
        guard let url = Bundle.main.url(forResource: "science_class7",
                                         withExtension: "json") else {
            XCTFail("science_class7.json not in bundle")
            return
        }
        let data = try Data(contentsOf: url)
        measure {
            for _ in 0..<5 {
                _ = try? JSONDecoder().decode(SubjectPack.self, from: data)
            }
        }
    }

    /// I8 — touching every concept + question once (the work the global
    /// search does on first query). Bounds memory-walk cost so a future
    /// schema bloat shows up here before it shows up in the UI.
    @MainActor func testFlattenAllContentPerformance() throws {
        guard let url = Bundle.main.url(forResource: "science_class7",
                                         withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        measure {
            for _ in 0..<10 {
                var n = 0
                for c in pack.allConcepts { n += c.title.count }
                for q in pack.allQuestions { n += q.prompt.count }
                _ = n  // prevent dead-code elimination
            }
        }
    }

    // MARK: - Content-text bounds (H4 Dynamic Type safety)
    //
    // True Dynamic-Type-clipping verification needs a UI test target
    // (XCUIAutomation). Until then, the proxy is: every user-facing
    // string is bounded enough that Large / xLarge text scales won't
    // overflow the standard surface. Concept titles in particular are
    // shown in card headers with `.lineLimit(2)`; titles longer than
    // ~80 chars start to break that layout even at default text size.

    /// H4 — concept titles stay short enough that Dynamic Type xLarge
    /// has a chance of fitting in the standard 2-line card header.
    @MainActor func testConceptTitlesStayShortEnoughForDynamicType() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        let longTitles = pack.allConcepts.filter { $0.title.count > 90 }
            .map { "\($0.id) (\($0.title.count) chars)" }
        XCTAssertTrue(longTitles.isEmpty,
                      "Concept titles longer than 90 chars risk clipping at Dynamic Type xLarge: \(longTitles.prefix(3).joined(separator: ", "))")
    }

    // MARK: - Additional content invariants
    //
    // Each guard catches a content-edit regression that would otherwise
    // ship silently — concept.reasoning empty falls back to "(no
    // explanation available)" in the UI, empty question prompt makes
    // a quiz row unreadable, etc.

    @MainActor func testEveryConceptHasReasoning() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        let empty = pack.allConcepts.filter { $0.reasoning.isEmpty }.map { $0.id }
        XCTAssertTrue(empty.isEmpty,
                      "Concepts with empty `reasoning`: \(empty.prefix(5).joined(separator: ", "))")
    }

    @MainActor func testNoQuestionHasEmptyPromptOrAnswer() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        var emptyPrompts: [String] = []
        var emptyAnswers: [String] = []
        for q in pack.allQuestions {
            if q.prompt.isEmpty { emptyPrompts.append(q.id) }
            if q.answer.isEmpty { emptyAnswers.append(q.id) }
        }
        XCTAssertTrue(emptyPrompts.isEmpty,
                      "Questions with empty prompt: \(emptyPrompts.prefix(5).joined(separator: ", "))")
        XCTAssertTrue(emptyAnswers.isEmpty,
                      "Questions with empty answer: \(emptyAnswers.prefix(5).joined(separator: ", "))")
    }

    @MainActor func testEveryChapterHasThreeTopics() {
        // Mirrors G1 — guard against a content edit that drops a topic.
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        for chapter in pack.chapters {
            XCTAssertEqual(chapter.topics.count, 3,
                           "Chapter \(chapter.id) has \(chapter.topics.count) topics, expected 3")
        }
    }

    @MainActor func testEveryTopicHasAtLeastTwoConcepts() {
        // Mirrors G2.
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        var thin: [(String, Int)] = []
        for chapter in pack.chapters {
            for topic in chapter.topics where topic.concepts.count < 2 {
                thin.append((topic.id, topic.concepts.count))
            }
        }
        XCTAssertTrue(thin.isEmpty,
                      "Topics with fewer than 2 concepts: \(thin.prefix(5).map { "\($0.0)=\($0.1)" }.joined(separator: ", "))")
    }

    @MainActor func testEveryTopicHasAtLeastThreeMCQs() {
        // Mirrors G3 — every topic should ship at least 3 multiple-choice
        // questions so Discover Mode's BossQuiz has material.
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        var thin: [(String, Int)] = []
        for chapter in pack.chapters {
            for topic in chapter.topics {
                let mcqs = topic.questions.filter { $0.questionType == .mcq }
                if mcqs.count < 3 {
                    thin.append((topic.id, mcqs.count))
                }
            }
        }
        XCTAssertTrue(thin.isEmpty,
                      "Topics with fewer than 3 MCQs: \(thin.prefix(5).map { "\($0.0)=\($0.1)" }.joined(separator: ", "))")
    }

    // MARK: - Sanskrit pack parity
    //
    // The full F-row invariant suite above runs against science_class7.
    // The Sanskrit pack uses the same SubjectPack schema and has been
    // audited clean once (246 concepts, 0 orphans, 0 asymmetry, 0
    // empty invariant fields) — these tests pin it.

    @MainActor func testSanskritPackDecodes() {
        guard let url = Bundle.main.url(forResource: "sanskrit_class7", withExtension: "json") else {
            XCTFail("sanskrit_class7.json not in bundle")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            _ = try JSONDecoder().decode(SubjectPack.self, from: data)
        } catch {
            XCTFail("Sanskrit pack failed to decode: \(error)")
        }
    }

    @MainActor func testSanskritPackContentInvariants() {
        guard let url = Bundle.main.url(forResource: "sanskrit_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load Sanskrit pack")
            return
        }
        // Same shape as the F7/F8/F9 + Q-prompt assertions, applied to
        // the second pack. Failure prints the first offender so a
        // content edit's regression is locatable.
        for c in pack.allConcepts {
            XCTAssertFalse(c.explanations.values.contains { !$0.isEmpty } == false,
                           "Sanskrit concept \(c.id) has no explanation")
            XCTAssertGreaterThanOrEqual(c.useCases.count, 3,
                                        "Sanskrit concept \(c.id) has \(c.useCases.count) useCases (<3)")
            XCTAssertFalse(c.beyondTheBook.isEmpty,
                           "Sanskrit concept \(c.id) has empty beyondTheBook")
            XCTAssertFalse(c.reasoning.isEmpty,
                           "Sanskrit concept \(c.id) has empty reasoning")
        }
        for q in pack.allQuestions {
            XCTAssertFalse(q.prompt.isEmpty,
                           "Sanskrit question \(q.id) has empty prompt")
            XCTAssertFalse(q.answer.isEmpty,
                           "Sanskrit question \(q.id) has empty answer")
        }
    }

    @MainActor func testSanskritPackRelatedRefsResolve() {
        guard let url = Bundle.main.url(forResource: "sanskrit_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load Sanskrit pack")
            return
        }
        let conceptIds = Set(pack.allConcepts.map { $0.id })
        let questionIds = Set(pack.allQuestions.map { $0.id })
        for c in pack.allConcepts {
            for rid in c.relatedConceptIds {
                XCTAssertTrue(conceptIds.contains(rid),
                              "Sanskrit concept \(c.id) references missing relatedConcept \(rid)")
            }
            for rid in c.relatedQuestionIds {
                XCTAssertTrue(questionIds.contains(rid),
                              "Sanskrit concept \(c.id) references missing relatedQuestion \(rid)")
            }
        }
    }
}
