#!/usr/bin/env python3
"""test_lints.py — self-test harness for the LH* lint rules.

Each lint rule has matching fixtures under `scripts/test_fixtures/`:
  - `<rule>_violation.swift` — the lint should flag this.
  - `<rule>_clean.swift`     — the lint should NOT flag this.

The harness imports `check_lifetime_hazards` and calls its per-rule
scan functions directly on the fixture paths, asserting the expected
violation count for each. Catches regressions where a regex change
silently breaks a rule and the lint goes from "hard gate" to "theater"
without anyone noticing.

Run from the repo root: `python3 scripts/test_lints.py`.

Exit codes:
  0 — every fixture pair behaved correctly.
  1 — one or more fixture pairs failed; see output for details.
"""

from __future__ import annotations

import importlib.util
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SCRIPTS = REPO_ROOT / "scripts"
FIXTURES = SCRIPTS / "test_fixtures"


def _import_lint_module(name: str):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / f"{name}.py")
    if spec is None or spec.loader is None:
        raise RuntimeError(f"could not load {name}.py")
    mod = importlib.util.module_from_spec(spec)
    # Python 3.14+: dataclasses use `sys.modules[cls.__module__].__dict__`
    # to resolve type hints. If the module isn't registered before
    # exec_module runs, that lookup returns None and dataclass init
    # blows up with `AttributeError: 'NoneType' object has no attribute
    # '__dict__'`. Register first, then exec.
    sys.modules[name] = mod
    spec.loader.exec_module(mod)
    return mod


def _count(violations, rule_prefix: str) -> int:
    return sum(1 for v in violations if v.rule_id.startswith(rule_prefix))


def _check(label: str, expected: int, actual: int) -> bool:
    ok = expected == actual
    flag = "PASS" if ok else "FAIL"
    print(f"  [{flag}] {label}: expected {expected}, got {actual}")
    return ok


