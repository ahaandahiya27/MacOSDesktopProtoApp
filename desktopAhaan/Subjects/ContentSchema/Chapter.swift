import Foundation

/// A textbook chapter.
struct Chapter: Codable, Hashable, Identifiable {
    let id: String                  // e.g. "ch01"
    let number: Int
    let title: String
    let summary: String
    let topics: [Topic]
    let pageRefs: [Int]
}
