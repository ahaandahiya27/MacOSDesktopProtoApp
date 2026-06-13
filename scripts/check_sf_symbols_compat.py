#!/usr/bin/env python3
"""Big Sur SF Symbols compat lint.

The deploy iMac runs macOS 11.7.11 (SF Symbols 2). Symbols introduced in
SF Symbols 3 (macOS 12) or 4 (macOS 13) render as missing glyphs on Big
Sur. The codebase routes modern names through `SFSymbolCompat.name(_:)`
in `desktopAhaan/Extensions/Extensions.swift`, which substitutes a
fallback on macOS 11 and is a no-op on macOS 12+.

This script catches the failure mode we hunted on 2026-05-19 (Ch.7
weather-station icons rendering blank): a scene data struct holds
`symbol: String = "humidity.fill"` and the call site does
`Image(systemName: inst.symbol)` — bypassing the compat shim. Even
worse: literal strings like `Label("...", systemImage: "humidity.fill")`
that never see the shim at all.

The script reads the compat map's case labels to know which symbol
names ARE known to be SF 3+/4+ (truth source = whatever's in
`SFSymbolCompat`). It then scans every .swift file for:
  - literal `systemName: "X"` or `systemImage: "X"` where X is in the
    compat map but the call site is NOT wrapped in `SFSymbolCompat.name(`

Anything flagged means: that literal renders blank on Big Sur. Either
wrap the literal in `SFSymbolCompat.name("X")` or add a new compat-map
entry if X isn't covered.

Exit code is 0 on clean, 1 if any violations found. Hook into
pre-push to gate the bug class.

Usage:
    python3 scripts/check_sf_symbols_compat.py [--paths ...]
"""

import argparse
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
EXTENSIONS_SWIFT = REPO_ROOT / "desktopAhaan" / "Extensions" / "Extensions.swift"
DEFAULT_SCAN_ROOT = REPO_ROOT / "desktopAhaan"


def load_compat_keys(path: Path) -> set[str]:
    """Parse `SFSymbolCompat.name(_:)` case labels out of Extensions.swift.

    Each line in the switch looks like:
        case "humidity.fill":              return "drop.fill"
    We collect the quoted symbol names on the LHS — those are the
    known-SF-3+/4+ names that MUST be routed through the shim.
    """
    if not path.exists():
        print(f"ERROR: cannot read compat map at {path}", file=sys.stderr)
        sys.exit(2)
    keys: set[str] = set()
    case_re = re.compile(r'^\s*case\s+"([^"]+)"\s*:', re.MULTILINE)
    text = path.read_text(encoding="utf-8")
    for m in case_re.finditer(text):
        keys.add(m.group(1))
    return keys


# Lines that include `SFSymbolCompat.name(` are already routed — skip.
ALREADY_ROUTED = re.compile(r"SFSymbolCompat\.name\s*\(")

# Match `systemName: "..."` or `systemImage: "..."` literal call-sites.
SYSTEM_SYMBOL_LITERAL = re.compile(
    r'system(?:Name|Image)\s*:\s*"([^"]+)"'
)


def scan_text(text: str, compat_keys: set[str]) -> list[tuple[int, str]]:
    """Return [(line_no, symbol_name), ...] violations in `text`."""
    violations: list[tuple[int, str]] = []
    for line_no, line in enumerate(text.splitlines(), start=1):
        if ALREADY_ROUTED.search(line):
            # Whole line is routed through the shim; skip.
            continue
        for sym_match in SYSTEM_SYMBOL_LITERAL.finditer(line):
            symbol = sym_match.group(1)
            if symbol in compat_keys:
                violations.append((line_no, symbol))
    return violations


def scan_file(path: Path, compat_keys: set[str]) -> list[tuple[int, str]]:
    """Return list of (line_no, symbol_name) violations in this file."""
    try:
        text = path.read_text(encoding="utf-8")
    except (UnicodeDecodeError, OSError):
        return []
    return scan_text(text, compat_keys)


# --------------------------------------------------------------------------
# Self-test fixtures. Hermetic compat-key set — does NOT depend on whatever
# Extensions.swift currently ships, so the selftest stays stable when
# new SF Symbols 3+/4+ entries are added to the live compat map.
# --------------------------------------------------------------------------

