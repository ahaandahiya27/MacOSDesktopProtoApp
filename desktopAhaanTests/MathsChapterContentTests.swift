import XCTest
@testable import desktopAhaan

/// Schema + content-quality ratchet for the Maths pack (`maths_class7.json`),
/// authored 2026-05-27 from the NEP Ganita Prakash Grade 7 textbook.
///
/// Mirrors the Science `ChapterContentTests` contract, scoped to Maths:
/// every concept carries 4 explanation depths, a predict-question ending in
/// '?', and a 3-layer whyChain; every question has worked solution steps and
/// at least two variations; every chapter meets the enrichment floors; and
/// the concept-map nodes resolve. The chapter/concept/question totals are
/// pinned so accidental deletions fail loudly.
///
/// If a deliberate content change moves a total, update the pinned numbers in
/// `testMathsContentTotals` in the same commit.
final class MathsChapterContentTests: XCTestCase {

    private func loadMathsPack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "maths_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("maths_class7.json missing from test bundle resources.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }

    // MARK: - Structure

    func testMathsPackHas15Chapters() throws {
        let pack = try loadMathsPack()
        XCTAssertEqual(pack.chapters.count, 15,
                       "Maths pack should have all 15 NEP Grade 7 chapters.")
        // Chapter numbers should be 1...15, in order.
        XCTAssertEqual(pack.chapters.map { $0.number }, Array(1...15))
    }

    func testMathsContentTotals() throws {
        let pack = try loadMathsPack()
        let concepts = pack.chapters.reduce(0) { acc, ch in
            acc + ch.topics.reduce(0) { $0 + $1.concepts.count }
        }
        let questions = pack.chapters.reduce(0) { acc, ch in
            acc + ch.topics.reduce(0) { $0 + $1.questions.count }
        }
        // Ratchet: these are the authored totals. A drop means content was
        // lost; a deliberate addition should bump these numbers in the same commit.
        XCTAssertGreaterThanOrEqual(concepts, 82,
            "Maths concept count dropped below the 82 baseline (\(concepts)).")
        XCTAssertGreaterThanOrEqual(questions, 132,
            "Maths question count dropped below the 132 baseline (\(questions)).")
    }

    // MARK: - Concept quality

    func testEveryConceptHasFourExplanationDepths() throws {
        let pack = try loadMathsPack()
        let depths = ["oneLine", "kidFriendly", "textbook", "expert"]
        for ch in pack.chapters {
            for t in ch.topics {
                for c in t.concepts {
                    for d in depths {
                        let text = c.explanations[d] ?? ""
                        XCTAssertFalse(text.isEmpty,
                            "Concept \(c.id) missing/empty explanation depth '\(d)'.")
                    }
                }
            }
        }
    }

    func testEveryPredictQuestionEndsInQuestionMark() throws {
        let pack = try loadMathsPack()
        for ch in pack.chapters {
            for t in ch.topics {
                for c in t.concepts {
                    guard let pq = c.predictQuestion else {
                        XCTFail("Concept \(c.id) is missing its predictQuestion.")
                        continue
                    }
                    XCTAssertTrue(pq.trimmingCharacters(in: .whitespacesAndNewlines).hasSuffix("?"),
                        "Concept \(c.id) predictQuestion must end in '?': \(pq)")
                }
            }
        }
    }

    func testEveryWhyChainHasThreeSubstantialLayers() throws {
        let pack = try loadMathsPack()
        for ch in pack.chapters {
            for t in ch.topics {
                for c in t.concepts {
                    guard let wc = c.whyChain else {
                        XCTFail("Concept \(c.id) is missing its whyChain.")
                        continue
                    }
                    XCTAssertEqual(wc.count, 3,
                        "Concept \(c.id) whyChain must have exactly 3 layers (has \(wc.count)).")
                    for (i, layer) in wc.enumerated() {
                        XCTAssertGreaterThanOrEqual(layer.count, 40,
                            "Concept \(c.id) whyChain layer \(i) is too short (\(layer.count) chars).")
                    }
                }
            }
        }
    }

    func testEveryConceptHasAtLeastThreeUseCases() throws {
        let pack = try loadMathsPack()
        for ch in pack.chapters {
            for t in ch.topics {
                for c in t.concepts {
                    XCTAssertGreaterThanOrEqual(c.useCases.count, 3,
                        "Concept \(c.id) needs at least 3 useCases (has \(c.useCases.count)).")
                }
            }
        }
    }

    // MARK: - Question quality

    func testEveryQuestionHasSolutionStepsAndTwoVariations() throws {
        let pack = try loadMathsPack()
        for ch in pack.chapters {
            for t in ch.topics {
                for q in t.questions {
                    XCTAssertFalse(q.solutionSteps.isEmpty,
                        "Question \(q.id) has no solutionSteps.")
                    XCTAssertGreaterThanOrEqual(q.variations.count, 2,
                        "Question \(q.id) needs at least 2 variations (has \(q.variations.count)).")
                }
            }
        }
    }

    // MARK: - Unique ids

    func testNoDuplicateConceptOrQuestionIds() throws {
        let pack = try loadMathsPack()
        var conceptIds: [String] = []
        var questionIds: [String] = []
        for ch in pack.chapters {
            for t in ch.topics {
                conceptIds.append(contentsOf: t.concepts.map(\.id))
                questionIds.append(contentsOf: t.questions.map(\.id))
            }
        }
        XCTAssertEqual(conceptIds.count, Set(conceptIds).count,
            "Duplicate concept id(s) in the Maths pack: \(duplicates(conceptIds)).")
        XCTAssertEqual(questionIds.count, Set(questionIds).count,
            "Duplicate question id(s) in the Maths pack: \(duplicates(questionIds)).")
    }

    private func duplicates(_ ids: [String]) -> [String] {
        var seen: Set<String> = []
        var dups: Set<String> = []
        for id in ids { if !seen.insert(id).inserted { dups.insert(id) } }
        return dups.sorted()
    }

    // MARK: - Chapter enrichment floors

    func testEveryChapterMeetsEnrichmentFloors() throws {
        let pack = try loadMathsPack()
        for ch in pack.chapters {
            XCTAssertGreaterThanOrEqual(ch.glossaryList.count, 10,
                "Chapter \(ch.number) needs >=10 glossary terms (has \(ch.glossaryList.count)).")
            XCTAssertGreaterThanOrEqual(ch.misconceptionsList.count, 5,
                "Chapter \(ch.number) needs >=5 misconceptions (has \(ch.misconceptionsList.count)).")
            XCTAssertGreaterThanOrEqual(ch.mnemonicsList.count, 3,
                "Chapter \(ch.number) needs >=3 mnemonics (has \(ch.mnemonicsList.count)).")
            XCTAssertGreaterThanOrEqual(ch.ncertQAList.count, 8,
                "Chapter \(ch.number) needs >=8 NCERT Q&A (has \(ch.ncertQAList.count)).")
        }
    }

    // MARK: - Concept map resolution

    func testConceptMapNodesResolveWithinChapterOrCrossChapter() throws {
        let pack = try loadMathsPack()
        for ch in pack.chapters {
            guard let cm = ch.conceptMap else { continue }
            let chapterConceptIds = Set(ch.topics.flatMap { $0.concepts.map(\.id) })
            for node in cm.nodes {
                switch node.kind {
                case .concept:
                    XCTAssertTrue(chapterConceptIds.contains(node.id),
                        "ConceptMap 'concept' node \(node.id) in chapter \(ch.number) does not resolve to an in-chapter concept.")
                case .crossChapter:
                    XCTAssertTrue(node.id.contains(":"),
                        "ConceptMap crossChapter node \(node.id) should use the 'chNN:concept_id' form.")
                case .pivot:
                    break // synthesised grouping nodes need not resolve
                }
            }
            // Every edge endpoint must be a declared node id.
            let nodeIds = Set(cm.nodes.map(\.id))
            for e in cm.edges {
                XCTAssertTrue(nodeIds.contains(e.from),
                    "ConceptMap edge \(e.id) in chapter \(ch.number) has unknown 'from' node \(e.from).")
                XCTAssertTrue(nodeIds.contains(e.to),
                    "ConceptMap edge \(e.id) in chapter \(ch.number) has unknown 'to' node \(e.to).")
            }
        }
    }
}
