#!/usr/bin/env python3
"""Big Sur @ViewBuilder / @CommandsBuilder safety lint (heuristic).

Swift 5.5 / Xcode 13.2.1 caps a result builder's `buildBlock` at 10 direct
child arguments per closure. The 11th child compiles silently on a modern
Xcode (which picks a different builder overload) but fails on the iMac with
the cryptic error:

    Extra arguments at positions #11..#N in call; 'buildBlock' declared here

This is NOT specific to SwiftUI `View` bodies. It bites EVERY result-builder
closure: `@ViewBuilder` computed vars / funcs, and — the gap that shipped a
broken build to the iMac on 2026-05-30 — `@CommandsBuilder` menu closures
(`CommandGroup`, `CommandMenu`) which the original version of this lint did
NOT scan. The Help `CommandGroup(replacing: .help)` had grown to 20 direct
children and slipped past every dev-Mac gate.

This script therefore scans, under `desktopAhaan/`, the direct-child count of:

  * SwiftUI layout containers — VStack/HStack/ZStack, the Lazy* variants,
    ScrollView, and Group.
  * Commands / menu builders — CommandGroup(...), CommandMenu(...),
    Menu(...), ToolbarItemGroup(...). Their trailing (or `content:`)
    closures are @CommandsBuilder/@ViewBuilder and obey the same cap.
  * Any function or computed var annotated `@ViewBuilder` or
    `@CommandsBuilder` (the body is a builder closure).

It does NOT scan a plain `var body: some View {` — that is the original
lint's deliberate scope (a View body's *containers* are scanned, not the
body wrapper itself), and widening it would re-flag files that already
bucket correctly. Wrap groups of children in `Group { ... }` — Group
flattens inline in a menu / stack (same items, same separators, same
order) so it costs nothing but resets the child count of its parent to 1.

This is a HEURISTIC. It can over-count on files with deeply chained
multi-line `.modifier` calls that contain their own `{...}` closures.
After it flags a closure, open it and count children manually before
fixing. For ground-truth verification, build with Xcode 13.2.1 on Big Sur
— that is the only way to be sure.

Usage:
    python3 scripts/check_viewbuilder_limit.py [--limit N] [--quiet] [paths ...]
    python3 scripts/check_viewbuilder_limit.py --selftest

`--quiet` suppresses the "clean" success line (violations still print) so
the pre-commit hook stays silent on the happy path. `--selftest` runs the
embedded fixtures and exits 0 only if every one classifies correctly.
"""

import argparse
import re
import sys
from pathlib import Path

DEFAULT_LIMIT = 10

# Layout containers (original scope) + commands/menu builders (added
# 2026-05-31 after the Help CommandGroup broke the iMac build). Longer
# names are matched safely by the `\b...\b` boundaries — `\bGroup\b` does
# NOT match inside "CommandGroup" / "ToolbarItemGroup" (no word boundary
# between the lowercase tail and "Group"), so each name is detected on its
# own and `CommandGroup`/`ToolbarItemGroup` are listed explicitly.
CONTAINERS = (
    "VStack", "HStack", "ZStack",
    "LazyVStack", "LazyHStack", "LazyVGrid", "LazyHGrid",
    "ScrollView", "Group",
    "CommandGroup", "CommandMenu", "Menu", "ToolbarItemGroup",
)

# A direct child statement at top level inside a builder closure tends to
# start with one of these tokens.
CHILD_STARTERS = re.compile(
    r"""^(
        [A-Z][A-Za-z0-9_]*        # SwiftUI primitive: Text, Image, VStack, Button, MyView, ...
      | if\b | for\b | switch\b   # control flow (each is one builder child)
      | Spacer\b | Divider\b      # common standalone children
      | @ViewBuilder\b            # shouldn't appear inside a body but defensive
    )"""
    , re.VERBOSE
)

# A container open line: `<Container>( … ) {` or `<Container> {` where the
# brace is the LAST non-space token (the start of the builder closure).
CONTAINER_OPEN = re.compile(r"\b(" + "|".join(CONTAINERS) + r")\b[^{]*\{\s*$")

# A builder BODY open line — a func or computed var whose body brace is the
# last token. We only treat it as a builder when a `@ViewBuilder` /
# `@CommandsBuilder` annotation sits within the few lines above (see
# `is_annotated_builder`). The var branch excludes `=` so a stored closure
# property like `@ViewBuilder var content: () -> Content` (which has no body
# brace at all) can never match.
DECL_OPEN = re.compile(
    r"""(
        \bfunc\s+\w+\s*\(.*\)\s*->.*\{\s*$   # func foo(...) -> some View {
      | \bvar\s+\w+\s*:\s*[^={]+\{\s*$        # var foo: some View {   (no `=`)
    )""",
    re.VERBOSE,
)

BUILDER_ANNOTATION = re.compile(r"@(ViewBuilder|CommandsBuilder)\b")


