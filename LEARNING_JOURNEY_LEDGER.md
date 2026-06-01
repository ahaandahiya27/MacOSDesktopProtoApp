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
| 1 | ✅ DONE | **P1-A…P1-J complete.** Cross-subject **enrichment-parity sweep DONE**: every subject carries `deepDive` + `bossQuestions` + `crossChapterRefs` + `examConnections` (≥3/ch) + `whatIfs` (≥3/ch) + Discover Mode — all four now at 🥈 STRONG or above. Highlights — Maths + Sanskrit `deepDive` 45 each, `bossQuestions` 90 each; `crossChapterRefs` 120; Sanskrit Discover 15/15 NEP w/ gated शब्द–अर्थ match; Maths exam+whatIf 45 each (P1-G); Sanskrit exam 45 (P1-H); Social Science exam+whatIf 2→3/ch + `_whatif` articles regenerated (P1-I); `JOURNEY_PARITY_MATRIX.md` refreshed (P1-J). Remaining items are deferred optional polish (timelines, quickChecks, more `scientists`, bespoke SS Discover) — blocks nothing. Phase 3 ceiling + weaving + Phase 5 ladder open across the board. |
| 2 | ✅ DONE | **MasteryEngine** (cycle 12, read-only cross-subject aggregation, +10 unit tests) **+ Mastery Map window** (cycle 13): pure-SwiftUI `MasteryMapView` + `MasteryMapWindowPresenter`, wired into Help → Mastery Map (⌘⇧M). Per-subject Coverage + Mastery meters, overall card, "focus next" nudge, legend, empty state; static bars (legacy-GPU-safe), full a11y, no SF Symbols/banned colours. +3 @MainActor integration tests. Build+test green. |
| 3 | 🟡 IN PROGRESS | **M1 + M2 DONE.** M1 (cycle 14): read-only pure `Services/JourneyPlanner.swift` (weak-first subject focus order from a `MasteryEngine` snapshot + a weak-first review round-robin) + `DataStore+JourneyPlan.swift` `buildWholeJourneyPlan` (cross-subject, gap-weighted; Maths Discover excluded for the `chNN` collision) + `JourneyMode` wired into `currentDailyPlan` (mode switch rebuilds). M2 (cycle 15): a Today ↔ Whole Journey **segmented picker in `DailyPlanView`** (bound to `JourneyPlannerStorage`, persists + rebuilds on change; subtitle line; Big-Sur-safe `SegmentedPickerStyle`+`onChange`) + render test. +13 tests total. **NEXT:** M3 — assess whether to fold the weakest-subject gap into `AdaptiveDifficultyEngine` surfacing, else close Phase 3. |
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

### Cycle 7 (2026-06-01) — Phase 1 · P1-F complete (`crossChapterRefs`)
- Confirmed the tree was green here after P1-E (731 XCTest, 0 fail) before any
  change.
