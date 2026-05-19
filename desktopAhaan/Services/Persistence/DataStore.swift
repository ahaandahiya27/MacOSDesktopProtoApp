import Foundation
import Combine
import os.log

// MARK: - SM-2 spaced repetition (Option B of the 2026-05-19 audit sweep)
//
// A lightweight SM-2 / Leitner-hybrid scheduler. Each question the kid
// answers in Daily Practice gets a `QuestionReview` row; the scheduler
// updates the row in place and DataStore persists the whole map to
// `reviews.json`. No external dependencies; the algorithm is small
// enough to live next to the storage it drives.
//
// Big Sur compatible: pure value types, no Combine, no macOS 12+ APIs.

/// Per-question spaced-repetition state. Keyed by `questionId` inside
/// DataStore's `questionReviews` dictionary.
struct QuestionReview: Codable, Hashable {
    let questionId: String
    /// 0 = brand new (never answered) up to 5 = mastered. Resets to 0
    /// on a `.forgot` answer so a forgotten question re-enters the
    /// near-term review queue.
    var bucket: Int
    /// SM-2 ease factor. Starts at 2.5 per the canonical SM-2 paper.
    /// Floor is 1.3 so a chronically-missed question still shows up.
    var ease: Double
    /// Days until the next review. 0 = today (re-shows in the same
    /// session for `.forgot` answers; clamped to ≥1 for non-forgot).
    var intervalDays: Int
    var lastReviewedAt: Date
    var nextDueAt: Date
    var totalReviews: Int
    /// Number of times this question has been answered `.forgot`.
    /// Surfaces as a "you keep missing this one" hint in future UI.
    var lapses: Int

    static func newReview(for questionId: String, at date: Date) -> QuestionReview {
        QuestionReview(
            questionId: questionId,
            bucket: 0, ease: 2.5, intervalDays: 0,
            lastReviewedAt: date, nextDueAt: date,
            totalReviews: 0, lapses: 0
        )
    }
}

/// What the kid says about how that review went. Maps to four buttons
/// in the review UI ("Forgot / Hard / Good / Easy"). Reading order is
/// "worse → better" so the rawValue can be used as a quality grade.
enum ReviewQuality: Int, Codable, Hashable {
    case forgot = 0
    case hard = 1
    case good = 2
    case easy = 3
}

/// Pure-function scheduler. Given the previous review state + the kid's
/// quality answer + the current time, returns the updated review row.
/// Decoupled from DataStore so it's unit-testable without any FS I/O.
enum SM2Scheduler {
    /// Tunables. Kept here (not magic numbers in the switch) so a
    /// future tweak ("first repeat should be 1 day, not 1 day after
    /// 3") is a one-line change with the unit test catching regression.
    static let minEase: Double = 1.3
    static let easeDeltaForgot: Double = -0.20
    static let easeDeltaHard: Double = -0.15
    static let easeDeltaEasy: Double = 0.10
    static let forgotRedoMinutes: Int = 10
    static let firstIntervalAfterLearn: Int = 1
    static let secondIntervalAfterLearn: Int = 3
    static let easyBoostMultiplier: Double = 1.3

    static func schedule(_ review: QuestionReview,
                          quality: ReviewQuality,
                          at now: Date,
                          calendar: Calendar = .current) -> QuestionReview {
        var r = review
        r.lastReviewedAt = now
        r.totalReviews += 1

        switch quality {
        case .forgot:
            r.lapses += 1
            r.bucket = 0
            r.intervalDays = 0
            r.ease = max(minEase, r.ease + easeDeltaForgot)
            r.nextDueAt = calendar.date(
                byAdding: .minute, value: forgotRedoMinutes, to: now
            ) ?? now

        case .hard:
            r.bucket = max(1, r.bucket)
            let prior = max(1, r.intervalDays)
            let next = max(1, Int((Double(prior) * 1.2).rounded()))
            r.intervalDays = next
            r.ease = max(minEase, r.ease + easeDeltaHard)
            r.nextDueAt = calendar.date(
                byAdding: .day, value: next, to: now
            ) ?? now

        case .good:
            r.bucket = min(5, r.bucket + 1)
            let next: Int
            if r.bucket == 1 {
                next = firstIntervalAfterLearn
            } else if r.bucket == 2 {
                next = secondIntervalAfterLearn
            } else {
                next = max(1, Int((Double(r.intervalDays) * r.ease).rounded()))
            }
            r.intervalDays = next
            r.nextDueAt = calendar.date(
                byAdding: .day, value: next, to: now
            ) ?? now

        case .easy:
            r.bucket = min(5, r.bucket + 1)
            let next: Int
            if r.bucket <= 1 {
                next = max(firstIntervalAfterLearn,
                           Int((Double(firstIntervalAfterLearn) * easyBoostMultiplier).rounded()))
            } else {
                next = max(1, Int((Double(r.intervalDays) * r.ease * easyBoostMultiplier).rounded()))
            }
            r.intervalDays = next
            r.ease += easeDeltaEasy
            r.nextDueAt = calendar.date(
                byAdding: .day, value: next, to: now
            ) ?? now
        }

        return r
    }
}

