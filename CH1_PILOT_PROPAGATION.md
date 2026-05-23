# Ch.1 Pilot — Propagation Playbook

The 2026-05-23 Ch.1 pilot shipped five net-new pedagogical surfaces
on Chapter 1 (Nutrition in Plants) only:

| # | Surface | What ships | Where it lives |
|---|---------|------------|----------------|
| 1 | **Inquiry-first mode** | Predict-before-reveal on concept cards | Settings toggle + ConceptDetailView gate |
| 2 | **BuildAPlantSandbox** | 4-slider live interactive (Liebig's-law-of-the-minimum) | `Subjects/Tutor/Surfaces/Ch1/` |
| 3 | **InsideTheLeafTour** | Five-stop SwiftUI walkthrough | `Subjects/Tutor/Surfaces/Ch1/` |
| 4 | **WhyChainView** | Three-layer Socratic drill | `Subjects/Tutor/Components/` (reusable) |
| 5 | **Ch1ConceptMap** | Node-and-edge SwiftUI graph | `Subjects/Tutor/Surfaces/Ch1/` |

Ch.2..19 are protected by `Ch2_19_StructuralRatchetTests`: any
content-array drift in those chapters fails CI immediately. Adding
pilot content for them is intentional and additive — the ratchet
fires only when a chapter's *fingerprint* (topic count, concept
count, question count, plus the 13 content-expansion-field counts)
drifts. Optional Ch.1-pilot fields (`predictQuestion`, `whyChain`,
`conceptMap`) are NOT in the fingerprint, so they can be authored
chapter-by-chapter without re-baselining the ratchet.

## Propagation cost — at-a-glance

| Surface | Per-chapter cost | Code edits needed? |
|---------|------------------|---------------------|
| Inquiry-first mode | ~20 min of content authoring | ❌ no |
| WhyChainView | ~50 min of content authoring | ❌ no |
| Concept map | ~30 min of content authoring | ❌ no |
| BuildAPlantSandbox | varies (per-chapter custom widget) | ✅ yes |
| InsideTheLeafTour | varies (per-chapter custom widget) | ✅ yes |

Total content-only propagation cost: **~12–15 hours across the 18
remaining chapters**, assuming a steady ~45-50 min per chapter for
the three content-only surfaces. Custom interactives (Sandbox + Tour)
are per-chapter judgement calls — not every chapter has manipulable
variables or microscopic structure worth touring; skip cleanly when
the chapter doesn't fit.

## Progress as of 2026-05-23 — propagation COMPLETE

| Chapter | Content propagated? | Round | Commit |
|---------|---------------------|-------|--------|
| Ch.1 Nutrition in Plants | ✅ pilot (all 5 surfaces incl. sandbox + tour) | 0 | `01617b6` |
| Ch.2 Nutrition in Animals | ✅ content-only | 1 | `6728f99` |
| Ch.3 Fibre to Fabric | ✅ content-only | 6 | `aac7c4f` (+`f34abe8` fix) |
| Ch.4 Heat | ✅ content-only | 5 | `ac3944b` |
| Ch.5 Acids, Bases, Salts | ✅ content-only | 6 | `aac7c4f` |
| Ch.6 Physical / Chemical Changes | ✅ content-only | 5 | `ac3944b` |
| Ch.7 Weather, Climate, Adaptations | ✅ content-only | 6 | `aac7c4f` |
| Ch.8 Winds, Storms, Cyclones | ✅ content-only | 6 | `aac7c4f` |
| Ch.9 Soil | ✅ content-only | 6 | `aac7c4f` |
| Ch.10 Respiration in Organisms | ✅ content-only | 1 | `6728f99` |
| Ch.11 Transportation in Animals & Plants | ✅ content-only | 2 | `b9fdfc4` |
| Ch.12 Reproduction in Plants | ✅ content-only | 6 | `aac7c4f` |
| Ch.13 Motion and Time | ✅ content-only | 3 | `ad6367c` |
| Ch.14 Electric Current and its Effect | ✅ content-only | 4 | (chXX) |
| Ch.15 Light | ✅ content-only | 3 | `ad6367c` |
| Ch.16 Water: A Precious Resource | ✅ content-only | 2 | `b9fdfc4` |
| Ch.17 Forest: Our Lifeline | ✅ content-only | 1 | `6728f99` |
| Ch.18 Wastewater Story | ✅ content-only | 6 | `aac7c4f` |
| Ch.19 Earth, Moon and the Sun | ✅ content-only (biggest — 23 concepts) | 7 | (this commit) |

