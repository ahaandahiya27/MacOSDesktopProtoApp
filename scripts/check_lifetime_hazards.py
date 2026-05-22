#!/usr/bin/env python3
"""check_lifetime_hazards.py — static lint for lifetime/ownership hazards.

Concerns kept separate from check_macos12_apis.py (which gates SDK
compatibility); this script gates ownership patterns that cause
EXC_BAD_ACCESS / retain cycles / sendable lies.

Current rules (each toggleable; existing violations grandfathered via
scripts/lifetime_hazards_allowlist.txt):

  1. var delegate:  — must be `weak var delegate:` when used as an
     AppKit/UIKit/SDK delegate, otherwise it can outlive its owner and
     produce zombies on subsequent delegate callbacks. Heuristic: any
     `var delegate:` declaration not on the same line as `weak`.

  2. `\\bunowned\\b` (any use) — `unowned` makes a non-nillable assumption
     about object lifetime that's hard to prove correct under SwiftUI's
     commit model. The rule forces the author to either use `weak` (and
     handle the nil case) or — if `unowned` is truly justified (e.g. an
     immutable owned-by-parent relationship in a @MainActor init) —
     add the file:line to the allowlist with the proof.

Pending rules (added in subsequent commits, this scaffolding stays):

  3. `@unchecked Sendable` — almost always a lie; converts a synchronization
     bug into a silent data race. Force the author to use a queue, lock,
     or actor instead.

Exit codes:
  0 — clean
  1 — at least one new violation (not in the allowlist)
  2 — script bug / fixture missing

Run from the repo root: `python3 scripts/check_lifetime_hazards.py`.
"""

from __future__ import annotations

import re
import sys
from dataclasses import dataclass
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SOURCE_DIR = REPO_ROOT / "desktopAhaan"
ALLOWLIST_PATH = REPO_ROOT / "scripts" / "lifetime_hazards_allowlist.txt"

# Files that are exempt from these rules. FoundationTutor is the AI shim
# carve-out documented in CLAUDE.md; tests are scanned separately if at all.
EXEMPT_PATH_FRAGMENTS = (
    "/FoundationTutor.swift",
)


@dataclass(frozen=True)
class Violation:
    rule_id: str
    rel_path: str
    line_no: int
    line: str
    why: str

    def allowlist_key(self) -> str:
        return f"{self.rel_path}:{self.line_no}"


def _is_exempt(path: Path) -> bool:
    rel = str(path)
    return any(frag in rel for frag in EXEMPT_PATH_FRAGMENTS)


def _read_allowlist() -> set[str]:
    if not ALLOWLIST_PATH.exists():
        return set()
    keys = set()
    for raw in ALLOWLIST_PATH.read_text().splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        # Lines look like  path:line:reason  — only the path:line prefix
        # is the key; everything after the second `:` is human prose.
        parts = line.split(":", 2)
        if len(parts) < 2:
            continue
        keys.add(f"{parts[0]}:{parts[1]}")
    return keys


# --- Rule implementations -------------------------------------------------

_VAR_DELEGATE_RE = re.compile(r"(?<!\bweak\s)\bvar\s+delegate\s*:")
_UNOWNED_RE = re.compile(r"\bunowned\b")


def _scan_var_delegate(swift_path: Path) -> list[Violation]:
    rel = swift_path.relative_to(REPO_ROOT).as_posix()
    findings: list[Violation] = []
    for idx, line in enumerate(swift_path.read_text().splitlines(), start=1):
        # Skip strings, comments, etc. — cheap heuristic: skip the line
        # if its first non-whitespace token is `//` or it's a docstring.
        stripped = line.strip()
        if stripped.startswith("//") or stripped.startswith("///"):
            continue
        # Skip `var delegate:` declarations that are explicitly weak.
        if "weak var delegate" in line:
            continue
        if _VAR_DELEGATE_RE.search(line):
            findings.append(
                Violation(
                    rule_id="LH001",
                    rel_path=rel,
                    line_no=idx,
                    line=line.rstrip(),
                    why=(
                        "`var delegate:` should be `weak var delegate:` — a "
                        "strong delegate reference outlives its owner and "
                        "produces zombies on subsequent delegate callbacks. "
                        "If the type is not an AppKit/UIKit delegate (e.g. "
                        "owned protocol with no callback), add the file/line "
                        "to scripts/lifetime_hazards_allowlist.txt with a "
                        "short reason."
                    ),
                )
            )
    return findings


def _scan_unowned(swift_path: Path) -> list[Violation]:
    rel = swift_path.relative_to(REPO_ROOT).as_posix()
    findings: list[Violation] = []
    for idx, line in enumerate(swift_path.read_text().splitlines(), start=1):
        stripped = line.strip()
        if stripped.startswith("//") or stripped.startswith("///"):
            continue
        if _UNOWNED_RE.search(line):
            findings.append(
                Violation(
                    rule_id="LH002",
                    rel_path=rel,
                    line_no=idx,
                    line=line.rstrip(),
                    why=(
                        "`unowned` assumes the referenced object outlives "
                        "the holder. Under SwiftUI's commit model that is "
                        "rarely provable; if the assumption is wrong the "
                        "next access EXC_BAD_ACCESSes instead of returning "
                        "nil. Prefer `weak` and handle the nil case. If "
                        "`unowned` is genuinely justified (e.g. an immutable "
                        "owned-by-parent relationship inside a @MainActor "
                        "init), add the file:line to "
                        "scripts/lifetime_hazards_allowlist.txt with proof."
                    ),
                )
            )
    return findings


# --- Driver ---------------------------------------------------------------

def _scan_repo() -> list[Violation]:
    findings: list[Violation] = []
    for swift_path in sorted(SOURCE_DIR.rglob("*.swift")):
        if _is_exempt(swift_path):
            continue
        findings.extend(_scan_var_delegate(swift_path))
        findings.extend(_scan_unowned(swift_path))
    return findings


def main() -> int:
    if not SOURCE_DIR.exists():
        print(
            f"check_lifetime_hazards: source dir not found at {SOURCE_DIR}",
            file=sys.stderr,
        )
        return 2

    allow = _read_allowlist()
    findings = _scan_repo()
    new_findings = [v for v in findings if v.allowlist_key() not in allow]

    if not new_findings:
        total = len(findings)
        if total:
            print(
                f"check_lifetime_hazards: clean — {total} pre-existing "
                f"violation(s) grandfathered via allowlist."
            )
        else:
            print("check_lifetime_hazards: clean — no violations.")
        return 0

    print("check_lifetime_hazards: new violations:")
    for v in new_findings:
        print(f"  [{v.rule_id}] {v.rel_path}:{v.line_no}")
        print(f"      {v.line}")
        print(f"      {v.why}")
        print()
    return 1


if __name__ == "__main__":
    sys.exit(main())
