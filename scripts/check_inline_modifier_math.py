#!/usr/bin/env python3
"""Big Sur Swift 5.5 inline-modifier-math lint (segfault guard).

Sister to `check_viewbuilder_depth.py`. That one catches DENSE
GeometryReader closures (many positioned children in one closure). This
one catches the FINER-GRAINED case the depth lint misses: a single
`.frame(...)` / `.position(...)` / `.offset(...)` / `.padding(...)` call
whose argument list contains a bare arithmetic expression
(`w * 0.3`, `cx - h * 0.16`, `cy + offset`).

Why it matters. On the deploy iMac (Big Sur 11.7.11 / Xcode 13.2.1 /
Swift 5.5 / 8 GB RAM) a result-builder closure with many such inline
arithmetic modifier args trips the constraint solver into recursing
through every `CGFloat * Double` overload, overflowing the compiler's
own stack:

    error: Segmentation fault: 11 (in target 'desktopAhaan' ...)

The fix is mechanical: hoist every arithmetic expression to an explicit
`let _: CGFloat = ...` local above the `return Group { ... }`. View
modifier args end up containing only named locals, integer literals,
and color/lineWidth/string literals. See commit ccd011a (Chapter10
ShapeDiagrams, canonical) and the wider sweep in commit 162a71b
(16 ShapeDiagrams files).

What this lint scans. For every `.swift` file under `desktopAhaan/`,
every call site of one of `.frame(`, `.position(`, `.offset(`,
`.padding(`, it extracts the balanced paren-content and asks: does the
content contain a binary arithmetic operator between two non-string,
non-keyword-argument-label tokens? If yes, flag.

The lint does NOT need to track "inside Path closure" because Path
closures use `p.move(to:)` / `p.addLine(to:)` / etc. — never the four
modifier names above. So a `.position(` site is always a view-modifier
call by construction.

This is a HEURISTIC. Possible misses (worth knowing):
  - Arithmetic hidden inside a helper function call passed as a modifier
    arg, e.g. `.position(at: myPoint(w, h))`. Cheap to spot manually;
    keep `myPoint` simple.
  - `.frame(maxWidth: .infinity)` — `.infinity` is property access, not
    arithmetic — correctly NOT flagged.
  - Negative literals (`.offset(x: -10)`) — leading `-` is unary, not
    binary — correctly NOT flagged (the regex requires a token BEFORE
    the operator).
  - Block comments `/* ... */` inside arg lists could mask operators
    inside the comment. Rare in this codebase; not handled.

HEURISTIC. After it flags a site, open the line and verify before
hoisting. Ground truth remains an Xcode 13.2.1 build on Big Sur.

Usage:
    python3 scripts/check_inline_modifier_math.py [--quiet] [paths ...]
    python3 scripts/check_inline_modifier_math.py --selftest
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

# Modifiers whose argument lists are arithmetic-sensitive in result-builder
# closures. The first four (frame/position/offset/padding) were the original
# hits on 2026-06-04. The rest were added on the follow-up sweep — same
# segfault class, just a wider numeric-arg modifier set: `.shadow(radius:)`,
# `.scaleEffect(x:y:)`, `.cornerRadius(r)`, `.rotationEffect(.degrees(a))`,
# `.blur(radius:)`, `.lineSpacing(x)`, `.kerning(x)`, `.tracking(x)`,
# `.opacity(x)`, `.brightness(x)`, `.contrast(x)`, `.saturation(x)`,
# `.hueRotation(.degrees(a))`.
MODIFIERS = (
    "frame", "position", "offset", "padding",
    "shadow", "scaleEffect", "cornerRadius", "rotationEffect", "blur",
    "lineSpacing", "kerning", "tracking", "opacity",
    "brightness", "contrast", "saturation", "hueRotation",
)

# Match the start of one of the four modifier calls. The leading `.`
# disambiguates them from same-named free functions.
_MOD_START = re.compile(
    r"\.(?P<name>" + "|".join(MODIFIERS) + r")\("
)

# Constructors whose argument lists are arithmetic-sensitive in result-builder
# closures — same segfault class as the modifiers, just without the leading
# `.` (these are bare type initializers). The Swift 5.5 constraint solver
# still has to disambiguate `CGFloat * Double` inside their arg lists when
# the constructor is a child of a Group/ZStack/VStack/HStack closure.
#
# Each entry is (display_name, regex_for_constructor_start). The regex
# anchors on a word boundary to avoid matching inside identifiers, and
# matches the opening `(` so the existing balanced-paren routine can finish.
_CONSTRUCTORS = (
    ("RoundedRectangle(...)", re.compile(r"\bRoundedRectangle\(")),
    ("Capsule(...)", re.compile(r"\bCapsule\(")),
    ("HStack(...)", re.compile(r"\bHStack\(")),
    ("VStack(...)", re.compile(r"\bVStack\(")),
    ("LazyHStack(...)", re.compile(r"\bLazyHStack\(")),
    ("LazyVStack(...)", re.compile(r"\bLazyVStack\(")),
    (".system(size:)", re.compile(r"\.system\(")),
    # ForEach(0..<<arithmetic>) range bound, e.g. `ForEach(0..<Int(x * y))`.
    # The full arg list goes through the same Swift-5.5 solver path.
    ("ForEach(...)", re.compile(r"\bForEach\(")),
    # Slider / Stepper bounds: `in: lo...hi` where hi is arithmetic.
    ("Slider(...)", re.compile(r"\bSlider\(")),
    ("Stepper(...)", re.compile(r"\bStepper\(")),
)

# A binary arithmetic operator between two "real" tokens — identifier,
# number, closing paren/bracket on the left; identifier, number, opening
# paren/bracket on the right. Whitespace allowed around the operator.
# Forbids:
#   - leading-`-` unary (need a token before `-`)
#   - keyword arg labels (`:` precedes the `-` in unary cases like
#     `width: -10`, and `:` is not in the left-side character class)
#   - string content (the modifier args here never contain string
#     literals with `+`/`-`/`*`/`/`)
_BINARY_OP = re.compile(
    r"[A-Za-z0-9_)\]]\s*[+\-*/]\s*[A-Za-z0-9_(\[]"
)

# Strip `// ...` line comments to avoid false positives from `// h * 0.3`
# style annotations. Leaves block comments alone (rare in this codebase).
_LINE_COMMENT = re.compile(r"//[^\n]*")


def _balanced_paren_end(src: str, open_idx: int) -> int:
    """Return index of the matching `)` for the `(` at `open_idx`, or -1."""
    depth = 0
    i = open_idx
    in_str = False
    str_quote = ""
    while i < len(src):
        c = src[i]
        if in_str:
            if c == "\\" and i + 1 < len(src):
                i += 2
                continue
            if c == str_quote:
                in_str = False
        else:
            if c == '"':
                in_str = True
                str_quote = c
            elif c == "(":
                depth += 1
            elif c == ")":
                depth -= 1
                if depth == 0:
                    return i
        i += 1
    return -1


def scan_text(src: str) -> list[tuple[int, str, str]]:
    """Return a list of (line_no, modifier_name, arg_content) violations."""
    cleaned = _LINE_COMMENT.sub("", src)
    findings: list[tuple[int, str, str]] = []
    for m in _MOD_START.finditer(cleaned):
        open_idx = m.end() - 1  # index of the `(`
        close_idx = _balanced_paren_end(cleaned, open_idx)
        if close_idx < 0:
            continue
        args = cleaned[open_idx + 1 : close_idx]
        if _BINARY_OP.search(args):
            line_no = cleaned.count("\n", 0, m.start()) + 1
            findings.append((line_no, m.group("name"), args.strip()))
    for display_name, regex in _CONSTRUCTORS:
        for m in regex.finditer(cleaned):
            # The constructor regex matches up to and including `(`; balanced
            # paren routine wants the `(` index.
            open_idx = m.end() - 1
            close_idx = _balanced_paren_end(cleaned, open_idx)
            if close_idx < 0:
                continue
            args = cleaned[open_idx + 1 : close_idx]
            if _BINARY_OP.search(args):
                line_no = cleaned.count("\n", 0, m.start()) + 1
                findings.append((line_no, display_name, args.strip()))
    findings.sort(key=lambda t: t[0])
    return findings


def scan_file(path: Path) -> list[tuple[int, str, str]]:
    try:
        return scan_text(path.read_text(encoding="utf-8"))
    except (UnicodeDecodeError, OSError):
        return []


def run_selftest() -> int:
    danger = """
    struct V: View {
      var body: some View {
        ZStack {
          Circle().frame(width: w * 0.3, height: h * 0.4)
          Text("x").position(x: cx + 10, y: cy)
          Image(systemName: "x").offset(x: w / 2)
          Rectangle().padding(.horizontal, base + 8)
          Circle().shadow(color: .black, radius: r * 2, x: 0, y: r)
          Circle().scaleEffect(1 + bounce * 0.2)
          Circle().cornerRadius(r * 2)
          Text("x").rotationEffect(.degrees(angle * 90))
          Rectangle().blur(radius: r * 0.5)
          Text("x").opacity(0.5 + alpha * 0.3)
          RoundedRectangle(cornerRadius: r * 2).fill(.red)
          Capsule(cornerRadius: r * 2).fill(.blue)
          HStack(spacing: gap + 4) { Text("a") }
          VStack(spacing: base * 2) { Text("b") }
          Text("z").font(.system(size: scale * 16))
          ForEach(0..<Int(progress * 10), id: \\.self) { _ in Text("p") }
          Slider(value: $v, in: 0...max + 5)
        }
      }
    }
    """
    safe = """
    struct V: View {
      var body: some View {
        let cellW: CGFloat = w * 0.5
        let cellH: CGFloat = h * 0.5
        let shadowR: CGFloat = r * 2
        let scale: CGFloat = 1 + bounce * 0.2
        let corner: CGFloat = r * 2
        let hgap: CGFloat = gap + 4
        let fontSize: CGFloat = scale * 16
        let particleCount: Int = Int(progress * 10)
        let sliderMax: CGFloat = maxVal + 5
        return ZStack {
          Circle().frame(width: cellW, height: cellH)
          Text("x").position(x: cx, y: cy)
          Image(systemName: "x").offset(x: -10)
          Rectangle().padding(.horizontal, 8)
          Text("x").frame(maxWidth: .infinity, maxHeight: .infinity)
          Circle().shadow(color: .black, radius: shadowR, x: 0, y: shadowR)
          Circle().scaleEffect(scale)
          Circle().cornerRadius(8)
          Text("x").rotationEffect(.degrees(45))
          Rectangle().blur(radius: 4)
          Text("x").opacity(0.7)
          RoundedRectangle(cornerRadius: corner).fill(.red)
          Capsule(cornerRadius: corner).fill(.blue)
          HStack(spacing: hgap) { Text("a") }
          VStack(spacing: 12) { Text("b") }
          Text("z").font(.system(size: fontSize))
          ForEach(items, id: \\.self) { _ in Text("p") }
          ForEach(0..<particleCount, id: \\.self) { _ in Text("p") }
          Slider(value: $v, in: 0...sliderMax)
          Slider(value: $v, in: -10...10)
          // .position(x: w * 0.5, y: h * 0.5)  ← commented out, ignored
        }
      }
    }
    """
    ok = True
    d = scan_text(danger)
    if len(d) != 17:
        print(f"SELFTEST FAIL: danger fixture flagged {len(d)} sites, expected 17")
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
            for (line_no, name, args_text) in scan_file(swift):
                trimmed = args_text if len(args_text) <= 80 else args_text[:77] + "..."
                # Modifier names are bare words ("frame") — render as ".frame(...)".
                # Constructor names already carry their decorations
                # ("RoundedRectangle(...)") — render as-is.
                rendered = name if "(" in name else f".{name}(...)"
                print(
                    f"{swift}:{line_no}  {rendered} has inline arithmetic — hoist to typed CGFloat local"
                )
                print(f"    args: {trimmed}")
                failed = True
    if failed:
        print()
        print("These view-modifier calls contain arithmetic expressions in their")
        print("argument lists. On Swift 5.5 / Xcode 13.2.1 (Big Sur iMac) the")
        print("constraint solver recurses through every `CGFloat * Double`")
        print("overload inside the result-builder closure and overflows the")
        print("compiler stack → `error: Segmentation fault: 11`.")
        print()
        print("Fix: hoist the expression to an explicit typed local above the")
        print("`return Group { ... }`, e.g.:")
        print("    let lungW: CGFloat = w * 0.28")
        print("    let lungY: CGFloat = h * 0.55")
        print("    return Group {")
        print("        LungShape().frame(width: lungW).position(x: cx, y: lungY)")
        print("    }")
        print()
        print("See commit ccd011a (Chapter10ShapeDiagrams) for the canonical")
        print("pattern and 162a71b for the 16-file sweep. Heuristic — Big-Sur")
        print("Xcode is ground truth.")
        return 1
    if not args.quiet:
        print(
            "no inline arithmetic in view-modifier args "
            "(heuristic — verify on Big Sur Xcode for certainty)"
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
