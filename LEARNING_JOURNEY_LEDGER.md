# LEARNING_JOURNEY_LEDGER.md — v6 "The Learning Journey"

> **Read this first every run.** It is the resumable status of the v6 mission:
> unify the four subjects (Science, Maths, Sanskrit, Social Science) into one
> guided beginner→expert journey and raise every subject to a consistent high
> bar. Update it (committed) at the end of each green milestone.

## Mission phases

0. **COMPILE-FIRST baseline** — prove the tree builds green before any change.
1. **PARITY AUDIT + DEPTH SWEEP** — `JOURNEY_PARITY_MATRIX.md`; raise weak
   chapters (deeper Discover, ≥1 gated bespoke interactive, fill enrichment).
2. **MASTERY MAP** — read-only `Services/MasteryEngine.swift` aggregating
   SRS + coverage concept→subject→overall; a Mastery Map window (pure SwiftUI).
3. **ADAPTIVE CROSS-SUBJECT JOURNEY** — `JourneyPlanner` extends Daily Plan +
   `AdaptiveDifficultyEngine`; a "Whole Journey" mode.
4. **MILESTONE ASSESSMENTS + PARENT REPORT CARD** — mixed quizzes sampled by
   mastery gaps; extend the Weekly-Progress PDF export to a report card.
5. **OLYMPIAD / EXPERT CHALLENGE LADDER** — tiered expert sets from `deepDive`,
   unlocked by mastery.
6. **INTEGRATE / TEST / DOC** — Help-menu wiring, a11y/WCAG/reduce-motion/
   legacy-GPU, full tests, `LEARNING_JOURNEY_CHECKPOINT.md`.

## Status

| Phase | State | Notes |
|-------|-------|-------|
| 0 | ✅ DONE | Baseline green: Release build + 700 XCTest pass, 0 fail; 13 core lints clean. |
| 1 | 🟡 IN PROGRESS | Audit landed. **P1-A…P1-E DONE** (Maths + Sanskrit `deepDive`: 45 each; Maths + Sanskrit `bossQuestions`: 90 each, 6/ch; **Sanskrit Discover: 15/15 NEP chapters with a gated शब्द–अर्थ word-match interactive each**; +31 tests total, 731 XCTest green). **All four subjects now carry `deepDive` + `bossQuestions`, and all four have Discover Mode.** Phase 3 ceiling + Phase 5 ladder open across the board; engagement parity reached. Backlog P1-F…P1-J pending. |
| 2 | ⬜ NOT STARTED | Note: `MasteryDashboard` + `DataStore+Mastery` + `MasteryLevel` already exist (per-chapter, single-subject). MasteryEngine must aggregate **cross-subject** concept→subject→overall on top of these. |
| 3 | ⬜ NOT STARTED | `AdaptiveDifficultyEngine` already exists — extend, don't replace. |
| 4 | ⬜ NOT STARTED | `WeeklyReportPDFExporter` already exists — extend to a report card. |
| 5 | ⬜ NOT STARTED | **Unblocked for all four subjects** — P1-A (Maths 45) + P1-B (Sanskrit 45) closed the `deepDive` gap; every subject now feeds the ladder. |
| 6 | ⬜ NOT STARTED | Final integration + checkpoint doc. |

## Environment note (important for whoever resumes)

The v6 prompt assumes execution **on the deploy iMac** (Xcode 13.2.1 / Swift
5.5 / Big Sur 11.7.11), where builds are authoritative. The cycles to date were
run on the **dev MacBook Pro (Xcode 26.5)**. Mitigation: the build pins
`MACOSX_DEPLOYMENT_TARGET=11.0` (so the compiler's availability checking still
rejects macOS-12+ APIs), and the static Big-Sur lints
(`check_macos12_apis.py`, `check_swift55_syntax.py`,
`check_sf_symbols_compat.py`, `check_color_literals.py`,
`check_view_mainactor.py`, `check_mainactor_closure_refs.py`,
`check_viewbuilder_limit.py`) are the authoritative Big-Sur guardrails and run
on every cycle. A final authoritative `--ui` build on the iMac is still
required before declaring the mission complete (Phase 6).

## Run log

### Cycle 1 (2026-06-01) — Phase 0 baseline + Phase 1 audit
- Confirmed Phase 0 green (Release build + 700 XCTest pass, 0 fail; 13 core
  lints clean; pbxproj already in sync).
- Created `JOURNEY_PARITY_MATRIX.md`: data-backed cross-subject audit. Key
  findings — **Sanskrit has 0/16 Discover coverage**; **Maths and Sanskrit have
  zero `deepDive`, `bossQuestions`, `crossChapterRefs`, `examConnections`**
  (which blocks Phase 5 and caps Phase 3 difficulty for those subjects).
  Science = gold standard; Social Science = strong.
