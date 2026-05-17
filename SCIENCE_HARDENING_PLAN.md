# Science Pack — Hardening, Audit & Closure Plan

**Target:** Class 7 Science (`science_class7`). Scope: Discover Mode for Ch 1–19, supporting articles, navigation, quiz bank, persistence, and the chapter-detail screen.

**Hard constraint:** Everything in this plan **must build and run on macOS 11 (Big Sur)** on the Late-2014 iMac 5K (R9 M290X 2 GB GPU). No `Canvas`, `TimelineView`, `Color.cyan/brown/indigo/mint/teal`, `progressView(.linear)` only, `symbolEffect`, `.foregroundStyle`, `Layout` protocol, `Observation` framework, `Grid` (macOS 13+), `.scrollPosition`, `.scrollTransition`, `.searchScopes`, `.bordered(_:.large)`, `.containerRelativeFrame`, etc.

**Estimated effort:** ≥ 2 hours of focused, non-stop autonomous execution. Plan is sequenced so partial completion still leaves the app in a buildable state after every phase.

---

## 0. Working Rules

1. **Build after every phase.** `BuildProject` must succeed before moving on.
2. **Never widen scope** beyond Science. Do not touch Sanskrit or any non-pack code unless a science fix demands it (then keep diff minimal).
3. **Compat helpers only.** Use `Color.compatIndigo`, `Color.compatCyan`, `Color.compatBrown`, `Color.compatTeal`. Add a `compatMint` / `compatPink` helper in `Extensions.swift` only if a scene genuinely needs it.
4. **No new emoji‑only scenes.** Where a scene currently uses emoji as illustration, upgrade to a `Shape`/`Path` drawing if the chapter is in Tier‑A polish. Other scenes may retain emoji but must pass content & interaction QA.
5. **No unbounded recursion in timers.** Every `DispatchQueue.main.asyncAfter` loop must have a cancellation flag and tear down in `.onDisappear`.
6. **One scene file = one responsibility.** No cross‑scene state, no `static` mutable storage, no singletons.
7. **Accessibility floor.** Every interactive control needs an `accessibilityLabel`. Every animation respects `accessibilityReduceMotion`.
8. **Mark complete on first meaningful interaction**, not after a chain of taps the user might never finish.

---

## 1. Known Bugs (Catalog)

These were introduced or surfaced during the bulk Ch 8–18 build, plus pre-existing.

### 1.1 Cross-cutting

| ID | Severity | File / Symbol | Bug |
|----|---------|---------------|-----|
| **B-01** | High | `DiscoverMode.scenesPerChapter = 8` | Constant is 8 but every chapter (old + new) has **9** sceneTitles including Boss Quiz. `DiscoverProgressDashboard` uses this constant → total scene count and percentage are wrong for every chapter. |
| **B-02** | Med | `DiscoverProgressDashboard` total chapters | Now that 11 new chapter ids are registered, the dashboard's expected totals (chapters × scenes) jump. Verify the percentage math handles 19 chapters × 9 scenes = **171** total scenes, not 12 × 8 = 96. |
| **B-03** | Med | `DiscoverProgress` rows for new chapters | `DataStore.markSceneComplete` must persist correctly for `ch08…ch18`. Run end-to-end: complete scene 1 of Ch 8 → relaunch → progress retained. |
| **B-04** | Low | `ChapterDetailView` "Discover Mode" entry button | Verify the button appears for `ch08…ch18`. `DiscoverMode.hasExperience(...)` already returns true after Phase 0 of last run; spot-check the UI in 2–3 chapters. |
| **B-05** | High | Missing article HTML for `ch02, ch03, ch04, ch08, ch09, ch10, ch11, ch12, ch13, ch14, ch15, ch16, ch17, ch18` | Article reader will either crash or show empty. Need a minimal overview HTML per chapter at the very least (one file `chNN_overview.html` + a re-used CSS). |

### 1.2 Scene-level bugs introduced this session

