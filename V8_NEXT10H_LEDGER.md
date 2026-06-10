# V8 — Next 10h autonomous run · LEDGER

Single-agent, zero-input run building the next content + Discover layer on
top of the v6 Learning Journey and the Olympiad P3–P5 series. Resume from
this file. Phase sentinels printed to the run log: `V8_PHASE<N>_COMPLETE_v1`.

> **No-push gate (FB-001):** every milestone goes green (lints + build) THEN
> commits + pushes via the safe flow
> (`git pull --rebase --autostash origin main && git push origin main`).
> Never `--no-verify` / `--force`.

## Status board

| Phase | Title | State |
|-------|-------|-------|
| 0 | Back up + green baseline + coverage audit | ✅ done |
| 1 | Triplet-completeness lint (`check_testpaper_triplet.py`) | ✅ done |
| 2 | Coverage ledger + issue row Y5 | ✅ done |
| 3 | Extend the Advanced tier (the bulk) | 🟡 in progress |
| 4 | Bespoke Discover depth (Swift; guarded) | ⏳ pending |
| 5 | Visual library + a11y (Swift; guarded) | ⏳ pending |
| 6 | Document (`V8_NEXT10H_CHECKPOINT.md`) | ⏳ pending |

## Phase 0 — baseline (✅)

- Pushed local backlog (94 commits) via safe flow — origin/main in sync.
- **Latent fix:** committed `project.pbxproj` was `objectVersion 77` (Swift 6 /
  Xcode 16) — would NOT open on the iMac's Xcode 13.2.1. Regenerated to
  `objectVersion 55` via `scripts/generate_compat_pbxproj.py` and pushed
  (`chore(scripts): regen compat pbxproj baseline`). This was a real
  build-blocker waiting on the deploy machine.
- Baseline `bash scripts/ci-build-test.sh`: **GREEN** — all static lints clean,
  `** BUILD SUCCEEDED **`, `** TEST SUCCEEDED **` (66 swift-testing + XCTest unit
  suite). DerivedData pinned off the fileprovider tree
  (`CI_DERIVED_OVERRIDE=/tmp/desktopAhaan-ci-derived`).

### Coverage audit (Phase 0 step 3 — the real gap)

Two streams surveyed:

- **`TestPapers/`** (repo root) — Olympiad **P3/P4/P5** series. 276
  `_QuestionPaper.md`, each paired with a `_Solutions.md` + rendered `_PN.html`.
  Broad (all four subjects × 69 chapters × 3 papers approx). No `_SolvedGuide`.
- **`desktopAhaan/Resources/TestPapers/`** — bundled **SolvedGuide** stream
  (71 base triplets: QuestionPaper.md + Solutions.md + SolvedGuide.html) **plus
  the sparse `_Advanced_` tier**.

**The real gap = the Advanced tier.** Only **2 / 69** base chapters had an
`_Advanced_` triplet at run start:

| Subject | Base chapters | Advanced present | Missing |
|---------|--------------:|-----------------:|--------:|
| Maths | 15 | 1 (Ch15) | 14 |
| Science | 19 | 1 (Ch13) | 18 |
| Sanskrit | 15 | 0 | 15 |
| Social Science | 20 | 0 | 20 |
| **Total** | **69** | **2** | **67** |

Full per-chapter ✅/❌ table: see **`ADVANCED_TIER_LEDGER.md`** (sourced by the
Phase-1 lint).

## Phase 1 — triplet lint (✅)

`scripts/check_testpaper_triplet.py` — for every `*_QuestionPaper.md` in both
streams, asserts a non-empty `*_Solutions.md`; in the Resources stream also a
non-empty `*_SolvedGuide.html`. `--selftest` builds a throwaway tree and asserts
it flags exactly the planted orphans. **0 pre-existing orphans** (clean baseline).
Wired into `scripts/ci-build-test.sh` (always) + `scripts/hooks/pre-commit`
(gated on a staged TestPapers file) + re-installed via `install-git-hooks.sh`.

## Phase 2 — ledger + issue row (✅)

- `ADVANCED_TIER_LEDGER.md` created (mirror of `OLYMPIAD_CONTENT_LEDGER.md`).
- `docs/ISSUE_CATEGORIES.md` row **Y5** added — "Advanced-tier test-paper
  coverage" (next free id after Y4). 🟡 until all 69 base chapters carry an
  Advanced triplet.

## Phase 3 — Advanced tier rollout (🟡)

Gold standard: `Maths_Ch15_FindingTheUnknown_Advanced_*`. Format per chapter:
**60 single-correct MCQs** (+4/−1/0, 240 marks, 90 min), QuestionPaper.md +
Solutions.md (worked prose with a check-by-substitution habit), then
`make_solved_guide.py --bulk` auto-renders the SolvedGuide.html. Grounded in the
chapter pack JSON + source PDFs (`/Users/mac/Extra/Ahaan-Books/`). One chapter =
one commit. Priority order: Maths → Science → Social Science → Sanskrit.

| Chapter | Committed |
|---------|-----------|
| _(rolling — see ADVANCED_TIER_LEDGER.md for the live ✅/❌ grid)_ | |

## Notes / decisions

- The 60-MCQ format (not "~25–40") matches the shipped prototype exactly —
  `make_solved_guide.py` hardcodes "All 60" / 240 marks and requires ≥50 merged
  questions, and the in-app hero band reads "60 Questions". Authoring to 60
  keeps every Advanced paper a true sibling of the prototype.
- Swift phases (4–5) are guarded by the v4 Big-Sur static lints since this dev
  Mac compiles with a newer toolchain; **final Big-Sur build confirmation is an
  iMac rebuild** (noted in the checkpoint).