- Defined the prioritised depth-sweep backlog (P1-A…P1-J).
- Created this ledger; gitignored the v6 launcher runtime artifacts.
- **NEXT:** begin P1-A (Maths `deepDive` fill) — highest leverage, unblocks
  Phase 5. PDF-faithful, additive, articles regenerated with `--write`, green
  here before commit.

### Cycle 2 (2026-06-01) — Phase 1 · P1-A complete (Maths `deepDive`)
- Added **45 `deepDive` StretchTopics** to the Maths pack (3 per chapter ×15),
  via the new re-runnable `scripts/inject_maths_deepdive.py`. Each is anchored
  by `parentConceptId` to a REAL concept in its own chapter, tagged
  class_8…class_11 (a genuine forward extension of the NEP Grade-7 idea — e.g.
  ch01 → standard form / significant figures / orders-of-magnitude; ch15 →
  transposition / simultaneous equations / quadratics), with a prerequisite and
  next-step hint and a ≥120-word body (Science floor is 100).
- Renders natively through the existing `DeepDiveSection` →
  `DeepDiveDetailSheet` in `ChapterDetailView` (no HTML article needed; the
  "regenerate articles" step is a Social-Science-only surface).
- Added `desktopAhaanTests/MathsDeepDiveTests.swift` (6 ratchet tests:
  ≥3/ch floor, total ≥45, parent-anchored in-chapter, globally-unique ids,
  ≥120-word bodies, prerequisite+nextStep present), mirroring the Science
  deep-dive contract.
- Green here: all content lints + `test_lints.py` pass; pbxproj regenerated
  (new test file wired); `ci-build-test.sh` → **BUILD + 706 XCTest, 0 failures**
  (was 700). roundtrip + `check_pack_schema` clean on all four packs.
- **Phase 5 (Olympiad ladder) is now open for Maths.** Additive only; zero
  regressions; zero STOP_AND_ASK.
- **NEXT:** P1-B — Sanskrit `deepDive` fill (15 NEP chapters `sch01`–`sch15`,
  ≥3/ch), the last subject blocking Phase 5. Same contract: in-chapter parent
  anchor, forward-grade extension faithful to the NEP Sanskrit text, ≥120-word
  bodies, mirror test, green before commit.

### Cycle 3 (2026-06-01) — Phase 1 · P1-B complete (Sanskrit `deepDive`)
- Added **45 `deepDive` StretchTopics** to the 15 NEP Sanskrit chapters
  (`sch01`–`sch15`, 3 each) via the new re-runnable
  `scripts/inject_sanskrit_deepdive.py`. The legacy `ch01` vocabulary deck is
  the documented carve-out and is skipped (and exempted in the test floor).
- Each is parent-anchored to a real in-chapter concept and is a genuine
  forward-grade extension (class_8…class_11) along three faithful tracks:
  **grammar** (samāsa, the कारक/विभक्ति system, the चतुर्थी after नमः, क्त्वा
  gerund, लङ् imperfect, तुमुन् infinitive + causative, the ten गण, the लकार
  system, परस्मैपद/आत्मनेपद, तसिल्/शस्/वति/मतुप् suffixes); **literature**
  (Īśopaniṣad, Bhagavad Gītā 3.14, Bhartṛhari's subhāṣitas, the Pañcatantra
  nīti tradition, अद्वैत वेदान्त + तत्त्वमसि); and **history/culture** (Vande
  Mataram & Ānandamaṭha, the Cellular Jail/कालापानी, Mewar & Panna Dhai,
  सूर्यनमस्कार/Yoga, आयुर्वेद, the वेदाङ्ग शिक्षा). All Devanagari/IAST
  micro-detail checked; bodies ≥120 words with prerequisite + next-step.
- Renders natively through the existing `DeepDiveSection` (same as Maths;
  no HTML article needed).
- Added `desktopAhaanTests/SanskritDeepDiveTests.swift` (6 ratchet tests; the
  per-chapter floor exempts the legacy `ch01` deck).
- Green here: content lints + `test_lints.py` pass; roundtrip + schema clean
  (Devanagari survives byte-for-byte with `ensure_ascii=False`); pbxproj
  regenerated; `ci-build-test.sh` → **BUILD + 712 XCTest, 0 failures** (was 706).
- **Phase 5 (Olympiad ladder) is now open for ALL FOUR subjects.** Additive
  only; zero regressions; zero STOP_AND_ASK.
