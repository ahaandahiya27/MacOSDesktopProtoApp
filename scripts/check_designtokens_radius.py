#!/usr/bin/env python3
"""DesignTokens.Radius migration ratchet (J8).

Sister to `check_designtokens_spacing.py`. The same 5-wave migration
that consolidated padding/spacing literals also collapsed every
corner-radius literal in the design canon ({8, 10, 14, 16, 22, 999})
onto named `DesignTokens.Radius.*` tokens (sm / md / card / lg / xl /
pill). This lint keeps a future PR from silently re-introducing the
raw literals.

It scans, under `desktopAhaan/`, every call site of:

  * `.cornerRadius(N)`
  * `RoundedRectangle(cornerRadius: N)` and the `style: .continuous`
    variant.
  * `.clipShape(RoundedRectangle(cornerRadius: N))` and the
    `style: .continuous` variant.

… and flags the call when `N` is a bare integer literal in the
design canon set `{8, 10, 14, 16, 22, 999}`. The 999 maps to the
"pill" token used for fully-rounded capsule shapes.

Skip list (intentionally allowed raw literals) — same as the
spacing ratchet:
  - `desktopAhaan/Extensions/Extensions.swift` — defines the tokens
    themselves; the literals on the RHS of `static let sm: CGFloat
    = 8` ARE the canon.
  - Article rendering surfaces — NativeArticleRepresentable.swift,
    ArticleStructuredRenderer.swift,
    ArticleStructuredRenderer+Render.swift.
  - Test bundles — desktopAhaanTests/, desktopAhaanUITests/.

Also skipped within a file:
  - Comment lines (// ...) and block comments (/* ... */).
  - String literals (single and triple-quoted Swift string forms).
  - `Path { ... }`, `Shape.path(in:) { ... }`, and `Canvas { ... }`
    closures — drawing math uses literal radii (e.g. inside
    `Path(roundedRect:cornerRadius:)`) that don't belong in the
    design canon.
  - Sites where the argument is already a `DesignTokens.Radius.*`
    reference (those are the goal state — never flagged).
  - Sites where the argument is a non-integer, a variable, or an
    expression — only BARE integer literals are flagged.

Usage:
    python3 scripts/check_designtokens_radius.py [--quiet] [paths ...]
    python3 scripts/check_designtokens_radius.py --selftest
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

# The design canon of corner-radius literals. Mapping is integer →
# named token under `DesignTokens.Radius`.
CANON: dict[int, str] = {
    8: "sm",
    10: "md",
    14: "card",
    16: "lg",
    22: "xl",
    999: "pill",
}

SKIP_FILE_NAMES = {
    "Extensions.swift",
    "NativeArticleRepresentable.swift",
    "ArticleStructuredRenderer.swift",
    "ArticleStructuredRenderer+Render.swift",
}
SKIP_PATH_PARTS = ("desktopAhaanTests", "desktopAhaanUITests")

# Bare positive integer — anchored to avoid bleeding into floats
# (`8.0`), parts of larger numbers (`80`), or identifiers (`r8`).
_INT = r"(?<![\w.])(?P<val>\d+)(?![\w.])"

# ----------------------------------------------------------------------
# Call-site regexes.
# ----------------------------------------------------------------------

# `.cornerRadius(8)` — bare integer arg.
RX_CORNER_RADIUS = re.compile(
    r"\.cornerRadius\(\s*" + _INT + r"\s*\)"
)

# `RoundedRectangle(cornerRadius: 8)` and `... cornerRadius: 8, style:
# .continuous)`. Anchors on the ctor name + `cornerRadius:` label, then
# the int.
RX_ROUNDED_RECT = re.compile(
    r"\bRoundedRectangle\s*\(\s*cornerRadius\s*:\s*" + _INT
    + r"(?:\s*,\s*style\s*:\s*\.\w+)?\s*\)"
)

# `.clipShape(RoundedRectangle(cornerRadius: 8))` and the continuous
# variant. The outer `.clipShape(` and inner ctor are validated; the
# int captures from inside the inner ctor.
RX_CLIPSHAPE_ROUNDED = re.compile(
    r"\.clipShape\(\s*RoundedRectangle\s*\(\s*cornerRadius\s*:\s*"
    + _INT + r"(?:\s*,\s*style\s*:\s*\.\w+)?\s*\)\s*\)"
)

PATTERNS: list[tuple[str, re.Pattern]] = [
    (".cornerRadius(N)", RX_CORNER_RADIUS),
    ("RoundedRectangle(cornerRadius: N)", RX_ROUNDED_RECT),
    (".clipShape(RoundedRectangle(cornerRadius: N))", RX_CLIPSHAPE_ROUNDED),
]

# ----------------------------------------------------------------------
# Scrubbing.
# ----------------------------------------------------------------------

_LINE_COMMENT = re.compile(r"//[^\n]*")
_BLOCK_COMMENT = re.compile(r"/\*.*?\*/", re.DOTALL)
_TRIPLE_STRING = re.compile(r'""".*?"""', re.DOTALL)
_SINGLE_STRING = re.compile(r'"(?:\\.|[^"\\])*"')
_DRAWING_OPEN = re.compile(
    r"\b(?:Path|Canvas)\s*(?:\([^)]*\))?\s*\{"
    r"|\.path\s*\([^)]*\)\s*\{"
)


def _scrub_closures(src: str) -> str:
    out = list(src)
    for m in _DRAWING_OPEN.finditer(src):
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
    seen: set[tuple[int, int]] = set()
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
        VStack {
            Text("a").cornerRadius(8)
            Text("b").cornerRadius(10)
            Text("c").cornerRadius(14)
            Text("d").cornerRadius(16)
            Text("e").cornerRadius(22)
            Text("f").cornerRadius(999)
            RoundedRectangle(cornerRadius: 8).fill(.red)
            RoundedRectangle(cornerRadius: 14, style: .continuous).fill(.blue)
            Image("p").clipShape(RoundedRectangle(cornerRadius: 16))
            Image("q").clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }
}
"""

