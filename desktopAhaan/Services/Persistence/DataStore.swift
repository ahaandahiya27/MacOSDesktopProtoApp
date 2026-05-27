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
    /// The id of the subject pack this review belongs to, captured at
    /// record time. Optional because (a) `reviews.json` rows written
    /// before this field existed decode it as nil, and (b) ephemeral
    /// surfaces with globally-unique prefixed ids don't need it.
    ///
    /// Why it matters: bare topic-question ids (`chNN_tNN_qNN`) are
    /// ALLOWED to collide across packs (Science/Sanskrit/Maths share
    /// the scheme), so resolving a review by id alone is ambiguous —
    /// `SubjectRegistry.location(forQuestionId:)` would pick whichever
    /// pack sorts first (Maths). Storing the pack here lets every
    /// surface (Recently-Missed, Mastery, Daily Practice) resolve the
    /// review back to the subject the kid actually answered it in.
    var packId: String? = nil

    static func newReview(for questionId: String, at date: Date,
                          packId: String? = nil) -> QuestionReview {
        QuestionReview(
            questionId: questionId,
            bucket: 0, ease: 2.5, intervalDays: 0,
            lastReviewedAt: date, nextDueAt: date,
            totalReviews: 0, lapses: 0, packId: packId
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
    /// Upper clamp on ease so repeated `.easy` answers can't grow the factor
    /// (and therefore future intervals) without bound. SM-2 starts at 2.5;
    /// 3.0 leaves comfortable headroom while keeping intervals sane.
    static let maxEase: Double = 3.0
    static let easeDeltaForgot: Double = -0.20
    static let easeDeltaHard: Double = -0.15
    static let easeDeltaEasy: Double = 0.10
    static let forgotRedoMinutes: Int = 10
    static let firstIntervalAfterLearn: Int = 1
    static let secondIntervalAfterLearn: Int = 3
    static let easyBoostMultiplier: Double = 1.3
    /// Hard ceiling on a single interval (days). Without it, repeated
    /// Easy/Good answers grow `Double(intervalDays) * ease * boost`
    /// exponentially until the `Int(...)` conversion TRAPS past Int.max
    /// (a real crash, forbidden by the no-trap rule). ~1 year is also a
    /// sane pedagogical maximum spacing.
    static let maxIntervalDays: Int = 365

    /// Round a raw interval and clamp it to `[1, maxIntervalDays]` entirely
    /// in Double space, so the final `Int` conversion can never receive an
    /// out-of-range (or infinite) value and trap.
    static func clampedInterval(_ raw: Double) -> Int {
        Int(min(Double(maxIntervalDays), max(1.0, raw.rounded())))
    }

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
            let next = clampedInterval(Double(prior) * 1.2)
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
                next = clampedInterval(Double(r.intervalDays) * r.ease)
            }
            r.intervalDays = next
            r.nextDueAt = calendar.date(
                byAdding: .day, value: next, to: now
            ) ?? now

        case .easy:
            r.bucket = min(5, r.bucket + 1)
            let next: Int
            if r.bucket <= 1 {
                // Easy on first learn must out-space Good (which gives
                // firstIntervalAfterLearn = 1). round(1 * 1.3) = 1 collapsed
                // the boost to the same 1-day interval, so Easy gave no
                // advantage. Floor at secondIntervalAfterLearn so Easy
                // genuinely skips a card ahead.
                next = max(secondIntervalAfterLearn,
                           clampedInterval(Double(firstIntervalAfterLearn) * easyBoostMultiplier))
            } else {
                next = clampedInterval(Double(r.intervalDays) * r.ease * easyBoostMultiplier)
            }
            r.intervalDays = next
            r.ease = min(maxEase, r.ease + easeDeltaEasy)
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
    // `internal` (default) so DataStore+Loading.swift and
    // DataStore+Saving.swift can reach the same logger from their
    // extension-defined static helpers.
    nonisolated static let logger = Logger(
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

    /// Article IDs the kid has marked as "read" — surfaces a small
    /// checkmark badge on `ExtraReadingRow` chips and the primary
    /// `ArticleEntryButton`. User-driven (a button in `ArticleBrowserView`'s
    /// footer toggles the flag). Persisted to `readArticleIds.json`.
    /// Added 2026-05-26.
    @Published var readArticleIds: Set<String> = []

    /// Concept IDs the kid has marked as "I understand this" via the
    /// thumbs-up toggle on `ConceptDetailView`. Surfaces a "5/8
    /// understood" count on each `ChapterRow`. Distinct from
    /// `studyBookmarks` (bookmark = "come back to this") and from
    /// `questionReviews` (SM-2 = "what's due next"). Persisted to
    /// `understoodConceptIds.json`. Added 2026-05-26.
    @Published var understoodConceptIds: Set<String> = []

    @Published var lastSaveError: String?

    // `internal` (default) so save/load helpers in the extension files
    // (`DataStore+Saving.swift`, `DataStore+Loading.swift`) can reach
    // `storeDir` without crossing the file-private boundary.
    let storeDir: URL

    // MARK: - Coalesced-write infrastructure (storage)
    //
    // Stored properties for the coalesced-write design. The methods that
    // operate on these (`save`, `saveCoalesced`, `flushPendingSave`,
    // `flushSavesBeforeQuit`, `performAtomicWrite`) live in
    // `DataStore+Saving.swift` along with the design comment block. The
    // dicts and timer stay here because Swift doesn't allow stored
    // properties in extensions.

    /// Filename → latest encoded payload waiting to be written. Updated
    /// on every `saveCoalesced` call; consumed when the debounce timer
    /// fires or `flushSavesBeforeQuit` runs.
    var pendingSavePayloads: [String: (url: URL, data: Data)] = [:]
    /// Filename → debounce timer. Cancelled and replaced on every
    /// subsequent `saveCoalesced` call within the window.
    var pendingSaveTimers: [String: Timer] = [:]
    let coalesceDelaySeconds: TimeInterval = 0.25

    /// Current persistence schema version. Bump whenever a stored JSON
    /// shape changes in a way that an older decoder would reject. The
    /// migration scaffold below runs `applyMigrations(_:to:)` from the
    /// last-seen on-disk version up to this constant before `loadAll()`
    /// reads any file.
    static let currentSchemaVersion: Int = 1

    /// Calendar used by the streak engine for yyyy-MM-dd day-boundary
    /// math. In production this is a fresh Gregorian calendar using the
    /// system timezone (default — i.e. "today" matches the kid's wall-
    /// clock). In tests this can be overridden with a UTC calendar so
    /// the streak assertions are deterministic across any CI machine's
    /// timezone.
    ///
    /// Why this matters: before this injection point, the engine
    /// constructed a fresh `Calendar(identifier: .gregorian)` per call
    /// (system TZ) while tests used `Calendar.current` (autoupdating).
    /// On most machines they agreed, but on machines where
    /// `NSLocale.current` returned a non-Gregorian default identifier
    /// (e.g. ja_JP with Japanese calendar), the two could disagree and
    /// the test would flake. The CLAUDE.md "retry the push once before
    /// assuming a real failure" rule existed to ride out this exact
    /// class of flake — and is now obsolete with this commit.
    let streakCalendar: Calendar

    /// Lazily-built formatter that uses `streakCalendar`. Kept as a
    /// stored property so we don't re-build it on every recordReview
    /// call (DateFormatter init is relatively expensive).
    private let streakDayFormatter: DateFormatter

    init(streakCalendar: Calendar? = nil,
         storeDir overrideStoreDir: URL? = nil,
         autoLoad: Bool = true) {
        // Default to a fresh Gregorian calendar in the system timezone
        // — equivalent to the pre-refactor inline calendar. Tests pass
        // a UTC Gregorian to make their day math deterministic.
        // Default is materialised inside the init body rather than the
        // signature because (a) `Self.defaultStreakCalendar` can't
        // appear in a covariant-Self default arg, and (b) the static
        // is MainActor-isolated and default args evaluate in a
        // nonisolated context — both errors caught by Swift 5.5 on
        // Big Sur and worth keeping the workaround documented.
        let resolvedCalendar = streakCalendar ?? Calendar(identifier: .gregorian)
        self.streakCalendar = resolvedCalendar
        let fmt = DateFormatter()
        fmt.calendar = resolvedCalendar
        fmt.timeZone = resolvedCalendar.timeZone
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.dateFormat = "yyyy-MM-dd"
        self.streakDayFormatter = fmt

        // `storeDir` defaults to the user's Application Support directory
        // for ship code; tests pass a temp directory to keep their state
        // isolated. `autoLoad` exists so tests can skip the off-thread
        // load that would otherwise race against test setUp() resetting
        // `@Published` state.
        if let override = overrideStoreDir {
            storeDir = override
        } else {
            let appSupport = FileManager.default.urls(
                for: .applicationSupportDirectory, in: .userDomainMask
            ).first ?? FileManager.default.temporaryDirectory
            storeDir = appSupport
                .appendingPathComponent("com.emoha.desktopAhaan")
                .appendingPathComponent("data")
        }
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
        if autoLoad {
            Task.detached(priority: .userInitiated) { [storeDir] in
                await Self.loadAllOffThread(into: self, from: storeDir)
            }
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
                      at now: Date = Date(),
                      packId: String? = nil) {
        let prior = questionReviews[questionId]
            ?? QuestionReview.newReview(for: questionId, at: now, packId: packId)
        var updated = SM2Scheduler.schedule(prior, quality: quality, at: now)
        // Backfill/refresh the owning pack when the caller knows it.
        // `schedule` already preserves a previously-stored packId via its
        // `var r = review` copy, so a nil here never clears a known value.
        if let packId { updated.packId = packId }
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
    ///
    /// Uses the injected `streakCalendar` + `streakDayFormatter` so
    /// the day-boundary math is deterministic across machine
    /// timezones. Tests override `streakCalendar` with UTC; production
    /// gets the system default (so "today" matches the kid's clock).
    private func creditReviewStreak(at now: Date) {
        let defaults = UserDefaults.standard
        let today = streakDayFormatter.string(from: now)
        let lastDate = defaults.string(forKey: AppStorageKeys.reviewStreakLastDate)
        let current = defaults.integer(forKey: AppStorageKeys.reviewStreakDays)

        guard lastDate != today else { return }   // already counted today

        let yesterday = streakCalendar.date(byAdding: .day, value: -1, to: now)
            .map { streakDayFormatter.string(from: $0) }

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
    //
    // Save helpers live in `DataStore+Saving.swift`.
    // Load helpers live in `DataStore+Loading.swift`.
}