- **NEXT:** P1-C — Maths `bossQuestions` fill (≥6/ch) to raise the Phase 3
  adaptive difficulty ceiling, then P1-D (Sanskrit `bossQuestions`). Same
  loop: author → lint → pbxproj → ci-build-test green → commit/push → ledger.

### Cycle 4 (2026-06-01) — Phase 1 · P1-C complete (Maths `bossQuestions`)
- Confirmed Phase 0 still green here (Release build + 712 XCTest, 0 fail) before
  any change.
- Added **90 chapter-level `bossQuestions`** to the Maths pack (6 per chapter ×
  15) via the new re-runnable `scripts/inject_maths_boss.py`. Each is:
  * a 4-option MCQ at **boss-tier difficulty 3–5** (the high pool the Phase-3
    adaptive engine escalates into, and a Phase-5 ladder feeder),
  * given the canonical collision-free id `bossquiz_mchNN_qII` (namespace token
    `mch` keeps Maths review state distinct from Science's `bossquiz_chNN_qII`,
    so SM-2 history never orphans across packs — enforced by
    `check_quiz_id_format.py` + the SubjectRegistry global question index),
  * carries worked `solutionSteps`, ≥1 `commonMistakes` note (each naming a
    specific distractor trap), and ≥1 re-drill `variation`,
  * NCERT Ganita Prakash Grade-7 faithful, with every numerical answer
    hand-verified; `pageRefs` inside the chapter's real page range,
  * tagged `source: "boss_quiz"`, `needsHumanReview: false`.
- Added `desktopAhaanTests/MathsBossQuestionsTests.swift` (7 ratchet tests:
  ≥6/ch floor, total ≥90, canonical+unique ids, difficulty 3–5, mcq answer ∈
  options, steps+mistakes+variation present, `.bossQuiz` source), mirroring the
  Science `BossQuizMigrationRatchetTests` contract scoped to Maths.
- Renders + reviews natively through the existing boss-quiz surface
  (`Chapter.bossQuestionsList` → SubjectRegistry index → Daily Practice /
  Recently-Missed). No new view code; additive data + tests only.
- Green here: all content lints + `test_lints.py` pass; roundtrip +
  `check_pack_schema` clean on all four packs; pbxproj regenerated (new test
  file auto-wired); `ci-build-test.sh` → **BUILD + 719 XCTest, 0 failures**
  (was 712, +7). Zero regressions; zero STOP_AND_ASK.
- **Phase 3 adaptive ceiling is now raised for Maths.** Additive only.
- **NEXT:** P1-D — Sanskrit `bossQuestions` fill (15 NEP chapters `sch01`–`sch15`,
  ≥6/ch, `bossquiz_schNN_qII`), the last subject capping the Phase-3 ceiling.
  Same loop: author → lint → pbxproj → ci-build-test green → commit/push →
  ledger.

### Cycle 5 (2026-06-01) — Phase 1 · P1-D complete (Sanskrit `bossQuestions`)
- Confirmed the tree was green here after P1-C (719 XCTest, 0 fail) before any
  change.
- Added **90 chapter-level `bossQuestions`** to the 15 NEP Sanskrit chapters
  (`sch01`–`sch15`, 6 each) via the new re-runnable
  `scripts/inject_sanskrit_boss.py`. The legacy `ch01` vocabulary deck is the
  documented carve-out and is **skipped** — a `bossquiz_ch01_*` id would collide
  with Science's `ch01` boss ids and orphan SM-2 review state across packs.
- Each boss question is:
  * a 4-option MCQ at **boss-tier difficulty 3–5**, id `bossquiz_schNN_qII`
    (the `sch` namespace keeps Sanskrit review state distinct from `ch`/`mch`/
    `ssch`),
  * **textbook-faithful** — grounded in each concept's own `explanations`
    (Devanagari/IAST checked against the NEP Sanskrit Grade-7 text), spanning the
    three authentic tracks: literature/values (वन्दे मातरम्, सुभाषितानि,
    ईशावास्यम्, अन्नाद् भवन्ति भूतानि, दशमः कः?), grammar (the चतुर्थी after नमः,
    the पञ्चमी ablative, the optative जानीयात्, the क्त्वा gerund, the -तुम्
    infinitive, the past active participle सोढवान्, मात्रा vowel quantities, the
    सप्तविभक्ति/declension system, the लकार/पद/पुरुष verb system) and
    history/culture (the Cellular Jail/कालापानी & Savarkar, Panna Dhai),
  * carries worked `solutionSteps`, ≥1 `commonMistakes` note (each naming a
    specific distractor trap, e.g. प्रथमपुरुष = English third person), and ≥1
    re-drill `variation`; `pageRefs` inside the chapter's real page range;
    `source: "boss_quiz"`.