| ID | File | Bug |
|----|------|-----|
| **B-10** | `Chapter11/Scenes/Scene2_PulseCounter.swift` | Tap action duplicated (button body has unreachable code) and the recursive `tick()` has no cancellation if the user navigates away mid-count. Memory & state leak. |
| **B-11** | `Chapter11/Scenes/Scene8_TranspirationPull.swift` | `runTimer()` / `advanceTimer()` recursion has no `.onDisappear` cancellation; the `running` flag is checked but `seconds < 5` is the only stop. If user toggles the cover off mid-run the inner branch still re-arms. |
| **B-12** | `Chapter13/Scenes/Scene7_StopwatchRace.swift` | Time accumulates by `1.0 / 30.0` per tick, drifting from wall‑clock. Replace with `Date()` start + delta on tick. |
| **B-13** | `Chapter13/Scenes/Scene2_PendulumLab.swift` | Period uses live slider value but `angle` is recomputed from current `length` every tick — the pendulum "jumps" when length changes mid-swing. Either snapshot `length` per swing or smooth the transition. |
| **B-14** | `Chapter15/Scenes/Scene1_MirrorMirror.swift` | Reflected ray geometry is approximate; the angle math doesn't preserve the "common point on the mirror" — both rays should meet on the mirror surface, not slightly off. Re-derive with proper anchor. |
| **B-15** | `Chapter15/Scenes/Scene4_PrismRainbow.swift` | The white ray, prism, and VIBGYOR exit are independent overlays — they don't actually line up at the prism vertex. Either re-position or draw with a proper `ZStack` + alignment offsets calculated from the prism size. |
| **B-16** | `Chapter14/Scenes/Scene6_BuildElectromagnet.swift` | `clipsHeld` text changes but the visual nail doesn't show clips attaching position-wise (they just stack in an HStack); also no upper-bound check that the clip count stays sane. |
| **B-17** | `Chapter9/Scenes/Scene7_WormEngineer.swift` | `Int.random(in: -120...120) % 120` is a useless modulo (range never exceeds the modulus). Tunnels render at incorrect positions and re-randomize every redraw. Move the random into a `@State` array set on `.onAppear`. |
| **B-18** | `Chapter17/Scenes/Scene3_FoodWebBuilder.swift` | "Arrows" set is toggled but never shown visually beyond the button label. Either draw actual connection lines or repurpose as a checklist (then clearly label it that way). |
| **B-19** | `Chapter10/Scenes/Scene5_FishGillFlow.swift` | The "water droplet" emoji moves but doesn't visually look like water flowing **through** gills. Replace with two emoji at fish's mouth → gill exit, or remove the animation and use static labelled arrows. |
| **B-20** | `Chapter18/Scenes/Scene2_WWTPStageBuilder.swift` | Stage strip is narrow; tapping the last stage on a 13″ screen wraps awkwardly. Add HStack scroll or wrap to 2 rows. |
| **B-21** | `Chapter9/Scenes/Scene3_PercolationRate.swift` | Animation duration `60.0 / soil.rate` makes "clayey" take 15 seconds — feels broken. Cap to 5 s max, scale proportionally. |
| **B-22** | `Chapter16/Scenes/Scene2_WaterTableSlider.swift` | Slider tracks rain/extract symmetrically but extraction `level` math is clipped — the water table never goes below the surface but visually it just stops mid-tank. Add a "dry well" warning state. |
| **B-23** | `Chapter17/Scenes/Scene7_DeforestationDomino.swift` | `revealed` advances by tap but no visual "fall" animation; the consequence list is static once revealed. Add an offset or fade. |
| **B-24** | `Chapter12/Scenes/Scene7_Budding.swift` | Stage progression is linear taps but `HStack(spacing: stage == 3 ? 60 : 4)` only animates when stage hits 3 — intermediate stages don't animate. Drive spacing off `stage` continuously. |
| **B-25** | `Chapter12/Scenes/Scene8_Fragmentation.swift` | Fragment count is `Int(fragments)` but the capsule width division `280 / fragments` uses `Double` directly — fragments=6 → 46-pt-wide capsules that don't visually look like a broken filament. Add explicit gaps between fragments. |
| **B-26** | `Chapter13/Scenes/Scene1_FastOrSlow.swift` | `current` array shuffled `.onAppear` only when empty — switching scenes back doesn't re-shuffle even after a "Shuffle" tap. Audit `done` reset paths. |
| **B-27** | `Chapter8/Scenes/Scene5_CycloneEye.swift` | Rotation grows unboundedly via `rotation += speed * 0.05` — eventually `Double` precision degrades. Modulo 360 each tick. |
| **B-28** | `Chapter15/Scenes/Scene8_Kaleidoscope.swift` | Pattern uses `seed * (i+1) * (j+1)` which becomes huge fast and `% 4` on a large `Int` is fine, but `seed` itself is `Int.random(in: 1...100)`. Multiplications above can overflow if seed grows. Constrain via `% 1000` after multiplication. |

