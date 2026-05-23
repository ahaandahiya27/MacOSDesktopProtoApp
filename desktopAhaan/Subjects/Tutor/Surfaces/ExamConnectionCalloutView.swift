import SwiftUI

// MARK: - ExamConnectionCalloutView
//
// Inline callout beneath a question (or near it) showing how the same
// idea reappears in a later class or competitive exam. Pulls from
// `chapter.examConnections[]`.
//
// Matching strategy: the schema's ExamConnection links to one or more
// concept ids; pick the first connection whose `relatedConceptIds`
// overlap with any of the question's relatedConceptIds — or, when the
// question has none, fall back to the first connection on the chapter
// that's roughly topic-prefixed by the question id (best-effort).
//
// Uses `InlineContentCallout`. Tinted purple to signal exam-relevance.

struct ExamConnectionCalloutView: View {
    let chapter: Chapter
    /// The set of concept ids associated with the parent question /
    /// concept page. The callout looks for an ExamConnection whose
    /// relatedConceptIds overlap with this set.
    let relatedConceptIds: [String]

    private var matched: ExamConnection? {
        let connections = chapter.examConnectionsList
        guard !connections.isEmpty else { return nil }
        let mySet = Set(relatedConceptIds)
        // Best match: any ExamConnection whose relatedConceptIds
        // intersects with mySet.
        if let direct = connections.first(where: { c in
            guard let ids = c.relatedConceptIds else { return false }
            return !mySet.isDisjoint(with: ids)
        }) {
            return direct
        }
        // Fallback: just show the first connection so the surface is
        // still visible. Better than nothing for chapters where the
        // JSON didn't author per-question links.
        return connections.first
    }

    var body: some View {
        if let connection = matched {
            InlineContentCallout(
                title: "Exam connection — \(connection.targetExam)",
                message: "\(connection.title)\n\n\(connection.body)",
                symbol: "graduationcap.fill",
                tint: .compatPurple
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Exam connection for \(connection.targetExam): \(connection.title). \(connection.body)")
        }
    }
}
