import Foundation

/// A single concept inside a topic. Carries four explanation depths plus the
/// "why is this true" reasoning, real-world use cases, and a "beyond the
/// book" extension. The content pipeline guarantees:
///   • all four ExplanationDepth values are populated
///   • useCases.count >= 3
struct Concept: Codable, Hashable, Identifiable {
    let id: String                  // e.g. "ch01_t02_c03"
    let title: String

    /// Keys are the raw values of `ExplanationDepth` ("oneLine" etc.).
    /// We use `[String: String]` here rather than `[ExplanationDepth: String]`
    /// for two reasons:
    ///   1. It maps cleanly onto JSON without custom Codable logic.
    ///   2. Future packs can add new keys ("middleSchool", "olympiad")
    ///      without breaking decoding of older builds.
    let explanations: [String: String]

    let reasoning: String
    let useCases: [UseCase]
    let beyondTheBook: String
    let relatedConceptIds: [String]
    let relatedQuestionIds: [String]
    let pageRefs: [Int]
    let needsHumanReview: Bool

    // MARK: - Convenience

    /// Returns the explanation at the requested depth, or a sensible fallback
    /// (the next-shallowest available depth, never an empty string).
    func explanation(at depth: ExplanationDepth) -> String {
        if let exact = explanations[depth.rawValue], !exact.isEmpty {
            return exact
        }
        // Fallback ladder: closer-to-textbook depths are usually the most
        // reliable to fall back to.
        let fallbacks: [ExplanationDepth] = [.textbook, .kidFriendly, .oneLine, .expert]
        for d in fallbacks where d != depth {
            if let candidate = explanations[d.rawValue], !candidate.isEmpty {
                return candidate
            }
        }
        return "(no explanation available)"
    }

    /// Are all four expected depths populated?
    var hasAllDepths: Bool {
        ExplanationDepth.allCases.allSatisfy { depth in
            (explanations[depth.rawValue] ?? "").isEmpty == false
        }
    }
}