@MainActor
final class DataStore: ObservableObject {

    static let shared = DataStore()
    private static let logger = Logger(subsystem: "com.emoha.desktopAhaan", category: "DataStore")

    @Published var translationRecords: [TranslationRecord] = [] {
        didSet { _recordsByDateCache = nil }
    }
    @Published var practiceProgress: [PracticeProgress] = []
    @Published var studyBookmarks: [StudyBookmark] = [] {
        didSet { _bookmarksByDateCache = nil }
    }
    @Published var questionBookmarks: [QuestionBookmark] = [] {
        didSet { _questionBookmarksByDateCache = nil }
    }
    @Published var questionAttempts: [QuestionAttempt] = []
    @Published var studySessions: [StudySession] = []
    @Published var discoverProgress: [DiscoverProgress] = [] {
        didSet { _discoverCountByChapterCache = nil }
    }

    /// Sorted-by-date caches. The `*ByDate` accessors below re-sort the
    /// whole array on every access — fine at the typical kid's <100-item
    /// scale but pure waste when called from a body that re-renders on
    /// every dataStore publish. didSet on each underlying @Published
    /// invalidates the matching cache so the next access rebuilds once.
    private var _recordsByDateCache: [TranslationRecord]?
    private var _bookmarksByDateCache: [StudyBookmark]?
    private var _questionBookmarksByDateCache: [QuestionBookmark]?
    /// Cached chapterId → completed-scene count derived from
    /// `discoverProgress`. Invalidated on every mutation; rebuilt lazily.
    /// Replaces the per-chapter linear scan that DiscoverProgressDashboard
    /// was doing 19+ times per render.
    private var _discoverCountByChapterCache: [String: Int]?
    /// Question IDs the parent has triaged. Used to override
    /// `Question.needsHumanReview` for auto-generated content (e.g. the 154
    /// Sanskrit MCQs) without having to edit the pack JSON.
    @Published var reviewedQuestionIds: Set<String> = []

    /// Question IDs the student has flagged as "tough — review later".
    /// Surfaces in the Daily Practice sidebar tool. User-driven, distinct
    /// from `needsHumanReview` (which is content-author-driven).
    /// Added 2026-05-19 (Option B of the audit sweep).
    @Published var toughQuestionIds: Set<String> = []

    /// SM-2 spaced-repetition state, keyed by `questionId`. Added
    /// 2026-05-19 (Option B of the final audit closure). Persisted to
    /// `reviews.json`; algorithm lives in `SM2Scheduler` at the top of
    /// this file.
    @Published var questionReviews: [String: QuestionReview] = [:]

    @Published var lastSaveError: String?

    private let storeDir: URL

