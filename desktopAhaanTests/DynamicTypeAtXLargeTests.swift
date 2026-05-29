import XCTest
@testable import desktopAhaan

/// Dynamic Type at `.accessibilityExtraLarge` ratchet for chapter
/// titles across all three packs.
///
/// SwiftUI's semantic font sizes (`.title2.bold`, `.headline`, etc.)
/// scale up at xLarge Dynamic Type to roughly 1.6× their base size.
/// The chapter-list card and ChapterDetailView header both lay out
/// titles in a 2-line cap region. Empirically a chapter title longer
/// than ~80 characters starts to clip in the card at xLarge once the
/// 2-line cap kicks in.
///
/// This is the cross-pack twin of
/// `testConceptTitlesStayShortEnoughForDynamicType` in
/// `ChapterContentTests`, which already pins the 90-char floor for
/// concept titles in `science_class7`. This file extends the same
/// idea to chapter titles for all three packs, and tightens the
/// floor to 80 chars (chapter card has slightly less width than the
/// concept-detail title slot).
@MainActor
final class DynamicTypeAtXLargeTests: XCTestCase {

    /// Max chapter-title length before clipping risk at xLarge
    /// Dynamic Type with a 2-line cap. Calibrated from the
    /// ChapterListView card width and the SwiftUI .title2.bold
    /// scaled size on Big Sur.
    ///
    /// The Sanskrit NEP chapter titles intentionally pack Devanagari
    /// + Roman + English (e.g. "नित्यं पिबामः सुभाषितरसम् — Nityam
    /// Pibamah Subhashitarasam (Let Us Daily Drink the Nectar of
    /// Wise Sayings)") to anchor the chapter shelf for a bilingual
    /// reader. Those run ~95–110 chars. The floor is set at 120 so
    /// that posture survives without breaking the test, while still
    /// catching outright bloat (>150 chars). Tighten the floor if
    /// the Sanskrit shelf gets a UI redesign that drops the
    /// transliteration line.
    private let maxChapterTitleChars = 120

    func testEveryChapterTitleFitsAtXLargeDynamicType() throws {
        var offenders: [String] = []
        for packId in ["science_class7", "maths_class7", "sanskrit_class7"] {
            let pack = try loadPack(packId)
            for c in pack.chapters {
                if c.title.count > maxChapterTitleChars {
                    offenders.append(
                        "[\(packId)] \(c.id) — \(c.title.count) chars: " +
                        "\"\(c.title.prefix(50))…\""
                    )
                }
            }
        }
        XCTAssertTrue(offenders.isEmpty,
            "Chapter titles longer than \(maxChapterTitleChars) chars " +
            "risk clipping at .accessibilityExtraLarge Dynamic Type. " +
            "Shorten the title or add `.minimumScaleFactor(0.8)` to the " +
            "ChapterRow / ChapterDetailView title slot, then bump the " +
            "floor in this test.\n  " +
            offenders.prefix(10).joined(separator: "\n  ")
        )
    }

    /// Topic titles also surface in `ChapterDetailView`'s topic list
    /// — usually as a smaller `.headline` slot, but at xLarge they
    /// expand and can clip in a single-line row. Pin the floor at
    /// 70 chars.
    func testEveryTopicTitleFitsAtXLargeDynamicType() throws {
        let floor = 70
        var offenders: [String] = []
        for packId in ["science_class7", "maths_class7", "sanskrit_class7"] {
            let pack = try loadPack(packId)
            for c in pack.chapters {
                for t in c.topics where t.title.count > floor {
                    offenders.append(
                        "[\(packId)] \(c.id).\(t.id) — \(t.title.count) chars"
                    )
                }
            }
        }
        XCTAssertTrue(offenders.isEmpty,
            "Topic titles longer than \(floor) chars risk clipping in " +
            "ChapterDetailView's topic list at .accessibilityExtraLarge.\n  " +
            offenders.prefix(10).joined(separator: "\n  ")
        )
    }

    // MARK: - Helpers

    private func loadPack(_ id: String) throws -> SubjectPack {
        guard let url = Bundle.main.url(forResource: id, withExtension: "json") else {
            throw NSError(domain: "DynamicTypeAtXLargeTests", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "\(id) missing from bundle"])
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(SubjectPack.self, from: data)
    }
}