def main() -> int:
    lh = _import_lint_module("check_lifetime_hazards")
    failures: list[str] = []

    print("== LH001 — var delegate without weak ==")
    v = lh._scan_var_delegate(FIXTURES / "lh001_violation.swift")
    if not _check("violation fixture flags exactly 1", 1, _count(v, "LH001")):
        failures.append("LH001 violation")
    v = lh._scan_var_delegate(FIXTURES / "lh001_clean.swift")
    if not _check("clean fixture flags 0", 0, _count(v, "LH001")):
        failures.append("LH001 clean")

    print("== LH002 — unowned anywhere ==")
    v = lh._scan_unowned(FIXTURES / "lh002_violation.swift")
    if not _check("violation fixture flags exactly 1", 1, _count(v, "LH002")):
        failures.append("LH002 violation")
    v = lh._scan_unowned(FIXTURES / "lh002_clean.swift")
    if not _check("clean fixture flags 0", 0, _count(v, "LH002")):
        failures.append("LH002 clean")

    print("== LH003 — @unchecked Sendable ==")
    v = lh._scan_unchecked_sendable(FIXTURES / "lh003_violation.swift")
    if not _check("violation fixture flags exactly 1", 1, _count(v, "LH003")):
        failures.append("LH003 violation")
    v = lh._scan_unchecked_sendable(FIXTURES / "lh003_clean.swift")
    if not _check("clean fixture flags 0", 0, _count(v, "LH003")):
        failures.append("LH003 clean")

    print("== LH004 — closure-capture strong-self ==")
    v = lh._scan_closure_captures(FIXTURES / "lh004_violation.swift")
    # Three sub-rules each fire once: LH004a (.sink), LH004b (Timer),
    # LH004c (.assign keypath). Combined count is 3.
    if not _check("violation fixture flags 3 (one per sub-rule)", 3, _count(v, "LH004")):
        failures.append("LH004 violation")
    v = lh._scan_closure_captures(FIXTURES / "lh004_clean.swift")
    if not _check("clean fixture flags 0", 0, _count(v, "LH004")):
        failures.append("LH004 clean")

    print("== LH005 — .animation without Reduce-Motion gate ==")
    v = lh._scan_animation_gate(FIXTURES / "lh005_violation.swift")
    if not _check("violation fixture flags exactly 1", 1, _count(v, "LH005")):
        failures.append("LH005 violation")
    v = lh._scan_animation_gate(FIXTURES / "lh005_clean.swift")
    if not _check("clean fixture flags 0", 0, _count(v, "LH005")):
        failures.append("LH005 clean")

    print("== LH005b — withAnimation imperative wrap without Reduce-Motion gate ==")
    v = lh._scan_withanimation_gate(FIXTURES / "lh005b_violation.swift")
    if not _check("violation fixture flags exactly 2", 2, _count(v, "LH005b")):
        failures.append("LH005b violation")
    v = lh._scan_withanimation_gate(FIXTURES / "lh005b_clean.swift")
    if not _check("clean fixture flags 0", 0, _count(v, "LH005b")):
        failures.append("LH005b clean")

    print("== LH006 — print() outside #if DEBUG ==")
    v = lh._scan_print_call(FIXTURES / "lh006_violation.swift")
    if not _check("violation fixture flags exactly 1", 1, _count(v, "LH006")):
        failures.append("LH006 violation")
    v = lh._scan_print_call(FIXTURES / "lh006_clean.swift")
    if not _check("clean fixture flags 0", 0, _count(v, "LH006")):
        failures.append("LH006 clean")

    # The Big Sur compile-safety lints carry their own embedded fixtures via a
    # `run_selftest()` entrypoint (no external fixture files). Drive them here
    # so the suite fails loudly if a regex edit silently breaks classification.
    print("== check_viewbuilder_limit — embedded --selftest ==")
    vb = _import_lint_module("check_viewbuilder_limit")
    if vb.run_selftest() != 0:
        failures.append("check_viewbuilder_limit selftest")

    print("== check_viewbuilder_depth — embedded --selftest ==")
    vd = _import_lint_module("check_viewbuilder_depth")
    if vd.run_selftest() != 0:
        failures.append("check_viewbuilder_depth selftest")

    print("== check_inline_modifier_math — embedded --selftest ==")
    imm = _import_lint_module("check_inline_modifier_math")
    if imm.run_selftest() != 0:
        failures.append("check_inline_modifier_math selftest")

    print("== check_appstorage_keys_routing — embedded --selftest ==")
    aks = _import_lint_module("check_appstorage_keys_routing")
    if aks.run_selftest() != 0:
        failures.append("check_appstorage_keys_routing selftest")

    print("== check_particle_budget — embedded --selftest ==")
    pb = _import_lint_module("check_particle_budget")
    if pb.run_selftest() != 0:
        failures.append("check_particle_budget selftest")

    print("== check_combine_sink_weakself — embedded --selftest ==")
    csw = _import_lint_module("check_combine_sink_weakself")
    if csw.run_selftest() != 0:
        failures.append("check_combine_sink_weakself selftest")

    print("== check_withanimation_motion — embedded --selftest ==")
    wam = _import_lint_module("check_withanimation_motion")
    if wam.run_selftest() != 0:
        failures.append("check_withanimation_motion selftest")

    print("== check_no_wkwebview — embedded --selftest ==")
    nww = _import_lint_module("check_no_wkwebview")
    if nww.run_selftest() != 0:
        failures.append("check_no_wkwebview selftest")

    print("== check_return_in_viewbuilder — embedded --selftest ==")
    rvb = _import_lint_module("check_return_in_viewbuilder")
    if rvb.run_selftest() != 0:
        failures.append("check_return_in_viewbuilder selftest")

    print("== check_mainactor_closure_refs — embedded --selftest ==")
    mc = _import_lint_module("check_mainactor_closure_refs")
    if mc.run_selftest() != 0:
        failures.append("check_mainactor_closure_refs selftest")

    print("== check_designtokens_spacing — embedded --selftest ==")
    dts = _import_lint_module("check_designtokens_spacing")
    if dts.run_selftest() != 0:
        failures.append("check_designtokens_spacing selftest")

    print("== check_designtokens_radius — embedded --selftest ==")
    dtr = _import_lint_module("check_designtokens_radius")
    if dtr.run_selftest() != 0:
        failures.append("check_designtokens_radius selftest")

    print("== check_a11y_identifier_uniqueness — embedded --selftest ==")
    aiu = _import_lint_module("check_a11y_identifier_uniqueness")
    if aiu.run_selftest() != 0:
        failures.append("check_a11y_identifier_uniqueness selftest")

    print("== check_color_rgb_centralized — embedded --selftest ==")
    crc = _import_lint_module("check_color_rgb_centralized")
    if crc.run_selftest() != 0:
        failures.append("check_color_rgb_centralized selftest")

    # The three Big-Sur deploy-target lints (added 2026-06-13). Each carries
    # its own embedded fixtures and a `run_selftest()` entrypoint, so a regex
    # edit that silently neuters the rule fails this suite loudly.
    print("== check_macos12_apis — embedded --selftest ==")
    m12 = _import_lint_module("check_macos12_apis")
    if m12.run_selftest() != 0:
        failures.append("check_macos12_apis selftest")

    print("== check_swift55_syntax — embedded --selftest ==")
    s55 = _import_lint_module("check_swift55_syntax")
    if s55.run_selftest() != 0:
        failures.append("check_swift55_syntax selftest")

    print("== check_sf_symbols_compat — embedded --selftest ==")
    sfc = _import_lint_module("check_sf_symbols_compat")
    if sfc.run_selftest() != 0:
        failures.append("check_sf_symbols_compat selftest")

    # The two T2 UI-test ratchets carry their own fixture-driven selftests
    # (no external fixture files). Drive them here so a regex edit that
    # silently neuters either ratchet fails the suite loudly.
    print("== check_critical_uitest_presence — embedded --selftest ==")
    cup = _import_lint_module("check_critical_uitest_presence")
    if cup.selftest() != 0:
        failures.append("check_critical_uitest_presence selftest")

    print("== check_uitest_label_coverage — embedded --selftest ==")
    ulc = _import_lint_module("check_uitest_label_coverage")
    if ulc.selftest() != 0:
        failures.append("check_uitest_label_coverage selftest")

    print()
    if failures:
        print(f"test_lints: FAIL — {len(failures)} broken rule(s):")
        for f in failures:
            print(f"  - {f}")
        return 1
    print("test_lints: PASS — every lint rule flags its violation fixture and ignores its clean fixture.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
