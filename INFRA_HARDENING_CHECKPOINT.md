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

### IH1 RESULT — build-mutex VALIDATED, push deferred (cross-agent compile break)

The mutex works. A real push (commit `178fb41`) ran the gate through
`build-mutex.sh` with isolated DerivedData `/tmp/dd-agent-C-push-<pid>`:
xcodebuild proceeded with **no contention deadlock and no OOM** — the exact
v2 failure mode is fixed. The push itself was blocked only by a transient
cross-agent compile break: Agent A's in-flight Adaptive Practice work
(`AdaptiveDifficultyEngine.swift`, untracked, not yet in the target's compile
sources) makes `AdaptiveDifficultyBandTests` fail to resolve the symbol. That
is Agent A's domain, mid-wiring in the shared working tree — not Agent C code.
Per the no-`--force`/no-`--no-verify` rule, the push is **deferred** and
retried later; commit `178fb41` is an ancestor of HEAD, so it ships the
moment any agent lands a clean push of a compiling tree.

Also observed: Agent B append-edited `scripts/hooks/pre-push` (a "Release DMG
validity (tag pushes only)" block calling `check_release_dmg_validity.sh`).
Append-only coexistence held — my mutex block (≈L54-83) and B's tag block
(≈L85-106) both present; I preserve B's addition on any future hook edit.

- [x] IH0 — baseline gate + checkpoint scaffold + read blocker
- [x] IH1 — build-mutex.sh + pre-push wiring + smoke test (push deferred, see above)
- [x] IH2 — clean_overnight_artifacts.sh + run_overnight_v3_3agents.sh (committed b7186a1)
- [x] IH3 — check_dmg_clean_install.sh (committed 7da8bc0; synthetic-DMG + corrupt-DMG verified)
- [x] IH4 — check_app_icon_completeness.py + advisory wiring (selftest + real tree clean)
- [x] IH5 — run_overnight_template.sh (reusable engine; dry-run validated)
- [x] IH6 — docs: README + INSTALL + DISTRIBUTION (single-targeted additions)
- [x] IH7 — mutex serialization proof: two concurrent `build-mutex.sh xcodebuild
      -version` serialized cleanly (second waited ~5s for the first; no interleave)
- [ ] IH8 — sentinel (final commit)

## Verification summary

| Deliverable | Verified |
|---|---|
| `build-mutex.sh` | 3 concurrent workers serialized; stale/corrupt holder reclaim; exit-code passthrough; no-arg→rc2 |
| pre-push wiring | live hook wraps `ci-build-test.sh` in mutex; coexists with Agent B's tag-DMG block + my icon advisory |
| `clean_overnight_artifacts.sh` | stale dd-agent removed, fresh survived, idempotent, dead-holder lock cleared, /tmp→/private/tmp symlink fix |
| `run_overnight_v3_3agents.sh` | dry-run validates 3 agents + per-agent DD paths; launches nothing without prompts; pre-flight clean runs |
| `check_dmg_clean_install.sh` | no-DMG WARN(0); synthetic ad-hoc DMG 7 pass/1 warn PASS; corrupt DMG FAIL(1) |
| `check_app_icon_completeness.py` | --selftest 4/4; real tree clean (10/10 entries, correct dims); strict+advisory modes |
| `run_overnight_template.sh` | sourced + direct dry-run; enforces per-agent DD invariant |
| mutex xcodebuild proof | two concurrent `xcodebuild -version` serialized |

## Cross-agent note

This was a live 3-way run (Agents A=Adaptive Practice, B=Cert/crashlog/DMG, C=this).
Commits raced HEAD locks repeatedly (retried, no loss). Commits/pushes are gated
by whole-tree pre-commit lints (`check_macos12_apis`, `check_viewbuilder_limit`
scan the working tree, not just staged files), so Agent A's in-flight
`Views/Worksheet/WorksheetPrintRenderer.swift` (macOS-12 API + ForEach
tuple-keypath, mid-AP3) transiently blocks ALL agents' commits until A finishes
that file. IH1/IH2/IH3 landed in clean windows; IH4–IH6 + sentinel batch-commit
on the next clean window. No `--no-verify`, no `--force` ever used.

## STOP_AND_ASK count: 0