### 1.3 Pre-existing issues worth noting (do **not** auto-fix unless trivial)

| ID | File | Note |
|----|------|------|
| **B-30** | `Chapter6/Scenes/Scene1_IceToWaterToSteam.swift` | `AnyShape` redefined locally — collides with SwiftUI's own `AnyShape` (macOS 13+). Already gated; verify still fine. |
| **B-31** | Sidebar discover badge | Badges may stop updating after large progress jumps; verify subscription path triggers a refresh after `markSceneComplete`. |

---

## 2. Content Quality Audit (per chapter)

For each of the 11 new chapters (Ch 8–18), the audit must verify:

1. **Concept accuracy** matches Class 7 NCERT (old curriculum / Curiosity new curriculum where applicable).
2. **Units & magnitudes** present and realistic (km/h, °C, A, L/min, etc.).
3. **Boss Quiz** — 5 questions, distractors are plausible but clearly wrong, explanations don't repeat the answer text verbatim.
4. **Title casing** consistent ("Pulse Counter" not "pulse counter").
5. **No typos / em-dash vs hyphen consistency** within a scene.
6. **Region-appropriate examples** (Indian context where relevant — bawdis, Van Mahotsav, IMD warnings, Swachh Bharat).

Output: a `SCIENCE_CONTENT_AUDIT.md` log with one bullet per change (or a `git diff`-style summary).

---

## 3. macOS 11 Compatibility Sweep

Run a final `grep` across the Discover tree for these banned tokens. **All must be 0 hits in `Subjects/Tutor/Discover/Chapter{8..18}/` (Ch 1–7, 19 are pre-existing and already audited).**

```text
Color\.cyan           Color\.brown          Color\.indigo
Color\.mint           Color\.teal           Color\.pink         (within new chapters only)
TimelineView          \bCanvas(            \bsymbolEffect
\.foregroundStyle     \.scrollPosition      \.scrollTransition
@Observable           \bGrid\(              \bGridRow\(
\.searchScopes        \.containerRelativeFrame
ContentUnavailableView                        \.bordered(\.borderless
```

For each banned hit, replace with a `Color.compat*` constant, a manual `Shape` drawing, a `Timer.publish` driven by `.timedScene`, or a Big-Sur-safe equivalent.

---

## 4. Implementation Phases (sequenced, ≥ 2 hours)

> Each phase ends with `BuildProject` green and `XcodeRefreshCodeIssuesInFile` on the most-touched files.

### Phase A — Foundation fixes (~15 min)

- **A1.** Fix `B-01`: change `DiscoverMode.scenesPerChapter` from `8` to `9` **AND** rename it `scenesPerChapter` → `totalScenesPerChapter` (clarity). Update `DiscoverProgressDashboard` references.
- **A2.** Verify `DiscoverProgressDashboard` math; add a unit test stub or in-line assertion that completion never exceeds 100%.
- **A3.** Add `accessibilityReduceMotion` honor to every animated scene that doesn't already gate on it (sweep `Chapter{8..18}`).
- **A4.** Build.

### Phase B — Timer & memory hygiene (~15 min)

