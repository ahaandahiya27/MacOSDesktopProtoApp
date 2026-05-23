import Foundation

/// "Kids often think X — actually Y" card. Chapter floor ≥ 5 per chapter.
/// The first sentence is the wrong-but-common belief; the second / third
/// sentences explain the right understanding gently. No "you're wrong"
/// tone; assume the misconception is a step toward the truth.
struct Misconception: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_ms01"
    let kidsThink: String            // 1-line common-belief
    let actually: String             // 2-line correction
    let relatedConceptIds: [String]?
}
