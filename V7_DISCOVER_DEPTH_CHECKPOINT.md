# V7_DISCOVER_DEPTH_CHECKPOINT.md — "Discover Depth + Visual Library"

> Closing checkpoint for the v7 autonomous run. Proven green on the deploy
> environment at every milestone (Release build + full XCTest). Resume detail
> lives in `V7_DEPTH_LEDGER.md`; per-milestone narrative in `REMEDIATION_LOG.md`.

## What v7 set out to close (audit gaps)

1. **Uneven Discover depth** — Science + Maths had bespoke per-chapter Discover
   interactives; Sanskrit (15 NEP ch) and Social Science (20 ch) did not.
2. **Empty visual library** — `ShapeDiagramRegistry` was a stub (`[:]`); ~76
   chapter diagrams rendered as placeholder cards.
3. **A few Discover callouts** read above the Class-7 reading band.

## Outcome by phase

| Phase | Scope | Result |
|-------|-------|--------|
| 1 · Social Science bespoke Discover | ssch01–ssch20 | ✅ **Pre-existing** at baseline — 14 strand explorers + `SSChronologyChallenge` + `SSGlossaryMatchChallenge` cover all 20 chapters, gated by `socialScienceInteractivesAreEnabled`. Verified, not re-built. |
| 2 · Sanskrit bespoke Discover | sch01–sch15 (legacy `ch01` exempt) | ✅ `ShabdaArthaMatchChallenge` (शब्द–अर्थ word↔meaning), Devanagari-forward, behind a new `sanskritInteractivesAreEnabled(forPackId:)` gate. |
| 3 · Shape Diagram Library | 76 diagrams, ch01–ch19 | ✅ **76/76 registered** — every `shapeDiagram` MediaAsset resource key now renders real pure-SwiftUI art. Zero placeholder fallbacks. |
| 4 · Reading-level polish | LookingAhead callouts | ✅ Over-band callouts simplified **56 → 15** flagged (73%↓) with no loss of accuracy; residual are irreducibly term-dense exam lists (advisory checker). |
| 5 · Integrate / test / doc | invariants + this doc | ✅ All invariants pinned by tests (below); checkpoint written. |

## The visual library (Phase 3, the headline build)

`ShapeDiagramRegistry` maps all **76** keys (4 per chapter × 19 science
chapters) to a SwiftUI factory. Diagrams live in
`desktopAhaan/Subjects/Tutor/Surfaces/ShapeDiagrams/Chapter{1..19}ShapeDiagrams.swift`
over a shared `ShapeDiagramKit` (SDFigure / SDLabel / SDChip / SDArrow / SDPlus /
SDLeafShape / SDFingerShape).

Big-Sur / legacy-GPU discipline held throughout:
- **Path / primitive Shape only** — no Canvas, no Charts (the ch13 distance-time
  and speed graphs are hand-drawn with `Path`), no MapKit, no macOS-12+ APIs.
- **Static geometry** — no animation, no randomness; cheap to rasterise on the
  AMD R9 M290X.
- **Palette** via `Color.compat*` / system primaries (never raw
  `.mint/.teal/.cyan/.indigo/.brown`, never `.foregroundColor(.orange/.yellow/.teal)`).
- **SF Symbols** routed through `SFSymbolCompat.name(_:)`, kept to SF Symbols 1/2
  glyphs that exist on Big Sur.
- **ViewBuilder ≤ 10 children** (Group buckets), **no force-unwrap**, **≤ 600
  LOC/file**.

## Invariants pinned by tests (the v7 safety net)

| Invariant | Test(s) |
|-----------|---------|
| Every Sanskrit NEP chapter has a bespoke Discover interactive | `SanskritInteractiveGateTests.testEveryNEPChapterResolvesToTheInteractive`, `SanskritDiscoverModeRoutingTests.testEveryNEPChapterCanFillTheSceneShape` |
| Every Social Science chapter has a bespoke Discover interactive | `SocialScienceInteractiveGateTests.testEveryChapterResolvesToAnInteractive`, `SocialScienceDiscoverModeRoutingTests.testEveryChapterCanFillTheNineSceneShape` |
| Subject gates are mutually exclusive (no cross-subject leak) | `SanskritInteractiveGateTests.testSubjectGatesAreMutuallyExclusive` / `…PackDoesNotEnableOtherGates`; `SocialScienceInteractiveGateTests.testScienceAndSocialScienceGatesAreMutuallyExclusive` / `…DoesNotEnableSciencePilot` |
| Legacy Sanskrit `ch01` deck stays Discover-free | `SanskritDiscoverModeRoutingTests.testEveryNEPChapterHasDiscoverAndLegacyDeckDoesNot` |
| Every authored ShapeDiagram key resolves to a factory (76/76) | `ShapeDiagramRegistryTests.testEveryPackDiagramKeyIsRegistered` |
| No orphan diagram registration; unregistered key → nil placeholder | `ShapeDiagramRegistryTests.testNoOrphanRegistrations` / `testUnregisteredKeyReturnsNil` |
| Per-chapter diagram completeness floor (ch01–ch19) | `ShapeDiagramRegistryTests.testFullyCoveredChaptersAreComplete` |

## Green status at close

- **810 XCTest, 0 failures** + 66 swift-testing, on the deploy environment via
  `scripts/ci-build-test.sh` (Release BUILD + Debug test suite).
- **17 Big-Sur lints + `test_lints.py`** clean; two commit-time T2 ratchets
  intact.
- Reading-level checker (advisory): 15 callouts over grade 13, down from 56.

Every milestone was committed only after lints + build + tests were green here,
then `git pull --rebase --autostash` + push. Additive throughout; zero
regressions; zero STOP_AND_ASK.

V7_DISCOVER_DEPTH_COMPLETE_SENTINEL_v1
