#!/usr/bin/env python3
"""check_no_wkwebview.py — block WKWebView reintroduction.

Background. WKWebView was permanently retired in this codebase
(`CRASH_LEDGER.md` row C2, `docs/ISSUE_CATEGORIES.md` row MM2). The
replacement is `NativeArticleRepresentable` (NSTextView in NSScrollView).
The retirement was driven by a Big-Sur-only `EXC_BAD_ACCESS` in
`objc_release` on the "close article → Try Discover Mode" path — a
dismantle-order over-release in WKWebView's coordinator teardown that
the Apple-side fix has not landed for the AMD R9 M290X / Big Sur
combination on the target iMac. The fix is dismantle-order, but the
real safety is to not use WKWebView at all.

This lint blocks regression. Any:
  • `import WebKit`
  • Any non-comment reference to `WKWebView`
fails the gate.

Comments and string literals mentioning WKWebView are allowed — the
codebase has ~7 doc comments explaining the retirement (and may grow
more as rationale gets cited). The lint distinguishes:
  - `// WKWebView is retired ...`  → comment, OK
  - `let s = "WKWebView risk"`     → string literal, OK
  - `import WebKit`                 → import, FAIL
  - `let v = WKWebView(...)`        → code, FAIL

Detection is line-based with a comment + string-literal mask:
  1. Lines starting with `//`, `///`, `*`, `/*` (after trim) → OK
  2. Substrings inside `"..."` quotes are masked out before the check
  3. After masking, if the line contains `WKWebView` or `import WebKit`
     → FAIL

Usage:
    python3 scripts/check_no_wkwebview.py             # whole repo
    python3 scripts/check_no_wkwebview.py FILE [...]  # scoped
    python3 scripts/check_no_wkwebview.py --selftest  # fixtures

Exit 0 = clean, 1 = violation. Wired into ci-build-test + pre-commit.
"""
from __future__ import annotations

import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCAN_ROOT = os.path.join(REPO, "desktopAhaan")

_STRING_LITERAL_RE = re.compile(r'"(?:[^"\\]|\\.)*"')
_BANNED_TOKENS = ("WKWebView", "import WebKit")


def _strip_strings_and_check(line: str) -> bool:
    """Return True iff the line, with string literals masked out and
    comments stripped, contains a banned token."""
    stripped = line.lstrip()
    # Skip single-line + triple-slash + block-comment-start lines.
    if (stripped.startswith("//") or stripped.startswith("///")
            or stripped.startswith("*") or stripped.startswith("/*")):
        return False
    # Mask string literals so a "WKWebView" inside a docstring or log
    # message doesn't trip the check.
    masked = _STRING_LITERAL_RE.sub("", line)
    return any(tok in masked for tok in _BANNED_TOKENS)


def audit_file(path: str) -> list[tuple[int, str]]:
    """Return (line_number, source_line) for each violation. 1-based."""
    try:
        with open(path, "r", encoding="utf-8") as fh:
            lines = fh.read().split("\n")
    except (OSError, UnicodeDecodeError):
        return []
    out: list[tuple[int, str]] = []
    in_block_comment = False
    for i, line in enumerate(lines):
        # Crude block-comment tracker. Good enough — the codebase
        # uses single-line `//` overwhelmingly; `/* ... */` is rare.
        if in_block_comment:
            if "*/" in line:
                in_block_comment = False
            continue
        if "/*" in line and "*/" not in line:
            in_block_comment = True
            continue
        if _strip_strings_and_check(line):
            out.append((i + 1, line.rstrip()))
    return out


def _walk_swift_files(root: str) -> list[str]:
    out: list[str] = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [
            d for d in dirnames
            if d not in {".build", ".dd", ".dd-olytest", ".dd-typecheck",
                         "DerivedData", "__pycache__"}
            and not d.startswith(".backup_xcode")
        ]
        for n in filenames:
            if n.endswith(".swift"):
                out.append(os.path.join(dirpath, n))
    return out