- Added `desktopAhaanTests/SanskritBossQuestionsTests.swift` (8 ratchet tests:
  ≥6/ch NEP floor, **legacy ch01 carries zero boss Qs**, total ≥90, canonical+
  unique ids, difficulty 3–5, mcq answer ∈ options, steps+mistakes+variation
  present, `.bossQuiz` source).
- Green here: all content lints + `test_lints.py` pass; roundtrip +
  `check_pack_schema` clean on all four packs (Devanagari survives byte-for-byte
  with `ensure_ascii=False`); pbxproj regenerated (new test file auto-wired);
  `ci-build-test.sh` → **BUILD + 727 XCTest, 0 failures** (was 719, +8). Zero
  regressions; zero STOP_AND_ASK.
- **Phase 3 adaptive ceiling is now raised for ALL FOUR subjects**, and every
  subject feeds the Phase-5 Olympiad ladder via both `deepDive` and
  `bossQuestions`. Additive only.
- **NEXT:** P1-E — build a real Sanskrit Discover experience (≥1 gated bespoke
  interactive per chapter; Sanskrit is 0/16 today), the largest remaining
  engagement gap. Same loop, but this is code-heavy (new SwiftUI views under the
  Big-Sur/legacy-GPU invariants), so expect multiple cycles.

### Cycle 6 (2026-06-01) — Phase 1 · P1-E complete (Sanskrit Discover)
- Confirmed Phase 0 still green here (Release build + 727 XCTest, 0 fail) before
  any change.
- Built a **complete Sanskrit Discover experience** for all **15 NEP chapters**
  (`sch01`–`sch15`). Mirrors the Social Science data-driven model (one generic
  view reads its 9 scenes live from the pack) but adds a **bespoke GATED
  interactive** the other subjects don't have:
  * **`SanskritWordMatchScene.swift`** — a Devanagari शब्द–अर्थ (word–meaning)
    tap-to-match game built from the chapter `glossary` (up to 5 pairs, spread
    across the glossary). Tap a Sanskrit term, then its English meaning; correct
    pairs lock green, wrong taps flash red. The scene completes — and chapter
    progress is credited — ONLY once every pair is matched, so it cannot be
    skipped with a single tap (the "gated" requirement). Tap-to-match, not drag
    (Big-Sur SwiftUI drag is unreliable).
  * **`SanskritDiscoverComponents.swift`** — info / quick-check / boss-quiz
    scenes, saffron-accented, reading concepts + `bossquiz_sch*` MCQs from the
    pack. Quick-checks and boss questions record SRS via the canonical
    `recordReview(questionId:quality:packId:)` path; Sanskrit boss ids are REAL
    pack rows resolved through the SubjectRegistry index (not synthetic
    ephemeral ids — the `bossquiz_sch` vs `bossquiz_ch` prefix keeps Sanskrit
    review state distinct from Science).
  * **`DiscoverChapterSanskritView.swift`** — the 9-scene dispatcher (Big
    Picture · 2 concepts · Word Match · 1 concept · 3 quick-checks · Boss Quiz).
    Scene cursor uses `discoverScene(400 + number)` (no collision with Science
    1–19 / Maths 101–115 / SS 300+); progress keys on the globally-unique
    `schNN` id.
- Wired `DiscoverMode` (`sanskritSupportedChapterIds` = the 15 NEP ids; the
  legacy `ch01` vocabulary deck is the documented carve-out and is excluded) and
  added 15 saffron/maroon/gold accents to `ChapterTheme`. Entry points
  (`ChapterDetailView`, `ChapterListView`, `TutorNavigation`) were already
  pack-agnostic via `hasExperience` / `view(for:)`, so no further wiring needed.
- Added `desktopAhaanTests/SanskritDiscoverModeRoutingTests.swift` (4 ratchet
  tests: NEP-has-Discover + legacy-ch01-excluded, exact subject gate with
  cross-subject leak guards, per-chapter scene-shape fill incl. ≥3 word-match
  glossary pairs, and the canonical-not-ephemeral boss-id boundary).
- Green here: all 8 Big-Sur lints + `test_lints.py` pass; pbxproj regenerated
  (3 new source files + 1 test file auto-wired); `ci-build-test.sh` → **BUILD +
  731 XCTest, 0 failures** (was 727, +4). Additive only; zero regressions; zero
  STOP_AND_ASK.
- **All four subjects now have Discover Mode** — engagement parity reached.
- **NEXT:** P1-F — add `crossChapterRefs` (≥4/ch) to Maths and Sanskrit (the
  last bolded enrichment gap that feeds Phase 3 cross-subject weaving). Content
  milestone, same loop: author → lint → pbxproj → ci-build-test green →
  commit/push → ledger.
