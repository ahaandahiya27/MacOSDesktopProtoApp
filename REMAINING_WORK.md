# Remaining Work — 2026-06-23 close-out

Snapshot of what's left between "everything code-side actionable is closed"
and "the app is fully ✅". Three buckets — each is a different machine /
person's job to close.

Source-of-truth ledger: `docs/ISSUE_CATEGORIES.md`. As of this turn:

```
✅: 317   🟡: 101   ❌: 8
```

---

## Bucket A — Dev-Mac closable (code)

**Empty.** Every actionable code-side row is now either closed or
locked by a lint that prevents regression.

Recent dev-Mac closures and the ratchet that locks each:

| Row | Action | Ratchet |
|-----|--------|---------|
| MO4 | All per-scene `withAnimation` calls gated for Reduce Motion (5 fixes in `fbe0afc`) | `scripts/check_withanimation_motion.py` (LH005b) — runs in pre-commit + ci-build-test, scans 531 Swift files |
| T3 | `NavigationSmokeUITests.swift` confirmed in the UITests target's Sources build phase (verified via `grep` of pbxproj) | `scripts/check_critical_uitest_presence.py` + `scripts/check_uitest_label_coverage.py` |
| H2 | `.help(...)` + `.accessibilityHint(...)` on every chrome control | `scripts/check_a11y_labels.py` + `scripts/check_a11y_identifier_uniqueness.py` |
| J8 | Spacing + radius routed through `DesignTokens.{Spacing,Radius}` | `scripts/check_designtokens_spacing.py` + `scripts/check_designtokens_radius.py` |
| (sidebar entries for Boss Challenge + Brutal Series) | New `SidebarTool.bossChallenge` + `.brutalSeries` cases + detail-pane dispatcher routes | `desktopAhaanTests/SidebarToolPapersRouteTests.swift` (7 cases) |

Active commit-time gates (40 lints, all passing on the current HEAD):

```
check_lifetime_hazards (LH001–LH006)    check_view_mainactor
check_macos12_apis                       check_sf_symbols_compat
check_swift55_syntax                     check_file_size (≤ 600 LOC)
check_viewbuilder_limit (≤ 10 children)  check_viewbuilder_depth
check_inline_modifier_math               check_appstorage_keys_routing
check_particle_budget                    check_combine_sink_weakself
check_withanimation_motion (LH005b)      check_return_in_viewbuilder
check_mainactor_closure_refs             check_designtokens_spacing
check_designtokens_radius                check_a11y_labels
check_a11y_identifier_uniqueness         check_a11y_hint_coverage
check_color_rgb_centralized              check_pack_schema
check_testpaper_triplet                  check_critical_uitest_presence
check_uitest_label_coverage              check_network_egress
check_mainactor_unsendable               check_color_literals
... plus content / verification scripts
```

If a future change introduces a new actionable defect, the relevant
lint either catches it at commit (most categories) or the per-commit
`bash scripts/ci-build-test.sh` gate catches it before push (build
warnings, test failures, file-size overflow, etc.).

---

## Bucket B — iMac-only (visual verify)

**~31 rows** — every one is a docs/ISSUE_CATEGORIES.md 🟡 or ❌ that
needs a real Big-Sur iMac eyeball (perception, focus rings on light
canvases, Instruments runs, sleep/wake recovery, AX-granted UI-test
run). The walk is enumerated in `IMAC_VERIFY_CHECKLIST.md` (19 numbered
rows, each with exact menu path + what "correct" looks like + the
taxonomy ID to flip).

Taxonomy IDs awaiting iMac verification (grouped):