def audit_repo() -> tuple[list[str], int]:
    files = _walk_swift_files(SCAN_ROOT)
    formatted: list[str] = []
    for f in files:
        for ln, src in audit_file(f):
            rel = os.path.relpath(f, REPO)
            formatted.append(f"{rel}:{ln}  WKWebView reintroduced: {src.strip()[:120]}")
    return formatted, len(files)


def audit_paths(paths: list[str]) -> list[str]:
    formatted: list[str] = []
    for p in paths:
        p_abs = p if os.path.isabs(p) else os.path.join(REPO, p)
        if not p_abs.endswith(".swift") or not os.path.isfile(p_abs):
            continue
        for ln, src in audit_file(p_abs):
            rel = os.path.relpath(p_abs, REPO)
            formatted.append(f"{rel}:{ln}  WKWebView reintroduced: {src.strip()[:120]}")
    return formatted


# ---------------------------------------------------------------------------
# Self-test
# ---------------------------------------------------------------------------

_DANGER_FIXTURE = '''\
import SwiftUI
import WebKit                                  // 1

struct Bad: View {
    let v = WKWebView(frame: .zero, configuration: .init())   // 2
    var body: some View { Text("hi") }
}
'''

_CLEAN_FIXTURE = '''\
import SwiftUI
// WKWebView retired — see MM2.
/// The previous WKWebView surface dismantled wrong on Big Sur AMD.
struct Good: View {
    let warning = "WKWebView risk; do not reintroduce"
    var body: some View { Text("hi") }
}
'''


def selftest() -> int:
    import tempfile
    ok = True
    with tempfile.TemporaryDirectory() as d:
        bad = os.path.join(d, "Bad.swift")
        with open(bad, "w") as fh:
            fh.write(_DANGER_FIXTURE)
        b_errs = audit_file(bad)
        if len(b_errs) != 2:
            print(f"SELFTEST FAIL: danger fixture flagged {len(b_errs)}, expected 2")
            for ln, src in b_errs:
                print(f"  L{ln}: {src.strip()}")
            ok = False
        else:
            print(f"  [PASS] danger fixture flags {len(b_errs)} (expected 2)")

        good = os.path.join(d, "Good.swift")
        with open(good, "w") as fh:
            fh.write(_CLEAN_FIXTURE)
        g_errs = audit_file(good)
        if g_errs:
            print(f"SELFTEST FAIL: clean fixture flagged {len(g_errs)}, expected 0")
            for ln, src in g_errs:
                print(f"  L{ln}: {src.strip()}")
            ok = False
        else:
            print("  [PASS] clean fixture flags 0 hits (comments + strings excluded)")

    print("check_no_wkwebview --selftest: " +
          ("PASS — every fixture classifies correctly." if ok else "FAIL"))
    return 0 if ok else 1


def run_selftest() -> int:
    return selftest()


def main() -> int:
    if "--selftest" in sys.argv:
        return selftest()

    file_args = [a for a in sys.argv[1:] if not a.startswith("-")]
    if file_args:
        errors = audit_paths(file_args)
        if errors:
            print("check_no_wkwebview: FAIL (scoped)")
            for e in errors[:30]:
                print("  " + e)
            print("\n  WKWebView is permanently retired — see CRASH_LEDGER.md row C2.")
            print("  Use NativeArticleRepresentable for article HTML rendering.")
            return 1
        print(f"check_no_wkwebview: clean — {len(file_args)} staged file(s) checked.")
        return 0

    errors, files = audit_repo()
    if errors:
        print("check_no_wkwebview: FAIL")
        for e in errors[:30]:
            print("  " + e)
        if len(errors) > 30:
            print(f"  ... and {len(errors) - 30} more")
        print()
        print(f"  {len(errors)} WKWebView reintroduction(s) across {files} file(s).")
        print("  WKWebView is permanently retired — see CRASH_LEDGER.md row C2.")
        print("  Use NativeArticleRepresentable for article HTML rendering.")
        return 1
    print(f"check_no_wkwebview: clean — scanned {files} Swift file(s); WKWebView stays retired.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
