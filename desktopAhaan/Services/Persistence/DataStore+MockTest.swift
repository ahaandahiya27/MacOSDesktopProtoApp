import Foundation

// MARK: - Mock Test builder + persistence + SRS recording
//
// v9 Exam Simulation. The `@MainActor` half of the Mock Test feature, in three
// clearly-separated parts:
//
//   • BUILD (`buildMockTest`) — gather eligible MCQs across all four banks
//     (`topics → questions`, `bossQuestions`, `quickCheckQuestions`,
//     `deepDive[*].bonusQuestions`), filter by the difficulty band, order them
//     mastery-gap-first + topic-balanced (`MockTestEngine.topicBalancedOrder`),
//     then apportion across subjects + interleave weak-first by REUSING the v6
//     `MilestoneAssessmentPlanner.compose`. Strictly READ-ONLY over the SRS.
//
//   • PERSIST (`recordMockTestResult` / `loadMockTestResults` / `latest…`) —
//     a capped chronological history in `mock_test_results.json`, reusing the
//     shared atomic `save` / `readFile` plumbing. NEW app state; never the SRS.
//
//   • RECORD (`recordMockTestReviews`) — the ONE deliberate SRS write: each
//     ANSWERED question is fed through the sanctioned `recordEphemeralReview`
//     path (correct → `.good`, wrong → `.forgot`) so a mock test updates the
//     Mastery Map exactly like any other review. Real topic ids resolve
//     normally; already-ephemeral boss / quick-check ids route through the
//     ephemeral resolver; a bonus-question id that resolves to nothing is
//     silently skipped by the existing resolver. No NEW ephemeral prefix is
//     needed (no synthetic ids are minted here).
//
// Big Sur compatible: value types, no macOS 12+ APIs.

extension DataStore {

    static let mockTestResultsFilename = "mock_test_results.json"

    /// Keep the most recent N results so the file can't grow without bound; the
    /// report card needs the latest, plus a short history at most.
    static let mockTestHistoryCap = 50

    /// Neutral SM-2 ease for an unseen question, so never-attempted material
    /// sorts after a reviewed-but-slipped item (whose ease floors near 1.3)
    /// within the same weakest mastery rank.
    static let mockTestUnseenEase = 2.5

    /// The config the Mock Test setup screen opens with: a Quick (15 Q / 20 min)
    /// mixed, balanced paper. Centralised here so the UI default and any
    /// programmatic launch share one definition.
    static func defaultMockTestConfig() -> MockTestConfig {
        MockTestPreset.quick.config(selection: .mixed, band: .balanced)
    }

    // MARK: - Build

