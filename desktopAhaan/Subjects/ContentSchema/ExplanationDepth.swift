import Foundation

/// The four depths at which a concept is explained. Every concept in a
/// `SubjectPack` must populate all four — the validator in the content
/// pipeline enforces this so the app can rely on it.
enum ExplanationDepth: String, CaseIterable, Identifiable, Codable, Hashable {
    case oneLine
    case kidFriendly
    case textbook
    case expert

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .oneLine:     return "One line"
        case .kidFriendly: return "Kid friendly"
        case .textbook:    return "Textbook"
        case .expert:      return "Beyond the book"
        }
    }

    /// Short label suitable for a segmented control on a narrow screen.
    var shortLabel: String {
        switch self {
        case .oneLine:     return "1-Line"
        case .kidFriendly: return "Kid"
        case .textbook:    return "Book"
        case .expert:      return "Expert"
        }
    }

    var systemImage: String {
        switch self {
        case .oneLine:     return "text.alignleft"
        case .kidFriendly: return "face.smiling"
        case .textbook:    return "book"
        case .expert:      return "graduationcap"
        }
    }
}
