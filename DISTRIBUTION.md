# Distribution runbook (developers)

How to cut a release `.dmg` of desktopAhaan that a non-developer can install on
a fresh Mac. This is the developer-facing companion to the end-user
[INSTALL.md](INSTALL.md).

## TL;DR

```bash
# 1. (optional) bump the version — see "Versioning" below
# 2. pre-flight: metadata, entitlements, icons, zero-warning Release build
bash scripts/check_release_build.sh

# 3. build the DMG (ad-hoc signed by default)
bash scripts/build_release_dmg.sh
#    → dist/desktopAhaan-v<version>-<git-sha>.dmg

# 4. sanity-check and ship
hdiutil verify dist/desktopAhaan-v*.dmg
```

Upload the resulting `.dmg` to wherever you distribute (a GitHub release, a
shared folder, AirDrop to the iMac, …) along with a copy of `INSTALL.md`.

## What the scripts do

| Script | Role |
|---|---|
| `scripts/check_release_build.sh` | Pre-flight sanity. Verifies `CFBundleShortVersionString` + `CFBundleVersion` are non-empty, `MACOSX_DEPLOYMENT_TARGET == 11.5`, the locked 5-key entitlement set is present, all 10 AppIcon PNGs exist, and (unless `--no-build`) that Release compiles with **zero warnings**. Exit 0 = safe to package. |
| `scripts/build_release_dmg.sh` | The packager. Runs the pre-flight (`--no-build`), archives Release, obtains the `.app`, stages it with an `/Applications` symlink + a `README.txt`, and produces a compressed (`UDZO`) DMG named `desktopAhaan-v<version>-<git-sha>.dmg` under `dist/`. |
| `scripts/install-receipt.sh` | The "what's installed, and where" map — every path the app touches, with `--check` and `--uninstall-hint` modes. Reference it for support and uninstall. It never mutates anything. |

All three are Big Sur-compatible: they use only `xcodebuild`, `hdiutil`,
`ditto`, and `PlistBuddy`/`awk` — nothing newer than the 11.5 toolchain.

## Signing

Two paths, selected by whether `$DEVELOPMENT_TEAM` is set:

### Ad-hoc (default — works headless, no Apple Developer account)

```bash
bash scripts/build_release_dmg.sh
```

Signs with the ad-hoc identity (`-`) via
`desktopAhaan/Config/DevSigning.xcconfig`. The sandbox + entitlements still
apply. On the user's Mac this triggers the one-time Gatekeeper "cannot be
checked for malware" prompt — [INSTALL.md](INSTALL.md) Step 4 documents the
right-click → Open → Open Anyway flow that clears it. This is the right choice
for sideloading to a single known iMac.

### Developer ID (for wider distribution / notarization)

```bash
DEVELOPMENT_TEAM=TQM5Y6FG3Z \
CODE_SIGN_IDENTITY="Developer ID Application" \
EXPORT_METHOD=developer-id \
bash scripts/build_release_dmg.sh
```

This runs a real `xcodebuild -exportArchive` with a generated
`ExportOptions.plist`. After producing the DMG you can notarize it:

```bash
xcrun notarytool submit dist/desktopAhaan-v*.dmg \
    --apple-id <id> --team-id TQM5Y6FG3Z --password <app-specific-pw> --wait
xcrun stapler staple dist/desktopAhaan-v*.dmg
```

A notarized + stapled DMG installs with no Gatekeeper prompt at all.

## Versioning

Version + build number live in the Xcode build settings
(`MARKETING_VERSION` / `CURRENT_PROJECT_VERSION`), surfaced as
`CFBundleShortVersionString` / `CFBundleVersion`. Today: `1.0` / `1`.

To bump, edit the values in `desktopAhaan.xcodeproj/project.pbxproj` (both the
Debug and Release build configs), or set them in Xcode → target → General. The
DMG filename and the in-app **What's New** sheet both read the marketing
version, so a bump flows through automatically. Re-running
`scripts/generate_compat_pbxproj.py` is **not** needed for a version bump (it
regenerates file references, not build settings).

> If you bump the marketing version, a returning user will see the **What's
> New** sheet on next launch (the app advances its "last seen version" cursor).
> A brand-new install is shielded from it by the first-launch onboarding gate
> in `desktopAhaanApp.swift`.

## First-launch experience

A fresh install shows the 4-page `FirstLaunchTourView` (Welcome → Three
subjects → Daily Practice → Open Science Ch.1). The gate lives in
`desktopAhaanApp.swift` and is keyed on
`OnboardingState.hasSeenOnboardingKey`; it also suppresses the legacy 3-panel
welcome tour + What's New so the child sees exactly one onboarding. Both can be
replayed from the **Help** menu.

## Per-agent DerivedData policy

When several Claude agents run in parallel on one checkout (overnight runs —
see `scripts/run_overnight_v3_3agents.sh`), their build gates must not share
build artifacts. Two rules, both enforced by the launcher and the hooks:

- **Every agent uses its own DerivedData path** — `/tmp/dd-agent-<LETTER>-<PID>`,
  never a shared `${TMPDIR}/desktopAhaan-ci-derived`. The launcher exports it
  as both `CI_DERIVED_OVERRIDE` (read by `scripts/ci-build-test.sh`, the
  pre-push gate) and `XCODEBUILD_DERIVED_DATA_PATH` (for any per-commit
  `xcodebuild -derivedDataPath` block).
- **The pre-push gate's `xcodebuild` is serialized** behind
  `scripts/hooks/build-mutex.sh` (a BSD-portable `flock` shim), so even two
  gates firing at the same instant never run two heavy builds at once.

**Rationale.** In the v2 run all three agents' gates shared one TMPDIR
DerivedData path. Concurrent `xcodebuild` jobs (7–8 observed) corrupted each
other's module caches and OOM-killed the 8 GB Late-2014 iMac's Swift compiler;
one gate hung 37+ min and the run's push had to be deferred (commit `b7118dd`).
Isolated paths remove the shared state; the mutex caps concurrent builds at one.
`scripts/clean_overnight_artifacts.sh` (run pre-flight by the launcher) GCs
stale `/tmp/dd-agent-*` paths so they don't accumulate across runs.

## Release checklist

- [ ] `bash scripts/check_release_build.sh` is green (zero warnings).
- [ ] `bash scripts/ci-build-test.sh` is green (full test suite + lints).
- [ ] Version/build bumped if this is a user-visible release.
- [ ] `bash scripts/build_release_dmg.sh` produced `dist/desktopAhaan-v*.dmg`.
- [ ] `hdiutil verify dist/desktopAhaan-v*.dmg` passes.
- [ ] Installed the DMG on a clean account / VM and confirmed:
      app launches, the welcome tour shows, a subject opens.
- [ ] Uploaded the DMG + `INSTALL.md` to the distribution channel.
