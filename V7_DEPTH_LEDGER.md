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
- ✅ **M3.2 — ch02–ch05 (16/16)** (cycle 2): new shared `ShapeDiagramKit`
  (SDFigure / SDLabel / SDChip / SDArrow / SDPlus / SDLeafShape / SDFingerShape;
  `SD*`-named to avoid colliding with ch01's file-private helpers). Diagrams —
  **ch02 Nutrition in Animals:** `digestive_system` (alimentary canal: mouth→
  oesophagus→J-stomach→coiled small intestine framed by large intestine + liver),
  `villi` (finger folds w/ red capillary loops), `tooth_types` (incisor/canine/
  premolar/molar crowns in a gum), `rumen` (4 chambers + cud-return arrow).
  **ch03 Fibre to Fabric:** `wool_process` (shearing→scouring→sorting→spinning),
  `silkworm_lifecycle` (egg→larva→cocoon→moth ring), `polymer_chain` (monomer→
  linked-bead chain), `fibre_compare` (natural vs synthetic columns).
  **ch04 Heat:** `thermometer` (clinical, bulb+kink+35–42 °C scale), `three_modes`
  (conduction/convection/radiation), `thermos_flask` (vacuum double-wall x-sec),
  `sea_breeze` (coast circulation). **ch05 Acids/Bases/Salts:** `ph_scale`
  (0–14 colour band), `neutralisation` (acid+base→salt+water), `indicators`
  (litmus/turmeric/china-rose colour table), `tooth_decay` (acid attack +
  base toothpaste). Test generalised to `testFullyCoveredChaptersAreComplete`
  (per-chapter completeness floor; covered list now ch01–ch05). Green: 17 lints +
  test_lints + ci-build-test (Release BUILD + 809 XCTest, 0 fail).
- ✅ **M3.3 — ch06–ch09 (16/16)** (cycle 2): **ch06 Physical/Chemical Changes:**
  `physical_vs_chemical` (two-column reversible/no-new-substance vs new-substance),
  `rust_formation` (iron+O₂+water→rust, rusty nail), `crystallization` (hot
  solution→crystals beaker), `balanced_equation` (2H₂+O₂→2H₂O with atom tally).
  **ch07 Weather/Climate/Adaptation:** `atmosphere_layers` (tropo→strato→meso→
  thermo bands), `monsoon_winds` (sea→land summer arrows over a peninsula),
  `polar_adapt` (polar-bear adaptations), `climate_zones` (latitude belts on a
  globe). **ch08 Winds/Storms/Cyclones:** `high_low_pressure` (H→L wind),
  `cyclone_spiral` (Archimedean spiral + eye), `coriolis` (deflected path on a
  spinning Earth), `thunderstorm` (cloud + up/downdraft + bolt + rain). **ch09
  Soil:** `soil_profile` (O/A/B/C/bedrock horizons), `soil_types` (sandy/clayey/
  loamy grain size), `erosion` (bare vs plant-held slope), `contour_terracing`
  (stepped terraces). Green: 17 lints + test_lints + ci-build-test (809 XCTest).
- ✅ **M3.4 — ch10–ch19 (40/40) — PHASE 3 COMPLETE** (cycle 2): **ch10
  Respiration:** lung_anatomy, alveolus (O₂ in/CO₂ out), mitochondrion (cristae),
  gas_exchange (respiration word-eq). **ch11 Transportation:** heart_4chambers,
  nephron, xylem_phloem, blood_cells. **ch12 Plant Reproduction:** flower_anatomy,
  pollen_tube, seed_dispersal, vegetative. **ch13 Motion & Time:** distance_time
  (Path-drawn graph, NOT Charts), pendulum (swing arc), clock_history, speed_compare
  (bar comparison). **ch14 Electricity:** simple_circuit, electromagnet, fuse_mcb,
  orsted. **ch15 Light:** reflection_law (i=r), prism (dispersion), lens_types
  (convex/concave + rays), periscope (45° mirrors). **ch16 Water:** water_cycle,
  aquifer (water table), drip_system, baori (stepwell). **ch17 Forests:**
  forest_layers, food_pyramid, nutrient_cycle, deforestation. **ch18 Wastewater:**
  wwtp_flow, sulabh_toilet (twin-pit), biogas_plant (dome digester), septic_tank
  (scum/liquid/sludge). **ch19 Solar System:** earth_tilt (23.5°→seasons),
  moon_phases (ring), solar_system (Sun + 8 planets), eclipse (solar/lunar align).
  +`testEveryPackDiagramKeyIsRegistered` (all 76 keys resolve → no placeholders).
  Green: 17 lints + test_lints + ci-build-test (Release BUILD + 810 XCTest, 0 fail).

> **ShapeDiagramRegistry: 76/76 keys registered — zero placeholder fallbacks.**

## Phase 4 — Reading-level + polish

- ⬜ Simplify over-band callouts flagged by `check_callout_reading_level.py`
  without losing accuracy.

## Phase 5 — Integrate / test / doc

- ⬜ Pin: every Sanskrit + SS chapter has a bespoke Discover experience;
  leak-gate mutual exclusivity; no unregistered ShapeDiagram keys for covered
  chapters; scene-count invariants. Write V7_DISCOVER_DEPTH_CHECKPOINT.md.
