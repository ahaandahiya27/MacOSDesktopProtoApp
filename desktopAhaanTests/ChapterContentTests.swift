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
        for (key, entry) in ArticleIndex.entries {
            let expected = "\(key).html"
            // Overviews have different naming; concepts should match
            if !key.hasSuffix("_t01") && !key.hasSuffix("_t02") && !key.hasSuffix("_t03")
                && key != "ch01" && key != "ch02" && key != "ch03" {
                XCTAssertEqual(entry.filename, expected,
                               "\(key): filename '\(entry.filename)' doesn't match expected '\(expected)'")
            }
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

    func testAllArticleHTMLFilesExistInBundle() {
        for (key, entry) in ArticleIndex.entries {
            let name = entry.filename.replacingOccurrences(of: ".html", with: "")
            // Files may be in a subdirectory or flat in the bundle root
            let url = Bundle.main.url(forResource: name, withExtension: "html",
                                       subdirectory: entry.chapterFolder)
                ?? Bundle.main.url(forResource: name, withExtension: "html")
            XCTAssertNotNil(url, "HTML file for article \(key) not found (\(entry.filename))")
        }
    }
}
