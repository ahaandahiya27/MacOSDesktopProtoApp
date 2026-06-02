# V7_DEPTH_LEDGER.md — "Discover Depth + Visual Library"

> Resumable ledger for the v7 autonomous run. Read this FIRST each cycle and
> resume from the first ⬜ / 🟡 milestone. One chapter / diagram-batch = one
> milestone. Every committed milestone is green here (Release build + full
> XCTest) before its row flips to ✅.

## Baseline reconciliation (cycle 1, 2026-06-02)

Phase 0 proved green: `generate_compat_pbxproj.py` + `ci-build-test.sh` →
Release BUILD + **801 XCTest, 0 failures**, all 17 lints + `test_lints.py`
clean. Never built new work on red.

**Audit-gap reconciliation against the actual tree** (the v7 brief's premise
was partly already-closed by prior sessions — recorded honestly here):

| Phase | Brief premise | Actual state on `main` @ baseline | Verdict |
|-------|---------------|-----------------------------------|---------|
| 1 · Social Science bespoke Discover | "runs on a single generic data-driven view" | **DONE.** `socialScienceInteractives(pack:chapter:)` mounts 14 named strand explorers (IndiaPhysiographicExplorer, BarterToMoneySim, PreambleExplorer, MarketPriceBalance, ThreeOrgansSorter, CompoundingGrowth, CroppingSeasonExplorer, GovernmentFormsExplorer, ClimateFactorsExplorer, WeatherInstrumentLab, InfrastructureSorter, IndiaNeighboursExplorer, HomeToManyExplorer, SacredGeographyExplorer) + `SSChronologyChallenge` (6 history ch) + `SSGlossaryMatchChallenge` fallback — **all 20 chapters covered**, gated by `socialScienceInteractivesAreEnabled`, pinned by `SocialScienceInteractiveGateTests`. | ✅ pre-existing |
| 2 · Sanskrit bespoke Discover | "runs on a single generic data-driven view" | **WAS open.** No `sanskritInteractivesAreEnabled` gate, no word-play interactive existed. | see M2.1 |
| 3 · Shape Diagram Library | "ShapeDiagramRegistry is a stub (~76 diagrams as placeholders)" | **OPEN.** `registrations` is `[:]` — empty by design. | ⬜ |
| 4 · Reading-level polish | "a few callouts above the Class-7 band" | advisory; `check_callout_reading_level.py` exists | ⬜ |
| 5 · Integrate/test/doc | — | partial (SS gate test exists) | ⬜ |

> Note: 3 `.claude/worktrees/agent-*` worktrees exist on unrelated stale
> branches (OCR scan quality, dead-iOS-code cleanup, SF-symbol routing) — NOT
> v7, NOT shape-diagram work. They are full-tree checkouts that merely contain
> a copy of `ShapeDiagramRegistry.swift`; unmerged; left untouched.

## Phase 1 — Social Science bespoke Discover

- ✅ **Pre-existing** — all 20 chapters carry a strand-matched bespoke
  interactive (see table above). No new work required; verified at baseline.

## Phase 2 — Sanskrit bespoke Discover

- ✅ **M2.1 — शब्द–अर्थ (word↔meaning) match, all 15 NEP chapters** (cycle 1).
  New gate `sanskritInteractivesAreEnabled(forPackId:)` + `sanskritInteractives(
  pack:chapter:)` mounting `ShabdaArthaMatchChallenge` (Devanagari-forward,
  faithful to each chapter's own glossary, reduce-motion-gated, VoiceOver
  labelled, no force-unwrap). Mounted on ChapterDetailView (SS+Sanskrit bucketed
  in one Group to hold the ≤10-child cap). Legacy `ch01` deck excluded (no `sch`
  prefix). +`SanskritInteractiveGateTests` (4 cases): pack-only gate, 3-way
  mutual-exclusivity, reverse-leak guard, 15/15 NEP coverage. Green: 17 lints +
  test_lints + ci-build-test (Release BUILD + 805 XCTest, 0 fail).

## Phase 3 — Shape Diagram Library (~76 pure-SwiftUI chapter diagrams)

Registry was empty; populating one chapter-slice (4 diagrams) per milestone.
Keys follow JSON `MediaAsset.resource` (`chNN_<short_name>`). Path/Shape only;
no MapKit/macOS-12 APIs; legacy-GPU friendly. `ShapeDiagramRegistryTests` pins
no-orphan-registration + factory-resolves + per-slice coverage each slice.

- ✅ **M3.1 — ch01 Nutrition in Plants (4/4)** (cycle 1): `ChloroplastDiagram`,
  `StomataDiagram` (open/closed guard cells), `PhotosynthesisEquationDiagram`
  (CO₂+H₂O+light→glucose+O₂ over a leaf), `LeafAnatomyDiagram` (epidermis /
  palisade / spongy + vein / stoma). Registered + `registeredKeys` accessor.
  +`ShapeDiagramRegistryTests` (4). Green: Release BUILD + 809 XCTest, 0 fail.
- ⬜ M3.2…M3.19 — remaining 18 chapters (ch02–ch19), 72 diagrams. Resource keys
  enumerated: 76 total, 4/chapter, all in `science_class7`.

## Phase 4 — Reading-level + polish

- ⬜ Simplify over-band callouts flagged by `check_callout_reading_level.py`
  without losing accuracy.

## Phase 5 — Integrate / test / doc

- ⬜ Pin: every Sanskrit + SS chapter has a bespoke Discover experience;
  leak-gate mutual exclusivity; no unregistered ShapeDiagram keys for covered
  chapters; scene-count invariants. Write V7_DISCOVER_DEPTH_CHECKPOINT.md.
