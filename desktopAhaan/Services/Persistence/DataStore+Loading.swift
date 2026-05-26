import Foundation

// MARK: - Cold-launch loader
//
// `loadAll()` originally did 11 synchronous JSON file reads on the
// main actor before `init` returned. Files are tiny today (kilobytes
// each) but the cumulative cost still ran on the cold-launch critical
// path — any growth (e.g. attempts.json after a year of practice)
// would start to show up in the cold-launch hang detector.
//
// `loadAllOffThread` runs all reads on a background `Task.detached`
// (priority `.userInitiated`), builds the value-type dictionaries on
// that thread, then hops back to the main actor in one
// `await MainActor.run { ... }` to assign every @Published property in
// a single batched update — so SwiftUI sees one pre-coalesced
// re-render rather than 11 cascading ones.

extension DataStore {

    /// Nonisolated file read — runs anywhere, touches no main-actor state.
    /// Returns the decoded array and a backup-rescue flag so the caller
    /// can surface the user-facing error message on the main thread.
    nonisolated static func readFile<T: Decodable>(
        _ type: T.Type, from filename: String, in storeDir: URL
    ) -> (items: [T], didRescueCorruptFile: Bool) {
        let url = storeDir.appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: url.path) else {
            return ([], false)
        }
        do {
            let data = try Data(contentsOf: url)
            return (try JSONDecoder().decode([T].self, from: data), false)
        } catch {
            let stamp = ISO8601DateFormatter().string(from: Date())
                .replacingOccurrences(of: ":", with: "-")
            let rescue = url.deletingPathExtension()
                .appendingPathExtension("corrupt.\(stamp).json")
            try? FileManager.default.moveItem(at: url, to: rescue)
            logger.error("load \(filename, privacy: .public) failed: \(error.localizedDescription, privacy: .public); preserved as \(rescue.lastPathComponent, privacy: .public)")
            return ([], true)
        }
    }

    /// Off-thread loader. Runs all 11 file reads on a background task,
    /// then hops back to the main actor to assign every @Published
    /// property in one batched update so SwiftUI sees a single
    /// pre-coalesced re-render rather than 11 cascading ones.
    nonisolated static func loadAllOffThread(
        into store: DataStore, from storeDir: URL
    ) async {
        let translations = readFile(TranslationRecord.self, from: "translations.json", in: storeDir)
        let practice = readFile(PracticeProgress.self, from: "practice.json", in: storeDir)
        let bookmarks = readFile(StudyBookmark.self, from: "bookmarks.json", in: storeDir)
        let qBookmarks = readFile(QuestionBookmark.self, from: "questionBookmarks.json", in: storeDir)
        let attempts = readFile(QuestionAttempt.self, from: "attempts.json", in: storeDir)
        let sessions = readFile(StudySession.self, from: "sessions.json", in: storeDir)
        let discover = readFile(DiscoverProgress.self, from: "discover.json", in: storeDir)
        let reviewed = readFile(String.self, from: "reviewedQuestionIds.json", in: storeDir)
        let tough = readFile(String.self, from: "toughQuestionIds.json", in: storeDir)
        let reviews = readFile(QuestionReview.self, from: "reviews.json", in: storeDir)
        let notes = readFile(ChapterNote.self, from: "notes.json", in: storeDir)
        let readArticles = readFile(String.self, from: "readArticleIds.json", in: storeDir)

        // Crash-safe Dictionary build can stay on the background thread —
        // result is a value type, transferred to main below.
        let reviewsDict = Dictionary(
            reviews.items.map { ($0.questionId, $0) },
            uniquingKeysWith: { a, b in
                CrashReporter.shared.logDataIssue(
                    "reviews.json contained duplicate questionId=\(a.questionId); kept newer row.")
                return a.lastReviewedAt >= b.lastReviewedAt ? a : b
            }
        )

        let notesDict = Dictionary(
            notes.items.map { ($0.chapterId, $0.text) },
            uniquingKeysWith: { a, b in
                CrashReporter.shared.logDataIssue(
                    "notes.json contained duplicate chapterId; kept first row.")
                return a
            }
        )

        let anyRescue = translations.didRescueCorruptFile || practice.didRescueCorruptFile
            || bookmarks.didRescueCorruptFile || qBookmarks.didRescueCorruptFile
            || attempts.didRescueCorruptFile || sessions.didRescueCorruptFile
            || discover.didRescueCorruptFile || reviewed.didRescueCorruptFile
            || tough.didRescueCorruptFile || reviews.didRescueCorruptFile
            || notes.didRescueCorruptFile || readArticles.didRescueCorruptFile

        await MainActor.run {
            store.translationRecords = translations.items
            store.practiceProgress = practice.items
            store.studyBookmarks = bookmarks.items
            store.questionBookmarks = qBookmarks.items
            store.questionAttempts = attempts.items
            store.studySessions = sessions.items
            store.discoverProgress = discover.items
            store.reviewedQuestionIds = Set(reviewed.items)
            store.toughQuestionIds = Set(tough.items)
            store.questionReviews = reviewsDict
            store.chapterNotes = notesDict
            store.readArticleIds = Set(readArticles.items)
            if anyRescue {
                store.lastSaveError = "Saved data couldn't be read — a backup copy was preserved next to your data. Continuing with a fresh file."
            }
        }
    }
}
