import Foundation

/// One end-of-chapter NCERT textbook Q&A. Chapter floor ≥ 8 per chapter.
/// The model answer must match the textbook's depth — 2 to 8 sentences
/// per the §C.4 style guide. Authoring these requires NCERT ground
/// truth; cross-check every claim before shipping.
struct NcertQAEntry: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_nq01"
    let question: String             // 1–2 sentence question (verbatim from NCERT)
    let modelAnswer: String          // 2–8 sentence model answer
    /// Optional textbook page reference for the user / parent to
    /// double-check against the NCERT book.
    let textbookPage: Int?
    let relatedConceptIds: [String]?
}