_SELFTEST_COMPAT_KEYS = {
    "humidity.fill",
    "thermometer.medium",
    "person.crop.circle.badge.checkmark",
}

_DANGER_FIXTURE = """\
import SwiftUI

struct DangerIcons: View {
    let inst = (symbol: "humidity.fill")
    var body: some View {
        VStack {
            // Bare literal — bypasses the shim.
            Image(systemName: "humidity.fill")
            Label("warmth", systemImage: "thermometer.medium")
            Image(systemName: "person.crop.circle.badge.checkmark")
        }
    }
}
"""

_CLEAN_FIXTURE = """\
import SwiftUI

struct CleanIcons: View {
    var body: some View {
        VStack {
            // Routed through the compat shim — no flag.
            Image(systemName: SFSymbolCompat.name("humidity.fill"))
            Label("warmth", systemImage: SFSymbolCompat.name("thermometer.medium"))
            // Unknown / SF-Symbols-2 symbol — not in the compat map.
            Image(systemName: "star.fill")
        }
    }
}
"""


def run_selftest() -> int:
    failures: list[str] = []

    d_hits = scan_text(_DANGER_FIXTURE, _SELFTEST_COMPAT_KEYS)
    expected_danger = 3
    if len(d_hits) != expected_danger:
        print(f"SELFTEST FAIL: danger fixture flagged {len(d_hits)} hit(s), "
              f"expected {expected_danger}")
        for h in d_hits:
            print("  ", h)
        failures.append("danger fixture")
    else:
        print(f"  [PASS] danger fixture flags {expected_danger} hit(s)")

    c_hits = scan_text(_CLEAN_FIXTURE, _SELFTEST_COMPAT_KEYS)
    if c_hits:
        print(f"SELFTEST FAIL: clean fixture flagged {len(c_hits)} hit(s), expected 0:")
        for h in c_hits:
            print("  ", h)
        failures.append("clean fixture")
    else:
        print("  [PASS] clean fixture flags 0 hits")

    print()
    if failures:
        print(f"check_sf_symbols_compat --selftest: FAIL — {len(failures)} case(s) misclassified.")
        return 1
    print("check_sf_symbols_compat --selftest: PASS — every fixture classifies correctly.")
    return 0


def main() -> int:
    if "--selftest" in sys.argv:
        return run_selftest()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--paths",
        nargs="*",
        default=[str(DEFAULT_SCAN_ROOT)],
        help="Roots to scan (default: desktopAhaan/)",
    )
    args = parser.parse_args()

    compat_keys = load_compat_keys(EXTENSIONS_SWIFT)
    if not compat_keys:
        print(f"WARN: no compat-map cases parsed from {EXTENSIONS_SWIFT}", file=sys.stderr)
        return 2

    total_violations = 0
    files_with_violations = 0
    for root in args.paths:
        for swift_path in Path(root).rglob("*.swift"):
            # Skip the compat map itself — its case labels are intentional.
            if swift_path.resolve() == EXTENSIONS_SWIFT.resolve():
                continue
            file_violations = scan_file(swift_path, compat_keys)
            if not file_violations:
                continue
            files_with_violations += 1
            rel = swift_path.relative_to(REPO_ROOT)
            for line_no, symbol in file_violations:
                print(f"{rel}:{line_no}: SF Symbols 3+/4+ name \"{symbol}\" not routed through SFSymbolCompat.name(_:)")
                total_violations += 1

    if total_violations == 0:
        print(f"check_sf_symbols_compat: clean — scanned against {len(compat_keys)} compat-map entries, no leaked literals")
        return 0

    print(
        f"\ncheck_sf_symbols_compat: {total_violations} violation(s) across "
        f"{files_with_violations} file(s). On Big Sur these icons render blank.",
        file=sys.stderr,
    )
    print(
        "Fix: wrap the literal in SFSymbolCompat.name(\"...\") at the call site, OR "
        "add a new case to SFSymbolCompat in desktopAhaan/Extensions/Extensions.swift.",
        file=sys.stderr,
    )
    return 1


if __name__ == "__main__":
    sys.exit(main())
