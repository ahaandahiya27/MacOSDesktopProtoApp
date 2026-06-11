#!/usr/bin/env python3
"""DesignTokens.Spacing migration ratchet (J8).

The repo just completed a 5-wave migration that rewrote every
padding / stack-spacing / grid-spacing literal in the design canon
({2, 4, 8, 12, 16, 24, 32, 48}) to a named `DesignTokens.Spacing.*`
token. The point: phase 3 / 5 / 6 of the visual sweep need ONE place
to refine spacing values across the whole app — not a search-and-
replace across hundreds of files. (See CLAUDE.md / phase plan +
`docs/ISSUE_CATEGORIES.md` row J8.)

This lint exists to keep waves 1-5 from silently un-doing themselves.
It scans, under `desktopAhaan/`, every call site of:

  * `.padding(N)`
  * `.padding(.horizontal, N)`, `.vertical`, `.top`, `.bottom`,
    `.leading`, `.trailing` (any single-edge variant)
  * `VStack(spacing: N)`, `HStack(spacing: N)`, the Lazy* variants
  * `LazyVGrid(... spacing: N)`, `LazyHGrid(... spacing: N)`
  * `Spacer(minLength: N)`

… and flags the call when `N` is a bare integer literal in the
design canon set `{2, 4, 8, 12, 16, 24, 32, 48}`. The lint
suggests the matching `DesignTokens.Spacing.<token>` substitution.

Skip list (intentionally allowed raw literals):
  - `desktopAhaan/Extensions/Extensions.swift` — defines the
    tokens themselves; the literals on the RHS of `static let
    sm: CGFloat = 8` are the canon.
  - Article rendering surfaces — `NativeArticleRepresentable.swift`,
    `ArticleStructuredRenderer.swift`,
    `ArticleStructuredRenderer+Render.swift`. These are HTML / NSText
    rendering shims and their padding semantics are tied to the
    AppKit / WebKit layer, not the SwiftUI design canon.
  - Test bundles — `desktopAhaanTests/`, `desktopAhaanUITests/`.

Also skipped within a file:
  - Comment lines (// ...) and block comments (/* ... */).
  - String literals (single and triple-quoted Swift string forms).
  - `Path { ... }`, `Shape.path(in:) { ... }`, and `Canvas { ... }`
    closures — drawing math frequently uses literal pixel offsets
    that don't belong in the spacing canon.
  - Sites where the argument is already a `DesignTokens.Spacing.*`
    reference (those are the goal state — never flagged).
  - Sites where the argument is a non-integer (`8.0`, `8.5`), a
    variable, an expression, or `.infinity` — only BARE integer
    literals are flagged.

Usage:
    python3 scripts/check_designtokens_spacing.py [--quiet] [paths ...]
    python3 scripts/check_designtokens_spacing.py --selftest
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

# The design canon of spacing literals. Any bare integer in this set
# inside one of the call sites below is a violation; the lint maps it
# to the named DesignTokens.Spacing.* token.
CANON: dict[int, str] = {
    2: "xxs",
    4: "xs",
    8: "sm",
    12: "md",
    16: "lg",
    24: "xl",
    32: "xxl",
    48: "xxxl",
}

# Files / folders the lint deliberately does NOT scan.
SKIP_FILE_NAMES = {
    "Extensions.swift",  # defines the tokens themselves
    "NativeArticleRepresentable.swift",
    "ArticleStructuredRenderer.swift",
    "ArticleStructuredRenderer+Render.swift",
}
SKIP_PATH_PARTS = ("desktopAhaanTests", "desktopAhaanUITests")

# A bare positive integer literal. Anchored so it doesn't bleed into
# `8.0` (float), `80` (different value), `pad8` (identifier), or
# `0x08` (hex). Surrounded captures so the regex can be reused for any
# of the call-site shapes below.
_INT = r"(?<![\w.])(?P<val>\d+)(?![\w.])"

# ----------------------------------------------------------------------
# Call-site regexes.
#
# Each pattern matches a single call site. The integer literal is
# captured in the `val` group; the call-site shape is what each pattern
# is named for (used in the violation message).
# ----------------------------------------------------------------------

# `.padding(8)` — bare integer arg, no label.
RX_PADDING_BARE = re.compile(
    r"\.padding\(\s*" + _INT + r"\s*\)"
)

# `.padding(.horizontal, 8)` / `.vertical` / `.top` / `.bottom` /
# `.leading` / `.trailing` — single-edge form.
RX_PADDING_EDGE = re.compile(
    r"\.padding\(\s*"
    r"\.(?P<edge>horizontal|vertical|top|bottom|leading|trailing)\s*,\s*"
    + _INT + r"\s*\)"
)

# `VStack(spacing: 8)`, `HStack(spacing: 8)`, the Lazy* variants.
# The opening of the stack ctor must precede `spacing:` directly OR
# with other args separated by commas — we anchor on the stack name
# and the `spacing:` label and look for an int between them.
RX_STACK_SPACING = re.compile(
    r"\b(?P<stack>VStack|HStack|LazyVStack|LazyHStack)\b\s*"
    r"\([^)]*?\bspacing\s*:\s*" + _INT + r"(?:\s*[,)])"
)

# `LazyVGrid(... spacing: 8)` / `LazyHGrid(... spacing: 8)`.
# Same shape as the stacks but the ctor accepts a `columns:` /
# `rows:` arg first.
RX_GRID_SPACING = re.compile(
    r"\b(?P<grid>LazyVGrid|LazyHGrid)\b\s*"
    r"\([^)]*?\bspacing\s*:\s*" + _INT + r"(?:\s*[,)])"
)

# `Spacer(minLength: 8)`.
RX_SPACER_MIN = re.compile(
    r"\bSpacer\s*\(\s*minLength\s*:\s*" + _INT + r"\s*\)"
)

# All patterns the lint runs, each with a display label.
PATTERNS: list[tuple[str, re.Pattern]] = [
    (".padding(N)", RX_PADDING_BARE),
    (".padding(.edge, N)", RX_PADDING_EDGE),
    ("Stack(spacing: N)", RX_STACK_SPACING),
    ("Grid(spacing: N)", RX_GRID_SPACING),
    ("Spacer(minLength: N)", RX_SPACER_MIN),
]

# ----------------------------------------------------------------------
# Scrubbing — strip comments, string literals, and drawing closures so
# the regexes don't false-positive on (a) comment / docstring example
# code, (b) string content that happens to look like a modifier call,
# or (c) Path/Canvas/Shape.path drawing math.
# ----------------------------------------------------------------------

_LINE_COMMENT = re.compile(r"//[^\n]*")
_BLOCK_COMMENT = re.compile(r"/\*.*?\*/", re.DOTALL)
_TRIPLE_STRING = re.compile(r'""".*?"""', re.DOTALL)
_SINGLE_STRING = re.compile(r'"(?:\\.|[^"\\])*"')

# `Path { ... }`, `Canvas { ... }`, `<...>.path(in: rect) { p in ... }`.
# Drawing closures are matched balanced-brace style by `_scrub_closures`
# below; the regex finds the opening, the helper walks to the matching
# `}`.
_DRAWING_OPEN = re.compile(
    r"\b(?:Path|Canvas)\s*(?:\([^)]*\))?\s*\{"
    r"|\.path\s*\([^)]*\)\s*\{"
)


def _scrub_closures(src: str) -> str:
    """Replace drawing-closure bodies (Path / Canvas / .path) with
    whitespace of equal length, preserving line numbers so later
    line-number calculations stay correct."""
    out = list(src)
    for m in _DRAWING_OPEN.finditer(src):
        # m.end() is one past the `{`. Walk forward to the matching `}`.
        depth = 1
        i = m.end()
        while i < len(src) and depth > 0:
            c = src[i]
            if c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
                if depth == 0:
                    break
            i += 1
        # Replace [m.end() .. i) — keep newlines so line numbers persist.
        for k in range(m.end(), i):
            if out[k] != "\n":
                out[k] = " "
    return "".join(out)


def scrub(src: str) -> str:
    src = _BLOCK_COMMENT.sub(lambda mo: re.sub(r"[^\n]", " ", mo.group(0)), src)
    src = _TRIPLE_STRING.sub(lambda mo: re.sub(r"[^\n]", " ", mo.group(0)), src)
    src = _SINGLE_STRING.sub(lambda mo: re.sub(r"[^\n]", " ", mo.group(0)), src)
    src = _LINE_COMMENT.sub(lambda mo: " " * len(mo.group(0)), src)
    src = _scrub_closures(src)
    return src


# ----------------------------------------------------------------------
# Scanning.
# ----------------------------------------------------------------------

def scan_text(src: str) -> list[tuple[int, str, int, str]]:
    """Return [(line_no, pattern_label, value, token_name), ...] for
    every bare-integer canon violation in `src`."""
    cleaned = scrub(src)
    findings: list[tuple[int, str, int, str]] = []
    seen: set[tuple[int, int]] = set()  # (start_offset, val) dedupe
    for label, rx in PATTERNS:
        for m in rx.finditer(cleaned):
            try:
                val = int(m.group("val"))
            except (ValueError, IndexError):
                continue
            if val not in CANON:
                continue
            key = (m.start("val"), val)
            if key in seen:
                continue
            seen.add(key)
            line_no = cleaned.count("\n", 0, m.start("val")) + 1
            findings.append((line_no, label, val, CANON[val]))
    findings.sort(key=lambda t: (t[0], t[2]))
    return findings


def scan_file(path: Path) -> list[tuple[int, str, int, str]]:
    try:
        return scan_text(path.read_text(encoding="utf-8"))
    except (UnicodeDecodeError, OSError):
        return []


def _should_skip(path: Path) -> bool:
    if path.name in SKIP_FILE_NAMES:
        return True
    parts = path.parts
    for part in SKIP_PATH_PARTS:
        if part in parts:
            return True
    return False


def _count_call_sites(src: str) -> int:
    """Total number of call sites the lint inspects in `src` (any int
    value, in or out of the canon). Used for the success-line tally."""
    cleaned = scrub(src)
    total = 0
    for _, rx in PATTERNS:
        total += sum(1 for _ in rx.finditer(cleaned))
    return total


# ----------------------------------------------------------------------
# Self-test fixtures.
# ----------------------------------------------------------------------

_DANGER_FIXTURE = """
struct V: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("a").padding(8)
            Text("b").padding(.horizontal, 16)
            Text("c").padding(.top, 4)
            HStack(spacing: 24) { Text("d") }
            LazyVStack(spacing: 32) { Text("e") }
            LazyHStack(spacing: 2) { Text("f") }
            LazyVGrid(columns: cols, spacing: 48) { Text("g") }
            LazyHGrid(rows: rows, spacing: 8) { Text("h") }
            Spacer(minLength: 16)
        }
    }
}
"""

_SAFE_FIXTURE = """
struct V: View {
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("a").padding(DesignTokens.Spacing.sm)
            Text("b").padding(.horizontal, DesignTokens.Spacing.lg)
            Text("c").padding(.top, DesignTokens.Spacing.xs)
            HStack(spacing: DesignTokens.Spacing.xl) { Text("d") }
            LazyVStack(spacing: DesignTokens.Spacing.xxl) { Text("e") }
            LazyVGrid(columns: cols, spacing: DesignTokens.Spacing.xxxl) { Text("g") }
            Spacer(minLength: DesignTokens.Spacing.lg)
            // .padding(8)   <- commented out, must be ignored
            // VStack(spacing: 12) {} <- commented out, must be ignored
            Text("inline string with .padding(8) literal").padding(.bottom, 0)
            Text("p").padding(8.5)     // float literal, not in canon
            Text("q").padding(10)      // 10 is not in canon
            Text("r").padding(custom)  // identifier, not a literal
            Path { p in
                p.move(to: CGPoint(x: 8, y: 16))
                p.addLine(to: CGPoint(x: 24, y: 32))
            }
            Canvas { ctx, size in
                ctx.fill(Path(roundedRect: .init(x: 4, y: 4, width: 8, height: 8), cornerRadius: 2), with: .color(.red))
            }
            Rectangle().fill(.red)
                .frame(width: 100, height: 100)
        }
    }
}
"""

# Sanity fixture: a `.padding(...)` whose arg is in the canon must be
# flagged regardless of preceding whitespace / line break.
_LINEBREAK_FIXTURE = """
struct V: View {
    var body: some View {
        Text("a")
            .padding(
                16
            )
    }
}
"""


def run_selftest() -> int:
    ok = True

    d = scan_text(_DANGER_FIXTURE)
    expected_danger = 10
    if len(d) != expected_danger:
        print(
            f"SELFTEST FAIL: danger fixture flagged {len(d)} sites, "
            f"expected {expected_danger}"
        )
        for v in d:
            print("  ", v)
        ok = False
    else:
        print(f"  [PASS] danger fixture flags {expected_danger} sites")

    s = scan_text(_SAFE_FIXTURE)
    if len(s) != 0:
        print(f"SELFTEST FAIL: safe fixture flagged {len(s)} sites, expected 0")
        for v in s:
            print("  ", v)
        ok = False
    else:
        print("  [PASS] safe fixture flags 0 sites")

    lb = scan_text(_LINEBREAK_FIXTURE)
    if len(lb) != 1:
        print(f"SELFTEST FAIL: line-break fixture flagged {len(lb)} sites, expected 1")
        for v in lb:
            print("  ", v)
        ok = False
    else:
        print("  [PASS] line-break fixture flags 1 site")

    print()
    if ok:
        print("check_designtokens_spacing --selftest: PASS")
        return 0
    print("check_designtokens_spacing --selftest: FAIL")
    return 1


# ----------------------------------------------------------------------
# CLI.
# ----------------------------------------------------------------------

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
    total_call_sites = 0
    files_scanned = 0
    for top in args.paths:
        root = Path(top)
        if not root.exists():
            continue
        if root.is_file():
            files = [root] if root.suffix == ".swift" else []
        else:
            files = sorted(root.rglob("*.swift"))
        for swift in files:
            if _should_skip(swift):
                continue
            files_scanned += 1
            try:
                src = swift.read_text(encoding="utf-8")
            except (UnicodeDecodeError, OSError):
                continue
            total_call_sites += _count_call_sites(src)
            for (line_no, label, val, token) in scan_text(src):
                print(
                    f"{swift}:{line_no}: {label} {val} — "
                    f"use DesignTokens.Spacing.{token} instead of {val}"
                )
                failed = True

    if failed:
        print()
        print("These raw spacing literals re-introduce values that waves 1-5 of the")
        print("J8 DesignTokens migration removed. Replace each with the named token")
        print("printed above so phase 3/5/6 of the visual sweep can refine values")
        print("in one place (Extensions.swift) instead of across every Swift file.")
        return 1
    if not args.quiet:
        print(
            f"check_designtokens_spacing: clean — {total_call_sites} raw literals "
            f"checked across {files_scanned} file(s), all use tokens (J8)"
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
