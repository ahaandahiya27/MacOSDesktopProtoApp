import Foundation
import Combine
import os.log

@MainActor
final class DataStore: ObservableObject {

    static let shared = DataStore()
    private static let logger = Logger(subsystem: "com.emoha.desktopAhaan", category: "DataStore")

    @Published var translationRecords: [TranslationRecord] = []
    @Published var practiceProgress: [PracticeProgress] = []
    @Published var studyBookmarks: [StudyBookmark] = []
    @Published var questionBookmarks: [QuestionBookmark] = []
    @Published var questionAttempts: [QuestionAttempt] = []
    @Published var studySessions: [StudySession] = []
    @Published var discoverProgress: [DiscoverProgress] = []
    /// Question IDs the parent has triaged. Used to override
    /// `Question.needsHumanReview` for auto-generated content (e.g. the 154
    /// Sanskrit MCQs) without having to edit the pack JSON.
    @Published var reviewedQuestionIds: Set<String> = []
    @Published var lastSaveError: String?

    private let storeDir: URL

    init() {
        let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask
        ).first ?? FileManager.default.temporaryDirectory
        storeDir = appSupport
            .appendingPathComponent("com.emoha.desktopAhaan")
            .appendingPathComponent("data")
        do {
            try FileManager.default.createDirectory(
                at: storeDir, withIntermediateDirectories: true
            )
        } catch {
            Self.logger.error("Failed to create data directory: \(error.localizedDescription, privacy: .public)")
            lastSaveError = "Could not create data directory. Data may not persist."
        }
        loadAll()
    }

    // MARK: - TranslationRecord

    func insert(_ record: TranslationRecord) {
        translationRecords.insert(record, at: 0)
        save(translationRecords, to: "translations.json")
    }

    func delete(_ record: TranslationRecord) {
        translationRecords.removeAll { $0.id == record.id }
        save(translationRecords, to: "translations.json")
    }

    func deleteAllTranslations() {
        translationRecords.removeAll()
        save(translationRecords, to: "translations.json")
    }

    func saveTranslations() {
        save(translationRecords, to: "translations.json")
    }

    func toggleRecordFavorite(_ record: TranslationRecord) {
        record.isFavorite.toggle()
        translationRecords = translationRecords
        save(translationRecords, to: "translations.json")
    }

    func setFavorite(recordId: UUID, isFavorite: Bool) {
        guard let record = translationRecords.first(where: { $0.id == recordId }) else { return }
        record.isFavorite = isFavorite
        translationRecords = translationRecords
        save(translationRecords, to: "translations.json")
    }

    var favorites: [TranslationRecord] {
        translationRecords
            .filter { $0.isFavorite }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var recordsByDate: [TranslationRecord] {
        translationRecords.sorted { $0.createdAt > $1.createdAt }
    }

    func findRecord(original: String, translated: String,
                    srcLang: String, tgtLang: String) -> TranslationRecord? {
        translationRecords.first {
            $0.originalText == original &&
            $0.translatedText == translated &&
            $0.sourceLanguage == srcLang &&
            $0.targetLanguage == tgtLang
        }
    }

    // MARK: - PracticeProgress

    func findProgress(phraseID: String) -> PracticeProgress? {
        practiceProgress.first { $0.phraseID == phraseID }
    }

    func upsertProgress(_ progress: PracticeProgress) {
        if let idx = practiceProgress.firstIndex(where: { $0.id == progress.id }) {
            practiceProgress[idx] = progress
        } else {
            practiceProgress.append(progress)
        }
        save(practiceProgress, to: "practice.json")
    }

    func deleteAllProgress() {
        practiceProgress.removeAll()
        save(practiceProgress, to: "practice.json")
    }

    // MARK: - StudyBookmark

    var bookmarksByDate: [StudyBookmark] {
        studyBookmarks.sorted { $0.addedAt > $1.addedAt }
    }

    func isBookmarked(subjectPackId: String, conceptId: String) -> Bool {
        let key = "\(subjectPackId)::\(conceptId)"
        return studyBookmarks.contains { $0.id == key }
    }

    func toggleBookmark(subjectPackId: String, conceptId: String,
                        conceptTitle: String) {
        let key = "\(subjectPackId)::\(conceptId)"
        if let idx = studyBookmarks.firstIndex(where: { $0.id == key }) {
            studyBookmarks.remove(at: idx)
        } else {
            studyBookmarks.append(StudyBookmark(
                subjectPackId: subjectPackId,
                conceptId: conceptId,
                conceptTitle: conceptTitle
            ))
        }
        save(studyBookmarks, to: "bookmarks.json")
    }

    func deleteBookmark(_ bookmark: StudyBookmark) {
        studyBookmarks.removeAll { $0.id == bookmark.id }
        save(studyBookmarks, to: "bookmarks.json")
    }

    // MARK: - QuestionBookmark

    var questionBookmarksByDate: [QuestionBookmark] {
        questionBookmarks.sorted { $0.addedAt > $1.addedAt }
    }

    func isQuestionBookmarked(subjectPackId: String, questionId: String) -> Bool {
        let key = "\(subjectPackId)::\(questionId)"
        return questionBookmarks.contains { $0.id == key }
    }

    func toggleQuestionBookmark(subjectPackId: String, questionId: String,
                                questionPrompt: String) {
        let key = "\(subjectPackId)::\(questionId)"
        if let idx = questionBookmarks.firstIndex(where: { $0.id == key }) {
            questionBookmarks.remove(at: idx)
        } else {
            questionBookmarks.append(QuestionBookmark(
                subjectPackId: subjectPackId,
                questionId: questionId,
                questionPrompt: questionPrompt
            ))
        }
        save(questionBookmarks, to: "questionBookmarks.json")
    }

    func deleteQuestionBookmark(_ bookmark: QuestionBookmark) {
        questionBookmarks.removeAll { $0.id == bookmark.id }
        save(questionBookmarks, to: "questionBookmarks.json")
    }

    // MARK: - QuestionAttempt

    func insertAttempt(_ attempt: QuestionAttempt) {
        questionAttempts.append(attempt)
        save(questionAttempts, to: "attempts.json")
    }

    // MARK: - StudySession

    func insertSession(_ session: StudySession) {
        studySessions.append(session)
        save(studySessions, to: "sessions.json")
    }

    // MARK: - DiscoverProgress

    func isSceneComplete(chapterId: String, sceneId: String) -> Bool {
        let key = "\(chapterId)::\(sceneId)"
        return discoverProgress.contains { $0.id == key }
    }

    func markSceneComplete(chapterId: String, sceneId: String,
                           score: Int? = nil, maxScore: Int? = nil) {
        let key = "\(chapterId)::\(sceneId)"
        if let idx = discoverProgress.firstIndex(where: { $0.id == key }) {
            if let s = score { discoverProgress[idx].score = s }
            if let m = maxScore { discoverProgress[idx].maxScore = m }
            discoverProgress[idx].completedAt = Date()
        } else {
            let row = DiscoverProgress(
                chapterId: chapterId, sceneId: sceneId,
                score: score, maxScore: maxScore
            )
            discoverProgress.append(row)
        }
        save(discoverProgress, to: "discover.json")
    }

    func discoverRows(for chapterId: String) -> [DiscoverProgress] {
        discoverProgress.filter { $0.chapterId == chapterId }
    }

    // MARK: - Review status

    /// True when the parent has flipped this question out of the
    /// "needs review" queue via the in-app Mark Reviewed button.
    func isReviewed(questionId: String) -> Bool {
        reviewedQuestionIds.contains(questionId)
    }

    /// Effective "needs review" status — the JSON flag wins unless the parent
    /// has explicitly marked the question reviewed in-app.
    func effectiveNeedsReview(_ question: Question) -> Bool {
        question.needsHumanReview && !isReviewed(questionId: question.id)
    }

    func setReviewed(questionId: String, reviewed: Bool) {
        if reviewed {
            reviewedQuestionIds.insert(questionId)
        } else {
            reviewedQuestionIds.remove(questionId)
        }
        save(Array(reviewedQuestionIds), to: "reviewedQuestionIds.json")
    }

    // MARK: - Persistence helpers

    private func save<T: Encodable>(_ items: [T], to filename: String) {
        let url = storeDir.appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: url, options: .atomic)
            lastSaveError = nil
        } catch {
            let msg = "Could not save data (\(filename)). Changes may be lost."
            lastSaveError = msg
            Self.logger.error("save \(filename, privacy: .public) failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    private func load<T: Decodable>(from filename: String) -> [T] {
        let url = storeDir.appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: url.path) else { return [] }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            // Don't silently throw away the corrupt file — rename it with a
            // timestamp so a future investigation (or the parent) can recover
            // partial data. Then return [] and surface the issue in the UI.
            let stamp = ISO8601DateFormatter().string(from: Date())
                .replacingOccurrences(of: ":", with: "-")
            let rescue = url.deletingPathExtension()
                .appendingPathExtension("corrupt.\(stamp).json")
            try? FileManager.default.moveItem(at: url, to: rescue)
            Self.logger.error("load \(filename, privacy: .public) failed: \(error.localizedDescription, privacy: .public); preserved as \(rescue.lastPathComponent, privacy: .public)")
            lastSaveError = "Saved \(filename) couldn't be read — a backup copy was preserved next to your data. Continuing with a fresh file."
            return []
        }
    }

    private func loadAll() {
        translationRecords = load(from: "translations.json")
        practiceProgress = load(from: "practice.json")
        studyBookmarks = load(from: "bookmarks.json")
        questionBookmarks = load(from: "questionBookmarks.json")
        questionAttempts = load(from: "attempts.json")
        studySessions = load(from: "sessions.json")
        discoverProgress = load(from: "discover.json")
        let reviewedArray: [String] = load(from: "reviewedQuestionIds.json")
        reviewedQuestionIds = Set(reviewedArray)
    }
}
