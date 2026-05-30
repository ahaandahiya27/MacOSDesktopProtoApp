# INFRA_HARDENING_CHECKPOINT.md

Agent C · Parallel Overnight v3 · Infra Hardening (DerivedData isolation +
build mutex + DMG clean-install verification + icon completeness).

Sentinel on completion: `INFRA_HARDENING_COMPLETE_SENTINEL_v1`.

## Mission

Fix the deferred-push blocker recorded in `b7118dd`
("docs(dist): record deferred-push blocker — parallel gate DerivedData
contention"): every parallel agent's pre-push gate shared one TMPDIR
DerivedData path, so 3-way concurrent `xcodebuild` runs corrupted each
other's module caches and OOM-killed the Late-2014 iMac's compiler. Harden
the launcher so future runs give each agent an isolated DerivedData path,
add a machine-wide build mutex as a second-tier guarantee, validate the
produced DMG installs cleanly, and assert the app icon is complete.

## Baseline gate (IH0) — GREEN

- `bash -n` clean on `scripts/hooks/pre-push` and `scripts/hooks/pre-commit`.
- All gated `scripts/check_*.py` lints PASS.
- One advisory lint (`check_callout_reading_level.py`) exits 1 by design
  ("NOT a hard gate" per its own output); it is wired into **no** gate
  (verified: not in pre-commit, pre-push, or ci-build-test) and is content
  (out of Agent C's domain). Treated as green — the real gates pass. My
  per-commit gate excludes this advisory accordingly.

## Environment notes discovered at IH0

- **No `run_overnight_v2_3agents.sh` exists in the tree** — the v2 launcher
  was never committed (the v2 run was driven ad hoc). v3 launcher is
  authored from the spec rather than diffed from v2.
- **AppIcon path is `desktopAhaan/Assets.xcassets/AppIcon.appiconset/`**, NOT
  `desktopAhaan/Resources/Assets.xcassets/...` as the brief states. The icon
  set is already complete: 10 entries, all PNGs present at correct pixel
  dimensions (16/32/128/256/512 @1x/2x). No STOP_AND_ASK needed; the checker
  globs for the real path.
- **No `dist/` directory / no DMG present** — `check_dmg_clean_install.sh`
  degrades to a WARN/skip when no DMG is found (Agent B builds the DMG).
- `scripts/ci-build-test.sh` already honours `CI_DERIVED_OVERRIDE` and
  defaults `DERIVED` to `${TMPDIR:-/tmp}/desktopAhaan-ci-derived` (the shared
  path that caused the contention). The fix is to give each agent its own
  path AND serialize the gate's xcodebuild via the mutex.

## Phase status

- [x] IH0 — baseline gate + checkpoint scaffold + read blocker
- [ ] IH1 — build-mutex.sh + pre-push wiring + smoke test
- [ ] IH2 — clean_overnight_artifacts.sh + run_overnight_v3_3agents.sh
- [ ] IH3 — check_dmg_clean_install.sh
- [ ] IH4 — check_app_icon_completeness.py + advisory wiring
- [ ] IH5 — run_overnight_template.sh (bonus)
- [ ] IH6 — docs: README + INSTALL + DISTRIBUTION
- [ ] IH7 — final gate + mutex serialization proof
- [ ] IH8 — sentinel

## STOP_AND_ASK count: 0
