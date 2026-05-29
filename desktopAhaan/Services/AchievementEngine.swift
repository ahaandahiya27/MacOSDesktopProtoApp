import Foundation
import Combine
import AppKit

// MARK: - AchievementEngine
//
// Observes the live `DataStore` (and `SubjectRegistry`), rebuilds the
// metric snapshot after every change, and unlocks any badge whose
// criterion just became satisfied. On unlock it persists the map and
// fires the top-right toast (+ a celebratory sound for gold/platinum).
//
// Design notes:
//   • The unlock map lives HERE, not on DataStore (extensions can't add
//     stored properties, and DataStore.swift is at its LOC ceiling).
//     Persistence delegates to `DataStore.loadAchievementUnlocks()` /
//     `saveAchievementUnlocks(_:)` so the on-disk plumbing is shared.
//   • Observation is a debounced sink on `objectWillChange` of both the
//     store and the registry. Every signal the criteria read
//     (`questionReviews`, `understoodConceptIds`, `discoverProgress`,
//     `readArticleIds`, and the streak defaults that `recordReview`
//     bumps) flows through one of those publishers, so a single sink
//     covers them all.
//   • `newlyUnlocked(in:now:)` is the pure, side-effect-free core — it
//     mutates the map and returns the freshly-unlocked badges. Tests call
//     it directly with hand-built snapshots; `evaluate()` wraps it with
//     persistence + toast.
//   • The first evaluation after launch is a SILENT backfill: a kid who
//     already has a streak / understood concepts from before this feature
//     shipped gets those badges recorded without a burst of toasts.
//
// Big Sur compatible: Combine + AppKit only, no macOS 12+ APIs.

@MainActor
final class AchievementEngine: ObservableObject {
    static let shared = AchievementEngine()

    /// `id → unlockedAt`. Published so the gallery re-renders the instant a
    /// badge flips from locked to unlocked.
    @Published private(set) var unlocks: [String: Date] = [:]

    private var cancellables = Set<AnyCancellable>()
    private weak var dataStore: DataStore?
    private weak var registry: SubjectRegistry?
    private var started = false

    /// Toast surface. Overridable so tests can swap in a no-op (the
    /// default presenter creates real `NSPanel`s).
    var toastPresenter: AchievementToastPresenter = .shared

    /// Optional hook fired for every newly-unlocked badge (after the map
    /// is updated). Used by tests; nil in production.
    var onUnlock: ((Achievement) -> Void)?

    /// init is accessible (not private) so tests can build an isolated
    /// engine without the shared singleton's persisted state.
    init() {}

    // MARK: - Lifecycle

    /// Wire the engine to the live store + registry. Idempotent — a second
    /// call is a no-op so a re-rendered `onAppear` can't double-subscribe.
    func start(dataStore: DataStore, registry: SubjectRegistry) {
        guard !started else { return }
        started = true
        self.dataStore = dataStore
        self.registry = registry
        unlocks = dataStore.loadAchievementUnlocks()

        dataStore.objectWillChange
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.evaluate() }
            .store(in: &cancellables)

        // Pack load completes after launch; chapter/subject mastery counts
        // need the concept lists, so re-evaluate when the registry settles.
        registry.objectWillChange
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.evaluate() }
            .store(in: &cancellables)

        // Silent backfill of anything already earned.
        evaluate(initial: true)
    }

    // MARK: - Evaluation

    /// Recompute the snapshot, unlock newly-satisfied badges, persist, and
    /// (unless `initial`) toast each one. Returns the freshly-unlocked set.
    @discardableResult
    func evaluate(initial: Bool = false, now: Date = Date()) -> [Achievement] {
        guard let dataStore = dataStore else { return [] }
        let snapshot = dataStore.achievementSnapshot(registry: registry, now: now)
        let newly = newlyUnlocked(in: snapshot, now: now)
        guard !newly.isEmpty else { return [] }
        dataStore.saveAchievementUnlocks(unlocks)
        if !initial {
            for badge in newly { present(badge) }
        }
        return newly
    }

    /// Pure core: add every now-satisfied, not-yet-recorded badge to the
    /// map (stamped `now`) and return them. No persistence, no toast — so
    /// tests can drive it directly with any snapshot.
    @discardableResult
    func newlyUnlocked(in snapshot: AchievementSnapshot, now: Date) -> [Achievement] {
        var newly: [Achievement] = []
        for badge in Achievement.all where unlocks[badge.id] == nil {
            if badge.isUnlocked(in: snapshot) {
                unlocks[badge.id] = now
                newly.append(badge)
            }
        }
        return newly
    }

    // MARK: - Read accessors (gallery)

    func isUnlocked(_ id: String) -> Bool { unlocks[id] != nil }
    func unlockDate(_ id: String) -> Date? { unlocks[id] }
    var unlockedCount: Int { unlocks.count }

    // MARK: - Side effects

    private func present(_ badge: Achievement) {
        onUnlock?(badge)
        toastPresenter.show(badge)
        // Gold/platinum chime, but never under Reduce Motion (the kid has
        // asked for a calmer experience — honour it for audio too).
        if badge.tier.playsCelebrationSound,
           !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion {
            NSSound(named: NSSound.Name("Glass"))?.play()
        }
    }
}
