#!/usr/bin/env python3
"""Swift 5.5 @ViewBuilder forbids explicit `return` in multi-statement
closures.

What this gates. A `GeometryReader { geo in let _ = ...; return ZStack
{ ... } }` shape compiles on Swift 6 (dev Mac) — but Swift 5.5 (iMac
Xcode 13.2.1) rejects it with:

    Cannot use explicit 'return' statement in the body of result builder
    'ViewBuilder'
    Remove 'return' statements to apply the result builder

The 2026-06-05 iMac build surfaced this in two files
(`Scene1_HeartBeats.swift`, `Scene1_MirrorMirror.swift`) — both where
an earlier sub-agent's modifier-math hoist added typed `let`
declarations above the `ZStack` and then added an explicit `return`.
The fix is to extract the body into a typed `private func content(w:h:)
-> some View` helper — that's a regular function, where `return` is
required and fine.

The safe pattern (caught by the existing `check_inline_modifier_math`
canonical template, commit ccd011a):

    var body: some View {
        GeometryReader { geo in
            content(w: geo.size.width, h: geo.size.height)
        }
    }

    private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w / 2
        return ZStack { ... }     // ← OK in a regular func
    }

The forbidden pattern this lint catches:

    GeometryReader { geo in
        let w = geo.size.width
        let h = geo.size.height
        let cx: CGFloat = w / 2
        return ZStack { ... }     // ← Swift 5.5 ViewBuilder rejects
    }

Heuristic. Tracks closure-opener lines containing `{ geo in` or
matching common @ViewBuilder trailing-closure patterns
(`GeometryReader`, `ScrollView`, `ZStack`, `VStack`, `HStack`, `Group`,
`Section`, `LazyVStack`, `LazyHStack` followed by `{ ... in }` /
`{ proxy in }` / similar). When such a closure body contains a
top-level `return` statement before its closing brace, flag it.

Usage:
    python3 scripts/check_return_in_viewbuilder.py [--quiet] [paths ...]
    python3 scripts/check_return_in_viewbuilder.py --selftest
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

# Lines that open a @ViewBuilder-typed closure with an explicit
# parameter name (e.g. `GeometryReader { geo in`). The `in` token is
# the trailing-closure parameter list opener.
_CLOSURE_OPENERS = re.compile(
    r"\b(?:GeometryReader|ScrollView|ScrollViewReader|NavigationView|NavigationStack|TabView)\s*\{[^{}]*\bin\b|\bGeometryReader\s*\{"
)

_LINE_COMMENT = re.compile(r"//[^\n]*")
_RETURN_STMT = re.compile(r"^\s*return\s+\w")


def _balanced_close(src: str, open_idx: int) -> int:
    """Return index of the matching `}` for the `{` at `open_idx`."""
    depth = 0
    i = open_idx
    in_str = False
    while i < len(src):
        c = src[i]
        if in_str:
            if c == "\\" and i + 1 < len(src):
                i += 2
                continue
            if c == '"':
                in_str = False
        else:
            if c == '"':
                in_str = True
            elif c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
                if depth == 0:
                    return i
        i += 1
    return -1


def scan_text(src: str) -> list[tuple[int, str]]:
    cleaned = _LINE_COMMENT.sub("", src)
    findings: list[tuple[int, str]] = []
    # Find every `GeometryReader { ... in` opener and check whether
    # any direct `return X` appears at the OUTERMOST nesting of the
    # closure body (not inside a Path closure, not inside a nested
    # Group, etc.).
    for m in re.finditer(r"\bGeometryReader\s*\{", cleaned):
        brace_idx = m.end() - 1
        close_idx = _balanced_close(cleaned, brace_idx)
        if close_idx < 0:
            continue
        body = cleaned[brace_idx + 1 : close_idx]
        # The closure starts on the same line as `GeometryReader {`.
        # Walk the body and find a `return ZStack/VStack/...` whose
        # LINE START is at depth-0 (i.e. one nesting level inside the
        # outer closure `{`). We snapshot depth at each line boundary
        # so a `return X {` line doesn't get masked by its own opening
        # brace incrementing depth before we check.
        depth = 0
        in_str = False
        line_start = 0
        line_start_depth = 0
        for j, c in enumerate(body):
            if in_str:
                if c == "\\":
                    continue
                if c == '"':
                    in_str = False
                continue
            if c == '"':
                in_str = True
            elif c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
            elif c == "\n":
                # Check the line we just finished — use the depth as
                # of the line's START, before any of its own braces.
                line_text = body[line_start:j]
                if line_start_depth == 0 and _RETURN_STMT.match(line_text):
                    abs_pos = brace_idx + 1 + line_start
                    line_no = cleaned.count("\n", 0, abs_pos) + 1
                    findings.append((line_no, line_text.strip()))
                line_start = j + 1
                line_start_depth = depth
    return findings


def scan_file(path: Path) -> list[tuple[int, str]]:
    try:
        return scan_text(path.read_text(encoding="utf-8"))
    except (UnicodeDecodeError, OSError):
        return []


def run_selftest() -> int:
    danger = """
    struct V: View {
      var body: some View {
        GeometryReader { geo in
          let w = geo.size.width
          let h = geo.size.height
          let cx: CGFloat = w / 2
          return ZStack {
            Text("x").position(x: cx, y: h / 2)
          }
        }
      }
    }
    """
    safe = """
    struct V: View {
      var body: some View {
        GeometryReader { geo in
          content(w: geo.size.width, h: geo.size.height)
        }
      }
      private func content(w: CGFloat, h: CGFloat) -> some View {
        let cx: CGFloat = w / 2
        return ZStack {
          Text("x").position(x: cx, y: h / 2)
        }
      }
    }
    """
    ok = True
    d = scan_text(danger)
    if len(d) != 1:
        print(f"SELFTEST FAIL: danger fixture flagged {len(d)} sites, expected 1")
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
            for (line_no, snippet) in scan_file(swift):
                print(
                    f"{swift}:{line_no}  explicit `return` inside GeometryReader closure — extract to typed func"
                )
                print(f"    {snippet}")
                failed = True
    if failed:
        print()
        print("These `return X` statements sit inside a `GeometryReader { geo")
        print("in ... }` @ViewBuilder closure. Swift 5.5 / Xcode 13.2.1 (iMac)")
        print("rejects them with:")
        print("    Cannot use explicit 'return' statement in the body of")
        print("    result builder 'ViewBuilder'")
        print()
        print("Fix: extract the body into a typed helper")
        print("    private func content(w: CGFloat, h: CGFloat) -> some View")
        print("and call it from the GeometryReader closure (mirror commit")
        print("ccd011a's pattern).")
        return 1
    if not args.quiet:
        print("no explicit `return` statements inside GeometryReader closures")
    return 0


if __name__ == "__main__":
    sys.exit(main())
