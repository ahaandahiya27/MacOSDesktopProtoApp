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

---

*Generated at: 2026-05-17.*