    /// Assemble a fresh mock-test paper for `config`. Returns an empty paper
    /// when no eligible question exists for the chosen subjects + band. A thin
    /// pool yields a SHORTER paper (≤ requested count) rather than filler.
    /// READ-ONLY over the SRS.
    func buildMockTest(
        registry: SubjectRegistry?,
        config: MockTestConfig,
        now: Date = Date()
    ) -> MockTestPaper {
        guard let registry = registry else {
            return MockTestPaper(questions: [], config: config, generatedAt: now)
        }

        // Which packs contribute.
        let packs: [SubjectPack]
        switch config.selection {
        case let .single(packId):
            packs = registry.pack(withId: packId).map { [$0] } ?? []
        case .mixed:
            packs = registry.packs
        }
        guard !packs.isEmpty else {
            return MockTestPaper(questions: [], config: config, generatedAt: now)
        }

        let reviews = questionReviews

        // Per-pack: a topic-balanced, gap-first ordered pool + a resolved-question
        // map keyed by the composite paper id.
        var poolsByPack: [String: [String]] = [:]
        var resolved: [String: MockTestQuestion] = [:]

        for pack in packs {
            var candidates: [MockTestEngine.Candidate] = []
            var seenIds = Set<String>()
            var seq = 0

            // One walker for every bank so eligibility + ranking are identical.
            //
            // `@MainActor` on this local function is REQUIRED on Swift 5.5 /
            // Big Sur. The enclosing `buildMockTest(...)` lives in an
            // `extension DataStore` where DataStore is `@MainActor`-isolated,
            // and `Self.isAssessableMCQ` (called below) is `@MainActor`
            // static. Swift 5.5 does NOT propagate the enclosing actor
            // isolation to nested local functions — without this annotation
            // the call to `isAssessableMCQ` is "from outside its actor
            // context [and] implicitly asynchronous", which fails to compile
            // on the deploy iMac (this is exactly the Big-Sur regression
            // class `check_view_mainactor.py` was extended to catch).
            @MainActor
            func consider(_ question: Question, topicKey: String,
                          topicTitle: String, chapter: Chapter, bank: MockTestBank) {
                seq += 1
                guard !seenIds.contains(question.id),
                      Self.isAssessableMCQ(question),
                      config.band.admits(difficulty: question.difficulty)
                else { return }
                seenIds.insert(question.id)

                let rank: Int
                let ease: Double
                if let review = reviews[question.id],
                   review.packId == nil || review.packId == pack.id {
                    rank = MasteryLevel.from(review: review).rawValue
                    ease = review.ease
                } else {
                    rank = MasteryLevel.learning.rawValue
                    ease = Self.mockTestUnseenEase
                }

                candidates.append(MockTestEngine.Candidate(
                    questionId: question.id, topicKey: topicKey,
                    masteryRank: rank, ease: ease, seq: seq))

                let paperId = "\(pack.id)::\(question.id)"
                resolved[paperId] = MockTestQuestion(
                    packId: pack.id, subjectTitle: pack.title,
                    chapterId: chapter.id, chapterTitle: chapter.title,
                    topicKey: topicKey, topicTitle: topicTitle, bank: bank,
                    question: question)
            }

            for chapter in pack.chapters {
                for topic in chapter.topics {
                    for question in topic.questions {
                        consider(question, topicKey: topic.id,
                                 topicTitle: topic.title, chapter: chapter, bank: .topic)
                    }
                }
                let bossKey = "boss::\(chapter.id)"
                let bossTitle = "\(chapter.title) — Boss Quiz"
                for question in chapter.bossQuestionsList {
                    consider(question, topicKey: bossKey, topicTitle: bossTitle,
                             chapter: chapter, bank: .boss)
                }
                let qcKey = "quickcheck::\(chapter.id)"
                let qcTitle = "\(chapter.title) — Quick Check"
                for question in chapter.quickCheckQuestionsList {
                    consider(question, topicKey: qcKey, topicTitle: qcTitle,
                             chapter: chapter, bank: .quickCheck)
                }
                let ddKey = "deepdive::\(chapter.id)"
                let ddTitle = "\(chapter.title) — Deep Dive"
                for stretch in chapter.deepDiveList {
                    for question in (stretch.bonusQuestions ?? []) {
                        consider(question, topicKey: ddKey, topicTitle: ddTitle,
                                 chapter: chapter, bank: .deepDive)
                    }
                }
            }

            guard !candidates.isEmpty else { continue }
            poolsByPack[pack.id] = MockTestEngine.topicBalancedOrder(candidates)
        }

        guard !poolsByPack.isEmpty else {
            return MockTestPaper(questions: [], config: config, generatedAt: now)
        }

        // Subject apportionment + weak-first interleave — REUSE the v6 planner.
        let snapshot = MasteryEngine.snapshot(registry: registry, dataStore: self, now: now)
        let order = JourneyPlanner.subjectFocusOrder(snapshot)
        var weightByPack: [String: Double] = [:]
        for subject in snapshot.subjects {
            weightByPack[subject.packId] = max(0, 1.0 - subject.masteryFraction)
        }
        // A pack with no review signal yet is absent from the snapshot weights;
        // treat it as a maximal gap so unseen subjects aren't frozen out.
        for packId in poolsByPack.keys where weightByPack[packId] == nil {
            weightByPack[packId] = 1.0
        }

        let picks = MilestoneAssessmentPlanner.compose(
            poolsByPack: poolsByPack, weightByPack: weightByPack,
            order: order, total: config.questionCount)

        var questions: [MockTestQuestion] = []
        for pick in picks {
            let paperId = "\(pick.packId)::\(pick.questionId)"
            if let q = resolved[paperId] { questions.append(q) }
        }

        return MockTestPaper(questions: questions, config: config, generatedAt: now)
    }

    // MARK: - Persist (NEW app state, never the SRS)

    /// Hydrate `mockTestResults` from disk at most once per process. The
    /// in-memory copy is the source of truth thereafter, so an append-then-save
    /// never races the asynchronous write.
    func hydrateMockTestResultsIfNeeded() {
        guard !didHydrateMockTestResults else { return }
        didHydrateMockTestResults = true
        mockTestResults = Self.readFile(
            MockTestResult.self, from: Self.mockTestResultsFilename, in: storeDir)
            .items
            .sorted { $0.takenAt < $1.takenAt }
    }

    /// All stored mock-test results, oldest → newest. Empty if none taken yet.
    func loadMockTestResults() -> [MockTestResult] {
        hydrateMockTestResultsIfNeeded()
        return mockTestResults
    }

    /// The most recently completed mock test, or nil if none exist.
    func latestMockTestResult() -> MockTestResult? {
        loadMockTestResults().last
    }

    /// Append a completed result to the in-memory history and persist (atomic),
    /// capped to the most recent `mockTestHistoryCap`. Returns the saved history.
    /// READ-ONLY over the SRS.
    @discardableResult
    func recordMockTestResult(_ result: MockTestResult) -> [MockTestResult] {
        hydrateMockTestResultsIfNeeded()
        mockTestResults.append(result)
        mockTestResults.sort { $0.takenAt < $1.takenAt }
        if mockTestResults.count > Self.mockTestHistoryCap {
            mockTestResults = Array(mockTestResults.suffix(Self.mockTestHistoryCap))
        }
        save(mockTestResults, to: Self.mockTestResultsFilename)
        return mockTestResults
    }

    // MARK: - Record into SRS (the one deliberate write)

    /// Feed each ANSWERED question of a completed mock test through the
    /// sanctioned `recordEphemeralReview` path so the test updates the Mastery
    /// Map. Correct → `.good`, wrong → `.forgot`; unanswered questions are NOT
    /// recorded (a skipped question isn't a failed recall). Returns the number
    /// of reviews recorded. Never mutates the SM-2 scheduler directly.
    @discardableResult
    func recordMockTestReviews(_ result: MockTestResult, at now: Date = Date()) -> Int {
        var recorded = 0
        for outcome in result.outcomes where outcome.isAnswered {
            let quality: ReviewQuality = outcome.isCorrect ? .good : .forgot
            recordEphemeralReview(
                ephemeralId: outcome.questionId, quality: quality,
                at: now, packId: outcome.packId)
            recorded += 1
        }
        return recorded
    }
}
