import Foundation

// MARK: - OlympiadPaperRegistry
//
// Hardcoded list of every Olympiad test paper bundled with the app.
// Adding a new paper = one entry here + 3 resource files
// (`<name>_QuestionPaper.md`, `<name>_Solutions.md`, `<name>.html`)
// dropped into `desktopAhaan/Resources/TestPapers/`. The
// PBXFileSystemSynchronizedRootGroup auto-picks them up.
//
// Today (2026-06-06): 2 papers (Science Ch13 + Maths Ch15) authored
// via the `TestPapers/validate_paper.py` Olympiad pipeline.

enum OlympiadPaperRegistry {

    /// All papers, ordered for display in the sidebar landing view.
    /// Order: by subject (Science → Maths → Sanskrit → Social
    /// Science) then by chapter number ascending.
    static let allPapers: [OlympiadPaper] =
        sciencePapers + mathsPapers + sanskritPapers + socialSciencePapers

    /// Group the list by subject for the sectioned sidebar landing.
    /// Returns an array of (subjectName, papersInThatSubject) pairs
    /// preserving the `allPapers` insertion order.
    static func papersBySubject() -> [(subject: String, papers: [OlympiadPaper])] {
        var ordered: [(String, [OlympiadPaper])] = []
        var seenSubjects: [String: Int] = [:]
        for paper in allPapers {
            if let idx = seenSubjects[paper.subjectName] {
                ordered[idx].1.append(paper)
            } else {
                seenSubjects[paper.subjectName] = ordered.count
                ordered.append((paper.subjectName, [paper]))
            }
        }
        return ordered.map { (subject: $0.0, papers: $0.1) }
    }

    /// Lookup by id — used by the persisted attempt state restore path
    /// (future work).
    static func paper(withId id: String) -> OlympiadPaper? {
        allPapers.first { $0.id == id }
    }
}
