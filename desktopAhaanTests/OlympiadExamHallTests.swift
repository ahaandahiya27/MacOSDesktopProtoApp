import XCTest
@testable import desktopAhaan

/// Exam-hall tier of tests: the in-progress autosave store + the score
/// report renderer. Each test gets a unique temp `storeDir` so writes
/// don't leak between cases. `autoLoad: false` skips the cold-launch
/// off-thread read.
@MainActor
final class OlympiadExamHallTests: XCTestCase {

    // MARK: - In-progress store

    private func tempStore() -> DataStore {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("oly-ip-\(UUID().uuidString)")
        return DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
    }

    private func record(
        paperId: String = "olympiad_science_ch13",
        currentIndex: Int = 12,
        selectedCount: Int = 5,
        startedAt: Date = Date(timeIntervalSince1970: 1_700_000_000)
    ) -> OlympiadInProgress {
        var picks: [String: String] = [:]
        for i in 0..<selectedCount {
            picks["q\(i+1)"] = ["A", "B", "C", "D"][i % 4]
        }
        return OlympiadInProgress(
            paperId: paperId,
            selectedByQuestionId: picks,
            markedForReviewQuestionIds: ["q3", "q11"],
            currentIndex: currentIndex,
            startedAt: startedAt,
            lastUpdatedAt: Date()
        )
    }

    func testSaveAndReadOneInProgress() {
        let store = tempStore()
        let r = record()
        store.saveOlympiadInProgress(r)
        let read = store.inProgressOlympiad(forPaperId: r.paperId)
        XCTAssertEqual(read?.paperId, r.paperId)
        XCTAssertEqual(read?.currentIndex, 12)
        XCTAssertEqual(read?.selectedByQuestionId.count, 5)
        XCTAssertEqual(Set(read?.markedForReviewQuestionIds ?? []), ["q3", "q11"])
    }

    func testUnknownPaperReturnsNil() {
        let store = tempStore()
        store.saveOlympiadInProgress(record(paperId: "olympiad_science_ch13"))
        XCTAssertNil(store.inProgressOlympiad(forPaperId: "olympiad_maths_ch01"))
    }

    func testSavingSamePaperOverwrites() {
        let store = tempStore()
        store.saveOlympiadInProgress(record(currentIndex: 4))
        store.saveOlympiadInProgress(record(currentIndex: 17))
        let read = store.inProgressOlympiad(forPaperId: "olympiad_science_ch13")
        XCTAssertEqual(read?.currentIndex, 17)
    }

    func testMultiplePapersCoexist() {
        let store = tempStore()
        store.saveOlympiadInProgress(record(paperId: "olympiad_science_ch13", currentIndex: 8))
        store.saveOlympiadInProgress(record(paperId: "olympiad_maths_ch15", currentIndex: 22))
        XCTAssertEqual(store.inProgressOlympiad(forPaperId: "olympiad_science_ch13")?.currentIndex, 8)
        XCTAssertEqual(store.inProgressOlympiad(forPaperId: "olympiad_maths_ch15")?.currentIndex, 22)
    }

    func testClearRemovesRecord() {
        let store = tempStore()
        store.saveOlympiadInProgress(record())
        store.clearOlympiadInProgress(forPaperId: "olympiad_science_ch13")
        XCTAssertNil(store.inProgressOlympiad(forPaperId: "olympiad_science_ch13"))
    }

    func testInProgressSurvivesStoreReload() {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("oly-ip-rt-\(UUID().uuidString)")
        let s1 = DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
        s1.saveOlympiadInProgress(record(currentIndex: 33))
        s1.flushSavesBeforeQuit()

        let s2 = DataStore(streakCalendar: nil, storeDir: dir, autoLoad: false)
        let read = s2.inProgressOlympiad(forPaperId: "olympiad_science_ch13")
        XCTAssertEqual(read?.currentIndex, 33)
        XCTAssertEqual(read?.selectedByQuestionId.count, 5)
    }

    // MARK: - Score report renderer

    private func paper() -> OlympiadPaper {
        OlympiadPaper(
            id: "olympiad_test_demo",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 13,
            chapterTitle: "Motion and Time",
            displayTitle: "Motion and Time — 60 MCQ Olympiad",
            questionPaperMD: "demo_qp.md",
            solutionsMD: "demo_sol.md",
            questionPaperHTML: "demo.html",
            questionPaperPDF: "demo.pdf",
            suggestedTimeMinutes: 90
        )
    }

    private func threeQuestions() -> [OlympiadQuestion] {
        [
            OlympiadQuestion(id: "q1", number: 1, stem: "What is 2+2?",
                             options: ["3","4","5","6"], correctAnswer: "B",
                             explanation: "Addition: 2+2 = 4."),
            OlympiadQuestion(id: "q2", number: 2, stem: "Capital of France?",
                             options: ["Paris","Lyon","Marseille","Nice"], correctAnswer: "A",
                             explanation: "Paris is the capital."),
            OlympiadQuestion(id: "q3", number: 3, stem: "Speed = distance / ?",
                             options: ["mass","time","force","area"], correctAnswer: "B",
                             explanation: "Speed equals distance divided by time."),
        ]
    }

    func testTallyComputation() {
        let tally = OlympiadScoreReportRenderer.computeTally(
            paper: paper(),
            questions: threeQuestions(),
            selectedByQuestionId: ["q1": "B", "q2": "C"]  // 1 right, 1 wrong, 1 skipped
        )
        XCTAssertEqual(tally.correct, 1)
        XCTAssertEqual(tally.wrong, 1)
        XCTAssertEqual(tally.skipped, 1)
        // +4 for correct, −1 for wrong, 0 for skipped → 3
        XCTAssertEqual(tally.scoreOutOfMax, 3)
    }

