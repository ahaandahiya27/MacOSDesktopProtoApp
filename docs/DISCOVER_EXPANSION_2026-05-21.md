# Discover Mode Expansion — 2026-05-20/21

## Summary

Every science chapter expanded from 9 → 20 Discover scenes. Total
Discover scene count: **171 → 380**.

## Final state

| Chapter | Title | Scene count | Dispatcher LOC |
|---|---|---|---|
| 1 | Nutrition in Plants | 20 | 1294 |
| 2 | Nutrition in Animals | 20 | 798 |
| 3 | Fibre to Fabric | 20 | 705 |
| 4 | Heat | 20 | 607 |
| 5 | Acids, Bases and Salts | 20 | 621 |
| 6 | Physical and Chemical Changes | 20 | 483 |
| 7 | Weather, Climate and Adaptations | 20 | 497 |
| 8 | Winds, Storms and Cyclones | 20 | 472 |
| 9 | Soil | 20 | 515 |
| 10 | Respiration in Organisms | 20 | 495 |
| 11 | Transportation in Animals and Plants | 20 | 460 |
| 12 | Reproduction in Plants | 20 | 438 |
| 13 | Motion and Time | 20 | 493 |
| 14 | Electric Current and its Effects | 20 | 470 |
| 15 | Light | 20 | 430 |
| 16 | Water: A Precious Resource | 20 | 445 |
| 17 | Forests: Our Lifeline | 20 | 440 |
| 18 | Wastewater Story | 20 | 414 |
| 19 | Earth, Moon and the Sun | 20 | 438 |

`DataStore.totalDiscoverScenes = 380` (matches 19 × 20).

## Architecture decisions

### Inline-in-dispatcher scene pattern

All 209 new scenes (11 per chapter × 19 chapters) live as `private struct`
declarations at the bottom of their owner's `DiscoverChapter<N>View.swift`
file, matching the established `DailyPracticeView` /
`ReviewSessionSheet` / `AllChaptersCompleteOverlay` pattern.

- Avoids the Xcode `project.pbxproj` add-files ceremony that the harness
  blocks while Xcode is open.
- Keeps each chapter's view code self-contained and easy to grep.
- File sizes stay manageable (most chapters 400–700 LOC; Ch.1 at 1294
  LOC since it carried the pilot rewrite).

### AnyView lookup-table dispatcher

Each chapter's `sceneBody(_:)` is a function returning `AnyView` that
indexes into a private `[() -> AnyView]` array (see commit `7843d56`):

```swift
private func sceneBody(_ index: Int) -> AnyView {
    guard index >= 0 && index < sceneBuilders.count else {
        return AnyView(EmptyView())
    }
    return sceneBuilders[index]()
}

private var sceneBuilders: [() -> AnyView] {
    [
        { AnyView(Scene1_…(pack: self.pack, …)) },
        … 20 entries …
    ]
}
```

Why: a 20-case `switch` inside `@ViewBuilder` forces Swift to type-check
`_ConditionalContent<_ConditionalContent<…>>` 20 levels deep. The
pre-refactor Ch.2 dispatcher took **210s** to compile. AnyView
short-circuits type inference and brings each dispatcher back to **5–8s**
build time — critical for the Xcode 13.2.1 deploy target.

Tradeoff: each scene render incurs a tiny type-erasure cost. Invisible
at the chapter-dispatch level (one view per active scene).

## Regression classes actively defended

These were the patterns that broke earlier in the codebase's history.
Every new scene file in the expansion was authored to avoid them:

1. **`try!` / `as!` / force-unwrap in runtime paths** — pre-commit lint
   enforces, only `FoundationTutor` exempt. None introduced.
2. **macOS 12+ APIs** — no `.foregroundStyle`, `.symbolEffect`,
   `.scrollPosition`, `@Observable`, `Bindable`, `Color.brown`,
   `Font.monospaced()`, `Image.resizable(capInsets:)`. Two `.monospaced()`
   slips on Font were caught by the build and converted to
   `.system(size:weight:design:)` mid-commit.
3. **SF Symbols ≥3 names** — pre-commit lint routes any flagged literal
   through `SFSymbolCompat.name(_:)`. Each new scene used SF Symbols 2
   glyphs only.
4. **`.foregroundColor(.yellow|.orange|.teal)` on `Text` widgets** —
   pre-commit lint blocks. All Text colours route via
   `DesignTokens.BrandColor.*` deep-hued accents.