**19 of 19 chapters complete.** Content-only propagation done. The
five Ch.1 pilot surfaces (predict-before-reveal, WhyChainView,
ConceptMap, BuildAPlantSandbox, InsideTheLeafTour) now have
content authored across the entire NCERT Class 7 Science syllabus.

Per-chapter custom interactives (Surface 2 BuildA{X}Sandbox / Surface
3 InsideThe{X}Tour) remain a per-chapter judgement call — not every
chapter has manipulable variables or microscopic structure worth
touring. These are deliberately NOT propagated wholesale; they ship
chapter by chapter as the right pattern emerges.

### Surface 2 / Surface 3 coverage (live)

| Chapter | Sandbox (S2) | Tour (S3) | Commit |
|---------|--------------|-----------|--------|
| Ch.1 Nutrition in Plants | ✅ BuildAPlantSandbox | ✅ InsideTheLeafTour | pilot `01617b6` |
| Ch.2 Nutrition in Animals | — | ✅ InsideTheDigestiveTour | `40e4a46` |
| Ch.4 Heat | ✅ BuildAHeatFlowSandbox | — | `599f0f8` |
| Ch.5 Acids, Bases, Salts | ✅ BuildAPHSandbox | — | `40e4a46` |
| Ch.6 Physical/Chemical Changes | ✅ BuildAReactionSandbox | — | `599f0f8` |
| Ch.7 Weather + Climate | ✅ BuildAClimateSandbox | — | `599f0f8` |
| Ch.8 Winds, Storms, Cyclones | ✅ BuildAWindSandbox | — | `4373a9f` |
| Ch.9 Soil | ✅ BuildASoilSandbox | — | `40e4a46` |
| Ch.10 Respiration in Organisms | — | ✅ InsideTheAlveolusTour | `4373a9f` |
| Ch.11 Transportation A&P | — | ✅ InsideTheXylemAscentTour | `4373a9f` |
| Ch.13 Motion and Time | ✅ BuildAMotionSandbox | — | `4373a9f` |
| Ch.14 Electric Current | — | ✅ InsideTheWireTour | `599f0f8` |
| Ch.15 Light | — | ✅ InsideTheLensTour | `599f0f8` |
| Ch.16 Water: A Precious Resource | ✅ BuildAWaterCycleSandbox | — | `40e4a46` |
| Ch.3, Ch.12, Ch.17, Ch.18, Ch.19 | — | — | not yet — see below |

**14 of 19 chapters carry a custom interactive** (9 sandboxes +
6 tours; Ch.1 has both). Total: 15 custom interactives across the
syllabus.

### Why some chapters don't have an interactive yet

These 5 chapters were deliberately skipped this round — each is
a per-chapter judgement call:

- **Ch.3 Fibre to Fabric** — no honest slider model (you can't
  meaningfully slider "cotton vs wool"), and there's no
  microscopic structure worth touring (a fibre cross-section is
  one stop, not five). Skip.
- **Ch.12 Reproduction in Plants** — the life-cycle is already
  linear in the chapter text; a tour would duplicate content
  rather than reveal hidden structure. Skip.
- **Ch.17 Forest: Our Lifeline** — the variables that matter
  (rainfall, biodiversity, deforestation rate) overlap with Ch.16
  BuildAWaterCycleSandbox enough that a separate forest sandbox
  would add little. Defer.
- **Ch.18 Wastewater Story** — a WWTP sandbox (flow rate × stage
  count → cleanliness) would model the right thing but feels
  contrived compared to a tour. Plausible future work.
- **Ch.19 Solar System** — almost entirely static geometric
  content. A Build-a-Planet sandbox (mass × distance → orbit) is
  out of NCERT Class 7 scope; an Inside-a-Star tour would need
  scenes the kid isn't ready for. Skip.

### Cross-chapter network — final shape

After Ch.19 lands, the concept map graph spans all 19 chapters with
the following clusters and bridges:

**Bio cluster** (ch01, ch02, ch10, ch11, ch12, ch17):
- ch01 ↔ ch02 (photosynthesis ↔ nutrition opposite)
- ch01 ↔ ch10 (photosynthesis ↔ respiration reverse)
- ch10 ↔ ch11 (haemoglobin ↔ heart transports O₂)
- ch11 → ch01 (transpiration via stomata)
- ch17 → ch01 (forests = mass photosynthesis)
- ch12 → ch01 (parasitic plants exploit reproductive system)
- ch02 → ch10 (cells use nutrients ← fuelled by respiration)

