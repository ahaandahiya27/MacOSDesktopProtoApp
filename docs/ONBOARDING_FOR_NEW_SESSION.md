# Onboarding for a new Claude session

A 5-minute orientation for any future Claude session arriving cold to the
`desktopAhaan` repo. Read this AFTER `CLAUDE.md`; this file is the
navigation index, `CLAUDE.md` is the working agreement.

## Where to look for state

| Question | Answer source |
|---|---|
| What's the working agreement? Hard platform constraints? | `CLAUDE.md` (top of repo) |
| Is everything green? | Run `bash scripts/ci-build-test.sh` — 38 lints + build + tests + 3-pack round-trip |
| What categories of bug / risk are tracked? | `docs/ISSUE_CATEGORIES.md` (A–Y) — flip rows ✅ when you close them |
| What's the bug-free certification status? | `BUG_FREE_CERTIFICATION_REPORT.md` (110 categories, current: 110/110 ✅) |
| What's the production-readiness status? | `PRODUCTION_READINESS_REPORT.md` (per-criterion table) |
| Per-subject state? | `MATHS_READINESS_REPORT.md`, `SANSKRIT_READINESS_REPORT.md`, `IMAC_READINESS_REPORT.md` |
| Latest session handoff notes? | `../OVERNIGHT_BUILD_CHECKPOINT.md` and `../PRODUCTION_POLISH_CHECKPOINT.md` at the repo parent |
| What sessions shipped historically? | `REMEDIATION_LOG.md` — chronological |
| Open content / UX items? | `POLISH_TODOS.md` |

## Verifying the gate in 30 seconds

```bash
cd /Users/mac/Documents/Claude/Projects/DesktopAhaan/DesktopAhaan/desktopAhaan
bash scripts/ci-build-test.sh
```

Expect: `==> ci-build-test PASSED`. The script also runs as the pre-push
hook, so every commit on `origin/main` is already gated through it.

## The 38 lints (canonical list lives at `scripts/check_*.py`)

Each lives at `scripts/check_*.py`. Wired into `scripts/ci-build-test.sh` for
push, and 4 of them also run as a pre-commit ratchet
(`check_critical_uitest_presence` + `check_uitest_label_coverage` for T2,
`check_designtokens_spacing` + `check_designtokens_radius` for J8).

To list them all (rather than embedding a brittle table here that drifts every
time a lint is added):

```bash
ls scripts/check_*.py | xargs -n1 basename
```

Broad categories the lints cover today:
- **Big-Sur compat:** `check_macos12_apis`, `check_swift55_syntax`, `check_sf_symbols_compat`, `check_test_target_compat`
- **SwiftUI safety:** `check_viewbuilder_limit`, `check_viewbuilder_depth`, `check_inline_modifier_math`, `check_return_in_viewbuilder`, `check_view_mainactor`, `check_mainactor_closure_refs`
- **Lifetime / concurrency:** `check_lifetime_hazards` (LH001-006), `check_combine_sink_weakself`, `check_kvo_observer_leak`, `check_notificationcenter_leak`, `check_race_and_deadlock`
- **Content / pack integrity:** `check_pack_schema`, `check_cross_pack_ids`, `check_orphan_refs`, `check_orphan_html`, `check_article_entry_bundled`, `check_quiz_id_format`, `check_page_ref_bounds`, `check_callout_reading_level`, `check_appstorage_keys_routing`, `check_testpaper_triplet`
- **Design tokens (J8):** `check_designtokens_spacing`, `check_designtokens_radius`
- **A11y / UI tests:** `check_a11y_labels`, `check_color_literals`, `check_wcag_contrast`, `check_critical_uitest_presence`, `check_uitest_label_coverage`
- **Persistence / process:** `check_atomic_writes`, `check_network_egress`, `check_file_size`, `check_dead_swift_types`, `check_particle_budget`, `check_app_icon_completeness`

## Three quick wins for a fresh session

1. **Check the test count.** `find desktopAhaanTests -name "*.swift" | xargs grep -cE "^\\s*(@MainActor\\s+)?func test"` — should report 835+. If lower, a test was deleted somewhere.
2. **Check the lint count.** `ls scripts/check_*.py | wc -l` should report 38. If different, a lint was added/removed since this doc.
3. **Check pack-decode performance.** `python3 scripts/perf_pack_decode.py` — each pack should report <50 ms. If higher, content bloat snuck through.

## What's worth tackling next

Cert is at full parity, so genuine continuation work is editorial / running-app:

- **Visual verification on iMac:** Increase Contrast, Reduce Transparency, Dynamic Type at xxxLarge, focus traversal via keyboard. None of these can be statically lint-checked; they need eyes.
- **Sanskrit Discover Mode pilot:** out of scope per `SANSKRIT_READINESS_REPORT.md` but a natural next sweep.
- **More maths Discover UI test breadth:** `MathsDiscoverWalkUITests` covers Ch.5 + Ch.10; the other 13 chapters could each get a smoke walk.
- **Content depth:** every concept already has 4 explanation depths + reasoning + ≥3 useCases + beyondTheBook + mnemonic + predictQuestion + whyChain, but editorial polish on the reading level + cultural anchoring is open-ended.

## Watch out for

- Don't auto-launch the `run_*.sh` dangerous-mode wrappers at the repo parent — they're for unattended overnight runs the user explicitly opts into, not for "go ahead" prompts. See `[[feedback-parallel-and-wrappers]]` in `~/.claude/projects/-Users-mac/memory/`.
- Don't introduce a Swift Package or third-party framework — Big Sur 11.7.11 toolchain constraints make dep management brittle.
- Don't bypass `check_swift55_syntax.py` — the iMac's Xcode 13.2.1 / Swift 5.5 rejects `if let foo {` shorthand.
- Pack JSON edits MUST use `json.dumps(d, ensure_ascii=False, indent=2) + "\n"`. `verify_pack_roundtrip.py` compares byte-for-byte; `indent=1` or a missing trailing newline silently fails.

## If you find this doc stale

It's an index; the linked docs are the source of truth. When a number
shifts (lint count, test count, cert score), update CLAUDE.md's
"Current status" section + this doc in the same commit so they stay
synchronized.
