import Foundation

/// A topic groups related concepts and questions inside a chapter.
struct Topic: Codable, Hashable, Identifiable {
    let id: String                  // e.g. "ch01_t02"
    let title: String
    let summary: String
    let concepts: [Concept]
    let questions: [Question]

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        summary = try c.decodeIfPresent(String.self, forKey: .summary) ?? ""
        concepts = try c.decode([Concept].self, forKey: .concepts)
        questions = try c.decode([Question].self, forKey: .questions)
    }
}