def count_children(src: str, container_open_line: int) -> int:
    """Walk forward from a builder-open line, returning a direct-child
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


def is_annotated_builder(lines: list, decl_line: int) -> bool:
    """True if a @ViewBuilder / @CommandsBuilder annotation sits within the
    3 non-blank lines immediately above `decl_line` (annotations can carry
    other attributes / access modifiers on intervening lines)."""
    seen = 0
    k = decl_line - 1
    while k >= 0 and seen < 3:
        s = lines[k].strip()
        if not s:
            k -= 1
            continue
        if BUILDER_ANNOTATION.search(s):
            return True
        # Stop once we leave the attribute/modifier prefix of this decl:
        # a line that is neither an attribute (@...) nor a bare modifier
        # keyword means the declaration's annotation block has ended.
        if not (s.startswith("@") or s in ("private", "public", "internal",
                                           "fileprivate", "static", "final")):
            return False
        seen += 1
        k -= 1
    return False


def find_openings(src: str) -> list:
    """Return a list of (line_index, label) for every builder-closure
    opening in `src`: layout/menu containers + annotated func/var bodies."""
    lines = src.splitlines()
    openings = []
    for i, line in enumerate(lines):
        m = CONTAINER_OPEN.search(line)
        if m:
            openings.append((i, m.group(1)))
            continue
        if DECL_OPEN.search(line) and is_annotated_builder(lines, i):
            openings.append((i, "@ViewBuilder/@CommandsBuilder"))
    return openings


def scan_src(src: str, limit: int) -> list:
    """Return [(line_no, label, child_count), ...] for closures over `limit`."""
    out = []
    for (idx, label) in find_openings(src):
        n = count_children(src, idx)
        if n > limit:
            out.append((idx + 1, label, n))
    return out


def scan_file(path: Path, limit: int) -> list:
    return scan_src(path.read_text(encoding="utf-8", errors="replace"), limit)


# --------------------------------------------------------------------------
# Self-test fixtures. Each is (name, source, expected_violation_count).
# --------------------------------------------------------------------------

def _menu_with(n_buttons: int) -> str:
    body = "\n".join(
        f'        Button("Item {k}") {{ act{k}() }}' for k in range(n_buttons)
    )
    return (
        "struct Demo {\n"
        "    var body: some Commands {\n"
        "        CommandGroup(replacing: .help) {\n"
        f"{body}\n"
        "        }\n"
        "    }\n"
        "}\n"
    )


def _viewbuilder_var_with(n: int) -> str:
    body = "\n".join(f'        Text("row {k}")' for k in range(n))
    return (
        "struct Demo: View {\n"
        "    @ViewBuilder\n"
        "    private var rows: some View {\n"
        f"{body}\n"
        "    }\n"
        "}\n"
    )


# A parent menu whose only children are bucketed Groups — each Group is one
# child of the parent, so the parent stays ≤10 even though the Groups hold
# many items between them. Must NOT flag.
_NESTED_GROUP_OK = (
    "struct Demo {\n"
    "    var body: some Commands {\n"
    "        CommandGroup(replacing: .help) {\n"
    "            Group {\n"
    + "\n".join(f'                Button("a{k}") {{}}' for k in range(6)) + "\n"
    "            }\n"
    "            Divider()\n"
    "            Group {\n"
    + "\n".join(f'                Button("b{k}") {{}}' for k in range(6)) + "\n"
    "            }\n"
    "        }\n"
    "    }\n"
    "}\n"
)

# A stored @ViewBuilder closure property — has NO body brace, must never be
# treated as a builder opening (regression guard for the DECL_OPEN `=`/brace
# exclusion).
_STORED_BUILDER_PROP_OK = (
    "struct ExpandableCard<Content: View>: View {\n"
    "    @ViewBuilder var content: () -> Content\n"
    "    var body: some View {\n"
    '        Text("hi")\n'
    "    }\n"
    "}\n"
)

SELFTESTS = [
    ("CommandGroup 11 children flags", _menu_with(11), 1),
    ("CommandGroup 10 children passes", _menu_with(10), 0),
    ("@ViewBuilder var 11 children flags", _viewbuilder_var_with(11), 1),
    ("@ViewBuilder var 10 children passes", _viewbuilder_var_with(10), 0),
    ("nested-Group bucketing passes", _NESTED_GROUP_OK, 0),
    ("stored @ViewBuilder closure prop passes", _STORED_BUILDER_PROP_OK, 0),
]


def run_selftest() -> int:
    failures = []
    for name, src, expected in SELFTESTS:
        hits = scan_src(src, DEFAULT_LIMIT)
        actual = len(hits)
        ok = actual == expected
        flag = "PASS" if ok else "FAIL"
        print(f"  [{flag}] {name}: expected {expected} violation(s), got {actual}")
        if not ok:
            failures.append(name)
    print()
    if failures:
        print(f"check_viewbuilder_limit --selftest: FAIL — {len(failures)} case(s) misclassified.")
        return 1
    print("check_viewbuilder_limit --selftest: PASS — every fixture classifies correctly.")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=DEFAULT_LIMIT)
    ap.add_argument("--quiet", action="store_true",
                    help="suppress the success line (violations still print)")
    ap.add_argument("--selftest", action="store_true",
                    help="run embedded fixtures and exit")
    ap.add_argument("paths", nargs="*", default=["desktopAhaan"])
    args = ap.parse_args()

    if args.selftest:
        return run_selftest()

    failed = False
    for top in args.paths:
        root = Path(top)
        if not root.exists():
            continue
        for swift in sorted(root.rglob("*.swift")):
            if "Tests" in swift.name:
                continue
            for (line_no, label, n) in scan_file(swift, args.limit):
                print(f"{swift}:{line_no}  {label} appears to have {n} direct children (limit {args.limit})")
                failed = True
    if failed:
        print()
        print("These builder closures MAY fail with 'Extra arguments at positions #11..#N")
        print("in call' on Xcode 13 / Swift 5.5 (Big Sur). Wrap groups of children in a")
        print("Group { ... } (it flattens inline in stacks/menus) or extract a")
        print("@ViewBuilder computed var. Heuristic only — open each file and count")
        print("direct children manually before fixing.")
        return 1
    if not args.quiet:
        print("no obvious @ViewBuilder/@CommandsBuilder violations found (heuristic — verify on Big Sur Xcode for certainty)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
