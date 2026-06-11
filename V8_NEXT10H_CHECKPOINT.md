# V8 — Next 10h autonomous run · CHECKPOINT (final)

Single-agent, zero-input run building the next content + Discover layer on top of
the v6 Learning Journey and the Olympiad P3–P5 series. This document records what
shipped per phase, the coverage delta, and the honest Big-Sur verification status.
Companions: `V8_NEXT10H_LEDGER.md` (live status board) and `ADVANCED_TIER_LEDGER.md`
(per-chapter grid).

> **Verification environment note.** This dev Mac compiles with a newer Xcode
> toolchain than the Late-2014 iMac deploy target (Big Sur 11.7.11 / Xcode 13.2.1 /
> Swift 5.5). All Swift work below is gated by the v4 Big-Sur static lints
> (`check_viewbuilder_limit`, `check_mainactor_closure_refs`, `check_macos12_apis`,
> `check_swift55_syntax`, …) and a full `ci-build-test.sh` (Release build + Debug
> XCTest) on this Mac. **Final Big-Sur build confirmation is an iMac rebuild** —
> push, then `scripts/imac-pull.sh`.

## Phase 0 — Backup + green baseline + coverage audit ✅

- Pushed local backlog via the safe flow; origin/main in sync.
- **Latent build-blocker fixed:** a committed `project.pbxproj` was `objectVersion 77`
  (Xcode 16 / Swift 6) — would not open on the iMac's Xcode 13.2.1. Regenerated to
  `objectVersion 55` via `scripts/generate_compat_pbxproj.py`.
- **Critical generator bug fixed earlier in the run (`f608afe`):**
  `generate_compat_pbxproj.py`'s `is_resource()` matched only `.html/.css/.json`, so
  regenerating the pbxproj silently dropped all `*_QuestionPaper.md` / `*_Solutions.md`
  / `.pdf` TestPapers from the app target — build still succeeded, but every paper
  would fail to load at runtime on the iMac. Fix added `.md` + `.pdf` to `is_resource`.
- Baseline `ci-build-test.sh`: GREEN.
- **Coverage audit** surfaced the real gap: the SolvedGuide base stream was broad
  (~71 triplets) but the `_Advanced_` tier was a 2-chapter prototype (Maths Ch15,
  Science Ch13) — 67 / 69 chapters lacked an Advanced triplet.

## Phase 1 — Triplet-completeness lint ✅

`scripts/check_testpaper_triplet.py` — for every `*_QuestionPaper.md` in both
`TestPapers/` (Olympiad P3–P5) and `desktopAhaan/Resources/TestPapers/` (SolvedGuide
stream), asserts a non-empty `*_Solutions.md`; in the Resources stream also a
non-empty `*_SolvedGuide.html`. `--selftest` plants orphans in a throwaway tree and
asserts they're flagged. Wired into `ci-build-test.sh` (always) + the pre-commit hook
(scoped to staged TestPapers files so an unrelated mid-flight paper can't block a
clean commit). 0 pre-existing orphans; now gates 414 papers clean.

## Phase 2 — Coverage ledger + issue row ✅

- `ADVANCED_TIER_LEDGER.md` — per-subject ✅/❌ grid, sourced by the Phase-1 lint.
- `docs/ISSUE_CATEGORIES.md` row **Y5** ("Advanced-tier test-paper coverage") added
  as the next free id after Y4 ("Diff-friendly JSON formatting"). **Flipped ✅** once
  all 69 chapters carried an Advanced triplet (this run).

## Phase 3 — Advanced tier rollout ✅ — COMPLETE 69/69

Gold standard: `Maths_Ch15_FindingTheUnknown_Advanced_*`. Per chapter: **60
single-correct MCQs** (+4/−1/0, 240 marks, 90 min), `QuestionPaper.md` +
`Solutions.md` (worked prose, answers keyed `**N. (X)**`), then
`make_solved_guide.py --bulk` auto-renders the `SolvedGuide.html`. Every paper
carries a **balanced 15/15/15/15 answer key** — the run's `rebalance_answer_key.py`
deterministically reorders options + rewrites the key in lockstep where authoring
left a positional bias (worked prose references option *content*, never letters, so
the reorder is content-preserving and reproducible).

**Coverage delta: 2 / 69 → 69 / 69.**

| Subject | Run start | End | Status |
|---------|----------:|----:|:------:|
| Maths | 1 | 15 | ✅ 15/15 |
| Science | 1 | 19 | ✅ 19/19 |
| Social Science | 0 | 20 | ✅ 20/20 |
| Sanskrit | 0 | 15 | ✅ 15/15 |
| **Total** | **2** | **69** | ✅ |

Registry: `OlympiadPaperRegistry` now exposes **138 papers** (69 foundation + 69
advanced), pinned by `OlympiadExamHallTests` (total count, per-tier counts, and the
full advanced id-set). The rollout spanned Waves 1–16; this single-agent session
integrated the final **Wave 16** — wiring the last nine Social Science Advanced
triplets (Ssch11–Ssch19), bumping the test assertions (60→69 advanced, 129→138
total), regenerating the pbxproj, and bundling the previously-untracked Ssch19
triplet. All lints clean, `ci-build-test.sh` GREEN, pushed.

