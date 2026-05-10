import Foundation

/// A concrete real-world example of a concept. The content pipeline requires
/// at least three of these per concept — pure abstractions don't qualify.
struct UseCase: Codable, Hashable, Identifiable {
    /// Stable id derived from the title. Used for ForEach.
    var id: String { title }

    let title: String
    let description: String
    /// One of: kitchen, weather, human body, plants, animals, technology,
    /// sport, travel, building, other. Free-form so future packs can extend.
    let domain: String
}