5. **GeometryReader + `.frame(maxHeight:)` cap collapse** — no scenes
   use this anti-pattern. The canonical
   `ScrollView { LazyVStack(spacing:14) { … GotItButton } }` template
   is used everywhere.
6. **`@ViewBuilder` ≤10 direct children limit** — every scene body has
   ≤8 direct children. The lookup-table dispatcher sidesteps the limit
   at the chapter level.
7. **`Dictionary(uniqueKeysWithValues:)` crashes on duplicate keys** —
   none introduced. Existing safer
   `Dictionary(_:uniquingKeysWith:)` pattern preserved.
8. **`Color.brown` (macOS 12+)** — all uses route via
   `Color.compatBrown`. Caught by build in Ch.1, applied prophylactically
   in Ch.6, Ch.9, etc.

## Verification

Each chapter shipped through identical gates:

1. Build clean (Big Sur deployment target `MACOSX_DEPLOYMENT_TARGET=11.0`)
2. `scripts/check_sf_symbols_compat.py` — clean
3. `scripts/check_color_literals.py` — clean
4. `scripts/check_viewbuilder_limit.py` — clean
5. 236 ChapterContentTests pass
6. `pre-push` CI ran `scripts/ci-build-test.sh` on every push — all
   green (`==> ci-build-test PASSED`)

Each chapter shipped as its own focused commit. If a chapter had broken
the gates, the entire expansion would have stopped at that chapter.
None did.

## Interaction-pattern toolbox

To keep the kid's experience varied, scenes rotated among these distinct
interaction patterns. No two adjacent new scenes in any chapter share
the same pattern.

1. Toggle reveal (binary state change)
2. Linear slider with live readout
3. Multi-stage stepper / sequence walk
4. Multiple-choice quiz with scored feedback
5. Tap-to-assign sorter (org → bucket)
6. Tap-to-reveal accordion list
7. Timing mini-game (Venus Flytrap, Pseudopod Catch)
8. Order-builder (Food Chain)
9. Zoom card (Stomata, Villi)
10. Comparison card-row (Cow vs Goat vs Camel)
11. Picker with rich detail

## Known follow-ups (deferred)

1. **Pack JSON content alignment for new scenes** — the 209 new scenes
   are visible interactive UIs but don't yet have matching concept
   entries in `science_class7.json`. Daily Practice's SM-2 review queue
   only surfaces questions tied to the existing 190 concepts. A future
   pass can add new concept rows + linking `relatedConceptIds` so the
   spaced-rep system covers the new material.
2. **Boss Quiz scaling** — most Boss Quizzes have 5 questions. With
   20-scene chapters they feel under-scaled. A future pass could bump
   to 10 questions each.
3. **iMac visual verification** — none of today's work has been
   verified on the actual deploy target (Big Sur iMac Late-2014).
   Recommended: pull → smoke-test 1 scene per chapter → flip ❌ rows
   to ✅ in `docs/ISSUE_CATEGORIES.md`.
4. **Articles for new scenes** — `Resources/Articles/Chapter*/`
   HTML files don't have entries for the new pedagogical hooks. Most
   new scenes are self-contained interactive content, so this is
   nice-to-have rather than required.

## Commits

Final commit list across 21 May 2026 (all on `main`, all green via
pre-push CI):

| Commit | Chapter |
|---|---|
| `05f3185` | Ch.6 Physical & Chemical Changes |
| `01acfe5` | Ch.7 Weather, Climate, Adaptations |
| `6cdcc02` | Ch.8 Winds, Storms, Cyclones |
| `d2b3ae2` | Ch.9 Soil |
| `1eacaed` | Ch.10 Respiration in Organisms |
| `dd27918` | Ch.11 Transportation |
| `9921f19` | Ch.12 Reproduction in Plants |
| `eca7f01` | Ch.13 Motion and Time |
| `7b5fa32` | Ch.14 Electric Current |
| `8cf5a7b` | Ch.15 Light |
| `8f1b96b` | Ch.16 Water |
| `9a6c54f` | Ch.17 Forests |
| `52ef150` | Ch.18 Wastewater |
| `405fd06` | Ch.19 Earth Moon Sun |

Ch.1-5 shipped 20 May 2026 (commits `af9a168` … `45a66ee`). Dispatcher
refactor `7843d56`.
