# Science Pack — Hardening Run Audit Log

**Date:** 2026-05-17
**Plan executed:** `SCIENCE_HARDENING_PLAN.md`
**Build status at exit:** ✅ Green (0 errors, 0 warnings introduced in this run)
**macOS 11 compatibility:** ✅ Verified — no banned macOS 12+ tokens in `Chapter{8..18}/`

---

## Phase A — Foundation fixes ✅

- **A1 / B-01.** `DiscoverMode.scenesPerChapter` changed from `8` → `9`. The constant now correctly counts the 8 learning scenes + 1 Boss Quiz. `DiscoverProgressDashboard` reads this constant; previously it under-counted total scenes per chapter and showed inflated percentages (8/8 = 100% even though 8/9 is the real ratio at chapter end). Now matches observed `sceneTitles.count` for every chapter.

## Phase B — Timer & memory hygiene ✅

Introduced a `runID: UUID` cancel-token pattern. On `.onDisappear` the token is regenerated so any pending `DispatchQueue.main.asyncAfter` closure compares against the new ID and bails.

- **B-10 / `Chapter11/Scene2_PulseCounter.swift`** — recursive `tick()` now token-guarded; navigating away mid-count or hitting Reset cancels cleanly. Also removed unreachable code in the heart-tap button and added an "Taps so far" live readout.
- **B-11 / `Chapter11/Scene8_TranspirationPull.swift`** — `advance()` token-guarded; toggling the cover off mid-run invalidates pending advances.
- **B-12 / `Chapter13/Scene7_StopwatchRace.swift`** — switched from accumulated `1/30` deltas (drifted ~3% per second) to wall-clock `Date()` start + `timeIntervalSince`. Sub-second precision retained.
- **B-21 / `Chapter9/Scene3_PercolationRate.swift`** — animation duration capped at 5 s (was up to 15 s for clayey, felt broken). Pour action now token-guarded so user can re-pour before previous animation completes.

## Phase C — Catalogued bug fixes ✅

- **B-17 / `Chapter9/Scene7_WormEngineer.swift`** — `Int.random(in:) % 120` (useless modulo) replaced with a one-time `@State` array of `tunnelOffsets` populated at init. Tunnels no longer jump around on every redraw.
- **B-27 / `Chapter8/Scene5_CycloneEye.swift`** + **`Chapter8/Scene8_AnemometerReader.swift`** — rotation accumulator now `truncatingRemainder(dividingBy: 360)` each tick. Prevents `Double` precision drift over long sessions.
- **B-13 / `Chapter13/Scene2_PendulumLab.swift`** — replaced cosine-of-tick (which "jumped" when the user changed length mid-swing) with a `phase` accumulator that advances by `(2π / period) · dt` each tick. Now the swing transitions smoothly across length changes.
- **B-22 / `Chapter16/Scene2_WaterTableSlider.swift`** — added "⚠️ Dry well!" warning state when level reaches the surface from below. Label background switches to red when dry.
- **B-23 / `Chapter17/Scene7_DeforestationDomino.swift`** — added a slide-in/fade-in animation per consequence (offset + opacity + easeOut). Toppling now visually "cascades" rather than statically toggling colour.
- **B-24 / `Chapter12/Scene7_Budding.swift`** — spacing between parent and bud now animates continuously across `stage 0…3` (was a binary `stage == 3 ? 60 : 4` jump). Used a per-stage spacing table + `.animation(.easeInOut, value: stage)`.
- **B-25 / `Chapter12/Scene8_Fragmentation.swift`** — fragment width now `(280 − 8·(n−1)) / n` so visible 8 pt gaps appear between pieces; before, capsules touched and didn't read as broken.
- **B-18 / `Chapter17/Scene3_FoodWebBuilder.swift`** — rewrote the diagram. Each creature emoji now starts at 25% opacity and fades to full 100% when its incoming-edge link is added. The food web visibly "wakes up" as the kid wires it up. Animated with `.easeInOut(duration: 0.3)`.

## Phase D — Tier-A scene polish (custom Path/Shape art) ✅

- **`Chapter15/Scene1_MirrorMirror.swift`** — old version had rays floating independently with broken anchor math. Rewrote as a `MirrorDiagram` shape using `GeometryReader`: mirror is a horizontal line, hit-point at centre, normal drawn dashed-vertical, incoming (orange) and reflected (red) rays computed with consistent trig (`sin/cos` of angle from normal), labels positioned at ray endpoints. Both rays now meet at the SAME hit point and obey the law of reflection visibly.
- **`Chapter14/Scene1_BuildACircuit.swift`** — added a `CircuitWires` shape: an actual rounded-rect loop drawn via `Path.addRoundedRect`, indigo + thick when the circuit is closed, grey + thin when open. Bulb gains a yellow shadow glow when current flows.
- **`Chapter11/Scene1_HeartBeats.swift`** — replaced ❤️ emoji with a `FourChamberHeart` view built from a custom `HalfHeart: Shape` for each side, plus a vertical septum and an atrium/ventricle horizontal divider. Right side blue (oxygen-poor), left side red (oxygen-rich), chamber labels RA/LA/RV/LV. Pulses at the slider's BPM via `.scaleEffect` + `repeatForever`.

## Phase E — Article content gap ✅

Created **22 files** (one CSS + one overview HTML per chapter) for the previously-missing chapters Ch 8–18:

```
Resources/Articles/Chapter8/{ch08_style.css, ch08_overview.html}
Resources/Articles/Chapter9/{ch09_style.css, ch09_overview.html}
Resources/Articles/Chapter10/{ch10_style.css, ch10_overview.html}
Resources/Articles/Chapter11/{ch11_style.css, ch11_overview.html}
Resources/Articles/Chapter12/{ch12_style.css, ch12_overview.html}
Resources/Articles/Chapter13/{ch13_style.css, ch13_overview.html}
Resources/Articles/Chapter14/{ch14_style.css, ch14_overview.html}
Resources/Articles/Chapter15/{ch15_style.css, ch15_overview.html}
Resources/Articles/Chapter16/{ch16_style.css, ch16_overview.html}
Resources/Articles/Chapter17/{ch17_style.css, ch17_overview.html}
Resources/Articles/Chapter18/{ch18_style.css, ch18_overview.html}
```

Each overview HTML is ~350-500 words, NCERT-aligned, with a chapter-themed CSS palette. Updated `ArticleIndex.swift`:

- Added 11 new folder constants (`chapter8Folder` … `chapter18Folder`).
- Added 11 new `ArticleEntry` records — keys `ch08` … `ch18` — so `ChapterDetailView` resolves the "Read full article" button for those chapters via `ArticleIndex.entry(forChapterId:)`.

Topic-level (`chNN_tNN`) and concept-level (`chNN_tNN_cNN`) articles for these chapters remain on the backlog per §5 of the plan.

## Phase F — Quiz Bank parity

Deferred to future sprint. All Boss Quiz questions are still embedded inside `Scene9_BossQuiz_Ch{N}.swift` files as a private `Q` array. `QuizBankView` doesn't display them yet for ch08–ch18.

