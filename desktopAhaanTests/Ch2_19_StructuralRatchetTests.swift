import XCTest
@testable import desktopAhaan

// MARK: - Ch2_19_StructuralRatchetTests
//
// "Pixel-identical" snapshot ratchet substitute for the Ch.1 pilot
// session (2026-05-23). The brief asked for pixel snapshots of every
// Ch.2..19 chapter-detail page; the dev Mac lacks the AX permission
// the UITest runner needs AND a 3rd-party snapshot library is
// forbidden by the no-new-package rule. Instead we lock the *data
// fingerprint* of every chapter except ch01: topic count, concept
// count, question count, and the item-count for each of the 13
// content-expansion fields. If any of those drift, the corresponding
// surface in ChapterDetailView will look different, so this is the
// closest no-pixel proxy for "Ch.2..19 must look unchanged."
//
// The ch01 chapter is deliberately NOT locked — the Ch.1 pilot may
// freely add `predictQuestion` / `whyChain` / `conceptMap` content
// to ch01 without tripping this test.
//
// On a drift failure, the ACTUAL fingerprint is printed alongside
// the expected one so a maintainer can re-baseline with confidence
// (or, more likely, find the leak in shared view code that touched
// data for a chapter it shouldn't have).

final class Ch2_19_StructuralRatchetTests: XCTestCase {

    func testCh2_19_HaveNotDriftedSincePilotBaseline() throws {
        let pack = try loadSciencePack()

        for chapter in pack.chapters where chapter.id != "ch01" {
            let actual = ChapterFingerprint(from: chapter)
            guard let expected = Self.baseline[chapter.id] else {
                XCTFail("No baseline for \(chapter.id) — add a row to Ch2_19_StructuralRatchetTests.baseline.")
                continue
            }
            XCTAssertEqual(
                actual, expected,
                "Chapter \(chapter.id) drifted from the Ch.1 pilot baseline. " +
                "Expected: \(expected). Actual: \(actual). " +
                "If the change is intentional, update the baseline; otherwise, find the leak in shared view / content code."
            )
        }
    }

    // MARK: - Helpers

    private func loadSciencePack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("science_class7.json missing from test bundle resources.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }

    // MARK: - Baseline (frozen 2026-05-23 pre-Ch.1-pilot)

    private static let baseline: [String: ChapterFingerprint] = [
        "ch02": .init(topicCount: 3, conceptCount: 20, questionCount: 35, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch03": .init(topicCount: 3, conceptCount: 15, questionCount: 35, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch04": .init(topicCount: 3, conceptCount: 16, questionCount: 34, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch05": .init(topicCount: 3, conceptCount: 8,  questionCount: 36, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch06": .init(topicCount: 3, conceptCount: 8,  questionCount: 39, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch07": .init(topicCount: 3, conceptCount: 8,  questionCount: 38, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch08": .init(topicCount: 3, conceptCount: 8,  questionCount: 32, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch09": .init(topicCount: 3, conceptCount: 8,  questionCount: 34, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch10": .init(topicCount: 3, conceptCount: 8,  questionCount: 28, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch11": .init(topicCount: 3, conceptCount: 8,  questionCount: 36, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch12": .init(topicCount: 3, conceptCount: 8,  questionCount: 29, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch13": .init(topicCount: 3, conceptCount: 8,  questionCount: 33, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch14": .init(topicCount: 3, conceptCount: 8,  questionCount: 38, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch15": .init(topicCount: 3, conceptCount: 8,  questionCount: 45, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch16": .init(topicCount: 3, conceptCount: 8,  questionCount: 39, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch17": .init(topicCount: 3, conceptCount: 8,  questionCount: 35, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch18": .init(topicCount: 3, conceptCount: 8,  questionCount: 32, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
        "ch19": .init(topicCount: 3, conceptCount: 23, questionCount: 99, realWorld: 5, examConn: 3, mnemonics: 3, miscons: 5, ncertQA: 8, glossary: 10, projects: 2, scientist: 1, whatIfs: 3, crossRefs: 2, bridge: 1, gallery: 6, timelines: 1, deepDive: 3, media: 10),
    ]
}

// MARK: - ChapterFingerprint

struct ChapterFingerprint: Equatable, CustomStringConvertible {
    let topicCount: Int
    let conceptCount: Int
    let questionCount: Int
    let realWorld: Int
    let examConn: Int
    let mnemonics: Int
    let miscons: Int
    let ncertQA: Int
    let glossary: Int
    let projects: Int
    let scientist: Int
    let whatIfs: Int
    let crossRefs: Int
    let bridge: Int
    let gallery: Int
    let timelines: Int
    let deepDive: Int
    let media: Int

    init(topicCount: Int, conceptCount: Int, questionCount: Int,
         realWorld: Int, examConn: Int, mnemonics: Int, miscons: Int,
         ncertQA: Int, glossary: Int, projects: Int, scientist: Int,
         whatIfs: Int, crossRefs: Int, bridge: Int, gallery: Int,
         timelines: Int, deepDive: Int, media: Int) {
        self.topicCount = topicCount
        self.conceptCount = conceptCount
        self.questionCount = questionCount
        self.realWorld = realWorld
        self.examConn = examConn
        self.mnemonics = mnemonics
        self.miscons = miscons
        self.ncertQA = ncertQA
        self.glossary = glossary
        self.projects = projects
        self.scientist = scientist
        self.whatIfs = whatIfs
        self.crossRefs = crossRefs
        self.bridge = bridge
        self.gallery = gallery
        self.timelines = timelines
        self.deepDive = deepDive
        self.media = media
    }

    init(from chapter: Chapter) {
        self.init(
            topicCount: chapter.topics.count,
            conceptCount: chapter.topics.reduce(0) { $0 + $1.concepts.count },
            questionCount: chapter.topics.reduce(0) { $0 + $1.questions.count },
            realWorld:  chapter.realWorldExamplesList.count,
            examConn:   chapter.examConnectionsList.count,
            mnemonics:  chapter.mnemonicsList.count,
            miscons:    chapter.misconceptionsList.count,
            ncertQA:    chapter.ncertQAList.count,
            glossary:   chapter.glossaryList.count,
            projects:   chapter.miniProjectsList.count,
            scientist:  chapter.scientistsList.count,
            whatIfs:    chapter.whatIfsList.count,
            crossRefs:  chapter.crossChapterRefsList.count,
            bridge:     chapter.curriculumBridge == nil ? 0 : 1,
            gallery:    chapter.galleryList.count,
            timelines:  chapter.timelinesList.count,
            deepDive:   chapter.deepDiveList.count,
            media:      chapter.mediaAssetsList.count
        )
    }

    var description: String {
        "FP(topics:\(topicCount), concepts:\(conceptCount), q:\(questionCount), rw:\(realWorld), ex:\(examConn), mn:\(mnemonics), ms:\(miscons), nq:\(ncertQA), gl:\(glossary), mp:\(projects), sc:\(scientist), wi:\(whatIfs), cr:\(crossRefs), br:\(bridge), gal:\(gallery), tl:\(timelines), dd:\(deepDive), md:\(media))"
    }
}
