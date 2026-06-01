import Foundation

// MARK: - ReportCardMasteryRow
//
// v6 Learning Journey · Phase 4 M3b. A flat, UI-free value the parent report
// card's PDF page consumes for its "Mastery by subject" section. Built from a
// `MasteryEngine.OverallMasterySnapshot` so `WeeklyReportPDFExporter` never has
// to import the live engine — keeping the exporter testable and off-main.
//
// Big Sur compatible: Foundation-only value type, no macOS 12+ APIs.
struct ReportCardMasteryRow: Hashable {
    let subjectTitle: String
    let coverageFraction: Double
    let masteryFraction: Double
    let levelName: String
    let hasStarted: Bool

    /// Map a cross-subject snapshot into report-card rows, in the snapshot's
    /// presentation (registry) order. Pure — no FS, no DataStore.
    static func rows(from snapshot: OverallMasterySnapshot) -> [ReportCardMasteryRow] {
        snapshot.subjects.map { subject in
            ReportCardMasteryRow(
                subjectTitle: subject.subjectTitle,
                coverageFraction: subject.coverageFraction,
                masteryFraction: subject.masteryFraction,
                levelName: subject.level.displayName,
                hasStarted: subject.hasStarted)
        }
    }
}
