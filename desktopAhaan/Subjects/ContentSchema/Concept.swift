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

    /// Short memorable hook a 12-year-old can recall in an exam — usually
    /// 1-2 sentences. Optional so older pack JSONs without this field
    /// continue to decode unchanged. Added 2026-05-19 (Phase A of the
    /// final-content sweep). The 2026-05-19 audit-pack-health.py dashboard
    /// surfaced all 190 concepts shipping without this field; backfill
    /// happens chapter-by-chapter with the testMnemonicsRatchet contract.
    let mnemonic: String?

    /// Inquiry-first prompt shown BEFORE the body when the user has the
    /// "predict-first" Settings toggle on. Single sentence ending in `?`,
    /// designed to make the kid hypothesise before reading the answer.
    /// Backwards-compatible: when absent (most chapters today), the
    /// concept card behaves exactly as it did before — body shows
    /// immediately. Added 2026-05-23 as part of the Ch.1 pilot.
    let predictQuestion: String?

    /// Three-layer Socratic drill, surfaced via WhyChainView's "Why?" pill.
    /// Layer 0 is the existing concept body; whyChain[0] = layer 1,
    /// whyChain[1] = layer 2, whyChain[2] = layer 3. Each layer is
    /// 60–100 words and goes one level deeper into causes / mechanism /
    /// edge cases.
    ///
    /// Backwards-compatible: absent on every chapter except ch01 today.
    /// The integrity test in `ChapterContentTests` rejects entries whose
    /// count != 3 or whose layers are too short.
    let whyChain: [String]?

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
