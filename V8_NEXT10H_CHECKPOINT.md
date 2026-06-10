# V8_NEXT10H_CHECKPOINT.md — Advanced-tier build (autonomous run)

This checkpoint records the v8 "next 10h" autonomous run that built out the
**Advanced (Paper 2) test-paper tier** and hardened the build tooling. The run
executed as a fleet of dangerous-mode agents sharing one working tree (the
documented `[[feedback-parallel-shared-tree]]` pattern), using pathspec commits
and the mutex-serialized pre-push gate. Coverage figures below are the repo
state at checkpoint time; the Advanced tier is still being extended.

## Phase 0 — Baseline, audit, and a root-cause tooling fix ✅

- **Backlog pushed** via the safe flow (`pull --rebase --autostash` → `push`).
- **Real coverage audit.** Two TestPapers streams confirmed:
  - `TestPapers/` (repo root) — the Olympiad P3–P5 series (rendered + md).
  - `desktopAhaan/Resources/TestPapers/` — the bundled SolvedGuide stream
    (69 base chapters) plus the sparse `_Advanced_` tier (only Maths Ch15 +
    Science Ch13 at run start = **2 / 69**).
- **Critical generator bug fixed (`fix(scripts)` f608afe).**
  `scripts/generate_compat_pbxproj.py`'s `is_resource()` matched only
  `.html/.css/.json`, so regenerating the pbxproj **silently dropped all 142
  `*_QuestionPaper.md` / `*_Solutions.md` and 69 `.pdf`** TestPapers resources
  from the app target's Resources build phase. The build still *succeeds*
  (markdown/PDF aren't compiled), but `OlympiadPaperParser` loads the paper
  markdown from `Bundle.main`, so on the iMac **every Olympiad / Advanced paper
  would fail to load at runtime.** A prior "regen baseline" commit had already
  shipped this regression to `origin`; the fix adds `.md` + `.pdf` to
  `is_resource` (plus an `image.pdf` file type) and regenerates, restoring all
  213 md refs + 71 SolvedGuide.html + 69 PDFs. Verified: no duplicate resource
  basenames; `xcodebuild -list` parses all three targets.

## Phase 1 — Triplet-completeness lint ✅

`scripts/check_testpaper_triplet.py` asserts every `*_QuestionPaper.md` (both
streams) has a non-empty `*_Solutions.md`, and — in the bundled Resources
stream — a non-empty `*_SolvedGuide.html`. Self-test fixtures; wired into
`scripts/ci-build-test.sh` and the pre-commit hook (runs when a test-paper file
is staged). Now gates ~350 question papers clean.

## Phase 2 — Coverage ledger + issue row ✅

`ADVANCED_TIER_LEDGER.md` (per-subject ✅/❌ grid, sourced by the Phase-1 lint)
and a new `docs/ISSUE_CATEGORIES.md` row **Y5** ("Advanced-tier paper
coverage"; Y4 was already taken by "Diff-friendly JSON formatting").

## Phase 3 — Advanced tier authored (the bulk) 🟡 in progress

Each chapter ships the gold-standard triplet modelled on
`Maths_Ch15_FindingTheUnknown_Advanced_*`: a **60-MCQ Paper 2** (+4 / −1 / 0,
240 marks, 90 min) that does NOT repeat the base paper, plus worked
`_Solutions.md`, plus an **auto-generated** `_SolvedGuide.html`
(`scripts/make_solved_guide.py`, bulk/fallback clustering — never hand-authored).
One chapter = one commit.

**Quality controls applied to every authored paper:**
- All 60 questions parse and merge cleanly (verified via the guide generator).
- No duplicate options within any question.
- Every marked-correct option value cross-checked against its worked solution.
- Answer key spread roughly evenly across A/B/C/D (≈15 each) — no positional
  giveaway.

**Coverage at checkpoint:**

| Subject | Advanced triplets complete | Notes |
|---|---|---|
| **Mathematics** | **15 / 15 ✅** | Ch01–Ch15 all have Paper 2 (Ch01 + Ch15 prototype + Ch02–Ch14 this run). |
| **Science** | **10 / 19** | Ch01 Nutrition-Plants, Ch02 Nutrition-Animals, Ch04 Heat, Ch05 Acids/Bases, Ch06 Physical/Chemical, Ch08 Winds/Cyclones, Ch10 Respiration, Ch13 Motion (prototype), Ch14 Electric Current, Ch15 Light. |
| Social Science | 1 / 20 | Ssch01 Geographical Diversity. |
| Sanskrit | 0 / 15 | not yet started. |

**Total Advanced triplets: 26 / 69** (up from 2 / 69 at run start). The bulk
of this run authored the complete Maths tier (13 new chapters) and 9 new
Science chapters — 1,320 verified beyond-grade MCQs with worked solutions and
auto-generated solved guides, every paper passing the triplet lint and the
internal answer-key verification.

Maths spans arithmetic (integers, fractions, decimals ×/÷ and place-value,
BODMAS), number theory (HCF/LCM, number-play/parity/cryptarithms), algebra
(letter-numbers), data handling, and the geometry chapters (angle chasing,
triangles, congruence, constructions/tilings) — all stated in words so the
text-only SolvedGuide renders faithfully.

## Phases 4–5 — Swift Discover depth + visual library ⏸️ not in this contribution

This run focused on the **content-safe** layer (Phase 0–3) per the deliberate
ordering. Surfacing the new papers in-app (registry entries in
`OlympiadPaperRegistry+*.swift` + pbxproj bundling) is **data-wiring handled by
the fleet's wiring pass**, guarded by the v4 Big-Sur lints. Bespoke
chapter-specific Discover scenes (Sanskrit/Social Science) and additional
`ShapeDiagramRegistry` diagrams were **not** undertaken here and remain open.

## Honest status notes

- **Big-Sur build of any Swift wiring needs a final iMac rebuild to confirm.**
  This dev Mac cannot compile the Big Sur target; correctness there rests on the
  static lints + the dev-Mac `ci-build-test.sh` (which passed on every push).
- The Advanced tier is **partially complete (Maths done; Science/SocSci/Sanskrit
  partial)**. The Phase-1 lint + `ADVANCED_TIER_LEDGER.md` remain the live source
  of truth for what is finished.
- Content packs were authored from NCERT Class 7 subject knowledge and the base
  papers; Maths answers are arithmetically verified, and Science answers are
  grounded in the standard Class 7 curriculum.
