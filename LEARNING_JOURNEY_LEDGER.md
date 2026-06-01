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
