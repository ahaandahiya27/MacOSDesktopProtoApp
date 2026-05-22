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

/// One free-form notebook entry per chapter. Persisted as an array of
/// these in `notes.json` so the existing `save`/`readFile` helpers
/// (which both take `[T]`) can be reused without changing their
/// signatures. The in-memory representation on DataStore is a dict
/// keyed by chapterId for O(1) lookup from the notebook sheet.
struct ChapterNote: Codable, Hashable {
    let chapterId: String
    var text: String
    var updatedAt: Date
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
    nonisolated private static let logger = Logger(
        subsystem: "com.emoha.desktopAhaan",
        category: "DataStore"
    )

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

    /// Chapter notebook — free-form text the kid jots while learning a
    /// chapter. Keyed by `chapter.id` (e.g. "ch01"). Persisted to
    /// `notes.json`. No size limit at this scale; written through
    /// `saveCoalesced` since mid-typing fires every keystroke.
    @Published var chapterNotes: [String: String] = [:]

    @Published var lastSaveError: String?

    private let storeDir: URL

    // MARK: - Coalesced-write infrastructure
    //
    // Hot mutators (recordReview / markSceneComplete / toggleToughQuestion
    // / etc.) can fire several times per second during a review session.
    // The full-file rewrite-on-every-change pattern was producing back-to-
    // back fsyncs that contributed to multi-hundred-ms main-thread hangs
    // on the Big Sur iMac's spinning disk.
    //
    // Two layers of mitigation:
    //
    //   1. Coalescing (`saveCoalesced(_:to:)`): within the 250 ms debounce
    //      window the LAST submission wins. Intermediate states would be
    //      overwritten on the very next mutation anyway, so dropping them
    //      is safe. Encoding happens on main at submission time so the
    //      payload reflects the model snapshot exactly when the user
    //      acted.
    //
    //   2. Off-main writes (`performAtomicWrite`): the `Data.write(to:
    //      options:.atomic)` call — which does the fsync — runs on the
    //      shared `saveQueue` (serial, .userInitiated background). The
    //      main thread is never blocked by the disk fsync at runtime.
    //      Error reports hop back via `DispatchQueue.main.async` to
    //      mutate the @Published `lastSaveError` banner.
    //
    // Invariants:
    //   - `applicationWillTerminate` calls `flushSavesBeforeQuit()` which
    //     dispatches all pending writes and then `saveQueue.sync { }`s to
    //     block main until they land — accepting the brief stall at quit
    //     time so data is durable.
    //   - The cold `save(_:to:)` path stays for one-shot user-driven
    //     operations (e.g. clearAll). It also encodes on main and writes
    //     off main, same pattern as the coalesced path.
    //   - Captures-by-value of the encoded snapshot at submission time
    //     means the off-main write sees a frozen copy of the data even
    //     if the in-memory model mutates again before the write lands.

    /// Filename → latest encoded payload waiting to be written. Updated
    /// on every `saveCoalesced` call; consumed when the debounce timer
    /// fires or `flushSavesBeforeQuit` runs.
    private var pendingSavePayloads: [String: (url: URL, data: Data)] = [:]
    /// Filename → debounce timer. Cancelled and replaced on every
    /// subsequent `saveCoalesced` call within the window.
    private var pendingSaveTimers: [String: Timer] = [:]
    private let coalesceDelaySeconds: TimeInterval = 0.25