- Added **120 `crossChapterRefs`** — exactly **4 outbound per chapter** across
  Maths (`ch01`–`ch15`, 60) and the 15 NEP Sanskrit chapters (`sch01`–`sch15`,
  60) — via the new re-runnable `scripts/inject_cross_chapter_refs.py`. The
  legacy Sanskrit `ch01` vocabulary deck is the documented carve-out and carries
  none. Each ref:
  * points to a **real in-pack chapter** (never itself), with the canonical id
    `{chapterId}_cx{NN}`;
  * carries a **hand-authored, curricularly-accurate** 1–2 sentence pointer
    explaining the genuine connection (Maths: e.g. ch03 decimals → ch12 decimal
    operations, ch04 letter-numbers → ch15 equations, ch05 lines → ch07
    triangle angle-sum; Sanskrit: e.g. the grammar chain sch13 phonics → sch14
    declension → sch15 conjugation, the patriotism arc sch01 ↔ sch11 ↔ sch12,
    the values arc sch05 ↔ sch07 ↔ sch09);
  * is anchored by ≥1 real **source-chapter `relatedConceptId`** (the injector
    hard-fails if a target chapter or a concept id doesn't resolve in-pack).
- Added `desktopAhaanTests/CrossChapterRefsTests.swift` (2 ratchet tests:
  Maths ≥4/ch; Sanskrit ≥4/ch on the NEP chapters with the legacy ch01 deck
  carrying zero — plus canonical-unique ids, real in-pack targets, no
  self-reference, non-empty topic, ≥30-char pointers, and in-pack
  `relatedConceptIds`).
- Green here: roundtrip byte-for-byte clean on all four packs (Devanagari
  intact via `ensure_ascii=False`); `check_pack_schema` + `check_color_literals`
  + `test_lints.py` pass; pbxproj regenerated (new test file auto-wired);
  `ci-build-test.sh` → **BUILD + 733 XCTest, 0 failures** (was 731, +2).
  Additive only; zero regressions; zero STOP_AND_ASK.
- **Phase 3 cross-subject weaving can now follow real curricular threads in
  every subject.** All four bolded enrichment gaps from the Phase-1 audit
  (`deepDive`, `bossQuestions`, `crossChapterRefs` + Sanskrit Discover) are
  closed.
- **NEXT:** P1-G — add `examConnections` + `whatIfs` to Maths (enrichment
  parity with Science/Social Science; both fields are 0/15 for Maths today).
  Same loop.

### Cycle 8 (2026-06-01) — Phase 1 · P1-G complete (Maths `examConnections` + `whatIfs`)
- Confirmed Phase 0 still green here (Release build + TEST SUCCEEDED) before any
  change.
- Added **45 `examConnections` + 45 `whatIfs`** (3 + 3 per chapter × 15) to the
  Maths pack via the new re-runnable `scripts/inject_maths_enrichment.py` — the
  last two enrichment surfaces where Science still outranked Maths.
- Ids `mchNN_xcII` / `mchNN_wiII` (the `mch` namespace keeps them distinct from
  Science's `chNN_xc` / `chNN_wi`, which share the `chNN` chapter ids). Each
  item anchored by ≥1 real in-chapter `relatedConceptId`; injector hard-fails on
  any unresolved anchor, a body outside 50–130 words, or a whatIf answer < 30
  chars.
- examConnections are NEP-faithful forward pointers (class8…class12 + jee);
  whatIfs are counterfactual prompts targeting each chapter's real
  misconceptions (fraction-shrinks, the 180° angle budget, the (−)(−)=(+)
  distributive-law proof, the truncated-axis graph lie, …).
- Added `desktopAhaanTests/MathsEnrichmentTests.swift` (3 ratchet tests:
  ≥3/ch + ≥45 total per surface, canonical-unique ids, ≥40-word exam bodies,
  non-blank titles + targetExam, ≥30-char whatIf answers, in-pack
  `relatedConceptIds`, and the `mch`-namespace boundary vs Science). Raised the
  Maths `whatIfs` floor in `CrossSubjectEnrichmentParityTests` 0 → 3.
- Green here: roundtrip byte-for-byte on all four packs; `check_pack_schema` +
  all 8 Big-Sur static lints + `test_lints.py` pass; pbxproj regenerated (new
  test file auto-wired); `ci-build-test.sh` → **BUILD + TEST SUCCEEDED, 0
  failures** (+3 XCTest). Additive only; zero regressions; zero STOP_AND_ASK.
- **Maths now reaches full enrichment-surface parity with Science.**
- **NEXT:** P1-H — audit Sanskrit `examConnections` (NEP chapters already carry
  `whatIfs` ≥3; check the exam-connection surface), then the remaining P1
  backlog. Same loop: author → lint → pbxproj → ci-build-test green →
  commit/push → ledger.

### Cycle 9 (2026-06-01) — Phase 1 · P1-H complete (Sanskrit `examConnections`)
- Confirmed Phase 0 still green here (Release build + TEST SUCCEEDED) before any
  change.
- Added **45 `examConnections`** (3 per NEP chapter × 15) to the Sanskrit pack
  via the new re-runnable `scripts/inject_sanskrit_examconn.py` — the last dark
  enrichment surface for the NEP chapters. The legacy `ch01` vocab deck is the
  documented carve-out (skipped; a `ch01_xc*` id would collide with Science).
- Ids `schNN_xcII` (distinct from Science `chNN_xc`). Each is a 60–120-word
  NEP-faithful forward pointer (class8…class12) along the three authentic
  tracks — grammar (समास, सप्तविभक्ति/kāraka, the लकार + गण verb system, क्तवतु/
  तुमुन्, ordinals + किम्), literature/values (subhāṣita + Bhartṛhari + chandas +
  alaṅkāra, the Pañcatantra, karma-yoga + the Gītā yajña-cycle, the Īśa
  Upaniṣad, speech-ethics), history/culture (yoga/āyurveda, Cellular Jail/
  Savarkar, Panna Dhai, Śikṣā). Each anchored by ≥1 real in-chapter
  `relatedConceptId`; injector hard-fails on any unresolved anchor.
- Added `desktopAhaanTests/SanskritExamConnectionsTests.swift` (1 comprehensive
  ratchet: ≥3/ch + ≥45 total on NEP, legacy ch01 zero, canonical-unique ids,
  sch-namespace boundary, ≥40-word bodies, non-blank title + targetExam, in-pack
  `relatedConceptIds`).
- Green here: roundtrip byte-for-byte on all four packs (Devanagari intact);
  `check_pack_schema` + `check_orphan_refs` + `check_cross_pack_ids` + all
  Big-Sur lints + `test_lints.py` pass; pbxproj regenerated (new test
  auto-wired); `ci-build-test.sh` → **BUILD + TEST SUCCEEDED, 0 failures** (+1
  XCTest). Additive only; zero regressions; zero STOP_AND_ASK.
- **Sanskrit NEP chapters now carry the full enrichment surface set.**
- **NEXT:** P1-I — top up Social Science `examConnections` + `whatIfs` from 2 → 3
  per chapter (one each × 20 chapters) so all four subjects clear the Science
  3/ch floor. Same loop.

### Cycle 10 (2026-06-01) — Phase 1 · P1-I complete (Social Science exam/whatIf top-up)
- Confirmed Phase 0 still green here before any change.
- Topped up every Social Science chapter (ssch01–ssch20) from 2 → 3
  `examConnections` and 2 → 3 `whatIfs` — adding `sschNN_xc03` + `sschNN_wi03`
  (40 new items) via the new re-runnable, idempotent
  `scripts/inject_socialscience_enrichment_topup.py` (keeps xc01/xc02 + wi01/wi02,
  dedupes the new id on re-run).
- Content spans all three SS strands (geography / history / civics / economics),
  each anchored by ≥1 real in-chapter `relatedConceptId`; injector hard-fails on
  any unresolved anchor or out-of-bounds length.
- Regenerated the 20 `ssch*_whatif` HTML articles via
  `scripts/generate_socialscience_articles.py --write` (each now 3 scenarios;
  `estimatedMinutes` recalculated 6→9 in `ArticleIndex+SocialScienceEntries.swift`).
  examConnections render natively via `ExamConnectionCalloutView` (no article).
- Added `desktopAhaanTests/SocialScienceEnrichmentParityTests.swift` (3 ratchets:
  ≥3/ch + ≥60 total per surface, canonical-unique ids, in-pack
  `relatedConceptIds`, non-blank fields, and a JSON↔article sync check that the
  regenerated `_whatif` articles enumerate every pack whatIf).
- Green here: roundtrip byte-for-byte on all four packs; `check_pack_schema` +
  `check_orphan_refs` + `check_article_entry_bundled` (907 rows) + all Big-Sur
  lints + `test_lints.py` pass; pbxproj regenerated; `ci-build-test.sh` → **BUILD
  + TEST SUCCEEDED, 0 failures** (+3 XCTest). Additive only; zero regressions;
  zero STOP_AND_ASK.
- **All four subjects now clear the 3/ch examConnections + whatIfs bar — the
  cross-subject enrichment-parity sweep is COMPLETE.**
- **NEXT:** P1-J — refresh `JOURNEY_PARITY_MATRIX.md` to mark the sweep complete,
  then begin Phase 2 (read-only `Services/MasteryEngine.swift` + a pure-SwiftUI
  Mastery Map window).

### Cycle 11 (2026-06-01) — Phase 1 · P1-J complete + Phase 1 CLOSED
- Refreshed `JOURNEY_PARITY_MATRIX.md` to mark the enrichment-parity sweep
  complete: headline tiers (Maths + Sanskrit 🟡 MEDIUM → 🥈 STRONG), the
  enrichment-coverage table (whatIfs/examConnections now ✅ across all subjects),
  reconciled the §4 backlog with the cycles that actually landed (P1-G…P1-J),
  and re-triaged the leftover surfaces (timelines, quickCheckQuestions, extra
  `scientists`, bespoke SS Discover) as a deferred OPTIONAL-polish backlog that
  darks no chapter surface and gates no later phase.
- Docs-only change (no pack/code/test touched); roundtrip clean; pre-push
  `ci-build-test` green.
- **Phase 1 is CLOSED.** Every subject is at the consistent high bar on all
  bar-setting enrichment surfaces + Discover; Phases 3 (adaptive ceiling +
  weaving) and 5 (Olympiad ladder) are unblocked across the board.
- **NEXT:** Phase 2 — author the read-only `Services/MasteryEngine.swift`
  aggregating SRS + coverage into concept→subject→overall mastery (built ON TOP
  of the existing `MasteryDashboard` / `DataStore+Mastery` / `MasteryLevel`,
  never mutating SRS), and a pure-SwiftUI Mastery Map window under the Big-Sur /
  legacy-GPU invariants. Read those existing files first; extend, don't replace.

### Cycle 12 (2026-06-01) — Phase 2 (start) · MasteryEngine
- Added read-only `desktopAhaan/Services/MasteryEngine.swift` — rolls the
  existing per-subject `MasterySummary` up into cross-subject concept/topic →
  chapter → subject → overall. READ-ONLY over SRS (no mutation/scheduling/disk
  write); built ON TOP of `DataStore.masterySummary` + `MasteryLevel` (no
  re-derived bucket math, so Map and dashboard can't drift).
- Two axes surfaced side by side: **coverageFraction** (reviewed / all
  reviewable = topic+boss+quickCheck) and **masteryFraction** (reviewed-
  weighted level). Per-subject `dueCount` computed in one pass over
  `questionReviews` (nextDueAt ≤ now, attributed to owning pack), distinct from
  the global `summary.dueCount`. `weakestStartedSubject` (lowest mastery,
  tie-break coverage→order) drives the Map's focus nudge + feeds Phase-3.
- Pure cores (`level(forFraction:)`, the two snapshot structs) are value-math;
  only `snapshot(registry:dataStore:now:)` touches the @MainActor singletons.
- Added `desktopAhaanTests/MasteryEngineTests.swift` (10 tests: band
  boundaries + clamp; coverage = reviewed/reviewable w/ clamp + zero-denom
  safety; reviewed-weighted mastery; overall weighted rollup; empty/unstarted
  = 0 not NaN; weakest-subject selection + tie-break).
- Green here: all 8 Big-Sur lints + `test_lints.py` pass; pbxproj regenerated
  (service + test auto-wired); `ci-build-test.sh` → **BUILD + TEST SUCCEEDED, 0
  failures** (+10 XCTest). Additive only; zero regressions; zero STOP_AND_ASK.
- **NEXT:** Phase 2 milestone 2 — the pure-SwiftUI **Mastery Map window**
  rendering this snapshot (per-subject coverage + mastery bars, overall ring,
  focus-next nudge), under Big-Sur / legacy-GPU invariants; then Help-menu
  wiring + a routing test.

### Cycle 13 (2026-06-01) — Phase 2 COMPLETE · Mastery Map window
- Built the pure-SwiftUI Mastery Map on the cycle-12 MasteryEngine and wired it
  into the menu — Phase 2 done.
- `desktopAhaan/Views/Progress/MasteryMapView.swift`: Overall card (coverage +
  mastery meters, totals, level chip, due), "Focus next" nudge → weakest
  started subject, per-subject rows (emoji + title + level chip + Coverage
  meter "N of M" + Mastery meter "NN%" + due; unstarted shows a "not started"
  state), level legend, welcoming empty state. Private `MeterBar` = static
  tinted capsule (no animation/particles → legacy-GPU-free; Reduce-Motion-safe).
- `desktopAhaan/Views/Progress/MasteryMapWindow.swift`:
  `MasteryMapWindowPresenter`, NSHostingController AppKit window singleton
  (proven WeeklyProgress/DailyPlan pattern). Help → Mastery Map (⌘⇧M) added to
  the dashboards Group in `desktopAhaanApp.swift`.
- Big-Sur invariants: @MainActor view; colours via DesignTokens + MasteryLevel
  .tint + compatIndigo (no raw mint/indigo/teal/cyan/brown); SF-Symbol-free
  (emoji icons); ViewBuilder ≤10 (Group buckets); no force-unwrap; every card
  has a combined a11y label, meters accessibility-hidden.
- Added `desktopAhaanTests/MasteryMapSnapshotTests.swift` (3 @MainActor
  integration tests over the LIVE registry: one row/pack in order, positive
  coverage denominators, reviewed ≤ reviewable, coverage/mastery ∈ [0,1] never
  NaN, overall = Σ subjects, weakest is started). State-independent + non-
  mutating → deterministic, proving the read-only contract end to end.
- Green here: all 8 Big-Sur lints + `test_lints.py` pass; pbxproj regenerated
  (3 files auto-wired); `ci-build-test.sh` → **BUILD + TEST SUCCEEDED, 0
  failures** (+3 XCTest). Additive (sole existing-file edit is one menu button);
  zero regressions; zero STOP_AND_ASK.
- **Phase 2 (Mastery Map) is COMPLETE.**
- **NEXT:** Phase 3 — extend the existing JourneyPlanner / Daily Plan +
  `AdaptiveDifficultyEngine` into a cross-subject "Whole Journey" mode, sampling
  by the mastery gaps this engine now exposes (weakestStartedSubject +
  per-subject coverage/mastery). Read those existing services first; extend,
  don't replace.

### Cycle 14 (2026-06-02) — Phase 3 (start) · JourneyPlanner engine + Whole Journey builder
- Confirmed Phase 0 still green here before any change (Release build + **751
  XCTest, 0 fail**; pbxproj in sync; all Big-Sur static lints clean).
- Added the **cross-subject, mastery-gap-weighted Whole Journey plan**,
  EXTENDING (never replacing) the Daily Plan — it reuses `DailyPlanItem`/
  `DailyPlan`, the persistence + reconcile + auto-Done + streak plumbing, and
  the `AdaptiveDifficultyEngine` due-ordering; the new bit is that it SAMPLES BY
  MASTERY GAPS so the weakest *started* subject is served first instead of
  front-loading whichever pack the registry lists first.
- `desktopAhaan/Services/JourneyPlanner.swift` — READ-ONLY pure core (mirrors
  `MasteryEngine`'s contract): `JourneyMode` (`today` | `wholeJourney`) +
  `JourneyPlannerStorage`; `subjectFocusOrder` (started subjects weakest-first
  by mastery, ties → coverage → registry order, *then* unstarted in registry
  order — generalises `weakestStartedSubject`'s comparator); `focusRank`; and
  `roundRobinReviews` (weak-first round-robin over per-subject due queues, so a
  weak subject's due review is never starved by a strong subject monopolising
  the slots, while each subject's internal adaptive order is preserved). FS-free,
  no DataStore — fully unit-testable.
- `desktopAhaan/Services/Persistence/DataStore+JourneyPlan.swift` — the
  `@MainActor` builder `buildWholeJourneyPlan`: builds a `MasteryEngine.snapshot`,
  takes ≤3 due reviews spread weak-first across subjects, 1 unmastered concept
  from the weakest started subject (falling through the gap order), and 1 open
  Discover chapter from the gap order over **collision-safe packs only**
  (Science / Sanskrit / Social Science). **Maths Discover is deliberately
  excluded** — `DiscoverProgress` carries no `packId` and Maths shares the bare
  `chNN` chapter-id space with Science, so a Maths Discover row can't be told
  apart from a Science one (would make auto-Done ambiguous); Maths engagement
  routes through its reviews + concept slots. READ-ONLY over SRS (no mutation /
  scheduling / write).
- Wired into `currentDailyPlan` via a new `buildPlan(mode:…)` dispatcher: a
  stored plan is reused only if it still covers today **and** was built in the
  currently-selected `JourneyMode`, so toggling Today ↔ Whole Journey rebuilds
  the day's plan (real SRS/concept/Discover progress untouched → reconcile
  re-ticks anything already done). Added a backward-compatible `planMode:
  JourneyMode?` to `DailyPlan` (old `dailyplan.json` decodes as `nil` → `.today`).
- Tests (+12): `JourneyPlannerTests.swift` (9 pure — focus order weakest-first +
  tie-breaks + unstarted-in-registry-order + empty; focusRank; round-robin
  spread / per-subject-order / max / empty / out-of-order packs; `JourneyMode`
  storage round-trip + default + raw-value persistence contract) and
  `JourneyPlanIntegrationTests.swift` (3 @MainActor over the live registry on an
  isolated temp store: cross-subject review spread + ≤5-item shape + unique ids +
  collision-safe Discover + read-only-over-SRS; and the mode-switch rebuild +
  persistence).
- Green here: all 8 Big-Sur lints + `test_lints.py` pass; pbxproj regenerated (2
  source + 2 test files auto-wired); `ci-build-test.sh` → **BUILD + 763 XCTest,
  0 failures** (was 751, +12). Additive (sole existing-file edits: the
  `currentDailyPlan` mode branch + `buildDailyPlan` mode tag + the `DailyPlan`
  optional field); zero regressions; zero STOP_AND_ASK.
- **NEXT:** Phase 3 Milestone 2 — surface the mode in `DailyPlanView` (a
  "Today / Whole Journey" segmented picker bound to `JourneyPlannerStorage`,
  reloading the plan on change) under the Big-Sur invariants, + a view/routing
  test. Then Milestone 3 — fold the weakest-subject gap into the
  AdaptiveDifficultyEngine surfacing if warranted.

### Cycle 15 (2026-06-02) — Phase 3 · M2 · Whole Journey mode picker (UI)
- Confirmed M1 still green here (763 XCTest, 0 fail) before any change.
- Surfaced the Phase-3 engine in the UI: `DailyPlanView` now shows a **Today ↔
  Whole Journey segmented picker** under the header, seeded from
  `JourneyPlannerStorage.currentMode()`. Changing it persists the choice and
  `reload()`s — and because `currentDailyPlan` rebuilds when the stored plan's
  mode no longer matches (M1), the plan instantly re-renders through the new
  lens. A caption line shows the selected mode's one-line description.
- Big-Sur-safe: `@MainActor` view; `Picker` + `.pickerStyle(.segmented)` +
  `onChange(of:)` (all already used elsewhere in the app, lint-clean); picker
  carries an a11y label, subtitle uses DesignTokens colours. VStack stays ≤10
  children (header · picker · items · Divider · reminder = 5).
- Added a `DailyPlanViewTests` render smoke test that persists Whole Journey
  (save/restore), seeds due reviews, and lays out the view through
  `NSHostingView` — proving the new body path doesn't crash.
- Green here: all 8 Big-Sur lints + `test_lints.py` pass; pbxproj unchanged (no
  new files); `ci-build-test.sh` → **BUILD + 764 XCTest, 0 failures** (was 763,
  +1). Additive (sole edits: 1 @State, 1 VStack child, 1 computed picker prop);
  zero regressions; zero STOP_AND_ASK.
- **The Whole Journey mode is now end-to-end reachable** — engine + UI.
- **NEXT:** Phase 3 M3 — decide whether the weakest-subject gap warrants
  additional `AdaptiveDifficultyEngine` surfacing (e.g. a gap-aware nudge), or
  declare Phase 3 complete and move to Phase 4 (Milestone Assessments + Parent
  Report Card, extending `WeeklyReportPDFExporter`).

### Cycle 16 (2026-06-02) — Phase 3 CLOSED · Phase 4 M1 · Milestone Assessment sampler
- Confirmed Phase 0 still green here before any change (Release build + **764
  XCTest, 0 fail**; pbxproj in sync; all Big-Sur static lints clean; the lone
  red script — `check_callout_reading_level.py` — is the documented non-gating
  Discover-callout advisory, flags only untouched scene files).
- **Phase 3 M3 DECISION — Phase 3 declared COMPLETE.** The cross-subject journey
  is already adaptive on two *orthogonal* axes: SUBJECT-level mastery-gap
  ordering (`JourneyPlanner.subjectFocusOrder` + `roundRobinReviews`) and
  WITHIN-subject band-aware difficulty ordering (`AdaptiveDifficultyEngine`,
  reused via `prioritizedDueQuestionIds`). Folding the subject-mastery aggregate
  (a coverage/SRS rollup) into the per-chapter rolling-5-window difficulty band
  would conflate two distinct signals and muddy the engine's read-only contract
  for no pedagogical gain — and the Mastery Map already surfaces the weakest-
  subject "focus next" nudge. The brief's Phase-3 promise ("JourneyPlanner
  extends Daily Plan + AdaptiveDifficultyEngine; Whole Journey mode") is met
  end-to-end (engine cycle 14 + UI cycle 15). No code change for M3 by design.
- **Phase 4 Milestone 1 — the read-only Milestone Assessment sampler.** A short,
  mixed, cross-subject quiz **sampled by mastery gaps**, mirroring the
  MasteryEngine/JourneyPlanner read-only-pure-core + @MainActor-builder split:
  - `desktopAhaan/Models/MilestoneAssessment.swift` — value types
    `AssessmentQuestion` (packId + subject/chapter title + resolved `Question`)
    and `MilestoneAssessment` (ordered questions, `generatedAt`, `subjectCounts`,
    `subjectTitles`). FS-free, no clock read.
  - `desktopAhaan/Services/MilestoneAssessmentPlanner.swift` — PURE core:
    `allocateSlots` apportions the quiz's slots across subjects by mastery-gap
    weight using **highest-averages (D'Hondt)** — proportional, deterministic,
    sums to exactly `min(total, Σ available)`, respects each subject's pool cap,
    ties break weakest-first by input order, zero-gap subjects kept eligible via
    a `minWeight` floor; `compose` does allocate → truncate each gap-ordered pool
    → interleave weak-first by **reusing `JourneyPlanner.roundRobinReviews`** (one
    shared spread guarantee, not a re-implementation).
  - `desktopAhaan/Services/Persistence/DataStore+MilestoneAssessment.swift` — the
    `@MainActor buildMilestoneAssessment(registry:targetCount:now:)`: builds a
    `MasteryEngine.snapshot`, and for each STARTED subject gathers its REVIEWED
    topic questions ordered **weakest-first** (lowest `MasteryLevel`, then lowest
    SM-2 ease, then authored order), weights each subject by gap
    (`1 − masteryFraction`), composes, and resolves picks back to
    `AssessmentQuestion`s. Scope choices: started subjects only (never quizzes an
    unopened subject), reviewed *topic* questions only (never unseen content,
    never scene-embedded boss/quick-check ids), pack-`packId`-scoped resolution
    so a colliding bare `chNN_tNN_qNN` id is credited only to the subject the kid
    answered it in. Degrades to a shorter quiz on a thin profile — no filler.
    READ-ONLY over the SRS (no mutation/scheduling/write).
- Tests (+13): `MilestoneAssessmentPlannerTests.swift` (10 pure —
  proportionality, cap-spill, sum-to-capacity, weakest-first tie-break, zero-
  weight floor, edge cases; compose allocate-by-gap + weak-first interleave,
  truncation, total-clamp/empty, out-of-order pools) and
  `MilestoneAssessmentIntegrationTests.swift` (3 @MainActor over the live
  registry on an isolated temp store: empty-when-nothing-reviewed; cross-subject
  spread + resolved-question integrity + collision-safe crediting + unique ids +
  subjectCounts tally + read-only-over-SRS; and gap-weighting tests the weaker
  subject more, leading the order with it).
- **Caught + fixed a test bug, not a code bug:** the gap-weighting test first
  assumed Science (`ch*`) and Maths question ids were disjoint — but only
  *concept* ids are pack-prefixed; topic-question ids share the bare
  `chNN_tNN_qNN` scheme, so the two seed sets collided and the second overwrote
  the first (inverting the result). Fixed by seeding against a shared `seen` set
  so the two id sets are disjoint strings, each with the correct `packId`. The
  production code was already correct (it disambiguates by `packId`).
- Green here: all 8 Big-Sur lints + `test_lints.py` pass; pbxproj regenerated (3
  source + 2 test files auto-wired); `ci-build-test.sh` → **BUILD + 777 XCTest,
  0 failures** (was 764, +13). Purely additive — zero existing-file edits; zero
  regressions; zero STOP_AND_ASK.
- **NEXT:** Phase 4 M2 — the assessment-taking UI: a pure-SwiftUI Milestone
  Assessment window (intro → one-question-at-a-time answer/score → result
  breakdown by subject), reusing the existing `AnswerValidator` correctness path
  and the NSHostingController window-presenter pattern, under the Big-Sur /
  legacy-GPU invariants, + a render/routing test. Then M3 — extend the
  Weekly-Progress PDF into a parent **report card** folding in the mastery
  snapshot + latest assessment score.

### Cycle 17 (2026-06-02) — Phase 4 · M2 · Milestone Checkpoint UI + MCQ refinement
- Confirmed M1 still green here before any change (777 XCTest, 0 fail).
- **Builder refinement (M2a):** a milestone assessment is now defined as a
  **single-tap-gradable multiple-choice checkpoint**. `DataStore.isAssessableMCQ`
  gates the sampler pool to `.mcq` questions whose options include the canonical
  answer (`AnswerValidator.matches`); free-text / numerical / match-the-following
  items are out of scope (they keep their richer practice UX). MCQ is 64% of the
  question bank (1501 items) — pools stay ample. Updated the M1 integration tests
  to seed assessable-MCQ ids accordingly.
- **The Milestone Checkpoint UI (M2b):**
  - `desktopAhaan/Views/Progress/MilestoneAssessmentView.swift` (~430 LOC) — a
    pure-SwiftUI three-phase flow held entirely in local `@State`: intro → one
    question at a time (tap an option · Check · see correct/your-answer + the
    first solution step) → a result screen with score, a static `ScoreBar`, and a
    per-subject correct/total breakdown in quiz order. Scoring is local via
    `AnswerValidator.matches`; it **never writes the SRS** (a check-in, not a
    teaching surface — retaking can't distort the schedule), stated to the kid on
    the intro card. Welcoming empty state when nothing assessable is reviewed yet.
  - `desktopAhaan/Views/Progress/MilestoneAssessmentWindow.swift` —
    `MilestoneAssessmentWindowPresenter` (NSHostingController singleton, proven
    WeeklyProgress/MasteryMap pattern). Help → Milestone Checkpoint (⌘⇧K) added
    to the dashboards Group in `desktopAhaanApp.swift`.
- Big-Sur invariants honoured: `@MainActor` view; colours via DesignTokens
  (success/danger/primaryAction/canvasText…, no raw mint/indigo/teal/cyan/brown);
  SF-Symbol-free (emoji + ✓/✗/●/○ glyphs); ViewBuilder ≤10 (Group + extracted
  subviews); transitions only through `withAnimationRespectingReduceMotion`;
  static `ScoreBar` (no animation/particles → legacy-GPU-free); every interactive
  button carries an explicit a11y label, each card a combined label, bars
  accessibility-hidden. **The `check_mainactor_closure_refs` lint caught a real
  Big-Sur hard-error** — `Button(action: begin)` passing a @MainActor method by
  bare reference — fixed to `Button(action: { begin() })` before any build.
- Tests (+4): `MilestoneAssessmentViewTests.swift` — `isAssessableMCQ` accept
  (incl. case/whitespace-normalised) + reject (no-match, empty, nil, non-MCQ)
  cases, and `NSHostingView` render-smoke of the view over both an empty world
  and a seeded one (no crash under Big-Sur layout).
- **Caught + fixed a test-coverage regression:** after the MCQ filter the
  gap-weighting integration test began *skipping* (couldn't find 6 *disjoint*
  MCQ ids across Science+Maths, which share the bare `chNN` id space). Switched
  its strong subject to **Social Science** (`sschNN_…` — a disjoint id prefix
  from Science's `chNN_…`), so the test reliably runs again (was 1 skipped → 0
  skipped). The pure planner test already proves the gap→more-slots property
  deterministically; this confirms it end-to-end with real mastery fractions.
- Green here: all 8 Big-Sur lints + `test_lints.py` pass; pbxproj regenerated (2
  source + 1 test file auto-wired); `ci-build-test.sh` → **BUILD + 781 XCTest, 0
  failures, 0 skipped** (was 777, +4). Additive (sole existing-file edit is the
  one new menu Button); zero regressions; zero STOP_AND_ASK.
- **The Milestone Checkpoint is now end-to-end reachable** — sampler + UI + menu.
- **NEXT:** Phase 4 M3 — extend the Weekly-Progress PDF into a parent **report
  card** folding in the `MasteryEngine` snapshot (per-subject coverage/mastery)
  and the latest checkpoint score, then wire its export + a test.

### Cycle 18 (2026-06-02) — Phase 4 · M3a · Checkpoint result persistence
- Confirmed M2 still green here (781 XCTest, 0 fail) before any change.
- Made the Milestone Checkpoint produce **durable** data so the parent report
  card (M3b) can fold in "the latest checkpoint":
  - `desktopAhaan/Models/MilestoneCheckpointResult.swift` — Codable value types
    `MilestoneCheckpointResult` (takenAt, correctCount, totalQuestions,
    per-subject breakdown; `scoreFraction`) and `MilestoneSubjectScore`, plus a
    PURE `from(assessment:correctById:takenAt:)` tally (subject order preserved).
  - `desktopAhaan/Services/Persistence/DataStore+MilestoneCheckpoint.swift` —
    `recordCheckpointResult` / `loadCheckpointResults` / `latestCheckpointResult`
    over a capped (50) chronological history in `milestone_checkpoints.json`,
    reusing the shared atomic-write plumbing. READ-ONLY over the SRS (new file).
  - `MilestoneAssessmentView` now builds the result once on completion, persists
    it via `recordCheckpointResult`, and renders the result screen FROM it
    (removed the view's ad-hoc breakdown in favour of the shared model).
- **Caught + fixed a real concurrency bug (not just a test bug):** the first cut
  did read-modify-write against the file (`loadCheckpointResults` → append →
  `save`), but `save` writes ASYNCHRONOUSLY on `saveQueue`, so two records in
  quick succession each read the not-yet-written file and clobbered history
  (tests caught: count 1 not 2, cap 21 not 50). Fixed by holding the history in
  memory on `DataStore` (`milestoneCheckpoints`, lazily hydrated once via
  `hydrateMilestoneCheckpointsIfNeeded`, mirroring `conceptVisitHistory`) so the
  append-then-save can't race the write.
- Tests (+5): `MilestoneCheckpointResultTests.swift` — pure `from` tally + empty
  case; and persistence (append + latest-is-newest, history cap keeps the most
  recent N, read-only-over-SRS).
- Green here: all 8 Big-Sur lints + `test_lints.py` pass; pbxproj regenerated (2
  source + 1 test auto-wired; DataStore.swift gained 2 stored props); 
  `ci-build-test.sh` → **BUILD + 786 XCTest, 0 failures** (was 781, +5). Additive
  (sole existing-file edits: DataStore stored props + the view's result wiring);
  zero regressions; zero STOP_AND_ASK.
- **NEXT:** Phase 4 M3b — the parent **report card**: extend the Weekly-Progress
  PDF with a `MasteryEngine` per-subject coverage/mastery section + the latest
  checkpoint score, wire its export (NSSavePanel + menu), and a render test.

### Cycle 19 (2026-06-02) — Phase 4 COMPLETE · M3b · Parent report card PDF
- Confirmed M3a still green here (786 XCTest, 0 fail) before any change.
- Extended the Weekly-Progress PDF export into a **two-page parent report card**:
  - `desktopAhaan/Services/WeeklyReportPDFExporter.swift` — factored the CG PDF
    context boilerplate into `withPDFContext` + `drawPage` (page-1 weekly output
    is byte-for-byte unchanged → existing exporter tests untouched), then added
    `exportReportCard(activity:masteryRows:checkpoint:to:)`: page 1 = the weekly
    summary, page 2 = **Mastery by subject** (per-subject Coverage% · Mastery% ·
    level, or "Not started yet") + **Latest checkpoint** (score, date, per-subject
    correct/total, or a "none yet" nudge). Plus `reportCardFilename`. Stays UI-free
    — it takes plain values, not the live engine — so it's off-main + testable.
  - `desktopAhaan/Models/ReportCardMasteryRow.swift` — the flat mastery-row value
    + a pure `rows(from: OverallMasterySnapshot)` mapper (registry order).
  - `WeeklyProgressView` — its export button now builds the `MasteryEngine`
    snapshot rows + `latestCheckpointResult()` and calls `exportReportCard`
    (relabelled "Export Report Card (PDF)", report-card filename + message). The
    view already had both `dataStore` + `registry`, so no plumbing change.
- Big-Sur safe: pure Core Graphics + AppKit text drawing (no PDFKit, no macOS-12
  APIs), atomic write, value-type inputs; the second page reuses the existing
  `drawText`/`drawRow` helpers.
- Tests (+5): exporter — report card writes a valid (`%PDF-`) PDF under 200 KB,
  handles a nil checkpoint + empty mastery, filename format; mapping —
  `ReportCardMasteryRow.rows` preserves order + carries coverage/mastery/started,
  and empty-snapshot → no rows.
- Green here: all 8 Big-Sur lints + `test_lints.py` pass; pbxproj regenerated (2
  new files auto-wired); `ci-build-test.sh` → **BUILD + 791 XCTest, 0 failures**
  (was 786, +5). Additive (sole existing-file edits: the exporter refactor +
  WeeklyProgressView's export call); zero regressions; zero STOP_AND_ASK.
- **PHASE 4 (Milestone Assessments + Parent Report Card) is COMPLETE** — the
  mastery-gap MCQ sampler (M1), the Milestone Checkpoint window (M2), durable
  checkpoint results (M3a), and the two-page parent report card (M3b) are all
  end-to-end reachable and green.
- **NEXT:** Phase 5 — OLYMPIAD / EXPERT CHALLENGE LADDER: tiered expert question
  sets sourced from chapter `deepDive` content, unlocked by mastery. Read the
  existing deepDive / expert content + the mastery gating first; extend, don't
  replace.

### Cycle 20 (2026-06-02) — Phase 5 · M1 · Expert Challenge Ladder engine
- Confirmed Phase 4 still green here (791 XCTest, 0 fail) before any change.
- **Reconnaissance finding that shaped the design:** difficulty-4 (286) and
  difficulty-5 (186) questions are abundant, but `deepDive.bonusQuestions` are
  **unpopulated across every pack (0)**. So the ladder's two lower tiers are
  content-rich from the existing hard questions, while the top (Olympiad) tier —
  honestly sourced from `deepDive` per the brief — is empty until that content
  is authored. No fake filler: the mechanism is complete + future-proof, and the
  M2 view will render only non-empty tiers so today's kid sees a rich Stretch +
  Challenge ladder, with Olympiad lighting up automatically once deepDive bonus
  questions land (a content task, not a code one).
- Built the **read-only Expert Challenge Ladder** (mirrors MasteryEngine /
  JourneyPlanner pure-core + @MainActor-builder split):
  - `desktopAhaan/Models/ExpertChallengeLadder.swift` — `ExpertTier`
    (stretch/challenge/olympiad; `unlockMastery` 0.20/0.50/0.80 aligned to the
    Familiar/Confident/Mastered bands; pure `classify(band:isDeepDive:)` — a
    deepDive bonus question is always Olympiad, else `.stretch`/`.challenge` by
    intrinsic band, `.easy`/`.core` excluded), `ExpertTierSet` (tier · isUnlocked
    · questions · isPlayable), `SubjectChallengeLadder`, `ExpertChallengeLadder`.
    Tiers reuse `AssessmentQuestion` so the M2 UI can present them like a
    checkpoint.
  - `desktopAhaan/Services/ExpertChallengePlanner.swift` — PURE `tierSets`:
    always three tiers in order, each unlocked iff `masteryFraction ≥`
    threshold.
  - `desktopAhaan/Services/Persistence/DataStore+ExpertChallenge.swift` — the
    `@MainActor buildExpertChallengeLadder`: gathers each subject's expert
    `isAssessableMCQ`s (hardest topic questions + deepDive bonus questions),
    classifies + dedupes them, orders each tier hardest-first and caps at 25,
    and marks unlock from the `MasteryEngine.snapshot` mastery fraction.
    READ-ONLY over the SRS.
- **Caught + fixed a real Swift-5.5 isolation error:** a nested local `func`
  doesn't inherit `@MainActor`, so it couldn't call the main-actor
  `isAssessableMCQ` ("call to main actor-isolated static method in a synchronous
  nonisolated context"). Replaced it with a `@MainActor` instance helper
  (`expertEntry`) and inlined the dedup/append.
- Tests (+7): `ExpertChallengePlannerTests.swift` (5 pure — classify by band,
  deepDive-always-Olympiad, escalating unlock thresholds, three-tiers-in-order,
  unlock-by-mastery incl. locked-not-playable) and
  `ExpertChallengeIntegrationTests.swift` (2 @MainActor over the live registry:
  tier structure + band-consistent classification + per-tier cap + all-MCQ +
  unique-per-subject + ladder-not-empty + read-only-over-SRS; and tiers unlock
  with a mastered subject while an unstarted subject stays locked).
- Green here: all 8 Big-Sur lints + `test_lints.py` pass; pbxproj regenerated (3
  source + 2 test files auto-wired); `ci-build-test.sh` → **BUILD + 798 XCTest,
  0 failures** (was 791, +7). Purely additive; zero regressions; zero
  STOP_AND_ASK.
- **NEXT:** Phase 5 M2 — the **Expert Challenges window**: a pure-SwiftUI ladder
  view (subjects → tiers with locked/unlocked/playable states; tap a playable
  tier to run a challenge quiz reusing the Milestone MCQ flow), Help-menu wiring
  + a render test. Render only non-empty tiers (Olympiad hidden until authored).

### Cycle 21 (2026-06-02) — Phase 5 COMPLETE · M2 · Expert Challenges window
- Confirmed M1 still green here (798 XCTest, 0 fail) before any change.
- **Shared the MCQ UI first (DRY, no duplication):**
  `desktopAhaan/Views/Progress/MCQQuizComponents.swift` — stateless reusable
  `MCQOptionRow` (selection + graded styling, ✓/✗/●/○ glyphs, a11y label) and
  `MCQFeedbackBlock` (correct/incorrect + first solution step). Refactored
  `MilestoneAssessmentView` to use them (behavior-preserving — its render +
  isAssessableMCQ tests stay green), so the new ladder reuses the exact same
  option/feedback rendering instead of copying it.
- **Built the Expert Challenges ladder:**
  - `desktopAhaan/Views/Progress/ExpertChallengeLadderView.swift` (~390 LOC) — a
    pure-SwiftUI three-phase flow (ladder → playing → result). The ladder lists
    each subject-with-content with a mastery level chip and its tiers; only
    tiers with authored questions are shown (so the empty Olympiad tier is hidden
    today), each marked ⭐️ playable (Start button) or 🔒 locked ("Reach <Level>
    to unlock"). Tapping a playable tier runs a short MCQ challenge over that
    tier's questions using the shared components; the result screen scores it
    locally with a Try-again / Back-to-challenges choice. Practice surface —
    scoring is local (`AnswerValidator`), it **never writes the SRS**.
  - `desktopAhaan/Views/Progress/ExpertChallengeLadderWindow.swift` —
    `ExpertChallengeLadderWindowPresenter` (NSHostingController singleton). Help →
    Expert Challenges (⌘⇧E) added to the dashboards Group in `desktopAhaanApp.swift`
    (now 7 children, ≤10).
- Big-Sur invariants: `@MainActor` views; DesignTokens colours; SF-Symbol-free
  (emoji/glyphs); ViewBuilder ≤10 (Group + extracted subviews; the menu Group
  re-counted at 7); transitions via `withAnimationRespectingReduceMotion`; no
  force-unwrap; explicit a11y labels on every button + combined card labels;
  `Button(action:)` wraps each method call in a closure (the lint stayed clean).
- Tests (+2): `ExpertChallengeLadderViewTests.swift` — `NSHostingView`
  render-smoke over a locked world and a mastered (tier-unlocked) world.
- Green here: all 8 Big-Sur lints + `test_lints.py` pass; pbxproj regenerated (3
  source + 1 test auto-wired); `ci-build-test.sh` → **BUILD + 800 XCTest, 0
  failures** (was 798, +2). Additive (sole existing-file edits: the Milestone MCQ
  refactor to shared components + the one new menu Button); zero regressions;
  zero STOP_AND_ASK.
- **PHASE 5 (Olympiad / Expert Challenge Ladder) is COMPLETE** — the read-only
  mastery-gated tier engine (M1) and the Expert Challenges window with playable
  challenges (M2) are end-to-end reachable and green. (Content note: the Olympiad
  tier populates once `deepDive.bonusQuestions` are authored — a content task;
  the mechanism is done and tested.)
- **NEXT:** Phase 6 — INTEGRATE / TEST / DOC: confirm all v6 Help-menu wiring,
  do an a11y / WCAG / reduce-motion / legacy-GPU pass over the new windows, round
  out tests, and write `LEARNING_JOURNEY_CHECKPOINT.md`.
