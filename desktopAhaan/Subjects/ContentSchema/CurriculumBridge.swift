import Foundation

/// A two-part "where this leads next" bridge. Chapter floor exactly 1
/// per chapter (singular, not an array). The UI shows it at the bottom
/// of the chapter detail page — a forward-looking "you'll meet this
/// again in higher classes" panel.
struct CurriculumBridge: Codable, Hashable {
    /// 2-line preview of how the chapter's topics evolve next year
    /// (Class 8 Science).
    let nextYearClass8: String
    /// 2-line preview of how the topic ties into NEET / JEE level
    /// understanding (Class 10–12).
    let forNeetJee: String
}