_SAFE_FIXTURE = """
struct V: View {
    var body: some View {
        VStack {
            Text("a").cornerRadius(DesignTokens.Radius.sm)
            Text("b").cornerRadius(DesignTokens.Radius.md)
            Text("c").cornerRadius(DesignTokens.Radius.card)
            Text("d").cornerRadius(DesignTokens.Radius.lg)
            Text("e").cornerRadius(DesignTokens.Radius.xl)
            Text("f").cornerRadius(DesignTokens.Radius.pill)
            RoundedRectangle(cornerRadius: DesignTokens.Radius.sm).fill(.red)
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card, style: .continuous).fill(.blue)
            Image("p").clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
            // .cornerRadius(8)   <- commented out, must be ignored
            // RoundedRectangle(cornerRadius: 14, style: .continuous)
            Text("inline literal: .cornerRadius(8)").cornerRadius(DesignTokens.Radius.sm)
            Text("z").cornerRadius(6)        // 6 is not in the canon
            Text("y").cornerRadius(20)       // 20 is not in the canon
            Text("x").cornerRadius(customR)  // identifier, not a literal
            Text("w").cornerRadius(8.0)      // float, not an int literal
            Path { p in
                p.addRoundedRect(in: rect, cornerSize: CGSize(width: 8, height: 8))
            }
            Canvas { ctx, size in
                ctx.fill(Path(roundedRect: rect, cornerRadius: 14), with: .color(.red))
            }
        }
    }
}
"""

# A `RoundedRectangle(cornerRadius:)` whose value spans a line break.
# Should still flag.
_LINEBREAK_FIXTURE = """
struct V: View {
    var body: some View {
        RoundedRectangle(
            cornerRadius: 14,
            style: .continuous
        ).fill(.red)
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
        print("check_designtokens_radius --selftest: PASS")
        return 0
    print("check_designtokens_radius --selftest: FAIL")
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
                    f"use DesignTokens.Radius.{token} instead of {val}"
                )
                failed = True

    if failed:
        print()
        print("These raw corner-radius literals re-introduce values that waves 1-5")
        print("of the J8 DesignTokens migration removed. Replace each with the named")
        print("token printed above so phase 3/5/6 of the visual sweep can refine")
        print("values in one place (Extensions.swift) instead of across every file.")
        return 1
    if not args.quiet:
        print(
            f"check_designtokens_radius: clean — {total_call_sites} raw literals "
            f"checked across {files_scanned} file(s), all use tokens (J8)"
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