- **B1.** Scene2_PulseCounter: extract `tick()` into a `Bool` cancel-token; cancel in `.onDisappear`.
- **B2.** Scene8_TranspirationPull: same pattern.
- **B3.** Scene7_StopwatchRace: switch to `Date()`-based elapsed; cap displayed precision to 0.01 s.
- **B4.** Sweep all `DispatchQueue.main.asyncAfter` recursions in new scenes — wrap each in a `runID: UUID` guard so navigating away invalidates the chain.
- **B5.** Build.

### Phase C — Bug fixes B-13 through B-28 (~30 min)

Walk through each B-id, apply minimal fix, build after every 4 fixes. Order:

1. Visual / math bugs first (B-13, B-14, B-15, B-17, B-19, B-22, B-25, B-27, B-28).
2. UX bugs next (B-16, B-18, B-20, B-21, B-23, B-24, B-26).
3. Build.

### Phase D — Scene polish (Tier-A only) (~30 min)

Pick **3 highest-impact scenes** to upgrade from emoji visuals → custom `Shape`/`Path` illustrations matching the polish of `Scene1_IceToWaterToSteam`:

1. **Ch 15 / Scene 1 — Mirror Mirror.** Draw mirror, normal, incident & reflected rays with proper anchor math.
2. **Ch 14 / Scene 1 — Build a Circuit.** Draw cell + wire + switch + bulb with real connector lines that animate when the loop is closed.
3. **Ch 11 / Scene 1 — Heart Beats.** Draw 4-chamber heart with `Path` curves + colored blood arrows (oxygen-rich / oxygen-poor).

Each upgraded scene gets a code comment explaining the geometry and a reduce-motion fallback.

Build after each.

### Phase E — Article content gap (~20 min)

For each missing chapter (ch02, ch03, ch04, ch08, ch09, ch10, ch11, ch12, ch13, ch14, ch15, ch16, ch17, ch18):

- Create `Resources/Articles/Chapter{N}/ch{NN}_overview.html` — a single-page summary (300–500 words) with `<link rel="stylesheet" href="ch{NN}_style.css">`. The CSS may re-use the existing Chapter6/7/19 style with chapter‑accent colour swapped.
- Reuse a shared `_shared_style.css` if you want — but keep it backward-compatible with chapters that already ship their own.
- Verify `ArticleEntryButton` / article reader resolves and renders these.

(Topic-level concept HTMLs `chNN_tNN_cNN.html` are out of scope here; we ship the overview now and the deeper articles in a later sprint.)

### Phase F — Quiz Bank parity (~15 min)

If `QuizBankView` shows per-chapter questions, ensure each new chapter has at least the 5 boss-quiz questions accessible there (either by reading from the Discover scene struct or by adding a small JSON/Swift array). Otherwise mark them clearly as "Quiz bank not yet seeded for this chapter — try Discover Mode > Boss Quiz".

### Phase G — Navigation & dashboard verification (~10 min)

- **G1.** Open the app. From the sidebar, navigate to each of `ch08…ch18`. Confirm:
  - Chapter detail loads.
  - "Discover Mode" entry button appears.
  - Article button either loads the new overview HTML or shows a friendly "no article yet" placeholder.
- **G2.** Open `DiscoverProgressDashboard`. Confirm all 19 chapters are listed with their 9-scene grid.
- **G3.** Complete one scene each in 3 new chapters → relaunch app → progress retained.
- **G4.** Verify recent-items sidebar section catches Discover scene completions.

### Phase H — Next-level polish backlog (≥ 15 min on the top items) (~25 min)

Pick from this menu in order; do as many as time allows:

