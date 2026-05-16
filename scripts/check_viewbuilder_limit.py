#!/usr/bin/env python3
"""Big Sur @ViewBuilder safety lint (heuristic).

Swift 5.5 / Xcode 13.2.1 caps SwiftUI's @ViewBuilder at 10 direct child
views per closure. The 11th child compiles silently on modern Xcode (which
uses a different builder overload) but fails on the iMac with the cryptic
error "Extra argument in call". This script scans every .swift file under
`desktopAhaan/` for SwiftUI container closures whose direct-child count
appears to exceed LIMIT, so you can catch the problem before pushing.

This is a HEURISTIC. It over-counts on files with deeply chained .modifier
calls that span multiple lines and contain their own `{...}` closures.
After it flags a file, open it and count children manually before fixing.
For ground-truth verification, build with Xcode 13.2.1 on Big Sur — that is
the only way to be sure.

Usage:
    python3 scripts/check_viewbuilder_limit.py [--limit N] [--paths ...]

The script counts lines that start (after stripping whitespace) with a
capital letter, `if`/`for`/`switch`/`Spacer`/`Divider` etc. at top-level
inside a container closure. It tries to skip continuation lines that start
with `.` (modifier chains) and lines inside nested closures.
"""

import argparse
import re
import sys
from pathlib import Path

DEFAULT_LIMIT = 10

CONTAINERS = (
    "VStack", "HStack", "ZStack",
    "LazyVStack", "LazyHStack", "LazyVGrid", "LazyHGrid",
    "ScrollView", "Group",
)

# A direct child statement at top level inside a container closure tends to
# start with one of these tokens.
CHILD_STARTERS = re.compile(
    r"""^(
        [A-Z][A-Za-z0-9_]*        # SwiftUI primitive: Text, Image, VStack, MyView, ...
      | if\b | for\b | switch\b   # control flow
      | Spacer\b | Divider\b      # common standalone children
      | @ViewBuilder\b            # shouldn't appear inside body but defensive
    )"""
    , re.VERBOSE
)


def count_children(src: str, container_open_line: int) -> int:
    """Walk forward from a container open line, returning a direct-child
    count using a brace+paren depth tracker."""
    lines = src.splitlines()
    if container_open_line >= len(lines):
        return 0

    depth = 1
    paren = 0
    children = 0
    pending_statement = True  # next non-blank, non-modifier line at depth 1 starts a child

    j = container_open_line + 1
    while j < len(lines) and depth > 0:
        line = lines[j]
        stripped = line.strip()

        # Skip comments and blanks
        if not stripped or stripped.startswith("//"):
            j += 1
            continue

        if depth == 1 and paren == 0 and pending_statement:
            # Is this line a continuation of a previous statement?
            # Continuation: starts with `.`, `}` (else branch), `)`, ` else `, etc.
            if not (stripped.startswith(".") or
                    stripped.startswith("}") or
                    stripped.startswith(")") or
                    stripped.startswith("] ") or
                    stripped.startswith("] .") or
                    stripped.startswith("else") or
                    stripped.startswith(", ") or
                    stripped.startswith(":") or
                    stripped.startswith("+") or
                    stripped.startswith("-") or
                    stripped.startswith("=")):
                # Does it look like a child statement?
                if CHILD_STARTERS.match(stripped):
                    children += 1
                    pending_statement = False

        # Update brace + paren depths.
        for ch in line:
            if ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1
                if depth < 1:
                    break
            elif ch == "(":
                paren += 1
            elif ch == ")":
                paren = max(0, paren - 1)
        if depth < 1:
            break
        # If we ended this line back at depth 1 + paren 0, next non-blank
        # line is a fresh statement candidate.
        pending_statement = (depth == 1 and paren == 0)
        j += 1
    return children


def scan_file(path: Path, limit: int) -> list:
    src = path.read_text()
    lines = src.splitlines()
    pat = re.compile(r"\b(" + "|".join(CONTAINERS) + r")\b[^{]*\{\s*$")
    out = []
    for i, line in enumerate(lines):
        m = pat.search(line)
        if not m:
            continue
        container = m.group(1)
        n = count_children(src, i)
        if n > limit:
            out.append((i + 1, container, n))
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=DEFAULT_LIMIT)
    ap.add_argument("paths", nargs="*", default=["desktopAhaan"])
    args = ap.parse_args()

    failed = False
    for top in args.paths:
        root = Path(top)
        if not root.exists():
            continue
        for swift in sorted(root.rglob("*.swift")):
            if "Tests" in swift.name:
                continue
            for (line_no, container, n) in scan_file(swift, args.limit):
                print(f"{swift}:{line_no}  {container} appears to have {n} direct children (limit {args.limit})")
                failed = True
    if failed:
        print()
        print("These containers MAY fail with 'Extra argument in call' on Xcode 13 / Swift 5.5 (Big Sur).")
        print("Wrap groups of children in a Group { ... } or extract @ViewBuilder computed vars.")
        print("Heuristic only — open each file and count manually before fixing.")
        return 1
    print("no obvious @ViewBuilder violations found (heuristic — verify on Big Sur Xcode for certainty)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
