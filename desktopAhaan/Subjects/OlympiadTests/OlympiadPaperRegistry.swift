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
    static let allPapers: [OlympiadPaper] = [
        OlympiadPaper(
            id: "olympiad_science_ch13",
            subjectId: "science_class7",
            subjectName: "Science",
            chapterNumber: 13,
            chapterTitle: "Motion and Time",
            displayTitle: "Motion and Time — 60 MCQ Olympiad",
            questionPaperMD: "Science_Ch13_MotionAndTime_QuestionPaper.md",
            solutionsMD: "Science_Ch13_MotionAndTime_Solutions.md",
            questionPaperHTML: "Science_Ch13_MotionAndTime.html",
            questionPaperPDF: "Science_Ch13_MotionAndTime.pdf",
            suggestedTimeMinutes: 90
        ),
        OlympiadPaper(
            id: "olympiad_maths_ch15",
            subjectId: "maths_class7",
            subjectName: "Maths",
            chapterNumber: 15,
            chapterTitle: "Finding the Unknown",
            displayTitle: "Finding the Unknown — 60 MCQ Olympiad",
            questionPaperMD: "Maths_Ch15_FindingTheUnknown_QuestionPaper.md",
            solutionsMD: "Maths_Ch15_FindingTheUnknown_Solutions.md",
            questionPaperHTML: "Maths_Ch15_FindingTheUnknown.html",
            questionPaperPDF: "Maths_Ch15_FindingTheUnknown.pdf",
            suggestedTimeMinutes: 90
        )
    ]

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
