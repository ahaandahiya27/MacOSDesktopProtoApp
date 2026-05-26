import XCTest
@testable import desktopAhaan

/// Pins `ConceptSiblings.resolve` — the static helper behind
/// the prev/next toolbar buttons on `ConceptDetailView` (added
/// 2026-05-26). Catches regressions where:
///   - the sibling walk fails to find a concept that exists,
///   - the edge cases (first / last in topic) don't return nil,
///   - the index / total disagree with the topic's actual layout.
final class ConceptSiblingsTests: XCTestCase {

    func testResolveSucceedsForEveryConceptInPack() throws {
        let pack = try loadSciencePack()
        var unresolved: [String] = []
        for chapter in pack.chapters {
            for topic in chapter.topics {
                for concept in topic.concepts {
                    if ConceptSiblings.resolve(conceptId: concept.id, in: pack) == nil {
                        unresolved.append(concept.id)
                    }
                }
            }
        }
        XCTAssertTrue(unresolved.isEmpty,
            "ConceptSiblings.resolve failed for \(unresolved.count) concept(s): " +
            "\(unresolved.prefix(5))")
    }

    func testFirstConceptInTopicHasNoPrev() throws {
        let pack = try loadSciencePack()
        for chapter in pack.chapters {
            for topic in chapter.topics {
                guard let first = topic.concepts.first else { continue }
                let r = ConceptSiblings.resolve(conceptId: first.id, in: pack)
                XCTAssertNotNil(r)
                XCTAssertNil(r?.prevId,
                    "First concept '\(first.id)' in topic '\(topic.id)' should have prevId=nil, got \(r?.prevId ?? "?")")
                XCTAssertEqual(r?.index, 0)
            }
        }
    }

    func testLastConceptInTopicHasNoNext() throws {
        let pack = try loadSciencePack()
        for chapter in pack.chapters {
            for topic in chapter.topics {
                guard let last = topic.concepts.last,
                      topic.concepts.count > 0 else { continue }
                let r = ConceptSiblings.resolve(conceptId: last.id, in: pack)
                XCTAssertNotNil(r)
                XCTAssertNil(r?.nextId,
                    "Last concept '\(last.id)' in topic '\(topic.id)' should have nextId=nil, got \(r?.nextId ?? "?")")
                XCTAssertEqual(r?.index, topic.concepts.count - 1)
            }
        }
    }

    func testMiddleConceptsHaveBothPrevAndNext() throws {
        let pack = try loadSciencePack()
        var checked = 0
        for chapter in pack.chapters {
            for topic in chapter.topics where topic.concepts.count >= 3 {
                for i in 1..<(topic.concepts.count - 1) {
                    let r = ConceptSiblings.resolve(conceptId: topic.concepts[i].id, in: pack)
                    XCTAssertEqual(r?.prevId, topic.concepts[i - 1].id)
                    XCTAssertEqual(r?.nextId, topic.concepts[i + 1].id)
                    checked += 1
                }
            }
        }
        XCTAssertGreaterThan(checked, 0,
            "No multi-concept topics found — sentinel for a malformed pack.")
    }

    func testUnknownConceptIdReturnsNil() throws {
        let pack = try loadSciencePack()
        let r = ConceptSiblings.resolve(conceptId: "ch01_t01_bogus", in: pack)
        XCTAssertNil(r,
            "ConceptSiblings.resolve must return nil for an id not in the pack.")
    }

    // MARK: - Helpers

    private func loadSciencePack() throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: "science_class7", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw XCTSkip("science_class7.json missing from test bundle.")
        }
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