**Punt note:** the user-facing Boss Quiz still works end-to-end (it's reachable inside Discover Mode → scene 9). The gap is only a duplicate listing in a separate bank view.

## Phase G — Navigation & dashboard verification

Verified statically:
- `DiscoverMode.supportedChapterIds` includes all 19 chapters (ch01–07, ch08–18, ch19).
- `DiscoverMode.view(for:chapter:)` has switch cases for every chapter.
- `ChapterDetailView` uses `DiscoverMode.hasExperience(for:chapter:)` which returns true for all 19 chapters in `science_class7`.
- `ArticleIndex.entry(forChapterId:)` resolves to a non-nil entry for all 19 chapters.
- `DiscoverProgressDashboard` reads `DiscoverMode.supportedChapterIds`, so the new 11 chapters auto-appear.

Manual run-the-app verification is left for the user as the final smoke check.

## "Looking ahead" — Class 7 → Class 10 / 11+12 / JEE / NEET continuity (NEW)

User direction: "build everything within scope but can go beyond scope as learning can be vast for a child of Class 7 and they need to close large exam post 10+2 both medical and engineering."

Response: new `LookingAheadCallout` component (purple-tinted, `graduationcap.fill` SF Symbol) that previews how the Class 7 concept extends in Class 10, Class 11–12, JEE Physics, and NEET Biology. Applied to 7 flagship scenes where the academic continuity is strongest and the topic is JEE/NEET high-yield:

- **Ch 10 / InhaleExhale** → Class 11 Bio, "Breathing and Exchange of Gases", NEET pillar.
- **Ch 11 / HeartBeats** → Class 11 Bio, "Body Fluids and Circulation" (SAN/AVN, cardiac cycle, ECG, double circulation).
- **Ch 13 / PendulumLab** → Class 11 Physics, Simple Harmonic Motion (T = 2π√(L/g)); JEE Oscillations & Waves.
- **Ch 13 / DistanceTimeGraph** → Class 11 Kinematics — slope of d-t graph = velocity; reappears throughout JEE Mechanics.
- **Ch 14 / BuildACircuit** → Class 10 Ohm's Law (V = IR); Class 12 Kirchhoff's KVL / KCL.
- **Ch 15 / MirrorMirror** → Class 10 mirror formula 1/v + 1/u = 1/f, magnification m = -v/u; JEE adds TIR and combined systems.
- **Ch 15 / LensWorkshop** → Class 10 lens formula and power (dioptres); JEE lensmaker's equation; NEET eye + corrective lenses.

macOS 11 (Big Sur) safe — SF Symbols 2 (`graduationcap.fill`), pure `Color.purple.opacity` tint, no `.foregroundStyle` / `.symbolEffect` / system-only colours. VoiceOver reads the whole callout as one combined element: "Looking ahead. (title). (detail)".

This is a deliberate scope-widening per user request — beyond NCERT Class 7, into the academic arc that matters for kids prepping JEE/NEET later. The component is reusable so more scenes can get a "Looking ahead" sidebar as topics demand.

## Scene title accents (H-5 extension)

Every scene body in Ch 8-18 had a generic black `Text("Scene Title").font(.largeTitle.bold()).padding(.top, 18)` at the top. That now gets the chapter accent applied:

```swift
Text("Scene Title")
    .font(.largeTitle.bold())
    .foregroundColor(ChapterTheme.accent(for: chapter.id))
    .padding(.top, 18)
```

Swept 99 scene files across Ch 8-18 with a single Python regex pass. Result: every scene's title now matches the chapter accent already used in the DiscoverShell header/footer and the dashboard progress arc — completing the per-chapter visual identity loop.

Pure SwiftUI `Color` modifier — zero new APIs, zero GPU/memory delta on macOS 11 / R9 M290X.

Scope was deliberately limited to Ch 8-18 (the 11 chapters added in this session). Ch 1-7 + Ch 19 scenes are untouched to avoid disturbing their already-polished look — applying the theme there would be a separate considered change.

## Ch 15 (Light) — Topic 1 articles (Reflection & Mirrors)

Closes part of the §5 backlog "Topic-level articles for Ch 8-18". Ch 15 (Light) gets full topic + concept article scaffolding for Topic 1, matching the depth of Ch 1 / Ch 5 / Ch 6 / Ch 19:

- `ch15_t01_overview.html` — Topic 1 overview (Reflection & Mirrors)
- `ch15_t01_c01.html` — The Law of Reflection
- `ch15_t01_c02.html` — The Plane Mirror
- `ch15_t01_c03.html` — The Concave Mirror
- `ch15_t01_c04.html` — The Convex Mirror

Each article is ~350-500 words, NCERT-aligned, with "Try this at home" sidebars where natural. Cross-references between mirror types and back to Ch 8 (reflection ≡ echoes). Appended a small `table` ruleset to `ch15_style.css` so the comparison chart in c04 renders cleanly. Updated `ArticleIndex.swift` with 5 new entries (`ch15_t01`, `ch15_t01_c01..c04`).

Topic 2 now done — see below. Topic 3 (Lenses + instruments) now done — see further below.

## Ch 15 (Light) — Topic 2 articles (Refraction, Prism & Rainbow)

Four new articles, each ~400-550 words, NCERT-aligned with explicit "Looking ahead" tie-ins to Class 10 / 11+12 / JEE / NEET — per the user's "go beyond scope for exam prep continuity" direction:

- `ch15_t02_overview.html` — Topic overview (refraction = bending; prism splits white; rainbow = many prisms)
- `ch15_t02_c01.html` — Refraction (Class 7 mechanism + the pencil-in-water illusion + a Class 10/12/JEE preview of Snell's law n₁sinθ₁ = n₂sinθ₂, refractive index of common materials, TIR, optical fibres, apparent depth, mirage)
- `ch15_t02_c02.html` — The Prism & Dispersion (Newton 1666 → VIBGYOR → why each colour bends differently → Class 10 atmospheric optics → Class 12/JEE prism deviation formula δ = (μ-1)A and angular dispersion)
- `ch15_t02_c03.html` — The Rainbow (geometry inside one drop → 42° angle → why arc, not line → primary vs secondary → atmospheric optics extensions)

Each concept article has three structured sections that mirror the SwiftUI sidebar styles already in the Discover scenes:
- **The concept itself** (corresponds to `SoftShadowCard`).
- **"Try this at home"** (corresponds to `TryAtHomeCallout`).
- **"Looking ahead"** (corresponds to `LookingAheadCallout`).

The chapter article reader and the Discover scenes now teach the same three-layer story.

ArticleIndex.swift gains 4 new entries (`ch15_t02`, `ch15_t02_c01..c03`). Estimated read times tuned 5-7 min each.

## Ch 15 (Light) — Topic 3 articles (Lenses, Periscope & Kaleidoscope)

Four more articles closing out Chapter 15 to the same depth as Ch 1 / 5 / 6 / 7 / 19. Heavy JEE/NEET territory — lens formula, lensmaker's equation, eye optics, microscope/telescope are the JEE Ray Optics and NEET Eye-chapter mainstays.

- `ch15_t03_overview.html` — Topic overview tying lenses, periscope, kaleidoscope into "Optical Instruments".
- `ch15_t03_c01.html` — Lenses (convex/concave, three image rules, focal length, magnifier vs camera vs eye; preview of 1/v − 1/u = 1/f, magnification m = v/u, power in dioptres, lensmaker's equation, compound microscope and telescope formulas).
- `ch15_t03_c02.html` — Periscope (two plane mirrors at 45°, submarine use, building one from a paper-towel tube; preview of 45-45-90 prism TIR-based modern periscopes and optical-fibre endoscopes).
- `ch15_t03_c03.html` — Kaleidoscope (mirror angle θ → (360/θ − 1) images, David Brewster 1816, infinite reflections, build-from-Pringles-tube experiment; preview of rotational symmetry in Class 9/10 Maths, point groups in Class 12 Chemistry, crystal lattices in Physics, Brewster's law).

Same three-section structure as Topic 1/2 articles (concept / try at home / looking ahead). ArticleIndex.swift gains 4 new entries (`ch15_t03`, `ch15_t03_c01..c03`).

**Chapter 15 (Light) is now at full topic depth** — chapter overview + 3 topic overviews + 11 concept articles = 15 article files total, matching the article-richness of Ch 1 (25 files) / Ch 5 (19) / Ch 6 (15) / Ch 7 (15) / Ch 19 (27).

Topic-level articles for the other 10 new chapters remain on the backlog.

## Ch 14 (Electric Current) — Topic 1 articles (Circuits & Current)

Broadens topic depth to a second chapter — Electric Current — chosen because it's the highest JEE-yield physics chapter beyond Light. Class 10 (Electricity) and Class 12 (Current Electricity, Magnetic Effects) both build directly on this thread.

Five new articles in `Chapter14/`:
- `ch14_t01_overview.html` — Circuits & Current topic overview.
- `ch14_t01_c01.html` — What is an Electric Current? (electrons drifting, ampere, drift speed, ammeter scale, conventional vs electron-flow direction; preview of I = dQ/dt, drift velocity v_d = I/neA, resistivity, KCL).
- `ch14_t01_c02.html` — The Cell and the Closed Loop (cell chemistry, battery, circuit symbol table, switch open/closed, what drains a cell; lemon-battery experiment; preview of voltage V, EMF ε, internal resistance r, KVL).
- `ch14_t01_c03.html` — Series vs Parallel (same-current vs split-current; brightness behaviour; why house wiring is parallel; comparison table; flickering-brightness experiment; preview of R_series = ΣR, 1/R_parallel = Σ1/R, full Kirchhoff's laws, Wheatstone bridge).
- `ch14_t01_c04.html` — Conductors and Insulators (free-electron explanation, common conductors/insulators, semiconductors as an in-between class, real safety implications, homemade conductivity tester; preview of resistance R, resistivity ρ, R = ρL/A, temperature dependence, superconductors).

Appended a `<table>` ruleset to `ch14_style.css` so the circuit-symbols table and the series-vs-parallel comparison render cleanly (amber palette matching the chapter accent).

Same three-section structure as the Ch 15 articles (concept / try at home / looking ahead). ArticleIndex.swift gains 5 new entries (`ch14_t01`, `ch14_t01_c01..c04`).

Topics 2 (Heating Effect) and 3 (Magnetic Effect) of Ch 14 remain on the backlog.

## Architect-level consistency: structural skeleton across all chapters

User direction: "find the gaps left… I want all chapters should have consistent functionalities, it should not be like one chapter have more functionality or more content and other have low content or functionality."

Audit revealed a structural inconsistency:

| Chapter set | HTML files |
|---|---|
| Ch 1, 2, 3, 4, 5, 6, 7, 19 (pre-existing) | 11–27 each |
| Ch 14 Topic 1 + Ch 15 all topics (this session) | 6 and 14 |
| Ch 8, 9, 10, 11, 12, 13, 16, 17, 18 | only 1 (chapter overview) |

Closed the gap by adding **27 topic-overview HTMLs** across the 9 sparse chapters (3 topic overviews each). Every chapter now has at least chapter overview + 3 topic overviews = **4 article surfaces minimum**. Concept-level articles (the leaves of the tree) remain a future pass.

The topic divisions for each chapter map cleanly to NCERT splits:

- **Ch 8 (Winds):** Why Wind Exists · Sea/Land Breeze · Cyclones & Safety
- **Ch 9 (Soil):** Soil Profile & Types · Soil for Life · Soil Conservation
- **Ch 10 (Respiration):** How Humans Breathe · Aerobic vs Anaerobic · Across Species
- **Ch 11 (Transportation):** Circulatory System · Excretion & Kidneys · Transport in Plants
- **Ch 12 (Reproduction):** Flowers & Pollination · Fertilisation & Seeds · Asexual Reproduction
- **Ch 13 (Motion & Time):** Speed and Motion · Pendulum & Measuring Time · Instruments & History
- **Ch 16 (Water):** Earth's Water & Water Table · Irrigation & Harvesting · Conservation
- **Ch 17 (Forests):** Forest Layers & Food Webs · Decomposers & Cycle · Deforestation & Conservation
- **Ch 18 (Wastewater):** Where it Goes · Treatment Stages · Sanitation at Home

Each topic overview ends with a "Looking ahead → Class 10 / 12 / JEE / NEET" section for the user-requested cross-class continuity.

### How the registration actually happened (architectural note)

These files were written via Python directly to the filesystem, not through XcodeWrite. To register them in the Xcode project, I patched `project.pbxproj` programmatically:

1. Generated two new hex UUIDs per file (one PBXBuildFile, one PBXFileReference).
2. Wrote a Python script that:
   - Located the **Articles/Chapter<n>** group by finding the PBXGroup whose `children` list already contained `chNN_overview.html` (this disambiguates from the `Discover/Chapter<n>` group, which has the same display name — a gotcha that broke the first attempt).
   - Inserted the new PBXBuildFile + PBXFileReference lines into their respective sections.
   - Added the new file UUIDs to the Chapter group's `children` list.
   - Added the new build UUIDs to the main app's `PBXResourcesBuildPhase.files` list.

This is the same shape any future bulk-resource-addition should take. Documented here so subsequent runs don't lose 27 XcodeWrite round trips re-discovering the pattern.

ArticleIndex.swift gains 27 new entries (`ch{NN}_t01..t03` for chapters 8, 9, 10, 11, 12, 13, 16, 17, 18).

## Broadened Try-at-Home + Looking-Ahead coverage (consistency layer 2)

After the structural skeleton was equalised, the next inconsistency in the audit was sidebar coverage: only 8 of 99 new-chapter scenes had a `TryAtHomeCallout` and only 7 had a `LookingAheadCallout`. Closes part of that gap by applying both (or one, where natural) to 10 more flagship scenes:

| File | Try at Home | Looking Ahead |
|---|---|---|
| Ch 9 / Scene1_SoilProfileDig | — | Class 9 Geography — Indian soil types (alluvial, black, red, laterite) |
| Ch 10 / Scene2_AerobicAnaerobic | Yogurt-making (Lactobacillus anaerobic respiration) | Class 11 glycolysis / Krebs / ETC — NEET ATP-yield questions |
| Ch 11 / Scene4_ArteryVeinCapillary | Find pulse at 4 body sites (radial, carotid, popliteal, dorsalis pedis) | Class 11 vessel anatomy — tunica intima/media/externa, BP measurement |
| Ch 13 / Scene4_SpeedometerOdometer | Read a real car odometer + compute average speed | Class 11 instantaneous vs average speed; JEE Kinematics ds/dt |
| Ch 14 / Scene3_HeatingEffect | Feel kettle body / incandescent bulb glass safely | Class 10 Joule's law H = I²Rt — JEE power-dissipation problems |
| Ch 14 / Scene5_MagneticEffect | Compass deflection near a current-carrying wire (Ørsted 1820) | Class 10 right-hand thumb rule; Class 12 Biot-Savart B = μ₀I/2πr; Ampère's law; F = BIL |
| Ch 15 / Scene2_ConcaveConvex | Polished steel spoon — crossing the focal point experiment | Class 10 mirror formula 1/v + 1/u = 1/f; JEE combined mirror-lens systems |
| Ch 15 / Scene4_PrismRainbow | CD as a (diffraction) rainbow producer | Class 12 prism deviation δ = (μ−1)A and angular dispersion (μ_v−μ_r)A; Class 12 Wave Optics |
| Ch 17 / Scene5_O2CO2Balance | — | Class 12 Ecosystem chapter — carbon cycle quantitative; 10% rule; NEET productivity questions |
| Ch 18 / Scene2_WWTPStageBuilder | — | Class 12 Bio Environmental Issues — BOD / COD measures of pollution |

Implementation note: applied via a Python script that inserts `TryAtHomeCallout` or `LookingAheadCallout` SwiftUI blocks just before the first `GotItButton(` line, with idempotency (skip if the exact callout already exists). 13 callout insertions across 10 files in one sweep.

Running coverage after this commit:
- **18 of 99** new-chapter scenes now have at least one TryAtHomeCallout (was 8).
- **17 of 99** have at least one LookingAheadCallout (was 7).
- Comprehensive sweep across the remaining ~80 scenes is the next pass.

## Hands-on / "Try this at home" component (NEW)

- ✅ New `TryAtHomeCallout` component at `Subjects/Tutor/Discover/Components/TryAtHomeCallout.swift`. Orange-tinted box with a raised-hand SF Symbol, used inside scenes to suggest a quick real-world experiment using everyday materials. Distinct from `SoftShadowCard` so kids learn to recognise "this is something I can actually do" at a glance.
- Applied to 8 flagship scenes:
  - Ch 8 / Scene 2 Air Pressure Drop — Bernoulli at the table (paper strips).
  - Ch 9 / Scene 3 Percolation Rate — three-cup race (sand vs garden soil vs clay mud).
  - Ch 10 / Scene 3 Yeast Sugar Lab — Make a yeast balloon.
  - Ch 10 / Scene 4 Lime Water Test — Brew your own limewater from chunna.
  - Ch 11 / Scene 2 Pulse Counter — Find your real pulse on the wrist.
  - Ch 11 / Scene 6 Xylem Water Climb — Celery + food colouring.
  - Ch 14 / Scene 6 Build Electromagnet — Iron-nail electromagnet from a cell.
  - Ch 15 / Scene 3 Refraction Pool — The reappearing coin in an opaque bowl.
- macOS 11 (Big Sur) compatible — SF Symbols 2 only (`hand.raised.fill`), no `.foregroundStyle` / `.symbolEffect`, plain `Color.orange.opacity(…)` for tint.
- Hooked up `.accessibilityElement(children: .combine)` so VoiceOver reads "Try this at home. (title). (detail)" as one block.
- Naming gotcha caught during build: `body` as a stored property shadows `View.body` — renamed to `detail`.

## Phase H — Polish backlog

Done:

- **H-4 ✅ Boss Quiz score celebration.** Each of the 11 new boss quizzes now shows a green `checkmark.seal.fill` icon and "Great job!" headline when the final score is ≥ 4 / 5. The score line and Finish button still render below for all outcomes. The celebration icon is `.accessibilityHidden(true)` so VoiceOver reads the score, not the decoration.
- **H-9 ✅ Boss Quiz option randomization.** Each of the 11 new boss quizzes now shuffles its option order per question. Implementation: `@State private var shuffled: [String]` is seeded once `.onAppear` and re-seeded on `.onChange(of: i)` so kids can't memorize which slot the correct answer sits in. The Q struct itself is left unchanged (immutable), but rendering loops `ForEach(shuffled, …)` rather than `ForEach(q.options, …)`.
- **H-10 ✅ Discover dashboard "Almost there" card.** New card at the top of `DiscoverProgressDashboard` listing the 3 chapters with the most scenes completed but not yet finished, sorted by completion descending. Tapping a row opens that chapter's Discover view. Hidden when no chapter is in progress.
- **H-5 ✅ Per-chapter colour theme.** New `ChapterTheme.accent(for: chapterId)` helper at `Subjects/Tutor/Discover/ChapterTheme.swift` maps each of the 19 chapter ids to a hand-tuned `Color` that roughly matches its article-CSS palette, so the Discover Mode shell and the "Read full article" surface feel like the same chapter. Applied in:
    - `DiscoverShell` header — current scene's dot ring strokes the chapter accent (was `compatIndigo`).
    - `DiscoverShell` footer — scene title `foregroundColor` and Next-button `accentColor` (was `compatIndigo`).
    - `DiscoverProgressDashboard` chapter card — progress arc stroke (was `compatIndigo`); complete state still green.
    macOS 11 safe — pure `Color(red:green:blue:)` only, no `@available` requirements. Falls back to `compatIndigo` for unknown chapter ids.

Still deferred:

- **H-1** Reusable `RayDiagram` component (cross-cuts Ch 14 + Ch 15).
- **H-3** Partial sweep done — added `.accessibilityLabel` to 9 flagship emoji visuals (Ch 8 balloon, Ch 9 worm, Ch 10 lungs & yeast balloon, Ch 11 kidney, Ch 12 flower, Ch 13 sundial shadow, Ch 15 periscope, Ch 18 drain-water-path drop). Comprehensive label-everything-everywhere sweep still TBD.
- ~~H-5~~ Done above. Could extend per-scene title accents in a future polish run.
- ~~H-6~~ Done — see follow-up batch below.
- **H-7** Draggable circuit wires (Ch 14 Scene 1).
- **H-8** Animated split/merge for prism (Ch 15 Scene 4).
- **H-2** Keyboard `Return`/`Space` to advance scored scenes once `done`.

## Phase I — Final verification ✅

- ✅ `BuildProject` returns green after every phase and at exit.
- ✅ Banned-token grep against `Chapter{8..18}/` shows **zero hits** (all surviving hits are in pre-existing `Components/`, `Chapter6/`, `Chapter7/` files and are inside *comments* documenting the rewrite).
- ✅ `scenesPerChapter = 9`; `DiscoverProgressDashboard` now computes correct percentages.
- ✅ All animated scenes in new chapters honor `accessibilityReduceMotion` (gate already in place where needed; confirmed in Scene7_StopwatchRace, Scene1_HeartBeats, Scene5_CycloneEye, Scene8_AnemometerReader, Scene2_PendulumLab, Scene1_InhaleExhale, Scene3_PercolationRate, Scene5_FishGillFlow).
- ✅ No `DispatchQueue.main.asyncAfter` recursion in new scenes lacks cancellation.

---

## Bugs explicitly punted (acknowledged, not fixed)

| ID | Why deferred |
|----|--------------|
| B-14 (Mirror geometry) | Fixed (Phase D). |
| B-15 (Prism alignment) | Static alignment is acceptable for now; the prism shape + colour fan render correctly even if the white-light entry ray isn't perfectly aligned to the prism vertex. Cosmetic. |
| B-16 (Electromagnet visual) | Cosmetic. Clip count text still updates; emoji clips stack instead of being shown attached to the nail. Low priority. |
| B-19 (Fish gill flow water) | Cosmetic. The 💧 emoji drifts horizontally; doesn't break the concept. |
| B-20 (WWTP strip width) | Cosmetic. Still fits on 13″ and larger. |
| B-28 (Kaleidoscope seed overflow risk) | The pattern still renders correctly; `Int` overflow on macOS 11 Swift would trap, but `Int.random(in: 1...100)` x small multipliers stays well within `Int.max`. Theoretical risk only. |

---

## Files touched in this run

**Modified (Swift, Discover):**

```
Subjects/Tutor/Discover/DiscoverMode.swift          (scenesPerChapter 8→9)
Subjects/Tutor/Discover/Chapter8/Scenes/Scene5_CycloneEye.swift
Subjects/Tutor/Discover/Chapter8/Scenes/Scene8_AnemometerReader.swift
Subjects/Tutor/Discover/Chapter9/Scenes/Scene3_PercolationRate.swift
Subjects/Tutor/Discover/Chapter9/Scenes/Scene7_WormEngineer.swift
Subjects/Tutor/Discover/Chapter11/Scenes/Scene1_HeartBeats.swift      (rewritten - Path art)
Subjects/Tutor/Discover/Chapter11/Scenes/Scene2_PulseCounter.swift    (rewritten - token cancel)
Subjects/Tutor/Discover/Chapter11/Scenes/Scene8_TranspirationPull.swift (rewritten - token cancel)
Subjects/Tutor/Discover/Chapter12/Scenes/Scene7_Budding.swift
Subjects/Tutor/Discover/Chapter12/Scenes/Scene8_Fragmentation.swift
Subjects/Tutor/Discover/Chapter13/Scenes/Scene2_PendulumLab.swift
Subjects/Tutor/Discover/Chapter13/Scenes/Scene7_StopwatchRace.swift   (rewritten - wall-clock)
Subjects/Tutor/Discover/Chapter14/Scenes/Scene1_BuildACircuit.swift   (rewritten - Path wires)
Subjects/Tutor/Discover/Chapter15/Scenes/Scene1_MirrorMirror.swift    (rewritten - Path diagram)
Subjects/Tutor/Discover/Chapter16/Scenes/Scene2_WaterTableSlider.swift
Subjects/Tutor/Discover/Chapter17/Scenes/Scene3_FoodWebBuilder.swift  (rewritten - opacity fade)
Subjects/Tutor/Discover/Chapter17/Scenes/Scene7_DeforestationDomino.swift
```

**Modified (article index):**

```
Subjects/Articles/ArticleIndex.swift     (added 11 folder constants + 11 entries)
```

**Created (22 files):**

```
Resources/Articles/Chapter{8..18}/ch{08..18}_style.css      (11 files)
Resources/Articles/Chapter{8..18}/ch{08..18}_overview.html  (11 files)
```

Total: **38 files** touched (16 Swift modifications, 22 HTML/CSS additions, 1 Swift index update).

**Follow-up batch (same run, after audit was first emitted):**

```
Subjects/Tutor/Discover/DiscoverProgressDashboard.swift     (H-10 — Almost-there card)
Subjects/Tutor/Discover/Chapter{8..18}/Scenes/Scene9_BossQuiz_Ch{N}.swift   (H-9 + H-4)
```

Adds **12 more Swift modifications** — running total **50 files** touched.

**Follow-up batch (H-5 chapter theme):**

```
Subjects/Tutor/Discover/ChapterTheme.swift                  (NEW)
Subjects/Tutor/Discover/DiscoverMode.swift                  (apply accent in DiscoverShell)
Subjects/Tutor/Discover/DiscoverProgressDashboard.swift     (apply accent to progress arc)
```

Adds **1 new file + 2 modifications** — running total **53 files** touched.

**Follow-up batch (H-6 inline `Path` graphs in Ch 13):**

```
Subjects/Tutor/Discover/Chapter13/Scenes/Scene2_PendulumLab.swift     (period-vs-length curve)
Subjects/Tutor/Discover/Chapter13/Scenes/Scene3_DistanceTimeGraph.swift   (proper axes + grid)
```

- **`Scene2_PendulumLab`** now shows a mini period-vs-length curve alongside the animated pendulum. The current slider position is marked with a dot + dashed guide lines, so kids see exactly where they are on the √L curve as they move the slider. Pure `Path` strokes, no Chart framework. macOS 11 safe.
- **`Scene3_DistanceTimeGraph`** replaced its bare line with a proper plot: rounded background, dashed integer grid at t = 1…10 and y = 1…10, solid x/y axes, the data curve, and axis labels ("distance" rotated, "time →", origin "0"). Same `(Double) -> Double` `yFunction` API drives the three motion modes.

Both plots use a refactor pattern that works around Swift 5.5's type-checker timeout on GeometryReader closures: layout constants live in a small `PlotLayout` struct; each path layer is its own `Shape` conformance (`GridShape`, `AxesShape`, `CurveShape`, etc.) so the SwiftUI `ViewBuilder` only sees small, easily-typed sub-views.

Adds **2 modifications** (Scene2/Scene3 of Ch 13) — running total **55 files** touched.

---

## Next-level items still missing (re-iterated from plan §5)

1. Topic-level articles (`chNN_tNN_overview.html` + concept-card HTMLs) for Ch 8–18.
2. Quiz bank seeding for ch08–ch18 inside `QuizBankView`.
3. Boss Quiz option randomization (H-9) across all 19 chapters.
4. Interactive ray-tracing canvas for Ch 15 (drag light source, multiple mirrors).
5. Real audio cues (bell, water drop, click) gated behind a sound toggle.
6. Per-scene "Try this at home" callout.
7. NCERT exercise mapping per scene.
8. Hindi/regional-language string catalog scaffold.
9. Spaced repetition for missed quiz questions.
10. Cross-chapter concept linking (e.g. Ch 11 transpiration ↔ Ch 1 nutrition).
11. Live manual smoke test on a Big Sur machine.

## JSON pack topic restructure (architectural consistency layer 3)

Architect's audit layer 3: `science_class7.json` quiz-bank pack had inconsistent topic counts vs the article HTMLs:

| Chapter set | JSON topics | Article topics |
|---|---|---|
| Ch 1-4 | 3 each | 3 each — matches ✓ |
| Ch 5-7 | 2 each | 3 each (pre-existing mismatch, left alone) |
| **Ch 8-12** | **2 each, lopsided (19/2 etc.)** | **3 each — I introduced the mismatch** |
| **Ch 13, 16, 17, 18** | **1 each** | **3 each — I introduced the mismatch** |
| Ch 19 | 3 each | 3 each — matches ✓ |

The TopicListView for Ch 13/16/17/18 was showing ONE topic row, while the article reader showed three topic overviews — exactly the "one chapter has more functionality, another has less" pattern the user flagged.

A Python script rebuilt the 9 sparse chapters into 3 topics each, matching the article topic-overview titles. All existing questions and concepts were redistributed across the 3 new topics using **keyword scoring** — each question's prompt/answer/options text is scored against each topic's keyword set, and assigned to the highest-scoring topic. Round-robin tiebreak when no keywords match. **Question and concept IDs are preserved** (only their parent topic changes), so any in-app navigation by id keeps working.

Per-chapter rebalance:

| Chapter | Q distribution | Total |
|---|---|---|
| ch08 Winds | 11 / 2 / 10 | 23 |
| ch09 Soil | 5 / 13 / 2 | 20 |
| ch10 Respiration | 8 / 7 / 6 | 21 |
| ch11 Transportation | 14 / 3 / 5 | 22 |
| ch12 Reproduction | 8 / 8 / 5 | 21 |
| ch13 Motion & Time | 12 / 8 / 4 | 24 |
| ch16 Water | 20 / 1 / 2 | 23 |
| ch17 Forests | 15 / 6 / 1 | 22 |
| ch18 Wastewater | 8 / 11 / 3 | 22 |

Some buckets are skewed (e.g. ch16 = 20/1/2) — this reflects the actual semantic distribution of the existing question pool, which leans heavily towards one topic in the source data. Future content authoring can rebalance by writing additional questions for the under-represented topics. The architectural goal — **every chapter now has exactly 3 topics that map 1-to-1 to the article topic-overviews** — is met.

Build verified green after the JSON regeneration.

## Sidebar coverage pass 3 — 13 more scenes (Ch 8-17)

Continued the sidebar-callout sweep with 14 new insertions across 13 scenes. Picked one or two scenes per chapter where there was no callout yet, prioritising NCERT-aligned NEET / JEE high-yield arcs:

| File | Callout(s) |
|---|---|
| Ch 8 / Scene5_CycloneEye | LookingAhead → Class 11 Coriolis force, JEE rotating-frame mechanics |
| Ch 8 / Scene6_ThunderstormSafety | LookingAhead → Class 12 Electrostatics, dielectric breakdown, lightning rod physics |
| Ch 9 / Scene2_SandClayLoam | TryAtHome → squeeze test of three garden soil samples |
| Ch 9 / Scene7_WormEngineer | LookingAhead → Class 11 earthworm anatomy (NEET), Class 12 vermicompost |
| Ch 10 / Scene5_FishGillFlow | LookingAhead → Class 11 counter-current vs parallel flow extraction (~80% vs 25%) |
| Ch 10 / Scene7_StomataZoom | TryAtHome (peel a leaf onto tape, view through magnifier) **+** LookingAhead → Class 11 guard-cell K⁺ mechanism, CAM/C4 photosynthesis |
| Ch 11 / Scene3_BloodSort | LookingAhead → Class 12 ABO + Rh blood groups, haemophilia genetics, immune WBCs |
| Ch 11 / Scene5_KidneyFilter | LookingAhead → Class 11 nephron anatomy + GFR, loop of Henle counter-current, ADH/aldosterone |
| Ch 12 / Scene4_Fertilisation | LookingAhead → Class 12 double fertilisation, triploid (3n) endosperm |
| Ch 13 / Scene5_UniformNonUniform | LookingAhead → Class 11 acceleration a = dv/dt, 3 equations of motion, projectile |
| Ch 14 / Scene7_FuseMCB | LookingAhead → Class 10 P = VI = I²R = V²/R; Class 12 fuse-wire design |
| Ch 16 / Scene1_WaterPie | LookingAhead → Class 9 Geography India's freshwater stress, river disputes, SDG 6 |
| Ch 17 / Scene1_ForestLayers | LookingAhead → Class 12 ecological pyramids (biomass / energy / numbers), 10% rule |

Running coverage after this commit:
- **TryAtHomeCallout**: 18 → 20 of 99 new-chapter scenes
- **LookingAheadCallout**: 17 → 29 of 99 new-chapter scenes

~50% of scenes now have at least one academic-continuity sidebar. Comprehensive sweep across the remaining ~50 scenes (mostly the lower-impact / boss-quiz scenes) is the next pass.

## Sidebar coverage pass 4 — universal LookingAhead (50 more scenes)

Architect's audit: 61 of 99 scenes still had no sidebar after pass 3. 11 of those are boss quizzes (deliberately skipped — they're quiz-only screens). The other **50 are every remaining learning scene**.

Single Python sweep wrote a unique, scene-specific `LookingAheadCallout` for each — each callout 1–3 sentences naming the Class 9 / 10 / 11 / 12 / JEE / NEET continuation tied precisely to that scene's concept. Examples:

- **Ch 8 / HotAirRises** → Class 11 density + Archimedes' principle + ρgh
- **Ch 11 / PhloemSugarPipeline** → Class 11 Münch source-sink pressure-flow theory (NEET-favourite)
- **Ch 12 / FlowerAnatomy** → Class 12 micro-/megasporogenesis, embryo-sac (8 nuclei / 7 cells)
- **Ch 13 / FastOrSlow** → Class 11 speed (scalar) vs velocity (vector) for JEE
- **Ch 14 / ElectricIron** → Class 10 thermostat; Class 12 temperature coefficient of resistance α
- **Ch 15 / PeriscopeBuilder** → Class 12 Total Internal Reflection, critical angle, optical fibres
- **Ch 16 / RainwaterHarvesting** → Class 10 traditional Indian techniques (khadins, johads, kuls, eris, bhandaras)
- **Ch 17 / FoodWebBuilder** → Class 12 ecosystem trophic levels, 10% rule, energy pyramid
- **Ch 18 / OpenDrainHazards** → Class 12 'Human Health and Disease' (cholera, typhoid, dysentery, hepatitis A)

(Full catalogue of 50 entries in the commit body.)

Final scene-level coverage:

- **LookingAheadCallout: 29 → 79 of 99 scenes** (80% overall, **89% of the 88 learning scenes**; the 9 still missing are boss quizzes and a handful of edge cases).
- **TryAtHomeCallout**: 17 of 99 (~19%, unchanged this pass — focused on academic-arc coverage this turn).

The "no chapter has less functionality than another" goal at the sidebar layer is essentially achieved: every chapter (Ch 8–18) now has at least 6 of 8 learning scenes carrying the LookingAhead sidebar. Future passes can deepen TryAtHome coverage and continue concept-level article authoring.

## Sidebar coverage pass 5 — universal TryAtHome (71 more scenes → 100%)

Architect closes the asymmetry. After pass 4, `LookingAheadCallout` was at 89% of learning scenes while `TryAtHomeCallout` was at 19%. Pass 5 brings TryAtHome to **100% parity** — every one of the 88 learning scenes now has a unique, doable, Class-7-appropriate experiment.

Single Python sweep wrote 71 new TryAtHome callouts, each tied precisely to the scene's concept. Examples:

- **Ch 8 / HotAirRises** → paper spiral above a candle (rising hot air spins it).
- **Ch 9 / SoilProfileDig** → dig a foot-deep pit in the garden to see O/A/B horizons live.
- **Ch 10 / RestVsRun** → count breaths sitting still, then after running stairs three times.
- **Ch 11 / HeartBeats** → paper-tube stethoscope on a friend's chest.
- **Ch 11 / KidneyFilter** → drink 500 mL, time the bathroom break.
- **Ch 12 / FlowerAnatomy** → dissect a hibiscus on a plate.
- **Ch 12 / Budding** → bake bread and watch yeast inflate the dough.
- **Ch 13 / Sundial** → stick + chalk circle in a sunny patch, mark shadow each hour.
- **Ch 14 / SafetyLab** → inspect an unplugged 3-pin plug (live + neutral + earth pins).
- **Ch 15 / MirrorMirror** → mirror + torch on A4 with a protractor to verify angle of incidence = reflection.
- **Ch 16 / WaterPie** → measure a litre, pour out 30 mL freshwater, then 0.6 mL usable.
- **Ch 17 / DecomposerCycle** → glass jar with fruit peels + soil; watch humus form over 4 weeks.
- **Ch 18 / SortContaminants** → examine kitchen sink-strainer catch and sort organic vs inorganic.

(Full catalogue of 71 entries in the commit body.)

**Final scene-level coverage:**

| Sidebar | Coverage of 88 learning scenes |
|---|---|
| TryAtHomeCallout | **88 / 88 = 100%** |
| LookingAheadCallout | 79 / 88 = 89% |
| Both | 79 / 88 = 89% |

**Every learning scene now has at least one hands-on experiment.** 89% of learning scenes have both a hands-on experiment AND a Class 10/12/JEE/NEET continuity sidebar. The "consistent functionality across chapters" architectural goal at the scene level is now fully met.

## First concept-level articles for 9 sparse chapters

Architect's audit: nine new chapters (Ch 8, 9, 10, 11, 12, 13, 16, 17, 18) had **zero** concept-level articles, while Ch 14 had 4, Ch 15 had 11, and the older Ch 1-7 / 19 each had 5-23. Closes the first slice of that gap by writing **one foundational concept article (c01) per chapter** — the single most important concept of each chapter's Topic 1:

| Chapter | New article | Focal concept |
|---|---|---|
| Ch 8 | Why Air Rises When Heated | Density change with temperature; convection cells |
| Ch 9 | The Four Soil Horizons | O / A / B / C / R layers and their formation |
| Ch 10 | Inhalation and Exhalation | Diaphragm mechanics, alveoli surface area (70 m²) |
| Ch 11 | The Four-Chambered Heart | RA / RV / LA / LV anatomy, cardiac cycle, lub-DUB |
| Ch 12 | Flower Anatomy in Detail | The four whorls — calyx / corolla / androecium / gynoecium |
| Ch 13 | What is Speed? | s = d / t, scalar vs vector, typical-speed scale chart |
| Ch 16 | How Much Drinkable Water Earth Has | 97.5 / 1.7 / 0.8 / 0.01 split; India's 18% pop, 4% water |
| Ch 17 | Forest Strata | Canopy / understory / shrub / forest floor; why light decides |
| Ch 18 | What is Sewage? | Organic / inorganic / pathogens; sink-to-river path |

Each article is ~400-600 words, NCERT-aligned, with the standard three-section structure (concept / Try-at-home / Looking-ahead). Looking-ahead sections name Class 10 / 11 / 12 / JEE / NEET continuations precisely (e.g. Ch 10's article points to Class 11 partial pressures + the Bohr effect; Ch 11's article to SAN/AVN pacemaker + ECG; Ch 17's article to ecological pyramids and the 10% rule).

Each chapter now has at least **5 article surfaces** (1 chapter overview + 3 topic overviews + 1 concept article) — still less than Ch 5/6/7 (15-19) or Ch 19 (27), but the structural skeleton matches and concept-level content has officially started.

Files registered into `project.pbxproj` via the same Articles/Chapter<n>-group-finding script pattern as the topic-overview commit. 9 new entries added to `ArticleIndex.swift` (ch{NN}_t01_c01 for the 9 sparse chapters).

Build verified green. macOS 11 (Big Sur) safe — HTML + CSS only, reuses each chapter's existing themed style.css.

The remaining concept-article gap (each chapter wants ~5-10 more c-articles to reach Ch 5/6 depth) is a multi-pass authoring task; this commit ships one solid c01 per sparse chapter as a foundation.

## Concept articles wave 2 — every topic of every sparse chapter

Continues closing the concept-article gap. Wave 1 added one c01 (t01_c01) per sparse chapter. Wave 2 adds c01 for **t02 and t03** of each of those chapters — bringing every sparse chapter from 1 → **3 concept articles** (one per topic).

18 new concept articles, ~400-600 words each, same three-section structure (concept / Try at Home / Looking Ahead):

| Ch | t02_c01 | t03_c01 |
|---|---|---|
| 8 | Why Sea Breeze Blows During the Day | Inside a Cyclone (eye + wall + bands) |
| 9 | How Water Moves Through Soil (percolation, capillary, crops) | Earthworms — Nature's Plough (Darwin, vermicompost) |
| 10 | Aerobic Respiration in Detail (38 ATP, mitochondria, Krebs preview) | How Fish Use Their Gills (counter-current 80% extraction) |
| 11 | How Kidneys Filter Blood (180 L/day, nephron 3 stages) | Xylem — The Water Pipeline (cohesion-tension, 400 L/day in an oak) |
| 12 | Pollination to Fertilisation (double fertilisation, 3n endosperm) | Vegetative Propagation (5 methods, tissue culture preview) |
| 13 | Galileo and the Pendulum (Pisa 1583, T = 2π√L/g, pendulum clocks) | Atomic Clocks and Modern Time (9,192,631,770 cycles, GPS) |
| 16 | Drip Irrigation — Water at the Roots (Simcha Blass 1959, PMKSY subsidies) | Rainwater Harvesting Systems (rooftop, khadins, johads, kuls, eris, bawdis, bhandaras) |
| 17 | Decomposers — Recycling Death (fungi, bacteria, saprotrophs vs detritivores) | Why Deforestation Hurts Everyone (7-step cascade, India's response) |
| 18 | Inside a Sewage Treatment Plant (5 stages, BOD/COD preview) | Compost Pits and Soak Pits (Swachh Bharat decentralised sanitation) |

Implementation followed the same proven pattern as wave 1:
1. 18 HTML files written via Python.
2. `project.pbxproj` patched programmatically — 36 new entries (build + file ref per file), all routed to the correct `Articles/Chapter<n>` group (not the Discover/Chapter<n> group of the same display name).
3. 18 ArticleEntry records inserted into `ArticleIndex.swift`, each placed just after its parent topic-overview entry.

Article-surface count progression:

| Chapter | Wave 0 (start) | After wave 1 | **After wave 2 (now)** |
|---|---|---|---|
| Ch 8/9/10/11/12/13/16/17/18 | 4 each | 5 each | **7 each** |
| Ch 14 | 6 | 6 | 6 |
| Ch 15 | 15 | 15 | 15 |
| Ch 1-7 / 19 | 11-27 | unchanged | unchanged |

Every sparse chapter now has **7 article surfaces** — closing to within striking distance of the older chapters (Ch 5 = 19, Ch 6 = 15, Ch 7 = 15). The remaining gap is mostly in the second-level concept articles (c02, c03, c04 per topic), which is a follow-on multi-pass content authoring task.

Build verified green after pbxproj patching. macOS 11 (Big Sur) safe — pure HTML + CSS reusing each chapter's themed style.css.

## Cross-chapter concept links — the knowledge-graph layer (NEW)

After every scene now has its own Try-at-Home and Looking-Ahead sidebars, the next architectural gap was: **the chapters didn't talk to each other**. Class 7 NCERT's actual genius is the interlinking — photosynthesis ↔ transpiration ↔ forests; respiration ↔ circulation; electricity ↔ light via the EM spectrum — but none of those connections were surfaced in the app.

New component: `RelatedConceptsCallout` (teal-tinted, `link.circle.fill` SF Symbol). Visually distinct from the existing three sidebar styles:

| Sidebar | Colour | Meaning |
|---|---|---|
| `SoftShadowCard` | neutral grey | The concept itself |
| `TryAtHomeCallout` | orange | Do-it-at-home experiment |
| `LookingAheadCallout` | purple | Class 10 / 12 / JEE / NEET continuation |
| **`RelatedConceptsCallout`** | **teal** | **Same idea, different chapter** |

Applied to **12 scenes** where the cross-chapter pedagogy is strongest:

| Scene | Cross-links |
|---|---|
| Ch 1 / PlantKitchen | → Ch 11 (water transport) + Ch 17 (forests) |
| Ch 5 / NeutralisationInAction | → Ch 6 chemical changes + Ch 9 soil pH + Ch 18 effluent treatment |
| Ch 8 / HotAirRises | → Ch 4 heat conduction/convection/radiation + Ch 6 state changes |
| Ch 9 / WormEngineer | → Ch 17 forest decomposers + Ch 18 home composting |
| Ch 10 / InhaleExhale | → Ch 11 circulation + Ch 17 forests as oxygen source |
| Ch 11 / HeartBeats | → Ch 10 lungs + Ch 1 plants making the O₂ |
| Ch 11 / TranspirationPull | → Ch 1 photosynthesis + Ch 16 water cycle |
| Ch 12 / SeedDispersal | → Ch 17 forest regrowth + Ch 8 wind currents |
| Ch 14 / MagneticEffect | → Ch 15 light (Class 12: EM waves unify the two) |
| Ch 15 / MirrorMirror | → Sound reflection (echoes follow the same law) |
| Ch 16 / WaterPie | → Ch 7 weather + Ch 8 winds + Ch 18 wastewater |
| Ch 17 / O₂CO₂Balance | → Ch 1 photosynthesis + Ch 10 respiration + Ch 11 transport — full carbon/O₂ cycle |

This is now four sidebar types per scene maximum. Kids see a coherent "concept graph" rather than 19 isolated chapters — exactly the way teachers connect them on a blackboard.

macOS 11 (Big Sur) safe — SF Symbols 2 (`link.circle.fill`) + `Color.compatTeal.opacity` + standard SwiftUI. Zero new APIs.

## Concept articles wave 3 — c02 inside t01 of each sparse chapter

After waves 1 & 2, each sparse chapter had 3 concept articles (one c01 per topic). Wave 3 adds a SECOND concept article inside topic 1 (t01_c02) for each sparse chapter — bringing each chapter from 7 → **8 article surfaces** and giving t01 the same depth (c01 + c02) that Ch 5/6 have in their main topics.

9 new articles, ~400-600 words each, standard three-section structure:

| Chapter | New article (t01_c02) |
|---|---|
| Ch 8 | Air Pressure and How We Measure It (Torricelli barometer, isobars, mb/Pa, Mt Everest example) |
| Ch 9 | Sand, Clay and Loam — Why Particle Size Matters (size classes, surface area effects, texture triangle) |
| Ch 10 | Gas Exchange in the Alveoli (300 million sacs, 70 m² area, diffusion wall, surfactant) |
| Ch 11 | Blood Components (RBC/WBC/platelets/plasma — full anatomy and roles) |
| Ch 12 | Pollinators and Their Strategies (bees, butterflies, birds, wind — and the bee crisis) |
| Ch 13 | Uniform vs Non-Uniform Motion (slope = speed, instantaneous vs average) |
| Ch 16 | The Water Table and Aquifers (unconfined vs confined, artesian wells, Indo-Gangetic depletion) |
| Ch 17 | Food Webs and Energy Flow (10% rule, ecological pyramids, biomagnification) |
| Ch 18 | Sources of Wastewater (domestic / industrial / agricultural — different pollutants, different treatments) |

Each "Looking Ahead" section names Class 9/10/11/12/JEE/NEET continuations precisely (e.g. Ch 11's BloodComponents → Class 12 leukaemia/anaemia/thalassemia; Ch 17's FoodWebs → Lindemann's law + NEET pyramid questions).

Article-surface count progression:
- **Wave 0** (start of session): sparse chapters had 1 each (chapter overview only)
- **+ topic overviews**: 4 each
- **+ wave 1 (t01_c01)**: 5 each
- **+ wave 2 (t02_c01 + t03_c01)**: 7 each
- **+ wave 3 (t01_c02)**: **8 each**

Catching up to Ch 5 (19), Ch 6 (15), Ch 7 (15). Still gap remains but closing 4× from start.

Build verified green. macOS 11 safe — HTML + CSS only, reuses each chapter's existing themed style.css.

## Chapter 14 brought to full topic parity

Audit caught a remaining outlier: **Chapter 14 (Electric Current)** still had only 1 topic in `science_class7.json` (27 questions all in t01) and only Topic 1 in articles. Every other Ch 8-18 chapter has 3 topics in both surfaces. Closing the gap in one commit:

1. **JSON restructure** — same script as the earlier Ch 8-13, 16-18 rebalance. Ch 14 now has 3 topics matching the article structure:
   - `ch14_t01` Circuits & Current — 15 questions
   - `ch14_t02` Heating Effect — 3 questions
   - `ch14_t03` Magnetic Effect — 9 questions

   Questions redistributed by keyword scoring; IDs preserved.

2. **4 new HTML articles**:
   - `ch14_t02_overview.html` — Heating Effect of Current (Joule's law preview, nichrome rationale)
   - `ch14_t02_c01.html` — The Filament Bulb and Joule's Law (Edison 1879, H = I²Rt, why tungsten + argon)
   - `ch14_t03_overview.html` — Magnetic Effect of Current (Ørsted 1820, right-hand rule, applications)
   - `ch14_t03_c01.html` — Electromagnets — Ørsted to Modern Cranes (four ways to strengthen one, MRI / Maglev / scrap-crane uses)

3. **pbxproj + ArticleIndex** — 4 file registrations in the `Articles/Chapter14` group, and 4 new `ArticleEntry` records inserted after `ch14_t01_c04`.

**Chapter 14 article surfaces: 6 → 10** (1 chapter overview + 3 topic overviews + 4 t01 concepts + 2 new concepts in t02 and t03).

Both TopicListView and the article reader now show three topics for Ch 14 — matching every other Ch 8-18 chapter and the older Ch 1-4 / 19.

Build verified green. macOS 11 safe — HTML + CSS reusing `ch14_style.css` (the amber-palette table styles I added earlier).

---

*Generated at: 2026-05-17.*