    /// Current persistence schema version. Bump whenever a stored JSON
    /// shape changes in a way that an older decoder would reject. The
    /// migration scaffold below runs `applyMigrations(_:to:)` from the
    /// last-seen on-disk version up to this constant before `loadAll()`
    /// reads any file.
    static let currentSchemaVersion: Int = 1

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
        runSchemaMigrationsIfNeeded()
        loadAll()
    }

    // MARK: - Schema migration scaffold (L7)

    /// Reads `schema_version` from `~/Library/Application Support/.../data/`.
    /// Defaults to 0 if missing — i.e. fresh install or never-migrated install.
    private var diskSchemaVersion: Int {
        let url = storeDir.appendingPathComponent("schema_version")
        guard let data = try? Data(contentsOf: url),
              let str = String(data: data, encoding: .utf8),
              let v = Int(str.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return 0
        }
        return v
    }

    private func writeDiskSchemaVersion(_ version: Int) {
        let url = storeDir.appendingPathComponent("schema_version")
        try? "\(version)".data(using: .utf8)?.write(to: url, options: .atomic)
    }

    /// Runs every `migrate_<n>_to_<n+1>()` step from the on-disk version
    /// up to `currentSchemaVersion`. Today only the version-stamp pass
    /// exists; future schema bumps add a step here.
    private func runSchemaMigrationsIfNeeded() {
        let from = diskSchemaVersion
        let to = Self.currentSchemaVersion
        guard from < to else {
            // Either already up-to-date or somehow ahead (downgrade?) — in
            // either case, leave files alone.
            return
        }
        Self.logger.info("DataStore migration: \(from, privacy: .public) → \(to, privacy: .public)")
        // No real migrations to run yet — bumping from 0 (no stamp) to 1
        // just marks "this install has been versioned now". The scaffold
        // is in place so a future Codable shape change can add:
        //   if from < 2 { migrate_1_to_2() }
        //   if from < 3 { migrate_2_to_3() }
        writeDiskSchemaVersion(to)
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
        if let cached = _recordsByDateCache { return cached }
        let built = translationRecords.sorted { $0.createdAt > $1.createdAt }
        _recordsByDateCache = built
        return built
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
        if let cached = _bookmarksByDateCache { return cached }
        let built = studyBookmarks.sorted { $0.addedAt > $1.addedAt }
        _bookmarksByDateCache = built
        return built
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
        if let cached = _questionBookmarksByDateCache { return cached }
        let built = questionBookmarks.sorted { $0.addedAt > $1.addedAt }
        _questionBookmarksByDateCache = built
        return built
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

    /// Fast count-only accessor for `discoverProgress` rows by chapter.
    /// Use this in dashboards / sidebars that only need the count — the
    /// per-chapter cache avoids the linear scan that `discoverRows(for:)`
    /// performs.
    func discoverRowCount(for chapterId: String) -> Int {
        if _discoverCountByChapterCache == nil {
            _discoverCountByChapterCache = Dictionary(
                grouping: discoverProgress, by: { $0.chapterId }
            ).mapValues { $0.count }
        }
        return _discoverCountByChapterCache?[chapterId] ?? 0
    }

    // MARK: - Tough-question flagging (Daily Practice)

    /// True if this question has been flagged "review later" by the student.
    func isToughQuestion(_ questionId: String) -> Bool {
        toughQuestionIds.contains(questionId)
    }

    /// Toggle a question's tough flag. Persists immediately.
    ///
    /// As a side effect, flagging a question tough also seeds an SM-2
    /// review row scheduled for "now" if none exists. Without that seed,
    /// the Daily Practice review queue would stay empty until the kid
    /// happened to answer a question inside the review sheet — which
    /// is a chicken-and-egg problem (you can't start a session with
    /// zero items). Tough-flagging is the kid's signal of "I want to
    /// see this again", so we honour that immediately.
    func toggleToughQuestion(_ questionId: String) {
        if toughQuestionIds.contains(questionId) {
            toughQuestionIds.remove(questionId)
        } else {
            toughQuestionIds.insert(questionId)
            if questionReviews[questionId] == nil {
                let now = Date()
                questionReviews[questionId] = QuestionReview.newReview(
                    for: questionId, at: now)
                save(Array(questionReviews.values), to: "reviews.json")
            }
        }
        save(Array(toughQuestionIds), to: "toughQuestionIds.json")
    }

    // MARK: - Spaced-repetition reviews (Option B)

    /// Record the kid's answer to a question, updating its scheduler
    /// state (or creating it on first contact). Persists immediately.
    func recordReview(questionId: String,
                      quality: ReviewQuality,
                      at now: Date = Date()) {
        let prior = questionReviews[questionId]
            ?? QuestionReview.newReview(for: questionId, at: now)
        let updated = SM2Scheduler.schedule(prior, quality: quality, at: now)
        questionReviews[questionId] = updated
        save(Array(questionReviews.values), to: "reviews.json")
    }

    /// Questions that are due for review at or before `now`. Returns the
    /// most-overdue questions first so the kid sees the items that have
    /// been waiting longest. Items with no review row yet are NOT
    /// included — they only enter the system once the kid answers them
    /// once. This means Daily Practice grows as the kid uses the app
    /// rather than dumping all 732 questions on day one.
    func dueQuestionIds(at now: Date = Date()) -> [String] {
        questionReviews.values
            .filter { $0.nextDueAt <= now }
            .sorted { $0.nextDueAt < $1.nextDueAt }
            .map { $0.questionId }
    }

    /// Count of questions due now — cheap accessor for the sidebar/header.
    func dueQuestionCount(at now: Date = Date()) -> Int {
        questionReviews.values.filter { $0.nextDueAt <= now }.count
    }

    // MARK: - Discover-mode all-chapters completion

    /// Total number of Discover scenes across the science pack: 19
    /// chapters × 9 scenes (Scene 1–8 + Boss Quiz) = 171. Hard-coded
    /// rather than derived because the chapter dispatchers all declare
    /// 9-entry sceneTitles arrays and changing scene counts is a
    /// structural decision, not a routine pack edit.
    static let totalDiscoverScenes = 171

    /// True once every Discover scene across all 19 science chapters
    /// has been marked complete. Used by the "you finished Discover
    /// Mode!" celebration overlay (DM7/EM4 in the visual sweep).
    var allDiscoverChaptersComplete: Bool {
        discoverProgress.count >= Self.totalDiscoverScenes
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
        let toughArray: [String] = load(from: "toughQuestionIds.json")
        toughQuestionIds = Set(toughArray)
        let reviewsArray: [QuestionReview] = load(from: "reviews.json")
        // Crash-safe merge: if a corrupt reviews.json ever has two rows
        // for the same questionId, keep the newer one rather than calling
        // `Dictionary(uniqueKeysWithValues:)` which would crash on the
        // duplicate. CrashReporter.logDataIssue records the collision.
        questionReviews = Dictionary(
            reviewsArray.map { ($0.questionId, $0) },
            uniquingKeysWith: { a, b in
                CrashReporter.shared.logDataIssue(
                    "reviews.json contained duplicate questionId=\(a.questionId); kept newer row.")
                return a.lastReviewedAt >= b.lastReviewedAt ? a : b
            }
        )
    }
}