- **Display / layout**: `J4`, `LY6`, `TY1`, `LY2`
- **Dynamic Type at L/xL**: `H4`, `TY4`
- **Dark Mode end-to-end render**: `J1`, `TH1`, `TH5` (Ch 8–18 legacy CSS)
- **Sidebar/canvas mode separation**: `CL3`, `TH2`
- **Contrast (WCAG AA)**: `H6`
- **Increase Contrast / Reduce Transparency**: `TH7`, `TH8`
- **Keyboard nav + focus ring on light tints**: `H7`, `H8`, `CN5`
- **First-launch onboarding feel**: `EM3`
- **Sleep / wake recovery**: `LC8`
- **AX-granted UI test runs**: `T3` (navigation smoke), `T2` (Social Science walks)
- **Instruments runs (Time Profiler / Leaks / Energy)**: `DG3`, `DG4`, `DG8`

How to close: walk `IMAC_VERIFY_CHECKLIST.md` top-to-bottom on the
iMac after `bash scripts/imac-pull.sh`. For each pass, paste
"row N (ID) ✅" back to the dev Mac; for each fail or defer, paste
"row N (ID) ❌ because …" / "defer because …".

---

## Bucket C — Deliberate non-bugs

**~70 rows** marked 🟡 in `docs/ISSUE_CATEGORIES.md`. Each has a
documented design decision in its row note. No action.

Common reasons they sit at 🟡 forever:

- **`intentional`** — explicit design choice (e.g. `TH3`: ChapterTheme
  hardcoded RGB because Discover canvas is intentionally fixed-light;
  auto-adapting would break contrast invariants).
- **`macOS convention`** — platform-standard behavior the audit
  initially flagged as inconsistent (e.g. `CL3`: NavigationView's
  vibrant sidebar + light canvas — matches Mail, Notes, Reminders).
- **`dup of`** — secondary taxonomy ID that points back to the primary
  row (e.g. `LY6` is dup of `J4`, `TY4` is dup of `H4`, `TH2` is dup
  of `CL3`).
- **`future content work`** — per-scene authoring not a chrome fix
  (e.g. `DM1`: each scene illustrates its own subject; adding anatomy
  labels is 152 scene-level design passes).
- **`per-scene decision`** — content judgment intentionally varied
  (e.g. `LY1`: per-scene `Spacer()` placement; `LY8`: alignment
  per-scene; `HR3`/`HR4`/`HR5`: density hierarchy authored per scene).
- **`scope: no 3rd-party dep`** — would need a forbidden package
  (e.g. `T4`: pixel snapshot tests would need a 3rd-party framework;
  the fingerprint-snapshot pattern in `Ch2_19_StructuralRatchetTests`
  is the dev-Mac substitute).
- **`pending content sweep`** — TestPapers QA, per-concept `pageRefs`
  audit (`Y3`) — content-team work, not chrome.

The full list with one-line rationales is in the corresponding row
notes of `docs/ISSUE_CATEGORIES.md`. Searching the file for
`**intentional**` / `**macOS convention**` / `**partial coverage**` /
`**dup of**` / `**future content work**` surfaces each cluster.

---

## Confirmation

**Every code-side actionable row is now closed or lint-blocked from
regressing.** The dev Mac has no remaining surface to fix without
either (a) the iMac walking `IMAC_VERIFY_CHECKLIST.md` and reporting,
or (b) the content team's standing TestPapers / page-refs sweep
completing. The only path to a pure / issue-less state is those two
external workflows — there's nothing left for the dev-Mac code side to
do that wouldn't be re-doing work the existing lints + tests already
enforce.

Pre-commit gate active on every push:

```
Debug + Release builds         : 0 warnings, target = MACOSX_DEPLOYMENT_TARGET 11.5
40 lints                       : all clean (selftest fixtures embedded)
66 swift-testing + 80+ XCTests : all green
science_class7.json round-trip : clean
file-size ceiling              : 600 LOC (2 allowlisted exceptions)
no new force-unwrap / ungated-animation / raw-color / macOS-12-API
git status clean before push
```

If/when the iMac walk surfaces a regression that wasn't caught by a
lint, the right close-out is: ship the fix + ship a new lint that
would have caught it. That's how the 40-rule suite grew.