    func testReportHTMLContainsCorrectAndWrongCues() {
        let html = OlympiadScoreReportRenderer.render(
            paper: paper(),
            questions: threeQuestions(),
            selectedByQuestionId: ["q1": "B", "q2": "C"]
        )
        XCTAssertTrue(html.contains("<title>Score Report — Motion and Time</title>"),
                      "Title should reflect chapter")
        XCTAssertTrue(html.contains("q correct"), "Correct row should carry CSS class")
        XCTAssertTrue(html.contains("q wrong"), "Wrong row should carry CSS class")
        XCTAssertTrue(html.contains("q skipped"), "Skipped row should carry CSS class")
        // The kid's wrong pick on q2 should be highlighted as "your answer"
        XCTAssertTrue(html.contains("your answer"), "Should mark kid's chosen option")
    }

    func testReportHTMLOmitsExplanationForCorrectAnswers() {
        let html = OlympiadScoreReportRenderer.render(
            paper: paper(),
            questions: threeQuestions(),
            selectedByQuestionId: ["q1": "B", "q2": "A", "q3": "B"]  // all 3 correct
        )
        // All correct → no Working section for any of them by default.
        XCTAssertFalse(html.contains("<h4>Working</h4>"),
                       "Worked solutions shouldn't appear when all answers are correct")
    }

    func testReportHTMLEscapesAngleBrackets() {
        let q = OlympiadQuestion(
            id: "qX", number: 1, stem: "Pick the right tag: <p>",
            options: ["<b>", "<i>", "<u>", "<s>"], correctAnswer: "A",
            explanation: nil
        )
        let html = OlympiadScoreReportRenderer.render(
            paper: paper(),
            questions: [q],
            selectedByQuestionId: ["qX": "A"]
        )
        XCTAssertTrue(html.contains("&lt;p&gt;"), "Stem angle brackets should be escaped")
        XCTAssertFalse(html.contains("<p>Pick the right tag:"),
                       "Raw <p> in the stem should not slip through")
    }

    // MARK: - Cross-subject coverage contract
    //
    // The Exam Hall pass (timer, autosave, exit guard, score report)
    // routes EVERY paper through the same `OlympiadQuizView`, so the
    // feature is universal-by-construction. These tests pin the input
    // contract — if anyone adds a future paper or edits a registry
    // entry such that the contract breaks, the feature silently
    // disables for that one paper. The pin catches that at commit time.

    func testEveryRegistryPaperHasPositiveSuggestedTime() {
        let papers = OlympiadPaperRegistry.allPapers
        XCTAssertFalse(papers.isEmpty, "Registry must ship at least one paper")
        for p in papers {
            XCTAssertGreaterThan(
                p.suggestedTimeMinutes, 0,
                "\(p.id) has suggestedTimeMinutes=\(p.suggestedTimeMinutes); timer needs >0 to start the countdown"
            )
        }
    }

    func testEveryRegistryPaperHasPositiveMaxMarks() {
        // OlympiadScoreReportRenderer.computeTally divides by maxMarks
        // to compute percentage. A 0 would force the safe branch
        // (pct = 0) for every kid, regardless of how they did.
        for p in OlympiadPaperRegistry.allPapers {
            XCTAssertGreaterThan(
                p.maxMarks, 0,
                "\(p.id) has maxMarks=\(p.maxMarks); percentage math needs >0"
            )
        }
    }

    func testAllFourSubjectsHaveAtLeastOnePaper() {
        // Catches a regression where a subject's registry sister file
        // is reverted to an empty array, or where the `allPapers`
        // composition drops a subject. The Exam Hall UX needs to be
        // visible from every subject in the hub.
        let bySubject = Dictionary(grouping: OlympiadPaperRegistry.allPapers,
                                   by: { $0.subjectName })
        for subject in ["Science", "Maths", "Sanskrit", "Social Science"] {
            XCTAssertNotNil(bySubject[subject],
                            "Subject '\(subject)' is missing from OlympiadPaperRegistry.allPapers")
            XCTAssertGreaterThan(bySubject[subject]?.count ?? 0, 0,
                                 "Subject '\(subject)' should have ≥1 paper")
        }
    }

    func testRegistryHasExactly69PapersToday() {
        // Soft canary on the current 19+15+15+20 inventory. If a paper
        // is added or removed, this fails and the author is forced to
        // bump the expected count in lock-step — which is the same
        // pattern used by EntitlementsSnapshotTest and the pack-id
        // collision ratchet.
        let papers = OlympiadPaperRegistry.allPapers
        XCTAssertEqual(papers.count, 69,
                       "Expected 69 papers (19 Science + 15 Maths + 15 Sanskrit + 20 Social Science). Got \(papers.count).")
    }

    func testMarkingSchemeIsUniformAcrossAllPapers() {
        // The Exam Hall countdown ribbon, autosave, and score report
        // all assume the +4/-1/0/240 scheme. A future per-paper
        // override would need to be explicitly opted-into and
        // documented; until then, lock the contract.
        for p in OlympiadPaperRegistry.allPapers {
            XCTAssertEqual(p.marksCorrect, 4, "\(p.id) marksCorrect")
            XCTAssertEqual(p.marksWrong, -1, "\(p.id) marksWrong")
            XCTAssertEqual(p.marksSkipped, 0, "\(p.id) marksSkipped")
            XCTAssertEqual(p.maxMarks, 240, "\(p.id) maxMarks")
            XCTAssertEqual(p.questionCount, 60, "\(p.id) questionCount")
        }
    }
}
