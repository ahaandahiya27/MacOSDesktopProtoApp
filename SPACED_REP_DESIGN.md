# Spaced Repetition — Design + State Audit · 2026-05-24

Pre-session read of every progress-related file. The session brief
assumed the SRS layer needed to be built from scratch; the audit
below shows that **the schema + algorithm + persistence + Daily
Drill UI all already shipped in the 2026-05-19 audit close-out**.
What's missing is the **mastery / aggregation layer** that turns the
existing per-question state into a visible learning loop.

## What already ships at HEAD `15562b0`

### Schema — `DataStore.swift:17-44`

```swift
struct QuestionReview: Codable, Hashable {
    let questionId: String
    var bucket: Int            // 0 (new) .. 5 (mastered); resets to 0 on .forgot
    var ease: Double           // SM-2 ease factor, floor 1.3, starts 2.5
    var intervalDays: Int      // days until nextDueAt
    var lastReviewedAt: Date
    var nextDueAt: Date
    var totalReviews: Int
    var lapses: Int            // count of .forgot answers (future "you keep missing this" hint)
}
```

Persisted to `~/Library/Application Support/com.emoha.desktopAhaan/data/reviews.json`
via the same coalesced-write pattern the rest of DataStore uses.

### Quality enum — `DataStore.swift:60-65`

```swift
enum ReviewQuality: Int, Codable, Hashable {
    case forgot = 0
    case hard   = 1
    case good   = 2
    case easy   = 3
}
```

Four levels (richer than the brief's three-button design — a kid hitting
"Hard" tells the scheduler something different from "Forgot").

### Algorithm — `DataStore.swift:70-144` (`SM2Scheduler`)

Pure function `schedule(_:quality:at:calendar:)` returning the updated
QuestionReview. Tunables (minEase, easeDeltaForgot, easyBoostMultiplier,
forgotRedoMinutes) lifted out of the switch as static constants for one-
line policy tweaks.

The algorithm is more nuanced than a vanilla SM-2:
- `.forgot` reschedules in 10 minutes (intra-session), not just "1 day"
- `.hard` keeps the bucket but stretches by 1.2× the prior interval (not the full ease)
- `.easy` applies a 1.3× boost on top of the normal ease multiplier
- Capped at a floor of 1 day on every branch (no negative / zero intervals)

### Persistence + write hooks — `DataStore.swift:202-677`

- `@Published var questionReviews: [String: QuestionReview] = [:]`
- `func recordReview(questionId:quality:at:)` — updates state, persists, credits streak
- `func dueQuestionIds(at:) -> [String]` — most-overdue first
- `func dueQuestionCount(at:) -> Int` — cheap accessor for sidebar badge
- `func toggleToughQuestion(_:)` — seeds an SRS row at "now" on first flag (chicken-and-egg fix)
- `creditReviewStreak(at:)` — yyyy-MM-dd day boundary, calendar-injected, sets `reviewStreakDays` / `reviewStreakBest` / `reviewStreakLastDate` AppStorage keys

### Streak engine — calendar-injection-safe

`DataStore.init(streakCalendar:)` accepts an injected `Calendar` for
deterministic test boundaries. Production gets a fresh
`Calendar(identifier: .gregorian)` in the system TZ. Tests pass UTC.
Closed the 2026-05-23 date-sensitive flake (commit `cb615c2`).

### Daily Drill UI — `Views/Practice/DailyPracticeViewSheet.swift`

`DailyPracticeView` (sidebar tool entry):
- Header card with current streak chip
- "N questions due now" review queue card with "Start Review" CTA
- Streak history card (current / best / last review date)
- Tough-flagged questions list with per-row remove
- Empty state messaging

