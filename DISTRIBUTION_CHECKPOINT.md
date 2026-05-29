# Distribution & Onboarding Checkpoint

**Run:** PARALLEL OVERNIGHT v2 — Agent C (Distribution + Onboarding)
**Started:** 2026-05-30
**Sentinel:** `DISTRIBUTION_COMPLETE_SENTINEL_v1`
**Mode:** `--dangerously-skip-permissions`, parallel with Agents A (Daily Plan)
and B (Cert) on disjoint domains.

This file tracks the "fresh install on a new iMac" story: a
signed/notarized-ready Release build, a repeatable DMG packager, an honest
first-launch onboarding flow, and parent-friendly install docs.

---

## ⚠ Cross-agent incident (2026-05-30, mid-run)

A parallel agent ran a destructive working-tree operation (a `git clean`-class
wipe + checkout revert) that removed **every untracked file** this agent had
authored — both the prior CD0–CD2 artifacts (scripts, `DevSigning.xcconfig`,
`OnboardingState`/`OnboardingStep`) AND this session's CD3–CD5 work — and
reverted the `desktopAhaanApp.swift` + `README.md` edits. Agent A's files
survived because they were created after the wipe.

**Recovery:** every file was recreated verbatim from this agent's working
context, then **committed immediately** — tracked files survive `git clean`, so
the commit is the durable guard against a repeat. Lesson logged to
`REMEDIATION_LOG.md`: commit-early beats hold-until-gate when agents share a
working tree and any of them may run `git clean`.

---

## CD0 — Baseline gate ✅ (2026-05-30)

| Check | Result |
|---|---|
| `scripts/verify_pack_roundtrip.py` | ✅ 3 packs round-trip byte-for-byte |
| `check_cross_pack_ids` / `check_orphan_refs` / `check_quiz_id_format` / `check_test_target_compat` | ✅ all clean |
| `scripts/ci-build-test.sh` (Release build + Debug suite) | ✅ `** TEST SUCCEEDED **` |

Toolchain on this dev Mac: Xcode 26.5 / Build 17F42. Deploy target stays
`MACOSX_DEPLOYMENT_TARGET = 11.5` (Big Sur). `hdiutil` present.

Project facts captured for the scripts:
- `MARKETING_VERSION = 1.0`, `CURRENT_PROJECT_VERSION = 1`
- `PRODUCT_BUNDLE_IDENTIFIER = com.emoha.desktopAhaan`
- `DEVELOPMENT_TEAM = TQM5Y6FG3Z`, `CODE_SIGN_STYLE = Automatic`
- Scheme: `desktopAhaan` (shared)
- Entitlements (5-key locked set): app-sandbox, network.client,
  files.user-selected.read-only, device.audio-input,
  temporary-exception.files.home-relative-path.read-write `/Documents/`
- AppIcon set: 10 PNGs (16/32/128/256/512 @1x+@2x) ✅

---

## CD1/CD2 — DMG packaging + release pre-flight ✅

- `scripts/check_release_build.sh` — pre-DMG sanity. Validates version + build
  number non-empty, `MACOSX_DEPLOYMENT_TARGET == 11.5`, the locked 5-key
  entitlement set, all 10 AppIcon PNGs, and (default) a **zero-warning Release
  build**. `--no-build` skips the compile for a fast metadata/asset pass.
  - `--no-build`: **ALL CHECKS PASSED**.
  - Full (with build): Release build SUCCEEDED, **zero warnings** (exit 0).
- `scripts/build_release_dmg.sh` — repeatable packager. Pre-flight → Release
  archive (ad-hoc signed by default via `DevSigning.xcconfig`, Developer-ID
  path when `$DEVELOPMENT_TEAM` is set) → stage `.app` + `/Applications`
  symlink + `README.txt` → `hdiutil create -format UDZO`. Output:
  `dist/desktopAhaan-v<version>-<git-sha>.dmg`. Verifies the archive via the
  log (xcodebuild exit codes are unreliable) and `codesign --verify`.