## Phase 4 — Bespoke Discover depth (Swift; guarded) ✅

**Audit finding:** Social Science and Sanskrit already had comprehensive bespoke
per-chapter interactives in the chapter *detail* surface — 16 distinct Social
Science widgets (`IndiaPhysiographicExplorer`, `BarterToMoneySim`, `PreambleExplorer`,
`SSChronologyChallenge`, `SSGlossaryMatchChallenge`, …) gated by pack id + chapter id,
plus Sanskrit's `ShabdaArthaMatchChallenge`. The v7 Discover-depth work in CLAUDE.md
is real and present.

**The genuine remaining gap** was the Discover *scene flow*: Social Science was the
only one of the four subjects whose Discover flow carried no gated interactive
(Science/Maths slot per-chapter sandboxes/tours; Sanskrit slots its word-match as
scene 4; Social Science used a purely generic info/quick/boss shape).

**Shipped** (`SocialScienceDiscoverInteractiveScenes.swift`, new): two Big-Sur-safe
gated Discover scenes mirroring `SanskritWordMatchScene`'s idioms (plain Buttons, no
macOS 12+ APIs, SF Symbols via `SFSymbolCompat`,
`withAnimationRespectingReduceMotion`, tap-to-select not drag):

- `SSDiscoverChronologyScene` — "tap the events earliest → latest" over the chapter's
  authored timeline, for the six History chapters (ssch04/05/06/07/15/16). Completion
  gated on placing every event in correct order; scramble is a deterministic,
  non-identity permutation.
- `SSDiscoverWordMatchScene` — key-word ↔ meaning match over the chapter glossary, for
  the other 14 chapters. Gated on matching every pair.

`DiscoverChapterSocialScienceView` inserts the gated scene as scene 5 (after three
concept scenes), dispatched by chapter type, with a safe fallback to an extra concept
scene if a chapter ever lacks the data. The 9-scene shape and the SRS path are
unchanged. **All four subjects now have a gated Discover interactive.**

Tests: `SocialScienceDiscoverInteractiveTests` (4) — every chapter can build its gated
interactive (timeline ≥3 steps / glossary ≥3 pairs); the scramble is a valid,
deterministic, non-identity permutation; degenerate counts handled. Built + GREEN.

## Phase 5 — Visual library + a11y (Swift; guarded, lowest priority) ✅ library / ⏸ H7

- **Visual library — verifiably complete, no work needed.** `ShapeDiagramRegistry`
  holds **76 pure-SwiftUI diagrams** (Science ch01–ch19 × 4). An audit of all four
  pack JSONs confirms **every `kind: "shapeDiagram"` reference (76, all Science) is
  registered — 0 unregistered keys**, so the placeholder-card fallback is a pure
  safety net never reached at runtime. Maths/Sanskrit/Social Science don't use
  `shapeDiagram` media (they ship bespoke interactives + galleries), so there is no
  missing-diagram gap to close.
- **H7 (keyboard-only navigation) — deferred, recorded.** The app already has broad
  keyboard coverage (21 `keyboardShortcut`s in `desktopAhaanApp.swift`, a dedicated
  `KeyboardShortcutsSheet`, menu `Command`s, `.keyboardShortcut` on key Buttons) and
  leans on SwiftUI's default focus traversal by design (zero `.focusable()`). A
  genuine H7 close requires an **XCUITest driving the home flow with an AX grant on
  the runner** — default CI runs unit tests only; UI tests are `--ui` opt-in and need
  AX permission this dev Mac can't grant headlessly. A broad `.focusable()` sweep is
  also a Big-Sur-risky change unverifiable here. Per the run's "record and skip if it
  can't go green" rule, H7 stays 🟡 pending an AX-granted UI runner / iMac; no
  unverifiable change was shipped.

## Phase 6 — Document ✅

This file. Ledgers (`V8_NEXT10H_LEDGER.md`, `ADVANCED_TIER_LEDGER.md`) and
`docs/ISSUE_CATEGORIES.md` row Y5 updated in lockstep.

## Net delta this run

- **Advanced test-paper tier: 2 → 69 chapters (COMPLETE).** Registry 138 papers.
- **Social Science Discover flow: gated interactive added** → cross-subject Discover
  parity (all four subjects).
- **+5 tests** (4 Discover-interactive + the bumped `OlympiadExamHallTests` set).
- All lints clean; `ci-build-test.sh` GREEN at every committed milestone.
- **Outstanding for an iMac session:** Big-Sur build confirmation of the Phase-4
  Swift addition; H7 keyboard-nav close (needs an AX-granted UI runner).

## Honest status notes

- Big-Sur build of the Phase-4 Swift addition needs a final iMac rebuild to confirm;
  correctness here rests on the static lints + dev-Mac `ci-build-test.sh` (GREEN on
  every push).
- Content packs were authored from NCERT Class 7 subject knowledge and the base
  papers; every Advanced paper passes the triplet lint and carries a verified,
  balanced answer key.