`ReviewSessionSheet` (the actual drill):
- Per-card two-phase UI: prompt-only → "Show answer" → reveal + 4 quality buttons (⌘1 Forgot / ⌘2 Hard / ⌘3 Good / ⌘4 Easy)
- Skip card with "S" shortcut (doesn't call recordReview)
- Completion state on session end

### Write hook on Practice Questions — `QuestionDetailView.swift:378`

Already wired:
```swift
dataStore.recordReview(questionId: question.id, quality: quality)
```

### Sidebar tool — `ContentView.swift:394` + `AppState.swift:222`

`SidebarTool.dailyPractice` already routes the sidebar selection to
`DailyPracticeView`. ⌘⇧P keyboard shortcut.

---

## What's missing — the gap this session closes

1. **MasteryDashboard** — a per-chapter grid showing how the kid's review
   queue maps to mastery buckets. `DiscoverProgressDashboard` shows
   Discover scene completion (binary done/not-done per scene); that's a
   different signal from "how many Practice Questions are you confident on".
   The mastery dashboard needs:
   - Per-chapter aggregate of `QuestionReview` rows grouped by `bucket` (0..5)
   - Per-bucket count visualised as a horizontal segmented bar
   - Tap chapter cell → push chapter detail
   - Subject filter (Sanskrit / Science tabs)
2. **MasteryLevel derivation** — a small enum that buckets `bucket + ease + totalReviews`
   into four human-readable levels (Learning / Familiar / Confident / Mastered).
   No new Codable field needed — derive on read from existing state.
3. **Sidebar due-count badge** — the Daily Practice tool row in `ContentView.sidebar`
   doesn't show the count. The badge component already exists (`BadgePill`); we
   just need to add a per-tool badge slot.
4. **Help menu entry** — "About Daily Practice" sheet explaining SRS in kid-
   friendly terms.
5. **Welcome tour 4th panel** — Currently 3 panels (Subjects / Discover /
   Read Aloud). Add a fourth pointing at Daily Practice.
6. **What's-new entry** — Document the mastery dashboard as a 2026-05 feature.

---

## What this session is NOT doing

Per the hard rules and the read-before-writing audit:

- **No new Codable struct** parallel to `QuestionReview`. The brief proposed
  `ItemReview`; `QuestionReview` already serves this purpose. A parallel struct
  would fragment the storage layer.
- **No new SM-2 implementation.** `SM2Scheduler` exists and is tested. A
  competing `SM2Lite` would add maintenance surface for zero behaviour delta.
- **No new `DataStore+SRS.swift` partial.** The methods already live in
  `DataStore.swift` (the file is 740 LOC, file-size allowlist already
  documents the planned per-domain split for future sessions).
- **No write hook on Boss Quiz.** Boss-quiz items are hand-authored
  `Ch1QuizItem` structs (Scene9_BossQuiz.swift:35-100); they don't carry
  canonical `Question.id` values. Recording reviews against synthetic
  boss-quiz ids would populate the review queue with items the
  `SubjectRegistry.location(forQuestionId:)` resolver can't render. The
  existing design — review queue grows from canonical Practice Question
  answers + kid-flagged Tough — is the right shape.
- **No write hook on Discover scene quick-checks.** Same reason —
  per-scene quick-check items are inline anonymous structs, not
  Question rows. (If we ever migrate boss-quiz / scene-quiz content to
  the pack JSON with stable ids, the hook becomes a one-liner.)

---

## Algorithm — MasteryLevel mapping

Four buckets, derived from `QuestionReview` state at read time:

| Level     | Derivation                                                        |
|-----------|-------------------------------------------------------------------|
| Learning  | `totalReviews == 0` OR `bucket == 0` (last answer was Forgot)     |
| Familiar  | `bucket == 1..2`                                                  |
| Confident | `bucket == 3..4`                                                  |
| Mastered  | `bucket == 5` AND `intervalDays >= 21`                            |

No persistence — derived from existing state on every dashboard render.

---

## Surfaces to add — file plan

| File                                                              | Why                                                       |
|-------------------------------------------------------------------|-----------------------------------------------------------|
| `Subjects/ContentSchema/MasteryLevel.swift`                       | Tiny enum + derivation func + display tokens              |
| `Services/Persistence/DataStore+Mastery.swift`                    | `masterySummary(for:packId:) -> MasterySummary` aggregation |
| `Subjects/Tutor/Surfaces/MasteryDashboard.swift`                  | The new dashboard view                                    |
| `Subjects/Tutor/DailyPracticeAboutSheet.swift`                    | Help menu "About Daily Practice" sheet                    |
| (modify) `Subjects/Tutor/WelcomeTourSheet.swift`                  | Add 4th panel                                             |
| (modify) `Subjects/Tutor/WhatsNewSheet.swift`                     | Add the mastery feature entry                             |
| (modify) `ContentView.swift`                                      | Sidebar due-count badge on Daily Practice row             |
| (modify) `App/AppState.swift`                                     | New `SidebarTool.mastery` case                            |
| (modify) `desktopAhaanApp.swift`                                  | Help menu wiring                                          |
| (new tests) `desktopAhaanTests/MasteryLevelTests.swift`           | Derivation correctness                                    |
| (new tests) `desktopAhaanTests/MasterySummaryTests.swift`         | Aggregation                                               |
| (new test)  `desktopAhaanUITests/SRS_Smoke.swift`                 | Sidebar walks → Daily Practice → check empty / non-empty  |

---

## Backwards compatibility

Zero schema changes to `QuestionReview`. The new `MasteryLevel` is a
view-only derivation. `reviews.json` decodes unchanged. Existing users
keep their `questionReviews` map; the mastery dashboard renders today
for any user with non-empty state.

---

## Verification

Each new surface ships with build + unit-test + 9-lint clean. The
existing `Surface_AuditWalker` UI test gains an opt-in test method
that walks Sidebar → Daily Practice → start review → close, asserting
no crash.
