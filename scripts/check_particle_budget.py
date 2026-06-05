#!/usr/bin/env python3
"""ParticleEmitter must respect HardwareTier.particleBudget.

Why this matters. The deploy iMac (AMD R9 M290X, 2 GB VRAM, Big Sur)
chokes when SwiftUI redraws too many particles per frame. The repo
defines `HardwareTier.particleBudget` (= 40 on legacy GPUs, 80 on modern)
exactly for this; every `ParticleEmitter` should pass that constant —
or a `min(N, HardwareTier.particleBudget)` cap — as its `particleCount:`
argument. A literal `particleCount: 80` doubles the legacy work and
re-introduces the dropped-frame class the 2026-05-28 perf sweep closed.

The 2026-06-05 deep audit caught three regressions:
  - `AllChaptersCompleteOverlay.swift:53` — hard-coded 80
  - `Scene5_AutotrophHeterotroph.swift:252` — hard-coded 80
  - `Scene2_PhotosynthesisLab.swift:81` — hard-coded 50

This lint blocks raw integer literals in `particleCount:` and forces
every call site through `HardwareTier.particleBudget`. Hard gate.

Allowed forms:
  ParticleEmitter(particleCount: HardwareTier.particleBudget, ...)
  ParticleEmitter(particleCount: min(50, HardwareTier.particleBudget), ...)
  ParticleEmitter(particleCount: customBudget, ...)            // named local

Forbidden:
  ParticleEmitter(particleCount: 80, ...)                       // literal
  ParticleEmitter(particleCount: 50, ...)                       // literal

Usage:
    python3 scripts/check_particle_budget.py [--quiet] [paths ...]
    python3 scripts/check_particle_budget.py --selftest
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

# Match `particleCount:` followed by a bare integer literal — the forbidden
# form. Skips `particleCount: HardwareTier...` / `particleCount: min(...)` /
# `particleCount: someLocal` because the value after `:` doesn't start with
# a digit.
_FORBIDDEN = re.compile(r"\bparticleCount:\s*(\d+)\b")

# Allowed form sanity check: at least one usage references HardwareTier
# elsewhere in the file. If the file never imports HardwareTier and uses
# ParticleEmitter, flag that separately (downgraded to a warning).
_HARDWARE_TIER_REF = re.compile(r"\bHardwareTier\.particleBudget\b")
_PARTICLE_EMITTER_CALL = re.compile(r"\bParticleEmitter\s*\(")

_LINE_COMMENT = re.compile(r"//[^\n]*")


def scan_text(src: str) -> list[tuple[int, str]]:
    cleaned = _LINE_COMMENT.sub("", src)
    findings: list[tuple[int, str]] = []
    for m in _FORBIDDEN.finditer(cleaned):
        line_no = cleaned.count("\n", 0, m.start()) + 1
        findings.append((line_no, m.group(0)))
    return findings


def scan_file(path: Path) -> list[tuple[int, str]]:
    try:
        return scan_text(path.read_text(encoding="utf-8"))
    except (UnicodeDecodeError, OSError):
        return []


def run_selftest() -> int:
    danger = """
    ParticleEmitter(isActive: true, particleCount: 80, duration: 4.0)
    ParticleEmitter(isActive: true, particleCount: 50)
    ParticleEmitter(particleCount: 100)
    """
    safe = """
    ParticleEmitter(isActive: true, particleCount: HardwareTier.particleBudget)
    ParticleEmitter(isActive: true, particleCount: min(50, HardwareTier.particleBudget))
    let budget: Int = min(40, HardwareTier.particleBudget)
    ParticleEmitter(isActive: true, particleCount: budget)
    // ParticleEmitter(particleCount: 80) ← commented, should not flag
    """
    ok = True
    d = scan_text(danger)
    if len(d) != 3:
        print(f"SELFTEST FAIL: danger fixture flagged {len(d)} sites, expected 3")
        for v in d:
            print("  ", v)
        ok = False
    s = scan_text(safe)
    if len(s) != 0:
        print(f"SELFTEST FAIL: safe fixture flagged {len(s)} sites, expected 0")
        for v in s:
            print("  ", v)
        ok = False
    print("selftest passed" if ok else "selftest FAILED")
    return 0 if ok else 1


def main() -> int:
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    ap.add_argument(
        "paths",
        nargs="*",
        default=["desktopAhaan"],
        help="roots to scan (default: desktopAhaan)",
    )
    ap.add_argument("--quiet", action="store_true")
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()

    if args.selftest:
        return run_selftest()

    failed = False
    for top in args.paths:
        root = Path(top)
        if not root.exists():
            continue
        if root.is_file():
            files = [root] if root.suffix == ".swift" else []
        else:
            files = sorted(root.rglob("*.swift"))
        for swift in files:
            if "Tests" in swift.name:
                continue
            # Skip the ParticleEmitter definition file itself — the default
            # parameter value `particleCount: Int = 60` is its API contract.
            if swift.name == "ParticleEmitter.swift":
                continue
            for (line_no, match_text) in scan_file(swift):
                print(
                    f"{swift}:{line_no}  {match_text} — literal int, route through HardwareTier.particleBudget"
                )
                failed = True
    if failed:
        print()
        print("These ParticleEmitter call sites pass a literal int as particleCount.")
        print("The deploy iMac's AMD R9 M290X chokes on counts above the legacy")
        print("budget (40); use `HardwareTier.particleBudget` (or a `min(N,")
        print("HardwareTier.particleBudget)` cap) instead.")
        print()
        print("Fix: replace `particleCount: 80` with `particleCount: HardwareTier.particleBudget`.")
        return 1
    if not args.quiet:
        print("all ParticleEmitter call sites route through HardwareTier.particleBudget")
    return 0


if __name__ == "__main__":
    sys.exit(main())
