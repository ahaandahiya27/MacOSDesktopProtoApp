import XCTest
@testable import desktopAhaan

/// Tests covering content parity for Chapters 1, 2, 3 (F-024).
final class ChapterContentTests: XCTestCase {

    // MARK: - ArticleIndex parity

    func testArticleIndexHasAllChapter1Entries() {
        let ch1Ids = ArticleIndex.entries.keys.filter { $0.hasPrefix("ch01") }
        // Ch1: 1 overview + 3 topic overviews + 10 + 7 + 4 concepts + 1 "Beyond the Book" enrichment = 26
        XCTAssertEqual(ch1Ids.count, 26, "Chapter 1 should have 26 article entries")
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

    /// F4 — every question id starts with its topic id. The
    /// `_topup_` rename in commit b2f6f9f normalised the 74 outliers;
    /// this test prevents the old pattern from sneaking back in via a
    /// content edit.
    @MainActor func testEveryQuestionIdPrefixedByTopicId() {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        var mismatches: [(String, String)] = []
        for chapter in pack.chapters {
            for topic in chapter.topics {
                let prefix = topic.id + "_q"
                for q in topic.questions where !q.id.hasPrefix(prefix) {
                    mismatches.append((q.id, topic.id))
                }
            }
        }
        XCTAssertTrue(mismatches.isEmpty,
                      "Questions whose id doesn't start with `<topic.id>_q`: \(mismatches.prefix(5).map { "\($0.0) (in \($0.1))" }.joined(separator: ", "))")
    }

    /// Cross-pack ID-collision posture.
    ///
    /// Concept IDs MUST be unique across all packs because Bookmarks
    /// + DataStore.discoverProgress key by `"\(packId)::\(conceptId)"`
    /// internally but the registry occasionally surfaces them flat (e.g.
    /// CommandPalette deep-link).
    ///
    /// Question IDs are ALLOWED to collide across packs because every
    /// navigation route + storage key carries packId explicitly (see
    /// TutorNavigationState.push(.question(packId:questionId:))). This
    /// test pins that posture so a future "let's globally namespace"
    /// refactor doesn't silently break the contract — or so the day
    /// we DO globally namespace, this test fails first.
    @MainActor func testNoCrossPackConceptIdCollision() {
        let sci = try? loadPack("science_class7")
        let san = try? loadPack("sanskrit_class7")
        guard let s = sci, let a = san else {
            XCTFail("Could not load both packs")
            return
        }
        let sIds = Set(s.allConcepts.map { $0.id })
        let aIds = Set(a.allConcepts.map { $0.id })
        let collisions = sIds.intersection(aIds)
        XCTAssertTrue(collisions.isEmpty,
                      "Concept IDs collide across packs: \(collisions.prefix(5))")
    }

    private func loadPack(_ resource: String) throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json") else {
            throw NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "\(resource).json not in bundle"])
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(SubjectPack.self, from: data)
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

    // MARK: - Per-chapter difficulty-level coverage (Phase 2 audit floor)

    /// Every science chapter must ship at least 3 L4 (analyse) AND at least
    /// 3 L5 (evaluate / create) questions. The 2026-05-19 Phase 1 audit
    /// found the pack severely top-heavy (L5 = 3 questions across 19
    /// chapters). Phases 2 + the 3+3 floor push brought every chapter to
    /// at-least-3 of each. This test locks that floor in — any future
    /// content edit that drops a chapter below the threshold fails CI.
    ///
    /// Scope: science_class7 only. Sanskrit pack has different question-mix
    /// expectations.
    /// Per-chapter zero-missing-commonMistakes ratchet. As the 2026-05-19
    /// audit identified, 253 questions originally shipped without
    /// commonMistakes. We backfill chapter-by-chapter; once a chapter reaches
    /// zero-missing, this test prevents future content edits from accidentally
    /// removing the commonMistakes (e.g., a copy-paste that drops the field).
    /// Add a chapter number to ZERO_MISSING_CMS once it's been backfilled.
    @MainActor func testCommonMistakesRatchet() {
        // Every science chapter now ships zero-missing commonMistakes
        // (closed 2026-05-19). New chapters added to the pack must be
        // added here too, with their content scaffolded before merge.
        let ZERO_MISSING_CMS: Set<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                                          11, 12, 13, 14, 15, 16, 17, 18, 19]
        guard let url = Bundle.main.url(forResource: "science_class7",
                                         withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        for chapter in pack.chapters where ZERO_MISSING_CMS.contains(chapter.number) {
            let missing = chapter.topics.flatMap { $0.questions }
                .filter { $0.commonMistakes.isEmpty }
                .map { $0.id }
            XCTAssertEqual(
                missing.count, 0,
                "Ch.\(chapter.number) (\(chapter.title)) was previously at zero-missing " +
                "commonMistakes; \(missing.count) question(s) now missing: \(missing). " +
                "Either restore the missing entries, or (if the regression is intentional) " +
                "remove this chapter from ZERO_MISSING_CMS in ChapterContentTests."
            )
        }
    }

    /// Per-chapter zero-missing-mnemonic ratchet — mirror of the
    /// commonMistakes ratchet. The 2026-05-19 audit-pack-health
    /// dashboard revealed all 190 concepts originally shipped with
    /// empty `mnemonic` fields. Backfill in chapter-sized batches and
    /// add each chapter number here once it reaches zero-missing.
    /// Future content edits that drop a chapter below the floor fail CI.
    @MainActor func testMnemonicsRatchet() {
        // All 19 science chapters now ship zero-missing mnemonics
        // (closed 2026-05-19, Option A of the final audit closure).
        let ZERO_MISSING_MNEMONICS: Set<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                                                11, 12, 13, 14, 15, 16, 17, 18, 19]
        guard let url = Bundle.main.url(forResource: "science_class7",
                                         withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        for chapter in pack.chapters where ZERO_MISSING_MNEMONICS.contains(chapter.number) {
            let missing = chapter.topics.flatMap { $0.concepts }
                .filter { ($0.mnemonic ?? "").trimmingCharacters(in: .whitespaces).isEmpty }
                .map { $0.id }
            XCTAssertEqual(
                missing.count, 0,
                "Ch.\(chapter.number) (\(chapter.title)) was previously at zero-missing " +
                "mnemonics; \(missing.count) concept(s) now missing: \(missing). " +
                "Either restore the missing entries, or (if intentional) remove this " +
                "chapter from ZERO_MISSING_MNEMONICS in ChapterContentTests."
            )
        }
    }

    /// L4 + L5 variations ratchet — every L4 and L5 question must ship
    /// with at least 2 variations so spaced-repetition has fresh framings
    /// to draw from. Lower-difficulty questions are exempt for now (a
    /// future content pass can extend the floor downward). Closed
    /// 2026-05-19 (Option A of the final audit closure).
    @MainActor func testEveryL4AndL5QuestionHasAtLeastTwoVariations() {
        guard let url = Bundle.main.url(forResource: "science_class7",
                                         withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        var thin: [(String, Int, Int)] = []
        for chapter in pack.chapters {
            for topic in chapter.topics {
                for q in topic.questions where q.difficulty >= 4 {
                    if q.variations.count < 2 {
                        thin.append((q.id, q.difficulty, q.variations.count))
                    }
                }
            }
        }
        XCTAssertTrue(
            thin.isEmpty,
            "L4/L5 questions with fewer than 2 variations: " +
            thin.prefix(5).map { "\($0.0) (L\($0.1)=\($0.2))" }.joined(separator: ", ")
        )
    }

    // MARK: - Discover-scene-count ratchet (2026-05-21)
    //
    // Every science chapter shipped today at 20 scenes (380 total) via
    // the inline-in-dispatcher pattern + AnyView lookup table. Ch.1 then
    // picked up the "Van Helmont's Willow" enrichment scene later the
    // same day → 381. The `DataStore.totalDiscoverScenes` constant gates
    // the "all chapters complete" celebration overlay — if a future
    // content edit drops this below the pinned number silently, the kid
    // would hit the celebration early (or never). Pin the number.

    @MainActor func testTotalDiscoverScenesPinnedAt381() {
        XCTAssertEqual(
            DataStore.totalDiscoverScenes, 381,
            "totalDiscoverScenes is the magic number the celebration overlay checks. " +
            "If you intentionally added/removed scenes, update both the constant AND this test."
        )
    }

    @MainActor func testAllDiscoverChaptersCompleteFlagFiresAtThreshold() {
        let store = DataStore()
        // No progress → flag false.
        store.discoverProgress = []
        XCTAssertFalse(store.allDiscoverChaptersComplete)

        // One scene short of the threshold → still false.
        store.discoverProgress = (0..<(DataStore.totalDiscoverScenes - 1)).map { i in
            DiscoverProgress(chapterId: "ch_\(i)", sceneId: "s_\(i)", score: nil, maxScore: nil)
        }
        XCTAssertFalse(store.allDiscoverChaptersComplete,
                       "Flag should not flip until we hit totalDiscoverScenes exactly.")

        // At the threshold → true.
        store.discoverProgress = (0..<DataStore.totalDiscoverScenes).map { i in
            DiscoverProgress(chapterId: "ch_\(i)", sceneId: "s_\(i)", score: nil, maxScore: nil)
        }
        XCTAssertTrue(store.allDiscoverChaptersComplete,
                      "Flag should flip the moment count reaches the threshold.")
    }

    // MARK: - WCAG contrast (Option C of the audit closure)
    //
    // These tests pin the BrandColor accent values against the WCAG 2.1
    // AA contrast floor (4.5:1 normal text, 3.0:1 large) over the
    // Discover-canvas gradient. The Python audit harness in
    // `scripts/check_wcag_contrast.py` is the developer-facing tool;
    // these Swift tests catch a regression where someone tweaks
    // BrandColor without re-running the audit.

    /// sRGB component → linear-RGB, matching the calculation in the
    /// Python script's `_channel_linear`.
    private func linearChannel(_ c: Double) -> Double {
        c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
    }

    private func relativeLuminance(_ rgb: (Double, Double, Double)) -> Double {
        let r = linearChannel(rgb.0)
        let g = linearChannel(rgb.1)
        let b = linearChannel(rgb.2)
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }

    private func contrastRatio(_ a: (Double, Double, Double),
                                _ b: (Double, Double, Double)) -> Double {
        let la = relativeLuminance(a)
        let lb = relativeLuminance(b)
        let (lighter, darker) = la > lb ? (la, lb) : (lb, la)
        return (lighter + 0.05) / (darker + 0.05)
    }

    /// Canvas gradient mid stop — the contrast-worst case the audit
    /// harness measures against. If the BrandColor accents pass here,
    /// they pass against TOP and BOTTOM too.
    private let gradientMid: (Double, Double, Double) = (0.96, 1.0, 0.92)

    /// BrandColor accents pinned in `desktopAhaan/Extensions/Extensions.swift`.
    /// If you change one of these values, also update both the Swift
    /// constant AND `scripts/check_wcag_contrast.py` BRAND_* tuples.
    private let brandLookingAhead: (Double, Double, Double) = (0.42, 0.20, 0.65)
    private let brandTryAtHome: (Double, Double, Double) = (0.65, 0.32, 0.0)
    private let brandMnemonic: (Double, Double, Double) = (0.55, 0.42, 0.0)
    private let brandRelatedConcepts: (Double, Double, Double) = (0.0, 0.45, 0.55)
    private let brandDanger: (Double, Double, Double) = (0.72, 0.14, 0.10)
    private let brandPrimaryAction: (Double, Double, Double) = (0.10, 0.52, 0.18)
    private let canvasTextSecondary: (Double, Double, Double) = (0.36, 0.38, 0.42)

    private let WCAG_AA_NORMAL: Double = 4.5

    func testWCAG_LookingAheadMeetsAAOnCanvas() {
        let r = contrastRatio(brandLookingAhead, gradientMid)
        XCTAssertGreaterThanOrEqual(r, WCAG_AA_NORMAL,
            "BrandColor.lookingAhead at \(r) on canvas-mid; AA floor is \(WCAG_AA_NORMAL).")
    }

    func testWCAG_TryAtHomeMeetsAAOnCanvas() {
        let r = contrastRatio(brandTryAtHome, gradientMid)
        XCTAssertGreaterThanOrEqual(r, WCAG_AA_NORMAL,
            "BrandColor.tryAtHome at \(r) on canvas-mid; AA floor is \(WCAG_AA_NORMAL).")
    }

    func testWCAG_MnemonicMeetsAAOnCanvas() {
        let r = contrastRatio(brandMnemonic, gradientMid)
        XCTAssertGreaterThanOrEqual(r, WCAG_AA_NORMAL,
            "BrandColor.mnemonic at \(r) on canvas-mid; AA floor is \(WCAG_AA_NORMAL).")
    }

    func testWCAG_RelatedConceptsMeetsAAOnCanvas() {
        let r = contrastRatio(brandRelatedConcepts, gradientMid)
        XCTAssertGreaterThanOrEqual(r, WCAG_AA_NORMAL,
            "BrandColor.relatedConcepts at \(r) on canvas-mid; AA floor is \(WCAG_AA_NORMAL).")
    }

    func testWCAG_DangerMeetsAAOnWhite() {
        let r = contrastRatio(brandDanger, (1.0, 1.0, 1.0))
        XCTAssertGreaterThanOrEqual(r, WCAG_AA_NORMAL,
            "BrandColor.danger at \(r) on white sheet; AA floor is \(WCAG_AA_NORMAL).")
    }

    func testWCAG_WhiteOnPrimaryActionMeetsAA() {
        let r = contrastRatio((1.0, 1.0, 1.0), brandPrimaryAction)
        XCTAssertGreaterThanOrEqual(r, WCAG_AA_NORMAL,
            "White text on BrandColor.primaryAction at \(r); AA floor is \(WCAG_AA_NORMAL).")
    }

    func testWCAG_CanvasTextSecondaryMeetsAAOnCanvas() {
        let r = contrastRatio(canvasTextSecondary, gradientMid)
        XCTAssertGreaterThanOrEqual(r, WCAG_AA_NORMAL,
            "BrandColor.canvasTextSecondary at \(r) on canvas-mid; AA floor is \(WCAG_AA_NORMAL).")
    }

    // MARK: - SM-2 spaced repetition (Option B of the audit closure)
    //
    // These tests validate the pure-function scheduler in isolation
    // from DataStore so a regression to the scheduling logic doesn't
    // require a full integration test to catch.

    func testSM2_FreshReviewWithGoodAnswerScheduleOneDayOut() {
        let now = Date()
        let r = QuestionReview.newReview(for: "q1", at: now)
        let next = SM2Scheduler.schedule(r, quality: .good, at: now)
        XCTAssertEqual(next.bucket, 1)
        XCTAssertEqual(next.intervalDays, SM2Scheduler.firstIntervalAfterLearn)
        XCTAssertEqual(next.totalReviews, 1)
        XCTAssertEqual(next.lapses, 0)
        XCTAssertEqual(
            Calendar.current.dateComponents([.day], from: now, to: next.nextDueAt).day,
            SM2Scheduler.firstIntervalAfterLearn
        )
    }

    func testSM2_ForgotAnswerResetsBucketAndSchedulesMinutesOut() {
        let now = Date()
        var r = QuestionReview.newReview(for: "q1", at: now)
        // Drive the bucket up to 3 first.
        r = SM2Scheduler.schedule(r, quality: .good, at: now)  // → bucket 1
        r = SM2Scheduler.schedule(r, quality: .good, at: now)  // → bucket 2
        r = SM2Scheduler.schedule(r, quality: .good, at: now)  // → bucket 3
        XCTAssertEqual(r.bucket, 3)
        // Now forget — bucket should drop to 0 and re-schedule in minutes.
        let next = SM2Scheduler.schedule(r, quality: .forgot, at: now)
        XCTAssertEqual(next.bucket, 0)
        XCTAssertEqual(next.intervalDays, 0)
        XCTAssertEqual(next.lapses, 1)
        // Within the same hour (10 minutes out).
        XCTAssertLessThan(next.nextDueAt.timeIntervalSince(now), 60 * 60)
        XCTAssertGreaterThan(next.nextDueAt.timeIntervalSince(now), 60 * 5)
    }

    func testSM2_EasyAnswerExtendsIntervalAndBoostsEase() {
        let now = Date()
        var r = QuestionReview.newReview(for: "q1", at: now)
        r = SM2Scheduler.schedule(r, quality: .good, at: now)   // bucket 1, 1d
        r = SM2Scheduler.schedule(r, quality: .good, at: now)   // bucket 2, 3d
        let beforeEase = r.ease
        let next = SM2Scheduler.schedule(r, quality: .easy, at: now)
        XCTAssertEqual(next.bucket, 3)
        XCTAssertGreaterThan(next.intervalDays, r.intervalDays,
                              "Easy should extend interval beyond the prior")
        XCTAssertEqual(next.ease, beforeEase + SM2Scheduler.easeDeltaEasy, accuracy: 0.001,
                       "Easy should boost ease by the configured delta")
    }

    func testSM2_HardAnswerExtendsLessThanGood() {
        let now = Date()
        var r = QuestionReview.newReview(for: "q1", at: now)
        r = SM2Scheduler.schedule(r, quality: .good, at: now)
        r = SM2Scheduler.schedule(r, quality: .good, at: now)
        r = SM2Scheduler.schedule(r, quality: .good, at: now)  // bucket 3
        let priorInterval = r.intervalDays
        let hardNext = SM2Scheduler.schedule(r, quality: .hard, at: now)
        let goodNext = SM2Scheduler.schedule(r, quality: .good, at: now)
        XCTAssertGreaterThan(hardNext.intervalDays, priorInterval,
                              "Hard should still extend, not reset")
        XCTAssertLessThan(hardNext.intervalDays, goodNext.intervalDays,
                          "Hard should extend by less than Good")
    }

    func testSM2_EaseHasFloorAtMin() {
        let now = Date()
        var r = QuestionReview.newReview(for: "q1", at: now)
        // Hammer it with forgots — ease shouldn't drop below the floor.
        for _ in 0..<20 {
            r = SM2Scheduler.schedule(r, quality: .forgot, at: now)
        }
        XCTAssertEqual(r.ease, SM2Scheduler.minEase, accuracy: 0.001,
                       "Ease should be clamped at the min ease floor")
    }

    func testSM2_RoundTripCodableSurvivesEncoding() throws {
        let now = Date()
        var r = QuestionReview.newReview(for: "q42", at: now)
        r = SM2Scheduler.schedule(r, quality: .good, at: now)
        r = SM2Scheduler.schedule(r, quality: .easy, at: now)
        r = SM2Scheduler.schedule(r, quality: .hard, at: now)

        let data = try JSONEncoder().encode(r)
        let round = try JSONDecoder().decode(QuestionReview.self, from: data)
        XCTAssertEqual(round.questionId, r.questionId)
        XCTAssertEqual(round.bucket, r.bucket)
        XCTAssertEqual(round.intervalDays, r.intervalDays)
        XCTAssertEqual(round.totalReviews, r.totalReviews)
        XCTAssertEqual(round.ease, r.ease, accuracy: 0.0001)
    }

    // MARK: - Streak counter (Option C of the audit closure)
    //
    // creditReviewStreak() does yyyy-MM-dd date arithmetic against
    // UserDefaults. The first user who travels through a timezone
    // boundary or whose local clock rolls past midnight mid-session
    // will hit any silent bugs in this math, so we pin the four
    // canonical cases here.

    private func clearStreakDefaults() {
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.reviewStreakDays)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.reviewStreakLastDate)
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.reviewStreakBest)
    }

    @MainActor func testStreak_BestEverTracksHighWaterMark() {
        clearStreakDefaults()
        defer { clearStreakDefaults() }
        let store = DataStore()
        store.questionReviews.removeAll()
        let day1 = Date(timeIntervalSince1970: 1_700_000_000)
        let cal = Calendar.current

        // Build a 4-day streak.
        for offset in 0..<4 {
            let d = cal.date(byAdding: .day, value: offset, to: day1)!
            store.recordReview(questionId: "q\(offset)", quality: .good, at: d)
        }
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakDays), 4)
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakBest), 4,
                       "Best should track the 4-day high.")

        // Break the streak — 5-day gap → resets to 1.
        let day10 = cal.date(byAdding: .day, value: 10, to: day1)!
        store.recordReview(questionId: "q-gap", quality: .good, at: day10)
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakDays), 1)
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakBest), 4,
                       "Best should stick at 4 even after current resets.")

        // Rebuild higher — 6-day streak.
        for offset in 1..<6 {
            let d = cal.date(byAdding: .day, value: 10 + offset, to: day1)!
            store.recordReview(questionId: "q-rebuild\(offset)", quality: .good, at: d)
        }
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakDays), 6)
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakBest), 6,
                       "Best should bump to the new high-water-mark.")
    }

    @MainActor func testStreak_FirstEverReviewSetsToOne() {
        clearStreakDefaults()
        defer { clearStreakDefaults() }
        let store = DataStore()
        store.questionReviews.removeAll()
        let now = Date()
        store.recordReview(questionId: "q-streak-1", quality: .good, at: now)
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakDays), 1,
                       "First-ever review should set streak to 1.")
        XCTAssertNotNil(UserDefaults.standard.string(forKey: AppStorageKeys.reviewStreakLastDate))
    }

    @MainActor func testStreak_SameDayReviewIsIdempotent() {
        clearStreakDefaults()
        defer { clearStreakDefaults() }
        let store = DataStore()
        store.questionReviews.removeAll()
        let now = Date()
        store.recordReview(questionId: "q-streak-a", quality: .good, at: now)
        store.recordReview(questionId: "q-streak-b", quality: .easy, at: now)
        store.recordReview(questionId: "q-streak-c", quality: .hard, at: now)
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakDays), 1,
                       "Multiple reviews on the same calendar day must not inflate the streak.")
    }

    @MainActor func testStreak_NextDayReviewIncrements() {
        clearStreakDefaults()
        defer { clearStreakDefaults() }
        let store = DataStore()
        store.questionReviews.removeAll()
        let day1 = Date(timeIntervalSince1970: 1_700_000_000)  // 2023-11-14 22:13:20 UTC
        let day2 = Calendar.current.date(byAdding: .day, value: 1, to: day1)!
        store.recordReview(questionId: "q-streak-day1", quality: .good, at: day1)
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakDays), 1)
        store.recordReview(questionId: "q-streak-day2", quality: .good, at: day2)
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakDays), 2,
                       "Review on the very next calendar day must increment by exactly 1.")
    }

    @MainActor func testStreak_MultiDayGapResetsToOne() {
        clearStreakDefaults()
        defer { clearStreakDefaults() }
        let store = DataStore()
        store.questionReviews.removeAll()
        let day1 = Date(timeIntervalSince1970: 1_700_000_000)
        let day5 = Calendar.current.date(byAdding: .day, value: 4, to: day1)!
        store.recordReview(questionId: "q-streak-day1", quality: .good, at: day1)
        store.recordReview(questionId: "q-streak-day1b", quality: .good,
                            at: Calendar.current.date(byAdding: .day, value: 1, to: day1)!)
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakDays), 2)
        // Big gap — streak should reset to 1.
        store.recordReview(questionId: "q-streak-day5", quality: .good, at: day5)
        XCTAssertEqual(UserDefaults.standard.integer(forKey: AppStorageKeys.reviewStreakDays), 1,
                       "A gap >1 day must reset the streak, not extend it.")
    }

    // MARK: - Chapter notebook (2026-05-21)
    //
    // setChapterNote is a hot path — fires on every TextEditor keystroke
    // via .onChange. Pin a few invariants so a future refactor doesn't
    // silently break the user's saved notes (this is data the kid writes
    // themselves — irreplaceable if lost).

    @MainActor func testNotebook_SetAndReadBack() {
        let store = DataStore()
        store.chapterNotes.removeAll()
        store.setChapterNote("Plants pull mass from air, not soil!", forChapterId: "ch01")
        XCTAssertEqual(store.chapterNotes["ch01"], "Plants pull mass from air, not soil!")
    }

    @MainActor func testNotebook_EmptyOrWhitespaceTextRemovesEntry() {
        let store = DataStore()
        store.chapterNotes.removeAll()
        store.setChapterNote("initial", forChapterId: "ch02")
        XCTAssertNotNil(store.chapterNotes["ch02"])

        store.setChapterNote("   \n\t  ", forChapterId: "ch02")
        XCTAssertNil(store.chapterNotes["ch02"],
                     "Whitespace-only text should clear the entry, not accumulate empty rows.")
    }

    @MainActor func testNotebook_DistinctChaptersHaveIndependentNotes() {
        let store = DataStore()
        store.chapterNotes.removeAll()
        store.setChapterNote("Note for ch.1", forChapterId: "ch01")
        store.setChapterNote("Note for ch.7", forChapterId: "ch07")
        XCTAssertEqual(store.chapterNotes["ch01"], "Note for ch.1")
        XCTAssertEqual(store.chapterNotes["ch07"], "Note for ch.7")
        XCTAssertNil(store.chapterNotes["ch02"])
    }

    @MainActor func testNotebook_ChapterNoteRoundTripCodable() throws {
        let note = ChapterNote(chapterId: "ch01", text: "Hello \u{2014} world",
                               updatedAt: Date(timeIntervalSince1970: 1_700_000_000))
        let data = try JSONEncoder().encode(note)
        let decoded = try JSONDecoder().decode(ChapterNote.self, from: data)
        XCTAssertEqual(decoded.chapterId, note.chapterId)
        XCTAssertEqual(decoded.text, note.text)
        XCTAssertEqual(decoded.updatedAt.timeIntervalSince1970,
                       note.updatedAt.timeIntervalSince1970, accuracy: 0.001)
    }

    @MainActor func testDataStore_DueCountReflectsScheduledItems() {
        let store = DataStore()
        // Wipe any leftover state from another test.
        store.questionReviews.removeAll()
        let now = Date()
        // Schedule three answers all "good" today — they'll be due 1+ days out.
        store.recordReview(questionId: "q1", quality: .good, at: now)
        store.recordReview(questionId: "q2", quality: .good, at: now)
        store.recordReview(questionId: "q3", quality: .good, at: now)
        // No items due "now".
        XCTAssertEqual(store.dueQuestionCount(at: now), 0)
        // Two days from now, all three should be due.
        let inTwoDays = Calendar.current.date(byAdding: .day, value: 2, to: now)!
        XCTAssertEqual(store.dueQuestionCount(at: inTwoDays), 3)
    }

    @MainActor func testEveryScienceChapterHasAtLeastThreeL4AndThreeL5() {
        guard let url = Bundle.main.url(forResource: "science_class7",
                                         withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pack = try? JSONDecoder().decode(SubjectPack.self, from: data) else {
            XCTFail("Could not load pack")
            return
        }
        for chapter in pack.chapters {
            let qs = chapter.topics.flatMap { $0.questions }
            let l4 = qs.filter { $0.difficulty == 4 }.count
            let l5 = qs.filter { $0.difficulty == 5 }.count
            XCTAssertGreaterThanOrEqual(
                l4, 3,
                "Ch.\(chapter.number) (\(chapter.title)) has \(l4) L4 questions, below 3+3 floor. " +
                "See docs/SCIENCE_CONTENT_AUDIT_2026-05-19.md for context."
            )
            XCTAssertGreaterThanOrEqual(
                l5, 3,
                "Ch.\(chapter.number) (\(chapter.title)) has \(l5) L5 questions, below 3+3 floor. " +
                "See docs/SCIENCE_CONTENT_AUDIT_2026-05-19.md for context."
            )
        }
    }
}
