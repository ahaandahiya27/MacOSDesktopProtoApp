import Foundation

/// "You'll see this again" pointer toward higher-class exam content
/// (Class 8, 10, 11, 12, NEET, JEE). One per relevant topic; the chapter
/// floor is ≥ 3 per chapter, ≥ 1 per topic.
struct ExamConnection: Codable, Hashable, Identifiable {
    let id: String                   // e.g. "ch01_xc01"
    let title: String                // "Photosynthesis returns in Class 11 Biology"
    let body: String                 // 60–120 words
    /// Tag indicating the future class / exam this connects to.
    /// Free-form String so the JSON can grow new values without a
    /// breaking schema change. Suggested values: "class8", "class10",
    /// "class11", "class12", "neet", "jee".
    let targetExam: String
    let relatedConceptIds: [String]?
}