**Env cluster** (ch07, ch09, ch16, ch17, ch18):
- ch17 ↔ ch16 (forests ↔ water cycle)
- ch09 ↔ ch17 (soil-forest cycle)
- ch16 ↔ ch01 (stomata transpire into water cycle)
- ch07 → ch04 (climate change is heat phenomenon)
- ch07 → ch17 (forests preserve adaptation habitats)
- ch18 → ch16 (WWTPs preserve water resources)
- ch09 → ch01 (crop rotation refills nitrogen)

**Physics cluster** (ch04, ch08, ch13, ch14, ch15):
- ch13 ↔ ch14 (motion meets electric current)
- ch15 → ch04 (radiation is heat, both wave-physics)
- ch08 → ch04 (winds are convection, scaled up)
- ch06 ↔ ch04 (chemical change releases / absorbs heat)

**Chem cluster** (ch05, ch06):
- ch05 → ch01 (ocean acidification ↔ photosynthesis CO₂)
- ch06 → ch04 (chemical change is also heat change)
- ch06 → ch10 (respiration is biological combustion)

**Astro cluster** (ch19) — joins everything:
- ch19 → ch04 (uneven heating drives convection)
- ch19 → ch07 (axial tilt drives climate zones)
- ch19 → ch08 (Coriolis effect shapes cyclones)
- ch19 → ch16 (Moon's gravity moves oceans → tides)

This produces a single connected graph: from Solar System (ch19) you
can reach photosynthesis (ch01) via ch04 (Heat) → ch07 (Climate) →
ch17 (Forests) → ch01 in 4 hops. Pedagogically, this is the prize:
the kid never gets the impression that each chapter is an island.

## Recommended propagation order

1. **Ch.2 Nutrition in Animals** — easiest first jump because the
   "How animals eat" concept map echoes Ch.1's plant-side counterpart
   nicely, and the herbivore / carnivore distinction is a natural
   cross-chapter link.
2. **Ch.10 Respiration** — the concept map of Ch.10 already has the
   reverse-of-photosynthesis link baked into the Ch.1 map. Authoring
   Ch.10 second closes the loop and surfaces the reciprocal link in
   both directions.
3. **Ch.6 Physical and Chemical Changes** — high-leverage sandbox
   candidate. Sliders: temperature, concentration, surface area,
   catalyst. The pattern from BuildAPlantSandbox transfers almost
   directly.
4. **Ch.7 Weather, Climate and Adaptations** — natural sandbox too
   (4 sliders: latitude, altitude, season, humidity → climate
   classification).
5. **Ch.11 Transportation** — closes a Ch.1 cross-chapter link.
6. **Ch.17 Forests** — closes another Ch.1 cross-chapter link.
7. Remainder in chapter-order (3, 4, 5, 8, 9, 12, 13, 14, 15, 16, 18, 19).

## Per-surface authoring rules

### Surface 1 · Inquiry-first mode

For each concept, author a `predictQuestion`: one sentence ending
in `?`, designed to make the kid hypothesise BEFORE reading. The
test `testPredictQuestionEndsInQuestionMarkWhenPresent` enforces
the trailing question mark.

Good questions:
- Ask about a counter-intuitive consequence ("If chlorophyll absorbs
  red and blue, why does it look green?").
- Pose a thought experiment ("If you put the plant in the dark for
  two weeks, would it die, sleep, or stay the same?").
- Force a hypothesis before exposure ("Why is nitrogen the rate-
  limiting nutrient for almost all crops?").

Bad questions:
- Anything that can be answered by skimming the body text.
- Multi-clause questions.
- Anything that contains the answer ("Photosynthesis needs four
  things — what are they?").

No code edits needed. The Settings toggle + ConceptDetailView gate
already ship in ch.1 commit. Future chapters just author the field
and the gate picks them up automatically.

### Surface 2 · BuildAPlantSandbox-style interactives

These are PER-CHAPTER. Each chapter that benefits from a sandbox
needs its own SwiftUI view file. Pattern:

1. Create `Subjects/Tutor/Surfaces/Ch{N}/BuildA{X}Sandbox.swift`
   (replace `{X}` with the chapter's domain — for Ch.6 it'd be
   `BuildAReactionSandbox`, for Ch.7 `BuildAClimateSandbox`).
2. Identify the chapter's 3–5 manipulable variables.
3. Compute one or two derived outputs from them. Don't be afraid
   to encode a simplified-but-honest model.
4. Mount on the chapter detail page via a new
   `chXPilotInteractives` slot in
   `ChapterDetailView+Ch{N}Pilot.swift`.

Skip chapters where there's no honest manipulable model. The
sandbox should never feel arbitrary — that's worse than not
having one.

### Surface 3 · InsideTheLeafTour-style guided walks

Per-chapter. Each chapter with microscopic / hidden structure
benefits — Ch.10 (alveolus walkthrough), Ch.11 (xylem ascent),
Ch.14 (electron flow through a wire), Ch.15 (lens refraction
trip). Pattern:

1. Create `Subjects/Tutor/Surfaces/Ch{N}/InsideThe{X}Tour.swift`.
2. Define a `TourStop` enum with 4–6 cases (sweet spot: 5).
3. For each stop: a small SwiftUI scene (ZStack of Shapes), a
   narration body (3–5 sentences), and a Read-aloud button that
   routes through `SpeechReader.shared` with an `owner:` keyed to
   the tour.
4. Mount as a CTA card on the chapter detail page using the
   shared `Ch1PilotCTACard` visual.

Skip chapters whose content is fundamentally diagrammatic but
not "journey-shaped" (eg Ch.12 reproduction — the life-cycle is
already linear, no new value from a tour).

### Surface 4 · WhyChainView content

For each concept, author a `whyChain: [String]` of EXACTLY 3
entries, each between 40 and 100 words (test:
`testWhyChainShapeWhenPresent`). Layer 1 answers the immediate
"why?". Layer 2 goes one level deeper into mechanism / cause.
Layer 3 goes to consequence / edge case / Class 8–11 bridge.

Each layer should feel like *the next thing a curious kid would
ask*. Don't restate the body. Don't write three paragraphs that
all answer the same question at the same depth — each layer must
ratchet UP in causal depth.

No code edits needed.

### Surface 5 · Concept map content

For each chapter, author a `conceptMap`:

- 10–18 nodes, each at normalised (x, y) in 0..1.
- 15–25 edges with optional relation labels.
- Cross-chapter nodes use the id form `chXX:<concept_id>`. The
  schema test `testConceptMapNodesResolveWithinChapterOrTo-
  CrossChapterRef` enforces that those targets exist.

Layout tips:
- Put the chapter's most central concept at (0.5, 0.4) ish.
- Put cross-chapter pointers near the edges of the canvas.
- Spread nodes so the labels don't overlap at 1.0× zoom (the user
  can zoom and pan but the default view should be readable).
- Use relation labels ("needs", "produces", "is opposite of") on
  the most pedagogically-loaded edges; leave decorative edges
  unlabeled.

No code edits needed. `Ch1ConceptMap.swift` is the renderer
template — future chapters will likely promote it to a generic
`ConceptMapView` once Ch.2 and Ch.10 ship and confirm the pattern
holds.

## Mechanics — how the propagation tests work

`Ch2_19_StructuralRatchetTests.swift` locks per-chapter item counts.
A propagation commit adding `predictQuestion` / `whyChain` /
`conceptMap` to Ch.X is invisible to the ratchet — those Optional
fields aren't in the fingerprint.

But ADDING a new concept, NCERT QA, mnemonic etc. to a Ch.X would
trip the ratchet. That's intentional: structural changes deserve
explicit re-baselining (update the baseline dict to the new counts,
note the change in REMEDIATION_LOG). Don't disable the ratchet.

## When NOT to propagate

If a chapter genuinely lacks the kind of content a surface needs,
skip it. Example: BuildA{X}Sandbox doesn't fit Ch.12 (reproduction)
or Ch.17 (forests) — there's no honest set of sliders. That's fine.
The Ch.{N}PilotInteractives gate stays empty; the chapter detail
page renders without those CTAs.

Inquiry-first mode and WhyChainView, by contrast, fit every chapter
and should be propagated to all 18 remaining chapters.

## Definition of done — propagation complete

- `Ch2_19_StructuralRatchetTests` green.
- `testPredictQuestionEndsInQuestionMarkWhenPresent` green across
  all 19 chapters.
- `testWhyChainShapeWhenPresent` green across all 19 chapters.
- `testConceptMapNodesResolveWithinChapterOrToCrossChapterRef`
  green across all 19 chapters.
- Each chapter that warrants a sandbox / tour has one.
- The propagation has surfaced no shared-code leakage (the ratchet
  remains green throughout).

Estimated total propagation effort: **12–15 hours across 18
chapters** if a single author works through them sequentially with
the playbook in hand. Faster with parallelisation (the content-only
surfaces can be authored by separate writers in parallel since they
touch different fields).
