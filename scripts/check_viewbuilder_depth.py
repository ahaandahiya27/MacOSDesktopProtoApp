#!/usr/bin/env python3
"""Big Sur Swift 5.5 result-builder DEPTH lint (segfault guard).

This is the sister of `check_viewbuilder_limit.py`. That one catches the
`buildBlock` *arity* ceiling (>10 direct children). This one catches a
different, nastier Big-Sur-only failure: a single result-builder closure
that is too DEEP/COMPLEX for the Swift 5.5 type-checker, which overflows
the compiler's own stack and dies with:

    error: Segmentation fault: 11 (in target 'desktopAhaan' ...)

It is invisible on the dev Mac. A modern Swift (6.x, the dev machine) solves
the same closure in a few hundred ms; Xcode 13.2.1's Swift 5.5 recurses deep
enough to SIGSEGV. It bit the iMac twice on 2026-06-04:
  * `Scene8_Fragmentation` — nested Int-literal x Double arithmetic inside a
    `CGFloat(...)` (see check note below; that exact class is rarer).
  * `LungAnatomyDiagram` (and ~25 sibling ShapeDiagrams) — a
    `GeometryReader { ZStack { Group { many .position(...) with inline w/h
    coordinate math } } }` closure solved in one pass.

The fix that cleared all of them: pull the closure body into typed helper
funcs (`private func content(w: CGFloat, h: CGFloat) -> some View`, one per
visual cluster), so the type-checker never solves one deep tree. After that
refactor the GeometryReader closure is a single `content(...)` call and this
lint reads ~0 inline-math children for it.

WHAT IT SCANS
-------------
Every `GeometryReader { ... }` closure under `desktopAhaan/`. Within each
closure body (brace-depth matched), it counts INLINE coordinate-math view
modifiers — `.position(...)`, `.frame(...)`, `.offset(...)` whose arguments
reference a geometry local (`w`, `h`, `cx`, `cy`, `geo`) or a `* 0.<digit>`
scale factor. If a single closure carries >= LIMIT such inline calls it is
flagged: that closure should delegate to helper funcs.

After the 2026-06-04 sweep the worst *remaining* (legitimately safe, already
helper-delegating) closure scores 4. The default limit is 8 — comfortably
above the safe baseline and well below the ~16 that crashed the iMac.

HEURISTIC. It can miss a deep closure that hides its math in custom Shapes,
and it can in principle over-count a closure that legitimately needs many
positioned children (wrap them in helper funcs anyway — it is free and it is
the documented Big-Sur-safe pattern). Ground truth is always an Xcode 13.2.1
build on Big Sur.
"""
import argparse
import re
import sys
from pathlib import Path

DEFAULT_LIMIT = 8

# An inline coordinate-math modifier: .position(/.frame(/.offset( whose
# argument list mentions a geometry local or a fractional scale factor.
_MATH_MOD = re.compile(
    r'\.(?:position|frame|offset)\([^)]*'
    r'(?:\b(?:w|h|cx|cy|geo)\b|\*\s*0\.\d|0\.\d+\s*\*)'
)


def _geometryreader_closures(src: str):
    """Yield (line_no, body_text) for each `GeometryReader { ... }` closure,
    matching braces so nested `{ }` (Paths, ForEach, modifiers) stay inside."""
    for m in re.finditer(r'GeometryReader\s*\{', src):
        open_brace = m.end() - 1
        depth = 0
        i = open_brace
        while i < len(src):
            c = src[i]
            if c == '{':
                depth += 1
            elif c == '}':
                depth -= 1
                if depth == 0:
                    break
            i += 1
        body = src[open_brace + 1:i]
        line_no = src.count('\n', 0, m.start()) + 1
        yield line_no, body


def scan_file(path: Path, limit: int):
    findings = []
    try:
        src = path.read_text(encoding='utf-8')
    except (UnicodeDecodeError, OSError):
        return findings
    if 'GeometryReader' not in src:
        return findings
    for line_no, body in _geometryreader_closures(src):
        n = len(_MATH_MOD.findall(body))
        if n >= limit:
            findings.append((line_no, n))
    return findings


def run_selftest() -> int:
    danger = """
    struct D: View {
      var body: some View {
        GeometryReader { geo in
          let w = geo.size.width, h = geo.size.height
          ZStack {
            A().frame(width: w * 0.2, height: h * 0.3).position(x: w * 0.1, y: h * 0.2)
            B().frame(width: w * 0.2, height: h * 0.3).position(x: w * 0.3, y: h * 0.2)
            C().position(x: w * 0.5, y: h * 0.4)
            E().position(x: w * 0.6, y: h * 0.5)
            F().offset(x: w * 0.1)
            G().position(x: cx, y: cy)
            H().position(x: w * 0.7, y: h * 0.8)
            I().position(x: w * 0.9, y: h * 0.9)
          }
        }
      }
    }
    """
    safe = """
    struct S: View {
      var body: some View {
        GeometryReader { geo in content(w: geo.size.width, h: geo.size.height) }
      }
      private func content(w: CGFloat, h: CGFloat) -> some View {
        ZStack { cluster(w: w, h: h) }
      }
    }
    """
    import tempfile
    ok = True
    with tempfile.TemporaryDirectory() as d:
        dp = Path(d) / "danger.swift"
        sp = Path(d) / "safe.swift"
        dp.write_text(danger)
        sp.write_text(safe)
        if not scan_file(dp, DEFAULT_LIMIT):
            print("SELFTEST FAIL: monolithic GeometryReader body not flagged")
            ok = False
        if scan_file(sp, DEFAULT_LIMIT):
            print("SELFTEST FAIL: delegating GeometryReader body wrongly flagged")
            ok = False
    print("selftest passed" if ok else "selftest FAILED")
    return 0 if ok else 1


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("paths", nargs="*", default=["desktopAhaan"],
                    help="roots to scan (default: desktopAhaan)")
    ap.add_argument("--limit", type=int, default=DEFAULT_LIMIT,
                    help=f"max inline coordinate-math modifiers per GeometryReader "
                         f"closure (default {DEFAULT_LIMIT})")
    ap.add_argument("--selftest", action="store_true")
    ap.add_argument("--quiet", action="store_true")
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
            for (line_no, n) in scan_file(swift, args.limit):
                print(f"{swift}:{line_no}  GeometryReader closure has {n} inline "
                      f"coordinate-math modifiers (limit {args.limit})")
                failed = True
    if failed:
        print()
        print("These GeometryReader closures are dense enough to risk a Swift 5.5")
        print("type-checker stack overflow on Big Sur / Xcode 13.2.1:")
        print("    error: Segmentation fault: 11")
        print("Pull the closure body into typed helper funcs, e.g.:")
        print("    GeometryReader { geo in content(w: geo.size.width, h: geo.size.height) }")
        print("    private func content(w: CGFloat, h: CGFloat) -> some View { ... }")
        print("with one helper per visual cluster (see LungAnatomyDiagram in")
        print("Chapter10ShapeDiagrams.swift). Heuristic — Big-Sur Xcode is ground truth.")
        return 1
    if not args.quiet:
        print("no over-dense GeometryReader closures found "
              "(heuristic — verify on Big Sur Xcode for certainty)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
