# UITEST_COVERAGE_CHECKPOINT.md

**Date:** 2026-06-02
**Scope:** Taxonomy T2 — XCUITest coverage of the propagated Science
interactives (sandboxes + tours) and the HomeExperiments sheet.
**Commits:** `6e7969c` (walks + pbxproj), `0656399` (ratchets).

---

## What this run added

### Newly-covered surfaces (14 new XCUITest walks)

**Tours** — `desktopAhaanUITests/PropagatedToursUITests.swift`
(open chapter → CTA exists → click → first-stop title → close → CTA re-mounts):

| Ch. | CTA accessibilityLabel | First-stop title | Close label |
|----|------------------------|------------------|-------------|
| 2  | `Inside the digestive system — five-stop tour` | `Mouth — chewing + saliva` | `Close digestive tour` |
| 10 | `Inside an alveolus — five-stop respiratory tour` | `At the nostril — first filter` | `Close alveolus tour` |
| 11 | `The xylem ascent — five-stop tour of water rising up a plant` | `At a root hair — water enters by osmosis` | `Close xylem tour` |
| 15 | `Inside the lens — five-stop refraction tour` | `Light leaves a distant object` | `Close lens tour` |

(Ch.1 leaf tour + Ch.14 wire tour were already covered in `GoldenPathUITests`.)

**Sandboxes** — `desktopAhaanUITests/PropagatedSandboxesUITests.swift`
(open chapter → container label exists → tap explainer toggle → assert the
toggle flips to its expanded label):

| Ch. | Container accessibilityLabel | Toggle (collapsed → expanded) |
|----|------------------------------|-------------------------------|
| 1  | `Build-a-plant sandbox`       | `Why does this happen?` → `Hide explanation` |
| 4  | `Build-a-heat-flow sandbox`   | `Why does this happen?` → `Hide explanation` |
| 5  | `Build-a-pH sandbox`          | `What is pH actually measuring?` → `Hide explanation` |
| 6  | `Build-a-reaction sandbox`    | `Why does this happen?` → `Hide explanation` |
| 7  | `Build-a-climate sandbox`     | `Why these four factors?` → `Hide explanation` |
| 8  | `Build-a-wind sandbox`        | `Why does the wind curve?` → `Hide explanation` |
| 9  | `Build-a-soil sandbox`        | `Why is loam the ideal?` → `Hide explanation` |
| 13 | `Build-a-motion sandbox`      | `Show the formulas` → `Hide formulas` |
| 16 | `Build-a-water-cycle sandbox` | `Why does the level drop even when it rains?` → `Hide explanation` |

**HomeExperiments** — `desktopAhaanUITests/HomeExperimentsUITests.swift`:
open Ch.1 → tap the `Try at Home` card → assert first experiment
`Iodine starch map of a leaf` → Escape (`.cancelAction`) → card re-mounts.

Every queried string is copied verbatim from source
(`ChapterDetailView+PropagatedCTAs.swift`, the per-tour/-sandbox views under
`Subjects/Tutor/Surfaces/ChNN/`, `ChapterDetailView+HomeExperiments.swift`).

### The two ratchet lints (deterministic, AX-free, no-build)

1. **`scripts/check_critical_uitest_presence.py`** (K.2 pattern) — its
   `REQUIRED` manifest grew 8 → 22 with the 14 new method names. A
   rename/deletion of any pinned walk fails at commit/push, no build needed.

2. **`scripts/check_uitest_label_coverage.py`** (new, T2) — derives every
   propagated contract label from source (tour/concept CTA accessibilityLabels
   in `ChapterDetailView+PropagatedCTAs.swift` + the `Build-a-… sandbox`
   container label of each `BuildA*Sandbox(...)` mounted there, resolved from
   its view under `Surfaces/`) and asserts each appears **verbatim** somewhere
   under `desktopAhaanUITests/`. 16 contract labels, all referenced. Catches
   both "added a CTA but no walk" and "drifted a label out from under its
   walk." Ships `--selftest` (label-present pass + label-missing /
   unresolved-mount flag).

Both are wired into the pre-commit chain (`scripts/hooks/pre-commit` sections
13 + 14) and self-tested by `scripts/test_lints.py`. Re-install with
`bash scripts/install-git-hooks.sh`.

---

## Honest verification status

**This dev Mac CANNOT prove the new walks pass green.** XCUITest needs an
Accessibility grant to the runner (`desktopAhaanUITests-Runner.app`); this Mac
has `CI_BUILD_TEST_FLAGS` unset and the bundle is `-skip-testing` by default.
Without the grant the clicks silently no-op and assertions fail by timeout.
**No "UI tests pass" claim is made here.**

What **is** proven on this Mac:
- **The UI-test target compiles** — `xcodebuild build-for-testing` →
  `** TEST BUILD SUCCEEDED **`, with all three new files in the object list.
- **Every queried label is grounded in real source** (tables above).
- **Both ratchets are green**, and `check_test_target_compat.py` is clean.
- `scripts/ci-build-test.sh` (non-UI) → Release BUILD + 801 XCTest +
  66 swift-testing, 0 failures.

### Authoritative green = the iMac `--ui` run

The iMac has AX granted and `export CI_BUILD_TEST_FLAGS=--ui` in its shell
profile, so its pre-push `scripts/ci-build-test.sh` already runs the UI bundle.
To drive the new walks explicitly there:

```
xcodebuild test \
  -project desktopAhaan.xcodeproj \
  -scheme desktopAhaan \
  -destination 'platform=macOS' \
  -only-testing:desktopAhaanUITests/PropagatedToursUITests \
  -only-testing:desktopAhaanUITests/PropagatedSandboxesUITests \
  -only-testing:desktopAhaanUITests/HomeExperimentsUITests
```

(Or `bash scripts/ci-build-test.sh --ui` for the GoldenPathUITests stage as
wired today; extend that stage's `-only-testing` list to include the three new
classes when running the full propagated set on the iMac.)

---

## Deferred (gravy, not core deliverable)

The Social Science bespoke interactives (`socialScienceInteractives` in
`ChapterDetailView+PropagatedCTAs.swift` — `IndiaPhysiographicExplorer`,
`PreambleExplorer`, `BarterToMoneySim`, etc.) have **no smoke walk**. They use
dynamic, interpolated accessibility labels (e.g. `"\(region.name), …"`) and
lack a stable container identifier, and SS chapters don't ship the
`try-discover-mode` mount proxy the science `openChapter` helper keys on — so a
grounded, non-fragile walk would need new helpers and source-side hooks. Out of
T2's propagated-pilot scope; the new label-coverage ratchet does not (and is
not meant to) cover SS. This is the only remaining T2 gap; the row is kept
honestly at 🟡 for it.