    /// Serial background queue for the actual `Data.write(to:options:.atomic)`
    /// calls. Encoding happens on main (cheap; ms for the largest files we
    /// store), but the fsync inside the atomic write is the part that
    /// stalls — single-digit ms on SSD, tens to a couple hundred ms on the
    /// Big Sur iMac's spinning disk. Per-instance would lock us into one
    /// DataStore so I keep it `static`; serial ordering across all callers
    /// is exactly what we want for atomicity (different files don't
    /// interleave; same file's later writes overwrite earlier ones).
    nonisolated static let saveQueue = DispatchQueue(
        label: "com.emoha.desktopAhaan.DataStore.save",
        qos: .userInitiated
    )

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
        // loadAll() previously did 11 synchronous JSON file reads on the
        // main actor before init returned. Files are tiny today but the
        // cumulative cost still ran on the cold-launch critical path —
        // any growth (e.g. attempts.json after a year of practice) would
        // start to show up in the cold-launch hang detector. Move all
        // reads off-thread, hop back to main to assign @Published.
        Task.detached(priority: .userInitiated) { [storeDir] in
            await Self.loadAllOffThread(into: self, from: storeDir)
        }
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
        // Coalesced — PracticeViewModel can fire several upserts per
        // word during scoring, and the file is rewritten in full each
        // time. Flushed at terminate.
        saveCoalesced(practiceProgress, to: "practice.json")
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
        // Coalesced — every wrong-answer retry fires this, and a typical
        // practice session writes dozens of attempts in seconds.
        saveCoalesced(questionAttempts, to: "attempts.json")
    }

    // MARK: - StudySession

    func insertSession(_ session: StudySession) {
        studySessions.append(session)
        saveCoalesced(studySessions, to: "sessions.json")
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
        // Coalesced — completing a quick scene chain (Boss Quiz auto-
        // advances on the final question) can mark several scenes in
        // quick succession.
        saveCoalesced(discoverProgress, to: "discover.json")
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
    /// Also credits the streak — idempotent within a calendar day.
    func recordReview(questionId: String,
                      quality: ReviewQuality,
                      at now: Date = Date()) {
        let prior = questionReviews[questionId]
            ?? QuestionReview.newReview(for: questionId, at: now)
        let updated = SM2Scheduler.schedule(prior, quality: quality, at: now)
        questionReviews[questionId] = updated
        // Coalesced — a 10-question review session writes once at the end,
        // not 10 times in 30 seconds. flushSavesBeforeQuit covers ⌘Q.
        saveCoalesced(Array(questionReviews.values), to: "reviews.json")
        creditReviewStreak(at: now)
    }

    /// Save (or clear) the notebook text for a chapter. Empty strings
    /// remove the entry so the disk file doesn't accumulate empties.
    func setChapterNote(_ text: String, forChapterId chapterId: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            chapterNotes.removeValue(forKey: chapterId)
        } else {
            chapterNotes[chapterId] = text
        }
        let rows = chapterNotes.map {
            ChapterNote(chapterId: $0.key, text: $0.value, updatedAt: Date())
        }
        saveCoalesced(rows, to: "notes.json")
    }

    /// Streak rules — applied each time the kid records a review:
    ///   - First-ever review: streak = 1, lastDate = today.
    ///   - Same day as lastDate: no change (idempotent within the day).
    ///   - Exactly one day after lastDate: streak += 1, lastDate = today.
    ///   - More than one day gap: streak = 1, lastDate = today (reset).
    private func creditReviewStreak(at now: Date) {
        let defaults = UserDefaults.standard
        let fmt = DateFormatter()
        fmt.calendar = Calendar(identifier: .gregorian)
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "yyyy-MM-dd"
        let today = fmt.string(from: now)
        let lastDate = defaults.string(forKey: AppStorageKeys.reviewStreakLastDate)
        let current = defaults.integer(forKey: AppStorageKeys.reviewStreakDays)

        guard lastDate != today else { return }   // already counted today

        let calendar = Calendar(identifier: .gregorian)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)
            .map { fmt.string(from: $0) }

        let nextStreak: Int
        if let last = lastDate, last == yesterday {
            nextStreak = current + 1
        } else {
            // First ever (lastDate nil) or a multi-day gap — reset to 1.
            nextStreak = 1
        }

        defaults.set(nextStreak, forKey: AppStorageKeys.reviewStreakDays)
        defaults.set(today, forKey: AppStorageKeys.reviewStreakLastDate)

        // Track all-time best for the Streak History display.
        let priorBest = defaults.integer(forKey: AppStorageKeys.reviewStreakBest)
        if nextStreak > priorBest {
            defaults.set(nextStreak, forKey: AppStorageKeys.reviewStreakBest)
        }
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

    /// Per-chapter Discover scene counts. Single source of truth — when
    /// a chapter grows or shrinks, update this dictionary and the
    /// `totalDiscoverScenes` computed sum re-derives automatically.
    /// `testTotalDiscoverScenesPinnedAt380` in ChapterContentTests
    /// fails if the sum drifts unintentionally.
    ///
    /// Expansion history:
    ///   - Original (pre-2026-05-20): all 19 chapters at 9 scenes each = 171
    ///   - 2026-05-20: Ch.1-5 expanded 9 → 20
    ///   - 2026-05-21: Ch.6-19 expanded 9 → 20
    ///   - 2026-05-21 (later): Ch.1 picks up Van Helmont enrichment scene → 21
    ///   - 2026-05-21 (later still): Ch.2 picks up Window-in-the-Stomach scene → 21
    /// Current: 17 chapters at 20 + Ch.1 & Ch.2 at 21 = 382.
    static let discoverSceneCounts: [Int: Int] = [
        1: 21, 2: 21, 3: 20, 4: 20, 5: 20,
        6: 20, 7: 20, 8: 20, 9: 20, 10: 20,
        11: 20, 12: 20, 13: 20, 14: 20, 15: 20,
        16: 20, 17: 20, 18: 20, 19: 20
    ]

    /// Total Discover scenes across the science pack — derived from
    /// `discoverSceneCounts`. Gates the "all chapters complete"
    /// celebration overlay.
    static let totalDiscoverScenes: Int = discoverSceneCounts.values.reduce(0, +)

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

    /// Cold-path save: encode on main, atomic-write off main. Error path
    /// reports back to the @MainActor `lastSaveError` banner via a
    /// `DispatchQueue.main.async` hop. The hop converts the Cocoa error
    /// into its `localizedDescription` String on the background side so
    /// the cross-thread value stays Sendable (NSError isn't).
    private func save<T: Encodable>(_ items: [T], to filename: String) {
        let url = storeDir.appendingPathComponent(filename)
        let data: Data
        do {
            data = try JSONEncoder().encode(items)
        } catch {
            // Encode failure is on main and rare (only happens if a
            // Codable conformance is broken). Surface immediately.
            lastSaveError = "Could not save data (\(filename)). Changes may be lost."
            Self.logger.error("encode \(filename, privacy: .public) failed: \(error.localizedDescription, privacy: .public)")
            return
        }
        Self.performAtomicWrite(data: data, to: url, filename: filename) { [weak self] errorDescription in
            // Always on main via DispatchQueue.main.async hop.
            guard let self = self else { return }
            if let errorDescription = errorDescription {
                self.lastSaveError = "Could not save data (\(filename)). Changes may be lost."
                Self.logger.error("save \(filename, privacy: .public) failed: \(errorDescription, privacy: .public)")
            } else {
                self.lastSaveError = nil
            }
        }
    }

    /// Off-main atomic-write helper. Schedules the write on `saveQueue`,
    /// converts any error to its String description on the background
    /// side, and hops back to main via `DispatchQueue.main.async` to
    /// invoke `completion`. Sendable-clean (String only) — no NSError
    /// crosses the actor hop.
    nonisolated private static func performAtomicWrite(
        data: Data,
        to url: URL,
        filename: String,
        completion: @escaping (String?) -> Void
    ) {
        saveQueue.async {
            var errorDescription: String? = nil
            do {
                try data.write(to: url, options: .atomic)
            } catch {
                errorDescription = error.localizedDescription
            }
            // Hop back to main for the completion. The completion mutates
            // @Published `lastSaveError` which must be on the main actor.
            DispatchQueue.main.async {
                completion(errorDescription)
            }
        }
    }

    /// Debounced write for high-frequency mutators. Encodes the snapshot
    /// at submission time, stashes it under the filename key, and resets
    /// a debounce timer; if another submission arrives within the window
    /// it replaces the payload (only the latest matters since each save
    /// rewrites the file in full). Net effect: rapid mutations land as
    /// one main-thread write of the latest state at the end of the
    /// coalescing window.
    private func saveCoalesced<T: Encodable>(_ items: [T], to filename: String) {
        let url = storeDir.appendingPathComponent(filename)
        let encoded: Data
        do {
            encoded = try JSONEncoder().encode(items)
        } catch {
            lastSaveError = "Could not encode \(filename). Changes may be lost."
            Self.logger.error("encode \(filename, privacy: .public) failed: \(error.localizedDescription, privacy: .public)")
            return
        }
        pendingSavePayloads[filename] = (url, encoded)
        pendingSaveTimers[filename]?.invalidate()
        pendingSaveTimers[filename] = Timer.scheduledTimer(
            withTimeInterval: coalesceDelaySeconds, repeats: false
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.flushPendingSave(filename: filename)
            }
        }
    }

    /// Consume the pending payload for `filename` (if any) and dispatch
    /// it to the off-main saveQueue for an atomic write. The dequeue
    /// happens on main (so two main-actor calls for the same filename
    /// can't double-dispatch the same payload); the actual write runs
    /// in the background.
    private func flushPendingSave(filename: String) {
        pendingSaveTimers.removeValue(forKey: filename)?.invalidate()
        guard let payload = pendingSavePayloads.removeValue(forKey: filename) else { return }
        Self.performAtomicWrite(data: payload.data, to: payload.url, filename: filename) { [weak self] errorDescription in
            guard let self = self else { return }
            if let errorDescription = errorDescription {
                self.lastSaveError = "Could not save data (\(filename)). Changes may be lost."
                Self.logger.error("coalesced-save \(filename, privacy: .public) failed: \(errorDescription, privacy: .public)")
            } else {
                self.lastSaveError = nil
            }
        }
    }

    /// Drain every pending coalesced write synchronously. Called from
    /// `applicationWillTerminate` so a clean ⌘Q doesn't lose mutations
    /// that landed inside the last 250ms debounce window. Safe to call
    /// when nothing is pending — no-op.
    ///
    /// `saveQueue.sync { }` after dispatching all pending writes blocks
    /// the calling thread (main) until the serial queue has drained.
    /// Standard pattern — saveQueue runs on a background thread and
    /// doesn't need main to make progress, so no deadlock. We accept
    /// some main-thread block at quit time because the alternative
    /// (returning before writes land) defeats the purpose. Bounded by
    /// the size of `pendingSavePayloads`, which today is ≤ 11 files of
    /// kilobytes each.
    func flushSavesBeforeQuit() {
        let filenames = Array(pendingSavePayloads.keys)
        for filename in filenames {
            flushPendingSave(filename: filename)
        }
        // Wait for every write we just dispatched to land on disk.
        Self.saveQueue.sync { }
    }

    /// Number of writes still queued in the coalesced-save buffer. Used
    /// by `applicationWillTerminate` to detect a truncation event when
    /// `flushSavesBeforeQuit`'s 1-second semaphore wait expires before
    /// the drain finishes (audit Top-10 #6). Read on the main actor.
    var pendingSaveCount: Int { pendingSavePayloads.count }

    /// Nonisolated file read — runs anywhere, touches no main-actor state.
    /// Returns the decoded array and a backup-rescue flag so the caller
    /// can surface the user-facing error message on the main thread.
    nonisolated private static func readFile<T: Decodable>(
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
    nonisolated private static func loadAllOffThread(
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
            || notes.didRescueCorruptFile

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
            if anyRescue {
                store.lastSaveError = "Saved data couldn't be read — a backup copy was preserved next to your data. Continuing with a fresh file."
            }
        }
    }
}
