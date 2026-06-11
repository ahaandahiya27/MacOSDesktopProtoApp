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
| 3 | Extend the Advanced tier (the bulk) | ✅ done — 69/69 |
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

**Concurrency note (important):** this run executed alongside **two other
identical v8 agents** in the same shared working tree (the documented
"parallel shared-tree hazard"). The other two agents produced **content-only**
Advanced triplets for Maths (no pbxproj regen, no registry wiring, no test
bumps) — so their papers shipped as files but were *unreachable in-app*. This
agent therefore took the **integrator** lane plus a non-colliding content
subject (Social Science): commit content with explicit pathspec (`git commit --
<paths>`, never `git add -A`), and periodically wire ALL committed Advanced
papers into the Swift registry + `OlympiadExamHallTests` counts + regen the
pbxproj so the collective content actually loads in the app. The pre-commit
triplet check was scoped to staged files (commit `6913093`) so an unrelated
mid-flight paper can't block a clean commit.

**Authored by this agent:** Maths Ch01 (content), Social Science Ssch01
(content). **Integrated (wired + bundled) by this agent:** all committed
Advanced papers — see `ADVANCED_TIER_LEDGER.md` for the live ✅/❌ grid and the
registry-wiring waves below.

Integration waves (registry + tests + pbxproj):
- **Wave 1:** wired Maths Ch01, Ch08, Ch10, Ch11, Ch12 (+ Ch15/Sci13 anchors) →
  76 papers / 7 advanced. Build + full XCTest GREEN.
- **Wave 2:** + Maths Ch02, Ch04, Ch06 and Social Science Ssch01 → 80 papers /
  11 advanced. (Maths Ch03 content committed concurrently; bundled, wired in a
  later wave.)
- **Wave 3 (2026-06-10, final):** wired every remaining on-disk Advanced triplet
  — Maths Ch03, Ch05, Ch07, Ch09, Ch13, Ch14 (6) and Science Ch04, Ch15 (2) →
  **88 papers / 69 foundation + 19 advanced**. pbxproj regenerated (objectVersion
  55), `OlympiadExamHallTests` count + id-set assertions bumped, `check_testpaper
  _triplet` clean (364 papers, 0 orphans), `bash scripts/ci-build-test.sh` GREEN.
  Maths is now 15/15 Advanced; Science 3/19; Social Science 1/20; Sanskrit 0/15.
- **Waves 4–8 (2026-06-10/11):** Science Ch01/02/03/05/06/07/08/09/10 + Social
  Science Ssch02/03/04 authored/integrated across the fleet → **32 advanced**
  (see `ADVANCED_TIER_LEDGER.md` for the per-wave detail).
- **Wave 9 (2026-06-11):** **Science Ch11** (Transportation in Animals and
  Plants). The on-disk triplet had a positional-giveaway key (50/60 in slot B);
  fixed with the new **`scripts/rebalance_answer_key.py`** (deterministic,
  content-preserving option reorder + lockstep key rewrite → 15/15/15/15), guide
  regenerated, wired (`OlympiadExamHallTests` → 102 / 33 advanced). GREEN; pushed.
- **Wave 10 (2026-06-11):** **Social Science Ssch05** (The Rise of Empires,
  authored this session) **+ integrated the first three Sanskrit Advanced
  papers** (Sch13/14/15, authored by concurrent agents; their block-ordered keys
  were scattered with the rebalance tool). Wired all four →
  **106 papers / 69 foundation + 37 advanced**. GREEN; pushed (`baeebca`).
  Coverage: Maths 15/15, Science 15/19, Social Science 5/20, Sanskrit 3/15.
- **Waves 11–15 (2026-06-11):** the fleet authored + integrated the remaining
  Sanskrit (Sch01–Sch12), Science (Ch12/Ch16–Ch19) and Social Science
  (Ssch06–Ssch10, Ssch20) Advanced papers → **60 advanced / 129 papers**.
- **Wave 16 (2026-06-11, FINAL — Phase 3 complete):** sole-agent integrator pass
  wired the last nine Social Science Advanced triplets **Ssch11–Ssch19** (authored
  content-only by the now-wound-down fleet; this agent verified each is 60 MCQs
  with a balanced 15/15/15/15 key, then wired registry + bumped
  `OlympiadExamHallTests` to **138 papers / 69 foundation + 69 advanced** + regen
  pbxproj + bundled the untracked Ssch19 triplet). All lints clean,
  `ci-build-test.sh` GREEN; pushed `7dbf9bb`. **The Advanced tier is COMPLETE:
  Maths 15/15, Science 19/19, Social Science 20/20, Sanskrit 15/15.**
  `ADVANCED_TIER_LEDGER.md` grid all ✅; `docs/ISSUE_CATEGORIES.md` row **Y5 ✅**.

> **Fleet status (2026-06-11):** the two sibling v8 agents have wound down — `ps`
> now shows a single `claude` process. This agent proceeds solo for Phases 4–6.

> **Fleet note (2026-06-11):** this run executes alongside **two other identical
> v8 agents** in the same working tree (the documented parallel shared-tree
> hazard — `ps` confirms 3 `claude --dangerously-skip-permissions` procs). The
> siblings author Sanskrit/Science content **content-only** (no registry wiring),
> committing via `git add -A` sweeps; the `OlympiadPaperRegistry` + `Olympiad
> ExamHallTests` hotspot is edited by **this agent alone**, so the registry/count
> stays consistent. This agent uses **pathspec commits** and **rebalances every
> paper's answer key** before wiring. The full-tree triplet pre-push gate flaps
> whenever a sibling has a mid-flight orphan QP — pushes succeed in clean
> windows; retry on a transient triplet failure.

## Notes / decisions

- The 60-MCQ format (not "~25–40") matches the shipped prototype exactly —
  `make_solved_guide.py` hardcodes "All 60" / 240 marks and requires ≥50 merged
  questions, and the in-app hero band reads "60 Questions". Authoring to 60
  keeps every Advanced paper a true sibling of the prototype.
- Swift phases (4–5) are guarded by the v4 Big-Sur static lints since this dev
  Mac compiles with a newer toolchain; **final Big-Sur build confirmation is an
  iMac rebuild** (noted in the checkpoint).