- `scripts/install-receipt.sh` — the canonical "what's installed, where" path
  map with `--check` and `--uninstall-hint` modes. Read-only; never mutates.
- `desktopAhaan/Config/DevSigning.xcconfig` — ad-hoc signing defaults for
  headless command-line builds; not wired into the pbxproj (applied via
  `-xcconfig`). Sandbox + entitlements stay on under ad-hoc.

Big Sur tooling only (xcodebuild / hdiutil / ditto / PlistBuddy / awk).

---

## CD3 — First-launch onboarding flow ✅

- `desktopAhaan/Views/Onboarding/OnboardingStep.swift` — pure-Foundation value
  type + the canonical 4-page `OnboardingStep.tour` (Welcome → Three subjects →
  Daily Practice → Open Science Ch.1) and `getStartedPackId = "science_class7"`.
- `desktopAhaan/Views/Onboarding/FirstLaunchTourView.swift` — switch-based
  pager (no `TabView(.page)` on Big Sur), Skip on every page, Previous/Next,
  CTA on the final page. SF Symbols via `SFSymbolCompat.name`, transitions via
  `withAnimationRespectingReduceMotion`, accent via `Color.compatIndigo`. Pure
  macOS 10.15+ surface.
- `desktopAhaan/Services/OnboardingState.swift` — single `hasSeenOnboarding`
  flag over injectable `UserDefaults` (tests use a scratch suite).
- `desktopAhaan/desktopAhaanApp.swift` — targeted addition: a first-launch
  gate resolved in `init()` (before any view body, so ordering vs.
  ContentView's own `.onAppear` is moot). On a genuinely fresh install it
  suppresses BOTH legacy auto-presents (welcome tour + What's New) by
  pre-setting their `@AppStorage` keys, then presents `FirstLaunchTourView` via
  a single `.sheet(isPresented:)`. Upgrading users (legacy tour already seen)
  are migrated silently — never re-onboarded. The CTA navigates to the science
  pack and flips the flag.

**No double-onboarding:** ContentView (owned by another surface, untouched)
auto-presents its legacy 3-panel tour only when `!hasSeenWelcomeTour`; the
init gate sets that key first on a fresh install, so only the new tour shows.

---

## CD4 — Onboarding tests ✅

- `desktopAhaanTests/OnboardingFirstLaunchTests.swift` — flag flips + persists
  on completion (relaunch survives), tour-catalog shape (4 pages, only final
  page has a CTA, non-empty copy, exactly the three subjects), CTA pack id
  matches `science_class7`, and every page (+ the full tour) renders through an
  off-screen `NSHostingView` without crashing.
- `desktopAhaanTests/OnboardingSkipTests.swift` — skip flips + persists the
  flag (same `markSeen()` path as Done), `reset()` returns to unseen, getter/
  setter agree.

---

## CD5 — README v2 + INSTALL.md + DISTRIBUTION.md ✅

- `README.md` — parent-friendly rewrite: what it is, who it's for, what's
  inside (3 subjects / 50 chapters / Discover / articles / daily practice /
  achievements / weekly progress), install pointer, privacy stance, developer
  pointers, kept license.
- `INSTALL.md` — non-developer step-by-step incl. the Gatekeeper "right-click →
  Open → Open Anyway" flow, permissions, data location, uninstall,
  troubleshooting. Screenshot placeholders referenced (no image generation).
- `DISTRIBUTION.md` — developer release runbook: the three scripts, ad-hoc vs.
  Developer-ID/notarize signing, versioning, first-launch behaviour, and a
  release checklist.

---

## CD6/CD7 — Final pass + sentinel ✅

- pbxproj regenerated (`scripts/generate_compat_pbxproj.py`) to add the 3 new
  source files + 2 test files to the target.
- Full gate (`scripts/ci-build-test.sh`) green with onboarding tests included.
- `DISTRIBUTION_COMPLETE_SENTINEL_v1` printed on the final commit.