| # | Item | Why |
|---|------|-----|
| H-1 | **Inline diagram component** `RayDiagram` — reusable for Ch 15 lenses/mirrors + Ch 14 wire diagrams. | Reduces duplicated geometry math. |
| H-2 | **Keyboard navigation per scene** — `← →` already work at chapter level; add `Return`/`Space` to advance scored scenes once `done`. | Improves accessibility. |
| H-3 | **VoiceOver labels on all `Text` emoji art** — emoji alone is read as the unicode name. Add `.accessibilityLabel`. | Vision-impaired users. |
| H-4 | **Scene completion celebration** — green flash + check icon when boss-quiz score ≥ 4/5. | Currently silent. |
| H-5 | **Chapter colour theme** — each chapter gets a tint via a `chapterTheme(for:)` helper applied to titles & SoftShadowCard accents. | Visual variety. |
| H-6 | **Pendulum lab — graph of period vs length** — small inline `Path` plot. | Reinforces √L relationship. |
| H-7 | **Circuit builder — drag wires** instead of just toggles. | True circuit feel. |
| H-8 | **Light prism — split / merge animation** on tap. | Currently abrupt. |
| H-9 | **Boss Quiz — randomize option order per session** so memorization doesn't game it. | Better learning. |
| H-10 | **Discover dashboard — top-3-chapters card** showing closest to completion. | Encourages finishing. |
| H-11 | **Audit MD output** — emit a fresh `SCIENCE_CONTENT_AUDIT.md` summarizing every edit made in this run (manual `git diff --stat`). | Auditability. |

### Phase I — Final verification (~10 min)

- `BuildProject` green
- `XcodeRefreshCodeIssuesInFile` on `DiscoverMode.swift`, `DiscoverProgressDashboard.swift`, and one scene from each new chapter — no warnings, no errors
- Run the app, walk through Ch 8 → Ch 18 sidebar entries, confirm each opens, has its Discover view, and the Boss Quiz reports a score
- Hand-verify on a Big Sur VM if available (or at minimum, confirm no `@available(macOS 12, *)` was introduced anywhere)

---

## 5. Next-Level Items Still Missing in Science (post-this-plan backlog)

These are explicitly **out of scope** for this run, but worth queueing:

1. **Topic-level articles** (`chNN_tNN_overview.html` + concept-card HTMLs) for Ch 8–18 — same depth as Ch 1.
2. **Interactive ray-tracing canvas** for Ch 15 — draggable light source, multiple mirrors.
3. **Real audio cues** — bell, water drop, click — gated behind a sound toggle.
4. **Per-scene "Try this at home" callout** — a sidebar with a real-life experiment kid can do.
5. **NCERT exercise mapping** — link each scene back to the textbook page/question it covers.
6. **Hindi & regional-language strings** — string catalog scaffold.
7. **Print-friendly chapter summary** PDF export from the dashboard.
8. **Teacher view** — group-completion stats if/when multi-user persistence lands.
9. **Spaced-repetition for missed quiz questions** — re-surface in future sessions.
10. **Cross-chapter concept links** — e.g. when Ch 11 (transportation) mentions root pressure, link back to Ch 1 (nutrition in plants).

---

## 6. Acceptance Criteria (exit gate)

This plan is **done** when **all** of the following are true:

- [ ] `BuildProject` succeeds with **0 errors, 0 warnings** introduced by this run.
- [ ] Every banned macOS 12+ token from §3 has zero hits in `Chapter{8..18}/`.
- [ ] `DiscoverMode.scenesPerChapter` is **9**; dashboard percentages match observed counts.
- [ ] All scenes in `Chapter{8..18}/` honor `accessibilityReduceMotion`.
- [ ] No `DispatchQueue.main.asyncAfter` recursion in new scenes lacks cancellation.
- [ ] Bugs **B-01 through B-28** are either fixed or explicitly punted with a code comment + entry in this file.
- [ ] Articles overview HTML exists for every chapter Discover Mode supports.
- [ ] Manual sidebar walk: each of `ch08…ch18` opens, shows Discover button, opens Boss Quiz, records a score.
- [ ] `SCIENCE_CONTENT_AUDIT.md` exists, summarizing edits.

---

## 7. Roll-back Strategy

If any phase breaks the build for more than 5 minutes:

1. `git diff` the offending phase only.
2. Stash the broken changes, leave the prior phase intact.
3. Re-plan that sub-step.
4. Move on; do not block the rest of the chapters on one bad scene.

The plan is deliberately **chapter‑parallel**: a fix in Ch 11 never depends on a fix in Ch 14, so the build can stay green even with partial progress.

---

*Last updated:* 2026-05-17. Owner: Science pack maintainers.
