import Foundation

/// A "you'll see this again in Ch. X" pointer. Chapter floor ≥ 2
/// outbound per chapter. The UI renders these as inline "Looking
/// ahead" cards so the kid understands how the curriculum threads
/// across chapters.
struct CrossChapterRef: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_cx01"
    let toChapterId: String          // "ch10"
    let topic: String                // "Respiration"
    let pointer: String              // 1–2 sentence explanation of the connection
    let relatedConceptIds: [String]?
}
